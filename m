Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2HaPsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:48:41 -0400
Received: from [66.192.166.38] ([66.192.166.38]:55473 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754264Ab2HaPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:48:40 -0400
Date: Fri, 31 Aug 2012 11:48:40 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/2] nbd: add set flags ioctl
Message-ID: <5040dcd8.o0gAcQjaJ9EalhQI%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: This patch adds a set-flags ioctl, allowing various option
flags to be set on an nbd device. This allows the nbd-client to set
the device flags (to enable read-only mode, or enable discard support, etc.).

Flags are typically specified by the nbd-server. During the negotiation phase
of the nbd connection, the server sends its flags to the client. The
client then uses NBD_SET_FLAGS to inform the kernel of the options.

Also included is a one-line fix to debug output for the set-timeout ioctl.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index d07c9f7..c544bb4 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -78,6 +78,8 @@ static const char *ioctl_cmd_to_ascii(int cmd)
 	case NBD_SET_SOCK: return "set-sock";
 	case NBD_SET_BLKSIZE: return "set-blksize";
 	case NBD_SET_SIZE: return "set-size";
+	case NBD_SET_TIMEOUT: return "set-timeout";
+	case NBD_SET_FLAGS: return "set-flags";
 	case NBD_DO_IT: return "do-it";
 	case NBD_CLEAR_SOCK: return "clear-sock";
 	case NBD_CLEAR_QUE: return "clear-que";
@@ -460,7 +462,7 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
 		nbd_cmd(req) = NBD_CMD_WRITE;
-		if (nbd->flags & NBD_READ_ONLY) {
+		if (nbd->flags & NBD_FLAG_READ_ONLY) {
 			dev_err(disk_to_dev(nbd->disk),
 				"Write on read-only\n");
 			goto error_out;
@@ -642,6 +644,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd->xmit_timeout = arg * HZ;
 		return 0;
 
+	case NBD_SET_FLAGS:
+		nbd->flags = arg;
+		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		nbd->bytesize = ((u64) arg) * nbd->blksize;
 		bdev->bd_inode->i_size = nbd->bytesize;
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index d146ca1..bb349be 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -27,6 +27,7 @@
 #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
 #define NBD_DISCONNECT  _IO( 0xab, 8 )
 #define NBD_SET_TIMEOUT _IO( 0xab, 9 )
+#define NBD_SET_FLAGS   _IO( 0xab, 10)
 
 enum {
 	NBD_CMD_READ = 0,
@@ -34,6 +35,10 @@ enum {
 	NBD_CMD_DISC = 2
 };
 
+/* values for flags field */
+#define NBD_FLAG_HAS_FLAGS    (1 << 0) /* nbd-server supports flags */
+#define NBD_FLAG_READ_ONLY    (1 << 1) /* device is read-only */
+
 #define nbd_cmd(req) ((req)->cmd[0])
 
 /* userspace doesn't need the nbd_device structure */
@@ -42,10 +47,6 @@ enum {
 #include <linux/wait.h>
 #include <linux/mutex.h>
 
-/* values for flags field */
-#define NBD_READ_ONLY 0x0001
-#define NBD_WRITE_NOCHK 0x0002
-
 struct request;
 
 struct nbd_device {
