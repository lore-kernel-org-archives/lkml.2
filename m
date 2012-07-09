Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2GIOhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:37:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab2GIOho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:44 -0400
Message-Id: <20120709143116.809234556@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Dave Jones <davej@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tom Herbert <therbert@google.com>
Subject: [ 01/48] splice: fix racy pipe->buffers uses
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 047fe3605235888f3ebcda0c728cb31937eadfe6 upstream.

Dave Jones reported a kernel BUG at mm/slub.c:3474! triggered
by splice_shrink_spd() called from vmsplice_to_pipe()

commit 35f3d14dbbc5 (pipe: add support for shrinking and growing pipes)
added capability to adjust pipe->buffers.

Problem is some paths don't hold pipe mutex and assume pipe->buffers
doesn't change for their duration.

Fix this by adding nr_pages_max field in struct splice_pipe_desc, and
use it in place of pipe->buffers where appropriate.

splice_shrink_spd() loses its struct pipe_inode_info argument.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Tom Herbert <therbert@google.com>
Tested-by: Dave Jones <davej@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.2:
 - Adjust context in vmsplice_to_pipe()
 - Update one more call to splice_shrink_spd(), from skb_splice_bits()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/splice.c            |   35 ++++++++++++++++++++---------------
 include/linux/splice.h |    8 ++++----
 kernel/relay.c         |    5 +++--
 kernel/trace/trace.c   |    6 ++++--
 mm/shmem.c             |    3 ++-
 net/core/skbuff.c      |    1 +
 6 files changed, 34 insertions(+), 24 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -274,13 +274,16 @@ void spd_release_page(struct splice_pipe
  * Check if we need to grow the arrays holding pages and partial page
  * descriptions.
  */
-int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
+int splice_grow_spd(const struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
 {
-	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+	unsigned int buffers = ACCESS_ONCE(pipe->buffers);
+
+	spd->nr_pages_max = buffers;
+	if (buffers <= PIPE_DEF_BUFFERS)
 		return 0;
 
-	spd->pages = kmalloc(pipe->buffers * sizeof(struct page *), GFP_KERNEL);
-	spd->partial = kmalloc(pipe->buffers * sizeof(struct partial_page), GFP_KERNEL);
+	spd->pages = kmalloc(buffers * sizeof(struct page *), GFP_KERNEL);
+	spd->partial = kmalloc(buffers * sizeof(struct partial_page), GFP_KERNEL);
 
 	if (spd->pages && spd->partial)
 		return 0;
@@ -290,10 +293,9 @@ int splice_grow_spd(struct pipe_inode_in
 	return -ENOMEM;
 }
 
-void splice_shrink_spd(struct pipe_inode_info *pipe,
-		       struct splice_pipe_desc *spd)
+void splice_shrink_spd(struct splice_pipe_desc *spd)
 {
-	if (pipe->buffers <= PIPE_DEF_BUFFERS)
+	if (spd->nr_pages_max <= PIPE_DEF_BUFFERS)
 		return;
 
 	kfree(spd->pages);
@@ -316,6 +318,7 @@ __generic_file_splice_read(struct file *
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &page_cache_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -327,7 +330,7 @@ __generic_file_splice_read(struct file *
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
 	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages = min(req_pages, pipe->buffers);
+	nr_pages = min(req_pages, spd.nr_pages_max);
 
 	/*
 	 * Lookup the (hopefully) full range of pages we need.
@@ -498,7 +501,7 @@ fill_it:
 	if (spd.nr_pages)
 		error = splice_to_pipe(pipe, &spd);
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return error;
 }
 
@@ -599,6 +602,7 @@ ssize_t default_file_splice_read(struct
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -609,8 +613,8 @@ ssize_t default_file_splice_read(struct
 
 	res = -ENOMEM;
 	vec = __vec;
-	if (pipe->buffers > PIPE_DEF_BUFFERS) {
-		vec = kmalloc(pipe->buffers * sizeof(struct iovec), GFP_KERNEL);
+	if (spd.nr_pages_max > PIPE_DEF_BUFFERS) {
+		vec = kmalloc(spd.nr_pages_max * sizeof(struct iovec), GFP_KERNEL);
 		if (!vec)
 			goto shrink_ret;
 	}
@@ -618,7 +622,7 @@ ssize_t default_file_splice_read(struct
 	offset = *ppos & ~PAGE_CACHE_MASK;
 	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-	for (i = 0; i < nr_pages && i < pipe->buffers && len; i++) {
+	for (i = 0; i < nr_pages && i < spd.nr_pages_max && len; i++) {
 		struct page *page;
 
 		page = alloc_page(GFP_USER);
@@ -666,7 +670,7 @@ ssize_t default_file_splice_read(struct
 shrink_ret:
 	if (vec != __vec)
 		kfree(vec);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return res;
 
 err:
@@ -1616,6 +1620,7 @@ static long vmsplice_to_pipe(struct file
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &user_page_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -1631,13 +1636,13 @@ static long vmsplice_to_pipe(struct file
 
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
 					    spd.partial, flags & SPLICE_F_GIFT,
-					    pipe->buffers);
+					    spd.nr_pages_max);
 	if (spd.nr_pages <= 0)
 		ret = spd.nr_pages;
 	else
 		ret = splice_to_pipe(pipe, &spd);
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 }
 
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -51,7 +51,8 @@ struct partial_page {
 struct splice_pipe_desc {
 	struct page **pages;		/* page map */
 	struct partial_page *partial;	/* pages[] may not be contig */
-	int nr_pages;			/* number of pages in map */
+	int nr_pages;			/* number of populated pages in map */
+	unsigned int nr_pages_max;	/* pages[] & partial[] arrays size */
 	unsigned int flags;		/* splice flags */
 	const struct pipe_buf_operations *ops;/* ops associated with output pipe */
 	void (*spd_release)(struct splice_pipe_desc *, unsigned int);
@@ -85,9 +86,8 @@ extern ssize_t splice_direct_to_actor(st
 /*
  * for dynamic pipe sizing
  */
-extern int splice_grow_spd(struct pipe_inode_info *, struct splice_pipe_desc *);
-extern void splice_shrink_spd(struct pipe_inode_info *,
-				struct splice_pipe_desc *);
+extern int splice_grow_spd(const struct pipe_inode_info *, struct splice_pipe_desc *);
+extern void splice_shrink_spd(struct splice_pipe_desc *);
 extern void spd_release_page(struct splice_pipe_desc *, unsigned int);
 
 extern const struct pipe_buf_operations page_cache_pipe_buf_ops;
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1235,6 +1235,7 @@ static ssize_t subbuf_splice_actor(struc
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.nr_pages = 0,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.partial = partial,
 		.flags = flags,
 		.ops = &relay_pipe_buf_ops,
@@ -1302,8 +1303,8 @@ static ssize_t subbuf_splice_actor(struc
                 ret += padding;
 
 out:
-	splice_shrink_spd(pipe, &spd);
-        return ret;
+	splice_shrink_spd(&spd);
+	return ret;
 }
 
 static ssize_t relay_file_splice_read(struct file *in,
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3456,6 +3456,7 @@ static ssize_t tracing_splice_read_pipe(
 		.pages		= pages_def,
 		.partial	= partial_def,
 		.nr_pages	= 0, /* This gets updated below. */
+		.nr_pages_max	= PIPE_DEF_BUFFERS,
 		.flags		= flags,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
@@ -3527,7 +3528,7 @@ static ssize_t tracing_splice_read_pipe(
 
 	ret = splice_to_pipe(pipe, &spd);
 out:
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 
 out_err:
@@ -4017,6 +4018,7 @@ tracing_buffers_splice_read(struct file
 	struct splice_pipe_desc spd = {
 		.pages		= pages_def,
 		.partial	= partial_def,
+		.nr_pages_max	= PIPE_DEF_BUFFERS,
 		.flags		= flags,
 		.ops		= &buffer_pipe_buf_ops,
 		.spd_release	= buffer_spd_release,
@@ -4104,7 +4106,7 @@ tracing_buffers_splice_read(struct file
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 out:
 	return ret;
 }
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1359,6 +1359,7 @@ static ssize_t shmem_file_splice_read(st
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &page_cache_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -1447,7 +1448,7 @@ static ssize_t shmem_file_splice_read(st
 	if (spd.nr_pages)
 		error = splice_to_pipe(pipe, &spd);
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 
 	if (error > 0) {
 		*ppos += error;
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1663,6 +1663,7 @@ int skb_splice_bits(struct sk_buff *skb,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
 		.ops = &sock_pipe_buf_ops,
 		.spd_release = sock_spd_release,
@@ -1709,7 +1710,7 @@ done:
 		lock_sock(sk);
 	}
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 }
 


