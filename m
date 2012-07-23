Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2GWI3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2GWI0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 05/16] GFS2: Increase buffer size for glocks and glstats debugfs files
Date: Mon, 23 Jul 2012 09:00:55 +0100
Message-Id: <1343030466-3053-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
References: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Al Viro's suggestion, this increases the buffer size used
for these two files. This provides a speed up of slightly less than
8x (i.e. proportional to the buffer size) for cases when we have
large numbers of glocks.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index dab2526..1c4cddf 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1972,6 +1972,9 @@ static int gfs2_glocks_open(struct inode *inode, struct file *file)
 		struct seq_file *seq = file->private_data;
 		struct gfs2_glock_iter *gi = seq->private;
 		gi->sdp = inode->i_private;
+		seq->buf = kmalloc(8*PAGE_SIZE, GFP_KERNEL | __GFP_NOWARN);
+		if (seq->buf)
+			seq->size = 8*PAGE_SIZE;
 	}
 	return ret;
 }
@@ -1984,6 +1987,9 @@ static int gfs2_glstats_open(struct inode *inode, struct file *file)
 		struct seq_file *seq = file->private_data;
 		struct gfs2_glock_iter *gi = seq->private;
 		gi->sdp = inode->i_private;
+		seq->buf = kmalloc(8*PAGE_SIZE, GFP_KERNEL | __GFP_NOWARN);
+		if (seq->buf)
+			seq->size = 8*PAGE_SIZE;
 	}
 	return ret;
 }
-- 
1.7.4

