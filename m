Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2DIC3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:29:51 -0400
Received: from masquerade.micron.com ([137.201.242.130]:6837 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2DIC3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:29:50 -0400
Message-ID: <4F824998.4050605@micron.com>
Date: Sun, 8 Apr 2012 19:29:44 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH v2 5/7] mtip32xx: Shorten macro names
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--22.473100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shortened macros used to represent mtip_port->flags and dd->dd_flag

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |  124 ++++++++++++++++++-------------------
 drivers/block/mtip32xx/mtip32xx.h |   28 ++++----
 2 files changed, 75 insertions(+), 77 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index be96626..e57864a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -173,7 +173,7 @@ static void mtip_command_cleanup(struct driver_data *dd)
 
 	up(&port->cmd_slot);
 
-	set_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag);
+	set_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag);
 	in_progress = 0;
 }
 
@@ -271,7 +271,7 @@ static int hba_reset_nosleep(struct driver_data *dd)
 		 && time_before(jiffies, timeout))
 		mdelay(1);
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))
 		return -1;
 
 	if (readl(dd->mmio + HOST_CTL) & HOST_RESET)
@@ -467,7 +467,7 @@ static void mtip_restart_port(struct mtip_port *port)
 		 && time_before(jiffies, timeout))
 		;
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 		return;
 
 	/*
@@ -498,7 +498,7 @@ static void mtip_restart_port(struct mtip_port *port)
 	while (time_before(jiffies, timeout))
 		;
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 		return;
 
 	/* Clear PxSCTL.DET */
@@ -512,7 +512,7 @@ static void mtip_restart_port(struct mtip_port *port)
 			 && time_before(jiffies, timeout))
 		;
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 		return;
 
 	if ((readl(port->mmio + PORT_SCR_STAT) & 0x01) == 0)
@@ -545,7 +545,7 @@ static void mtip_timeout_function(unsigned long int data)
 	if (unlikely(!port))
 		return;
 
-	if (test_bit(MTIP_DD_FLAG_RESUME_BIT, &port->dd->dd_flag)) {
+	if (test_bit(MTIP_DDF_RESUME_BIT, &port->dd->dd_flag)) {
 		mod_timer(&port->cmd_timer,
 			jiffies + msecs_to_jiffies(30000));
 		return;
@@ -572,7 +572,7 @@ static void mtip_timeout_function(unsigned long int data)
 
 			cmdto_cnt++;
 			if (cmdto_cnt == 1)
-				set_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags);
+				set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 
 			/*
 			 * Clear the completed bit. This should prevent
@@ -610,7 +610,7 @@ static void mtip_timeout_function(unsigned long int data)
 			"%d commands timed out: restarting port",
 			cmdto_cnt);
 		mtip_restart_port(port);
-		clear_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags);
+		clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 		wake_up_interruptible(&port->svc_wait);
 	}
 
@@ -765,7 +765,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	del_timer(&port->cmd_timer);
 
 	/* Set eh_active */
-	set_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags);
+	set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -826,14 +826,14 @@ static void mtip_handle_tfe(struct driver_data *dd)
 		if (buf[259] & 0x1) {
 			dev_info(&dd->pdev->dev,
 				"Write protect bit is set.\n");
-			set_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag);
+			set_bit(MTIP_DDF_WRITE_PROTECT_BIT, &dd->dd_flag);
 			fail_all_ncq_write = 1;
 			fail_reason = "write protect";
 		}
 		if (buf[288] == 0xF7) {
 			dev_info(&dd->pdev->dev,
 				"Exceeded Tmax, drive in thermal shutdown.\n");
-			set_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag);
+			set_bit(MTIP_DDF_OVER_TEMP_BIT, &dd->dd_flag);
 			fail_all_ncq_cmds = 1;
 			fail_reason = "thermal shutdown";
 		}
@@ -920,7 +920,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	print_tags(dd, "TFE tags reissued:", tagaccum);
 
 	/* clear eh_active */
-	clear_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags);
+	clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 	wake_up_interruptible(&port->svc_wait);
 
 	mod_timer(&port->cmd_timer,
@@ -988,7 +988,7 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 	struct mtip_port *port = dd->port;
 	struct mtip_cmd *cmd = &port->commands[MTIP_TAG_INTERNAL];
 
-	if (test_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags) &&
+	if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags) &&
 	    (cmd != NULL) && !(readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 		& (1 << MTIP_TAG_INTERNAL))) {
 		if (cmd->comp_func) {
@@ -1055,7 +1055,7 @@ static inline irqreturn_t mtip_handle_irq(struct driver_data *data)
 				/* don't proceed further */
 				return IRQ_HANDLED;
 			}
-			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+			if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 							&dd->dd_flag))
 				return rv;
 
