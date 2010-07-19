Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966390Ab0GSSmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:42:22 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44215 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965648Ab0GSSlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:07 -0400
Subject: [PATCH 23/26] cciss: use consistent variable names
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:38 -0500
Message-ID: <20100719184638.7908.83380.stgit@beardog.cce.hp.com>
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

cciss: use consistent variable names
"h", for the hba structure and "c" for the command structures.
and get rid of trivial CCISS_LOCK macro.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |  611 ++++++++++++++++++++++----------------------
 drivers/block/cciss.h      |    2 
 drivers/block/cciss_scsi.c |  591 +++++++++++++++++++++----------------------
 3 files changed, 592 insertions(+), 612 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 2abe6df..70ad24f 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -191,17 +191,17 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time, int via_ioctl);
 static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all, int via_ioctl);
 
-static void cciss_read_capacity(int ctlr, int logvol,
+static void cciss_read_capacity(ctlr_info_t *h, int logvol,
 			sector_t *total_size, unsigned int *block_size);
-static void cciss_read_capacity_16(int ctlr, int logvol,
+static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 			sector_t *total_size, unsigned int *block_size);
-static void cciss_geometry_inquiry(int ctlr, int logvol,
+static void cciss_geometry_inquiry(ctlr_info_t *h, int logvol,
 			sector_t total_size,
 			unsigned int block_size, InquiryData_struct *inq_buff,
 				   drive_info_struct *drv);
 static void __devinit cciss_interrupt_mode(ctlr_info_t *);
 static void start_io(ctlr_info_t *h);
-static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
+static int sendcmd_withirq(ctlr_info_t *h, __u8 cmd, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
 			int cmd_type);
 static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
@@ -229,9 +229,9 @@ static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
 static void cciss_put_controller_into_performant_mode(ctlr_info_t *h);
 
 #ifdef CONFIG_PROC_FS
-static void cciss_procinit(int i);
+static void cciss_procinit(ctlr_info_t *h);
 #else
-static void cciss_procinit(int i)
+static void cciss_procinit(ctlr_info_t *h)
 {
 }
 #endif				/* CONFIG_PROC_FS */
@@ -416,26 +416,25 @@ static void cciss_seq_show_header(struct seq_file *seq)
 		h->maxQsinceinit, h->max_outstanding, h->maxSG);
 
 #ifdef CONFIG_CISS_SCSI_TAPE
-	cciss_seq_tape_report(seq, h->ctlr);
+	cciss_seq_tape_report(seq, h);
 #endif /* CONFIG_CISS_SCSI_TAPE */
 }
 
 static void *cciss_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	ctlr_info_t *h = seq->private;
-	unsigned ctlr = h->ctlr;
 	unsigned long flags;
 
 	/* prevent displaying bogus info during configuration
 	 * or deconfiguration of a logical volume
 	 */
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring) {
-		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return ERR_PTR(-EBUSY);
 	}
 	h->busy_configuring = 1;
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (*pos == 0)
 		cciss_seq_show_header(seq);
@@ -543,7 +542,7 @@ cciss_proc_write(struct file *file, const char __user *buf,
 		struct seq_file *seq = file->private_data;
 		ctlr_info_t *h = seq->private;
 
-		err = cciss_engage_scsi(h->ctlr);
+		err = cciss_engage_scsi(h);
 		if (err == 0)
 			err = length;
 	} else
@@ -566,7 +565,7 @@ static const struct file_operations cciss_proc_fops = {
 	.write	 = cciss_proc_write,
 };
 
-static void __devinit cciss_procinit(int i)
+static void __devinit cciss_procinit(ctlr_info_t *h)
 {
 	struct proc_dir_entry *pde;
 
@@ -574,9 +573,9 @@ static void __devinit cciss_procinit(int i)
 		proc_cciss = proc_mkdir("driver/cciss", NULL);
 	if (!proc_cciss)
 		return;
-	pde = proc_create_data(hba[i]->devname, S_IWUSR | S_IRUSR | S_IRGRP |
+	pde = proc_create_data(h->devname, S_IWUSR | S_IRUSR | S_IRGRP |
 					S_IROTH, proc_cciss,
-					&cciss_proc_fops, hba[i]);
+					&cciss_proc_fops, h);
 }
 #endif				/* CONFIG_PROC_FS */
 
@@ -609,12 +608,12 @@ static ssize_t dev_show_unique_id(struct device *dev,
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring)
 		ret = -EBUSY;
 	else
 		memcpy(sn, drv->serial_no, sizeof(sn));
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (ret)
 		return ret;
@@ -639,12 +638,12 @@ static ssize_t dev_show_vendor(struct device *dev,
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring)
 		ret = -EBUSY;
 	else
 		memcpy(vendor, drv->vendor, VENDOR_LEN + 1);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (ret)
 		return ret;
@@ -663,12 +662,12 @@ static ssize_t dev_show_model(struct device *dev,
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring)
 		ret = -EBUSY;
 	else
 		memcpy(model, drv->model, MODEL_LEN + 1);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (ret)
 		return ret;
@@ -687,12 +686,12 @@ static ssize_t dev_show_rev(struct device *dev,
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring)
 		ret = -EBUSY;
 	else
 		memcpy(rev, drv->rev, REV_LEN + 1);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	if (ret)
 		return ret;
@@ -709,17 +708,17 @@ static ssize_t cciss_show_lunid(struct device *dev,
 	unsigned long flags;
 	unsigned char lunid[8];
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -EBUSY;
 	}
 	if (!drv->heads) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -ENOTTY;
 	}
 	memcpy(lunid, drv->LunID, sizeof(lunid));
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return snprintf(buf, 20, "0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 		lunid[0], lunid[1], lunid[2], lunid[3],
 		lunid[4], lunid[5], lunid[6], lunid[7]);
@@ -734,13 +733,13 @@ static ssize_t cciss_show_raid_level(struct device *dev,
 	int raid;
 	unsigned long flags;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -EBUSY;
 	}
 	raid = drv->raid_level;
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (raid < 0 || raid > RAID_UNKNOWN)
 		raid = RAID_UNKNOWN;
 
@@ -757,13 +756,13 @@ static ssize_t cciss_show_usage_count(struct device *dev,
 	unsigned long flags;
 	int count;
 
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -EBUSY;
 	}
 	count = drv->usage_count;
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return snprintf(buf, 20, "%d\n", count);
 }
 static DEVICE_ATTR(usage_count, S_IRUGO, cciss_show_usage_count, NULL);
@@ -1012,7 +1011,7 @@ static inline drive_info_struct *get_drv(struct gendisk *disk)
  */
 static int cciss_open(struct block_device *bdev, fmode_t mode)
 {
-	ctlr_info_t *host = get_host(bdev->bd_disk);
+	ctlr_info_t *h = get_host(bdev->bd_disk);
 	drive_info_struct *drv = get_drv(bdev->bd_disk);
 
 #ifdef CCISS_DEBUG
@@ -1044,7 +1043,7 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 			return -EPERM;
 	}
 	drv->usage_count++;
-	host->usage_count++;
+	h->usage_count++;
 	return 0;
 }
 
@@ -1064,11 +1063,11 @@ static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode)
  */
 static int cciss_release(struct gendisk *disk, fmode_t mode)
 {
-	ctlr_info_t *host;
+	ctlr_info_t *h;
 	drive_info_struct *drv;
 
 	lock_kernel();
-	host = get_host(disk);
+	h = get_host(disk);
 	drv = get_drv(disk);
 
 #ifdef CCISS_DEBUG
@@ -1076,7 +1075,7 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 #endif				/* CCISS_DEBUG */
 
 	drv->usage_count--;
-	host->usage_count--;
+	h->usage_count--;
 	unlock_kernel();
 	return 0;
 }
@@ -1223,11 +1222,11 @@ static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-static void check_ioctl_unit_attention(ctlr_info_t *host, CommandList_struct *c)
+static void check_ioctl_unit_attention(ctlr_info_t *h, CommandList_struct *c)
 {
 	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
 			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
-		(void)check_for_unit_attention(host, c);
+		(void)check_for_unit_attention(h, c);
 }
 /*
  * ioctl
@@ -1236,9 +1235,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	ctlr_info_t *host = get_host(disk);
+	ctlr_info_t *h = get_host(disk);
 	drive_info_struct *drv = get_drv(disk);
-	int ctlr = host->ctlr;
 	void __user *argp = (void __user *)arg;
 
 #ifdef CCISS_DEBUG
@@ -1252,10 +1250,10 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 
 			if (!arg)
 				return -EINVAL;
-			pciinfo.domain = pci_domain_nr(host->pdev->bus);
-			pciinfo.bus = host->pdev->bus->number;
-			pciinfo.dev_fn = host->pdev->devfn;
-			pciinfo.board_id = host->board_id;
+			pciinfo.domain = pci_domain_nr(h->pdev->bus);
+			pciinfo.bus = h->pdev->bus->number;
+			pciinfo.dev_fn = h->pdev->devfn;
+			pciinfo.board_id = h->board_id;
 			if (copy_to_user
 			    (argp, &pciinfo, sizeof(cciss_pci_info_struct)))
 				return -EFAULT;
@@ -1267,9 +1265,9 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			if (!arg)
 				return -EINVAL;
 			intinfo.delay =
-			    readl(&host->cfgtable->HostWrite.CoalIntDelay);
+			    readl(&h->cfgtable->HostWrite.CoalIntDelay);
 			intinfo.count =
-			    readl(&host->cfgtable->HostWrite.CoalIntCount);
+			    readl(&h->cfgtable->HostWrite.CoalIntCount);
 			if (copy_to_user
 			    (argp, &intinfo, sizeof(cciss_coalint_struct)))
 				return -EFAULT;
@@ -1293,22 +1291,22 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 //                      printk("cciss_ioctl: delay and count cannot be 0\n");
 				return -EINVAL;
 			}
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+			spin_lock_irqsave(&h->lock, flags);
 			/* Update the field, and then ring the doorbell */
 			writel(intinfo.delay,
-			       &(host->cfgtable->HostWrite.CoalIntDelay));
+			       &(h->cfgtable->HostWrite.CoalIntDelay));
 			writel(intinfo.count,
-			       &(host->cfgtable->HostWrite.CoalIntCount));
-			writel(CFGTBL_ChangeReq, host->vaddr + SA5_DOORBELL);
+			       &(h->cfgtable->HostWrite.CoalIntCount));
+			writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 
 			for (i = 0; i < MAX_IOCTL_CONFIG_WAIT; i++) {
-				if (!(readl(host->vaddr + SA5_DOORBELL)
+				if (!(readl(h->vaddr + SA5_DOORBELL)
 				      & CFGTBL_ChangeReq))
 					break;
 				/* delay and try again */
 				udelay(1000);
 			}
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+			spin_unlock_irqrestore(&h->lock, flags);
 			if (i >= MAX_IOCTL_CONFIG_WAIT)
 				return -EAGAIN;
 			return 0;
@@ -1322,7 +1320,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				return -EINVAL;
 			for (i = 0; i < 16; i++)
 				NodeName[i] =
-				    readb(&host->cfgtable->ServerName[i]);
+				    readb(&h->cfgtable->ServerName[i]);
 			if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
 				return -EFAULT;
 			return 0;
@@ -1342,23 +1340,23 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			    (NodeName, argp, sizeof(NodeName_type)))
 				return -EFAULT;
 
-			spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+			spin_lock_irqsave(&h->lock, flags);
 
 			/* Update the field, and then ring the doorbell */
 			for (i = 0; i < 16; i++)
 				writeb(NodeName[i],
-				       &host->cfgtable->ServerName[i]);
+				       &h->cfgtable->ServerName[i]);
 
