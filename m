Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2KZRCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47211 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2KZRCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 044/270] target/file: Re-enable optional fd_buffered_io=1 operation
Date: Mon, 26 Nov 2012 14:55:34 -0200
Message-Id: <1353949160-26803-45-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit b32f4c7ed85c5cee2a21a55c9f59ebc9d57a2463 upstream.

This patch re-adds the ability to optionally run in buffered FILEIO mode
(eg: w/o O_DSYNC) for device backends in order to once again use the
Linux buffered cache as a write-back storage mechanism.

This logic was originally dropped with mainline v3.5-rc commit:

commit a4dff3043c231d57f982af635c9d2192ee40e5ae
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed May 30 16:25:41 2012 -0700

    target/file: Use O_DSYNC by default for FILEIO backends

This difference with this patch is that fd_create_virtdevice() now
forces the explicit setting of emulate_write_cache=1 when buffered FILEIO
operation has been enabled.

(v2: Switch to FDBD_HAS_BUFFERED_IO_WCE + add more detailed
     comment as requested by hch)

Reported-by: Ferry <iscsitmp@bananateam.nl>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_file.c |   41 ++++++++++++++++++++++++++++++++++---
 drivers/target/target_core_file.h |    1 +
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 9f99d04..c0d6e6d 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -138,6 +138,19 @@ static struct se_device *fd_create_virtdevice(
 	 * of pure timestamp updates.
 	 */
 	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
+	/*
+	 * Optionally allow fd_buffered_io=1 to be enabled for people
+	 * who want use the fs buffer cache as an WriteCache mechanism.
+	 *
+	 * This means that in event of a hard failure, there is a risk
+	 * of silent data-loss if the SCSI client has *not* performed a
+	 * forced unit access (FUA) write, or issued SYNCHRONIZE_CACHE
+	 * to write-out the entire device cache.
+	 */
+	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
+		pr_debug("FILEIO: Disabling O_DSYNC, using buffered FILEIO\n");
+		flags &= ~O_DSYNC;
+	}
 
 	file = filp_open(dev_p, flags, 0600);
 	if (IS_ERR(file)) {
@@ -205,6 +218,12 @@ static struct se_device *fd_create_virtdevice(
 	if (!dev)
 		goto fail;
 
+	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {
+		pr_debug("FILEIO: Forcing setting of emulate_write_cache=1"
+			" with FDBD_HAS_BUFFERED_IO_WCE\n");
+		dev->se_sub_dev->se_dev_attrib.emulate_write_cache = 1;
+	}
+
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
@@ -422,6 +441,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
+	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
@@ -433,7 +453,7 @@ static ssize_t fd_set_configfs_dev_params(
 	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token;
+	int ret = 0, arg, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -477,6 +497,19 @@ static ssize_t fd_set_configfs_dev_params(
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
+		case Opt_fd_buffered_io:
+			match_int(args, &arg);
+			if (arg != 1) {
+				pr_err("bogus fd_buffered_io=%d value\n", arg);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			pr_debug("FILEIO: Using buffered I/O"
+				" operations for struct fd_dev\n");
+
+			fd_dev->fbd_flags |= FDBD_HAS_BUFFERED_IO_WCE;
+			break;
 		default:
 			break;
 		}
@@ -508,8 +541,10 @@ static ssize_t fd_show_configfs_dev_params(
 	ssize_t bl = 0;
 
 	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: O_DSYNC\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size);
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
+		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
+		(fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) ?
+		"Buffered-WCE" : "O_DSYNC");
 	return bl;
 }
 
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 70ce7fd..876ae53 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -14,6 +14,7 @@
 
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
+#define FDBD_HAS_BUFFERED_IO_WCE 0x04
 
 struct fd_dev {
 	u32		fbd_flags;
-- 
1.7.9.5