@@ -1123,13 +1123,12 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
 
 	to = jiffies + msecs_to_jiffies(timeout);
 	do {
-		if (test_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags) &&
-			test_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags)) {
+		if (test_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags) &&
+			test_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags)) {
 			msleep(20);
 			continue; /* svc thd is actively issuing commands */
 		}
-		if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
-						&port->dd->dd_flag))
+		if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 			return -EFAULT;
 		/*
 		 * Ignore s_active bit 0 of array element 0.
@@ -1193,7 +1192,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 			"Internal command already active\n");
 		return -EBUSY;
 	}
-	set_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
+	set_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags);
 
 	if (atomic == GFP_KERNEL) {
 		if (fis->command != ATA_CMD_STANDBYNOW1) {
@@ -1202,8 +1201,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				dev_warn(&port->dd->pdev->dev,
 					"Failed to quiesce IO\n");
 				release_slot(port, MTIP_TAG_INTERNAL);
-				clear_bit(MTIP_FLAG_IC_ACTIVE_BIT,
-							&port->flags);
+				clear_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags);
 				wake_up_interruptible(&port->svc_wait);
 				return -EBUSY;
 			}
@@ -1256,7 +1254,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				"within timeout of  %lu ms\n",
 				atomic, timeout);
 			if (mtip_check_surprise_removal(port->dd->pdev) ||
-				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+				test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				rv = -ENXIO;
 				goto exec_ic_exit;
@@ -1268,7 +1266,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 			& (1 << MTIP_TAG_INTERNAL)) {
 			dev_warn(&port->dd->pdev->dev,
 				"Retiring internal command but CI is 1.\n");
-			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+			if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				hba_reset_nosleep(port->dd);
 				rv = -ENXIO;
@@ -1290,7 +1288,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				goto exec_ic_exit;
 			}
 			if ((fis->command != ATA_CMD_STANDBYNOW1) &&
-				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+				test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				rv = -ENXIO;
 				goto exec_ic_exit;
@@ -1302,7 +1300,7 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 			dev_err(&port->dd->pdev->dev,
 				"Internal command did not complete [atomic]\n");
 			rv = -EAGAIN;
-			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+			if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 						&port->dd->dd_flag)) {
 				hba_reset_nosleep(port->dd);
 				rv = -ENXIO;
@@ -1316,7 +1314,7 @@ exec_ic_exit:
 	/* Clear the allocated and active bits for the internal command. */
 	atomic_set(&int_cmd->active, 0);
 	release_slot(port, MTIP_TAG_INTERNAL);
-	clear_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags);
+	clear_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags);
 	wake_up_interruptible(&port->svc_wait);
 
 	return rv;
@@ -1366,7 +1364,7 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 	int rv = 0;
 	struct host_to_dev_fis fis;
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 		return -EFAULT;
 
 	/* Build the FIS. */
@@ -2398,10 +2396,10 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	 * To prevent this command from being issued
 	 * if an internal command is in progress or error handling is active.
 	 */
-	if (unlikely(test_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags) ||
-			test_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags))) {
+	if (unlikely(test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags) ||
+			test_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags))) {
 		set_bit(tag, port->cmds_to_issue);
-		set_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags);
+		set_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags);
 		return;
 	}
 
@@ -2447,7 +2445,7 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
 	down(&dd->port->cmd_slot);
 	*tag = get_slot(dd->port);
 
-	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
+	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))) {
 		up(&dd->port->cmd_slot);
 		return NULL;
 	}
@@ -2521,9 +2519,9 @@ static ssize_t mtip_hw_show_status(struct device *dev,
 	struct driver_data *dd = dev_to_disk(dev)->private_data;
 	int size = 0;
 
-	if (test_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag))
+	if (test_bit(MTIP_DDF_OVER_TEMP_BIT, &dd->dd_flag))
 		size += sprintf(buf, "%s", "thermal_shutdown\n");
-	else if (test_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag))
+	else if (test_bit(MTIP_DDF_WRITE_PROTECT_BIT, &dd->dd_flag))
 		size += sprintf(buf, "%s", "write_protect\n");
 	else
 		size += sprintf(buf, "%s", "online\n");
@@ -2670,7 +2668,7 @@ static int mtip_ftl_rebuild_poll(struct driver_data *dd)
 	timeout = jiffies + msecs_to_jiffies(MTIP_FTL_REBUILD_TIMEOUT_MS);
 
 	do {
-		if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+		if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 				&dd->dd_flag)))
 			return -EFAULT;
 		if (mtip_check_surprise_removal(dd->pdev))
