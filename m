Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0D0TbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:31:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46820 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab0D0TbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:31:06 -0400
Date: Tue, 27 Apr 2010 21:31:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/writeback bits for 2.6.34-rc
Message-ID: <20100427193102.GN27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the fixes for the file systems that were missing a bdi setup
and assignment for proper flushing. As a proof of concept, I also
"converted" btrfs to use the bdi_setup_and_register() helper since I use
that on the laptop.

Also included are two minor fixes for drbd, and a fix for a very
unlikely rq timeout condition.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Dan Carpenter (1):
      drbd: fix memory leak

Jens Axboe (11):
      bdi: add helper function for doing init and register of a bdi for a file system
      9p: add bdi backing to mount session
      afs: add bdi backing to mount session.
      cifs: add bdi backing to mount session
      coda: add bdi backing to mount session
      ecryptfs: add bdi backing to mount session
      exofs: add bdi backing to mount session
      ncpfs: add bdi backing to mount session
      smbfs: add bdi backing to mount session
      btrfs: convert to using bdi_setup_and_register()
      mtd: ensure that bdi entries are properly initialized and registered

Jörn Engel (3):
      Fix JFFS2 sync silent failure
      Catch filesystems lacking s_bdi
      Move mtd_bdi_*mappable to mtdcore.c

Philipp Reisner (1):
      drbd: Terminate a connection early if sending the protocol fails

Richard Kennedy (1):
      block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer

 block/blk-timeout.c                |   12 ++---
 drivers/block/drbd/drbd_main.c     |    1 +
 drivers/block/drbd/drbd_receiver.c |    3 +-
 drivers/mtd/Makefile               |    2 +-
 drivers/mtd/internal.h             |   17 --------
 drivers/mtd/mtdbdi.c               |   43 -------------------
 drivers/mtd/mtdcore.c              |   79 +++++++++++++++++++++++++++++++++--
 drivers/mtd/mtdsuper.c             |    2 +
 fs/9p/v9fs.c                       |   10 +++++
 fs/9p/v9fs.h                       |    2 +
 fs/9p/vfs_super.c                  |    1 +
 fs/afs/internal.h                  |    2 +
 fs/afs/super.c                     |    1 +
 fs/afs/volume.c                    |    7 +++
 fs/btrfs/disk-io.c                 |   12 +-----
 fs/cifs/cifs_fs_sb.h               |    3 +
 fs/cifs/cifsfs.c                   |   10 +++++
 fs/coda/inode.c                    |    8 ++++
 fs/ecryptfs/ecryptfs_kernel.h      |    2 +
 fs/ecryptfs/main.c                 |   10 ++++-
 fs/ecryptfs/super.c                |    1 +
 fs/exofs/exofs.h                   |    2 +
 fs/exofs/super.c                   |    8 ++++
 fs/ncpfs/inode.c                   |    8 ++++
 fs/smbfs/inode.c                   |    8 ++++
 fs/super.c                         |    8 ++-
 fs/sync.c                          |    3 +-
 include/linux/backing-dev.h        |    2 +
 include/linux/coda_psdev.h         |    2 +
 include/linux/ncp_fs_sb.h          |    2 +
 include/linux/smb_fs_sb.h          |    3 +
 mm/backing-dev.c                   |   34 +++++++++++++++
 32 files changed, 218 insertions(+), 90 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1ba7e0a..4f0c06c 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -109,6 +109,7 @@ void blk_rq_timed_out_timer(unsigned long data)
 	struct request_queue *q = (struct request_queue *) data;
 	unsigned long flags, next = 0;
 	struct request *rq, *tmp;
+	int next_set = 0;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -122,16 +123,13 @@ void blk_rq_timed_out_timer(unsigned long data)
 			if (blk_mark_rq_complete(rq))
 				continue;
 			blk_rq_timed_out(rq);
