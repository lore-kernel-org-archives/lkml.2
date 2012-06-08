Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786Ab2FHFNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:13:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761325Ab2FHFHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:30 -0400
Message-Id: <20120608041851.096743193@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [ 76/82] target/file: Use O_DSYNC by default for FILEIO backends
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit a4dff3043c231d57f982af635c9d2192ee40e5ae upstream.

Convert to use O_DSYNC for all cases at FILEIO backend creation time to
avoid the extra syncing of pure timestamp updates with legacy O_SYNC during
default operation as recommended by hch.  Continue to do this independently of
Write Cache Enable (WCE) bit, as WCE=0 is currently the default for all backend
devices and enabled by user on per device basis via attrib/emulate_write_cache.

This patch drops the now unnecessary fd_buffered_io= token usage that was
originally signalling when to explictly disable O_SYNC at backend creation
time for buffered I/O operation.  This can end up being dangerous for a number
of reasons during physical node failure, so go ahead and drop this option
for now when O_DSYNC is used as the default.

Also allow explict FUA WRITEs -> vfs_fsync_range() call to function in
fd_execute_cmd() independently of WCE bit setting.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[bwh: Backported to 3.2:
 - We have fd_do_task() and not fd_execute_cmd()
 - Various fields are in struct se_task rather than struct se_cmd
 - fd_create_virtdevice() flags initialisation hasn't been cleaned up]
---
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -134,21 +134,11 @@
 		ret = PTR_ERR(dev_p);
 		goto fail;
 	}
-#if 0
-	if (di->no_create_file)
-		flags = O_RDWR | O_LARGEFILE;
-	else
-		flags = O_RDWR | O_CREAT | O_LARGEFILE;
-#else
-	flags = O_RDWR | O_CREAT | O_LARGEFILE;
-#endif
-/*	flags |= O_DIRECT; */
 	/*
-	 * If fd_buffered_io=1 has not been set explicitly (the default),
-	 * use O_SYNC to force FILEIO writes to disk.
+	 * Use O_DSYNC by default instead of O_SYNC to forgo syncing
+	 * of pure timestamp updates.
 	 */
-	if (!(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO))
-		flags |= O_SYNC;
+	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
 
 	file = filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
@@ -400,26 +390,6 @@
 		transport_complete_sync_cache(cmd, ret == 0);
 }
 
-/*
- * WRITE Force Unit Access (FUA) emulation on a per struct se_task
- * LBA range basis..
- */
-static void fd_emulate_write_fua(struct se_cmd *cmd, struct se_task *task)
-{
-	struct se_device *dev = cmd->se_dev;
-	struct fd_dev *fd_dev = dev->dev_ptr;
-	loff_t start = task->task_lba * dev->se_sub_dev->se_dev_attrib.block_size;
-	loff_t end = start + task->task_size;
-	int ret;
-
-	pr_debug("FILEIO: FUA WRITE LBA: %llu, bytes: %u\n",
-			task->task_lba, task->task_size);
-
-	ret = vfs_fsync_range(fd_dev->fd_file, start, end, 1);
-	if (ret != 0)
-		pr_err("FILEIO: vfs_fsync_range() failed: %d\n", ret);
-}
-
 static int fd_do_task(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
@@ -434,19 +404,21 @@
 		ret = fd_do_readv(task);
 	} else {
 		ret = fd_do_writev(task);
-
+		/*
+		 * Perform implict vfs_fsync_range() for fd_do_writev() ops
+		 * for SCSI WRITEs with Forced Unit Access (FUA) set.
+		 * Allow this to happen independent of WCE=0 setting.
+		 */
 		if (ret > 0 &&
-		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
 		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
 		    (cmd->se_cmd_flags & SCF_FUA)) {
-			/*
-			 * We might need to be a bit smarter here
-			 * and return some sense data to let the initiator
-			 * know the FUA WRITE cache sync failed..?
-			 */
-			fd_emulate_write_fua(cmd, task);
-		}
+			struct fd_dev *fd_dev = dev->dev_ptr;
+			loff_t start = task->task_lba *
+				dev->se_sub_dev->se_dev_attrib.block_size;
+			loff_t end = start + task->task_size;
 
+			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
+		}
 	}
 
 	if (ret < 0) {
@@ -478,7 +450,6 @@
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
-	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
@@ -490,7 +461,7 @@
 	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, arg, token;
+	int ret = 0, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -534,19 +505,6 @@
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
-		case Opt_fd_buffered_io:
-			match_int(args, &arg);
-			if (arg != 1) {
-				pr_err("bogus fd_buffered_io=%d value\n", arg);
-				ret = -EINVAL;
-				goto out;
-			}
-
-			pr_debug("FILEIO: Using buffered I/O"
-				" operations for struct fd_dev\n");
-
-			fd_dev->fbd_flags |= FDBD_USE_BUFFERED_IO;
-			break;
 		default:
 			break;
 		}
@@ -578,10 +536,8 @@
 	ssize_t bl = 0;
 
 	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
-		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
-		"Buffered" : "Synchronous");
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: O_DSYNC\n",
+		fd_dev->fd_dev_name, fd_dev->fd_dev_size);
 	return bl;
 }
 
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -18,7 +18,6 @@
 
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
-#define FDBD_USE_BUFFERED_IO	0x04
 
 struct fd_dev {
 	u32		fbd_flags;


