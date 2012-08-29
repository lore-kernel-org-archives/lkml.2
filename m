Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2H2NO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:14:57 -0400
Received: from [66.192.166.38] ([66.192.166.38]:36965 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752255Ab2H2NO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:14:56 -0400
Date: Wed, 29 Aug 2012 08:41:02 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [RESEND] add discard support to nbd
Message-ID: <503e0dde.ssYktQsJ5nYlhlQB%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description: This patch adds discard support to nbd. When the nbd client
system receives a discard request, this will be passed along to the nbd
server system, where the nbd-server will respond by performing:
	fallocate(.. FALLOC_FL_PUNCH_HOLE ..)

To punch a hole in the backend storage, which is no longer needed.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c544bb4..a014169 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -98,6 +98,7 @@ static const char *nbdcmd_to_ascii(int cmd)
 	case  NBD_CMD_READ: return "read";
 	case NBD_CMD_WRITE: return "write";
 	case  NBD_CMD_DISC: return "disconnect";
+	case  NBD_CMD_TRIM: return "trim/discard";
 	}
 	return "invalid";
 }
@@ -461,7 +462,11 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 
 	nbd_cmd(req) = NBD_CMD_READ;
 	if (rq_data_dir(req) == WRITE) {
-		nbd_cmd(req) = NBD_CMD_WRITE;
+		if ((req->cmd_flags & REQ_DISCARD)) {
+			WARN_ON(!(nbd->flags & NBD_FLAG_SEND_TRIM));
+			nbd_cmd(req) = NBD_CMD_TRIM;
+		} else
+			nbd_cmd(req) = NBD_CMD_WRITE;
 		if (nbd->flags & NBD_FLAG_READ_ONLY) {
 			dev_err(disk_to_dev(nbd->disk),
 				"Write on read-only\n");
@@ -667,6 +672,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 
 		mutex_unlock(&nbd->tx_lock);
 
+		if (nbd->flags & NBD_FLAG_SEND_TRIM)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+				nbd->disk->queue);
+
 		thread = kthread_create(nbd_thread, nbd, nbd->disk->disk_name);
 		if (IS_ERR(thread)) {
 			mutex_lock(&nbd->tx_lock);
@@ -684,6 +693,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		nbd->file = NULL;
 		nbd_clear_que(nbd);
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
 		if (file)
 			fput(file);
 		nbd->bytesize = 0;
@@ -802,6 +812,9 @@ static int __init nbd_init(void)
 		 * Tell the block layer that we are not a rotational device
 		 */
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, disk->queue);
+		disk->queue->limits.discard_granularity = 512;
+		disk->queue->limits.max_discard_sectors = UINT_MAX;
+		disk->queue->limits.discard_zeroes_data = 0;
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index bb349be..3b49a63 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -32,12 +32,16 @@
 enum {
 	NBD_CMD_READ = 0,
 	NBD_CMD_WRITE = 1,
-	NBD_CMD_DISC = 2
+	NBD_CMD_DISC = 2,
+	/* there is a gap here to match userspace */
+	NBD_CMD_TRIM = 4
 };
 
 /* values for flags field */
 #define NBD_FLAG_HAS_FLAGS	(1 << 0)
 #define NBD_FLAG_READ_ONLY	(1 << 1)
+/* there is a gap here to match userspace */
+#define NBD_FLAG_SEND_TRIM	(1 << 5) /* send trim/discard */
 
 #define nbd_cmd(req) ((req)->cmd[0])
 