-		} else if (!next || time_after(next, rq->deadline))
+		} else if (!next_set || time_after(next, rq->deadline)) {
 			next = rq->deadline;
+			next_set = 1;
+		}
 	}
 
-	/*
-	 * next can never be 0 here with the list non-empty, since we always
-	 * bump ->deadline to 1 so we can detect if the timer was ever added
-	 * or not. See comment in blk_add_timer()
-	 */
-	if (next)
+	if (next_set)
 		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 67e0fc5..93d1f9b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1695,6 +1695,7 @@ int drbd_send_protocol(struct drbd_conf *mdev)
 			cf |= CF_DRY_RUN;
 		else {
 			dev_err(DEV, "--dry-run is not supported by peer");
+			kfree(p);
 			return 0;
 		}
 	}
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ed9f1de..3f096e7 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -899,7 +899,8 @@ retry:
 
 	drbd_thread_start(&mdev->asender);
 
-	drbd_send_protocol(mdev);
+	if (!drbd_send_protocol(mdev))
+		return -1;
 	drbd_send_sync_param(mdev, &mdev->sync_conf);
 	drbd_send_sizes(mdev, 0);
 	drbd_send_uuids(mdev);
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 82d1e4d..4521b1e 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -4,7 +4,7 @@
 
 # Core functionality.
 obj-$(CONFIG_MTD)		+= mtd.o
-mtd-y				:= mtdcore.o mtdsuper.o mtdbdi.o
+mtd-y				:= mtdcore.o mtdsuper.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 
 obj-$(CONFIG_MTD_CONCAT)	+= mtdconcat.o
diff --git a/drivers/mtd/internal.h b/drivers/mtd/internal.h
index c658fe7..e69de29 100644
--- a/drivers/mtd/internal.h
+++ b/drivers/mtd/internal.h
@@ -1,17 +0,0 @@
-/* Internal MTD definitions
- *
- * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-/*
- * mtdbdi.c
- */
-extern struct backing_dev_info mtd_bdi_unmappable;
-extern struct backing_dev_info mtd_bdi_ro_mappable;
-extern struct backing_dev_info mtd_bdi_rw_mappable;
diff --git a/drivers/mtd/mtdbdi.c b/drivers/mtd/mtdbdi.c
index 5ca5aed..e69de29 100644
--- a/drivers/mtd/mtdbdi.c
+++ b/drivers/mtd/mtdbdi.c
@@ -1,43 +0,0 @@
-/* MTD backing device capabilities
- *
- * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/backing-dev.h>
-#include <linux/mtd/mtd.h>
-#include "internal.h"
-
-/*
- * backing device capabilities for non-mappable devices (such as NAND flash)
- * - permits private mappings, copies are taken of the data
- */
-struct backing_dev_info mtd_bdi_unmappable = {
-	.capabilities	= BDI_CAP_MAP_COPY,
-};
-
-/*
- * backing device capabilities for R/O mappable devices (such as ROM)
- * - permits private mappings, copies are taken of the data
- * - permits non-writable shared mappings
- */
-struct backing_dev_info mtd_bdi_ro_mappable = {
-	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
-			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
-};
-
-/*
- * backing device capabilities for writable mappable devices (such as RAM)
- * - permits private mappings, copies are taken of the data
- * - permits non-writable shared mappings
- */
-struct backing_dev_info mtd_bdi_rw_mappable = {
-	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
-			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
-			   BDI_CAP_WRITE_MAP),
-};
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 5b38b17..b177e75 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -2,6 +2,9 @@
  * Core registration and callback routines for MTD
  * drivers and users.
  *
+ * bdi bits are:
+ * Copyright © 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
  */
 
 #include <linux/module.h>
@@ -16,11 +19,39 @@
 #include <linux/init.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/proc_fs.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
-#include "internal.h"
 
 #include "mtdcore.h"
