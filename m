Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1IHHps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:45:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65133 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1IHHpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:45:11 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Clements <Paul.Clements@steeleye.com>, <nbd-general@lists.sf.net>
Subject: [PATCH v2 1/2] nbd: add support for feature negotiation
Date: Thu,  8 Sep 2011 09:44:57 +0200
Message-Id: <1315467898-23984-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315467898-23984-1-git-send-email-pbonzini@redhat.com>
References: <1315467898-23984-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a IOCTL to negotiate features between the server and the kernel
module, with mediation from the userspace client.  Features are stored
in the pre-existing (but so far never written to) flags field; bits for
the flags field are adjusted to actually match the network protocol.

Also, zero out the flags when NBD_DO_IT completes.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: <nbd-general@lists.sf.net>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c |   10 +++++++++-
 include/linux/nbd.h |   28 ++++++++++++++--------------
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index be23aec..c4fe9c8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -85,6 +85,7 @@ static const char *ioctl_cmd_to_ascii(int cmd)
 	case NBD_PRINT_DEBUG: return "print-debug";
 	case NBD_SET_SIZE_BLOCKS: return "set-size-blocks";
 	case NBD_DISCONNECT: return "disconnect";
+	case NBD_SET_FLAGS: return "set-flags";
 	case BLKROSET: return "set-read-only";
 	case BLKFLSBUF: return "flush-buffer-cache";
 	}
@@ -453,7 +453,7 @@ static void nbd_handle_req(struct nbd_device *lo, struct request *req)
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
-		if (lo->flags & NBD_READ_ONLY) {
+		if (lo->flags & NBD_FLAG_READ_ONLY) {
 			printk(KERN_ERR "%s: Write on read-only\n",
 					lo->disk->disk_name);
 			goto error_out;
@@ -634,6 +635,12 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		lo->xmit_timeout = arg * HZ;
 		return 0;
 
+	case NBD_SET_FLAGS:
+		if (((u64) arg) & (-1ULL << 32))
+			return -EINVAL;
+		lo->flags = arg;
+		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		bdev->bd_inode->i_size = lo->bytesize;
@@ -672,6 +679,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
 		if (file)
 			fput(file);
+		lo->flags = 0;
 		lo->bytesize = 0;
 		bdev->bd_inode->i_size = 0;
 		set_capacity(lo->disk, 0);
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index 0582054..926f19d 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -17,16 +17,20 @@
 
 #include <linux/types.h>
 
-#define NBD_SET_SOCK	_IO( 0xab, 0 )
-#define NBD_SET_BLKSIZE	_IO( 0xab, 1 )
-#define NBD_SET_SIZE	_IO( 0xab, 2 )
-#define NBD_DO_IT	_IO( 0xab, 3 )
-#define NBD_CLEAR_SOCK	_IO( 0xab, 4 )
-#define NBD_CLEAR_QUE	_IO( 0xab, 5 )
-#define NBD_PRINT_DEBUG	_IO( 0xab, 6 )
-#define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
-#define NBD_DISCONNECT  _IO( 0xab, 8 )
-#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
+#define NBD_SET_SOCK		_IO(0xab, 0)
+#define NBD_SET_BLKSIZE		_IO(0xab, 1)
+#define NBD_SET_SIZE		_IO(0xab, 2)
+#define NBD_DO_IT		_IO(0xab, 3)
+#define NBD_CLEAR_SOCK		_IO(0xab, 4)
+#define NBD_CLEAR_QUE		_IO(0xab, 5)
+#define NBD_PRINT_DEBUG		_IO(0xab, 6)
+#define NBD_SET_SIZE_BLOCKS	_IO(0xab, 7)
+#define NBD_DISCONNECT		_IO(0xab, 8)
+#define NBD_SET_TIMEOUT		_IO(0xab, 9)
+#define NBD_SET_FLAGS		_IO(0xab, 10)
+
+/* values for flags field */
+#define NBD_FLAG_READ_ONLY	(1 << 1)
 
 enum {
 	NBD_CMD_READ = 0,
@@ -42,10 +46,6 @@ enum {
 #include <linux/wait.h>
 #include <linux/mutex.h>
 
-/* values for flags field */
-#define NBD_READ_ONLY 0x0001
-#define NBD_WRITE_NOCHK 0x0002
-
 struct request;
 
 struct nbd_device {
-- 
1.7.6


