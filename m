Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1FPHNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:13:06 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42175 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab1FPHLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:38 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p5G7B91O003616, This message is released by code: ctaloc0852
From: <edwin_rong@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: edwin_rong <edwin_rong@realsil.com.cn>
Subject: [PATCH] Realtek cr: Add autosuspend function.
Date: Thu, 16 Jun 2011 15:10:35 +0800
X-BOX-Message-Id: p5G7B91O003616
Message-ID: <1308208235-3603-1-git-send-email-edwin_rong@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: edwin_rong <edwin_rong@realsil.com.cn>

The autosuspend function can be disabled by unchecking the Macro
CONFIG_REALTEK_AUTOPM in kernel config file, by default, this macro is
turned on.

Signed-off-by: edwin_rong <edwin_rong@realsil.com.cn>
---
 drivers/usb/storage/Kconfig      |    4 +
 drivers/usb/storage/realtek_cr.c |  537 ++++++++++++++++++++++++++++++++------
 2 files changed, 467 insertions(+), 74 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 9798725..d398c5e 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -40,6 +40,10 @@ config USB_STORAGE_REALTEK
 
 	  If this driver is compiled as a module, it will be named ums-realtek.
 
+config REALTEK_AUTOPM
+	bool "Realtek Card Reader autosuspend support"
+	depends on USB_STORAGE_REALTEK
+	default y
 
 config USB_STORAGE_DATAFAB
 	tristate "Datafab Compact Flash Reader support"
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index d509a4a..b94d00e 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -51,6 +51,35 @@ static int auto_delink_en = 1;
 module_param(auto_delink_en, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(auto_delink_en, "enable auto delink");
 
+#ifdef CONFIG_REALTEK_AUTOPM
+static int ss_en = 1;
+module_param(ss_en, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ss_en, "enable selective suspend");
+
+static int ss_delay = 50;
+module_param(ss_delay, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ss_delay,
+		 "seconds to delay before entering selective suspend");
+
+enum RTS51X_STAT {
+	RTS51X_STAT_INIT,
+	RTS51X_STAT_IDLE,
+	RTS51X_STAT_RUN,
+	RTS51X_STAT_SS
+};
+
+#define POLLING_INTERVAL	50
+
+#define rts51x_set_stat(chip, stat)	\
+	((chip)->state = (enum RTS51X_STAT)(stat))
+#define rts51x_get_stat(chip)		((chip)->state)
+
+#define SET_LUN_READY(chip, lun)	((chip)->lun_ready |= ((u8)1 << (lun)))
+#define CLR_LUN_READY(chip, lun)	((chip)->lun_ready &= ~((u8)1 << (lun)))
+#define TST_LUN_READY(chip, lun)	((chip)->lun_ready & ((u8)1 << (lun)))
+
+#endif
+
 struct rts51x_status {
 	u16 vid;
 	u16 pid;
@@ -70,14 +99,27 @@ struct rts51x_status {
 };
 
 struct rts51x_chip {
-	u16			vendor_id;
-	u16			product_id;
-	char			max_lun;
+	u16 vendor_id;
+	u16 product_id;
+	char max_lun;
 
-	struct rts51x_status	*status;
-	int			status_len;
+	struct rts51x_status *status;
+	int status_len;
 
-	u32			flag;
+	u32 flag;
+#ifdef CONFIG_REALTEK_AUTOPM
+	struct us_data *us;
+	struct workqueue_struct *rts51x_wq;
+	struct delayed_work rts51x_delayed_work;
+	int pwr_state;
+	int idle_counter;
+	int ss_counter;
+	u8 lun_ready;
+	enum RTS51X_STAT state;
+	int support_auto_delink;
+#endif
+	/* used to back up the protocal choosen in probe1 phase */
+	proto_cmnd proto_handler_backup;
 };
 
 /* flag definition */
@@ -97,9 +139,28 @@ struct rts51x_chip {
 #define RTS51X_GET_VID(chip)		((chip)->vendor_id)
 #define RTS51X_GET_PID(chip)		((chip)->product_id)
 
+#define VENDOR_ID(chip)			((chip)->status->vid)
+#define PRODUCT_ID(chip)		((chip)->status->pid)
+#ifdef CONFIG_REALTEK_AUTOPM
+#define FW_VERSION(chip)		((chip)->status->fw_ver)
+#else
 #define FW_VERSION(chip)		((chip)->status[0].fw_ver)
+#endif
 #define STATUS_LEN(chip)		((chip)->status_len)
 
+#define STATUS_SUCCESS		0
+#define STATUS_FAIL		1
+
+#ifdef RTSU_DEBUG_MODE
+#define RETURN(ret)	\
+do {			\
+	US_DEBUGP("[%s][%s]:[%d]\n", filename(__FILE__), __func__, __LINE__);\
+	return ret;	\
+} while (0)
+#else
+#define RETURN(ret)	return (ret)
+#endif
+
 /* Check card reader function */
 #define SUPPORT_DETAILED_TYPE1(chip)	\
 		CHK_BIT((chip)->status[0].function[0], 1)
@@ -119,15 +180,6 @@ struct rts51x_chip {
 #define CHECK_ID(chip, pid, fw_ver)	\
 		(CHECK_PID((chip), (pid)) && CHECK_FW_VER((chip), (fw_ver)))
 
-#define wait_timeout_x(task_state, msecs)	\
-do {						\
-	set_current_state((task_state));	\
-	schedule_timeout((msecs) * HZ / 1000);	\
-} while (0)
-
-#define wait_timeout(msecs)		\
-		wait_timeout_x(TASK_INTERRUPTIBLE, (msecs))
-
 static int init_realtek_cr(struct us_data *us);
 
 /*
@@ -143,8 +195,9 @@ static int init_realtek_cr(struct us_data *us);
 
 static const struct usb_device_id realtek_cr_ids[] = {
 #	include "unusual_realtek.h"
-	{ }		/* Terminating entry */
+	{}			/* Terminating entry */
 };
+
 MODULE_DEVICE_TABLE(usb, realtek_cr_ids);
 
 #undef UNUSUAL_DEV
@@ -165,7 +218,7 @@ MODULE_DEVICE_TABLE(usb, realtek_cr_ids);
 
 static struct us_unusual_dev realtek_cr_unusual_dev_list[] = {
 #	include "unusual_realtek.h"
-	{ }		/* Terminating entry */
+	{}			/* Terminating entry */
 };
 
 #undef UNUSUAL_DEV
@@ -174,8 +227,8 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 				 u8 *cmd, int cmd_len, u8 *buf, int buf_len,
 				 enum dma_data_direction dir, int *act_len)
 {
-	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *) us->iobuf;
-	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *) us->iobuf;
+	struct bulk_cb_wrap *bcb = (struct bulk_cb_wrap *)us->iobuf;
+	struct bulk_cs_wrap *bcs = (struct bulk_cs_wrap *)us->iobuf;
 	int result;
 	unsigned int residue;
 	unsigned int cswlen;
@@ -195,7 +248,7 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	/* send it to out endpoint */
 	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
-				bcb, cbwlen, NULL);
+					    bcb, cbwlen, NULL);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -204,24 +257,23 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	if (buf && buf_len) {
 		unsigned int pipe = (dir == DMA_FROM_DEVICE) ?
-				us->recv_bulk_pipe : us->send_bulk_pipe;
+		    us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_transfer_buf(us, pipe,
-				buf, buf_len, NULL);
+						    buf, buf_len, NULL);
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
 	}
 
 	/* get CSW for device status */
 	result = usb_stor_bulk_transfer_buf(us, us->recv_bulk_pipe,
-				bcs, US_BULK_CS_WRAP_LEN, &cswlen);
+					    bcs, US_BULK_CS_WRAP_LEN, &cswlen);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
 	/* check bulk status */
 	if (bcs->Signature != cpu_to_le32(US_BULK_CS_SIGN)) {
 		US_DEBUGP("Signature mismatch: got %08X, expecting %08X\n",
-			  le32_to_cpu(bcs->Signature),
-			  US_BULK_CS_SIGN);
+			  le32_to_cpu(bcs->Signature), US_BULK_CS_SIGN);
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -249,8 +301,8 @@ static int rts51x_bulk_transport(struct us_data *us, u8 lun,
 
 	case US_BULK_STAT_PHASE:
 		/* phase error -- note that a transport reset will be
-			* invoked by the invoke_transport() function
-			*/
+		 * invoked by the invoke_transport() function
+		 */
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -266,10 +318,10 @@ static int rts51x_get_max_lun(struct us_data *us)
 	/* issue the command */
 	us->iobuf[0] = 0;
 	result = usb_stor_control_msg(us, us->recv_ctrl_pipe,
-				 US_BULK_GET_MAX_LUN,
-				 USB_DIR_IN | USB_TYPE_CLASS |
-				 USB_RECIP_INTERFACE,
-				 0, us->ifnum, us->iobuf, 1, 10*HZ);
+				      US_BULK_GET_MAX_LUN,
+				      USB_DIR_IN | USB_TYPE_CLASS |
+				      USB_RECIP_INTERFACE,
+				      0, us->ifnum, us->iobuf, 1, 10 * HZ);
 
 	US_DEBUGP("GetMaxLUN command result is %d, data is %d\n",
 		  result, us->iobuf[0]);