+/*
+ * backing device capabilities for non-mappable devices (such as NAND flash)
+ * - permits private mappings, copies are taken of the data
+ */
+struct backing_dev_info mtd_bdi_unmappable = {
+	.capabilities	= BDI_CAP_MAP_COPY,
+};
+
+/*
+ * backing device capabilities for R/O mappable devices (such as ROM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_ro_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
+};
+
+/*
+ * backing device capabilities for writable mappable devices (such as RAM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_rw_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
+			   BDI_CAP_WRITE_MAP),
+};
 
 static int mtd_cls_suspend(struct device *dev, pm_message_t state);
 static int mtd_cls_resume(struct device *dev);
@@ -628,20 +659,55 @@ done:
 /*====================================================================*/
 /* Init code */
 
+static int __init mtd_bdi_init(struct backing_dev_info *bdi, const char *name)
+{
+	int ret;
+
+	ret = bdi_init(bdi);
+	if (!ret)
+		ret = bdi_register(bdi, NULL, name);
+
+	if (ret)
+		bdi_destroy(bdi);
+
+	return ret;
+}
+
 static int __init init_mtd(void)
 {
 	int ret;
+
 	ret = class_register(&mtd_class);
+	if (ret)
+		goto err_reg;
+
+	ret = mtd_bdi_init(&mtd_bdi_unmappable, "mtd-unmap");
+	if (ret)
+		goto err_bdi1;
+
+	ret = mtd_bdi_init(&mtd_bdi_ro_mappable, "mtd-romap");
+	if (ret)
+		goto err_bdi2;
+
+	ret = mtd_bdi_init(&mtd_bdi_rw_mappable, "mtd-rwmap");
+	if (ret)
+		goto err_bdi3;
 
-	if (ret) {
-		pr_err("Error registering mtd class: %d\n", ret);
-		return ret;
-	}
 #ifdef CONFIG_PROC_FS
 	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
 		proc_mtd->read_proc = mtd_read_proc;
 #endif /* CONFIG_PROC_FS */
 	return 0;
+
+err_bdi3:
+	bdi_destroy(&mtd_bdi_ro_mappable);
+err_bdi2:
+	bdi_destroy(&mtd_bdi_unmappable);
+err_bdi1:
+	class_unregister(&mtd_class);
+err_reg:
+	pr_err("Error registering mtd class or bdi: %d\n", ret);
+	return ret;
 }
 
 static void __exit cleanup_mtd(void)
@@ -651,6 +717,9 @@ static void __exit cleanup_mtd(void)
 		remove_proc_entry( "mtd", NULL);
 #endif /* CONFIG_PROC_FS */
 	class_unregister(&mtd_class);
+	bdi_destroy(&mtd_bdi_unmappable);
+	bdi_destroy(&mtd_bdi_ro_mappable);
+	bdi_destroy(&mtd_bdi_rw_mappable);
 }
 
 module_init(init_mtd);
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
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 5c5bc84..f8b86e9 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -238,6 +238,13 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	rc = bdi_setup_and_register(&v9ses->bdi, "9p", BDI_CAP_MAP_COPY);
+	if (rc) {
+		__putname(v9ses->aname);
+		__putname(v9ses->uname);
+		return ERR_PTR(rc);
+	}
+
 	spin_lock(&v9fs_sessionlist_lock);
 	list_add(&v9ses->slist, &v9fs_sessionlist);
 	spin_unlock(&v9fs_sessionlist_lock);
@@ -301,6 +308,7 @@ struct p9_fid *v9fs_session_init(struct v9fs_session_info *v9ses,
 	return fid;
 
 error:
+	bdi_destroy(&v9ses->bdi);
 	return ERR_PTR(retval);
 }
 
@@ -326,6 +334,8 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 	__putname(v9ses->uname);
 	__putname(v9ses->aname);
 
+	bdi_destroy(&v9ses->bdi);
+
 	spin_lock(&v9fs_sessionlist_lock);
 	list_del(&v9ses->slist);
 	spin_unlock(&v9fs_sessionlist_lock);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a0a8d3d..bec4d0b 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -20,6 +20,7 @@
  *  Boston, MA  02111-1301  USA
  *
  */
