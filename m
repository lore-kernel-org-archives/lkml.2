Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0JUNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:49:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab0JUNt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:49:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>
Subject: [PATCH 1/2] BKL: remove BKL from qnx4
Date: Thu, 21 Oct 2010 15:50:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <201009161632.59210.arnd@arndb.de> <20101021124743.GC17654@infradead.org> <201010211538.24733.arnd@arndb.de>
In-Reply-To: <201010211538.24733.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211550.34289.arnd@arndb.de>
X-Provags-ID: V02:K0:Zi9YDOZadIDPdhHbc61Fb3T5KzU2Iyfg3zC+UZxh++s
 BKtWR8h0JSJh/hggls+Ne17uC/JEGmu8miMgGHvmxVke1x1bsi
 9xFXO9bFqn23hcek04FT6xLmgB2rjVFWLhYXzUPeJXA6BcqNRn
 HU7n0UZz56S82YytwHnMJ+CxPiuTTZSRsheGACYmywjnlngyTA
 ynRTUunDhtTWsk4rhsoVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All uses of the BKL in qnx4 were the result of a pushdown into
code that doesn't really need it. As Christoph points out, this
is a read-only file system, which eliminates most of the races in
readdir/lookup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anders Larsen <al@alarsen.net>
Cc: Christoph Hellwig <hch@infradead.org>
---
 fs/qnx4/dir.c   |    3 ---
 fs/qnx4/inode.c |   14 +-------------
 fs/qnx4/namei.c |    4 ----
 3 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index 6e8fc62..06de116 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -11,7 +11,6 @@
  * 20-06-1998 by Frank Denis : Linux 2.1.99+ & dcache support.
  */
 
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include "qnx4.h"
 
@@ -29,8 +28,6 @@ static int qnx4_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	QNX4DEBUG((KERN_INFO "qnx4_readdir:i_size = %ld\n", (long) inode->i_size));
 	QNX4DEBUG((KERN_INFO "filp->f_pos         = %ld\n", (long) filp->f_pos));
 
-	lock_kernel();
-
 	while (filp->f_pos < inode->i_size) {
 		blknum = qnx4_block_map( inode, filp->f_pos >> QNX4_BLOCK_SIZE_BITS );
 		bh = sb_bread(inode->i_sb, blknum);
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 86a7be1..01bad30 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/highuid.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
@@ -157,8 +156,6 @@ static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct super_block *sb = dentry->d_sb;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
-	lock_kernel();
-
 	buf->f_type    = sb->s_magic;
 	buf->f_bsize   = sb->s_blocksize;
 	buf->f_blocks  = le32_to_cpu(qnx4_sb(sb)->BitMap->di_size) * 8;
@@ -168,8 +165,6 @@ static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
 
-	unlock_kernel();
-
 	return 0;
 }
 
@@ -234,13 +229,9 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 	struct qnx4_sb_info *qs;
 	int ret = -EINVAL;
 
-	lock_kernel();
-
 	qs = kzalloc(sizeof(struct qnx4_sb_info), GFP_KERNEL);
-	if (!qs) {
-		unlock_kernel();
+	if (!qs)
 		return -ENOMEM;
-	}
 	s->s_fs_info = qs;
 
 	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
@@ -287,8 +278,6 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
  		goto outi;
 
 	brelse(bh);
-
-	unlock_kernel();
 	return 0;
 
       outi:
@@ -298,7 +287,6 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
       outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
-	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index 58703eb..275327b 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -12,7 +12,6 @@
  * 04-07-1998 by Frank Denis : first step for rmdir/unlink.
  */
 
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include "qnx4.h"
 
@@ -109,7 +108,6 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	int len = dentry->d_name.len;
 	struct inode *foundinode = NULL;
 
-	lock_kernel();
 	if (!(bh = qnx4_find_entry(len, dir, name, &de, &ino)))
 		goto out;
 	/* The entry is linked, let's get the real info */
@@ -123,13 +121,11 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
 
 	foundinode = qnx4_iget(dir->i_sb, ino);
 	if (IS_ERR(foundinode)) {
-		unlock_kernel();
 		QNX4DEBUG((KERN_ERR "qnx4: lookup->iget -> error %ld\n",
 			   PTR_ERR(foundinode)));
 		return ERR_CAST(foundinode);
 	}
 out:
-	unlock_kernel();
 	d_add(dentry, foundinode);
 
 	return NULL;
-- 
1.7.1