@@ -281,19 +333,19 @@ static int rts51x_get_max_lun(struct us_data *us)
 	return 0;
 }
 
-static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
+static int rts51x_read_mem(struct us_data *us, u16 addr, u8 * data, u16 len)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0D;
-	cmnd[2] = (u8)(addr >> 8);
-	cmnd[3] = (u8)addr;
-	cmnd[4] = (u8)(len >> 8);
-	cmnd[5] = (u8)len;
+	cmnd[2] = (u8) (addr >> 8);
+	cmnd[3] = (u8) addr;
+	cmnd[4] = (u8) (len >> 8);
+	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
 				       data, len, DMA_FROM_DEVICE, NULL);
@@ -303,19 +355,19 @@ static int rts51x_read_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
 	return 0;
 }
 
-static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
+static int rts51x_write_mem(struct us_data *us, u16 addr, u8 * data, u16 len)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 
 	cmnd[0] = 0xF0;
 	cmnd[1] = 0x0E;
-	cmnd[2] = (u8)(addr >> 8);
-	cmnd[3] = (u8)addr;
-	cmnd[4] = (u8)(len >> 8);
-	cmnd[5] = (u8)len;
+	cmnd[2] = (u8) (addr >> 8);
+	cmnd[3] = (u8) addr;
+	cmnd[4] = (u8) (len >> 8);
+	cmnd[5] = (u8) len;
 
 	retval = rts51x_bulk_transport(us, 0, cmnd, 12,
 				       data, len, DMA_TO_DEVICE, NULL);
