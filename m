Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2FKNdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab2FKNdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:33:52 -0400
Subject: Re: [PATCH] Add seq_vprintf and use in gfs2 (was Re: GFS2: Cache
 last hash bucket for glock seq_files)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <1339413164.6001.2046.camel@edumazet-glaptop>
References: <1339152726.2752.3.camel@menhir>
	 <1339230731.6001.159.camel@edumazet-glaptop>
	 <1339403377.2734.7.camel@menhir>
	 <1339404517.6001.1767.camel@edumazet-glaptop>
	 <1339410072.2734.17.camel@menhir>
	 <1339413164.6001.2046.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Jun 2012 14:32:42 +0100
Message-ID: <1339421562.2734.32.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2012-06-11 at 13:12 +0200, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 11:21 +0100, Steven Whitehouse wrote:
> 
> > Thats true, but are there any arches with a 64k page size? In any case
> > I'll follow up with another patch for that rather than try to combine it
> > with this one...
> 
> Some arches have page size from 16K to 1MB in size
> 
> sh, frv, hexagon, tile, ia64, mips, microblaze, sparc64, ppc64...
> 
> 
> 
I can't imagine running GFS2 on many of those, sparc64 and/or ppc64
maybe, but rather unlikely on the others. Nevertheless, here is a patch
to ensure that we don't land up allocating too much memory. No
performance impact on x86_64 since the buffer size hasn't changed in
that case.

Hopefully this should be the last bit for this set of patches. Many
thanks for taking the time to look at this - things should be much
improved from my initial idea and I think that our QE and support teams
will be happy with the result,

Steve.


>From 0fe2f1e929ecabf834f4af2ffd300fe70700f4b3 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 11 Jun 2012 13:49:47 +0100
Subject: [PATCH] GFS2: Size seq_file buffer more carefully

This places a limit on the buffer size for archs with larger
PAGE_SIZE.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4d5d63d..1ed81f4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1977,6 +1977,8 @@ static const struct seq_operations gfs2_sbstats_seq_ops = {
 	.show  = gfs2_sbstats_seq_show,
 };
 
+#define GFS2_SEQ_GOODSIZE min(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER, 65536UL)
+
 static int gfs2_glocks_open(struct inode *inode, struct file *file)
 {
 	int ret = seq_open_private(file, &gfs2_glock_seq_ops,
@@ -1985,9 +1987,9 @@ static int gfs2_glocks_open(struct inode *inode, struct file *file)
 		struct seq_file *seq = file->private_data;
 		struct gfs2_glock_iter *gi = seq->private;
 		gi->sdp = inode->i_private;
-		seq->buf = kmalloc(8*PAGE_SIZE, GFP_KERNEL | __GFP_NOWARN);
+		seq->buf = kmalloc(GFS2_SEQ_GOODSIZE, GFP_KERNEL | __GFP_NOWARN);
 		if (seq->buf)
-			seq->size = 8*PAGE_SIZE;
+			seq->size = GFS2_SEQ_GOODSIZE;
 	}
 	return ret;
 }
@@ -2000,9 +2002,9 @@ static int gfs2_glstats_open(struct inode *inode, struct file *file)
 		struct seq_file *seq = file->private_data;
 		struct gfs2_glock_iter *gi = seq->private;
 		gi->sdp = inode->i_private;
-		seq->buf = kmalloc(8*PAGE_SIZE, GFP_KERNEL | __GFP_NOWARN);
+		seq->buf = kmalloc(GFS2_SEQ_GOODSIZE, GFP_KERNEL | __GFP_NOWARN);
 		if (seq->buf)
-			seq->size = 8*PAGE_SIZE;
+			seq->size = GFS2_SEQ_GOODSIZE;
 	}
 	return ret;
 }
-- 
1.7.4