@@ -2728,17 +2726,17 @@ static int mtip_service_thread(void *data)
 		 * is in progress nor error handling is active
 		 */
 		wait_event_interruptible(port->svc_wait, (port->flags) &&
-			!test_bit(MTIP_FLAG_IC_ACTIVE_BIT, &port->flags) &&
-			!test_bit(MTIP_FLAG_EH_ACTIVE_BIT, &port->flags));
+			!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags) &&
+			!test_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags));
 
 		if (kthread_should_stop())
 			break;
 
-		if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+		if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
 				&dd->dd_flag)))
 			break;
-		set_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags);
-		if (test_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags)) {
+		set_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags);
+		if (test_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags)) {
 			slot = 1;
 			/* used to restrict the loop to one iteration */
 			slot_start = num_cmd_slots;
@@ -2766,16 +2764,16 @@ static int mtip_service_thread(void *data)
 				clear_bit(slot, port->cmds_to_issue);
 			}
 
-			clear_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags);
-		} else if (test_bit(MTIP_FLAG_REBUILD_BIT, &port->flags)) {
+			clear_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags);
+		} else if (test_bit(MTIP_PF_REBUILD_BIT, &port->flags)) {
 			if (!mtip_ftl_rebuild_poll(dd))
-				set_bit(MTIP_DD_FLAG_REBUILD_FAILED_BIT,
+				set_bit(MTIP_DDF_REBUILD_FAILED_BIT,
 							&dd->dd_flag);
-			clear_bit(MTIP_FLAG_REBUILD_BIT, &port->flags);
+			clear_bit(MTIP_PF_REBUILD_BIT, &port->flags);
 		}
-		clear_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags);
+		clear_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags);
 
-		if (test_bit(MTIP_FLAG_SVC_THD_SHOULD_STOP_BIT, &port->flags))
+		if (test_bit(MTIP_PF_SVC_THD_SHOULD_STOP_BIT, &port->flags))
 			break;
 	}
 	return 0;
@@ -2930,7 +2928,7 @@ static int mtip_hw_init(struct driver_data *dd)
 		rv = -ENODEV;
 		goto out2 ;
 	}
-	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
+	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))) {
 		timetaken = jiffies - timetaken;
 		dev_warn(&dd->pdev->dev,
 			"Removal detected at %u ms\n",
@@ -2983,7 +2981,7 @@ static int mtip_hw_init(struct driver_data *dd)
 		jiffies + msecs_to_jiffies(MTIP_TIMEOUT_CHECK_PERIOD));
 
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)) {
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)) {
 		rv = -EFAULT;
 		goto out3;
 	}
@@ -2995,7 +2993,7 @@ static int mtip_hw_init(struct driver_data *dd)
 
 	if (*(dd->port->identify + MTIP_FTL_REBUILD_OFFSET) ==
 		MTIP_FTL_REBUILD_MAGIC) {
-		set_bit(MTIP_FLAG_REBUILD_BIT, &dd->port->flags);
+		set_bit(MTIP_PF_REBUILD_BIT, &dd->port->flags);
 		return MTIP_FTL_REBUILD_MAGIC;
 	}
 	mtip_dump_identify(dd->port);
@@ -3013,12 +3011,12 @@ static int mtip_hw_init(struct driver_data *dd)
 		if (buf[259] & 0x1) {
 			dev_info(&dd->pdev->dev,
 				"Write protect bit is set.\n");
-			set_bit(MTIP_DD_FLAG_WRITE_PROTECT_BIT, &dd->dd_flag);
+			set_bit(MTIP_DDF_WRITE_PROTECT_BIT, &dd->dd_flag);
 		}
 		if (buf[288] == 0xF7) {
 			dev_info(&dd->pdev->dev,
 				"Exceeded Tmax, drive in thermal shutdown.\n");
-			set_bit(MTIP_DD_FLAG_OVER_TEMP_BIT, &dd->dd_flag);
+			set_bit(MTIP_DDF_OVER_TEMP_BIT, &dd->dd_flag);
 		}
 		if (buf[288] == 0xBF) {
 			dev_info(&dd->pdev->dev,
@@ -3077,9 +3075,9 @@ static int mtip_hw_exit(struct driver_data *dd)
 	 * Send standby immediate (E0h) to the drive so that it
 	 * saves its state.
 	 */
-	if (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
+	if (!test_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag)) {
 
-		if (!test_bit(MTIP_FLAG_REBUILD_BIT, &dd->port->flags))
+		if (!test_bit(MTIP_PF_REBUILD_BIT, &dd->port->flags))
 			if (mtip_standby_immediate(dd->port))
 				dev_warn(&dd->pdev->dev,
 					"STANDBY IMMEDIATE failed\n");
@@ -3260,7 +3258,7 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
-	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)))
+	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
 	switch (cmd) {
@@ -3298,7 +3296,7 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
-	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)))
+	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
 	switch (cmd) {
@@ -3423,7 +3421,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 	int nents = 0;
 	int tag = 0;
 
-	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)) {
+	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)) {
 		bio_endio(bio, -ENXIO);
 		return;
 	}