@@ -329,7 +381,7 @@ static int rts51x_read_status(struct us_data *us,
 			      u8 lun, u8 *status, int len, int *actlen)
 {
 	int retval;
-	u8 cmnd[12] = {0};
+	u8 cmnd[12] = { 0 };
 
 	US_DEBUGP("%s, lun = %d\n", __func__, lun);
 
@@ -356,12 +408,12 @@ static int rts51x_check_status(struct us_data *us, u8 lun)
 
 	US_DEBUGP("chip->status_len = %d\n", chip->status_len);
 
-	chip->status[lun].vid = ((u16)buf[0] << 8) | buf[1];
-	chip->status[lun].pid = ((u16)buf[2] << 8) | buf[3];
+	chip->status[lun].vid = ((u16) buf[0] << 8) | buf[1];
+	chip->status[lun].pid = ((u16) buf[2] << 8) | buf[3];
 	chip->status[lun].cur_lun = buf[4];
 	chip->status[lun].card_type = buf[5];
 	chip->status[lun].total_lun = buf[6];
-	chip->status[lun].fw_ver = ((u16)buf[7] << 8) | buf[8];
+	chip->status[lun].fw_ver = ((u16) buf[7] << 8) | buf[8];
 	chip->status[lun].phy_exist = buf[9];
 	chip->status[lun].multi_flag = buf[10];
 	chip->status[lun].multi_card = buf[11];
@@ -432,6 +484,8 @@ static int config_autodelink_after_power_on(struct us_data *us)
 	int retval;
 	u8 value;
 
+	US_DEBUGP("%s: <---\n", __func__);
+
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -465,7 +519,7 @@ static int config_autodelink_after_power_on(struct us_data *us)
 			CLR_BIT(value, 2);
 
 		if (CHECK_ID(chip, 0x0159, 0x5889) ||
-				CHECK_ID(chip, 0x0138, 0x3880)) {
+		    CHECK_ID(chip, 0x0138, 0x3880)) {
 			CLR_BIT(value, 0);
 			CLR_BIT(value, 7);
 		}
@@ -487,6 +541,8 @@ static int config_autodelink_after_power_on(struct us_data *us)
 		}
 	}
 
