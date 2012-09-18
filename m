Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab2IRKCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:02:13 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:52912 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2IRKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:02:11 -0400
X-ASG-Debug-ID: 1347962529-03d6a50cb5665c10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50584690.9030502@fusionio.com>
Date: Tue, 18 Sep 2012 12:01:52 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block bits for 3.6-final
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block bits for 3.6-final
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1347962529
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.108878
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of driver fixes/updates and a core fix
for 3.6. It contains:

- Bug fixes for mtip32xx, and support for new hardware (just
  addition of IDs). They have been queued up for 3.7 for a few
  weeks as well.

- rate-limit a failing command error message in block core.

- A fix for an old cciss bug from Stephen.

- Prevent overflow of partition count from Alan.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 2453f5f992717251cfadab6184fbb3ec2f2e8b40:

  cciss: fix handling of protocol error (2012-09-18 11:57:08 +0200)

----------------------------------------------------------------
Alan Cox (1):
      blk: add an upper sanity check on partition adding

Asai Thambi S P (6):
      mtip32xx: Add support for new devices
      mtip32xx: Handle NCQ commands during the security locked state
      mtip32xx: Increase timeout for standby command
      mtip32xx: Proper reporting of write protect status on big-endian
      mtip32xx: Change printk to pr_xxxx
      mtip32xx: Remove dead code

David Milburn (1):
      mtip32xx: fix user_buffer check in exec_drive_command

Stephen M. Cameron (1):
      cciss: fix handling of protocol error

Yi Zou (1):
      block: rate-limit the error message from failing commands

 block/blk-core.c                  |  8 +++++---
 block/ioctl.c                     |  2 +-
 drivers/block/cciss_scsi.c        |  1 +
 drivers/block/mtip32xx/mtip32xx.c | 38 +++++++++++++++++++++++---------------
 drivers/block/mtip32xx/mtip32xx.h | 10 +++++++++-
 5 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..ee3cb3a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2254,9 +2254,11 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 			error_type = "I/O";
 			break;
 		}
-		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
-		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
-		       (unsigned long long)blk_rq_pos(req));
+		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+				   error_type, req->rq_disk ?
+				   req->rq_disk->disk_name : "?",
+				   (unsigned long long)blk_rq_pos(req));
+
 	}
 
 	blk_account_io_completion(req, nr_bytes);
diff --git a/block/ioctl.c b/block/ioctl.c
index 4476e0e8..4a85096 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -41,7 +41,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			    sizeof(long long) > sizeof(long)) {
 				long pstart = start, plength = length;
 				if (pstart != start || plength != length
-				    || pstart < 0 || plength < 0)
+				    || pstart < 0 || plength < 0 || partno > 65535)
 					return -EINVAL;
 			}
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 38aa6dd..da33111 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -795,6 +795,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
+				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p has protocol error\n", c);
                         break;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a8fddeb..f946d31 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1148,11 +1148,15 @@ static bool mtip_pause_ncq(struct mtip_port *port,
 	reply = port->rxfis + RX_FIS_D2H_REG;
 	task_file_data = readl(port->mmio+PORT_TFDATA);
 
-	if ((task_file_data & 1) || (fis->command == ATA_CMD_SEC_ERASE_UNIT))
+	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)
+		clear_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
+
+	if ((task_file_data & 1))
 		return false;
 
 	if (fis->command == ATA_CMD_SEC_ERASE_PREP) {
 		set_bit(MTIP_PF_SE_ACTIVE_BIT, &port->flags);
+		set_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
 		port->ic_pause_timer = jiffies;
 		return true;
 	} else if ((fis->command == ATA_CMD_DOWNLOAD_MICRO) &&
@@ -1900,7 +1904,7 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 	int rv = 0, xfer_sz = command[3];
 
 	if (xfer_sz) {
-		if (user_buffer)
+		if (!user_buffer)
 			return -EFAULT;
 
 		buf = dmam_alloc_coherent(&port->dd->pdev->dev,
@@ -2043,7 +2047,7 @@ static void mtip_set_timeout(struct host_to_dev_fis *fis, unsigned int *timeout)
 		*timeout = 240000; /* 4 minutes */
 		break;
 	case ATA_CMD_STANDBYNOW1:
-		*timeout = 10000;  /* 10 seconds */
+		*timeout = 120000;  /* 2 minutes */
 		break;
 	case 0xF7:
 	case 0xFA:
@@ -2588,9 +2592,6 @@ static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
 	if (!len || size)
 		return 0;
 
-	if (size < 0)
-		return -EINVAL;
-
 	size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
 
 	for (n = dd->slot_groups-1; n >= 0; n--)
@@ -2660,9 +2661,6 @@ static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
 	if (!len || size)
 		return 0;
 
-	if (size < 0)
-		return -EINVAL;
-
 	size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
 							dd->port->flags);
 	size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
@@ -3214,8 +3212,8 @@ static int mtip_hw_init(struct driver_data *dd)
 				"Unable to check write protect progress\n");
 	else
 		dev_info(&dd->pdev->dev,
-				"Write protect progress: %d%% (%d blocks)\n",
-				attr242.cur, attr242.data);
+				"Write protect progress: %u%% (%u blocks)\n",
+				attr242.cur, le32_to_cpu(attr242.data));
 	return rv;
 
 out3:
