Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2DEVAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:00:06 -0400
Received: from masquerade.micron.com ([137.201.242.130]:2441 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab2DEVAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:00:02 -0400
Message-ID: <4F7E07CE.8080607@micron.com>
Date: Thu, 5 Apr 2012 13:59:58 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 1/5] mtip32xx: Add new bitwise flag 'dd_flag' and make set
 comp_time as common
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--12.365400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Merged the following flags into one variable 'dd_flag':
        * drv_cleanup_done
        * resumeflag
* Added the following flags into 'dd_flag'
        * remove pending
        * init done
* Removed 'ftlrebuildflag' (similar flag is already part of mti_port->flags)
* Moved setting completion time into mtip_issue_ncq_command()

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Reviewed-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |  232 ++++++++++++++++++++++++++-----------
 drivers/block/mtip32xx/mtip32xx.h |   12 +-
 2 files changed, 173 insertions(+), 71 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 8eb81c9..295138b 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -36,6 +36,7 @@
 #include <linux/idr.h>
 #include <linux/kthread.h>
 #include <../drivers/ata/ahci.h>
+#include <linux/export.h>
 #include "mtip32xx.h"
 
 #define HW_CMD_SLOT_SZ		(MTIP_MAX_COMMAND_SLOTS * 32)
@@ -44,6 +45,7 @@
 #define HW_PORT_PRIV_DMA_SZ \
 		(HW_CMD_SLOT_SZ + HW_CMD_TBL_AR_SZ + AHCI_RX_FIS_SZ)
 
+#define HOST_CAP_NZDMA		(1 << 19)
 #define HOST_HSORG		0xFC
 #define HSORG_DISABLE_SLOTGRP_INTR (1<<24)
 #define HSORG_DISABLE_SLOTGRP_PXIS (1<<16)
@@ -139,6 +141,12 @@ static void mtip_command_cleanup(struct driver_data *dd)
 	int group = 0, commandslot = 0, commandindex = 0;
 	struct mtip_cmd *command;
 	struct mtip_port *port = dd->port;
+	static int in_progress;
+
+	if (in_progress)
+		return;
+
+	in_progress = 1;
 
 	for (group = 0; group < 4; group++) {
 		for (commandslot = 0; commandslot < 32; commandslot++) {
@@ -165,7 +173,8 @@ static void mtip_command_cleanup(struct driver_data *dd)
 
 	up(&port->cmd_slot);
 
-	atomic_set(&dd->drv_cleanup_done, true);
+	set_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag);
+	in_progress = 0;
 }
 
 /*
@@ -262,6 +271,9 @@ static int hba_reset_nosleep(struct driver_data *dd)
 		 && time_before(jiffies, timeout))
 		mdelay(1);
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))
+		return -1;
+
 	if (readl(dd->mmio + HOST_CTL) & HOST_RESET)
 		return -1;
 
@@ -294,6 +306,10 @@ static inline void mtip_issue_ncq_command(struct mtip_port *port, int tag)
 			port->cmd_issue[MTIP_TAG_INDEX(tag)]);
 
 	spin_unlock_irqrestore(&port->cmd_issue_lock, flags);
+
+	/* Set the command's timeout value.*/
+	port->commands[tag].comp_time = jiffies + msecs_to_jiffies(
+					MTIP_NCQ_COMMAND_TIMEOUT_MS);
 }
 
 /*
@@ -447,6 +463,9 @@ static void mtip_restart_port(struct mtip_port *port)
 		 && time_before(jiffies, timeout))
 		;
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+		return;
+
 	/*
 	 * Chip quirk: escalate to hba reset if
 	 * PxCMD.CR not clear after 500 ms
@@ -475,6 +494,9 @@ static void mtip_restart_port(struct mtip_port *port)
 	while (time_before(jiffies, timeout))
 		;
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+		return;
+
 	/* Clear PxSCTL.DET */
 	writel(readl(port->mmio + PORT_SCR_CTL) & ~1,
 			 port->mmio + PORT_SCR_CTL);
@@ -486,6 +508,9 @@ static void mtip_restart_port(struct mtip_port *port)
 			 && time_before(jiffies, timeout))
 		;
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+		return;
+
 	if ((readl(port->mmio + PORT_SCR_STAT) & 0x01) == 0)
 		dev_warn(&port->dd->pdev->dev,
 			"COM reset failed\n");
@@ -518,7 +543,7 @@ static void mtip_timeout_function(unsigned long int data)
 	if (unlikely(!port))
 		return;
 
