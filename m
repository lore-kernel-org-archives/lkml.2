Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1FQLgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:36:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46677 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1FQLf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:35:59 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p5HBZiWp009776, This message is released by code: ctaloc0852
From: <edwin_rong@realsil.com.cn>
To: <error27@gmail.com>, <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: edwin_rong <edwin_rong@realsil.com.cn>
Subject: [PATCH 3/3] Realtek cr: Add autosuspend function.
Date: Fri, 17 Jun 2011 19:35:11 +0800
X-BOX-Message-Id: p5HBZiWp009776
Message-ID: <1308310511-5659-3-git-send-email-edwin_rong@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308310511-5659-1-git-send-email-edwin_rong@realsil.com.cn>
References: <1308310511-5659-1-git-send-email-edwin_rong@realsil.com.cn>
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
 drivers/usb/storage/realtek_cr.c |  377 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 369 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 9798725..58aabe6 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -40,6 +40,10 @@ config USB_STORAGE_REALTEK
 
 	  If this driver is compiled as a module, it will be named ums-realtek.
 
+config REALTEK_AUTOPM
+	bool "Realtek Card Reader autosuspend support"
+	depends on USB_STORAGE_REALTEK && CONFIG_PM_RUNTIME
+	default y
 
 config USB_STORAGE_DATAFAB
 	tristate "Datafab Compact Flash Reader support"
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 2ea0da2..34adc4b 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -24,7 +24,6 @@
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
-#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/version.h>
 
@@ -51,6 +50,35 @@ static int auto_delink_en = 1;
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
@@ -77,7 +105,18 @@ struct rts51x_chip {
 	struct rts51x_status *status;
 	int status_len;
 
-	u32	flag;
+	u32 flag;
+#ifdef CONFIG_REALTEK_AUTOPM
+	struct us_data *us;
+	struct timer_list rts51x_suspend_timer;
+	unsigned long timer_expires;
+	int pwr_state;
+	u8 lun_ready;
+	enum RTS51X_STAT state;
+	int support_auto_delink;
+#endif
+	/* used to back up the protocal choosen in probe1 phase */
+	proto_cmnd proto_handler_backup;
 };
 
 /* flag definition */
@@ -97,9 +136,14 @@ struct rts51x_chip {
 #define RTS51X_GET_VID(chip)		((chip)->vendor_id)
 #define RTS51X_GET_PID(chip)		((chip)->product_id)
 
+#define VENDOR_ID(chip)			((chip)->status[0].vid)
+#define PRODUCT_ID(chip)		((chip)->status[0].pid)
 #define FW_VERSION(chip)		((chip)->status[0].fw_ver)
 #define STATUS_LEN(chip)		((chip)->status_len)
 
+#define STATUS_SUCCESS		0
+#define STATUS_FAIL		1
+
 /* Check card reader function */
 #define SUPPORT_DETAILED_TYPE1(chip)	\
 		CHK_BIT((chip)->status[0].function[0], 1)
@@ -423,6 +467,8 @@ static int config_autodelink_after_power_on(struct us_data *us)
 	int retval;
 	u8 value;
 
+	US_DEBUGP("%s: <---\n", __func__);
+
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -478,6 +524,8 @@ static int config_autodelink_after_power_on(struct us_data *us)
 		}
 	}
 
+	US_DEBUGP("%s: --->\n", __func__);
+
 	return 0;
 }
 
@@ -487,6 +535,8 @@ static int config_autodelink_before_power_down(struct us_data *us)
 	int retval;
 	u8 value;
 
+	US_DEBUGP("%s: <---\n", __func__);
+
 	if (!CHK_AUTO_DELINK(chip))
 		return 0;
 
@@ -547,25 +597,323 @@ static int config_autodelink_before_power_down(struct us_data *us)
 		}
 	}
 