+	US_DEBUGP("%s: --->\n", __func__);
+
 	return 0;
 }
 
@@ -496,6 +552,8 @@ static int config_autodelink_before_power_down(struct us_data *us)
 	int retval;
 	u8 value;
 
+	US_DEBUGP("%s: <---\n", __func__);
+
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -528,14 +586,14 @@ static int config_autodelink_before_power_down(struct us_data *us)
 			return -EIO;
 	} else {
 		if (CHECK_ID(chip, 0x0159, 0x5889) ||
-				CHECK_ID(chip, 0x0138, 0x3880) ||
-				CHECK_ID(chip, 0x0138, 0x3882)) {
+		    CHECK_ID(chip, 0x0138, 0x3880) ||
+		    CHECK_ID(chip, 0x0138, 0x3882)) {
 			retval = rts51x_read_mem(us, 0xFE47, &value, 1);
 			if (retval < 0)
 				return -EIO;
 
 			if (CHECK_ID(chip, 0x0159, 0x5889) ||
-					CHECK_ID(chip, 0x0138, 0x3880)) {
+			    CHECK_ID(chip, 0x0138, 0x3880)) {
 				SET_BIT(value, 0);
 				SET_BIT(value, 7);
 			}
@@ -556,25 +614,350 @@ static int config_autodelink_before_power_down(struct us_data *us)
 		}
 	}
 