-			writel(CFGTBL_ChangeReq, host->vaddr + SA5_DOORBELL);
+			writel(CFGTBL_ChangeReq, h->vaddr + SA5_DOORBELL);
 
 			for (i = 0; i < MAX_IOCTL_CONFIG_WAIT; i++) {
-				if (!(readl(host->vaddr + SA5_DOORBELL)
+				if (!(readl(h->vaddr + SA5_DOORBELL)
 				      & CFGTBL_ChangeReq))
 					break;
 				/* delay and try again */
 				udelay(1000);
 			}
-			spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+			spin_unlock_irqrestore(&h->lock, flags);
 			if (i >= MAX_IOCTL_CONFIG_WAIT)
 				return -EAGAIN;
 			return 0;
@@ -1370,7 +1368,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 
 			if (!arg)
 				return -EINVAL;
-			heartbeat = readl(&host->cfgtable->HeartBeat);
+			heartbeat = readl(&h->cfgtable->HeartBeat);
 			if (copy_to_user
 			    (argp, &heartbeat, sizeof(Heartbeat_type)))
 				return -EFAULT;
@@ -1382,7 +1380,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 
 			if (!arg)
 				return -EINVAL;
-			BusTypes = readl(&host->cfgtable->BusTypes);
+			BusTypes = readl(&h->cfgtable->BusTypes);
 			if (copy_to_user
 			    (argp, &BusTypes, sizeof(BusTypes_type)))
 				return -EFAULT;
@@ -1394,7 +1392,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 
 			if (!arg)
 				return -EINVAL;
-			memcpy(firmware, host->firm_ver, 4);
+			memcpy(firmware, h->firm_ver, 4);
 
 			if (copy_to_user
 			    (argp, firmware, sizeof(FirmwareVer_type)))
@@ -1417,7 +1415,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWD:
 	case CCISS_REVALIDVOLS:
-		return rebuild_lun_table(host, 0, 1);
+		return rebuild_lun_table(h, 0, 1);
 
 	case CCISS_GETLUNINFO:{
 			LogvolInfo_struct luninfo;
@@ -1472,7 +1470,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			} else {
 				memset(buff, 0, iocommand.buf_size);
 			}
-			if ((c = cmd_alloc(host, 0)) == NULL) {
+			c = cmd_alloc(h, 0);
+			if (!c) {
 				kfree(buff);
 				return -ENOMEM;
 			}
@@ -1498,7 +1497,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 
 			/* Fill in the scatter gather information */
 			if (iocommand.buf_size > 0) {
-				temp64.val = pci_map_single(host->pdev, buff,
+				temp64.val = pci_map_single(h->pdev, buff,
 					iocommand.buf_size,
 					PCI_DMA_BIDIRECTIONAL);
 				c->SG[0].Addr.lower = temp64.val32.lower;
@@ -1508,24 +1507,24 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			}
 			c->waiting = &wait;
 
-			enqueue_cmd_and_start_io(host, c);
+			enqueue_cmd_and_start_io(h, c);
 			wait_for_completion(&wait);
 
 			/* unlock the buffers from DMA */
 			temp64.val32.lower = c->SG[0].Addr.lower;
 			temp64.val32.upper = c->SG[0].Addr.upper;
-			pci_unmap_single(host->pdev, (dma_addr_t) temp64.val,
+			pci_unmap_single(h->pdev, (dma_addr_t) temp64.val,
 					 iocommand.buf_size,
 					 PCI_DMA_BIDIRECTIONAL);
 
-			check_ioctl_unit_attention(host, c);
+			check_ioctl_unit_attention(h, c);
 
 			/* Copy the error information out */
 			iocommand.error_info = *(c->err_info);
 			if (copy_to_user
 			    (argp, &iocommand, sizeof(IOCTL_Command_struct))) {
 				kfree(buff);
-				cmd_free(host, c, 0);
+				cmd_free(h, c, 0);
 				return -EFAULT;
 			}
 
@@ -1534,12 +1533,12 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				if (copy_to_user
 				    (iocommand.buf, buff, iocommand.buf_size)) {
 					kfree(buff);
-					cmd_free(host, c, 0);
+					cmd_free(h, c, 0);
 					return -EFAULT;
 				}
 			}
 			kfree(buff);
-			cmd_free(host, c, 0);
+			cmd_free(h, c, 0);
 			return 0;
 		}
 	case CCISS_BIG_PASSTHRU:{
@@ -1621,7 +1620,8 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				data_ptr += sz;
 				sg_used++;
 			}
-			if ((c = cmd_alloc(host, 0)) == NULL) {
+			c = cmd_alloc(h, 0);
+			if (!c) {
 				status = -ENOMEM;
 				goto cleanup1;
 			}
@@ -1642,7 +1642,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 			if (ioc->buf_size > 0) {
 				for (i = 0; i < sg_used; i++) {
 					temp64.val =
-					    pci_map_single(host->pdev, buff[i],
+					    pci_map_single(h->pdev, buff[i],
 						    buff_size[i],
 						    PCI_DMA_BIDIRECTIONAL);
 					c->SG[i].Addr.lower =
@@ -1654,21 +1654,21 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				}
 			}
 			c->waiting = &wait;
-			enqueue_cmd_and_start_io(host, c);
+			enqueue_cmd_and_start_io(h, c);
 			wait_for_completion(&wait);
 			/* unlock the buffers from DMA */
 			for (i = 0; i < sg_used; i++) {
 				temp64.val32.lower = c->SG[i].Addr.lower;
 				temp64.val32.upper = c->SG[i].Addr.upper;
-				pci_unmap_single(host->pdev,
+				pci_unmap_single(h->pdev,
 					(dma_addr_t) temp64.val, buff_size[i],
 					PCI_DMA_BIDIRECTIONAL);
 			}
-			check_ioctl_unit_attention(host, c);
+			check_ioctl_unit_attention(h, c);
 			/* Copy the error information out */
 			ioc->error_info = *(c->err_info);
 			if (copy_to_user(argp, ioc, sizeof(*ioc))) {
-				cmd_free(host, c, 0);
+				cmd_free(h, c, 0);
 				status = -EFAULT;
 				goto cleanup1;
 			}
@@ -1678,14 +1678,14 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 				for (i = 0; i < sg_used; i++) {
 					if (copy_to_user
 					    (ptr, buff[i], buff_size[i])) {
-						cmd_free(host, c, 0);
+						cmd_free(h, c, 0);
 						status = -EFAULT;
 						goto cleanup1;
 					}
 					ptr += buff_size[i];
 				}
 			}
-			cmd_free(host, c, 0);
+			cmd_free(h, c, 0);
 			status = 0;
 		      cleanup1:
 			if (buff) {
@@ -1773,26 +1773,26 @@ static void cciss_check_queues(ctlr_info_t *h)
 
 static void cciss_softirq_done(struct request *rq)
 {
-	CommandList_struct *cmd = rq->completion_data;
-	ctlr_info_t *h = hba[cmd->ctlr];
-	SGDescriptor_struct *curr_sg = cmd->SG;
+	CommandList_struct *c = rq->completion_data;
+	ctlr_info_t *h = hba[c->ctlr];
+	SGDescriptor_struct *curr_sg = c->SG;
 	u64bit temp64;
 	unsigned long flags;
 	int i, ddir;
 	int sg_index = 0;
 
-	if (cmd->Request.Type.Direction == XFER_READ)
+	if (c->Request.Type.Direction == XFER_READ)
 		ddir = PCI_DMA_FROMDEVICE;
 	else
 		ddir = PCI_DMA_TODEVICE;
 
 	/* command did not need to be retried */
 	/* unmap the DMA mapping for all the scatter gather elements */
-	for (i = 0; i < cmd->Header.SGList; i++) {
+	for (i = 0; i < c->Header.SGList; i++) {
 		if (curr_sg[sg_index].Ext == CCISS_SG_CHAIN) {
-			cciss_unmap_sg_chain_block(h, cmd);
+			cciss_unmap_sg_chain_block(h, c);
 			/* Point to the next block */
-			curr_sg = h->cmd_sg_list[cmd->cmdindex];
+			curr_sg = h->cmd_sg_list[c->cmdindex];
 			sg_index = 0;
 		}
 		temp64.val32.lower = curr_sg[sg_index].Addr.lower;
@@ -1808,12 +1808,12 @@ static void cciss_softirq_done(struct request *rq)
 
 	/* set the residual count for pc requests */
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC)
-		rq->resid_len = cmd->err_info->ResidualCnt;
+		rq->resid_len = c->err_info->ResidualCnt;
 
 	blk_end_request_all(rq, (rq->errors == 0) ? 0 : -EIO);
 
 	spin_lock_irqsave(&h->lock, flags);
-	cmd_free(h, cmd, 1);
+	cmd_free(h, c, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
@@ -1829,7 +1829,7 @@ static inline void log_unit_to_scsi3addr(ctlr_info_t *h,
  * via the inquiry page 0.  Model, vendor, and rev are set to empty strings if
  * they cannot be read.
  */
-static void cciss_get_device_descr(int ctlr, int logvol,
+static void cciss_get_device_descr(ctlr_info_t *h, int logvol,
 				   char *vendor, char *model, char *rev)
 {
 	int rc;
@@ -1844,8 +1844,8 @@ static void cciss_get_device_descr(int ctlr, int logvol,
 	if (!inq_buf)
 		return;
 
-	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	rc = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buf, sizeof(*inq_buf), 0,
+	log_unit_to_scsi3addr(h, scsi3addr, logvol);
+	rc = sendcmd_withirq(h, CISS_INQUIRY, inq_buf, sizeof(*inq_buf), 0,
 			scsi3addr, TYPE_CMD);
 	if (rc == IO_OK) {
 		memcpy(vendor, &inq_buf->data_byte[8], VENDOR_LEN);
@@ -1865,7 +1865,7 @@ static void cciss_get_device_descr(int ctlr, int logvol,
  * number cannot be had, for whatever reason, 16 bytes of 0xff
  * are returned instead.
  */
-static void cciss_get_serial_no(int ctlr, int logvol,
+static void cciss_get_serial_no(ctlr_info_t *h, int logvol,
 				unsigned char *serial_no, int buflen)
 {
 #define PAGE_83_INQ_BYTES 64
@@ -1880,8 +1880,8 @@ static void cciss_get_serial_no(int ctlr, int logvol,
 	if (!buf)
 		return;
 	memset(serial_no, 0, buflen);
-	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	rc = sendcmd_withirq(CISS_INQUIRY, ctlr, buf,
+	log_unit_to_scsi3addr(h, scsi3addr, logvol);
+	rc = sendcmd_withirq(h, CISS_INQUIRY, buf,
 		PAGE_83_INQ_BYTES, 0x83, scsi3addr, TYPE_CMD);
 	if (rc == IO_OK)
 		memcpy(serial_no, &buf[8], buflen);
@@ -1947,10 +1947,9 @@ init_queue_failure:
  * is also the controller node.  Any changes to disk 0 will show up on
  * the next reboot.
  */
-static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
-	int via_ioctl)
+static void cciss_update_drive_info(ctlr_info_t *h, int drv_index,
+	int first_time, int via_ioctl)
 {
-	ctlr_info_t *h = hba[ctlr];
 	struct gendisk *disk;
 	InquiryData_struct *inq_buff = NULL;
 	unsigned int block_size;
@@ -1967,16 +1966,16 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 
 	/* testing to see if 16-byte CDBs are already being used */
 	if (h->cciss_read == CCISS_READ_16) {
-		cciss_read_capacity_16(h->ctlr, drv_index,
+		cciss_read_capacity_16(h, drv_index,
 			&total_size, &block_size);
 
 	} else {
-		cciss_read_capacity(ctlr, drv_index, &total_size, &block_size);
+		cciss_read_capacity(h, drv_index, &total_size, &block_size);
 		/* if read_capacity returns all F's this volume is >2TB */
 		/* in size so we switch to 16-byte CDB's for all */
 		/* read/write ops */
 		if (total_size == 0xFFFFFFFFULL) {
-			cciss_read_capacity_16(ctlr, drv_index,
+			cciss_read_capacity_16(h, drv_index,
 			&total_size, &block_size);
 			h->cciss_read = CCISS_READ_16;
 			h->cciss_write = CCISS_WRITE_16;
@@ -1986,14 +1985,14 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 		}
 	}
 
-	cciss_geometry_inquiry(ctlr, drv_index, total_size, block_size,
+	cciss_geometry_inquiry(h, drv_index, total_size, block_size,
 			       inq_buff, drvinfo);
 	drvinfo->block_size = block_size;
 	drvinfo->nr_blocks = total_size + 1;
 
-	cciss_get_device_descr(ctlr, drv_index, drvinfo->vendor,
+	cciss_get_device_descr(h, drv_index, drvinfo->vendor,
 				drvinfo->model, drvinfo->rev);
-	cciss_get_serial_no(ctlr, drv_index, drvinfo->serial_no,
+	cciss_get_serial_no(h, drv_index, drvinfo->serial_no,
 			sizeof(drvinfo->serial_no));
 	/* Save the lunid in case we deregister the disk, below. */
 	memcpy(drvinfo->LunID, h->drv[drv_index]->LunID,
@@ -2019,9 +2018,9 @@ static void cciss_update_drive_info(int ctlr, int drv_index, int first_time,
 	 */
 	if (h->drv[drv_index]->raid_level != -1 && drv_index != 0) {
 		printk(KERN_WARNING "disk %d has changed.\n", drv_index);
-		spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+		spin_lock_irqsave(&h->lock, flags);
 		h->drv[drv_index]->busy_configuring = 1;
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 
 		/* deregister_disk sets h->drv[drv_index]->queue = NULL
 		 * which keeps the interrupt handler from starting
@@ -2243,7 +2242,6 @@ error:
 static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 	int via_ioctl)
 {
-	int ctlr = h->ctlr;
 	int num_luns;
 	ReportLunData_struct *ld_buff = NULL;
 	int return_code;
@@ -2258,19 +2256,19 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		return -EPERM;
 
 	/* Set busy_configuring flag for this operation */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	if (h->busy_configuring) {
-		spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -EBUSY;
 	}
 	h->busy_configuring = 1;
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 
 	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
 	if (ld_buff == NULL)
 		goto mem_msg;
 
-	return_code = sendcmd_withirq(CISS_REPORT_LOG, ctlr, ld_buff,
+	return_code = sendcmd_withirq(h, CISS_REPORT_LOG, ld_buff,
 				      sizeof(ReportLunData_struct),
 				      0, CTLR_LUNID, TYPE_CMD);
 
@@ -2317,9 +2315,9 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 		}
 		if (!drv_found) {
 			/* Deregister it from the OS, it's gone. */
-			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+			spin_lock_irqsave(&h->lock, flags);
 			h->drv[i]->busy_configuring = 1;
-			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+			spin_unlock_irqrestore(&h->lock, flags);
 			return_code = deregister_disk(h, i, 1, via_ioctl);
 			if (h->drv[i] != NULL)
 				h->drv[i]->busy_configuring = 0;
@@ -2358,8 +2356,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time,
 			if (drv_index == -1)
 				goto freeret;
 		}
-		cciss_update_drive_info(ctlr, drv_index, first_time,
-			via_ioctl);
+		cciss_update_drive_info(h, drv_index, first_time, via_ioctl);
 	}		/* end for */
 
 freeret:
@@ -2491,11 +2488,10 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	return 0;
 }
 
-static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
+static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 		size_t size, __u8 page_code, unsigned char *scsi3addr,
 		int cmd_type)
 {
-	ctlr_info_t *h = hba[ctlr];
 	u64bit buff_dma_handle;
 	int status = IO_OK;
 
@@ -2580,7 +2576,8 @@ static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
 			break;
 		default:
 			printk(KERN_WARNING
-			       "cciss%d:  Unknown Command 0x%c\n", ctlr, cmd);
+			       "cciss%d:  Unknown Command 0x%c\n",
+				h->ctlr, cmd);
 			return IO_ERROR;
 		}
 	} else if (cmd_type == TYPE_MSG) {
@@ -2613,12 +2610,13 @@ static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
 			break;
 		default:
 			printk(KERN_WARNING
-			       "cciss%d: unknown message type %d\n", ctlr, cmd);
+			       "cciss%d: unknown message type %d\n",
+				h->ctlr, cmd);
 			return IO_ERROR;
 		}
 	} else {
 		printk(KERN_WARNING
-		       "cciss%d: unknown command type %d\n", ctlr, cmd_type);
+		       "cciss%d: unknown command type %d\n", h->ctlr, cmd_type);
 		return IO_ERROR;
 	}
 	/* Fill in the scatter gather information */
@@ -2760,18 +2758,17 @@ command_done:
 	return return_status;
 }
 
-static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
+static int sendcmd_withirq(ctlr_info_t *h, __u8 cmd, void *buff, size_t size,
 			   __u8 page_code, unsigned char scsi3addr[],
 			int cmd_type)
 {
-	ctlr_info_t *h = hba[ctlr];
 	CommandList_struct *c;
 	int return_status;
 
 	c = cmd_alloc(h, 0);
 	if (!c)
 		return -ENOMEM;
-	return_status = fill_cmd(c, cmd, ctlr, buff, size, page_code,
+	return_status = fill_cmd(h, c, cmd, buff, size, page_code,
 		scsi3addr, cmd_type);
 	if (return_status == IO_OK)
 		return_status = sendcmd_withirq_core(h, c, 1);
@@ -2780,7 +2777,7 @@ static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 	return return_status;
 }
 
-static void cciss_geometry_inquiry(int ctlr, int logvol,
+static void cciss_geometry_inquiry(ctlr_info_t *h, int logvol,
 				   sector_t total_size,
 				   unsigned int block_size,
 				   InquiryData_struct *inq_buff,
@@ -2791,8 +2788,8 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 	unsigned char scsi3addr[8];
 
 	memset(inq_buff, 0, sizeof(InquiryData_struct));
-	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	return_code = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buff,
+	log_unit_to_scsi3addr(h, scsi3addr, logvol);
+	return_code = sendcmd_withirq(h, CISS_INQUIRY, inq_buff,
 			sizeof(*inq_buff), 0xC1, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		if (inq_buff->data_byte[8] == 0xFF) {
@@ -2826,7 +2823,7 @@ static void cciss_geometry_inquiry(int ctlr, int logvol,
 }
 
 static void
-cciss_read_capacity(int ctlr, int logvol, sector_t *total_size,
+cciss_read_capacity(ctlr_info_t *h, int logvol, sector_t *total_size,
 		    unsigned int *block_size)
 {
 	ReadCapdata_struct *buf;
@@ -2839,8 +2836,8 @@ cciss_read_capacity(int ctlr, int logvol, sector_t *total_size,
 		return;
 	}
 
-	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	return_code = sendcmd_withirq(CCISS_READ_CAPACITY, ctlr, buf,
+	log_unit_to_scsi3addr(h, scsi3addr, logvol);
+	return_code = sendcmd_withirq(h, CCISS_READ_CAPACITY, buf,
 		sizeof(ReadCapdata_struct), 0, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		*total_size = be32_to_cpu(*(__be32 *) buf->total_size);
@@ -2853,7 +2850,7 @@ cciss_read_capacity(int ctlr, int logvol, sector_t *total_size,
 	kfree(buf);
 }
 
-static void cciss_read_capacity_16(int ctlr, int logvol,
+static void cciss_read_capacity_16(ctlr_info_t *h, int logvol,
 	sector_t *total_size, unsigned int *block_size)
 {
 	ReadCapdata_struct_16 *buf;
@@ -2866,9 +2863,9 @@ static void cciss_read_capacity_16(int ctlr, int logvol,
 		return;
 	}
 
-	log_unit_to_scsi3addr(hba[ctlr], scsi3addr, logvol);
-	return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
-		ctlr, buf, sizeof(ReadCapdata_struct_16),
+	log_unit_to_scsi3addr(h, scsi3addr, logvol);
+	return_code = sendcmd_withirq(h, CCISS_READ_CAPACITY_16,
+		buf, sizeof(ReadCapdata_struct_16),
 			0, scsi3addr, TYPE_CMD);
 	if (return_code == IO_OK) {
 		*total_size = be64_to_cpu(*(__be64 *) buf->total_size);
@@ -2910,13 +2907,13 @@ static int cciss_revalidate(struct gendisk *disk)
 		return 1;
 	}
 	if (h->cciss_read == CCISS_READ_10) {
-		cciss_read_capacity(h->ctlr, logvol,
+		cciss_read_capacity(h, logvol,
 					&total_size, &block_size);
 	} else {
-		cciss_read_capacity_16(h->ctlr, logvol,
+		cciss_read_capacity_16(h, logvol,
 					&total_size, &block_size);
 	}
-	cciss_geometry_inquiry(h->ctlr, logvol, total_size, block_size,
+	cciss_geometry_inquiry(h, logvol, total_size, block_size,
 			       inq_buff, drv);
 
 	blk_queue_logical_block_size(drv->queue, drv->block_size);
@@ -2966,7 +2963,7 @@ static void start_io(ctlr_info_t *h)
 	}
 }
 
-/* Assumes that CCISS_LOCK(h->ctlr) is held. */
+/* Assumes that h->lock is held. */
 /* Zeros out the error record and then resends the command back */
 /* to the controller */
 static inline void resend_cciss_cmd(ctlr_info_t *h, CommandList_struct *c)
@@ -3494,7 +3491,7 @@ static irqreturn_t do_cciss_intx(int irq, void *dev_id)
 	 * If there are completed commands in the completion queue,
 	 * we had better do something about it.
 	 */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h);
 		while (raw_tag != FIFO_EMPTY) {
@@ -3505,7 +3502,7 @@ static irqreturn_t do_cciss_intx(int irq, void *dev_id)
 		}
 	}
 
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -3524,7 +3521,7 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id)
 	 * If there are completed commands in the completion queue,
 	 * we had better do something about it.
 	 */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
 	raw_tag = get_next_completion(h);
 	while (raw_tag != FIFO_EMPTY) {
 		if (cciss_tag_contains_index(raw_tag))
@@ -3533,7 +3530,7 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id)
 			raw_tag = process_nonindexed_cmd(h, raw_tag);
 	}
 
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
 
@@ -3961,7 +3958,7 @@ clean_up:
  * controllers that are capable. If not, we use IO-APIC mode.
  */
 
-static void __devinit cciss_interrupt_mode(ctlr_info_t *c)
+static void __devinit cciss_interrupt_mode(ctlr_info_t *h)
 {
 #ifdef CONFIG_PCI_MSI
 	int err;
@@ -3970,18 +3967,18 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c)
 	};
 
 	/* Some boards advertise MSI but don't really support it */
-	if ((c->board_id == 0x40700E11) || (c->board_id == 0x40800E11) ||
-	    (c->board_id == 0x40820E11) || (c->board_id == 0x40830E11))
+	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
+	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
 		goto default_int_mode;
 
-	if (pci_find_capability(c->pdev, PCI_CAP_ID_MSIX)) {
-		err = pci_enable_msix(c->pdev, cciss_msix_entries, 4);
+	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
+		err = pci_enable_msix(h->pdev, cciss_msix_entries, 4);
 		if (!err) {
-			c->intr[0] = cciss_msix_entries[0].vector;
-			c->intr[1] = cciss_msix_entries[1].vector;
-			c->intr[2] = cciss_msix_entries[2].vector;
-			c->intr[3] = cciss_msix_entries[3].vector;
-			c->msix_vector = 1;
+			h->intr[0] = cciss_msix_entries[0].vector;
+			h->intr[1] = cciss_msix_entries[1].vector;
+			h->intr[2] = cciss_msix_entries[2].vector;
+			h->intr[3] = cciss_msix_entries[3].vector;
+			h->msix_vector = 1;
 			return;
 		}
 		if (err > 0) {
@@ -3994,17 +3991,16 @@ static void __devinit cciss_interrupt_mode(ctlr_info_t *c)
 			goto default_int_mode;
 		}
 	}
-	if (pci_find_capability(c->pdev, PCI_CAP_ID_MSI)) {
-		if (!pci_enable_msi(c->pdev)) {
-			c->msi_vector = 1;
-		} else {
+	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
+		if (!pci_enable_msi(h->pdev))
+			h->msi_vector = 1;
+		else
 			printk(KERN_WARNING "cciss: MSI init failed\n");
-		}
 	}
 default_int_mode:
 #endif				/* CONFIG_PCI_MSI */
 	/* if we get here we're going to use the default interrupt mode */
-	c->intr[PERF_MODE_INT] = c->pdev->irq;
+	h->intr[PERF_MODE_INT] = h->pdev->irq;
 	return;
 }
 
@@ -4190,28 +4186,28 @@ static inline void cciss_p600_dma_prefetch_quirk(ctlr_info_t *h)
 	pci_write_config_dword(h->pdev, PCI_COMMAND_PARITY, dma_refetch);
 }
 
-static int __devinit cciss_pci_init(ctlr_info_t *c)
+static int __devinit cciss_pci_init(ctlr_info_t *h)
 {
 	int prod_index, err;
 
-	prod_index = cciss_lookup_board_id(c->pdev, &c->board_id);
+	prod_index = cciss_lookup_board_id(h->pdev, &h->board_id);
 	if (prod_index < 0)
 		return -ENODEV;
-	c->product_name = products[prod_index].product_name;
-	c->access = *(products[prod_index].access);
+	h->product_name = products[prod_index].product_name;
+	h->access = *(products[prod_index].access);
 
-	if (cciss_board_disabled(c)) {
+	if (cciss_board_disabled(h)) {
 		printk(KERN_WARNING
 		       "cciss: controller appears to be disabled\n");
 		return -ENODEV;
 	}
-	err = pci_enable_device(c->pdev);
+	err = pci_enable_device(h->pdev);
 	if (err) {
 		printk(KERN_ERR "cciss: Unable to Enable PCI device\n");
 		return err;
 	}
 
-	err = pci_request_regions(c->pdev, "cciss");
+	err = pci_request_regions(h->pdev, "cciss");
 	if (err) {
 		printk(KERN_ERR "cciss: Cannot obtain PCI resources, "
 		       "aborting\n");
@@ -4220,38 +4216,38 @@ static int __devinit cciss_pci_init(ctlr_info_t *c)
 
 #ifdef CCISS_DEBUG
 	printk(KERN_INFO "command = %x\n", command);
-	printk(KERN_INFO "irq = %x\n", c->pdev->irq);
-	printk(KERN_INFO "board_id = %x\n", c->board_id);
+	printk(KERN_INFO "irq = %x\n", h->pdev->irq);
+	printk(KERN_INFO "board_id = %x\n", h->board_id);
 #endif				/* CCISS_DEBUG */
 
 /* If the kernel supports MSI/MSI-X we will try to enable that functionality,
  * else we use the IO-APIC interrupt assigned to us by system ROM.
  */
-	cciss_interrupt_mode(c);
-	err = cciss_pci_find_memory_BAR(c->pdev, &c->paddr);
+	cciss_interrupt_mode(h);
+	err = cciss_pci_find_memory_BAR(h->pdev, &h->paddr);
 	if (err)
 		goto err_out_free_res;
-	c->vaddr = remap_pci_mem(c->paddr, 0x250);
-	if (!c->vaddr) {
+	h->vaddr = remap_pci_mem(h->paddr, 0x250);
+	if (!h->vaddr) {
 		err = -ENOMEM;
 		goto err_out_free_res;
 	}
-	err = cciss_wait_for_board_ready(c);
+	err = cciss_wait_for_board_ready(h);
 	if (err)
 		goto err_out_free_res;
-	err = cciss_find_cfgtables(c);
+	err = cciss_find_cfgtables(h);
 	if (err)
 		goto err_out_free_res;
-	print_cfg_table(c->cfgtable);
-	cciss_find_board_params(c);
+	print_cfg_table(h->cfgtable);
+	cciss_find_board_params(h);
 
-	if (!CISS_signature_present(c)) {
+	if (!CISS_signature_present(h)) {
 		err = -ENODEV;
 		goto err_out_free_res;
 	}
-	cciss_enable_scsi_prefetch(c);
-	cciss_p600_dma_prefetch_quirk(c);
-	cciss_put_controller_into_performant_mode(c);
+	cciss_enable_scsi_prefetch(h);
+	cciss_p600_dma_prefetch_quirk(h);
+	cciss_put_controller_into_performant_mode(h);
 	return 0;
 
 err_out_free_res:
@@ -4259,13 +4255,13 @@ err_out_free_res:
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
-	if (c->transtable)
-		iounmap(c->transtable);
-	if (c->cfgtable)
-		iounmap(c->cfgtable);
-	if (c->vaddr)
-		iounmap(c->vaddr);
-	pci_release_regions(c->pdev);
+	if (h->transtable)
+		iounmap(h->transtable);
+	if (h->cfgtable)
+		iounmap(h->cfgtable);
+	if (h->vaddr)
+		iounmap(h->vaddr);
+	pci_release_regions(h->pdev);
 	return err;
 }
 
@@ -4278,12 +4274,12 @@ static int alloc_cciss_hba(void)
 
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
-			ctlr_info_t *p;
+			ctlr_info_t *h;
 
-			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
-			if (!p)
+			h = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
+			if (!h)
 				goto Enomem;
-			hba[i] = p;
+			hba[i] = h;
 			return i;
 		}
 	}
@@ -4295,12 +4291,11 @@ Enomem:
 	return -1;
 }
 
-static void free_hba(int n)
+static void free_hba(ctlr_info_t *h)
 {
-	ctlr_info_t *h = hba[n];
 	int i;
 
-	hba[n] = NULL;
+	hba[h->ctlr] = NULL;
 	for (i = 0; i < h->highest_lun + 1; i++)
 		if (h->gendisk[i] != NULL)
 			put_disk(h->gendisk[i]);
@@ -4651,6 +4646,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int rc;
 	int dac, return_code;
 	InquiryData_struct *inq_buff;
+	ctlr_info_t *h;
 
 	rc = cciss_init_reset_devices(pdev);
 	if (rc)
@@ -4659,21 +4655,22 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	if (i < 0)
 		return -1;
 
-	hba[i]->pdev = pdev;
-	hba[i]->busy_initializing = 1;
-	INIT_HLIST_HEAD(&hba[i]->cmpQ);
-	INIT_HLIST_HEAD(&hba[i]->reqQ);
-	mutex_init(&hba[i]->busy_shutting_down);
+	h = hba[i];
+	h->pdev = pdev;
+	h->busy_initializing = 1;
+	INIT_HLIST_HEAD(&h->cmpQ);
+	INIT_HLIST_HEAD(&h->reqQ);
+	mutex_init(&h->busy_shutting_down);
 
-	if (cciss_pci_init(hba[i]) != 0)
+	if (cciss_pci_init(h) != 0)
 		goto clean_no_release_regions;
 
-	sprintf(hba[i]->devname, "cciss%d", i);
-	hba[i]->ctlr = i;
+	sprintf(h->devname, "cciss%d", i);
+	h->ctlr = i;
 
-	init_completion(&hba[i]->scan_wait);
+	init_completion(&h->scan_wait);
 
-	if (cciss_create_hba_sysfs_entry(hba[i]))
+	if (cciss_create_hba_sysfs_entry(h))
 		goto clean0;
 
 	/* configure PCI DMA stuff */
@@ -4692,100 +4689,100 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	 * 8 controller support.
 	 */
 	if (i < MAX_CTLR_ORIG)
-		hba[i]->major = COMPAQ_CISS_MAJOR + i;
-	rc = register_blkdev(hba[i]->major, hba[i]->devname);
+		h->major = COMPAQ_CISS_MAJOR + i;
+	rc = register_blkdev(h->major, h->devname);
 	if (rc == -EBUSY || rc == -EINVAL) {
 		printk(KERN_ERR
 		       "cciss:  Unable to get major number %d for %s "
-		       "on hba %d\n", hba[i]->major, hba[i]->devname, i);
+		       "on hba %d\n", h->major, h->devname, i);
 		goto clean1;
 	} else {
 		if (i >= MAX_CTLR_ORIG)
-			hba[i]->major = rc;
+			h->major = rc;
 	}
 
 	/* make sure the board interrupts are off */
-	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
-	if (hba[i]->msi_vector || hba[i]->msix_vector) {
-		if (request_irq(hba[i]->intr[PERF_MODE_INT],
+	h->access.set_intr_mask(h, CCISS_INTR_OFF);
+	if (h->msi_vector || h->msix_vector) {
+		if (request_irq(h->intr[PERF_MODE_INT],
 				do_cciss_msix_intr,
-				IRQF_DISABLED, hba[i]->devname, hba[i])) {
+				IRQF_DISABLED, h->devname, h)) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
+			       h->intr[PERF_MODE_INT], h->devname);
 			goto clean2;
 		}
 	} else {
-		if (request_irq(hba[i]->intr[PERF_MODE_INT], do_cciss_intx,
-				IRQF_DISABLED, hba[i]->devname, hba[i])) {
+		if (request_irq(h->intr[PERF_MODE_INT], do_cciss_intx,
+				IRQF_DISABLED, h->devname, h)) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
+			       h->intr[PERF_MODE_INT], h->devname);
 			goto clean2;
 		}
 	}
 
 	printk(KERN_INFO "%s: <0x%x> at PCI %s IRQ %d%s using DAC\n",
-	       hba[i]->devname, pdev->device, pci_name(pdev),
-	       hba[i]->intr[PERF_MODE_INT], dac ? "" : " not");
+	       h->devname, pdev->device, pci_name(pdev),
+	       h->intr[PERF_MODE_INT], dac ? "" : " not");
 
-	hba[i]->cmd_pool_bits =
-	    kmalloc(DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+	h->cmd_pool_bits =
+	    kmalloc(DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG)
 			* sizeof(unsigned long), GFP_KERNEL);
-	hba[i]->cmd_pool = (CommandList_struct *)
-	    pci_alloc_consistent(hba[i]->pdev,
-		    hba[i]->nr_cmds * sizeof(CommandList_struct),
-		    &(hba[i]->cmd_pool_dhandle));
-	hba[i]->errinfo_pool = (ErrorInfo_struct *)
-	    pci_alloc_consistent(hba[i]->pdev,
-		    hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
-		    &(hba[i]->errinfo_pool_dhandle));
-	if ((hba[i]->cmd_pool_bits == NULL)
-	    || (hba[i]->cmd_pool == NULL)
-	    || (hba[i]->errinfo_pool == NULL)) {
+	h->cmd_pool = (CommandList_struct *)
+	    pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(CommandList_struct),
+		    &(h->cmd_pool_dhandle));
+	h->errinfo_pool = (ErrorInfo_struct *)
+	    pci_alloc_consistent(h->pdev,
+		    h->nr_cmds * sizeof(ErrorInfo_struct),
+		    &(h->errinfo_pool_dhandle));
+	if ((h->cmd_pool_bits == NULL)
+	    || (h->cmd_pool == NULL)
+	    || (h->errinfo_pool == NULL)) {
 		printk(KERN_ERR "cciss: out of memory");
 		goto clean4;
 	}
 
 	/* Need space for temp scatter list */
-	hba[i]->scatter_list = kmalloc(hba[i]->max_commands *
+	h->scatter_list = kmalloc(h->max_commands *
 						sizeof(struct scatterlist *),
 						GFP_KERNEL);
-	for (k = 0; k < hba[i]->nr_cmds; k++) {
-		hba[i]->scatter_list[k] = kmalloc(sizeof(struct scatterlist) *
-							hba[i]->maxsgentries,
+	for (k = 0; k < h->nr_cmds; k++) {
+		h->scatter_list[k] = kmalloc(sizeof(struct scatterlist) *
+							h->maxsgentries,
 							GFP_KERNEL);
-		if (hba[i]->scatter_list[k] == NULL) {
+		if (h->scatter_list[k] == NULL) {
 			printk(KERN_ERR "cciss%d: could not allocate "
 				"s/g lists\n", i);
 			goto clean4;
 		}
 	}
-	hba[i]->cmd_sg_list = cciss_allocate_sg_chain_blocks(hba[i],
-		hba[i]->chainsize, hba[i]->nr_cmds);
-	if (!hba[i]->cmd_sg_list && hba[i]->chainsize > 0)
+	h->cmd_sg_list = cciss_allocate_sg_chain_blocks(h,
+		h->chainsize, h->nr_cmds);
+	if (!h->cmd_sg_list && h->chainsize > 0)
 		goto clean4;
 
-	spin_lock_init(&hba[i]->lock);
+	spin_lock_init(&h->lock);
 
 	/* Initialize the pdev driver private data.
-	   have it point to hba[i].  */
-	pci_set_drvdata(pdev, hba[i]);
+	   have it point to h.  */
+	pci_set_drvdata(pdev, h);
 	/* command and error info recs zeroed out before
 	   they are used */
-	memset(hba[i]->cmd_pool_bits, 0,
-	       DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
+	memset(h->cmd_pool_bits, 0,
+	       DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG)
 			* sizeof(unsigned long));
 
-	hba[i]->num_luns = 0;
-	hba[i]->highest_lun = -1;
+	h->num_luns = 0;
+	h->highest_lun = -1;
 	for (j = 0; j < CISS_MAX_LUN; j++) {
-		hba[i]->drv[j] = NULL;
-		hba[i]->gendisk[j] = NULL;
+		h->drv[j] = NULL;
+		h->gendisk[j] = NULL;
 	}
 
-	cciss_scsi_setup(i);
+	cciss_scsi_setup(h);
 
 	/* Turn the interrupts on so we can service requests */
-	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
+	h->access.set_intr_mask(h, CCISS_INTR_ON);
 
 	/* Get the firmware version */
 	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
@@ -4794,59 +4791,59 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		goto clean4;
 	}
 
-	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
+	return_code = sendcmd_withirq(h, CISS_INQUIRY, inq_buff,
 		sizeof(InquiryData_struct), 0, CTLR_LUNID, TYPE_CMD);
 	if (return_code == IO_OK) {
-		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
-		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
-		hba[i]->firm_ver[2] = inq_buff->data_byte[34];
-		hba[i]->firm_ver[3] = inq_buff->data_byte[35];
+		h->firm_ver[0] = inq_buff->data_byte[32];
+		h->firm_ver[1] = inq_buff->data_byte[33];
+		h->firm_ver[2] = inq_buff->data_byte[34];
+		h->firm_ver[3] = inq_buff->data_byte[35];
 	} else {	 /* send command failed */
 		printk(KERN_WARNING "cciss: unable to determine firmware"
 			" version of controller\n");
 	}
 	kfree(inq_buff);
 
-	cciss_procinit(i);
+	cciss_procinit(h);
 
-	hba[i]->cciss_max_sectors = 8192;
+	h->cciss_max_sectors = 8192;
 
-	rebuild_lun_table(hba[i], 1, 0);
-	hba[i]->busy_initializing = 0;
+	rebuild_lun_table(h, 1, 0);
+	h->busy_initializing = 0;
 	return 1;
 
 clean4:
-	kfree(hba[i]->cmd_pool_bits);
+	kfree(h->cmd_pool_bits);
 	/* Free up sg elements */
-	for (k = 0; k < hba[i]->nr_cmds; k++)
-		kfree(hba[i]->scatter_list[k]);
-	kfree(hba[i]->scatter_list);
-	cciss_free_sg_chain_blocks(hba[i]->cmd_sg_list, hba[i]->nr_cmds);
-	if (hba[i]->cmd_pool)
-		pci_free_consistent(hba[i]->pdev,
-				    hba[i]->nr_cmds * sizeof(CommandList_struct),
-				    hba[i]->cmd_pool, hba[i]->cmd_pool_dhandle);
-	if (hba[i]->errinfo_pool)
-		pci_free_consistent(hba[i]->pdev,
-				    hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
-				    hba[i]->errinfo_pool,
-				    hba[i]->errinfo_pool_dhandle);
-	free_irq(hba[i]->intr[PERF_MODE_INT], hba[i]);
+	for (k = 0; k < h->nr_cmds; k++)
+		kfree(h->scatter_list[k]);
+	kfree(h->scatter_list);
+	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
+	if (h->cmd_pool)
+		pci_free_consistent(h->pdev,
+				    h->nr_cmds * sizeof(CommandList_struct),
+				    h->cmd_pool, h->cmd_pool_dhandle);
+	if (h->errinfo_pool)
+		pci_free_consistent(h->pdev,
+				    h->nr_cmds * sizeof(ErrorInfo_struct),
+				    h->errinfo_pool,
+				    h->errinfo_pool_dhandle);
+	free_irq(h->intr[PERF_MODE_INT], h);
 clean2:
-	unregister_blkdev(hba[i]->major, hba[i]->devname);
+	unregister_blkdev(h->major, h->devname);
 clean1:
-	cciss_destroy_hba_sysfs_entry(hba[i]);
+	cciss_destroy_hba_sysfs_entry(h);
 clean0:
 	pci_release_regions(pdev);
 clean_no_release_regions:
-	hba[i]->busy_initializing = 0;
+	h->busy_initializing = 0;
 
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
 	pci_set_drvdata(pdev, NULL);
-	free_hba(i);
+	free_hba(h);
 	return -1;
 }
 
@@ -4866,7 +4863,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 	}
 	/* write all data in the battery backed cache to disk */
 	memset(flush_buf, 0, 4);
-	return_code = sendcmd_withirq(CCISS_CACHE_FLUSH, h->ctlr, flush_buf,
+	return_code = sendcmd_withirq(h, CCISS_CACHE_FLUSH, flush_buf,
 		4, 0, CTLR_LUNID, TYPE_CMD);
 	kfree(flush_buf);
 	if (return_code != IO_OK)
@@ -4878,7 +4875,7 @@ static void cciss_shutdown(struct pci_dev *pdev)
 
 static void __devexit cciss_remove_one(struct pci_dev *pdev)
 {
-	ctlr_info_t *tmp_ptr;
+	ctlr_info_t *h;
 	int i, j;
 
 	if (pci_get_drvdata(pdev) == NULL) {
@@ -4886,28 +4883,28 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		return;
 	}
 
-	tmp_ptr = pci_get_drvdata(pdev);
-	i = tmp_ptr->ctlr;
+	h = pci_get_drvdata(pdev);
+	i = h->ctlr;
 	if (hba[i] == NULL) {
 		printk(KERN_ERR "cciss: device appears to "
-		       "already be removed \n");
+		       "already be removed\n");
 		return;
 	}
 
-	mutex_lock(&hba[i]->busy_shutting_down);
+	mutex_lock(&h->busy_shutting_down);
 
-	remove_from_scan_list(hba[i]);
-	remove_proc_entry(hba[i]->devname, proc_cciss);
-	unregister_blkdev(hba[i]->major, hba[i]->devname);
+	remove_from_scan_list(h);
+	remove_proc_entry(h->devname, proc_cciss);
+	unregister_blkdev(h->major, h->devname);
 
 	/* remove it from the disk list */
 	for (j = 0; j < CISS_MAX_LUN; j++) {
-		struct gendisk *disk = hba[i]->gendisk[j];
+		struct gendisk *disk = h->gendisk[j];
 		if (disk) {
 			struct request_queue *q = disk->queue;
 
 			if (disk->flags & GENHD_FL_UP) {
-				cciss_destroy_ld_sysfs_entry(hba[i], j, 1);
+				cciss_destroy_ld_sysfs_entry(h, j, 1);
 				del_gendisk(disk);
 			}
 			if (q)
@@ -4916,41 +4913,41 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE
-	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
+	cciss_unregister_scsi(h);	/* unhook from SCSI subsystem */
 #endif
 
 	cciss_shutdown(pdev);
 
 #ifdef CONFIG_PCI_MSI
-	if (hba[i]->msix_vector)
-		pci_disable_msix(hba[i]->pdev);
-	else if (hba[i]->msi_vector)
-		pci_disable_msi(hba[i]->pdev);
+	if (h->msix_vector)
+		pci_disable_msix(h->pdev);
+	else if (h->msi_vector)
+		pci_disable_msi(h->pdev);
 #endif				/* CONFIG_PCI_MSI */
 
-	iounmap(hba[i]->transtable);
-	iounmap(hba[i]->cfgtable);
-	iounmap(hba[i]->vaddr);
+	iounmap(h->transtable);
+	iounmap(h->cfgtable);
+	iounmap(h->vaddr);
 
-	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(CommandList_struct),
-			    hba[i]->cmd_pool, hba[i]->cmd_pool_dhandle);
-	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
-			    hba[i]->errinfo_pool, hba[i]->errinfo_pool_dhandle);
-	kfree(hba[i]->cmd_pool_bits);
+	pci_free_consistent(h->pdev, h->nr_cmds * sizeof(CommandList_struct),
+			    h->cmd_pool, h->cmd_pool_dhandle);
+	pci_free_consistent(h->pdev, h->nr_cmds * sizeof(ErrorInfo_struct),
+			    h->errinfo_pool, h->errinfo_pool_dhandle);
+	kfree(h->cmd_pool_bits);
 	/* Free up sg elements */
-	for (j = 0; j < hba[i]->nr_cmds; j++)
-		kfree(hba[i]->scatter_list[j]);
-	kfree(hba[i]->scatter_list);
-	cciss_free_sg_chain_blocks(hba[i]->cmd_sg_list, hba[i]->nr_cmds);
+	for (j = 0; j < h->nr_cmds; j++)
+		kfree(h->scatter_list[j]);
+	kfree(h->scatter_list);
+	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
-	cciss_destroy_hba_sysfs_entry(hba[i]);
-	mutex_unlock(&hba[i]->busy_shutting_down);
-	free_hba(i);
+	cciss_destroy_hba_sysfs_entry(h);
+	mutex_unlock(&h->busy_shutting_down);
+	free_hba(h);
 }
 
 static struct pci_driver cciss_pci_driver = {
diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 4290b7f..ae340ff 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -419,6 +419,4 @@ struct board_type {
 	int nr_cmds; /* Max cmds this kind of ctlr can handle. */
 };
 
-#define CCISS_LOCK(i)	(&hba[i]->lock)
-
 #endif /* CCISS_H */
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 3604b72..9133ad4 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -44,7 +44,7 @@
 #define CCISS_ABORT_MSG 0x00
 #define CCISS_RESET_MSG 0x01
 
-static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
+static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 	size_t size,
 	__u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
@@ -127,16 +127,16 @@ struct cciss_scsi_adapter_data_t {
 	spinlock_t lock; // to protect ccissscsi[ctlr]; 
 };
 
-#define CPQ_TAPE_LOCK(ctlr, flags) spin_lock_irqsave( \
-	&hba[ctlr]->scsi_ctlr->lock, flags);
-#define CPQ_TAPE_UNLOCK(ctlr, flags) spin_unlock_irqrestore( \
-	&hba[ctlr]->scsi_ctlr->lock, flags);
+#define CPQ_TAPE_LOCK(h, flags) spin_lock_irqsave( \
+	&h->scsi_ctlr->lock, flags);
+#define CPQ_TAPE_UNLOCK(h, flags) spin_unlock_irqrestore( \
+	&h->scsi_ctlr->lock, flags);
 
 static CommandList_struct *
 scsi_cmd_alloc(ctlr_info_t *h)
 {
 	/* assume only one process in here at a time, locking done by caller. */
-	/* use CCISS_LOCK(ctlr) */
+	/* use h->lock */
 	/* might be better to rewrite how we allocate scsi commands in a way that */
 	/* needs no locking at all. */
 
@@ -177,10 +177,10 @@ scsi_cmd_alloc(ctlr_info_t *h)
 }
 
 static void 
-scsi_cmd_free(ctlr_info_t *h, CommandList_struct *cmd)
+scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
 {
 	/* assume only one process in here at a time, locking done by caller. */
-	/* use CCISS_LOCK(ctlr) */
+	/* use h->lock */
 	/* drop the free memory chunk on top of the stack. */
 
 	struct cciss_scsi_adapter_data_t *sa;
@@ -193,19 +193,19 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct *cmd)
 		printk("cciss: scsi_cmd_free called too many times.\n");
 		BUG();
 	}
-	stk->elem[stk->top] = (struct cciss_scsi_cmd_stack_elem_t *) cmd;
+	stk->elem[stk->top] = (struct cciss_scsi_cmd_stack_elem_t *) c;
 }
 
 static int
-scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
+scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
 {
 	int i;
 	struct cciss_scsi_cmd_stack_t *stk;
 	size_t size;
 
-	sa->cmd_sg_list = cciss_allocate_sg_chain_blocks(hba[ctlr],
-		hba[ctlr]->chainsize, CMD_STACK_SIZE);
-	if (!sa->cmd_sg_list && hba[ctlr]->chainsize > 0)
+	sa->cmd_sg_list = cciss_allocate_sg_chain_blocks(h,
+		h->chainsize, CMD_STACK_SIZE);
+	if (!sa->cmd_sg_list && h->chainsize > 0)
 		return -ENOMEM;
 
 	stk = &sa->cmd_stack; 
@@ -215,7 +215,7 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
 	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
 	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
-		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
+		pci_alloc_consistent(h->pdev, size, &stk->cmd_pool_handle);
 
 	if (stk->pool == NULL) {
 		cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
@@ -234,13 +234,13 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
 }
 
 static void
-scsi_cmd_stack_free(int ctlr)
+scsi_cmd_stack_free(ctlr_info_t *h)
 {
 	struct cciss_scsi_adapter_data_t *sa;
 	struct cciss_scsi_cmd_stack_t *stk;
 	size_t size;
 
-	sa = hba[ctlr]->scsi_ctlr;
+	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 	if (stk->top != CMD_STACK_SIZE-1) {
 		printk( "cciss: %d scsi commands are still outstanding.\n",
@@ -250,7 +250,7 @@ scsi_cmd_stack_free(int ctlr)
 	}
 	size = sizeof(struct cciss_scsi_cmd_stack_elem_t) * CMD_STACK_SIZE;
 
-	pci_free_consistent(hba[ctlr]->pdev, size, stk->pool, stk->cmd_pool_handle);
+	pci_free_consistent(h->pdev, size, stk->pool, stk->cmd_pool_handle);
 	stk->pool = NULL;
 	cciss_free_sg_chain_blocks(sa->cmd_sg_list, CMD_STACK_SIZE);
 }
@@ -342,20 +342,20 @@ print_cmd(CommandList_struct *cp)
 #endif
 
 static int 
-find_bus_target_lun(int ctlr, int *bus, int *target, int *lun)
+find_bus_target_lun(ctlr_info_t *h, int *bus, int *target, int *lun)
 {
 	/* finds an unused bus, target, lun for a new device */
-	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
+	/* assumes h->scsi_ctlr->lock is held */
 	int i, found=0;
 	unsigned char target_taken[CCISS_MAX_SCSI_DEVS_PER_HBA];
 
 	memset(&target_taken[0], 0, CCISS_MAX_SCSI_DEVS_PER_HBA);
 
 	target_taken[SELF_SCSI_ID] = 1;	
-	for (i=0;i<ccissscsi[ctlr].ndevices;i++)
-		target_taken[ccissscsi[ctlr].dev[i].target] = 1;
+	for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++)
+		target_taken[ccissscsi[h->ctlr].dev[i].target] = 1;
 	
-	for (i=0;i<CCISS_MAX_SCSI_DEVS_PER_HBA;i++) {
+	for (i = 0; i < CCISS_MAX_SCSI_DEVS_PER_HBA; i++) {
 		if (!target_taken[i]) {
 			*bus = 0; *target=i; *lun = 0; found=1;
 			break;
@@ -369,19 +369,19 @@ struct scsi2map {
 };
 
 static int 
-cciss_scsi_add_entry(int ctlr, int hostno, 
+cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
 		struct cciss_scsi_dev_t *device,
 		struct scsi2map *added, int *nadded)
 {
-	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
-	int n = ccissscsi[ctlr].ndevices;
+	/* assumes h->scsi_ctlr->lock is held */
+	int n = ccissscsi[h->ctlr].ndevices;
 	struct cciss_scsi_dev_t *sd;
 	int i, bus, target, lun;
 	unsigned char addr1[8], addr2[8];
 
 	if (n >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
 		printk("cciss%d: Too many devices, "
-			"some will be inaccessible.\n", ctlr);
+			"some will be inaccessible.\n", h->ctlr);
 		return -1;
 	}
 
@@ -397,7 +397,7 @@ cciss_scsi_add_entry(int ctlr, int hostno,
 		memcpy(addr1, device->scsi3addr, 8);
 		addr1[4] = 0;
 		for (i = 0; i < n; i++) {
-			sd = &ccissscsi[ctlr].dev[i];
+			sd = &ccissscsi[h->ctlr].dev[i];
 			memcpy(addr2, sd->scsi3addr, 8);
 			addr2[4] = 0;
 			/* differ only in byte 4? */
@@ -410,9 +410,9 @@ cciss_scsi_add_entry(int ctlr, int hostno,
 		}
 	}
 
-	sd = &ccissscsi[ctlr].dev[n];
+	sd = &ccissscsi[h->ctlr].dev[n];
 	if (lun == 0) {
-		if (find_bus_target_lun(ctlr,
+		if (find_bus_target_lun(h,
 			&sd->bus, &sd->target, &sd->lun) != 0)
 			return -1;
 	} else {
@@ -431,37 +431,37 @@ cciss_scsi_add_entry(int ctlr, int hostno,
 	memcpy(sd->device_id, device->device_id, sizeof(sd->device_id));
 	sd->devtype = device->devtype;
 
-	ccissscsi[ctlr].ndevices++;
+	ccissscsi[h->ctlr].ndevices++;
 
 	/* initially, (before registering with scsi layer) we don't 
 	   know our hostno and we don't want to print anything first 
 	   time anyway (the scsi layer's inquiries will show that info) */
 	if (hostno != -1)
 		printk("cciss%d: %s device c%db%dt%dl%d added.\n", 
-			ctlr, scsi_device_type(sd->devtype), hostno,
+			h->ctlr, scsi_device_type(sd->devtype), hostno,
 			sd->bus, sd->target, sd->lun);
 	return 0;
 }
 
 static void
-cciss_scsi_remove_entry(int ctlr, int hostno, int entry,
+cciss_scsi_remove_entry(ctlr_info_t *h, int hostno, int entry,
 	struct scsi2map *removed, int *nremoved)
 {
-	/* assumes hba[ctlr]->scsi_ctlr->lock is held */ 
+	/* assumes h->ctlr]->scsi_ctlr->lock is held */
 	int i;
 	struct cciss_scsi_dev_t sd;
 
 	if (entry < 0 || entry >= CCISS_MAX_SCSI_DEVS_PER_HBA) return;
-	sd = ccissscsi[ctlr].dev[entry];
+	sd = ccissscsi[h->ctlr].dev[entry];
 	removed[*nremoved].bus    = sd.bus;
 	removed[*nremoved].target = sd.target;
 	removed[*nremoved].lun    = sd.lun;
 	(*nremoved)++;
-	for (i=entry;i<ccissscsi[ctlr].ndevices-1;i++)
-		ccissscsi[ctlr].dev[i] = ccissscsi[ctlr].dev[i+1];
-	ccissscsi[ctlr].ndevices--;
+	for (i = entry; i < ccissscsi[h->ctlr].ndevices-1; i++)
+		ccissscsi[h->ctlr].dev[i] = ccissscsi[h->ctlr].dev[i+1];
+	ccissscsi[h->ctlr].ndevices--;
 	printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-		ctlr, scsi_device_type(sd.devtype), hostno,
+		h->ctlr, scsi_device_type(sd.devtype), hostno,
 			sd.bus, sd.target, sd.lun);
 }
 
@@ -476,24 +476,24 @@ cciss_scsi_remove_entry(int ctlr, int hostno, int entry,
 	(a)[1] == (b)[1] && \
 	(a)[0] == (b)[0])
 
-static void fixup_botched_add(int ctlr, char *scsi3addr)
+static void fixup_botched_add(ctlr_info_t *h, char *scsi3addr)
 {
 	/* called when scsi_add_device fails in order to re-adjust */
 	/* ccissscsi[] to match the mid layer's view. */
 	unsigned long flags;
 	int i, j;
-	CPQ_TAPE_LOCK(ctlr, flags);
-	for (i = 0; i < ccissscsi[ctlr].ndevices; i++) {
+	CPQ_TAPE_LOCK(h, flags);
+	for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++) {
 		if (memcmp(scsi3addr,
-				ccissscsi[ctlr].dev[i].scsi3addr, 8) == 0) {
-			for (j = i; j < ccissscsi[ctlr].ndevices-1; j++)
-				ccissscsi[ctlr].dev[j] =
-					ccissscsi[ctlr].dev[j+1];
-			ccissscsi[ctlr].ndevices--;
+				ccissscsi[h->ctlr].dev[i].scsi3addr, 8) == 0) {
+			for (j = i; j < ccissscsi[h->ctlr].ndevices-1; j++)
+				ccissscsi[h->ctlr].dev[j] =
+					ccissscsi[h->ctlr].dev[j+1];
+			ccissscsi[h->ctlr].ndevices--;
 			break;
 		}
 	}
-	CPQ_TAPE_UNLOCK(ctlr, flags);
+	CPQ_TAPE_UNLOCK(h, flags);
 }
 
 static int device_is_the_same(struct cciss_scsi_dev_t *dev1,
@@ -513,7 +513,7 @@ static int device_is_the_same(struct cciss_scsi_dev_t *dev1,
 }
 
 static int
-adjust_cciss_scsi_table(int ctlr, int hostno,
+adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 	struct cciss_scsi_dev_t sd[], int nsds)
 {
 	/* sd contains scsi3 addresses and devtypes, but
@@ -535,14 +535,14 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 
 	if (!added || !removed) {
 		printk(KERN_WARNING "cciss%d: Out of memory in "
-			"adjust_cciss_scsi_table\n", ctlr);
+			"adjust_cciss_scsi_table\n", h->ctlr);
 		goto free_and_out;
 	}
 
-	CPQ_TAPE_LOCK(ctlr, flags);
+	CPQ_TAPE_LOCK(h, flags);
 
 	if (hostno != -1)  /* if it's not the first time... */
-		sh = hba[ctlr]->scsi_ctlr->scsi_host;
+		sh = h->scsi_ctlr->scsi_host;
 
 	/* find any devices in ccissscsi[] that are not in 
 	   sd[] and remove them from ccissscsi[] */
@@ -550,8 +550,8 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 	i = 0;
 	nremoved = 0;
 	nadded = 0;
-	while(i<ccissscsi[ctlr].ndevices) {
-		csd = &ccissscsi[ctlr].dev[i];
+	while (i < ccissscsi[h->ctlr].ndevices) {
+		csd = &ccissscsi[h->ctlr].dev[i];
 		found=0;
 		for (j=0;j<nsds;j++) {
 			if (SCSI3ADDR_EQ(sd[j].scsi3addr,
@@ -567,19 +567,20 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 		if (found == 0) { /* device no longer present. */ 
 			changes++;
 			/* printk("cciss%d: %s device c%db%dt%dl%d removed.\n",
-				ctlr, scsi_device_type(csd->devtype), hostno,
+				h->ctlr, scsi_device_type(csd->devtype), hostno,
 					csd->bus, csd->target, csd->lun); */
-			cciss_scsi_remove_entry(ctlr, hostno, i,
+			cciss_scsi_remove_entry(h, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
 		} else if (found == 1) { /* device is different in some way */
 			changes++;
 			printk("cciss%d: device c%db%dt%dl%d has changed.\n",
-				ctlr, hostno, csd->bus, csd->target, csd->lun);
-			cciss_scsi_remove_entry(ctlr, hostno, i,
+				h->ctlr, hostno,
+				csd->bus, csd->target, csd->lun);
+			cciss_scsi_remove_entry(h, hostno, i,
 				removed, &nremoved);
 			/* remove ^^^, hence i not incremented */
-			if (cciss_scsi_add_entry(ctlr, hostno, &sd[j],
+			if (cciss_scsi_add_entry(h, hostno, &sd[j],
 				added, &nadded) != 0)
 				/* we just removed one, so add can't fail. */
 					BUG();
@@ -601,8 +602,8 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 
 	for (i=0;i<nsds;i++) {
 		found=0;
-		for (j=0;j<ccissscsi[ctlr].ndevices;j++) {
-			csd = &ccissscsi[ctlr].dev[j];
+		for (j = 0; j < ccissscsi[h->ctlr].ndevices; j++) {
+			csd = &ccissscsi[h->ctlr].dev[j];
 			if (SCSI3ADDR_EQ(sd[i].scsi3addr,
 				csd->scsi3addr)) {
 				if (device_is_the_same(&sd[i], csd))
@@ -614,18 +615,18 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 		}
 		if (!found) {
 			changes++;
-			if (cciss_scsi_add_entry(ctlr, hostno, &sd[i],
+			if (cciss_scsi_add_entry(h, hostno, &sd[i],
 				added, &nadded) != 0)
 				break;
 		} else if (found == 1) {
 			/* should never happen... */
 			changes++;
 			printk(KERN_WARNING "cciss%d: device "
-				"unexpectedly changed\n", ctlr);
+				"unexpectedly changed\n", h->ctlr);
 			/* but if it does happen, we just ignore that device */
 		}
 	}
-	CPQ_TAPE_UNLOCK(ctlr, flags);
+	CPQ_TAPE_UNLOCK(h, flags);
 
 	/* Don't notify scsi mid layer of any changes the first time through */
 	/* (or if there are no changes) scsi_scan_host will do it later the */
@@ -647,7 +648,7 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 			/* timeout as if the device was gone. */
 			printk(KERN_WARNING "cciss%d: didn't find "
 				"c%db%dt%dl%d\n for removal.",
-				ctlr, hostno, removed[i].bus,
+				h->ctlr, hostno, removed[i].bus,
 				removed[i].target, removed[i].lun);
 		}
 	}
@@ -661,11 +662,11 @@ adjust_cciss_scsi_table(int ctlr, int hostno,
 			continue;
 		printk(KERN_WARNING "cciss%d: scsi_add_device "
 			"c%db%dt%dl%d failed, device not added.\n",
-			ctlr, hostno,
+			h->ctlr, hostno,
 			added[i].bus, added[i].target, added[i].lun);
 		/* now we have to remove it from ccissscsi, */
 		/* since it didn't get added to scsi mid layer */
-		fixup_botched_add(ctlr, added[i].scsi3addr);
+		fixup_botched_add(h, added[i].scsi3addr);
 	}
 
 free_and_out:
@@ -675,33 +676,33 @@ free_and_out:
 }
 
 static int
-lookup_scsi3addr(int ctlr, int bus, int target, int lun, char *scsi3addr)
+lookup_scsi3addr(ctlr_info_t *h, int bus, int target, int lun, char *scsi3addr)
 {
 	int i;
 	struct cciss_scsi_dev_t *sd;
 	unsigned long flags;
 
-	CPQ_TAPE_LOCK(ctlr, flags);
-	for (i=0;i<ccissscsi[ctlr].ndevices;i++) {
-		sd = &ccissscsi[ctlr].dev[i];
+	CPQ_TAPE_LOCK(h, flags);
+	for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++) {
+		sd = &ccissscsi[h->ctlr].dev[i];
 		if (sd->bus == bus &&
 		    sd->target == target &&
 		    sd->lun == lun) {
 			memcpy(scsi3addr, &sd->scsi3addr[0], 8);
-			CPQ_TAPE_UNLOCK(ctlr, flags);
+			CPQ_TAPE_UNLOCK(h, flags);
 			return 0;
 		}
 	}
-	CPQ_TAPE_UNLOCK(ctlr, flags);
+	CPQ_TAPE_UNLOCK(h, flags);
 	return -1;
 }
 
 static void 
-cciss_scsi_setup(int cntl_num)
+cciss_scsi_setup(ctlr_info_t *h)
 {
 	struct cciss_scsi_adapter_data_t * shba;
 
-	ccissscsi[cntl_num].ndevices = 0;
+	ccissscsi[h->ctlr].ndevices = 0;
 	shba = (struct cciss_scsi_adapter_data_t *)
 		kmalloc(sizeof(*shba), GFP_KERNEL);	
 	if (shba == NULL)
@@ -709,35 +710,35 @@ cciss_scsi_setup(int cntl_num)
 	shba->scsi_host = NULL;
 	spin_lock_init(&shba->lock);
 	shba->registered = 0;
-	if (scsi_cmd_stack_setup(cntl_num, shba) != 0) {
+	if (scsi_cmd_stack_setup(h, shba) != 0) {
 		kfree(shba);
 		shba = NULL;
 	}
-	hba[cntl_num]->scsi_ctlr = shba;
+	h->scsi_ctlr = shba;
 	return;
 }
 
-static void
-complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
+static void complete_scsi_command(CommandList_struct *c, int timeout,
+	__u32 tag)
 {
 	struct scsi_cmnd *cmd;
-	ctlr_info_t *ctlr;
+	ctlr_info_t *h;
 	ErrorInfo_struct *ei;
 
-	ei = cp->err_info;
+	ei = c->err_info;
 
 	/* First, see if it was a message rather than a command */
-	if (cp->Request.Type.Type == TYPE_MSG)  {
-		cp->cmd_type = CMD_MSG_DONE;
+	if (c->Request.Type.Type == TYPE_MSG)  {
+		c->cmd_type = CMD_MSG_DONE;
 		return;
 	}
 
-	cmd = (struct scsi_cmnd *) cp->scsi_cmd;	
-	ctlr = hba[cp->ctlr];
+	cmd = (struct scsi_cmnd *) c->scsi_cmd;
+	h = hba[c->ctlr];
 
 	scsi_dma_unmap(cmd);
-	if (cp->Header.SGTotal > ctlr->max_cmd_sgentries)
-		cciss_unmap_sg_chain_block(ctlr, cp);
+	if (c->Header.SGTotal > h->max_cmd_sgentries)
+		cciss_unmap_sg_chain_block(h, c);
 
 	cmd->result = (DID_OK << 16); 		/* host byte */
 	cmd->result |= (COMMAND_COMPLETE << 8);	/* msg byte */
@@ -764,9 +765,8 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
                 		{
 #if 0
                     			printk(KERN_WARNING "cciss: cmd %p "
-					"has SCSI Status = %x\n",
-                        			cp,  
-						ei->ScsiStatus); 
+						"has SCSI Status = %x\n",
+						c, ei->ScsiStatus);
 #endif
 					cmd->result |= (ei->ScsiStatus << 1);
                 		}
@@ -786,13 +786,13 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 			case CMD_DATA_UNDERRUN: /* let mid layer handle it. */
 			break;
 			case CMD_DATA_OVERRUN:
-				printk(KERN_WARNING "cciss: cp %p has"
+				printk(KERN_WARNING "cciss: %p has"
 					" completed with data overrun "
-					"reported\n", cp);
+					"reported\n", c);
 			break;
 			case CMD_INVALID: {
-				/* print_bytes(cp, sizeof(*cp), 1, 0);
-				print_cmd(cp); */
+				/* print_bytes(c, sizeof(*c), 1, 0);
+				print_cmd(c); */
      /* We get CMD_INVALID if you address a non-existent tape drive instead
 	of a selection timeout (no response).  You will see this if you yank 
 	out a tape drive, then try to access it. This is kind of a shame
@@ -802,54 +802,52 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
-                                printk(KERN_WARNING "cciss: cp %p has "
-					"protocol error \n", cp);
+				printk(KERN_WARNING "cciss: %p has "
+					"protocol error\n", c);
                         break;
 			case CMD_HARDWARE_ERR:
 				cmd->result = DID_ERROR << 16;
-                                printk(KERN_WARNING "cciss: cp %p had " 
-                                        " hardware error\n", cp);
+				printk(KERN_WARNING "cciss: %p had "
+					" hardware error\n", c);
                         break;
 			case CMD_CONNECTION_LOST:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: cp %p had "
-					"connection lost\n", cp);
+				printk(KERN_WARNING "cciss: %p had "
+					"connection lost\n", c);
 			break;
 			case CMD_ABORTED:
 				cmd->result = DID_ABORT << 16;
-				printk(KERN_WARNING "cciss: cp %p was "
-					"aborted\n", cp);
+				printk(KERN_WARNING "cciss: %p was "
+					"aborted\n", c);
 			break;
 			case CMD_ABORT_FAILED:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: cp %p reports "
-					"abort failed\n", cp);
+				printk(KERN_WARNING "cciss: %p reports "
+					"abort failed\n", c);
 			break;
 			case CMD_UNSOLICITED_ABORT:
 				cmd->result = DID_ABORT << 16;
-				printk(KERN_WARNING "cciss: cp %p aborted "
-					"do to an unsolicited abort\n", cp);
+				printk(KERN_WARNING "cciss: %p aborted "
+					"do to an unsolicited abort\n", c);
 			break;
 			case CMD_TIMEOUT:
 				cmd->result = DID_TIME_OUT << 16;
-				printk(KERN_WARNING "cciss: cp %p timedout\n",
-					cp);
+				printk(KERN_WARNING "cciss: %p timedout\n",
+					c);
 			break;
 			default:
 				cmd->result = DID_ERROR << 16;
-				printk(KERN_WARNING "cciss: cp %p returned "
-					"unknown status %x\n", cp, 
+				printk(KERN_WARNING "cciss: %p returned "
+					"unknown status %x\n", c,
 						ei->CommandStatus); 
 		}
 	}
-	// printk("c:%p:c%db%dt%dl%d ", cmd, ctlr->ctlr, cmd->channel, 
-	//	cmd->target, cmd->lun);
 	cmd->scsi_done(cmd);
-	scsi_cmd_free(ctlr, cp);
+	scsi_cmd_free(h, c);
 }
 
 static int
-cciss_scsi_detect(int ctlr)
+cciss_scsi_detect(ctlr_info_t *h)
 {
 	struct Scsi_Host *sh;
 	int error;
@@ -860,15 +858,15 @@ cciss_scsi_detect(int ctlr)
 	sh->io_port = 0;	// good enough?  FIXME, 
 	sh->n_io_port = 0;	// I don't think we use these two...
 	sh->this_id = SELF_SCSI_ID;  
-	sh->sg_tablesize = hba[ctlr]->maxsgentries;
+	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
 
 	((struct cciss_scsi_adapter_data_t *) 
-		hba[ctlr]->scsi_ctlr)->scsi_host = sh;
-	sh->hostdata[0] = (unsigned long) hba[ctlr];
-	sh->irq = hba[ctlr]->intr[SIMPLE_MODE_INT];
+		h->scsi_ctlr)->scsi_host = sh;
+	sh->hostdata[0] = (unsigned long) h;
+	sh->irq = h->intr[SIMPLE_MODE_INT];
 	sh->unique_id = sh->irq;
-	error = scsi_add_host(sh, &hba[ctlr]->pdev->dev);
+	error = scsi_add_host(sh, &h->pdev->dev);
 	if (error)
 		goto fail_host_put;
 	scsi_scan_host(sh);
@@ -882,20 +880,20 @@ cciss_scsi_detect(int ctlr)
 
 static void
 cciss_unmap_one(struct pci_dev *pdev,
-		CommandList_struct *cp,
+		CommandList_struct *c,
 		size_t buflen,
 		int data_direction)
 {
 	u64bit addr64;
 
-	addr64.val32.lower = cp->SG[0].Addr.lower;
-	addr64.val32.upper = cp->SG[0].Addr.upper;
+	addr64.val32.lower = c->SG[0].Addr.lower;
+	addr64.val32.upper = c->SG[0].Addr.upper;
 	pci_unmap_single(pdev, (dma_addr_t) addr64.val, buflen, data_direction);
 }
 
 static void
 cciss_map_one(struct pci_dev *pdev,
-		CommandList_struct *cp,
+		CommandList_struct *c,
 		unsigned char *buf,
 		size_t buflen,
 		int data_direction)
@@ -903,18 +901,18 @@ cciss_map_one(struct pci_dev *pdev,
 	__u64 addr64;
 
 	addr64 = (__u64) pci_map_single(pdev, buf, buflen, data_direction);
-	cp->SG[0].Addr.lower = 
+	c->SG[0].Addr.lower =
 	  (__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
-	cp->SG[0].Addr.upper =
+	c->SG[0].Addr.upper =
 	  (__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);
-	cp->SG[0].Len = buflen;
-	cp->Header.SGList = (__u8) 1;   /* no. SGs contig in this cmd */
-	cp->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
+	c->SG[0].Len = buflen;
+	c->Header.SGList = (__u8) 1;   /* no. SGs contig in this cmd */
+	c->Header.SGTotal = (__u16) 1; /* total sgs in this cmd list */
 }
 
 static int
-cciss_scsi_do_simple_cmd(ctlr_info_t *c,
-			CommandList_struct *cp,
+cciss_scsi_do_simple_cmd(ctlr_info_t *h,
+			CommandList_struct *c,
 			unsigned char *scsi3addr, 
 			unsigned char *cdb,
 			unsigned char cdblen,
@@ -923,53 +921,52 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *c,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	cp->cmd_type = CMD_IOCTL_PEND;		// treat this like an ioctl 
-	cp->scsi_cmd = NULL;
-	cp->Header.ReplyQueue = 0;  // unused in simple mode
-	memcpy(&cp->Header.LUN, scsi3addr, sizeof(cp->Header.LUN));
-	cp->Header.Tag.lower = cp->busaddr;  // Use k. address of cmd as tag
+	c->cmd_type = CMD_IOCTL_PEND; /* treat this like an ioctl */
+	c->scsi_cmd = NULL;
+	c->Header.ReplyQueue = 0;  /* unused in simple mode */
+	memcpy(&c->Header.LUN, scsi3addr, sizeof(c->Header.LUN));
+	c->Header.Tag.lower = c->busaddr;  /* Use k. address of cmd as tag */
 	// Fill in the request block...
 
 	/* printk("Using scsi3addr 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n", 
 		scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
 		scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]); */
 
-	memset(cp->Request.CDB, 0, sizeof(cp->Request.CDB));
-	memcpy(cp->Request.CDB, cdb, cdblen);
-	cp->Request.Timeout = 0;
-	cp->Request.CDBLen = cdblen;
-	cp->Request.Type.Type = TYPE_CMD;
-	cp->Request.Type.Attribute = ATTR_SIMPLE;
-	cp->Request.Type.Direction = direction;
+	memset(c->Request.CDB, 0, sizeof(c->Request.CDB));
+	memcpy(c->Request.CDB, cdb, cdblen);
+	c->Request.Timeout = 0;
+	c->Request.CDBLen = cdblen;
+	c->Request.Type.Type = TYPE_CMD;
+	c->Request.Type.Attribute = ATTR_SIMPLE;
+	c->Request.Type.Direction = direction;
 
 	/* Fill in the SG list and do dma mapping */
-	cciss_map_one(c->pdev, cp, (unsigned char *) buf,
+	cciss_map_one(h->pdev, c, (unsigned char *) buf,
 			bufsize, DMA_FROM_DEVICE); 
 
-	cp->waiting = &wait;
-	enqueue_cmd_and_start_io(c, cp);
+	c->waiting = &wait;
+	enqueue_cmd_and_start_io(h, c);
 	wait_for_completion(&wait);
 
 	/* undo the dma mapping */
-	cciss_unmap_one(c->pdev, cp, bufsize, DMA_FROM_DEVICE);
+	cciss_unmap_one(h->pdev, c, bufsize, DMA_FROM_DEVICE);
 	return(0);
 }
 
 static void 
-cciss_scsi_interpret_error(CommandList_struct *cp)
+cciss_scsi_interpret_error(CommandList_struct *c)
 {
 	ErrorInfo_struct *ei;
 
-	ei = cp->err_info; 
+	ei = c->err_info;
 	switch(ei->CommandStatus)
 	{
 		case CMD_TARGET_STATUS:
 			printk(KERN_WARNING "cciss: cmd %p has "
-				"completed with errors\n", cp);
+				"completed with errors\n", c);
 			printk(KERN_WARNING "cciss: cmd %p "
 				"has SCSI Status = %x\n",
-					cp,  
-					ei->ScsiStatus);
+					c, ei->ScsiStatus);
 			if (ei->ScsiStatus == 0)
 				printk(KERN_WARNING 
 				"cciss:SCSI status is abnormally zero.  "
@@ -981,78 +978,75 @@ cciss_scsi_interpret_error(CommandList_struct *cp)
 			printk("UNDERRUN\n");
 		break;
 		case CMD_DATA_OVERRUN:
-			printk(KERN_WARNING "cciss: cp %p has"
+			printk(KERN_WARNING "cciss: %p has"
 				" completed with data overrun "
-				"reported\n", cp);
+				"reported\n", c);
 		break;
 		case CMD_INVALID: {
 			/* controller unfortunately reports SCSI passthru's */
 			/* to non-existent targets as invalid commands. */
-			printk(KERN_WARNING "cciss: cp %p is "
+			printk(KERN_WARNING "cciss: %p is "
 				"reported invalid (probably means "
-				"target device no longer present)\n", 
-				cp); 
-			/* print_bytes((unsigned char *) cp, sizeof(*cp), 1, 0);
-			print_cmd(cp);  */
+				"target device no longer present)\n", c);
+			/* print_bytes((unsigned char *) c, sizeof(*c), 1, 0);
+			print_cmd(c);  */
 			}
 		break;
 		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: cp %p has "
-				"protocol error \n", cp);
+			printk(KERN_WARNING "cciss: %p has "
+				"protocol error\n", c);
 		break;
 		case CMD_HARDWARE_ERR:
 			/* cmd->result = DID_ERROR << 16; */
-			printk(KERN_WARNING "cciss: cp %p had " 
-				" hardware error\n", cp);
+			printk(KERN_WARNING "cciss: %p had "
+				" hardware error\n", c);
 		break;
 		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: cp %p had "
-				"connection lost\n", cp);
+			printk(KERN_WARNING "cciss: %p had "
+				"connection lost\n", c);
 		break;
 		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: cp %p was "
-				"aborted\n", cp);
+			printk(KERN_WARNING "cciss: %p was "
+				"aborted\n", c);
 		break;
 		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: cp %p reports "
-				"abort failed\n", cp);
+			printk(KERN_WARNING "cciss: %p reports "
+				"abort failed\n", c);
 		break;
 		case CMD_UNSOLICITED_ABORT:
-			printk(KERN_WARNING "cciss: cp %p aborted "
-				"do to an unsolicited abort\n", cp);
+			printk(KERN_WARNING "cciss: %p aborted "
+				"do to an unsolicited abort\n", c);
 		break;
 		case CMD_TIMEOUT:
-			printk(KERN_WARNING "cciss: cp %p timedout\n",
-				cp);
+			printk(KERN_WARNING "cciss: %p timedout\n", c);
 		break;
 		default:
-			printk(KERN_WARNING "cciss: cp %p returned "
-				"unknown status %x\n", cp, 
-					ei->CommandStatus); 
+			printk(KERN_WARNING "cciss: %p returned "
+				"unknown status %x\n", c, ei->CommandStatus);
 	}
 }
 
 static int
-cciss_scsi_do_inquiry(ctlr_info_t *c, unsigned char *scsi3addr, 
+cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char *scsi3addr,
 	unsigned char page, unsigned char *buf,
 	unsigned char bufsize)
 {
 	int rc;
-	CommandList_struct *cp;
+	CommandList_struct *c;
 	char cdb[6];
 	ErrorInfo_struct *ei;
 	unsigned long flags;
 
-	spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
-	cp = scsi_cmd_alloc(c);
-	spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
+	c = scsi_cmd_alloc(h);
+	spin_unlock_irqrestore(&h->lock, flags);
 
-	if (cp == NULL) {			/* trouble... */
+	if (c == NULL) {			/* trouble... */
 		printk("cmd_alloc returned NULL!\n");
 		return -1;
 	}
 
-	ei = cp->err_info; 
+	ei = c->err_info;
 
 	cdb[0] = CISS_INQUIRY;
 	cdb[1] = (page != 0);
@@ -1060,24 +1054,24 @@ cciss_scsi_do_inquiry(ctlr_info_t *c, unsigned char *scsi3addr,
 	cdb[3] = 0;
 	cdb[4] = bufsize;
 	cdb[5] = 0;
-	rc = cciss_scsi_do_simple_cmd(c, cp, scsi3addr, cdb, 
+	rc = cciss_scsi_do_simple_cmd(h, c, scsi3addr, cdb,
 				6, buf, bufsize, XFER_READ);
 
 	if (rc != 0) return rc; /* something went wrong */
 
 	if (ei->CommandStatus != 0 && 
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-		cciss_scsi_interpret_error(cp);
+		cciss_scsi_interpret_error(c);
 		rc = -1;
 	}
-	spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
-	scsi_cmd_free(c, cp);
-	spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
+	scsi_cmd_free(h, c);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return rc;	
 }
 
 /* Get the device id from inquiry page 0x83 */
-static int cciss_scsi_get_device_id(ctlr_info_t *c, unsigned char *scsi3addr,
+static int cciss_scsi_get_device_id(ctlr_info_t *h, unsigned char *scsi3addr,
 	unsigned char *device_id, int buflen)
 {
 	int rc;
@@ -1088,7 +1082,7 @@ static int cciss_scsi_get_device_id(ctlr_info_t *c, unsigned char *scsi3addr,
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
 		return -1;
-	rc = cciss_scsi_do_inquiry(c, scsi3addr, 0x83, buf, 64);
+	rc = cciss_scsi_do_inquiry(h, scsi3addr, 0x83, buf, 64);
 	if (rc == 0)
 		memcpy(device_id, &buf[8], buflen);
 	kfree(buf);
@@ -1096,20 +1090,20 @@ static int cciss_scsi_get_device_id(ctlr_info_t *c, unsigned char *scsi3addr,
 }
 
 static int
-cciss_scsi_do_report_phys_luns(ctlr_info_t *c, 
+cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
 		ReportLunData_struct *buf, int bufsize)
 {
 	int rc;
-	CommandList_struct *cp;
+	CommandList_struct *c;
 	unsigned char cdb[12];
 	unsigned char scsi3addr[8]; 
 	ErrorInfo_struct *ei;
 	unsigned long flags;
 
-	spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
-	cp = scsi_cmd_alloc(c);
-	spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
-	if (cp == NULL) {			/* trouble... */
+	spin_lock_irqsave(&h->lock, flags);
+	c = scsi_cmd_alloc(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+	if (c == NULL) {			/* trouble... */
 		printk("cmd_alloc returned NULL!\n");
 		return -1;
 	}
@@ -1128,27 +1122,27 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *c,
 	cdb[10] = 0;
 	cdb[11] = 0;
 
-	rc = cciss_scsi_do_simple_cmd(c, cp, scsi3addr, 
+	rc = cciss_scsi_do_simple_cmd(h, c, scsi3addr,
 				cdb, 12, 
 				(unsigned char *) buf, 
 				bufsize, XFER_READ);
 
 	if (rc != 0) return rc; /* something went wrong */
 
-	ei = cp->err_info; 
+	ei = c->err_info;
 	if (ei->CommandStatus != 0 && 
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
-		cciss_scsi_interpret_error(cp);
+		cciss_scsi_interpret_error(c);
 		rc = -1;
 	}
-	spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
-	scsi_cmd_free(c, cp);
-	spin_unlock_irqrestore(CCISS_LOCK(c->ctlr), flags);
+	spin_lock_irqsave(&h->lock, flags);
+	scsi_cmd_free(h, c);
+	spin_unlock_irqrestore(&h->lock, flags);
 	return rc;	
 }
 
 static void
-cciss_update_non_disk_devices(int cntl_num, int hostno)
+cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 {
 	/* the idea here is we could get notified from /proc
 	   that some devices have changed, so we do a report 
@@ -1181,7 +1175,6 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 	ReportLunData_struct *ld_buff;
 	unsigned char *inq_buff;
 	unsigned char scsi3addr[8];
-	ctlr_info_t *c;
 	__u32 num_luns=0;
 	unsigned char *ch;
 	struct cciss_scsi_dev_t *currentsd, *this_device;
@@ -1189,7 +1182,6 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 	int reportlunsize = sizeof(*ld_buff) + CISS_MAX_PHYS_LUN * 8;
 	int i;
 
-	c = (ctlr_info_t *) hba[cntl_num];	
 	ld_buff = kzalloc(reportlunsize, GFP_KERNEL);
 	inq_buff = kmalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
 	currentsd = kzalloc(sizeof(*currentsd) *
@@ -1199,7 +1191,7 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 		goto out;
 	}
 	this_device = &currentsd[CCISS_MAX_SCSI_DEVS_PER_HBA];
-	if (cciss_scsi_do_report_phys_luns(c, ld_buff, reportlunsize) == 0) {
+	if (cciss_scsi_do_report_phys_luns(h, ld_buff, reportlunsize) == 0) {
 		ch = &ld_buff->LUNListLength[0];
 		num_luns = ((ch[0]<<24) | (ch[1]<<16) | (ch[2]<<8) | ch[3]) / 8;
 		if (num_luns > CISS_MAX_PHYS_LUN) {
@@ -1223,7 +1215,7 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 		memset(inq_buff, 0, OBDR_TAPE_INQ_SIZE);
 		memcpy(&scsi3addr[0], &ld_buff->LUN[i][0], 8);
 
-		if (cciss_scsi_do_inquiry(hba[cntl_num], scsi3addr, 0, inq_buff,
+		if (cciss_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
 			(unsigned char) OBDR_TAPE_INQ_SIZE) != 0)
 			/* Inquiry failed (msg printed already) */
 			continue; /* so we will skip this device. */
@@ -1241,7 +1233,7 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 			sizeof(this_device->revision));
 		memset(this_device->device_id, 0,
 			sizeof(this_device->device_id));
-		cciss_scsi_get_device_id(hba[cntl_num], scsi3addr,
+		cciss_scsi_get_device_id(h, scsi3addr,
 			this_device->device_id, sizeof(this_device->device_id));
 
 		switch (this_device->devtype)
@@ -1268,7 +1260,7 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 		  case 0x08: /* medium changer */
 			if (ncurrent >= CCISS_MAX_SCSI_DEVS_PER_HBA) {
 				printk(KERN_INFO "cciss%d: %s ignored, "
-					"too many devices.\n", cntl_num,
+					"too many devices.\n", h->ctlr,
 					scsi_device_type(this_device->devtype));
 				break;
 			}
@@ -1280,7 +1272,7 @@ cciss_update_non_disk_devices(int cntl_num, int hostno)
 		}
 	}
 
-	adjust_cciss_scsi_table(cntl_num, hostno, currentsd, ncurrent);
+	adjust_cciss_scsi_table(h, hostno, currentsd, ncurrent);
 out:
 	kfree(inq_buff);
 	kfree(ld_buff);
@@ -1299,12 +1291,12 @@ is_keyword(char *ptr, int len, char *verb)  // Thanks to ncr53c8xx.c
 }
 
 static int
-cciss_scsi_user_command(int ctlr, int hostno, char *buffer, int length)
+cciss_scsi_user_command(ctlr_info_t *h, int hostno, char *buffer, int length)
 {
 	int arg_len;
 
 	if ((arg_len = is_keyword(buffer, length, "rescan")) != 0)
-		cciss_update_non_disk_devices(ctlr, hostno);
+		cciss_update_non_disk_devices(h, hostno);
 	else
 		return -EINVAL;
 	return length;
@@ -1321,20 +1313,16 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 {
 
 	int buflen, datalen;
-	ctlr_info_t *ci;
+	ctlr_info_t *h;
 	int i;
-	int cntl_num;
 
-
-	ci = (ctlr_info_t *) sh->hostdata[0];
-	if (ci == NULL)  /* This really shouldn't ever happen. */
+	h = (ctlr_info_t *) sh->hostdata[0];
+	if (h == NULL)  /* This really shouldn't ever happen. */
 		return -EINVAL;
 
-	cntl_num = ci->ctlr;	/* Get our index into the hba[] array */
-
 	if (func == 0) {	/* User is reading from /proc/scsi/ciss*?/?*  */
 		buflen = sprintf(buffer, "cciss%d: SCSI host: %d\n",
-				cntl_num, sh->host_no);
+				h->ctlr, sh->host_no);
 
 		/* this information is needed by apps to know which cciss
 		   device corresponds to which scsi host number without
@@ -1344,8 +1332,9 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 		   this info is for an app to be able to use to know how to
 		   get them back in sync. */
 
-		for (i=0;i<ccissscsi[cntl_num].ndevices;i++) {
-			struct cciss_scsi_dev_t *sd = &ccissscsi[cntl_num].dev[i];
+		for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++) {
+			struct cciss_scsi_dev_t *sd =
+				&ccissscsi[h->ctlr].dev[i];
 			buflen += sprintf(&buffer[buflen], "c%db%dt%dl%d %02d "
 				"0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
 				sh->host_no, sd->bus, sd->target, sd->lun,
@@ -1363,15 +1352,15 @@ cciss_scsi_proc_info(struct Scsi_Host *sh,
 			*start = buffer + offset;
 		return(datalen);
 	} else 	/* User is writing to /proc/scsi/cciss*?/?*  ... */
-		return cciss_scsi_user_command(cntl_num, sh->host_no,
+		return cciss_scsi_user_command(h, sh->host_no,
 			buffer, length);	
 } 
 
 /* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci 
    dma mapping  and fills in the scatter gather entries of the 
-   cciss command, cp. */
+   cciss command, c. */
 
-static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
+static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *c,
 	struct scsi_cmnd *cmd)
 {
 	unsigned int len;
@@ -1385,7 +1374,7 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
 
 	chained = 0;
 	sg_index = 0;
-	curr_sg = cp->SG;
+	curr_sg = c->SG;
 	request_nsgs = scsi_dma_map(cmd);
 	if (request_nsgs) {
 		scsi_for_each_sg(cmd, sg, request_nsgs, i) {
@@ -1393,7 +1382,7 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
 				!chained && request_nsgs - i > 1) {
 				chained = 1;
 				sg_index = 0;
-				curr_sg = sa->cmd_sg_list[cp->cmdindex];
+				curr_sg = sa->cmd_sg_list[c->cmdindex];
 			}
 			addr64 = (__u64) sg_dma_address(sg);
 			len  = sg_dma_len(sg);
@@ -1406,19 +1395,19 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
 			++sg_index;
 		}
 		if (chained)
-			cciss_map_sg_chain_block(h, cp,
-				sa->cmd_sg_list[cp->cmdindex],
+			cciss_map_sg_chain_block(h, c,
+				sa->cmd_sg_list[c->cmdindex],
 				(request_nsgs - (h->max_cmd_sgentries - 1)) *
 					sizeof(SGDescriptor_struct));
 	}
 	/* track how many SG entries we are using */
 	if (request_nsgs > h->maxSG)
 		h->maxSG = request_nsgs;
-	cp->Header.SGTotal = (__u8) request_nsgs + chained;
+	c->Header.SGTotal = (__u8) request_nsgs + chained;
 	if (request_nsgs > h->max_cmd_sgentries)
-		cp->Header.SGList = h->max_cmd_sgentries;
+		c->Header.SGList = h->max_cmd_sgentries;
 	else
-		cp->Header.SGList = cp->Header.SGTotal;
+		c->Header.SGList = c->Header.SGTotal;
 	return;
 }
 
@@ -1426,18 +1415,17 @@ static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *cp,
 static int
 cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 {
-	ctlr_info_t *c;
-	int ctlr, rc;
+	ctlr_info_t *h;
+	int rc;
 	unsigned char scsi3addr[8];
-	CommandList_struct *cp;
+	CommandList_struct *c;
 	unsigned long flags;
 
 	// Get the ptr to our adapter structure (hba[i]) out of cmd->host.
 	// We violate cmd->host privacy here.  (Is there another way?)
-	c = (ctlr_info_t *) cmd->device->host->hostdata[0];
-	ctlr = c->ctlr;
+	h = (ctlr_info_t *) cmd->device->host->hostdata[0];
 
-	rc = lookup_scsi3addr(ctlr, cmd->device->channel, cmd->device->id, 
+	rc = lookup_scsi3addr(h, cmd->device->channel, cmd->device->id,
 			cmd->device->lun, scsi3addr);
 	if (rc != 0) {
 		/* the scsi nexus does not match any that we presented... */
@@ -1449,18 +1437,13 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		return 0;
 	}
 
-	/* printk("cciss_queue_command, p=%p, cmd=0x%02x, c%db%dt%dl%d\n", 
-		cmd, cmd->cmnd[0], ctlr, cmd->channel, cmd->target, cmd->lun);*/
-	// printk("q:%p:c%db%dt%dl%d ", cmd, ctlr, cmd->channel, 
-	//	cmd->target, cmd->lun);
-
 	/* Ok, we have a reasonable scsi nexus, so send the cmd down, and
            see what the device thinks of it. */
 
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	cp = scsi_cmd_alloc(c);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-	if (cp == NULL) {			/* trouble... */
+	spin_lock_irqsave(&h->lock, flags);
+	c = scsi_cmd_alloc(h);
+	spin_unlock_irqrestore(&h->lock, flags);
+	if (c == NULL) {			/* trouble... */
 		printk("scsi_cmd_alloc returned NULL!\n");
 		/* FIXME: next 3 lines are -> BAD! <- */
 		cmd->result = DID_NO_CONNECT << 16;
@@ -1472,35 +1455,41 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 
 	cmd->scsi_done = done;    // save this for use by completion code 
 
-	// save cp in case we have to abort it 
-	cmd->host_scribble = (unsigned char *) cp; 
+	/* save c in case we have to abort it */
+	cmd->host_scribble = (unsigned char *) c;
 
-	cp->cmd_type = CMD_SCSI;
-	cp->scsi_cmd = cmd;
-	cp->Header.ReplyQueue = 0;  // unused in simple mode
-	memcpy(&cp->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
-	cp->Header.Tag.lower = cp->busaddr;  // Use k. address of cmd as tag
+	c->cmd_type = CMD_SCSI;
+	c->scsi_cmd = cmd;
+	c->Header.ReplyQueue = 0;  /* unused in simple mode */
+	memcpy(&c->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
+	c->Header.Tag.lower = c->busaddr;  /* Use k. address of cmd as tag */
 	
 	// Fill in the request block...
 
-	cp->Request.Timeout = 0;
-	memset(cp->Request.CDB, 0, sizeof(cp->Request.CDB));
-	BUG_ON(cmd->cmd_len > sizeof(cp->Request.CDB));
-	cp->Request.CDBLen = cmd->cmd_len;
-	memcpy(cp->Request.CDB, cmd->cmnd, cmd->cmd_len);
-	cp->Request.Type.Type = TYPE_CMD;
-	cp->Request.Type.Attribute = ATTR_SIMPLE;
+	c->Request.Timeout = 0;
+	memset(c->Request.CDB, 0, sizeof(c->Request.CDB));
+	BUG_ON(cmd->cmd_len > sizeof(c->Request.CDB));
+	c->Request.CDBLen = cmd->cmd_len;
+	memcpy(c->Request.CDB, cmd->cmnd, cmd->cmd_len);
+	c->Request.Type.Type = TYPE_CMD;
+	c->Request.Type.Attribute = ATTR_SIMPLE;
 	switch(cmd->sc_data_direction)
 	{
-	  case DMA_TO_DEVICE: cp->Request.Type.Direction = XFER_WRITE; break;
-	  case DMA_FROM_DEVICE: cp->Request.Type.Direction = XFER_READ; break;
-	  case DMA_NONE: cp->Request.Type.Direction = XFER_NONE; break;
+	  case DMA_TO_DEVICE:
+		c->Request.Type.Direction = XFER_WRITE;
+		break;
+	  case DMA_FROM_DEVICE:
+		c->Request.Type.Direction = XFER_READ;
+		break;
+	  case DMA_NONE:
+		c->Request.Type.Direction = XFER_NONE;
+		break;
 	  case DMA_BIDIRECTIONAL:
 		// This can happen if a buggy application does a scsi passthru
 		// and sets both inlen and outlen to non-zero. ( see
 		// ../scsi/scsi_ioctl.c:scsi_ioctl_send_command() )
 
-	  	cp->Request.Type.Direction = XFER_RSVD;
+		c->Request.Type.Direction = XFER_RSVD;
 		// This is technically wrong, and cciss controllers should
 		// reject it with CMD_INVALID, which is the most correct 
 		// response, but non-fibre backends appear to let it 
@@ -1516,14 +1505,13 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		BUG();
 		break;
 	}
-	cciss_scatter_gather(c, cp, cmd);
-	enqueue_cmd_and_start_io(c, cp);
+	cciss_scatter_gather(h, c, cmd);
+	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
 }
 
-static void 
-cciss_unregister_scsi(int ctlr)
+static void cciss_unregister_scsi(ctlr_info_t *h)
 {
 	struct cciss_scsi_adapter_data_t *sa;
 	struct cciss_scsi_cmd_stack_t *stk;
@@ -1531,59 +1519,59 @@ cciss_unregister_scsi(int ctlr)
 
 	/* we are being forcibly unloaded, and may not refuse. */
 
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	sa = hba[ctlr]->scsi_ctlr;
+	spin_lock_irqsave(&h->lock, flags);
+	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
 	/* if we weren't ever actually registered, don't unregister */ 
 	if (sa->registered) {
-		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+		spin_unlock_irqrestore(&h->lock, flags);
 		scsi_remove_host(sa->scsi_host);
 		scsi_host_put(sa->scsi_host);
-		spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+		spin_lock_irqsave(&h->lock, flags);
 	}
 
 	/* set scsi_host to NULL so our detect routine will 
 	   find us on register */
 	sa->scsi_host = NULL;
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-	scsi_cmd_stack_free(ctlr);
+	spin_unlock_irqrestore(&h->lock, flags);
+	scsi_cmd_stack_free(h);
 	kfree(sa);
 }
 
-static int 
-cciss_engage_scsi(int ctlr)
+static int cciss_engage_scsi(ctlr_info_t *h)
 {
 	struct cciss_scsi_adapter_data_t *sa;
 	struct cciss_scsi_cmd_stack_t *stk;
 	unsigned long flags;
 
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-	sa = hba[ctlr]->scsi_ctlr;
+	spin_lock_irqsave(&h->lock, flags);
+	sa = h->scsi_ctlr;
 	stk = &sa->cmd_stack; 
 
 	if (sa->registered) {
-		printk("cciss%d: SCSI subsystem already engaged.\n", ctlr);
-		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+		printk(KERN_INFO "cciss%d: SCSI subsystem already engaged.\n",
+			h->ctlr);
+		spin_unlock_irqrestore(&h->lock, flags);
 		return -ENXIO;
 	}
 	sa->registered = 1;
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-	cciss_update_non_disk_devices(ctlr, -1);
-	cciss_scsi_detect(ctlr);
+	spin_unlock_irqrestore(&h->lock, flags);
+	cciss_update_non_disk_devices(h, -1);
+	cciss_scsi_detect(h);
 	return 0;
 }
 
 static void
-cciss_seq_tape_report(struct seq_file *seq, int ctlr)
+cciss_seq_tape_report(struct seq_file *seq, ctlr_info_t *h)
 {
 	unsigned long flags;
 
-	CPQ_TAPE_LOCK(ctlr, flags);
+	CPQ_TAPE_LOCK(h, flags);
 	seq_printf(seq,
 		"Sequential access devices: %d\n\n",
-			ccissscsi[ctlr].ndevices);
-	CPQ_TAPE_UNLOCK(ctlr, flags);
+			ccissscsi[h->ctlr].ndevices);
+	CPQ_TAPE_UNLOCK(h, flags);
 }
 
 static int wait_for_device_to_become_ready(ctlr_info_t *h,
@@ -1615,7 +1603,7 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
-		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0,
+		rc = fill_cmd(h, c, TEST_UNIT_READY, NULL, 0, 0,
 			lunaddr, TYPE_CMD);
 		if (rc == 0)
 			rc = sendcmd_withirq_core(h, c, 0);
@@ -1672,26 +1660,25 @@ static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	int rc;
 	CommandList_struct *cmd_in_trouble;
 	unsigned char lunaddr[8];
-	ctlr_info_t *c;
-	int ctlr;
+	ctlr_info_t *h;
 
 	/* find the controller to which the command to be aborted was sent */
-	c = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
-	if (c == NULL) /* paranoia */
+	h = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
+	if (h == NULL) /* paranoia */
 		return FAILED;
-	ctlr = c->ctlr;
-	printk(KERN_WARNING "cciss%d: resetting tape drive or medium changer.\n", ctlr);
+	printk(KERN_WARNING
+		"cciss%d: resetting tape drive or medium changer.\n", h->ctlr);
 	/* find the command that's giving us trouble */
 	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_in_trouble == NULL) /* paranoia */
 		return FAILED;
 	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd_withirq(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
+	rc = sendcmd_withirq(h, CCISS_RESET_MSG, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
-	if (rc == 0 && wait_for_device_to_become_ready(c, lunaddr) == 0)
+	if (rc == 0 && wait_for_device_to_become_ready(h, lunaddr) == 0)
 		return SUCCESS;
-	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
+	printk(KERN_WARNING "cciss%d: resetting device failed.\n", h->ctlr);
 	return FAILED;
 }
 
@@ -1700,22 +1687,20 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 	int rc;
 	CommandList_struct *cmd_to_abort;
 	unsigned char lunaddr[8];
-	ctlr_info_t *c;
-	int ctlr;
+	ctlr_info_t *h;
 
 	/* find the controller to which the command to be aborted was sent */
-	c = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
-	if (c == NULL) /* paranoia */
+	h = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
+	if (h == NULL) /* paranoia */
 		return FAILED;
-	ctlr = c->ctlr;
-	printk(KERN_WARNING "cciss%d: aborting tardy SCSI cmd\n", ctlr);
+	printk(KERN_WARNING "cciss%d: aborting tardy SCSI cmd\n", h->ctlr);
 
 	/* find the command to be aborted */
 	cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_to_abort == NULL) /* paranoia */
 		return FAILED;
 	memcpy(lunaddr, &cmd_to_abort->Header.LUN.LunAddrBytes[0], 8);
-	rc = sendcmd_withirq(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag,
+	rc = sendcmd_withirq(h, CCISS_ABORT_MSG, &cmd_to_abort->Header.Tag,
 		0, 0, lunaddr, TYPE_MSG);
 	if (rc == 0)
 		return SUCCESS;