-	if (atomic_read(&port->dd->resumeflag) == true) {
+	if (test_bit(MTIP_DD_FLAG_RESUME_BIT, &port->dd->dd_flag)) {
 		mod_timer(&port->cmd_timer,
 			jiffies + msecs_to_jiffies(30000));
 		return;
@@ -801,10 +826,6 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 				set_bit(tag, tagaccum);
 
-				/* Update the timeout value. */
-				port->commands[tag].comp_time =
-					jiffies + msecs_to_jiffies(
-					MTIP_NCQ_COMMAND_TIMEOUT_MS);
 				/* Re-issue the command. */
 				mtip_issue_ncq_command(port, tag);
 
@@ -968,6 +989,9 @@ static inline irqreturn_t mtip_handle_irq(struct driver_data *data)
 				/* don't proceed further */
 				return IRQ_HANDLED;
 			}
+			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+							&dd->dd_flag))
+				return rv;
 
 			mtip_process_errors(dd, port_stat & PORT_IRQ_ERR);
 		}
@@ -1038,6 +1062,9 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
 			msleep(20);
 			continue; /* svc thd is actively issuing commands */
 		}
+		if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+						&port->dd->dd_flag))
+			return -EFAULT;
 		/*
 		 * Ignore s_active bit 0 of array element 0.
 		 * This bit will always be set
@@ -1159,6 +1186,12 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				"Internal command did not complete [%d] "
 				"within timeout of  %lu ms\n",
 				atomic, timeout);
+			if (mtip_check_surprise_removal(port->dd->pdev) ||
+				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+						&port->dd->dd_flag)) {
+				rv = -ENXIO;
+				goto exec_ic_exit;
+			}
 			rv = -EAGAIN;
 		}
 
@@ -1166,6 +1199,15 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 			& (1 << MTIP_TAG_INTERNAL)) {
 			dev_warn(&port->dd->pdev->dev,
 				"Retiring internal command but CI is 1.\n");
+			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+						&port->dd->dd_flag)) {
+				hba_reset_nosleep(port->dd);
+				rv = -ENXIO;
+			} else {
+				mtip_restart_port(port);
+				rv = -EAGAIN;
+			}
+			goto exec_ic_exit;
 		}
 
 	} else {
@@ -1175,8 +1217,14 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 		while ((readl(
 			port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL))
-			&& time_before(jiffies, timeout))
-			;
+			&& time_before(jiffies, timeout)) {
+			if (mtip_check_surprise_removal(port->dd->pdev) ||
+				test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+						&port->dd->dd_flag)) {
+				rv = -ENXIO;
+				goto exec_ic_exit;
+			}
+		}
 
 		if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL)) {
@@ -1184,9 +1232,17 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 				"Internal command did not complete [%d]\n",
 				atomic);
 			rv = -EAGAIN;
+			if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+						&port->dd->dd_flag)) {
+				hba_reset_nosleep(port->dd);
+				rv = -ENXIO;
+			} else {
+				mtip_restart_port(port);
+				rv = -EAGAIN;
+			}
 		}
 	}
-
+exec_ic_exit:
 	/* Clear the allocated and active bits for the internal command. */
 	atomic_set(&int_cmd->active, 0);
 	release_slot(port, MTIP_TAG_INTERNAL);
@@ -1240,6 +1296,9 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 	int rv = 0;
 	struct host_to_dev_fis fis;
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &port->dd->dd_flag))
+		return -EFAULT;
+
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
 	fis.type	= 0x27;
@@ -1505,9 +1564,7 @@ static int exec_drive_task(struct mtip_port *port, u8 *command)
 	fis.device	= command[6] & ~0x10; /* Clear the dev bit*/
 
 