+	US_DEBUGP("%s: --->\n", __func__);
+
+	return 0;
+}
+
+static int fw5895_init(struct us_data *us)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
+	int retval;
+	u8 val;
+
+	US_DEBUGP("-- %s --\n", __func__);
+
+	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
+		US_DEBUGP("Not the specified device, return immediately!\n");
+		return STATUS_SUCCESS;
+	}
+
+	retval = rts51x_read_mem(us, 0xFD6F, &val, 1);
+	if (retval != STATUS_SUCCESS) {
+		US_DEBUGP("Read memory fail\n");
+		RETURN(STATUS_FAIL);
+	}
+
+	if ((val & 0x1F) == 0) {
+		val = 0x1F;
+		retval = rts51x_write_mem(us, 0xFD70, &val, 1);
+		if (retval != STATUS_SUCCESS) {
+			US_DEBUGP("Write memory fail\n");
+			RETURN(STATUS_FAIL);
+		}
+	}
+
+	return STATUS_SUCCESS;
+}
+
+#ifdef CONFIG_REALTEK_AUTOPM
+static int fw5895_set_mmc_wp(struct us_data *us)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
+	int retval;
+	u8 buf[13];
+
+	US_DEBUGP("-- %s --\n", __func__);
+
+	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
+		US_DEBUGP("Not the specified device, return immediately!\n");
+		return STATUS_SUCCESS;
+	}
+
+	retval = rts51x_read_mem(us, 0xFD6F, buf, 1);
+	if (retval != STATUS_SUCCESS) {
+		US_DEBUGP("Read memory fail\n");
+		RETURN(STATUS_FAIL);
+	}
+	/* SD Exist and SD WP */
+	if ((buf[0] & 0x24) == 0x24) {
+		retval = rts51x_read_mem(us, 0xD04E, buf, 1);
+		if (retval != STATUS_SUCCESS) {
+			US_DEBUGP("Read memory fail\n");
+			RETURN(STATUS_FAIL);
+		}
+
+		buf[0] |= 0x04;
+		retval = rts51x_write_mem(us, 0xFD70, buf, 1);
+		if (retval != STATUS_SUCCESS) {
+			US_DEBUGP("Write memory fail\n");
+			RETURN(STATUS_FAIL);
+		}
+	}
+
+	return STATUS_SUCCESS;
+}
+
+void rts51x_polling(struct work_struct *work)
+{
+	struct rts51x_chip *chip = container_of(work, struct rts51x_chip,
+						rts51x_delayed_work.work);
+	struct us_data *us = chip->us;
+
+	/* lock the device pointers */
+	mutex_lock(&(us->dev_mutex));
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	switch (rts51x_get_stat(chip)) {
+	case RTS51X_STAT_INIT:
+		break;
+	case RTS51X_STAT_RUN:
+		chip->idle_counter = 0;
+		break;
+	case RTS51X_STAT_IDLE:{
+		if (chip->idle_counter <
+				(ss_delay * 1000 / POLLING_INTERVAL)) {
+			US_DEBUGP("%s: idle_counter ++\n", __func__);
+			chip->idle_counter++;
+			break;
+			}
+		}
+	case RTS51X_STAT_SS:{
+		US_DEBUGP("%s: RTS51X_STAT_SS, intf->pm_usage_cnt:%d,"
+			"power.usage:%d\n", __func__,
+			atomic_read(&us->pusb_intf->pm_usage_cnt),
+			atomic_read(&us->pusb_intf->dev.power.usage_count));
+
+		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
+			US_DEBUGP("%s: Ready to enter SS state.\n",
+				  __func__);
+			rts51x_set_stat(chip, RTS51X_STAT_SS);
+			/* ignore mass storage interface's children */
+			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
+			usb_autopm_put_interface(us->pusb_intf);
+			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
+				"intf->pm_usage_cnt:%d, power.usage:%d\n",
+				__func__,
+				atomic_read(&us->pusb_intf->pm_usage_cnt),
+				atomic_read(
+					&us->pusb_intf->dev.power.usage_count));
+		}
+		break;
+		}
+	default:
+		US_DEBUGP("%s: Unknonwn state !!!\n", __func__);
+		break;
+	}
+
+	if (rts51x_get_stat(chip) != RTS51X_STAT_SS)
+		queue_delayed_work(chip->rts51x_wq,
+				   &(chip->rts51x_delayed_work),
+				   POLLING_INTERVAL * HZ / 1000);
+	/* unlock the device pointers */
+	mutex_unlock(&us->dev_mutex);
+
+	US_DEBUGP("%s: --->\n", __func__);
+}
+
+static inline int working_scsi(struct scsi_cmnd *srb)
+{
+	if ((srb->cmnd[0] == TEST_UNIT_READY) ||
+	    (srb->cmnd[0] == ALLOW_MEDIUM_REMOVAL)) {
+		return 0;
+	}
+
+	return 1;
+}
+
+void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
+	static int card_first_show = 1;
+	static u8 media_not_present[] = { 0x70, 0, 0x02, 0, 0, 0, 0,
+		10, 0, 0, 0, 0, 0x3A, 0, 0, 0, 0, 0
+	};
+	static u8 invalid_cmd_field[] = { 0x70, 0, 0x05, 0, 0, 0, 0,
+		10, 0, 0, 0, 0, 0x24, 0, 0, 0, 0, 0
+	};
+	int ret;
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	if (working_scsi(srb)) {
+		US_DEBUGP("%s: working scsi, intf->pm_usage_cnt:%d,"
+			"power.usage:%d\n", __func__,
+			atomic_read(&us->pusb_intf->pm_usage_cnt),
+			atomic_read(&us->pusb_intf->dev.power.usage_count));
+
+		if (atomic_read(&us->pusb_intf->pm_usage_cnt) <= 0) {
+			ret = usb_autopm_get_interface(us->pusb_intf);
+			US_DEBUGP("%s: working scsi, ret=%d\n", __func__, ret);
+		}
+		if (rts51x_get_stat(chip) != RTS51X_STAT_RUN)
+			rts51x_set_stat(chip, RTS51X_STAT_RUN);
+		chip->proto_handler_backup(srb, us);
+	} else {
+		if (rts51x_get_stat(chip) == RTS51X_STAT_SS) {
+			US_DEBUGP("%s: NOT working scsi\n", __func__);
+			if ((srb->cmnd[0] == TEST_UNIT_READY) &&
+			    (chip->pwr_state == US_SUSPEND)) {
+				if (TST_LUN_READY(chip, srb->device->lun)) {
+					srb->result = SAM_STAT_GOOD;
+				} else {
+					srb->result = SAM_STAT_CHECK_CONDITION;
+					memcpy(srb->sense_buffer,
+					       media_not_present,
+					       US_SENSE_SIZE);
+				}
+				US_DEBUGP("%s: TEST_UNIT_READY--->\n",
+					  __func__);
+				goto out;
+			}
+			if (srb->cmnd[0] == ALLOW_MEDIUM_REMOVAL) {
+				int prevent = srb->cmnd[4] & 0x1;
+				if (prevent) {
+					srb->result = SAM_STAT_CHECK_CONDITION;
+					memcpy(srb->sense_buffer,
+					       invalid_cmd_field,
+					       US_SENSE_SIZE);
+				} else {
+					srb->result = SAM_STAT_GOOD;
+				}
+				US_DEBUGP("%s: ALLOW_MEDIUM_REMOVAL--->\n",
+					  __func__);
+				goto out;
+			}
+		} else {
+			US_DEBUGP("%s: NOT working scsi, not SS\n", __func__);
+			chip->proto_handler_backup(srb, us);
+			/* Check wether card is plugged in */
+			if (srb->cmnd[0] == TEST_UNIT_READY) {
+				if (srb->result == SAM_STAT_GOOD) {
+					SET_LUN_READY(chip, srb->device->lun);
+					if (card_first_show) {
+						card_first_show = 0;
+						(void)fw5895_set_mmc_wp(us);
+					}
+				} else {
+					CLR_LUN_READY(chip, srb->device->lun);
+					card_first_show = 1;
+				}
+			}
+			if (rts51x_get_stat(chip) != RTS51X_STAT_IDLE)
+				rts51x_set_stat(chip, RTS51X_STAT_IDLE);
+		}
+	}
+out:
+	if (rts51x_get_stat(chip) != RTS51X_STAT_SS)
+		queue_delayed_work(chip->rts51x_wq,
+				   &(chip->rts51x_delayed_work),
+				   POLLING_INTERVAL * HZ / 1000);
+
+	US_DEBUGP("%s: --->\n", __func__);
+}
+
+static int realtek_cr_autosuspend_setup(struct us_data *us)
+{
+	struct rts51x_chip *chip;
+	struct rts51x_status *status = NULL;
+	u8 buf[16];
+	int retval;
+
+	chip = (struct rts51x_chip *)us->extra;
+	chip->support_auto_delink = 0;
+	chip->pwr_state = US_RESUME;
+	chip->lun_ready = 0;
+	chip->ss_counter = 0;
+	rts51x_set_stat(chip, RTS51X_STAT_INIT);
+
+	retval = rts51x_read_status(us, 0, buf, 16, &(chip->status_len));
+	if (retval != STATUS_SUCCESS) {
+		US_DEBUGP("Read status fail\n");
+		RETURN(-EIO);
+	}
+	status = chip->status;
+	status->vid = ((u16) buf[0] << 8) | buf[1];
+	status->pid = ((u16) buf[2] << 8) | buf[3];
+	status->cur_lun = buf[4];
+	status->card_type = buf[5];
+	status->total_lun = buf[6];
+	status->fw_ver = ((u16) buf[7] << 8) | buf[8];
+	status->phy_exist = buf[9];
+	status->multi_flag = buf[10];
+	status->multi_card = buf[11];
+	status->log_exist = buf[12];
+	if (chip->status_len == 16) {
+		status->detailed_type.detailed_type1 = buf[13];
+		status->function[0] = buf[14];
+		status->function[1] = buf[15];
+	}
+
+	/* back up the proto_handler in us->extra */
+	chip = (struct rts51x_chip *)(us->extra);
+	chip->proto_handler_backup = us->proto_handler;
+	/* Set the autosuspend_delay to 0 */
+	pm_runtime_set_autosuspend_delay(&us->pusb_dev->dev, 0);
+	/* override us->proto_handler setted in get_protocol() */
+	us->proto_handler = rts51x_invoke_transport;
+
+	chip->rts51x_wq = create_workqueue("rts51x-wq");
+	INIT_DELAYED_WORK(&(chip->rts51x_delayed_work), rts51x_polling);
+	queue_delayed_work(chip->rts51x_wq, &(chip->rts51x_delayed_work),
+			   5 * HZ);
+
+	(void)fw5895_init(us);
+
+	/* enable autosuspend funciton of the usb device */
+	usb_enable_autosuspend(us->pusb_dev);
+
 	return 0;
 }