+#include <linux/backing-dev.h>
 
 /**
  * enum p9_session_flags - option flags for each 9P session
@@ -102,6 +103,7 @@ struct v9fs_session_info {
 	u32 uid;		/* if ACCESS_SINGLE, the uid that has access */
 	struct p9_client *clnt;	/* 9p client */
 	struct list_head slist; /* list of sessions registered with v9fs */
+	struct backing_dev_info bdi;
 };
 
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 491108b..806da5d 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -77,6 +77,7 @@ v9fs_fill_super(struct super_block *sb, struct v9fs_session_info *v9ses,
 	sb->s_blocksize = 1 << sb->s_blocksize_bits;
 	sb->s_magic = V9FS_MAGIC;
 	sb->s_op = &v9fs_super_ops;
+	sb->s_bdi = &v9ses->bdi;
 
 	sb->s_flags = flags | MS_ACTIVE | MS_SYNCHRONOUS | MS_DIRSYNC |
 	    MS_NOATIME;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index c54dad4..a10f258 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -19,6 +19,7 @@
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/fscache.h>
+#include <linux/backing-dev.h>
 
 #include "afs.h"
 #include "afs_vl.h"
@@ -313,6 +314,7 @@ struct afs_volume {
 	unsigned short		rjservers;	/* number of servers discarded due to -ENOMEDIUM */
 	struct afs_server	*servers[8];	/* servers on which volume resides (ordered) */
 	struct rw_semaphore	server_sem;	/* lock for accessing current server */
+	struct backing_dev_info	bdi;
 };
 
 /*
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 14f6431..e932e5a 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -311,6 +311,7 @@ static int afs_fill_super(struct super_block *sb, void *data)
 	sb->s_magic		= AFS_FS_MAGIC;
 	sb->s_op		= &afs_super_ops;
 	sb->s_fs_info		= as;
+	sb->s_bdi		= &as->volume->bdi;
 
 	/* allocate the root inode and dentry */
 	fid.vid		= as->volume->vid;
diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index a353e69..401eeb2 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -106,6 +106,10 @@ struct afs_volume *afs_volume_lookup(struct afs_mount_params *params)
 	volume->cell		= params->cell;
 	volume->vid		= vlocation->vldb.vid[params->type];
 
+	ret = bdi_setup_and_register(&volume->bdi, "afs", BDI_CAP_MAP_COPY);
+	if (ret)
+		goto error_bdi;
+
 	init_rwsem(&volume->server_sem);
 
 	/* look up all the applicable server records */
@@ -151,6 +155,8 @@ error:
 	return ERR_PTR(ret);
 
 error_discard:
+	bdi_destroy(&volume->bdi);
+error_bdi:
 	up_write(&params->cell->vl_sem);
 
 	for (loop = volume->nservers - 1; loop >= 0; loop--)
@@ -200,6 +206,7 @@ void afs_put_volume(struct afs_volume *volume)
 	for (loop = volume->nservers - 1; loop >= 0; loop--)
 		afs_put_server(volume->servers[loop]);
 
+	bdi_destroy(&volume->bdi);
 	kfree(volume);
 
 	_leave(" [destroyed]");
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e7b8f2c..feca041 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -44,8 +44,6 @@ static struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void free_fs_root(struct btrfs_root *root);
 
-static atomic_t btrfs_bdi_num = ATOMIC_INIT(0);
-
 /*
  * end_io_wq structs are used to do processing in task context when an IO is
  * complete.  This is used during reads to verify checksums, and it is used
@@ -1375,19 +1373,11 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 {
 	int err;
 
-	bdi->name = "btrfs";
 	bdi->capabilities = BDI_CAP_MAP_COPY;
-	err = bdi_init(bdi);
+	err = bdi_setup_and_register(bdi, "btrfs", BDI_CAP_MAP_COPY);
 	if (err)
 		return err;
 
-	err = bdi_register(bdi, NULL, "btrfs-%d",
-				atomic_inc_return(&btrfs_bdi_num));
-	if (err) {
-		bdi_destroy(bdi);
-		return err;
-	}
-
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
 	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
 	bdi->unplug_io_data	= info;
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 4797787..246a167 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -18,6 +18,8 @@
 #ifndef _CIFS_FS_SB_H
 #define _CIFS_FS_SB_H
 
+#include <linux/backing-dev.h>
+
 #define CIFS_MOUNT_NO_PERM      1 /* do not do client vfs_perm check */
 #define CIFS_MOUNT_SET_UID      2 /* set current's euid in create etc. */
 #define CIFS_MOUNT_SERVER_INUM  4 /* inode numbers from uniqueid from server  */
@@ -50,5 +52,6 @@ struct cifs_sb_info {
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	char   *mountdata; /* mount options received at mount time */
 #endif
+	struct backing_dev_info bdi;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index ded66be..ad235d6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -103,6 +103,12 @@ cifs_read_super(struct super_block *sb, void *data,
 	if (cifs_sb == NULL)
 		return -ENOMEM;
 
+	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
+	if (rc) {
+		kfree(cifs_sb);
+		return rc;
+	}
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/* copy mount params to sb for use in submounts */
 	/* BB: should we move this after the mount so we
@@ -115,6 +121,7 @@ cifs_read_super(struct super_block *sb, void *data,
 		int len = strlen(data);
 		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
 		if (cifs_sb->mountdata == NULL) {
+			bdi_destroy(&cifs_sb->bdi);
 			kfree(sb->s_fs_info);
 			sb->s_fs_info = NULL;
 			return -ENOMEM;
@@ -135,6 +142,7 @@ cifs_read_super(struct super_block *sb, void *data,
 
 	sb->s_magic = CIFS_MAGIC_NUMBER;
 	sb->s_op = &cifs_super_ops;
+	sb->s_bdi = &cifs_sb->bdi;
 /*	if (cifs_sb->tcon->ses->server->maxBuf > MAX_CIFS_HDR_SIZE + 512)
 	    sb->s_blocksize =
 		cifs_sb->tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE; */
@@ -183,6 +191,7 @@ out_mount_failed:
 		}
 #endif
 		unload_nls(cifs_sb->local_nls);
+		bdi_destroy(&cifs_sb->bdi);
 		kfree(cifs_sb);
 	}
 	return rc;
@@ -214,6 +223,7 @@ cifs_put_super(struct super_block *sb)
 #endif
 
 	unload_nls(cifs_sb->local_nls);
+	bdi_destroy(&cifs_sb->bdi);
 	kfree(cifs_sb);
 
 	unlock_kernel();
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index a1695dc..d97f993 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -167,6 +167,10 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 		return -EBUSY;
 	}
 