-	dbg_printk(MTIP_DRV_NAME "%s: User Command: cmd %x, feat %x, "
-		"nsect %x, sect %x, lcyl %x, "
-		"hcyl %x, sel %x\n",
+	dbg_printk(MTIP_DRV_NAME "%s: User Command: cmd %x, feat %x, nsect %x, sect %x, lcyl %x, hcyl %x, sel %x\n",
 		__func__,
 		command[0],
 		command[1],
@@ -1534,8 +1591,7 @@ static int exec_drive_task(struct mtip_port *port, u8 *command)
 	command[4] = reply->cyl_low;
 	command[5] = reply->cyl_hi;
 
-	dbg_printk(MTIP_DRV_NAME "%s: Completion Status: stat %x, "
-		"err %x , cyl_lo %x cyl_hi %x\n",
+	dbg_printk(MTIP_DRV_NAME "%s: Completion Status: stat %x, err %x , cyl_lo %x cyl_hi %x\n",
 		__func__,
 		command[0],
 		command[1],
@@ -2080,14 +2136,10 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
 	struct mtip_cmd *command = &port->commands[tag];
+	int dma_dir = (dir == READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
 	/* Map the scatter list for DMA access */
-	if (dir == READ)
-		nents = dma_map_sg(&dd->pdev->dev, command->sg,
-					nents, DMA_FROM_DEVICE);
-	else
-		nents = dma_map_sg(&dd->pdev->dev, command->sg,
-					nents, DMA_TO_DEVICE);
+	nents = dma_map_sg(&dd->pdev->dev, command->sg, nents, dma_dir);
 
 	command->scatter_ents = nents;
 
@@ -2127,7 +2179,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	 */
 	command->comp_data = dd;
 	command->comp_func = mtip_async_complete;
-	command->direction = (dir == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	command->direction = dma_dir;
 
 	/*
 	 * Set the completion function and data for the command passed
@@ -2150,9 +2202,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	/* Issue the command to the hardware */
 	mtip_issue_ncq_command(port, tag);
 
-	/* Set the command's timeout value.*/
-	port->commands[tag].comp_time = jiffies + msecs_to_jiffies(
-					MTIP_NCQ_COMMAND_TIMEOUT_MS);
+	return;
 }
 
 /*
@@ -2191,6 +2241,10 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
 	down(&dd->port->cmd_slot);
 	*tag = get_slot(dd->port);
 
+	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
+		up(&dd->port->cmd_slot);
+		return NULL;
+	}
 	if (unlikely(*tag < 0))
 		return NULL;
 
@@ -2207,7 +2261,7 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
  * return value
  *	The size, in bytes, of the data copied into buf.
  */
-static ssize_t hw_show_registers(struct device *dev,
+static ssize_t mtip_hw_show_registers(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
 {
@@ -2253,7 +2307,7 @@ static ssize_t hw_show_registers(struct device *dev,
 
 	return size;
 }
-static DEVICE_ATTR(registers, S_IRUGO, hw_show_registers, NULL);
+static DEVICE_ATTR(registers, S_IRUGO, mtip_hw_show_registers, NULL);
 
 /*
  * Create the sysfs related attributes.
@@ -2384,10 +2438,12 @@ static int mtip_ftl_rebuild_poll(struct driver_data *dd)
 		"FTL rebuild in progress. Polling for completion.\n");
 
 	start = jiffies;
-	dd->ftlrebuildflag = 1;
 	timeout = jiffies + msecs_to_jiffies(MTIP_FTL_REBUILD_TIMEOUT_MS);
 
 	do {
+		if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+				&dd->dd_flag)))
+			return -EFAULT;
 		if (mtip_check_surprise_removal(dd->pdev))
 			return -EFAULT;
 
@@ -2408,22 +2464,17 @@ static int mtip_ftl_rebuild_poll(struct driver_data *dd)
 			dev_warn(&dd->pdev->dev,
 				"FTL rebuild complete (%d secs).\n",
 			jiffies_to_msecs(jiffies - start) / 1000);
-			dd->ftlrebuildflag = 0;
 			mtip_block_initialize(dd);
-			break;
+			return 0;
 		}
 		ssleep(10);
 	} while (time_before(jiffies, timeout));
 
 	/* Check for timeout */
-	if (dd->ftlrebuildflag) {
-		dev_err(&dd->pdev->dev,
+	dev_err(&dd->pdev->dev,
 		"Timed out waiting for FTL rebuild to complete (%d secs).\n",
 		jiffies_to_msecs(jiffies - start) / 1000);
-		return -EFAULT;
-	}
-
-	return 0;
+	return -EFAULT;
 }
 
 /*
@@ -2454,6 +2505,9 @@ static int mtip_service_thread(void *data)
 		if (kthread_should_stop())
 			break;
 
+		if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT,
+				&dd->dd_flag)))
+			break;
 		set_bit(MTIP_FLAG_SVC_THD_ACTIVE_BIT, &port->flags);
 		if (test_bit(MTIP_FLAG_ISSUE_CMDS_BIT, &port->flags)) {
 			slot = 1;
@@ -2480,10 +2534,6 @@ static int mtip_service_thread(void *data)
 				/* Issue the command to the hardware */
 				mtip_issue_ncq_command(port, slot);
 
-				/* Set the command's timeout value.*/
-				port->commands[slot].comp_time = jiffies +
-				msecs_to_jiffies(MTIP_NCQ_COMMAND_TIMEOUT_MS);
-
 				clear_bit(slot, port->cmds_to_issue);
 			}
 
@@ -2513,6 +2563,7 @@ static int mtip_hw_init(struct driver_data *dd)
 	int i;
 	int rv;
 	unsigned int num_command_slots;
+	unsigned long timeout, timetaken;
 
 	dd->mmio = pcim_iomap_table(dd->pdev)[MTIP_ABAR];
 
@@ -2623,14 +2674,43 @@ static int mtip_hw_init(struct driver_data *dd)
 			dd->port->mmio + i*0x80 + PORT_SDBV;
 	}
 
-	/* Reset the HBA. */
-	if (mtip_hba_reset(dd) < 0) {
-		dev_err(&dd->pdev->dev,
-			"Card did not reset within timeout\n");
-		rv = -EIO;
+	timetaken = jiffies;
+	timeout = jiffies + msecs_to_jiffies(30000);
+	while (((readl(dd->port->mmio + PORT_SCR_STAT) & 0x0F) != 0x03) &&
+		 time_before(jiffies, timeout)) {
+		mdelay(100);
+	}
+	if (unlikely(mtip_check_surprise_removal(dd->pdev))) {
+		timetaken = jiffies - timetaken;
+		dev_warn(&dd->pdev->dev,
+			"Surprise removal detected at %u ms\n",
+			jiffies_to_msecs(timetaken));
+		rv = -ENODEV;
+		goto out2 ;
+	}
+	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
+		timetaken = jiffies - timetaken;
+		dev_warn(&dd->pdev->dev,
+			"Removal detected at %u ms\n",
+			jiffies_to_msecs(timetaken));
+		rv = -EFAULT;
 		goto out2;
 	}
 
+	/* Conditionally reset the HBA. */
+	if (!(readl(dd->mmio + HOST_CAP) & HOST_CAP_NZDMA)) {
+		if (mtip_hba_reset(dd) < 0) {
+			dev_err(&dd->pdev->dev,
+				"Card did not reset within timeout\n");
+			rv = -EIO;
+			goto out2;
+		}
+	} else {
+		/* Clear any pending interrupts on the HBA */
+		writel(readl(dd->mmio + HOST_IRQ_STAT),
+			dd->mmio + HOST_IRQ_STAT);
+	}
+
 	mtip_init_port(dd->port);
 	mtip_start_port(dd->port);
 
@@ -2660,6 +2740,12 @@ static int mtip_hw_init(struct driver_data *dd)
 	mod_timer(&dd->port->cmd_timer,
 		jiffies + msecs_to_jiffies(MTIP_TIMEOUT_CHECK_PERIOD));
 
+
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)) {
+		rv = -EFAULT;
+		goto out3;
+	}
+
 	if (mtip_get_identify(dd->port, NULL) < 0) {
 		rv = -EFAULT;
 		goto out3;
@@ -2712,9 +2798,12 @@ static int mtip_hw_exit(struct driver_data *dd)
 	 * Send standby immediate (E0h) to the drive so that it
 	 * saves its state.
 	 */
-	if (atomic_read(&dd->drv_cleanup_done) != true) {
+	if (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
 
-		mtip_standby_immediate(dd->port);
+		if (test_bit(MTIP_FLAG_REBUILD_BIT, &dd->dd_flag))
+			if (mtip_standby_immediate(dd->port))
+				dev_warn(&dd->pdev->dev,
+					"STANDBY IMMEDIATE failed\n");
 
 		/* de-initialize the port. */
 		mtip_deinit_port(dd->port);
@@ -2892,6 +2981,9 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)))
+		return -ENOTTY;
+
 	switch (cmd) {
 	case BLKFLSBUF:
 		return -ENOTTY;
@@ -2927,6 +3019,9 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)))
+		return -ENOTTY;
+
 	switch (cmd) {
 	case BLKFLSBUF:
 		return -ENOTTY;
@@ -3049,6 +3144,11 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 	int nents = 0;
 	int tag = 0;
 
+	if (test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag)) {
+		bio_endio(bio, -ENXIO);
+		return;
+	}
+
 	if (unlikely(!bio_has_data(bio))) {
 		blk_queue_flush(queue, 0);
 		bio_endio(bio, 0);
@@ -3061,7 +3161,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 
 		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
 			dev_warn(&dd->pdev->dev,
-				"Maximum number of SGL entries exceeded");
+				"Maximum number of SGL entries exceeded\n");
 			bio_io_error(bio);
 			mtip_hw_release_scatterlist(dd, tag);
 			return;
@@ -3210,8 +3310,10 @@ skip_create_disk:
 		kobject_put(kobj);
 	}
 
-	if (dd->mtip_svc_handler)
+	if (dd->mtip_svc_handler) {
+		set_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag);
 		return rv; /* service thread created for handling rebuild */
+	}
 
 start_service_thread:
 	sprintf(thd_name, "mtip_svc_thd_%02d", index);