+#endif
 
 static void realtek_cr_destructor(void *extra)
 {
 	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
 
+	US_DEBUGP("%s: <---\n", __func__);
+
 	if (!chip)
 		return;
-
+#ifdef CONFIG_REALTEK_AUTOPM
+	if (ss_en) {
+		flush_workqueue(chip->rts51x_wq);
+		cancel_delayed_work(&(chip->rts51x_delayed_work));
+		destroy_workqueue(chip->rts51x_wq);
+	}
+#endif
 	kfree(chip->status);
 }
 
 #ifdef CONFIG_PM
-static void realtek_pm_hook(struct us_data *us, int pm_state)
+int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
+{
+	struct us_data *us = usb_get_intfdata(iface);
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	/* wait until no command is running */
+	mutex_lock(&us->dev_mutex);
+
+	config_autodelink_before_power_down(us);
+
+	mutex_unlock(&us->dev_mutex);
+
+	US_DEBUGP("%s: --->\n", __func__);
+
+	return 0;
+}
+
+static int realtek_cr_resume(struct usb_interface *iface)
 {
-	if (pm_state == US_SUSPEND)
-		(void)config_autodelink_before_power_down(us);
+	struct us_data *us = usb_get_intfdata(iface);
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	fw5895_init(us);
+	config_autodelink_after_power_on(us);
+
+	US_DEBUGP("%s: --->\n", __func__);
+
+	return 0;
 }
