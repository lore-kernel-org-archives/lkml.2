Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0DQSk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:40:28 -0400
Received: from lazybastard.de ([212.112.238.170]:38715 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0DQSk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:40:26 -0400
Date: Sat, 17 Apr 2010 20:40:16 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] [MTD] Fix JFFS2 sync silent failure
Message-ID: <20100417184016.GA17345@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin David,

if I read the code correctly, JFFS2 will happily perform a NOP on
sys_sync() again.  And this time it appears to be Jens' fault.

JFFS2 does not appear to set s_bdi anywhere.  And as of 32a88aa1,
__sync_filesystem() will return 0 if s_bdi is not set.  As a result,
sync_fs() is never called for jffs2 and whatever remains in the wbuf
will not make it to the device.

The patch also adds a BUG_ON to catch this problem in any remaining or
future offenders.  I am not sure about network filesystems, but at
least bdev- and mtd-based ones should be caught.

Opinions?

Jörn

-- 
No art, however minor, demands less than total dedication if you want
to excel in it.
-- Leon Battista Alberti

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index af8b42e..7c00319 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -13,6 +13,7 @@
 #include <linux/mtd/super.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 
 /*
  * compare superblocks to see if they're equivalent
@@ -44,6 +45,7 @@ static int get_sb_mtd_set(struct super_block *sb, void *_mtd)
 
 	sb->s_mtd = mtd;
 	sb->s_dev = MKDEV(MTD_BLOCK_MAJOR, mtd->index);
+	sb->s_bdi = mtd->backing_dev_info;
 	return 0;
 }
 
diff --git a/fs/super.c b/fs/super.c
index f35ac60..e8af253 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -954,10 +954,12 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	if (error < 0)
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
+	BUG_ON(!mnt->mnt_sb->s_bdi &&
+			(mnt->mnt_sb->s_bdev || mnt->mnt_sb->s_mtd));
 
- 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
- 	if (error)
- 		goto out_sb;
+	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
+	if (error)
+		goto out_sb;
 
 	/*
 	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