+	error = bdi_setup_and_register(&vc->bdi, "coda", BDI_CAP_MAP_COPY);
+	if (error)
+		goto bdi_err;
+
 	vc->vc_sb = sb;
 
 	sb->s_fs_info = vc;
@@ -175,6 +179,7 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_blocksize_bits = 12;
 	sb->s_magic = CODA_SUPER_MAGIC;
 	sb->s_op = &coda_super_operations;
+	sb->s_bdi = &vc->bdi;
 
 	/* get root fid from Venus: this needs the root inode */
 	error = venus_rootfid(sb, &fid);
@@ -200,6 +205,8 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
         return 0;
 
  error:
+	bdi_destroy(&vc->bdi);
+ bdi_err:
 	if (root)
 		iput(root);
 	if (vc)
@@ -210,6 +217,7 @@ static int coda_fill_super(struct super_block *sb, void *data, int silent)
 
 static void coda_put_super(struct super_block *sb)
 {
+	bdi_destroy(&coda_vcp(sb)->bdi);
 	coda_vcp(sb)->vc_sb = NULL;
 	sb->s_fs_info = NULL;
 
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index bc71154..bfc2e0f 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -35,6 +35,7 @@
 #include <linux/scatterlist.h>
 #include <linux/hash.h>
 #include <linux/nsproxy.h>
+#include <linux/backing-dev.h>
 
 /* Version verification for shared data structures w/ userspace */
 #define ECRYPTFS_VERSION_MAJOR 0x00
@@ -393,6 +394,7 @@ struct ecryptfs_mount_crypt_stat {
 struct ecryptfs_sb_info {
 	struct super_block *wsi_sb;
 	struct ecryptfs_mount_crypt_stat mount_crypt_stat;
+	struct backing_dev_info bdi;
 };
 
 /* file private data. */
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index af1a8f0..760983d 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -497,17 +497,25 @@ struct kmem_cache *ecryptfs_sb_info_cache;
 static int
 ecryptfs_fill_super(struct super_block *sb, void *raw_data, int silent)
 {
+	struct ecryptfs_sb_info *esi;
 	int rc = 0;
 
 	/* Released in ecryptfs_put_super() */
 	ecryptfs_set_superblock_private(sb,
 					kmem_cache_zalloc(ecryptfs_sb_info_cache,
 							 GFP_KERNEL));
-	if (!ecryptfs_superblock_to_private(sb)) {
+	esi = ecryptfs_superblock_to_private(sb);
+	if (!esi) {
 		ecryptfs_printk(KERN_WARNING, "Out of memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
+
+	rc = bdi_setup_and_register(&esi->bdi, "ecryptfs", BDI_CAP_MAP_COPY);
+	if (rc)
+		goto out;
+
+	sb->s_bdi = &esi->bdi;
 	sb->s_op = &ecryptfs_sops;
 	/* Released through deactivate_super(sb) from get_sb_nodev */
 	sb->s_root = d_alloc(NULL, &(const struct qstr) {
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 278743c..0c0ae49 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -122,6 +122,7 @@ static void ecryptfs_put_super(struct super_block *sb)
 	lock_kernel();
 
 	ecryptfs_destroy_mount_crypt_stat(&sb_info->mount_crypt_stat);
+	bdi_destroy(&sb_info->bdi);
 	kmem_cache_free(ecryptfs_sb_info_cache, sb_info);
 	ecryptfs_set_superblock_private(sb, NULL);
 
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 8442e35..5437327 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -35,6 +35,7 @@
 
 #include <linux/fs.h>
 #include <linux/time.h>
+#include <linux/backing-dev.h>
 #include "common.h"
 
 /* FIXME: Remove once pnfs hits mainline
@@ -92,6 +93,7 @@ struct exofs_sb_info {
 	struct exofs_layout	layout;		/* Default files layout,
 						 * contains the variable osd_dev
 						 * array. Keep last */
+	struct backing_dev_info bdi;
 	struct osd_dev	*_min_one_dev[1];	/* Place holder for one dev   */
 };
 
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 18e57ea..03149b9 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -302,6 +302,7 @@ static void exofs_put_super(struct super_block *sb)
 	_exofs_print_device("Unmounting", NULL, sbi->layout.s_ods[0],
 			    sbi->layout.s_pid);
 
+	bdi_destroy(&sbi->bdi);
 	exofs_free_sbi(sbi);
 	sb->s_fs_info = NULL;
 }
@@ -546,6 +547,10 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!sbi)
 		return -ENOMEM;
 
+	ret = bdi_setup_and_register(&sbi->bdi, "exofs", BDI_CAP_MAP_COPY);
+	if (ret)
+		goto free_bdi;
+
 	/* use mount options to fill superblock */
 	od = osduld_path_lookup(opts->dev_name);
 	if (IS_ERR(od)) {
@@ -612,6 +617,7 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* set up operation vectors */
+	sb->s_bdi = &sbi->bdi;
 	sb->s_fs_info = sbi;
 	sb->s_op = &exofs_sops;
 	sb->s_export_op = &exofs_export_ops;
@@ -643,6 +649,8 @@ static int exofs_fill_super(struct super_block *sb, void *data, int silent)
 	return 0;
 
 free_sbi:
+	bdi_destroy(&sbi->bdi);
+free_bdi:
 	EXOFS_ERR("Unable to mount exofs on %s pid=0x%llx err=%d\n",
 		  opts->dev_name, sbi->layout.s_pid, ret);
 	exofs_free_sbi(sbi);
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index cf98da1..fa33851 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -526,10 +526,15 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	sb->s_blocksize_bits = 10;
 	sb->s_magic = NCP_SUPER_MAGIC;
 	sb->s_op = &ncp_sops;
+	sb->s_bdi = &server->bdi;
 
 	server = NCP_SBP(sb);
 	memset(server, 0, sizeof(*server));
 
+	error = bdi_setup_and_register(&server->bdi, "ncpfs", BDI_CAP_MAP_COPY);
+	if (error)
+		goto out_bdi;
+
 	server->ncp_filp = ncp_filp;
 	server->ncp_sock = sock;
 	
@@ -719,6 +724,8 @@ out_fput2:
 	if (server->info_filp)
 		fput(server->info_filp);
 out_fput:
+	bdi_destroy(&server->bdi);
+out_bdi:
 	/* 23/12/1998 Marcin Dalecki <dalecki@cs.net.pl>:
 	 * 
 	 * The previously used put_filp(ncp_filp); was bogous, since
@@ -756,6 +763,7 @@ static void ncp_put_super(struct super_block *sb)
 	kill_pid(server->m.wdog_pid, SIGTERM, 1);
 	put_pid(server->m.wdog_pid);
 
+	bdi_destroy(&server->bdi);
 	kfree(server->priv.data);
 	kfree(server->auth.object_name);
 	vfree(server->rxbuf);
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index 1c4c8f0..dfa1d67 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -479,6 +479,7 @@ smb_put_super(struct super_block *sb)
 	if (server->conn_pid)
 		kill_pid(server->conn_pid, SIGTERM, 1);
 
+	bdi_destroy(&server->bdi);
 	kfree(server->ops);
 	smb_unload_nls(server);
 	sb->s_fs_info = NULL;
@@ -525,6 +526,11 @@ static int smb_fill_super(struct super_block *sb, void *raw_data, int silent)
 	if (!server)
 		goto out_no_server;
 	sb->s_fs_info = server;
+	
+	if (bdi_setup_and_register(&server->bdi, "smbfs", BDI_CAP_MAP_COPY))
+		goto out_bdi;
+
+	sb->s_bdi = &server->bdi;
 
 	server->super_block = sb;
 	server->mnt = NULL;
@@ -624,6 +630,8 @@ out_no_smbiod:
 out_bad_option:
 	kfree(mem);
 out_no_mem:
+	bdi_destroy(&server->bdi);
+out_bdi:
 	if (!server->mnt)
 		printk(KERN_ERR "smb_fill_super: allocation failure\n");
 	sb->s_fs_info = NULL;
diff --git a/fs/super.c b/fs/super.c
index f35ac60..dc72491 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -693,6 +693,7 @@ int set_anon_super(struct super_block *s, void *data)
 		return -EMFILE;
 	}
 	s->s_dev = MKDEV(0, dev & MINORMASK);
+	s->s_bdi = &noop_backing_dev_info;
 	return 0;
 }
 
@@ -954,10 +955,11 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	if (error < 0)
 		goto out_free_secdata;
 	BUG_ON(!mnt->mnt_sb);
+	WARN_ON(!mnt->mnt_sb->s_bdi);
 
- 	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
- 	if (error)
- 		goto out_sb;
+	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
+	if (error)
+		goto out_sb;
 
 	/*
 	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
diff --git a/fs/sync.c b/fs/sync.c
index fc5c3d7..92b2281 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/backing-dev.h>
 #include "internal.h"
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
@@ -32,7 +33,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 	 * This should be safe, as we require bdi backing to actually
 	 * write out data in the first place
 	 */
-	if (!sb->s_bdi)
+	if (!sb->s_bdi || sb->s_bdi == &noop_backing_dev_info)
 		return 0;
 
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index fcbc26a..bd0e3c6 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -101,6 +101,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
+int bdi_setup_and_register(struct backing_dev_info *, char *, unsigned int);
 void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 				long nr_pages);
 int bdi_writeback_task(struct bdi_writeback *wb);
@@ -246,6 +247,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #endif
 
 extern struct backing_dev_info default_backing_dev_info;
+extern struct backing_dev_info noop_backing_dev_info;
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
 int writeback_in_progress(struct backing_dev_info *bdi);
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 5b5d473..644062e 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -1,6 +1,7 @@
 #ifndef __CODA_PSDEV_H
 #define __CODA_PSDEV_H
 
+#include <linux/backing-dev.h>
 #include <linux/magic.h>
 
 #define CODA_PSDEV_MAJOR 67
@@ -17,6 +18,7 @@ struct venus_comm {
 	struct list_head    vc_processing;
 	int                 vc_inuse;
 	struct super_block *vc_sb;
+	struct backing_dev_info bdi;
 };
 
 
diff --git a/include/linux/ncp_fs_sb.h b/include/linux/ncp_fs_sb.h
index 6330fc7..5ec9ca6 100644
--- a/include/linux/ncp_fs_sb.h
+++ b/include/linux/ncp_fs_sb.h
@@ -12,6 +12,7 @@
 #include <linux/ncp_mount.h>
 #include <linux/net.h>
 #include <linux/mutex.h>
+#include <linux/backing-dev.h>
 
 #ifdef __KERNEL__
 
@@ -127,6 +128,7 @@ struct ncp_server {
 		size_t len;
 		__u8 data[128];
 	} unexpected_packet;
+	struct backing_dev_info bdi;
 };
 
 extern void ncp_tcp_rcv_proc(struct work_struct *work);
diff --git a/include/linux/smb_fs_sb.h b/include/linux/smb_fs_sb.h
index 8a060a7..bb947dd 100644
--- a/include/linux/smb_fs_sb.h
+++ b/include/linux/smb_fs_sb.h
@@ -10,6 +10,7 @@
 #define _SMB_FS_SB
 
 #include <linux/types.h>
+#include <linux/backing-dev.h>
 #include <linux/smb.h>
 
 /*
@@ -74,6 +75,8 @@ struct smb_sb_info {
 	struct smb_ops *ops;
 
 	struct super_block *super_block;
+
+	struct backing_dev_info bdi;
 };
 
 static inline int
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f13e067..707d0dc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -11,6 +11,8 @@
 #include <linux/writeback.h>
 #include <linux/device.h>
 
+static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
+
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
 }
@@ -25,6 +27,11 @@ struct backing_dev_info default_backing_dev_info = {
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
+struct backing_dev_info noop_backing_dev_info = {
+	.name		= "noop",
+};
+EXPORT_SYMBOL_GPL(noop_backing_dev_info);
+
 static struct class *bdi_class;
 
 /*
@@ -715,6 +722,33 @@ void bdi_destroy(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(bdi_destroy);
 
+/*
+ * For use from filesystems to quickly init and register a bdi associated
+ * with dirty writeback
+ */
+int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
+			   unsigned int cap)
+{
+	char tmp[32];
+	int err;
+
+	bdi->name = name;
+	bdi->capabilities = cap;
+	err = bdi_init(bdi);
+	if (err)
+		return err;
+
+	sprintf(tmp, "%.28s%s", name, "-%d");
+	err = bdi_register(bdi, NULL, tmp, atomic_long_inc_return(&bdi_seq));
+	if (err) {
+		bdi_destroy(bdi);
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bdi_setup_and_register);
+
 static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])

-- 
Jens Axboe