+#else
+#define realtek_cr_suspend	NULL
+#define realtek_cr_resume	NULL
 #endif
 
 static int init_realtek_cr(struct us_data *us)
@@ -585,13 +968,8 @@ static int init_realtek_cr(struct us_data *us)
 	chip = kzalloc(sizeof(struct rts51x_chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
-
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
-#ifdef CONFIG_PM
-	us->suspend_resume_hook = realtek_pm_hook;
-#endif
-
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 
 	US_DEBUGP("chip->max_lun = %d\n", chip->max_lun);
@@ -602,18 +980,24 @@ static int init_realtek_cr(struct us_data *us)
 		goto INIT_FAIL;
 
 	for (i = 0; i <= (int)(chip->max_lun); i++) {
-		retval = rts51x_check_status(us, (u8)i);
+		retval = rts51x_check_status(us, (u8) i);
 		if (retval < 0)
 			goto INIT_FAIL;
 	}
 
 	if (CHECK_FW_VER(chip, 0x5888) || CHECK_FW_VER(chip, 0x5889) ||
-			CHECK_FW_VER(chip, 0x5901))
+	    CHECK_FW_VER(chip, 0x5901))
 		SET_AUTO_DELINK(chip);
 	if (STATUS_LEN(chip) == 16) {
 		if (SUPPORT_AUTO_DELINK(chip))
 			SET_AUTO_DELINK(chip);
 	}
+#ifdef CONFIG_REALTEK_AUTOPM
+	if (ss_en) {
+		chip->us = us;
+		realtek_cr_autosuspend_setup(us);
+	}
+#endif
 
 	US_DEBUGP("chip->flag = 0x%x\n", chip->flag);
 
@@ -632,7 +1016,7 @@ INIT_FAIL:
 }
 
 static int realtek_cr_probe(struct usb_interface *intf,
-			 const struct usb_device_id *id)
+			    const struct usb_device_id *id)
 {
 	struct us_data *us;
 	int result;
@@ -640,25 +1024,30 @@ static int realtek_cr_probe(struct usb_interface *intf,
 	US_DEBUGP("Probe Realtek Card Reader!\n");
 
 	result = usb_stor_probe1(&us, intf, id,
-			(id - realtek_cr_ids) + realtek_cr_unusual_dev_list);
+				 (id - realtek_cr_ids) +
+				 realtek_cr_unusual_dev_list);
 	if (result)
 		return result;
 
 	result = usb_stor_probe2(us);
+
 	return result;
 }
 
 static struct usb_driver realtek_cr_driver = {
-	.name =		"ums-realtek",
-	.probe =	realtek_cr_probe,
-	.disconnect =	usb_stor_disconnect,
-	.suspend =	usb_stor_suspend,
-	.resume =	usb_stor_resume,
-	.reset_resume =	usb_stor_reset_resume,
-	.pre_reset =	usb_stor_pre_reset,
-	.post_reset =	usb_stor_post_reset,
-	.id_table =	realtek_cr_ids,
-	.soft_unbind =	1,
+	.name = "ums-realtek",
+	.probe = realtek_cr_probe,
+	.disconnect = usb_stor_disconnect,
+	/* .suspend =      usb_stor_suspend, */
+	/* .resume =       usb_stor_resume, */
+	.reset_resume = usb_stor_reset_resume,
+	.suspend = realtek_cr_suspend,
+	.resume = realtek_cr_resume,
+	.pre_reset = usb_stor_pre_reset,
+	.post_reset = usb_stor_post_reset,
+	.id_table = realtek_cr_ids,
+	.soft_unbind = 1,
+	.supports_autosuspend = 1,
 };
 
 static int __init realtek_cr_init(void)
-- 
1.7.4.1