@@ -3590,7 +3588,7 @@ skip_create_disk:
 	}
 
 	if (dd->mtip_svc_handler) {
-		set_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag);
+		set_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag);
 		return rv; /* service thread created for handling rebuild */
 	}
 
@@ -3650,13 +3648,13 @@ static int mtip_block_remove(struct driver_data *dd)
 	struct kobject *kobj;
 
 	if (dd->mtip_svc_handler) {
-		set_bit(MTIP_FLAG_SVC_THD_SHOULD_STOP_BIT, &dd->port->flags);
+		set_bit(MTIP_PF_SVC_THD_SHOULD_STOP_BIT, &dd->port->flags);
 		wake_up_interruptible(&dd->port->svc_wait);
 		kthread_stop(dd->mtip_svc_handler);
 	}
 
 	/* Clean up the sysfs attributes, if created */
-	if (test_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag)) {
+	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag)) {
 		kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
 		if (kobj) {
 			mtip_hw_sysfs_exit(dd, kobj);
@@ -3812,7 +3810,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	 */
 	instance++;
 	if (rv != MTIP_FTL_REBUILD_MAGIC)
-		set_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag);
+		set_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag);
 	goto done;
 
 block_initialize_err:
@@ -3841,10 +3839,10 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	struct driver_data *dd = pci_get_drvdata(pdev);
 	int counter = 0;
 
-	set_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag);
+	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
 
 	if (mtip_check_surprise_removal(pdev)) {
-		while (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
+		while (!test_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag)) {
 			counter++;
 			msleep(20);
 			if (counter == 10) {
@@ -3882,7 +3880,7 @@ static int mtip_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 		return -EFAULT;
 	}
 
-	set_bit(MTIP_DD_FLAG_RESUME_BIT, &dd->dd_flag);
+	set_bit(MTIP_DDF_RESUME_BIT, &dd->dd_flag);
 
 	/* Disable ports & interrupts then send standby immediate */
 	rv = mtip_block_suspend(dd);
@@ -3948,7 +3946,7 @@ static int mtip_pci_resume(struct pci_dev *pdev)
 		dev_err(&pdev->dev, "Unable to resume\n");
 
 err:
-	clear_bit(MTIP_DD_FLAG_RESUME_BIT, &dd->dd_flag);
+	clear_bit(MTIP_DDF_RESUME_BIT, &dd->dd_flag);
 
 	return rv;
 }
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index ea5c7e7..5ad2d79 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -114,22 +114,22 @@
 #define __force_bit2int (unsigned int __force)
 
 /* below are bit numbers in 'flags' defined in mtip_port */
-#define MTIP_FLAG_IC_ACTIVE_BIT			0
-#define MTIP_FLAG_EH_ACTIVE_BIT			1
-#define MTIP_FLAG_SVC_THD_ACTIVE_BIT		2
-#define MTIP_FLAG_ISSUE_CMDS_BIT		4
-#define MTIP_FLAG_REBUILD_BIT			5
-#define MTIP_FLAG_SVC_THD_SHOULD_STOP_BIT	8
+#define MTIP_PF_IC_ACTIVE_BIT			0
+#define MTIP_PF_EH_ACTIVE_BIT			1
+#define MTIP_PF_SVC_THD_ACTIVE_BIT		2
+#define MTIP_PF_ISSUE_CMDS_BIT			4
+#define MTIP_PF_REBUILD_BIT			5
+#define MTIP_PF_SVC_THD_SHOULD_STOP_BIT		8
 
 /* below are bit numbers in 'dd_flag' defined in driver_data */
-#define MTIP_DD_FLAG_REMOVE_PENDING_BIT		1
-#define MTIP_DD_FLAG_RESUME_BIT			2
-#define MTIP_DD_FLAG_CLEANUP_BIT		3
-#define MTIP_DD_FLAG_INIT_DONE_BIT		4
-
-#define MTIP_DD_FLAG_WRITE_PROTECT_BIT		5
-#define MTIP_DD_FLAG_OVER_TEMP_BIT		6
-#define MTIP_DD_FLAG_REBUILD_FAILED_BIT		7
+#define MTIP_DDF_REMOVE_PENDING_BIT	1
+#define MTIP_DDF_RESUME_BIT		2
+#define MTIP_DDF_CLEANUP_BIT		3
+#define MTIP_DDF_INIT_DONE_BIT		4
+
+#define MTIP_DDF_WRITE_PROTECT_BIT	5
+#define MTIP_DDF_OVER_TEMP_BIT		6
+#define MTIP_DDF_REBUILD_FAILED_BIT	7
 
 __packed struct smart_attr{
 	u8 attr_id;
-- 
1.7.1

