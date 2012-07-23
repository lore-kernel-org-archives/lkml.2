Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2GWI2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab2GWI0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:24 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/16] GFS2: Size seq_file buffer more carefully
Date: Mon, 23 Jul 2012 09:01:00 +0100
Message-Id: <1343030466-3053-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