@@ -3226,6 +3328,9 @@ start_service_thread:
 		goto kthread_run_error;
 	}
 
+	if (wait_for_rebuild == MTIP_FTL_REBUILD_MAGIC)
+		rv = wait_for_rebuild;
+
 	return rv;
 
 kthread_run_error:
@@ -3272,10 +3377,12 @@ static int mtip_block_remove(struct driver_data *dd)
 	}
 
 	/* Clean up the sysfs attributes managed by the protocol layer. */
-	kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
-	if (kobj) {
-		mtip_hw_sysfs_exit(dd, kobj);
-		kobject_put(kobj);
+	if (test_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag)) {
+		kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
+		if (kobj) {
+			mtip_hw_sysfs_exit(dd, kobj);
+			kobject_put(kobj);
+		}
 	}
 
 	/*
@@ -3359,11 +3466,6 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	}
 
-	/* Set the atomic variable as 1 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
-
-	atomic_set(&dd->resumeflag, false);
-
 	/* Attach the private data to this PCI device.  */
 	pci_set_drvdata(pdev, dd);
 
@@ -3420,7 +3522,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	 * instance number.
 	 */
 	instance++;
-
+	if (rv != MTIP_FTL_REBUILD_MAGIC)
+		set_bit(MTIP_DD_FLAG_INIT_DONE_BIT, &dd->dd_flag);
 	goto done;
 
 block_initialize_err:
@@ -3434,9 +3537,6 @@ iomap_err:
 	pci_set_drvdata(pdev, NULL);
 	return rv;
 done:
-	/* Set the atomic variable as 0 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
-
 	return rv;
 }
 
@@ -3452,8 +3552,10 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	struct driver_data *dd = pci_get_drvdata(pdev);
 	int counter = 0;
 
+	set_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag);
+
 	if (mtip_check_surprise_removal(pdev)) {
-		while (atomic_read(&dd->drv_cleanup_done) == false) {
+		while (!test_bit(MTIP_DD_FLAG_CLEANUP_BIT, &dd->dd_flag)) {
 			counter++;
 			msleep(20);
 			if (counter == 10) {
@@ -3463,8 +3565,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 			}
 		}
 	}
-	/* Set the atomic variable as 1 in case of SRSI */
-	atomic_set(&dd->drv_cleanup_done, true);
 
 	/* Clean up the block layer. */
 	mtip_block_remove(dd);
@@ -3493,7 +3593,7 @@ static int mtip_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 		return -EFAULT;
 	}
 
-	atomic_set(&dd->resumeflag, true);
+	set_bit(MTIP_DD_FLAG_RESUME_BIT, &dd->dd_flag);
 
 	/* Disable ports & interrupts then send standby immediate */
 	rv = mtip_block_suspend(dd);
@@ -3559,7 +3659,7 @@ static int mtip_pci_resume(struct pci_dev *pdev)
 		dev_err(&pdev->dev, "Unable to resume\n");
 
 err:
-	atomic_set(&dd->resumeflag, false);
+	clear_bit(MTIP_DD_FLAG_RESUME_BIT, &dd->dd_flag);
 
 	return rv;
 }
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index e0554a8..f4e46cc 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -121,6 +121,12 @@
 #define MTIP_FLAG_REBUILD_BIT			5
 #define MTIP_FLAG_SVC_THD_SHOULD_STOP_BIT	8
 
+/* below are bit numbers in 'dd_flag' defined in driver_data */
+#define MTIP_DD_FLAG_REMOVE_PENDING_BIT		1
+#define MTIP_DD_FLAG_RESUME_BIT			2
+#define MTIP_DD_FLAG_CLEANUP_BIT		3
+#define MTIP_DD_FLAG_INIT_DONE_BIT		4
+
 /* Register Frame Information Structure (FIS), host to device. */
 struct host_to_dev_fis {
 	/*
@@ -404,13 +410,9 @@ struct driver_data {
 
 	unsigned slot_groups; /* number of slot groups the product supports */
 
-	atomic_t drv_cleanup_done; /* Atomic variable for SRSI */
-
 	unsigned long index; /* Index to determine the disk name */
 
-	unsigned int ftlrebuildflag; /* FTL rebuild flag */
-
-	atomic_t resumeflag; /* Atomic variable to track suspend/resume */
+	unsigned long dd_flag; /* NOTE: use atomic bit operations on this */
 
 	struct task_struct *mtip_svc_handler; /* task_struct of svc thd */
 };
-- 
1.7.1