+	US_DEBUGP("%s: --->\n", __func__);
+
+	return 0;
+}
+
+static void fw5895_init(struct us_data *us)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
+	int retval;
+	u8 val;
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
+		US_DEBUGP("Not the specified device, return immediately!\n");
+	} else {
+		retval = rts51x_read_mem(us, 0xFD6F, &val, 1);
+		if (retval == STATUS_SUCCESS && (val & 0x1F) == 0) {
+			val = 0x1F;
+			retval = rts51x_write_mem(us, 0xFD70, &val, 1);
+			if (retval != STATUS_SUCCESS)
+				US_DEBUGP("Write memory fail\n");
+		} else {
+			US_DEBUGP("Read memory fail, OR (val & 0x1F) != 0\n");
+		}
+	}
+
+	US_DEBUGP("%s: --->\n", __func__);
+}
+
+#ifdef CONFIG_REALTEK_AUTOPM
+static void fw5895_set_mmc_wp(struct us_data *us)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)(us->extra);
+	int retval;
+	u8 buf[13];
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	if ((PRODUCT_ID(chip) != 0x0158) || (FW_VERSION(chip) != 0x5895)) {
+		US_DEBUGP("Not the specified device, return immediately!\n");
+	} else {
+		retval = rts51x_read_mem(us, 0xFD6F, buf, 1);
+		if (retval == STATUS_SUCCESS && (buf[0] & 0x24) == 0x24) {
+			/* SD Exist and SD WP */
+			retval = rts51x_read_mem(us, 0xD04E, buf, 1);
+			if (retval == STATUS_SUCCESS) {
+				buf[0] |= 0x04;
+				retval = rts51x_write_mem(us, 0xFD70, buf, 1);
+				if (retval != STATUS_SUCCESS)
+					US_DEBUGP("Write memory fail\n");
+			} else {
+				US_DEBUGP("Read memory fail\n");
+			}
+		} else {
+			US_DEBUGP("Read memory fail, OR (buf[0]&0x24)!=0x24\n");
+		}
+	}
+
+	US_DEBUGP("%s: --->\n", __func__);
+}
+
+static void rts51x_modi_suspend_timer(struct rts51x_chip *chip)
+{
+	US_DEBUGP("%s: <---, state:%d\n", __func__, rts51x_get_stat(chip));
+
+	chip->timer_expires = jiffies + msecs_to_jiffies(1000*ss_delay);
+	mod_timer(&chip->rts51x_suspend_timer, chip->timer_expires);
+
+	US_DEBUGP("%s: --->\n", __func__);
+}
+
+static void rts51x_suspend_timer_fn(unsigned long data)
+{
+	struct rts51x_chip *chip = (struct rts51x_chip *)data;
+	struct us_data *us = chip->us;
+
+	US_DEBUGP("%s: <---\n", __func__);
+
+	switch (rts51x_get_stat(chip)) {
+	case RTS51X_STAT_INIT:
+	case RTS51X_STAT_RUN:
+		rts51x_modi_suspend_timer(chip);
+		break;
+	case RTS51X_STAT_IDLE:
+	case RTS51X_STAT_SS:
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
+	default:
+		US_DEBUGP("%s: Unknonwn state !!!\n", __func__);
+		break;
+	}
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
+						fw5895_set_mmc_wp(us);
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
+	US_DEBUGP("%s: state:%d\n", __func__, rts51x_get_stat(chip));
+	if (rts51x_get_stat(chip) == RTS51X_STAT_RUN)
+		rts51x_modi_suspend_timer(chip);
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
+	rts51x_set_stat(chip, RTS51X_STAT_INIT);
+
+	retval = rts51x_read_status(us, 0, buf, 16, &(chip->status_len));
+	if (retval != STATUS_SUCCESS) {
+		US_DEBUGP("Read status fail\n");
+		return -EIO;
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
+	chip->timer_expires = 0;
+	setup_timer(&chip->rts51x_suspend_timer, rts51x_suspend_timer_fn,
+			(unsigned long)chip);
+	fw5895_init(us);
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
+		del_timer(&chip->rts51x_suspend_timer);
+		chip->timer_expires = 0;
+	}
+#endif
 	kfree(chip->status);
 }
 
 #ifdef CONFIG_PM
-static void realtek_pm_hook(struct us_data *us, int pm_state)
+int realtek_cr_suspend(struct usb_interface *iface, pm_message_t message)
 {
-	if (pm_state == US_SUSPEND)
-		(void)config_autodelink_before_power_down(us);
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
 }
+
+static int realtek_cr_resume(struct usb_interface *iface)
+{
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
+}
+#else
+#define realtek_cr_suspend	NULL
+#define realtek_cr_resume	NULL
 #endif
 
 static int init_realtek_cr(struct us_data *us)
@@ -579,10 +927,6 @@ static int init_realtek_cr(struct us_data *us)
 
 	us->extra = chip;
 	us->extra_destructor = realtek_cr_destructor;
-#ifdef CONFIG_PM
-	us->suspend_resume_hook = realtek_pm_hook;
-#endif
-
 	us->max_lun = chip->max_lun = rts51x_get_max_lun(us);
 
 	US_DEBUGP("chip->max_lun = %d\n", chip->max_lun);
@@ -605,6 +949,12 @@ static int init_realtek_cr(struct us_data *us)
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
 
@@ -645,13 +995,16 @@ static struct usb_driver realtek_cr_driver = {
 	.name = "ums-realtek",
 	.probe = realtek_cr_probe,
 	.disconnect = usb_stor_disconnect,
-	.suspend = usb_stor_suspend,
-	.resume = usb_stor_resume,
+	/* .suspend =      usb_stor_suspend, */
+	/* .resume =       usb_stor_resume, */
 	.reset_resume = usb_stor_reset_resume,
+	.suspend = realtek_cr_suspend,
+	.resume = realtek_cr_resume,
 	.pre_reset = usb_stor_pre_reset,
 	.post_reset = usb_stor_post_reset,
 	.id_table = realtek_cr_ids,
 	.soft_unbind = 1,
+	.supports_autosuspend = 1,
 };
 
 static int __init realtek_cr_init(void)
-- 
1.7.4.1

