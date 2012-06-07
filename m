Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab2FGKhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:37:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47668 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab2FGKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:37:03 -0400
Subject: [PATCH] splice: fix racy pipe->buffers uses
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
        Tom Herbert <therbert@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1339043263.26966.79.camel@edumazet-glaptop>
References: <20120607025117.GA28261@redhat.com>
	 <1339043263.26966.79.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 12:36:57 +0200
Message-ID: <1339065417.26966.133.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

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
Cc: stable <stable@vger.kernel.org> # 2.6.35
---
 fs/splice.c            |   35 ++++++++++++++++++++---------------
 include/linux/splice.h |    8 ++++----
 kernel/relay.c         |    5 +++--
 kernel/trace/trace.c   |    6 ++++--
 mm/shmem.c             |    3 ++-
 net/core/skbuff.c      |    1 +
 6 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index c9f1318..7bf08fa 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -273,13 +273,16 @@ void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
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
@@ -289,10 +292,9 @@ int splice_grow_spd(struct pipe_inode_info *pipe, struct splice_pipe_desc *spd)
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
@@ -315,6 +317,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &page_cache_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -326,7 +329,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	loff = *ppos & ~PAGE_CACHE_MASK;
 	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	nr_pages = min(req_pages, pipe->buffers);
+	nr_pages = min(req_pages, spd.nr_pages_max);
 
 	/*
 	 * Lookup the (hopefully) full range of pages we need.
@@ -497,7 +500,7 @@ fill_it:
 	if (spd.nr_pages)
 		error = splice_to_pipe(pipe, &spd);
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return error;
 }
 
@@ -598,6 +601,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -608,8 +612,8 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 
 	res = -ENOMEM;
 	vec = __vec;
-	if (pipe->buffers > PIPE_DEF_BUFFERS) {
-		vec = kmalloc(pipe->buffers * sizeof(struct iovec), GFP_KERNEL);
+	if (spd.nr_pages_max > PIPE_DEF_BUFFERS) {
+		vec = kmalloc(spd.nr_pages_max * sizeof(struct iovec), GFP_KERNEL);
 		if (!vec)
 			goto shrink_ret;
 	}
@@ -617,7 +621,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 	offset = *ppos & ~PAGE_CACHE_MASK;
 	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-	for (i = 0; i < nr_pages && i < pipe->buffers && len; i++) {
+	for (i = 0; i < nr_pages && i < spd.nr_pages_max && len; i++) {
 		struct page *page;
 
 		page = alloc_page(GFP_USER);
@@ -665,7 +669,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
 shrink_ret:
 	if (vec != __vec)
 		kfree(vec);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return res;
 
 err:
@@ -1614,6 +1618,7 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &user_page_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -1629,13 +1634,13 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
 					    spd.partial, false,
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
 
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 26e5b61..09a545a 100644
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
@@ -85,9 +86,8 @@ extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
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
diff --git a/kernel/relay.c b/kernel/relay.c
index ab56a17..e8cd202 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1235,6 +1235,7 @@ static ssize_t subbuf_splice_actor(struct file *in,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.nr_pages = 0,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.partial = partial,
 		.flags = flags,
 		.ops = &relay_pipe_buf_ops,
@@ -1302,8 +1303,8 @@ static ssize_t subbuf_splice_actor(struct file *in,
                 ret += padding;
 
 out:
-	splice_shrink_spd(pipe, &spd);
-        return ret;
+	splice_shrink_spd(&spd);
+	return ret;
 }
 
 static ssize_t relay_file_splice_read(struct file *in,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 68032c6..2884880 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3609,6 +3609,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.pages		= pages_def,
 		.partial	= partial_def,
 		.nr_pages	= 0, /* This gets updated below. */
+		.nr_pages_max	= PIPE_DEF_BUFFERS,
 		.flags		= flags,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
@@ -3680,7 +3681,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	ret = splice_to_pipe(pipe, &spd);
 out:
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 	return ret;
 
 out_err:
@@ -4231,6 +4232,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	struct splice_pipe_desc spd = {
 		.pages		= pages_def,
 		.partial	= partial_def,
+		.nr_pages_max	= PIPE_DEF_BUFFERS,
 		.flags		= flags,
 		.ops		= &buffer_pipe_buf_ops,
 		.spd_release	= buffer_spd_release,
@@ -4318,7 +4320,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 out:
 	return ret;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 585bd220..c244e93 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1577,6 +1577,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = PIPE_DEF_BUFFERS,
 		.flags = flags,
 		.ops = &page_cache_pipe_buf_ops,
 		.spd_release = spd_release_page,
@@ -1665,7 +1666,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	if (spd.nr_pages)
 		error = splice_to_pipe(pipe, &spd);
 
-	splice_shrink_spd(pipe, &spd);
+	splice_shrink_spd(&spd);
 
 	if (error > 0) {
 		*ppos += error;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 016694d..bac3c57 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1755,6 +1755,7 @@ int skb_splice_bits(struct sk_buff *skb, unsigned int offset,
 	struct splice_pipe_desc spd = {
 		.pages = pages,
 		.partial = partial,
+		.nr_pages_max = MAX_SKB_FRAGS,
 		.flags = flags,
 		.ops = &sock_pipe_buf_ops,
 		.spd_release = sock_spd_release,


