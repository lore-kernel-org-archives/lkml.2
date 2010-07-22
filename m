Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0GVBMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:12:44 -0400
Received: from norkia.v3.sk ([91.210.183.14]:39326 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0GVBMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:12:43 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lubomir Rintel <lkundrak@v3.sk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] V7: Adjust sanity checks for some volumes
Date: Thu, 22 Jul 2010 03:11:48 +0200
Message-Id: <1279761108-302-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279621893.18203.12.camel@localhost.localdomain>
References: <1279621893.18203.12.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly mkfs-ed filesystems from Seventh Edition have last modification
time set to zero, but are otherwise perfectly valid.

Also, tighten up other sanity checks to filter out most filesystems with
different bytesex than we're using.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 fs/sysv/super.c         |    6 ++++--
 include/linux/sysv_fs.h |   11 +++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index bd8d141..ac7b008 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -470,7 +470,7 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	v7sb = (struct v7_super_block *) bh->b_data;
 	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
 	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
-	    fs32_to_cpu(sbi, v7sb->s_time) == 0)
+	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
 		goto failed;
 
 	/* plausibility check on root inode: it is a directory,
@@ -480,7 +480,9 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	v7i = (struct sysv_inode *)(bh2->b_data + 64);
 	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
 	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
-	    (fs32_to_cpu(sbi, v7i->i_size) & 017) != 0)
+	    (fs32_to_cpu(sbi, v7i->i_size) & 017) ||
+	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
+	     sizeof (struct sysv_dir_entry)))
 		goto failed;
 	brelse(bh2);
 	bh2 = NULL;
diff --git a/include/linux/sysv_fs.h b/include/linux/sysv_fs.h
index 9641130..e47d6d9 100644
--- a/include/linux/sysv_fs.h
+++ b/include/linux/sysv_fs.h
@@ -148,6 +148,17 @@ struct v7_super_block {
 	char    s_fname[6];     /* file system name */
 	char    s_fpack[6];     /* file system pack name */
 };
+/* Constants to aid sanity checking */
+/* This is not a hard limit, nor enforced by v7 kernel. It's actually just
+ * the limit used by Seventh Edition's ls, though is high enough to assume
+ * that no reasonable file system would have that much entries in root
+ * directory. Thus, if we see anything higher, we just probably got the
+ * endiannes wrong. */
+#define V7_NFILES	1024
+/* The disk addresses are three-byte (despite direct block addresses being
+ * aligned word-wise in inode). If the most significant byte is non-zero,
+ * something is most likely wrong (not a filesystem, bad bytesex). */
+#define V7_MAXSIZE	0x00ffffff
 
 /* Coherent super-block data on disk */
 #define COH_NICINOD	100	/* number of inode cache entries */
-- 
1.7.1