@@ -3619,6 +3617,10 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 			bio_endio(bio, -ENODATA);
 			return;
 		}
+		if (unlikely(test_bit(MTIP_DDF_SEC_LOCK_BIT, &dd->dd_flag))) {
+			bio_endio(bio, -ENODATA);
+			return;
+		}
 	}
 
 	if (unlikely(!bio_has_data(bio))) {
@@ -4168,7 +4170,13 @@ static void mtip_pci_shutdown(struct pci_dev *pdev)
 
 /* Table of device ids supported by this driver. */
 static DEFINE_PCI_DEVICE_TABLE(mtip_pci_tbl) = {
-	{  PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320H_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320S_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P325M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P420H_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P420M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P425M_DEVICE_ID) },
 	{ 0 }
 };
 
@@ -4199,12 +4207,12 @@ static int __init mtip_init(void)
 {
 	int error;
 
-	printk(KERN_INFO MTIP_DRV_NAME " Version " MTIP_DRV_VERSION "\n");
+	pr_info(MTIP_DRV_NAME " Version " MTIP_DRV_VERSION "\n");
 
 	/* Allocate a major block device number to use with this driver. */
 	error = register_blkdev(0, MTIP_DRV_NAME);
 	if (error <= 0) {
-		printk(KERN_ERR "Unable to register block device (%d)\n",
+		pr_err("Unable to register block device (%d)\n",
 		error);
 		return -EBUSY;
 	}
@@ -4213,7 +4221,7 @@ static int __init mtip_init(void)
 	if (!dfs_parent) {
 		dfs_parent = debugfs_create_dir("rssd", NULL);
 		if (IS_ERR_OR_NULL(dfs_parent)) {
-			printk(KERN_WARNING "Error creating debugfs parent\n");
+			pr_warn("Error creating debugfs parent\n");
 			dfs_parent = NULL;
 		}
 	}
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index f51fc23..18627a1 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -76,7 +76,13 @@
 
 /* Micron Vendor ID & P320x SSD Device ID */
 #define PCI_VENDOR_ID_MICRON    0x1344
-#define P320_DEVICE_ID		0x5150
+#define P320H_DEVICE_ID		0x5150
+#define P320M_DEVICE_ID		0x5151
+#define P320S_DEVICE_ID		0x5152
+#define P325M_DEVICE_ID		0x5153
+#define P420H_DEVICE_ID		0x5160
+#define P420M_DEVICE_ID		0x5161
+#define P425M_DEVICE_ID		0x5163
 
 /* Driver name and version strings */
 #define MTIP_DRV_NAME		"mtip32xx"
@@ -131,10 +137,12 @@ enum {
 	MTIP_PF_SVC_THD_STOP_BIT    = 8,
 
 	/* below are bit numbers in 'dd_flag' defined in driver_data */
+	MTIP_DDF_SEC_LOCK_BIT	    = 0,
 	MTIP_DDF_REMOVE_PENDING_BIT = 1,
 	MTIP_DDF_OVER_TEMP_BIT      = 2,
 	MTIP_DDF_WRITE_PROTECT_BIT  = 3,
 	MTIP_DDF_STOP_IO      = ((1 << MTIP_DDF_REMOVE_PENDING_BIT) | \
+				(1 << MTIP_DDF_SEC_LOCK_BIT) | \
 				(1 << MTIP_DDF_OVER_TEMP_BIT) | \
 				(1 << MTIP_DDF_WRITE_PROTECT_BIT)),
 

-- 
Jens Axboe

