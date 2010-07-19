Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966398Ab0GSSl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:41:29 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44400 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966394Ab0GSSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:18 -0400
Subject: [PATCH 25/26] cciss: change printks to dev_warn, etc.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:48 -0500
Message-ID: <20100719184648.7908.19478.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: change printks to dev_warn, etc.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |  314 +++++++++++++++++++-------------------------
 drivers/block/cciss_scsi.c |  159 ++++++++++------------
 2 files changed, 212 insertions(+), 261 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1dc9574..35a9f08 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -922,9 +922,6 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h)
 			return NULL;
 	} while (test_and_set_bit(i & (BITS_PER_LONG - 1),
 		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: using command buffer %d\n", i);
-#endif
 	c = h->cmd_pool + i;
 	memset(c, 0, sizeof(CommandList_struct));
 	cmd_dma_handle = h->cmd_pool_dhandle + i * sizeof(CommandList_struct);
@@ -1026,10 +1023,7 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 	ctlr_info_t *h = get_host(bdev->bd_disk);
 	drive_info_struct *drv = get_drv(bdev->bd_disk);
 
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss_open %s\n", bdev->bd_disk->disk_name);
-#endif				/* CCISS_DEBUG */
-
+	dev_dbg(&h->pdev->dev, "cciss_open %s\n", bdev->bd_disk->disk_name);
 	if (drv->busy_configuring)
 		return -EBUSY;
 	/*
@@ -1081,11 +1075,7 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 	lock_kernel();
 	h = get_host(disk);
 	drv = get_drv(disk);
-
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss_release %s\n", disk->disk_name);
-#endif				/* CCISS_DEBUG */
-
+	dev_dbg(&h->pdev->dev, "cciss_release %s\n", disk->disk_name);
 	drv->usage_count--;
 	h->usage_count--;
 	unlock_kernel();
@@ -1251,10 +1241,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	drive_info_struct *drv = get_drv(disk);
 	void __user *argp = (void __user *)arg;
 
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss_ioctl: Called with cmd=%x %lx\n", cmd, arg);
-#endif				/* CCISS_DEBUG */
-
+	dev_dbg(&h->pdev->dev, "cciss_ioctl: Called with cmd=%x %lx\n",
+		cmd, arg);
 	switch (cmd) {
 	case CCISS_GETPCIINFO:
 		{
@@ -1299,10 +1287,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			    (&intinfo, argp, sizeof(cciss_coalint_struct)))
 				return -EFAULT;
 			if ((intinfo.delay == 0) && (intinfo.count == 0))
-			{
-//                      printk("cciss_ioctl: delay and count cannot be 0\n");
 				return -EINVAL;
-			}
 			spin_lock_irqsave(&h->lock, flags);
 			/* Update the field, and then ring the doorbell */
 			writel(intinfo.delay,
@@ -1814,9 +1799,7 @@ static void cciss_softirq_done(struct request *rq)
 		++sg_index;
 	}
 
-#ifdef CCISS_DEBUG
-	printk("Done with %p\n", rq);
-#endif				/* CCISS_DEBUG */
+	dev_dbg(&h->pdev->dev, "Done with %p\n", rq);
 
 	/* set the residual count for pc requests */
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
@@ -2029,7 +2012,7 @@ static void cciss_update_drive_info(ctlr_info_t *h, int drv_index,
 	 * (unless it's the first disk (for the controller node).
 	 */
 	if (h->drv[drv_index]->raid_level != -1 && drv_index != 0) {
-		printk(KERN_WARNING "disk %d has changed.\n", drv_index);
+		dev_warn(&h->pdev->dev, "disk %d has changed.\n", drv_index);
 		spin_lock_irqsave(&h->lock, flags);
 		h->drv[drv_index]->busy_configuring = 1;
 		spin_unlock_irqrestore(&h->lock, flags);
@@ -2082,8 +2065,8 @@ static void cciss_update_drive_info(ctlr_info_t *h, int drv_index,
 		if (cciss_add_disk(h, disk, drv_index) != 0) {
 			cciss_free_gendisk(h, drv_index);
 			cciss_free_drive_info(h, drv_index);
-			printk(KERN_WARNING "cciss:%d could not update "
-				"disk %d\n", h->ctlr, drv_index);
+			dev_warn(&h->pdev->dev, "could not update disk %d\n",
+				drv_index);
 			--h->num_luns;
 		}
 	}
@@ -2093,7 +2076,7 @@ freeret:
 	kfree(drvinfo);
 	return;
 mem_msg:
-	printk(KERN_ERR "cciss: out of memory\n");
+	dev_err(&h->pdev->dev, "out of memory\n");
 	goto freeret;
 }
 
@@ -2185,9 +2168,9 @@ static int cciss_add_gendisk(ctlr_info_t *h, unsigned char lunid[],
 		h->gendisk[drv_index] =
 			alloc_disk(1 << NWD_SHIFT);
 		if (!h->gendisk[drv_index]) {
-			printk(KERN_ERR "cciss%d: could not "
-				"allocate a new disk %d\n",
-				h->ctlr, drv_index);
+			dev_err(&h->pdev->dev,
+				"could not allocate a new disk %d\n",
+				drv_index);
 			goto err_free_drive_info;
 		}
 	}
@@ -2238,8 +2221,7 @@ static void cciss_add_controller_node(ctlr_info_t *h)
 	cciss_free_gendisk(h, drv_index);
 	cciss_free_drive_info(h, drv_index);
 error:
-	printk(KERN_WARNING "cciss%d: could not "
-		"add disk 0.\n", h->ctlr);
+	dev_warn(&h->pdev->dev, "could not add disk 0.\n");
 	return;
 }
 
@@ -2287,8 +2269,8 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 	if (return_code == IO_OK)
 		listlength = be32_to_cpu(*(__be32 *) ld_buff->LUNListLength);
 	else {	/* reading number of logical volumes failed */
-		printk(KERN_WARNING "cciss: report logical volume"
-		       " command failed\n");
+		dev_warn(&h->pdev->dev,
+			"report logical volume command failed\n");
 		listlength = 0;
 		goto freeret;
 	}
@@ -2296,7 +2278,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 	num_luns = listlength / 8;	/* 8 bytes per entry */
 	if (num_luns > CISS_MAX_LUN) {
 		num_luns = CISS_MAX_LUN;
-		printk(KERN_WARNING "cciss: more luns configured"
+		dev_warn(&h->pdev->dev, "more luns configured"
 		       " on controller than can be handled by"
 		       " this driver.\n");
 	}
@@ -2380,7 +2362,7 @@ freeret:
 	 */
 	return -1;
 mem_msg:
-	printk(KERN_ERR "cciss: out of memory\n");
+	dev_err(&h->pdev->dev, "out of memory\n");
 	h->busy_configuring = 0;
 	goto freeret;
 }
@@ -2587,9 +2569,7 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			c->Request.Timeout = 0;
 			break;
 		default:
-			printk(KERN_WARNING
-			       "cciss%d:  Unknown Command 0x%c\n",
-				h->ctlr, cmd);
+			dev_warn(&h->pdev->dev, "Unknown Command 0x%c\n", cmd);
 			return IO_ERROR;
 		}
 	} else if (cmd_type == TYPE_MSG) {
@@ -2621,14 +2601,12 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			c->Request.CDB[0] = cmd;
 			break;
 		default:
-			printk(KERN_WARNING
-			       "cciss%d: unknown message type %d\n",
-				h->ctlr, cmd);
+			dev_warn(&h->pdev->dev,
+				"unknown message type %d\n", cmd);
 			return IO_ERROR;
 		}
 	} else {
-		printk(KERN_WARNING
-		       "cciss%d: unknown command type %d\n", h->ctlr, cmd_type);
+		dev_warn(&h->pdev->dev, "unknown command type %d\n", cmd_type);
 		return IO_ERROR;
 	}
 	/* Fill in the scatter gather information */
@@ -2656,15 +2634,14 @@ static int check_target_status(ctlr_info_t *h, CommandList_struct *c)
 		default:
 			if (check_for_unit_attention(h, c))
 				return IO_NEEDS_RETRY;
-			printk(KERN_WARNING "cciss%d: cmd 0x%02x "
+			dev_warn(&h->pdev->dev, "cmd 0x%02x "
 				"check condition, sense key = 0x%02x\n",
-				h->ctlr, c->Request.CDB[0],
-				c->err_info->SenseInfo[2]);
+				c->Request.CDB[0], c->err_info->SenseInfo[2]);
 		}
 		break;
 	default:
-		printk(KERN_WARNING "cciss%d: cmd 0x%02x"
-			"scsi status = 0x%02x\n", h->ctlr,
+		dev_warn(&h->pdev->dev, "cmd 0x%02x"
+			"scsi status = 0x%02x\n",
 			c->Request.CDB[0], c->err_info->ScsiStatus);
 		break;
 	}
@@ -2687,43 +2664,42 @@ static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c)
 		/* expected for inquiry and report lun commands */
 		break;
 	case CMD_INVALID:
-		printk(KERN_WARNING "cciss: cmd 0x%02x is "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x is "
 		       "reported invalid\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_PROTOCOL_ERR:
-		printk(KERN_WARNING "cciss: cmd 0x%02x has "
-		       "protocol error \n", c->Request.CDB[0]);
+		dev_warn(&h->pdev->dev, "cmd 0x%02x has "
+		       "protocol error\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_HARDWARE_ERR:
-		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x had "
 		       " hardware error\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_CONNECTION_LOST:
-		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x had "
 		       "connection lost\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_ABORTED:
-		printk(KERN_WARNING "cciss: cmd 0x%02x was "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x was "
 		       "aborted\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_ABORT_FAILED:
-		printk(KERN_WARNING "cciss: cmd 0x%02x reports "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x reports "
 		       "abort failed\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		printk(KERN_WARNING
-		       "cciss%d: unsolicited abort 0x%02x\n", h->ctlr,
+		dev_warn(&h->pdev->dev, "unsolicited abort 0x%02x\n",
 			c->Request.CDB[0]);
 		return_status = IO_NEEDS_RETRY;
 		break;
 	default:
-		printk(KERN_WARNING "cciss: cmd 0x%02x returned "
+		dev_warn(&h->pdev->dev, "cmd 0x%02x returned "
 		       "unknown status %x\n", c->Request.CDB[0],
 		       c->err_info->CommandStatus);
 		return_status = IO_ERROR;
@@ -2751,7 +2727,7 @@ resend_cmd2:
 
 	if (return_status == IO_NEEDS_RETRY &&
 		c->retry_count < MAX_CMD_RETRIES) {
-		printk(KERN_WARNING "cciss%d: retrying 0x%02x\n", h->ctlr,
+		dev_warn(&h->pdev->dev, "retrying 0x%02x\n",
 			c->Request.CDB[0]);
 		c->retry_count++;
 		/* erase the old error information */
@@ -2805,8 +2781,8 @@ static void cciss_geometry_inquiry(ctlr_info_t *h, int logvol,
 			sizeof(*inq_buff), 0xC1, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		if (inq_buff->data_byte[8] == 0xFF) {
-			printk(KERN_WARNING
-			       "cciss: reading geometry failed, volume "
+			dev_warn(&h->pdev->dev,
+			       "reading geometry failed, volume "
 			       "does not support reading geometry\n");
 			drv->heads = 255;
 			drv->sectors = 32;	/* Sectors per track */
@@ -2830,7 +2806,7 @@ static void cciss_geometry_inquiry(ctlr_info_t *h, int logvol,
 			drv->cylinders = real_size;
 		}
 	} else {		/* Get geometry failed */
-		printk(KERN_WARNING "cciss: reading geometry failed\n");
+		dev_warn(&h->pdev->dev, "reading geometry failed\n");
 	}
 }
 
@@ -2844,7 +2820,7 @@ cciss_read_capacity(ctlr_info_t *h, int logvol, sector_t *total_size,
 
 	buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_WARNING "cciss: out of memory\n");
+		dev_warn(&h->pdev->dev, "out of memory\n");
 		return;
 	}
 
@@ -2855,7 +2831,7 @@ cciss_read_capacity(ctlr_info_t *h, int logvol, sector_t *total_size,
 		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
 	} else {		/* read capacity command failed */
-		printk(KERN_WARNING "cciss: read capacity failed\n");
+		dev_warn(&h->pdev->dev, "read capacity failed\n");
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
@@ -2871,7 +2847,7 @@ static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 
 	buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_WARNING "cciss: out of memory\n");
+		dev_warn(&h->pdev->dev, "out of memory\n");
 		return;
 	}
 
@@ -2883,11 +2859,11 @@ static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
 		*block_size = be32_to_cpu(*(__be32 *) buf->block_size);
 	} else {		/* read capacity command failed */
-		printk(KERN_WARNING "cciss: read capacity failed\n");
+		dev_warn(&h->pdev->dev, "read capacity failed\n");
 		*total_size = 0;
 		*block_size = BLOCK_SIZE;
 	}
-	printk(KERN_INFO "      blocks= %llu block_size= %d\n",
+	dev_info(&h->pdev->dev, "      blocks= %llu block_size= %d\n",
 	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
 }
@@ -2915,7 +2891,7 @@ static int cciss_revalidate(struct gendisk *disk)
 
 	inq_buff = kmalloc(sizeof(InquiryData_struct), GFP_KERNEL);
 	if (inq_buff == NULL) {
-		printk(KERN_WARNING "cciss: out of memory\n");
+		dev_warn(&h->pdev->dev, "out of memory\n");
 		return 1;
 	}
 	if (h->cciss_read == CCISS_READ_10) {
@@ -2959,7 +2935,7 @@ static void start_io(ctlr_info_t *h)
 		c = hlist_entry(h->reqQ.first, CommandList_struct, list);
 		/* can't do anything if fifo is full */
 		if ((h->access.fifo_full(h))) {
-			printk(KERN_WARNING "cciss: fifo full\n");
+			dev_warn(&h->pdev->dev, "fifo full\n");
 			break;
 		}
 
@@ -3026,7 +3002,7 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 
 	if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
 		if (cmd->rq->cmd_type != REQ_TYPE_BLOCK_PC)
-			printk(KERN_WARNING "cciss: cmd %p "
+			dev_warn(&h->pdev->dev, "cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
 		return error_value;
@@ -3047,7 +3023,7 @@ static inline int evaluate_target_status(ctlr_info_t *h,
 	/* Not SG_IO or similar? */
 	if (cmd->rq->cmd_type != REQ_TYPE_BLOCK_PC) {
 		if (error_value != 0)
-			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
+			dev_warn(&h->pdev->dev, "cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
 		return error_value;
 	}
@@ -3088,7 +3064,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (cmd->rq->cmd_type == REQ_TYPE_FS) {
-			printk(KERN_WARNING "cciss: cmd %p has"
+			dev_warn(&h->pdev->dev, "cmd %p has"
 			       " completed with data underrun "
 			       "reported\n", cmd);
 			cmd->rq->resid_len = cmd->err_info->ResidualCnt;
@@ -3096,12 +3072,12 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 		break;
 	case CMD_DATA_OVERRUN:
 		if (cmd->rq->cmd_type == REQ_TYPE_FS)
-			printk(KERN_WARNING "cciss: cmd %p has"
+			dev_warn(&h->pdev->dev, "cciss: cmd %p has"
 			       " completed with data overrun "
 			       "reported\n", cmd);
 		break;
 	case CMD_INVALID:
-		printk(KERN_WARNING "cciss: cmd %p is "
+		dev_warn(&h->pdev->dev, "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
@@ -3109,15 +3085,15 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_PROTOCOL_ERR:
-		printk(KERN_WARNING "cciss: cmd %p has "
-		       "protocol error \n", cmd);
+		dev_warn(&h->pdev->dev, "cciss: cmd %p has "
+		       "protocol error\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_HARDWARE_ERR:
-		printk(KERN_WARNING "cciss: cmd %p had "
+		dev_warn(&h->pdev->dev, "cciss: cmd %p had "
 		       " hardware error\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
@@ -3125,7 +3101,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_CONNECTION_LOST:
-		printk(KERN_WARNING "cciss: cmd %p had "
+		dev_warn(&h->pdev->dev, "cciss: cmd %p had "
 		       "connection lost\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
@@ -3133,7 +3109,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_ABORTED:
-		printk(KERN_WARNING "cciss: cmd %p was "
+		dev_warn(&h->pdev->dev, "cciss: cmd %p was "
 		       "aborted\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
@@ -3141,7 +3117,7 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
-		printk(KERN_WARNING "cciss: cmd %p reports "
+		dev_warn(&h->pdev->dev, "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
@@ -3149,31 +3125,29 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		printk(KERN_WARNING "cciss%d: unsolicited "
+		dev_warn(&h->pdev->dev, "cciss%d: unsolicited "
 		       "abort %p\n", h->ctlr, cmd);
 		if (cmd->retry_count < MAX_CMD_RETRIES) {
 			retry_cmd = 1;
-			printk(KERN_WARNING
-			       "cciss%d: retrying %p\n", h->ctlr, cmd);
+			dev_warn(&h->pdev->dev, "retrying %p\n", cmd);
 			cmd->retry_count++;
 		} else
-			printk(KERN_WARNING
-			       "cciss%d: %p retried too "
-			       "many times\n", h->ctlr, cmd);
+			dev_warn(&h->pdev->dev,
+				"%p retried too many times\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 				DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
-		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
+		dev_warn(&h->pdev->dev, "cmd %p timedout\n", cmd);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
 			cmd->err_info->CommandStatus, DRIVER_OK,
 			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
 	default:
-		printk(KERN_WARNING "cciss: cmd %p returned "
+		dev_warn(&h->pdev->dev, "cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
 		rq->errors = make_status_bytes(SAM_STAT_GOOD,
@@ -3282,11 +3256,8 @@ static void do_cciss_request(struct request_queue *q)
 	c->Request.CDB[0] =
 	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
 	start_blk = blk_rq_pos(creq);
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "ciss: sector =%d nr_sectors=%d\n",
+	dev_dbg(&h->pdev->dev, "sector =%d nr_sectors=%d\n",
 	       (int)blk_rq_pos(creq), (int)blk_rq_sectors(creq));
-#endif				/* CCISS_DEBUG */
-
 	sg_init_table(tmp_sg, h->maxsgentries);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
@@ -3326,11 +3297,9 @@ static void do_cciss_request(struct request_queue *q)
 	if (seg > h->maxSG)
 		h->maxSG = seg;
 
-#ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %ld sectors in %d segments "
+	dev_dbg(&h->pdev->dev, "Submitting %u sectors in %d segments "
 			"chained[%d]\n",
 			blk_rq_sectors(creq), seg, chained);
-#endif				/* CCISS_DEBUG */
 
 	c->Header.SGTotal = seg + chained;
 	if (seg <= h->max_cmd_sgentries)
@@ -3373,7 +3342,8 @@ static void do_cciss_request(struct request_queue *q)
 		c->Request.CDBLen = creq->cmd_len;
 		memcpy(c->Request.CDB, creq->cmd, BLK_MAX_CDB);
 	} else {
-		printk(KERN_WARNING "cciss%d: bad request type %d\n", h->ctlr, creq->cmd_type);
+		dev_warn(&h->pdev->dev, "bad request type %d\n",
+			creq->cmd_type);
 		BUG();
 	}
 
@@ -3675,18 +3645,17 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
 
 	switch (c->err_info->SenseInfo[12]) {
 	case STATE_CHANGED:
-		printk(KERN_WARNING "cciss%d: a state change "
-			"detected, command retried\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "a state change "
+			"detected, command retried\n");
 		return 1;
 	break;
 	case LUN_FAILED:
-		printk(KERN_WARNING "cciss%d: LUN failure "
-			"detected, action required\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "LUN failure "
+			"detected, action required\n");
 		return 1;
 	break;
 	case REPORT_LUNS_CHANGED:
-		printk(KERN_WARNING "cciss%d: report LUN data "
-			"changed\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "report LUN data changed\n");
 	/*
 	 * Here, we could call add_to_scan_list and wake up the scan thread,
 	 * except that it's quite likely that we will get more than one
@@ -3706,19 +3675,18 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
 		return 1;
 	break;
 	case POWER_OR_RESET:
-		printk(KERN_WARNING "cciss%d: a power on "
-			"or device reset detected\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"a power on or device reset detected\n");
 		return 1;
 	break;
 	case UNIT_ATTENTION_CLEARED:
-		printk(KERN_WARNING "cciss%d: unit attention "
-		    "cleared by another initiator\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"unit attention cleared by another initiator\n");
 		return 1;
 	break;
 	default:
-		printk(KERN_WARNING "cciss%d: unknown "
-			"unit attention detected\n", h->ctlr);
-				return 1;
+		dev_warn(&h->pdev->dev, "unknown unit attention detected\n");
+		return 1;
 	}
 }
 
@@ -3727,38 +3695,40 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
  *   the io functions.
  *   This is for debug only.
  */
-static void print_cfg_table(CfgTable_struct *tb)
+static void print_cfg_table(ctlr_info_t *h)
 {
-#ifdef CCISS_DEBUG
 	int i;
 	char temp_name[17];
+	CfgTable_struct *tb = h->cfgtable;
 
-	printk("Controller Configuration information\n");
-	printk("------------------------------------\n");
+	dev_dbg(&h->pdev->dev, "Controller Configuration information\n");
+	dev_dbg(&h->pdev->dev, "------------------------------------\n");
 	for (i = 0; i < 4; i++)
 		temp_name[i] = readb(&(tb->Signature[i]));
 	temp_name[4] = '\0';
-	printk("   Signature = %s\n", temp_name);
-	printk("   Spec Number = %d\n", readl(&(tb->SpecValence)));
-	printk("   Transport methods supported = 0x%x\n",
+	dev_dbg(&h->pdev->dev, "   Signature = %s\n", temp_name);
+	dev_dbg(&h->pdev->dev, "   Spec Number = %d\n",
+		readl(&(tb->SpecValence)));
+	dev_dbg(&h->pdev->dev, "   Transport methods supported = 0x%x\n",
 	       readl(&(tb->TransportSupport)));
-	printk("   Transport methods active = 0x%x\n",
+	dev_dbg(&h->pdev->dev, "   Transport methods active = 0x%x\n",
 	       readl(&(tb->TransportActive)));
-	printk("   Requested transport Method = 0x%x\n",
+	dev_dbg(&h->pdev->dev, "   Requested transport Method = 0x%x\n",
 	       readl(&(tb->HostWrite.TransportRequest)));
-	printk("   Coalesce Interrupt Delay = 0x%x\n",
+	dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Delay = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntDelay)));
-	printk("   Coalesce Interrupt Count = 0x%x\n",
+	dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	printk("   Max outstanding commands = 0x%d\n",
+	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
 	       readl(&(tb->CmdsOutMax)));
-	printk("   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
+	dev_dbg(&h->pdev->dev, "   Bus Types = 0x%x\n",
+		readl(&(tb->BusTypes)));
 	for (i = 0; i < 16; i++)
 		temp_name[i] = readb(&(tb->ServerName[i]));
 	temp_name[16] = '\0';
-	printk("   Server Name = %s\n", temp_name);
-	printk("   Heartbeat Counter = 0x%x\n\n\n", readl(&(tb->HeartBeat)));
-#endif				/* CCISS_DEBUG */
+	dev_dbg(&h->pdev->dev, "   Server Name = %s\n", temp_name);
+	dev_dbg(&h->pdev->dev, "   Heartbeat Counter = 0x%x\n\n\n",
+		readl(&(tb->HeartBeat)));
 }
 
 static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
@@ -3783,7 +3753,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
 				offset += 8;
 				break;
 			default:	/* reserved in PCI 2.2 */
-				printk(KERN_WARNING
+				dev_warn(&pdev->dev,
 				       "Base address is invalid\n");
 				return -1;
 				break;
@@ -3908,7 +3878,7 @@ static __devinit void cciss_enter_performant_mode(ctlr_info_t *h)
 	cciss_wait_for_mode_change_ack(h);
 	register_value = readl(&(h->cfgtable->TransportActive));
 	if (!(register_value & CFGTBL_Trans_Performant))
-		printk(KERN_WARNING "cciss: unable to get board into"
+		dev_warn(&h->pdev->dev, "cciss: unable to get board into"
 					" performant mode\n");
 }
 
@@ -3923,14 +3893,13 @@ static void __devinit cciss_put_controller_into_performant_mode(ctlr_info_t *h)
 	if (!(trans_support & PERFORMANT_MODE))
 		return;
 
-	printk(KERN_WARNING "cciss%d: Placing controller into "
-				"performant mode\n", h->ctlr);
+	dev_dbg(&h->pdev->dev, "Placing controller into performant mode\n");
 	/* Performant mode demands commands on a 32 byte boundary
 	 * pci_alloc_consistent aligns on page boundarys already.
 	 * Just need to check if divisible by 32
 	 */
 	if ((sizeof(CommandList_struct) % 32) != 0) {
-		printk(KERN_WARNING "%s %d %s\n",
+		dev_warn(&h->pdev->dev, "%s %d %s\n",
 			"cciss info: command size[",
 			(int)sizeof(CommandList_struct),
 			"] not divisible by 32, no performant mode..\n");
@@ -3995,12 +3964,12 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *h)
 			return;
 		}
 		if (err > 0) {
-			printk(KERN_WARNING "cciss: only %d MSI-X vectors "
-			       "available\n", err);
+			dev_warn(&h->pdev->dev,
+				"only %d MSI-X vectors available\n", err);
 			goto default_int_mode;
 		} else {
-			printk(KERN_WARNING "cciss: MSI-X init failed %d\n",
-			       err);
+			dev_warn(&h->pdev->dev,
+				"MSI-X init failed %d\n", err);
 			goto default_int_mode;
 		}
 	}
@@ -4008,7 +3977,7 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *h)
 		if (!pci_enable_msi(h->pdev))
 			h->msi_vector = 1;
 		else
-			printk(KERN_WARNING "cciss: MSI init failed\n");
+			dev_warn(&h->pdev->dev, "MSI init failed\n");
 	}
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
@@ -4210,28 +4179,24 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 	h->access = *(products[prod_index].access);
 
 	if (cciss_board_disabled(h)) {
-		printk(KERN_WARNING
-		       "cciss: controller appears to be disabled\n");
+		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
 	err = pci_enable_device(h->pdev);
 	if (err) {
-		printk(KERN_ERR "cciss: Unable to Enable PCI device\n");
+		dev_warn(&h->pdev->dev, "Unable to Enable PCI device\n");
 		return err;
 	}
 
 	err = pci_request_regions(h->pdev, "cciss");
 	if (err) {
-		printk(KERN_ERR "cciss: Cannot obtain PCI resources, "
-		       "aborting\n");
+		dev_warn(&h->pdev->dev,
+			"Cannot obtain PCI resources, aborting\n");
 		return err;
 	}
 
-#ifdef CCISS_DEBUG
-	printk(KERN_INFO "command = %x\n", command);
-	printk(KERN_INFO "irq = %x\n", h->pdev->irq);
-	printk(KERN_INFO "board_id = %x\n", h->board_id);
-#endif				/* CCISS_DEBUG */
+	dev_dbg(&h->pdev->dev, "irq = %x\n", h->pdev->irq);
+	dev_dbg(&h->pdev->dev, "board_id = %x\n", h->board_id);
 
 /* If the kernel supports MSI/MSI-X we will try to enable that functionality,
  * else we use the IO-APIC interrupt assigned to us by system ROM.
@@ -4251,7 +4216,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
 	err = cciss_find_cfgtables(h);
 	if (err)
 		goto err_out_free_res;
-	print_cfg_table(h->cfgtable);
+	print_cfg_table(h);
 	cciss_find_board_params(h);
 
 	if (!CISS_signature_present(h)) {
@@ -4281,7 +4246,7 @@ err_out_free_res:
 /* Function to find the first free pointer into our hba[] array
  * Returns -1 if no free entries are left.
  */
-static int alloc_cciss_hba(void)
+static int alloc_cciss_hba(struct pci_dev *pdev)
 {
 	int i;
 
@@ -4296,11 +4261,11 @@ static int alloc_cciss_hba(void)
 			return i;
 		}
 	}
-	printk(KERN_WARNING "cciss: This driver supports a maximum"
+	dev_warn(&pdev->dev, "This driver supports a maximum"
 	       " of %d controllers.\n", MAX_CTLR);
 	return -1;
 Enomem:
-	printk(KERN_ERR "cciss: out of memory.\n");
+	dev_warn(&pdev->dev, "out of memory.\n");
 	return -1;
 }
 
@@ -4388,7 +4353,8 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 	/* we leak the DMA buffer here ... no choice since the controller could
 	   still complete the command. */
 	if (i == 10) {
-		printk(KERN_ERR "cciss: controller message %02x:%02x timed out\n",
+		dev_err(&pdev->dev,
+			"controller message %02x:%02x timed out\n",
 			opcode, type);
 		return -ETIMEDOUT;
 	}
@@ -4396,12 +4362,12 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 	pci_free_consistent(pdev, cmd_sz, cmd, paddr64);
 
 	if (tag & 2) {
-		printk(KERN_ERR "cciss: controller message %02x:%02x failed\n",
+		dev_err(&pdev->dev, "controller message %02x:%02x failed\n",
 			opcode, type);
 		return -EIO;
 	}
 
-	printk(KERN_INFO "cciss: controller message %02x:%02x succeeded\n",
+	dev_info(&pdev->dev, "controller message %02x:%02x succeeded\n",
 		opcode, type);
 	return 0;
 }
@@ -4422,7 +4388,7 @@ static __devinit int cciss_reset_msi(struct pci_dev *pdev)
 	if (pos) {
 		pci_read_config_word(pdev, msi_control_reg(pos), &control);
 		if (control & PCI_MSI_FLAGS_ENABLE) {
-			printk(KERN_INFO "cciss: resetting MSI\n");
+			dev_info(&pdev->dev, "resetting MSI\n");
 			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSI_FLAGS_ENABLE);
 		}
 	}
@@ -4431,7 +4397,7 @@ static __devinit int cciss_reset_msi(struct pci_dev *pdev)
 	if (pos) {
 		pci_read_config_word(pdev, msi_control_reg(pos), &control);
 		if (control & PCI_MSIX_FLAGS_ENABLE) {
-			printk(KERN_INFO "cciss: resetting MSI-X\n");
+			dev_info(&pdev->dev, "resetting MSI-X\n");
 			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSIX_FLAGS_ENABLE);
 		}
 	}
@@ -4664,7 +4630,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	rc = cciss_init_reset_devices(pdev);
 	if (rc)
 		return rc;
-	i = alloc_cciss_hba();
+	i = alloc_cciss_hba(pdev);
 	if (i < 0)
 		return -1;
 
@@ -4692,7 +4658,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
 		dac = 0;
 	else {
-		printk(KERN_ERR "cciss: no suitable DMA available\n");
+		dev_err(&h->pdev->dev, "no suitable DMA available\n");
 		goto clean1;
 	}
 
@@ -4705,8 +4671,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		h->major = COMPAQ_CISS_MAJOR + i;
 	rc = register_blkdev(h->major, h->devname);
 	if (rc == -EBUSY || rc == -EINVAL) {
-		printk(KERN_ERR
-		       "cciss:  Unable to get major number %d for %s "
+		dev_err(&h->pdev->dev,
+		       "Unable to get major number %d for %s "
 		       "on hba %d\n", h->major, h->devname, i);
 		goto clean1;
 	} else {
@@ -4720,20 +4686,20 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		if (request_irq(h->intr[PERF_MODE_INT],
 				do_cciss_msix_intr,
 				IRQF_DISABLED, h->devname, h)) {
-			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
+			dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
 			       h->intr[PERF_MODE_INT], h->devname);
 			goto clean2;
 		}
 	} else {
 		if (request_irq(h->intr[PERF_MODE_INT], do_cciss_intx,
 				IRQF_DISABLED, h->devname, h)) {
-			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
+			dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
 			       h->intr[PERF_MODE_INT], h->devname);
 			goto clean2;
 		}
 	}
 
-	printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
+	dev_info(&h->pdev->dev, "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
 	       h->devname, pdev->device, pci_name(pdev),
 	       h->intr[PERF_MODE_INT], dac ? "" : " not");
 
@@ -4751,7 +4717,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	if ((h->cmd_pool_bits == NULL)
 	    || (h->cmd_pool == NULL)
 	    || (h->errinfo_pool == NULL)) {
-		printk(KERN_ERR "cciss: out of memory");
+		dev_err(&h->pdev->dev, "out of memory");
 		goto clean4;
 	}
 
@@ -4764,8 +4730,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 							h->maxsgentries,
 							GFP_KERNEL);
 		if (h->scatter_list[k] == NULL) {
-			printk(KERN_ERR "cciss%d: could not allocate "
-				"s/g lists\n", i);
+			dev_err(&h->pdev->dev,
+				"could not allocate s/g lists\n");
 			goto clean4;
 		}
 	}
@@ -4800,7 +4766,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	/* Get the firmware version */
 	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
 	if (inq_buff == NULL) {
-		printk(KERN_ERR "cciss: out of memory\n");
+		dev_err(&h->pdev->dev, "out of memory\n");
 		goto clean4;
 	}
 
@@ -4812,7 +4778,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		h->firm_ver[2] = inq_buff->data_byte[34];
 		h->firm_ver[3] = inq_buff->data_byte[35];
 	} else {	 /* send command failed */
-		printk(KERN_WARNING "cciss: unable to determine firmware"
+		dev_warn(&h->pdev->dev, "unable to determine firmware"
 			" version of controller\n");
 	}
 	kfree(inq_buff);
@@ -4869,9 +4835,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 	h = pci_get_drvdata(pdev);
 	flush_buf = kzalloc(4, GFP_KERNEL);
 	if (!flush_buf) {
-		printk(KERN_WARNING
-			"cciss:%d cache not flushed, out of memory.\n",
-			h->ctlr);
+		dev_warn(&h->pdev->dev, "cache not flushed, out of memory.\n");
 		return;
 	}
 	/* write all data in the battery backed cache to disk */
@@ -4880,8 +4844,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 		4, 0, CTLR_LUNID, TYPE_CMD);
 	kfree(flush_buf);
 	if (return_code != IO_OK)
-		printk(KERN_WARNING "cciss%d: Error flushing cache\n",
-			h->ctlr);
+		dev_warn(&h->pdev->dev, "Error flushing cache\n");
 	h->access.set_intr_mask(h, CCISS_INTR_OFF);
 	free_irq(h->intr[PERF_MODE_INT], h);
 }
@@ -4892,15 +4855,14 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	int i, j;
 
 	if (pci_get_drvdata(pdev) == NULL) {
-		printk(KERN_ERR "cciss: Unable to remove device \n");
+		dev_err(&pdev->dev, "Unable to remove device\n");
 		return;
 	}
 
 	h = pci_get_drvdata(pdev);
 	i = h->ctlr;
 	if (hba[i] == NULL) {
-		printk(KERN_ERR "cciss: device appears to "
-		       "already be removed\n");
+		dev_err(&pdev->dev, "device appears to already be removed\n");
 		return;
 	}
 
@@ -5021,8 +4983,8 @@ static void __exit cciss_cleanup(void)
 	/* double check that all controller entrys have been removed */
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (hba[i] != NULL) {
-			printk(KERN_WARNING "cciss: had to remove"
-			       " controller %d\n", i);
+			dev_warn(&hba[i]->pdev->dev,
+				"had to remove controller\n");
 			cciss_remove_one(hba[i]->pdev);
 		}
 	}
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 9fe0d8f..575495f 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -192,7 +192,8 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
 	stk = &sa->cmd_stack; 
 	stk->top++;
 	if (stk->top >= CMD_STACK_SIZE) {
-		printk("cciss: scsi_cmd_free called too many times.\n");
+		dev_err(&h->pdev->dev,
+			"scsi_cmd_free called too many times.\n");
 		BUG();
 	}
 	stk->elem[stk->top] = (struct cciss_scsi_cmd_stack_elem_t *) c;
@@ -245,10 +246,9 @@ scsi_cmd_stack_free(ctlr_info_t *h)
 	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 	if (stk->top != CMD_STACK_SIZE-1) {
-		printk( "cciss: %d scsi commands are still outstanding.\n",
+		dev_warn(&h->pdev->dev,
+			"bug: %d scsi commands are still outstanding.\n",
 			CMD_STACK_SIZE - stk->top);
-		// BUG();
-		printk("WE HAVE A BUG HERE!!! stk=0x%p\n", stk);
 	}
 	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
 
@@ -382,8 +382,8 @@ cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
 	unsigned char addr1[8], addr2[8];
 
 	if (n >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
-		printk("cciss%d: Too many devices, "
-			"some will be inaccessible.\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "Too many devices, "
+			"some will be inaccessible.\n");
 		return -1;
 	}
 
@@ -439,8 +439,8 @@ cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
 	   know our hostno and we don't want to print anything first 
 	   time anyway (the scsi layer's inquiries will show that info) */
 	if (hostno != -1)
-		printk("cciss%d: %s device c%db%dt%dl%d added.\n", 
-			h->ctlr, scsi_device_type(sd->devtype), hostno,
+		dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d added.\n",
+			scsi_device_type(sd->devtype), hostno,
 			sd->bus, sd->target, sd->lun);
 	return 0;
 }
@@ -462,8 +462,8 @@ cciss_scsi_remove_entry(ctlr_info_t *h, int hostno, int entry,
 	for (i = entry; i < ccissscsi[h->ctlr].ndevices-1; i++)
 		ccissscsi[h->ctlr].dev[i] = ccissscsi[h->ctlr].dev[i+1];
 	ccissscsi[h->ctlr].ndevices--;
-	printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-		h->ctlr, scsi_device_type(sd.devtype), hostno,
+	dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d removed.\n",
+		scsi_device_type(sd.devtype), hostno,
 			sd.bus, sd.target, sd.lun);
 }
 
@@ -536,8 +536,8 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 			GFP_KERNEL);
 
 	if (!added || !removed) {
-		printk(KERN_WARNING "cciss%d: Out of memory in "
-			"adjust_cciss_scsi_table\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			"Out of memory in adjust_cciss_scsi_table\n");
 		goto free_and_out;
 	}
 
@@ -568,17 +568,14 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 
 		if (found == 0) { /* device no longer present. */ 
 			changes++;
-			/* printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-				h->ctlr, scsi_device_type(csd->devtype), hostno,
-					csd->bus, csd->target, csd->lun); */
 			cciss_scsi_remove_entry(h, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
 		} else if (found == 1) { /* device is different in some way */
 			changes++;
-			printk("cciss%d: device c%db%dt%dl%d has changed.\n",
-				h->ctlr, hostno,
-				csd->bus, csd->target, csd->lun);
+			dev_info(&h->pdev->dev,
+				"device c%db%dt%dl%d has changed.\n",
+				hostno, csd->bus, csd->target, csd->lun);
 			cciss_scsi_remove_entry(h, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
@@ -623,8 +620,8 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 		} else if (found == 1) {
 			/* should never happen... */
 			changes++;
-			printk(KERN_WARNING "cciss%d: device "
-				"unexpectedly changed\n", h->ctlr);
+			dev_warn(&h->pdev->dev,
+				"device unexpectedly changed\n");
 			/* but if it does happen, we just ignore that device */
 		}
 	}
@@ -648,9 +645,9 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 			/* We don't expect to get here. */
 			/* future cmds to this device will get selection */
 			/* timeout as if the device was gone. */
-			printk(KERN_WARNING "cciss%d: didn't find "
+			dev_warn(&h->pdev->dev, "didn't find "
 				"c%db%dt%dl%d\n for removal.",
-				h->ctlr, hostno, removed[i].bus,
+				hostno, removed[i].bus,
 				removed[i].target, removed[i].lun);
 		}
 	}
@@ -662,10 +659,9 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 			added[i].target, added[i].lun);
 		if (rc == 0)
 			continue;
-		printk(KERN_WARNING "cciss%d: scsi_add_device "
+		dev_warn(&h->pdev->dev, "scsi_add_device "
 			"c%db%dt%dl%d failed, device not added.\n",
-			h->ctlr, hostno,
-			added[i].bus, added[i].target, added[i].lun);
+			hostno, added[i].bus, added[i].target, added[i].lun);
 		/* now we have to remove it from ccissscsi, */
 		/* since it didn't get added to scsi mid layer */
 		fixup_botched_add(h, added[i].scsi3addr);
@@ -788,7 +784,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 			case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
 			break;
 			case CMD_DATA_OVERRUN:
-				printk(KERN_WARNING "cciss: %p has"
+				dev_warn(&h->pdev->dev, "%p has"
 					" completed with data overrun "
 					"reported\n", c);
 			break;
@@ -804,43 +800,41 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
-				printk(KERN_WARNING "cciss: %p has "
-					"protocol error\n", c);
+				dev_warn(&h->pdev->dev,
+					"%p has protocol error\n", c);
                         break;
 			case CMD_HARDWARE_ERR:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: %p had "
-					" hardware error\n", c);
+				dev_warn(&h->pdev->dev,
+					"%p had hardware error\n", c);
                         break;
 			case CMD_CONNECTION_LOST:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: %p had "
-					"connection lost\n", c);
+				dev_warn(&h->pdev->dev,
+					"%p had connection lost\n", c);
 			break;
 			case CMD_ABORTED:
 				cmd->result = DID_ABORT << 16;
-				printk(KERN_WARNING "cciss: %p was "
-					"aborted\n", c);
+				dev_warn(&h->pdev->dev, "%p was aborted\n", c);
 			break;
 			case CMD_ABORT_FAILED:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: %p reports "
-					"abort failed\n", c);
+				dev_warn(&h->pdev->dev,
+					"%p reports abort failed\n", c);
 			break;
 			case CMD_UNSOLICITED_ABORT:
 				cmd->result = DID_ABORT << 16;
-				printk(KERN_WARNING "cciss: %p aborted "
-					"do to an unsolicited abort\n", c);
+				dev_warn(&h->pdev->dev, "%p aborted do to an "
+					"unsolicited abort\n", c);
 			break;
 			case CMD_TIMEOUT:
 				cmd->result = DID_TIME_OUT << 16;
-				printk(KERN_WARNING "cciss: %p timedout\n",
-					c);
+				dev_warn(&h->pdev->dev, "%p timedout\n", c);
 			break;
 			default:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: %p returned "
-					"unknown status %x\n", c,
+				dev_warn(&h->pdev->dev,
+					"%p returned unknown status %x\n", c,
 						ei->CommandStatus); 
 		}
 	}
@@ -956,7 +950,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
 }
 
 static void 
-cciss_scsi_interpret_error(CommandList_struct *c)
+cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
 {
 	ErrorInfo_struct *ei;
 
@@ -964,67 +958,64 @@ cciss_scsi_interpret_error(CommandList_struct *c)
 	switch(ei->CommandStatus)
 	{
 		case CMD_TARGET_STATUS:
-			printk(KERN_WARNING "cciss: cmd %p has "
-				"completed with errors\n", c);
-			printk(KERN_WARNING "cciss: cmd %p "
-				"has SCSI Status = %x\n",
-					c, ei->ScsiStatus);
+			dev_warn(&h->pdev->dev,
+				"cmd %p has completed with errors\n", c);
+			dev_warn(&h->pdev->dev,
+				"cmd %p has SCSI Status = %x\n",
+				c, ei->ScsiStatus);
 			if (ei->ScsiStatus == 0)
-				printk(KERN_WARNING 
-				"cciss:SCSI status is abnormally zero.  "
+				dev_warn(&h->pdev->dev,
+				"SCSI status is abnormally zero.  "
 				"(probably indicates selection timeout "
 				"reported incorrectly due to a known "
 				"firmware bug, circa July, 2001.)\n");
 		break;
 		case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
-			printk("UNDERRUN\n");
+			dev_info(&h->pdev->dev, "UNDERRUN\n");
 		break;
 		case CMD_DATA_OVERRUN:
-			printk(KERN_WARNING "cciss: %p has"
+			dev_warn(&h->pdev->dev, "%p has"
 				" completed with data overrun "
 				"reported\n", c);
 		break;
 		case CMD_INVALID: {
 			/* controller unfortunately reports SCSI passthru's */
 			/* to non-existent targets as invalid commands. */
-			printk(KERN_WARNING "cciss: %p is "
-				"reported invalid (probably means "
+			dev_warn(&h->pdev->dev,
+				"%p is reported invalid (probably means "
 				"target device no longer present)\n", c);
 			/* print_bytes((unsigned char *) c, sizeof(*c), 1, 0);
 			print_cmd(c);  */
 			}
 		break;
 		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: %p has "
-				"protocol error\n", c);
+			dev_warn(&h->pdev->dev, "%p has protocol error\n", c);
 		break;
 		case CMD_HARDWARE_ERR:
 			/* cmd->result = DID_ERROR << 16; */
-			printk(KERN_WARNING "cciss: %p had "
-				" hardware error\n", c);
+			dev_warn(&h->pdev->dev, "%p had hardware error\n", c);
 		break;
 		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: %p had "
-				"connection lost\n", c);
+			dev_warn(&h->pdev->dev, "%p had connection lost\n", c);
 		break;
 		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: %p was "
-				"aborted\n", c);
+			dev_warn(&h->pdev->dev, "%p was aborted\n", c);
 		break;
 		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: %p reports "
-				"abort failed\n", c);
+			dev_warn(&h->pdev->dev,
+				"%p reports abort failed\n", c);
 		break;
 		case CMD_UNSOLICITED_ABORT:
-			printk(KERN_WARNING "cciss: %p aborted "
-				"do to an unsolicited abort\n", c);
+			dev_warn(&h->pdev->dev,
+				"%p aborted do to an unsolicited abort\n", c);
 		break;
 		case CMD_TIMEOUT:
-			printk(KERN_WARNING "cciss: %p timedout\n", c);
+			dev_warn(&h->pdev->dev, "%p timedout\n", c);
 		break;
 		default:
-			printk(KERN_WARNING "cciss: %p returned "
-				"unknown status %x\n", c, ei->CommandStatus);
+			dev_warn(&h->pdev->dev,
+				"%p returned unknown status %x\n",
+				c, ei->CommandStatus);
 	}
 }
 
@@ -1063,7 +1054,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char *scsi3addr,
 
 	if (ei->CommandStatus != 0 && 
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-		cciss_scsi_interpret_error(c);
+		cciss_scsi_interpret_error(h, c);
 		rc = -1;
 	}
 	spin_lock_irqsave(&h->lock, flags);
@@ -1134,7 +1125,7 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && 
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-		cciss_scsi_interpret_error(c);
+		cciss_scsi_interpret_error(h, c);
 		rc = -1;
 	}
 	spin_lock_irqsave(&h->lock, flags);
@@ -1446,7 +1437,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 	c = scsi_cmd_alloc(h);
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
-		printk("scsi_cmd_alloc returned NULL!\n");
+		dev_warn(&h->pdev->dev, "scsi_cmd_alloc returned NULL!\n");
 		/* FIXME: next 3 lines are -> BAD! <- */
 		cmd->result = DID_NO_CONNECT << 16;
 		done(cmd);
@@ -1502,7 +1493,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		break;
 
 	  default: 
-		printk("cciss: unknown data direction: %d\n", 
+		dev_warn(&h->pdev->dev, "unknown data direction: %d\n",
 			cmd->sc_data_direction);
 		BUG();
 		break;
@@ -1552,8 +1543,7 @@ static int cciss_engage_scsi(ctlr_info_t *h)
 	stk = &sa->cmd_stack; 
 
 	if (sa->registered) {
-		printk(KERN_INFO "cciss%d: SCSI subsystem already engaged.\n",
-			h->ctlr);
+		dev_info(&h->pdev->dev, "SCSI subsystem already engaged.\n");
 		spin_unlock_irqrestore(&h->lock, flags);
 		return -ENXIO;
 	}
@@ -1586,8 +1576,8 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
 
 	c = cmd_alloc(h);
 	if (!c) {
-		printk(KERN_WARNING "cciss%d: out of memory in "
-			"wait_for_device_to_become_ready.\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "out of memory in "
+			"wait_for_device_to_become_ready.\n");
 		return IO_ERROR;
 	}
 
@@ -1631,16 +1621,16 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
 			}
 		}
 retry_tur:
-		printk(KERN_WARNING "cciss%d: Waiting %d secs "
+		dev_warn(&h->pdev->dev, "Waiting %d secs "
 			"for device to become ready.\n",
-			h->ctlr, waittime / HZ);
+			waittime / HZ);
 		rc = 1; /* device not ready. */
 	}
 
 	if (rc)
-		printk("cciss%d: giving up on device.\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "giving up on device.\n");
 	else
-		printk(KERN_WARNING "cciss%d: device is ready.\n", h->ctlr);
+		dev_warn(&h->pdev->dev, "device is ready.\n");
 
 	cmd_free(h, c);
 	return rc;
@@ -1668,8 +1658,7 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	h = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
 	if (h == NULL) /* paranoia */
 		return FAILED;
-	printk(KERN_WARNING
-		"cciss%d: resetting tape drive or medium changer.\n", h->ctlr);
+	dev_warn(&h->pdev->dev, "resetting tape drive or medium changer.\n");
 	/* find the command that's giving us trouble */
 	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_in_trouble == NULL) /* paranoia */
@@ -1680,7 +1669,7 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		TYPE_MSG);
 	if (rc == 0 && wait_for_device_to_become_ready(h, lunaddr) == 0)
 		return SUCCESS;
-	printk(KERN_WARNING "cciss%d: resetting device failed.\n", h->ctlr);
+	dev_warn(&h->pdev->dev, "resetting device failed.\n");
 	return FAILED;
 }
 
@@ -1695,7 +1684,7 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 	h = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
 	if (h == NULL) /* paranoia */
 		return FAILED;
-	printk(KERN_WARNING "cciss%d: aborting tardy SCSI cmd\n", h->ctlr);
+	dev_warn(&h->pdev->dev, "aborting tardy SCSI cmd\n");
 
 	/* find the command to be aborted */
 	cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;

