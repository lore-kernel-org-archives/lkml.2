Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab0GSLRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:17:08 -0400
Received: from norkia.v3.sk ([91.210.183.14]:54006 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583Ab0GSLRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:17:01 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lubomir Rintel <lkundrak@v3.sk>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] [fs/sysv] V7: Adjust sanity checks for some volumes
Date: Mon, 19 Jul 2010 19:16:41 +0200
Message-Id: <1279559802-19154-3-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
References: <1279559802-19154-1-git-send-email-lkundrak@v3.sk>
 <1279559802-19154-2-git-send-email-lkundrak@v3.sk>
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
 fs/sysv/super.c         |    8 +++++---
 include/linux/sysv_fs.h |   11 +++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index bd8d141..17ac83d 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -470,8 +470,8 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	v7sb = (struct v7_super_block *) bh->b_data;
 	if (fs16_to_cpu(sbi, v7sb->s_nfree) > V7_NICFREE ||
 	    fs16_to_cpu(sbi, v7sb->s_ninode) > V7_NICINOD ||
-	    fs32_to_cpu(sbi, v7sb->s_time) == 0)
-		goto failed;
+	    fs32_to_cpu(sbi, v7sb->s_fsize) > V7_MAXSIZE)
+		return 0;
 
 	/* plausibility check on root inode: it is a directory,
 	   with a nonzero size that is a multiple of 16 */
@@ -480,7 +480,9 @@ static int v7_fill_super(struct super_block *sb, void *data, int silent)
 	v7i = (struct sysv_inode *)(bh2->b_data + 64);
 	if ((fs16_to_cpu(sbi, v7i->i_mode) & ~0777) != S_IFDIR ||
 	    (fs32_to_cpu(sbi, v7i->i_size) == 0) ||
-	    (fs32_to_cpu(sbi, v7i->i_size) & 017) != 0)
+	    (fs32_to_cpu(sbi, v7i->i_size) & 017)
+	    (fs32_to_cpu(sbi, v7i->i_size) > V7_NFILES *
+	     sizeof (struct sysv_dir_entry))) {
 		goto failed;
 	brelse(bh2);
 	bh2 = NULL;
diff --git a/include/linux/sysv_fs.h b/include/linux/sysv_fs.h
index 9641130..0a7a232 100644
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
+/* Indirect blocks hold just three-byte addresses, therefore if see a file
+ * system whose length has the most significant byte non-zero something is
+ * most likely wrong (not a filesystem, bad bytesex). */
+#define V7_MAXSIZE	0x00ffffff
 
 /* Coherent super-block data on disk */
 #define COH_NICINOD	100	/* number of inode cache entries */
-- 
1.6.5.2

