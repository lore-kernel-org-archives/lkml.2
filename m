Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2DIC3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:29:33 -0400
Received: from masquerade.micron.com ([137.201.242.130]:26389 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2DIC3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:29:31 -0400
Message-ID: <4F824986.1030305@micron.com>
Date: Sun, 8 Apr 2012 19:29:26 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH v2 4/7] mtip32xx: misc changes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--13.354300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Handle the interrupt completion of polled internal commands
* Do not check remove pending flag for standby command
* On rebuild failure,
    - set corresponding bit dd_flag
    - do not send standby command
* Free ida index in remove path

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   66 ++++++++++++++++++++++++------------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 79fdb06..be96626 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -708,6 +708,14 @@ static void mtip_completion(struct mtip_port *port,
 	complete(waiting);
 }
 
+static void mtip_null_completion(struct mtip_port *port,
+			    int tag,
+			    void *data,
+			    int status)
+{
+	return;
+}
+
 /*
  * Helper function for tag logging
  */
@@ -992,8 +1000,6 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 		}
 	}
 
-	dev_warn(&dd->pdev->dev, "IRQ status 0x%x ignored.\n", port_stat);
-
 	return;
 }
 
@@ -1161,7 +1167,7 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
  *	-EAGAIN  Time out waiting for command to complete.
  */
 static int mtip_exec_internal_command(struct mtip_port *port,
-					void *fis,
+					struct host_to_dev_fis *fis,
 					int fis_len,
 					dma_addr_t buffer,
 					int buf_len,
@@ -1190,14 +1196,17 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	set_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
 
 	if (atomic == GFP_KERNEL) {
-		/* wait for io to complete if non atomic */
-		if (mtip_quiesce_io(port, 5000) < 0) {
-			dev_warn(&port->dd->pdev->dev,
-				"Failed to quiesce IO\n");
-			release_slot(port, MTIP_TAG_INTERNAL);
-			clear_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
-			wake_up_interruptible(&port->svc_wait);
-			return -EBUSY;
+		if (fis->command != ATA_CMD_STANDBYNOW1) {
+			/* wait for io to complete if non atomic */
+			if (mtip_quiesce_io(port, 5000) < 0) {
+				dev_warn(&port->dd->pdev->dev,
+					"Failed to quiesce IO\n");
+				release_slot(port, MTIP_TAG_INTERNAL);
+				clear_bit(MTIP_FLAG_IC_ACTIVE_BIT,
+							&port->flags);
+				wake_up_interruptible(&port->svc_wait);
+				return -EBUSY;
+			}
 		}
 
 		/* Set the completion function and data for the command. */
@@ -1207,7 +1216,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	} else {
 		/* Clear completion - we're going to poll */
 		int_cmd->comp_data = NULL;
-		int_cmd->comp_func = NULL;
+		int_cmd->comp_func = mtip_null_completion;
 	}
 
 	/* Copy the command to the command table */
@@ -1273,12 +1282,14 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	} else {
 		/* Spin for <timeout> checking if command still outstanding */
 		timeout = jiffies + msecs_to_jiffies(timeout);
-
-		while ((readl(
-			port->cmd_issue[MTIP_TAG_INTERNAL])
-			& (1 << MTIP_TAG_INTERNAL))
-			&& time_before(jiffies, timeout)) {
-			if (mtip_check_surprise_removal(port->dd->pdev) ||
+		while ((readl(port->cmd_issue[MTIP_TAG_INTERNAL])
+				& (1 << MTIP_TAG_INTERNAL))
+				&& time_before(jiffies, timeout)) {
+			if (mtip_check_surprise_removal(port->dd->pdev)) {
+				rv = -ENXIO;
+				goto exec_ic_exit;
+			}
+			if ((fis->command != ATA_CMD_STANDBYNOW1) &&
 				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				rv = -ENXIO;
@@ -1289,8 +1300,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 		if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL)) {
 			dev_err(&port->dd->pdev->dev,
-				"Internal command did not complete [%d]\n",
-				atomic);
+				"Internal command did not complete [atomic]\n");
 			rv = -EAGAIN;
 			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
@@ -2758,7 +2768,9 @@ static int mtip_service_thread(void *data)
 
 			clear_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags);
 		} else if (test_bit(MTIP_FLAG_REBUILD_BIT, &port->flags)) {
-			mtip_ftl_rebuild_poll(dd);
+			if (!mtip_ftl_rebuild_poll(dd))
+				set_bit(MTIP_DD_FLAG_REBUILD_FAILED_BIT,
+							&dd->dd_flag);
 			clear_bit(MTIP_FLAG_REBUILD_BIT, &port->flags);
 		}
 		clear_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags);
@@ -3067,7 +3079,7 @@ static int mtip_hw_exit(struct driver_data *dd)
 	 */
 	if (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
 
-		if (test_bit(MTIP_FLAG_REBUILD_BIT, &dd->dd_flag))
+		if (!test_bit(MTIP_FLAG_REBUILD_BIT, &dd->port->flags))
 			if (mtip_standby_immediate(dd->port))
 				dev_warn(&dd->pdev->dev,
 					"STANDBY IMMEDIATE failed\n");
@@ -3657,6 +3669,11 @@ static int mtip_block_remove(struct driver_data *dd)
 	 * from /dev
 	 */
 	del_gendisk(dd->disk);
+
+	spin_lock(&rssd_index_lock);
+	ida_remove(&rssd_index_ida, dd->index);
+	spin_unlock(&rssd_index_lock);
+
 	blk_cleanup_queue(dd->queue);
 	dd->disk  = NULL;
 	dd->queue = NULL;
@@ -3686,6 +3703,11 @@ static int mtip_block_shutdown(struct driver_data *dd)
 
 	/* Delete our gendisk structure, and cleanup the blk queue. */
 	del_gendisk(dd->disk);
+
+	spin_lock(&rssd_index_lock);
+	ida_remove(&rssd_index_ida, dd->index);
+	spin_unlock(&rssd_index_lock);
+
 	blk_cleanup_queue(dd->queue);
 	dd->disk  = NULL;
 	dd->queue = NULL;
-- 
1.7.1

