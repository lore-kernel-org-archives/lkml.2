Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2JQF6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:58:05 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:36064 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2JQF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:58:01 -0400
From: Scott Liu <scott.liu@emc.com.tw>
To: Scott Liu <scott.liu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>
Subject: [PATCH v1] Support Elan Touchscreen eKTF product.
Date: Wed, 17 Oct 2012 05:57:59 +0800
Message-Id: <1350424679-20725-1-git-send-email-scott.liu@emc.com.tw>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for Elan eKTF Touchscreen product, I2C adpater module.

This driver adds communication support with Elan eKTF controller using I2C bus.

Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
---
 drivers/input/touchscreen/Kconfig      |    9 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/elants_i2c.c | 3182 ++++++++++++++++++++++++++++++++
 include/linux/i2c/elants.h             |   61 +
 4 files changed, 3253 insertions(+)
 create mode 100644 drivers/input/touchscreen/elants_i2c.c
 create mode 100644 include/linux/i2c/elants.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 1ba232c..50e6f05 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -237,6 +237,15 @@ config TOUCHSCREEN_EETI
 	  To compile this driver as a module, choose M here: the
 	  module will be called eeti_ts.
 
+config TOUCHSCREEN_ELAN
+         tristate "Elan touchscreen panel support"
+         depends on I2C
+         help
+           Say Y here to enable support for I2C connected Elan touch panels.
+
+           To compile this driver as a module, choose M here: the
+           module will be called elants_i2c.
+
 config TOUCHSCREEN_EGALAX
 	tristate "EETI eGalax multi-touch panel support"
 	depends on I2C
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 178eb12..428a631 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_TOUCHSCREEN_EDT_FT5X06)	+= edt-ft5x06.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
 obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti_ts.o
+obj-$(CONFIG_TOUCHSCREEN_ELAN)		+= elants_i2c.o
 obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
 obj-$(CONFIG_TOUCHSCREEN_EGALAX)	+= egalax_ts.o
 obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
new file mode 100644
index 0000000..d87b2ef
--- /dev/null
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -0,0 +1,3182 @@
+/*
+ * Elan Microelectronics touchpanels with I2C interface
+ *
+ * Copyright (C) 2012 Elan Microelectronics Corporation.
+ * Scott Liu <scott.liu@emc.com.tw>
+ *
+ * This code is partly based on hid-multitouch.c:
+ *
+ *  Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
+ *  Copyright (c) 2010-2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ *  Copyright (c) 2010-2012 Ecole Nationale de l'Aviation Civile, France
+ *
+ */
+
+/*
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ */
+
+#define CHIP_NUM        2
+
+/* Reserved for having platform to test */
+#define MT_TYPE_B       0
+
+/* Define it if using on Android system */
+#define ANDROID         0
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/jiffies.h>
+#include <linux/hrtimer.h>
+#include <linux/timer.h>
+#include <linux/kthread.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/buffer_head.h>
+#include <linux/version.h>
+#include <linux/kfifo.h>
+#include <linux/slab.h>
+#if (ANDROID)
+#include <linux/wakelock.h>
+#include <linux/earlysuspend.h>
+#endif
+#if (MT_TYPE_B)
+#include <linux/input/mt.h>
+#endif
+
+/* debug option */
+static bool debug = false;
+module_param(debug, bool, 0444);
+MODULE_PARM_DESC(debug, "print a lot of debug information");
+
+#define elan_dbg(client, fmt, arg...)   \
+	if (debug)      \
+		dev_printk(KERN_DEBUG, &client->dev, fmt, ##arg)
+
+/*=================================================
+ *  Marco
+ *================================================= */
+#define DRV_NAME        "elants_i2c"
+
+#define DRV_MA_VER 2
+#define DRV_MI_VER 0
+#define DRV_SUB_MI_VER 0
+
+#define _str(s) #s
+#define str(s)  _str(s)
+#define DRIVER_VERSION  str(DRV_MA_VER.DRV_MI_VER.DRV_SUB_MI_VER)
+
+
+#define IDX_PACKET_SIZE_4FIG    17
+#define IDX_PACKET_SIZE_WIDTH   40
+
+#define FINGER_NUM      10
+
+#define PWR_STATE_DEEP_SLEEP	0
+#define PWR_STATE_NORMAL        1
+#define PWR_STATE_MASK          BIT(3)
+
+#define CMD_S_PKT       0x52
+#define CMD_R_PKT       0x53
+#define CMD_W_PKT       0x54
+
+#define HELLO_PKT       0x55
+#define NORMAL_PKT      0x62
+
+#define RESET_PKT       0x77
+#define CALIB_PKT       0xA8
+
+#define FINGER_ID       1
+
+#define FIFO_SIZE       (64)
+
+
+/*! Convert from rows or columns into resolution */
+#define ELAN_TS_RESOLUTION(n)   ((n - 1) * 64)
+
+static const char hello_packet[4] = { 0x55, 0x55, 0x55, 0x55 };
+static const char iniap_packet[4] = { 0x55, 0xaa, 0x33, 0xcc };
+static const char recov_packet[4] = { 0x55, 0x55, 0x80, 0x80 };
+
+#include <linux/i2c/elants.h>
+
+/*! Firmware protocol status flag */
+#define PRO_I2C_WRT_CMD_SYNC	0x00000001
+#define PRO_HID_MOD_CHECKSUM    0x00000002
+#define PRO_UPDATE_FW_MODE      0x00000080
+
+
+/*! driver status flag, should move to public header file */
+#define STA_NONINIT         0x00000001
+#define STA_INIT            0x00000002
+#define STA_INIT2           0x00000004
+#define STA_INIT3           0x00000100
+#define STA_INIT4           0x00000200
+#define STA_PROBED          0x00000008
+#define STA_ERR_HELLO_PKT   0x00000010
+#define STA_USE_IRQ         0x00000020
+#define STA_SLEEP_MODE      0x00000040
+
+/*=======================================
+ *  Structure Definition
+ *=======================================*/
+
+/*! @enum elan i2c address definition */
+enum elan_i2c_addr {
+	elan_i2c_master = 0x10,
+	elan_i2c_slave1 = 0x20,
+	elan_i2c_slave2 = 0x21,
+
+	elan_i2c_maxnum = 3,
+};
+
+
+/*! @enum finger_report_header Finger report header byte definition */
+enum finger_report_header {
+	idx_coordinate_packet_4_finger = 0x5c,
+	idx_coordinate_packet_10_finger = 0x62,
+};
+
+/*! @enum fw_queue_report_hdr FW Queue report header definition */
+enum fw_queue_report_hdr {
+	queue_header_byte_Single = 0x62,
+	queue_header_byte_normal = 0x63,
+	queue_header_byte_wait = 0x64,
+	queue_header_size = 4,
+	queue_packet_max_len = queue_header_size + (IDX_PACKET_SIZE_WIDTH * 3),
+};
+
+/*! @enum fw_normal_cmd_hdr FW Normal command header definition */
+enum fw_normal_cmd_hdr {
+	cmd_header_byte_write = 0x54,
+	cmd_header_byte_read = 0x53,
+	cmd_header_byte_response = 0x52,
+	cmd_header_byte_hello = 0x55,
+	cmd_response_len = 4
+};
+
+/*! @enum fw_info_pos FW information position */
+enum fw_info_pos {
+	idx_finger_header = 0,
+	idx_finger_state = 1,
+	idx_finger_total = 2,
+	idx_finger_checksum = 34,
+	idx_finger_width = 35,
+	idx_4finger_checksum = 17,
+	idx_finger_width_checksum = 34,
+};
+
+/*! @enum lock_bit Lock bit definition */
+enum lock_bit {
+	idx_file_operate = 0,
+	idx_cmd_handshake = 1,
+	idx_finger_report = 2,
+	idx_test_mode = 3,
+};
+
+enum kfifo_ret {
+	ret_ok = 0,
+	ret_cmdrsp = 1,
+	ret_fail = -1,
+};
+
+typedef enum elan_boot_e {
+	E_BOOT_NORM = 0,
+	E_BOOT_IAP = 1
+} elan_boot_t;
+
+/* FW read command, 0x53 0x?? 0x0, 0x01 */
+enum {
+	E_ELAN_INFO_FW_VER = 0x00,
+	E_ELAN_INFO_BC_VER = 0x10,
+	E_ELAN_INFO_FW_ID = 0xf0
+};
+
+
+/*! @struct <multi_queue_header> */
+struct multi_queue_header {
+	u8		packet_id;
+	u8		report_count;
+	u8		report_length;
+	u8		reserved;
+};
+
+/*! @brief elan_polling */
+struct elan_polling {
+	struct workqueue_struct *elan_wq;	/* polling work queue */
+	struct timer_list timer;	/* Polling intr_gpio timer */
+	u8 int_status;				/* polling intr gpio status */
+};
+
+
+/* finger handler, refer to hid-multitouch.c */
+struct mt_slot {
+	__s32 x, y, p, w, h;
+	__s32 contactid;	/* the device ContactID assigned to this slot */
+	bool touch_state;	/* is the touch valid? */
+	bool seen_in_this_frame;/* has this slot been updated */
+};
+
+struct mt_device {
+	struct mt_slot curdata;	/* placeholder of incoming data */
+	__u8 num_received;	/* how many contacts we received */
+	__u8 num_expected;	/* expected last contact index */
+	__u8 maxcontacts;
+	bool curvalid;		/* is the current contact valid? */
+	struct mt_slot *slots;
+};
+
+
+/**
+*
+* @brief elants_data
+*
+* all variable should include in this struct.
+*
+*/
+struct elants_data {
+	int intr_gpio;		/* interupter pin*/
+	int rst_gpio;		/* reset pin*/
+	int use_irq;
+	u8 major_fw_version;
+	u8 minor_fw_version;
+	u8 major_bc_version;
+	u8 minor_bc_version;
+	u8 major_hw_id;
+	u8 minor_hw_id;
+	bool fw_enabled;	/* True if firmware device enabled*/
+	int rows;			/* Panel geometry for input layer*/
+	int cols;
+	int x_max;
+	int y_max;
+	/* Power state 0:sleep 1:active*/
+	u8 power_state;
+	/* TS is in IAP mode already*/
+#define IAP_MODE_ENABLE		1
+	/* 1 : Firmware update mode
+		0 : normal*/
+	unsigned int iap_mode;
+	unsigned int rx_size;		/* Read size in use*/
+
+	/* Multi-queue info */
+	struct multi_queue_header mq_header;
+
+	/* our i2c client*/
+	struct i2c_client *client;
+	/* input device*/
+	struct input_dev *input;
+	/* normal function work thread*/
+	struct workqueue_struct *elan_wq;
+	/* normal function work queue*/
+	struct work_struct work;
+	/* start probe start*/
+	struct task_struct	*thread;
+	/* char device for ioctl and IAP*/
+	struct miscdevice firmware;
+	/* use timer if use_irq == 0*/
+	struct hrtimer timer;
+	/*	regular polling work thread*/
+	struct work_struct pollingwork;
+	/*	regular polling work queue*/
+	struct elan_polling polling;
+#if (ANDROID)
+	struct early_suspend early_suspend;
+	/*	avoid sleep during IAP.*/
+	struct wake_lock wakelock;
+#endif
+
+	/* Protects I2C accesses to device*/
+	struct mutex mutex;
+	/* Protects I2C tx/rx*/
+	struct mutex tr_mutex;
+
+	/* Lock openers*/
+	unsigned long busy;
+	/* Protocol stats for firmware*/
+	unsigned int protocol;
+
+	/* elan-iap i2c address*/
+	unsigned short i2caddr;
+
+	/* fifo and processing */
+	struct kfifo fifo;
+
+	/* Serialize operations around FIFO */
+	struct mutex fifo_mutex;
+	wait_queue_head_t wait;
+	spinlock_t rx_kfifo_lock;
+
+	/* boot log */
+	u8 boot_log[256];
+
+	/*! Add for TS driver debug */
+	unsigned int status;
+	long int irq_received;
+	long int packet_received;
+	long int packet_fail;
+	long int touched_sync;
+	long int no_touched_sync;
+	long int checksum_correct;
+	long int wdt_reset;
+	u16 checksum_fail;
+	u16 header_fail;
+	u16	mq_header_fail;
+	u16 drop_frame;
+
+	/* mt device */
+	struct mt_device td;
+};
+
+
+
+/*/============================================
+ *  Function prototype
+ *=============================================*/
+static int elants_set_data(struct i2c_client *client,
+						   const u8 *data,
+						   size_t len);
+static int elants_async_recv_data(struct i2c_client *client,
+								  const uint8_t *cmd,
+								  uint8_t *buf,
+								  size_t tx_size,
+								  size_t rx_size);
+
+static void elants_drop_packet(struct elants_data *ts);
+static irqreturn_t elants_work_func(int irq, void *work);
+
+static irqreturn_t elants_irq_handler(int irq, void *dev_id);
+static int elan_hw_reset(struct i2c_client *client);
+static int elan_touch_pull_frame(struct elants_data *ts, u8 *buf);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+static void elants_early_suspend(struct early_suspend *h);
+static void elants_late_resume(struct early_suspend *h);
+#endif
+
+
+/*=================================================
+ *  Global variable
+ *=================================================*/
+
+/*! for elan-iap char driver */
+static struct miscdevice *private_ts;
+static bool old_bootcode = false;
+
+static u8 tp_device_addr[3] = {elan_i2c_master,
+							   elan_i2c_slave1,
+							   elan_i2c_slave2
+							  };
+
+
+#define elants_acqurie_data(a, cmd, buf, c) \
+	elants_async_recv_data(a, cmd, buf, c, c)
+
+/*=================================================
+ *  Function implement
+ *=================================================*/
+static inline void elan_msleep(u32 t)
+{
+	/*
+	 * If the sleeping time is 10us - 20ms, usleep_range() is recommended.
+	 * Read Documentation/timers/timers-howto.txt
+	*/
+	usleep_range(t*1000, t*1000 + 500);
+}
+
+/**
+ *	@brief __issue_bootcode_cmd	-	hadle bootcode status.
+ *	@param client : our i2c device
+ *
+ *	@return { >0 means success,
+ *			otherwise fail. }
+ *
+ *	Enter Normal mode packet is {0x55, 0x55, 0x55, 0x55}
+ *	2012/3/1	won't issue bootcmd in normal driver initial flow.
+ */
+static int elan_bootcode_cmd(struct i2c_client *client,
+							 u8 passcode)
+{
+	int rc = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+	u8 command[2][4] = {
+		{0x45, 0x49, 0x41, 0xFF},	/* normal_command */
+		{0x45, 0x49, 0x41, 0x50},	/* iap_command */
+	};
+
+	/* Detect old / new FW */
+	elan_msleep(90);
+
+	if (gpio_get_value(ts->intr_gpio) == 0) {
+		/* Old FW */
+		pr_warn("detect intr!!!!! OLD BC detect\n");
+		return -2;
+	}
+
+	if (passcode > E_BOOT_IAP)
+		return -1;
+
+	elan_dbg(client, "passcode = %x:%x:%x:%x\n",
+			 command[passcode][0],
+			 command[passcode][1],
+			 command[passcode][2],
+			 command[passcode][3]);
+
+	mutex_lock(&ts->mutex);
+
+	ts->i2caddr = elan_i2c_slave2;
+	rc = elants_set_data(client, command[passcode], 4);
+	if (rc < 0)
+		dev_err(&ts->client->dev,
+				"[ELAN] set passcode[%d] fail\n", passcode);
+
+	ts->i2caddr = elan_i2c_slave1;
+	rc = elants_set_data(client, command[passcode], 4);
+	if (rc < 0)
+		dev_err(&ts->client->dev,
+				"[ELAN] set passcode[%d] fail\n", passcode);
+
+	ts->i2caddr = elan_i2c_master;
+	rc = elants_set_data(client, command[passcode], 4);
+	if (rc < 0)
+		dev_err(&ts->client->dev,
+				"[ELAN] set passcode[%d] fail\n", passcode);
+
+	/* normal communitcat interactives with Master. */
+	ts->i2caddr = elan_i2c_master;
+	mutex_unlock(&ts->mutex);
+
+	return rc;
+}
+
+/**
+*	@brief \b elan_iap_open	- char device
+*
+*	purpose for ioctl and iap updating fw.
+*/
+int elan_iap_open(struct inode *inode, struct file *filp)
+{
+	struct elants_data *ts ;
+
+	filp->private_data = private_ts;
+	ts = container_of(filp->private_data,
+					  struct elants_data, firmware);
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	return 0;
+}
+
+/**
+*	@brief  \b elan_iap_release	- char device
+*
+*	purpose for close this device
+*/
+int elan_iap_release(struct inode *inode, struct file *filp)
+{
+	struct elants_data *ts =
+		container_of(filp->private_data,
+					 struct elants_data, firmware);
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	return 0;
+}
+
+/**
+*	@brief  \b elan_iap_write	- iap write page data
+*	@param buff is page data from user space
+*	@param count is number of data in byte.
+*
+*	purpose for iap write page data
+*/
+ssize_t elan_iap_write(struct file *filp,
+					   const char *buff,
+					   size_t count,
+					   loff_t *offp)
+{
+	struct elants_data *ts =
+		container_of(filp->private_data,
+					 struct elants_data, firmware);
+	int ret;
+	u8	txbuf[256];
+	struct i2c_adapter *adap = ts->client->adapter;
+	struct i2c_msg msg;
+
+	if (count > 256)
+		return -EMSGSIZE;
+
+	if (copy_from_user(txbuf, buff, count))
+		return -EFAULT;
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.len = count;
+	msg.buf = (char *)txbuf;
+
+	ret = i2c_transfer(adap, &msg, 1);
+	if (ret != 1)
+		dev_err(&ts->client->dev,
+				"[ELAN] i2c_master_send fail, ret=%d\n", ret);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (ret == 1) ? count : ret;
+}
+
+/**
+*	@brief  \b elan_iap_read	- read status code from TP
+*
+*	purpose for iap read status code from TP
+*/
+ssize_t elan_iap_read(struct file *filp,
+					  char *buff,
+					  size_t count,
+					  loff_t *offp)
+{
+	struct elants_data *ts =
+		container_of(filp->private_data,
+					 struct elants_data, firmware);
+	u8	rxbuf[256];
+	int ret;
+	struct i2c_adapter *adap = ts->client->adapter;
+	struct i2c_msg msg;
+
+	if (count > 256)
+		return -EMSGSIZE;
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.flags |= I2C_M_RD;
+	msg.len = count;
+	msg.buf = rxbuf;
+
+	ret = i2c_transfer(adap, &msg, 1);
+	if (ret == 1)
+		if (copy_to_user(buff, rxbuf, count))
+			return -EFAULT;
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (ret == 1) ? count : ret;
+}
+
+/**
+*	@brief  \b elan_iap_ioctl	- ioctl
+*	@param cmd to control our TP device.
+*	@param arg is parameter from user space
+*
+*	purpose  is that control our TP by char device node.
+*/
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
+static int elan_iap_ioctl(struct inode *inode,
+						  struct file *filp,
+						  unsigned int cmd,
+						  unsigned long arg)
+#else
+static long elan_iap_ioctl(struct file *filp,
+						   unsigned int cmd,
+						   unsigned long arg)
+#endif
+{
+	struct elants_data *ts =
+		container_of(filp->private_data,
+					 struct elants_data, firmware);
+	int __user *argp = (int __user *)arg;
+	u8 len, buf[32];
+	int rc;
+
+	switch (cmd) {
+	case IOCTL_I2C_SLAVE:
+		ts->i2caddr = (unsigned short)arg;
+		break;
+	case IOCTL_MAJOR_FW_VER:
+		put_user(ts->major_fw_version, argp);
+		break;
+	case IOCTL_MINOR_FW_VER:
+		put_user(ts->minor_fw_version, argp);
+		break;
+	case IOCTL_CHECK_RECOVERY_MODE:
+		put_user(ts->iap_mode, argp);
+		break;
+	case  IOCTL_IAP_ENABLE: {
+		disable_irq(ts->client->irq);
+#if (ANDROID)
+		wake_lock(&ts->wakelock);
+#endif
+		ts->protocol |= PRO_UPDATE_FW_MODE;
+	}
+	break;
+	case  IOCTL_IAP_DISABLE:
+		ts->protocol &= ~PRO_UPDATE_FW_MODE;
+#if (ANDROID)
+		wake_unlock(&ts->wakelock);
+#endif
+		enable_irq(ts->client->irq);
+		break;
+	case  IOCTL_BOOTCODE_CMD: {
+		int mode;
+
+		len = 1;
+		if (copy_from_user(buf, (const void *)arg, len))
+			return -EFAULT;
+
+		mode = buf[0];
+		rc = elan_bootcode_cmd(ts->client, (u8)mode);
+		if (rc < 0) {
+			elan_dbg(ts->client,
+					 "elan_bootcode_command error\n");
+			return -1;
+		}
+	}
+	break;
+	case IOCTL_RESET:
+		pr_warn("[ELAN] IOCTL_RESET\n");
+		rc = elan_hw_reset(ts->client);
+		if (rc < 0) {
+			elan_dbg(ts->client,
+					 "[ELAN] elan_hw_reset error\n");
+			return -1;
+		}
+		break;
+	case IOCTL_I2C_INT:
+		put_user(gpio_get_value(ts->intr_gpio), argp);
+		break;
+	case IOCTL_SET_COMMAND: {
+		struct i2c_client *client = ts->client;
+		struct elan_ioctl_data idata;
+
+		if (copy_from_user(&idata.len,
+						   (const void *)arg,
+						   sizeof(idata.len))) {
+			dev_err(&client->dev,
+					"IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					buf[0], buf[1], buf[2], buf[3]);
+			return -EFAULT;
+		}
+
+		if (copy_from_user(&idata,
+						   (const void *)arg,
+						   idata.len + sizeof(int))) {
+			dev_err(&client->dev,
+					"IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					buf[0], buf[1], buf[2], buf[3]);
+			return -EFAULT;
+		}
+		dev_dbg(&ts->client->dev,
+				"IOCTL_SET_COMMAND:%x:%x:%x:%x\n",
+				idata.buf[0],
+				idata.buf[1],
+				idata.buf[2],
+				idata.buf[3]);
+
+		if (idata.buf[0] != CMD_R_PKT &&
+			idata.buf[0] != CMD_W_PKT)
+			return -EFAULT;
+
+		mutex_lock(&ts->mutex);
+		elants_set_data(ts->client,
+						(const u8 *)idata.buf,
+						idata.len);
+		mutex_unlock(&ts->mutex);
+	}
+	break;
+	case  IOCTL_GET_COMMAND: {
+		int rc = 0;
+		struct i2c_client *client = ts->client;
+		struct elan_ioctl_data idata;
+
+		/* Get command length first */
+		if (copy_from_user(&idata.len,
+						   (const void *)arg,
+						   sizeof(idata.len))) {
+			dev_err(&client->dev,
+					"IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					buf[0], buf[1], buf[2], buf[3]);
+			return -EFAULT;
+		}
+
+		/* Get command real length then */
+		if (copy_from_user(&idata, (const void *)arg,
+						   idata.len + sizeof(int))) {
+			dev_err(&client->dev,
+					"IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					buf[0], buf[1], buf[2], buf[3]);
+			return -EFAULT;
+		}
+
+		if (idata.buf[0] != CMD_R_PKT && idata.buf[0] != CMD_W_PKT)
+			return -EFAULT;
+
+		pr_info("[ELAN] IOCTL_GET_COMMAND %x:%x:%x:%x\n",
+				idata.buf[0], idata.buf[1], idata.buf[2], idata.buf[3]);
+
+		mutex_lock(&ts->mutex);
+
+		set_bit(idx_cmd_handshake, &ts->busy);
+
+		elants_set_data(client, idata.buf, idata.len);
+		mutex_unlock(&ts->mutex);
+
+		/* We will wait for non O_NONBLOCK handles until a signal or data */
+		mutex_lock(&ts->fifo_mutex);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+		while (kfifo_len(ts->fifo) == 0) {
+#else
+		while (kfifo_len(&ts->fifo) == 0) {
+#endif
+			mutex_unlock(&ts->fifo_mutex);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+			rc = wait_event_interruptible_timeout(
+					 ts->wait, kfifo_len(ts->fifo),
+					 msecs_to_jiffies(3000));
+#else
+			rc = wait_event_interruptible_timeout(
+					 ts->wait, kfifo_len(&ts->fifo),
+					 msecs_to_jiffies(3000));
+#endif
+			if (rc <= 0) {
+				rc = -ETIMEDOUT;
+				dev_err(&client->dev,
+						"timeout!! wake_up(ts->wait)\n");
+				goto err2;
+			}
+			mutex_lock(&ts->fifo_mutex);
+		}
+		if (elan_touch_pull_frame(ts, idata.buf) < 0) {
+			rc = -1;
+			goto err1;
+		}
+
+err1:
+		mutex_unlock(&ts->fifo_mutex);
+err2:
+		clear_bit(idx_cmd_handshake, &ts->busy);
+
+		dev_dbg(&client->dev,
+				"[ELAN] Leave %s\n", __func__);
+
+		if (rc < 0) {
+			rc = copy_to_user((void __user *)arg,
+							  (void *)&idata,
+							  4+sizeof(len));
+			return -rc;
+		}
+
+		elan_dbg(client,
+				 "Reponse=%x:%x:%x:%x\n",
+				 idata.buf[0],
+				 idata.buf[1],
+				 idata.buf[2],
+				 idata.buf[3]);
+
+		if (copy_to_user((void __user *)arg,
+						 (void *)&idata,
+						 sizeof(idata)))
+			return -EFAULT;
+
+	}
+	break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static const struct file_operations elan_touch_fops = {
+	.owner = THIS_MODULE,
+	.open = elan_iap_open,
+	.write = elan_iap_write,
+	.read = elan_iap_read,
+	.release = elan_iap_release,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 36)
+	.ioctl = elan_iap_ioctl,
+#else
+	.unlocked_ioctl = elan_iap_ioctl,
+#endif
+};
+
+
+/**
+ *	@brief interfaces
+ *	provide the hardware and firmware information
+ */
+static ssize_t show_fw_version_value(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+	return sprintf(buf, "%.2x %.2x\n",
+				   ts->major_fw_version,
+				   ts->minor_fw_version);
+}
+
+
+static ssize_t show_bc_version_value(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%.2x %.2x\n",
+				   ts->major_bc_version,
+				   ts->minor_bc_version);
+}
+
+static ssize_t show_drvver_value(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	return sprintf(buf, "%s\n", DRIVER_VERSION);
+}
+
+
+static ssize_t show_intr_gpio(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	int ret = 0;
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+	ret = gpio_get_value(ts->intr_gpio);
+
+	return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t show_adapter_pkt_rvd(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+	return sprintf(buf, "irq_received=%ld packet_received=%ld packet_fail=%ld \
+						mq_hdr_fail=%d, checksum_fail=%x header_fail=%d, \
+						poll_timer=%d, wdt_reset=%ld\n",
+				   ts->irq_received, ts->packet_received,
+				   ts->packet_fail, ts->mq_header_fail,
+				   ts->checksum_fail, ts->header_fail,
+				   ts->drop_frame, ts->wdt_reset);
+}
+
+static ssize_t show_queue_count(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+	return sprintf(buf, "queue_report_count=%d, report_length=%d\n",
+				   ts->mq_header.report_count, ts->mq_header.report_length);
+}
+
+
+static ssize_t store_power_mode(
+	struct device *dev,
+	struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long val;
+	const char AcMode[] = {0x54, 0x30, 0x00, 0x01};
+	const char BtMode[] = {0x54, 0x38, 0x00, 0x01};
+	char cmd[4];
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	switch (val) {
+	case 0:
+		memcpy(cmd, AcMode, sizeof(AcMode));
+		break;
+	case 1:
+		memcpy(cmd, BtMode, sizeof(BtMode));
+		break;
+	default:
+		return -1;
+	}
+
+	mutex_lock(&ts->mutex);
+	elants_set_data(ts->client, cmd, sizeof(cmd));
+	mutex_unlock(&ts->mutex);
+
+	return count;
+}
+
+static ssize_t show_power_mode(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	const char RespCmd[] = {0x53, 0x30, 0x00, 0x01};
+	char tbuf[4];
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return -1;
+
+
+	mutex_lock(&ts->mutex);
+	set_bit(idx_cmd_handshake, &ts->busy);
+	elants_acqurie_data(ts->client, RespCmd, tbuf, sizeof(RespCmd));
+	if (tbuf[0] != cmd_header_byte_response) {
+		dev_err(&client->dev,
+				"exception!! %x:%x:%x:%x\n",
+				tbuf[0], tbuf[1], tbuf[2], tbuf[3]);
+		elants_drop_packet(ts);
+		memset(tbuf, 0x0, sizeof(tbuf));
+	}
+	clear_bit(idx_cmd_handshake, &ts->busy);
+	mutex_unlock(&ts->mutex);
+
+	return sprintf(buf, "%x:%x:%x:%x\n",
+				   tbuf[0], tbuf[1], tbuf[2], tbuf[3]);
+}
+
+static ssize_t show_report_rate(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+	long int old_frame, new_frame;
+
+	old_frame = ts->packet_received;
+	ssleep(1);
+	new_frame = ts->packet_received;
+
+	return sprintf(buf, "%ld\n", new_frame - old_frame);
+}
+
+static ssize_t show_iap_mode(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client =
+		container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%s\n",
+				   (ts->iap_mode == 0) ? "Normal" : "Recovery");
+}
+
+static ssize_t show_recal(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	u8 w_flashkey[4] = {0x54, 0xC0, 0xE1, 0x5A};
+	u8 rek[4] = {0x54, 0x29, 0x00, 0x01};
+
+	ts->i2caddr = elan_i2c_master;
+	elants_set_data(client, w_flashkey, 4);
+	elan_msleep(1);
+	elants_set_data(client, rek, 4);
+
+	return sprintf(buf, "%s\n", "re-K finish");
+}
+
+
+static ssize_t show_boot_log(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	/* show boot status, allow user cat this log during iap mode enable!! */
+
+	return scnprintf(buf, PAGE_SIZE, ts->boot_log);
+}
+
+
+static DEVICE_ATTR(power_mode, S_IRUGO|S_IWUGO,
+				   show_power_mode, store_power_mode);
+static DEVICE_ATTR(queue_count, S_IRUGO, show_queue_count, NULL);
+static DEVICE_ATTR(drv_version, S_IRUGO, show_drvver_value, NULL);
+static DEVICE_ATTR(fw_version, S_IRUGO, show_fw_version_value, NULL);
+static DEVICE_ATTR(bc_version, S_IRUGO, show_bc_version_value, NULL);
+static DEVICE_ATTR(ts_packet, S_IRUGO, show_adapter_pkt_rvd, NULL);
+static DEVICE_ATTR(gpio, S_IRUGO, show_intr_gpio, NULL);
+static DEVICE_ATTR(report_rate, S_IRUGO, show_report_rate, NULL);
+static DEVICE_ATTR(boot_log, S_IRUGO, show_boot_log, NULL);
+static DEVICE_ATTR(iap_mode, S_IRUGO, show_iap_mode, NULL);
+static DEVICE_ATTR(rek, S_IRUGO, show_recal, NULL);
+
+
+
+static struct attribute *elan_attributes[] = {
+	&dev_attr_power_mode.attr,
+	&dev_attr_queue_count.attr,
+	&dev_attr_fw_version.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_bc_version.attr,
+	&dev_attr_gpio.attr,
+	&dev_attr_ts_packet.attr,
+	&dev_attr_report_rate.attr,
+	&dev_attr_boot_log.attr,
+	&dev_attr_iap_mode.attr,
+	&dev_attr_rek.attr,
+
+	NULL
+};
+
+
+static struct attribute_group elan_attribute_group = {
+	.name	= "elants",
+	.attrs	= elan_attributes,
+};
+
+
+/**
+ *	@brief elan_hw_reset		-	h/w reset.
+ *	@param client : our i2c device
+ *
+ *	@retval >0 means reset success,	\n
+ *	otherwise is fail.
+ *
+ */
+static int elan_hw_reset(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int ret;
+
+	if (ts->rst_gpio < 0)
+		return -1;
+
+	ret = gpio_direction_output(ts->rst_gpio, 0);
+	if (ret < 0) {
+		pr_err("gpio_direction fail!\n");
+		return ret;
+	}
+
+	elan_msleep(2);
+
+	ret = gpio_direction_output(ts->rst_gpio, 1);
+	if (ret < 0)
+		return ret;
+
+	/* wait > 10ms to ensure that fw is in IAP mode */
+	msleep(20);
+
+	return ret;
+}
+
+
+
+/**
+ *	@brief elan_ts_poll		-	polling intr pin status.
+ *	@param client : our i2c device
+ *
+ *	@retval 0 means intr pin is low,	\n
+ *	otherwise is high.
+ *
+ *	polling intr pin untill low and the maximus wait time is \b 200ms.
+ */
+static int elan_ts_poll(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int status = 0, retry = 20;
+
+	do {
+		status = gpio_get_value(ts->intr_gpio);
+		elan_dbg(client,
+				 "%s: status = %d\n", __func__, status);
+		retry--;
+		mdelay(10);
+	} while (status != 0 && retry > 0);
+
+	elan_dbg(client,
+			 "%s: poll interrupt status %s\n",
+			 __func__, status == 1 ? "high" : "low");
+	return (status == 0 ? 0 : -ETIMEDOUT);
+}
+
+/**
+ *	@brief  \b elan_ts_set_data		-	set command to TP.
+ *	@param client : our i2c device
+ *	@param data : command or data which will send to TP.
+ *	@param len : command length usually.
+ *
+ *	set command to our TP.
+ */
+static int elants_set_data(struct i2c_client *client,
+						   const u8 *data, size_t len)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct i2c_adapter *adap = client->adapter;
+	struct i2c_msg msg;
+	int rc = 0;
+
+	dev_dbg(&client->dev, "[ELAN] Enter: %s\n", __func__);
+	elan_dbg(client,
+			 "dump cmd: %02x, %02x, %02x, %02x, addr=%x\n",
+			 data[0], data[1], data[2], data[3], ts->i2caddr);
+
+	mutex_lock(&ts->tr_mutex);
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.len = len;
+	msg.buf = (char *)data;
+
+	rc = i2c_transfer(adap, &msg, 1);
+	if (rc != 1)
+		dev_err(&ts->client->dev,
+				"[ELAN] i2c_transfer write fail, rc=%d\n", rc);
+
+	mutex_unlock(&ts->tr_mutex);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (rc == 1) ? len : rc;
+
+}
+
+/**
+ *	@brief  \b elan_ts_get_data		-	set command to TP.
+ *	@param client : our i2c device
+ *	@param data : data to be received from TP.
+ *	@param len : command length usually.
+ *
+ *	get data from our TP.
+ */
+static int elants_get_data(
+	struct i2c_client *client,
+	const u8 *buf,
+	size_t len)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct i2c_adapter *adap = client->adapter;
+	struct i2c_msg msg;
+	int rc = 0;
+
+	dev_dbg(&client->dev,
+			"[ELAN] Enter: %s id:0x%x\n", __func__, ts->i2caddr);
+
+	mutex_lock(&ts->tr_mutex);
+
+	msg.addr = ts->i2caddr;
+	msg.flags = client->flags & I2C_M_TEN;
+	msg.flags |= I2C_M_RD;
+	msg.len = len;
+	msg.buf = (char *)buf;
+
+	rc = i2c_transfer(adap, &msg, 1);
+	if (rc != 1)
+		dev_err(&client->dev,
+				"[ELAN] i2c_transfer read fail, rc=%d\n", rc);
+
+	mutex_unlock(&ts->tr_mutex);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (rc == 1) ? len : rc;
+}
+
+/**
+ *	@brief  \b elants_is_iap		-	is it in iap mode ?
+ *	@param client : our i2c device
+ *	@param addr : i2c address
+ *
+ *	check whether fw currently is in iap.
+ *	@return :
+ *		 < 0 :normal mode
+ *		 > 0 :iap mode or abnormal.
+ */
+static int elants_is_iap(
+	struct i2c_client *client,
+	u16 addr)
+{
+	int rc;
+	uint8_t buf_recv[4] = {0};
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	ts->i2caddr = addr;
+	rc = elants_get_data(client, buf_recv, 4);
+	if ((rc < 0) || memcmp(buf_recv, iniap_packet, 4)) {
+		dev_err(&client->dev,
+				"[elan] %s: ID 0x%x can't boot IAP!\n",
+				__func__, addr);
+		rc = -EINVAL;
+	}
+
+	ts->i2caddr = elan_i2c_master;
+
+	return rc;
+}
+
+static int elants_boot(
+	struct i2c_client *client,
+	u16 addr,
+	elan_boot_t type)
+{
+	int rc;
+	struct elants_data *ts = i2c_get_clientdata(client);
+	uint8_t command[2][4] = {
+		{0x4D, 0x61, 0x69, 0x6E},	/* normal_command */
+		{0x45, 0x49, 0x41, 0x50},	/* iap_command */
+	};
+
+	ts->i2caddr = addr;
+	rc = elants_set_data(client, command[(int32_t)type], 4);
+	if (rc != 4) {
+		if (type == E_BOOT_IAP)
+			dev_err(&client->dev,
+					"[elan] Boot IAP fail, error=%d\n",
+					rc);
+		else
+			dev_dbg(&client->dev,
+					"[elan] Boot normal fail, error=%d\n",
+					rc);
+		ts->i2caddr = elan_i2c_master;
+		return -EINVAL;
+	}
+	pr_info("[elan] Boot success -- 0x%x\n", addr);
+	ts->i2caddr = elan_i2c_master;
+	return 0;
+}
+
+static int elants_enter_iap(struct i2c_client *client)
+{
+	int rc = 0, i;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	elan_hw_reset(client);
+
+	/* Boot devices to IAP mode */
+	for (i = 0; i < CHIP_NUM; i++) {
+		rc = elants_boot(client, tp_device_addr[i], E_BOOT_IAP);
+		if (rc < 0)
+			return rc;
+	}
+
+	elan_msleep(10);
+
+	/* Check if devices can enter IAP mode */
+	for (i = 0; i < CHIP_NUM; i++) {
+		rc = elants_is_iap(client, tp_device_addr[i]);
+		if (rc < 0)
+			return rc;
+	}
+
+	ts->iap_mode = IAP_MODE_ENABLE;
+	ts->protocol = ts->protocol |  PRO_UPDATE_FW_MODE;
+	ts->i2caddr = elan_i2c_master;
+
+	return rc;
+}
+
+
+/**
+ *	@brief  \b elan_ts_async_recv_data		-	get TP status
+ *	@param client : our i2c device
+ *	@param cmd : asking command
+ *	@param buf : result
+ *	@param size : command length usually.
+ *
+ *	set command type and TP will return its status in buf.
+ */
+static int elants_async_recv_data(
+	struct i2c_client *client,
+	const uint8_t *cmd,
+	uint8_t *buf, size_t tx_size,
+	size_t rx_size)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	dev_dbg(&client->dev,
+			"[ELAN] Enter: %s\n", __func__);
+
+	if (buf == NULL)
+		return -EINVAL;
+
+	mutex_lock(&ts->tr_mutex);
+	if ((i2c_master_send(client, cmd, tx_size)) != tx_size) {
+		dev_err(&client->dev,
+				"%s: i2c_master_send failed\n", __func__);
+		goto fail;
+	}
+
+	if (unlikely(elan_ts_poll(client) < 0))
+		goto fail;
+	else {
+		if (i2c_master_recv(client, buf, rx_size) != rx_size)
+			goto fail;
+		mutex_unlock(&ts->tr_mutex);
+	}
+
+	return 0;
+
+fail:
+	mutex_unlock(&ts->tr_mutex);
+	return -EINVAL;
+}
+
+/**
+ *	@brief  \b  __get_bc_version		-	probe /INT to get new/old BC
+ *	@param client : our i2c device
+ *
+ *	1 : new bootcode
+ *	0 : old bootcode
+ */
+static int __get_bc_version(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	/* wait 150ms to probe /INT and get old-BC, new-BC status */
+	msleep(150);
+
+	if (gpio_get_value(ts->intr_gpio) == 0) {
+		/* Old BC */
+		pr_info("[ELAN]detect intr=>Old FW\n");
+		old_bootcode = true;
+	} else {
+		/* New BC */
+		pr_info("[elan]detect intr=>New FW\n");
+		old_bootcode = false;
+	}
+
+	return old_bootcode;
+}
+
+
+/**
+ *	@brief __hello_packet_handler	-	hadle hello packet.
+ *	@param client : our i2c device
+ *
+ *	@return { >0 means success,
+ *			otherwise fail. }
+ *
+ *	Normal hello packet is {0x55, 0x55, 0x55, 0x55}
+ *	recovery mode hello packet is {0x55, 0x55, 0x80, 0x80}
+ */
+static int __hello_packet_handler(struct i2c_client *client)
+{
+	int rc = 0, tries = 5;
+	uint8_t buf_recv[4] = {0};
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+
+retry:	/* wait INT for 1sec */
+	rc = elan_ts_poll(client);
+	if (rc < 0) {
+		dev_err(&client->dev,
+				"%s: poll failed!\n", ELAN_DEV_NAME);
+		if (tries-- > 0)
+			goto retry;
+	}
+
+	rc = elants_get_data(client, buf_recv, 4);
+
+	elan_dbg(client,
+			 "[ELAN] rc = %d Hello Packet: [0x%.2x 0x%.2x 0x%.2x 0x%.2x]\n",
+			 rc, buf_recv[0], buf_recv[1], buf_recv[2], buf_recv[3]);
+
+	if (rc != 4) {
+		dev_err(&client->dev,
+				"[ELAN] %s: Try recovery because of no hello\n",
+				__func__);
+
+		/* force TP FW into IAP mode. */
+		elants_enter_iap(client);
+		return -EINVAL;
+	}
+
+	/* new iap main-flow recovery mechanism 20120518*/
+	if (memcmp(buf_recv, hello_packet, 4) ||
+		elants_is_iap(client, elan_i2c_slave1) > 0) {
+		dev_err(&client->dev,
+				"[ELAN] got mainflow recovery message\n");
+		elants_enter_iap(client);
+		return -EINVAL;
+	}
+
+	ts->i2caddr = elan_i2c_master;
+
+	return rc;
+}
+
+static int __fw_packet_handler(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc, tries = 3;
+	const uint8_t cmd[] = {CMD_R_PKT, 0x00, 0x00, 0x01};
+	uint8_t buf_recv[4] = {0x0};
+
+	/* Command not support in IAP recovery mode */
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return 0;
+retry:
+	rc = elants_acqurie_data(client, cmd, buf_recv, 4);
+	if (rc < 0)
+		return rc;
+
+	if (buf_recv[0] == CMD_S_PKT) {
+		ts->major_fw_version = ((buf_recv[1] & 0x0f) << 4) |
+							   ((buf_recv[2] & 0xf0) >> 4);
+		ts->minor_fw_version = ((buf_recv[2] & 0x0f) << 4) |
+							   ((buf_recv[3] & 0xf0) >> 4);
+
+		/* For 1+2, support this function since Solution version 0.3E(2012/2/23) */
+		if ((ts->major_fw_version == 0x00 &&
+			 ts->minor_fw_version == 0x00) ||
+			(ts->major_fw_version == 0xFF &&
+			 ts->minor_fw_version == 0xFF)) {
+			dev_err(&client->dev,
+					"\n\n[ELAN] FW version is empty, suggest IAP ELAN chip\n\n");
+			return -EINVAL;
+		}
+
+		elan_dbg(client,
+				 "[ELAN] TOUCH MAJOR FW VERSION 0x%02x\n",
+				 ts->major_fw_version);
+		elan_dbg(client,
+				 "[ELAN] TOUCH MINOR FW VERSION 0x%02x\n",
+				 ts->minor_fw_version);
+	} else {
+		if (tries > 0) {
+			tries--;
+			goto retry;
+		}
+		ts->major_fw_version = 0xff;
+		ts->minor_fw_version = 0xff;
+		dev_err(&client->dev,
+				"\n\n[ELAN] FW version is empty, suggest IAP ELAN chip\n\n");
+		return -EINVAL;
+
+	}
+
+	return 0;
+}
+
+static int __touch_get_resolution(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc;
+	uint8_t buf_recv[17] = {0x0};
+	const uint8_t get_resolution_cmd[] = {
+		0x5B, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+
+	/* Command not support in IAP recovery mode */
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return 0;
+
+	rc = elants_async_recv_data(client, get_resolution_cmd, buf_recv,
+								sizeof(get_resolution_cmd), sizeof(buf_recv));
+	if (rc < 0)
+		return -rc;
+
+
+	elan_dbg(client,
+			 "[ELAN] %x:%x:%x, :%x:%x:%x, %d\n",
+			 buf_recv[2],  buf_recv[6], buf_recv[10],
+			 buf_recv[3], buf_recv[7], buf_recv[0], rc);
+
+	if (buf_recv[0] != 0x9B)
+		return -EINVAL;
+
+	elan_dbg(client, "[ELAN] %x:%x:%x, :%x:%x:%x, %d\n",
+			 buf_recv[2],  buf_recv[6], buf_recv[10],
+			 buf_recv[3], buf_recv[7], buf_recv[11], rc);
+
+
+	ts->rows = (buf_recv[2] + buf_recv[6] + buf_recv[10]);
+	ts->cols = (buf_recv[3] + buf_recv[7] + buf_recv[11]);
+
+	elan_dbg(client, "[ELAN] %x:%x:%x, :%x:%x:%x\n", buf_recv[2],
+			 buf_recv[6], buf_recv[10],
+			 buf_recv[3], buf_recv[7], buf_recv[11]);
+
+	if (ts->rows < 2 || ts->cols < 2) {
+		dev_err(&client->dev,
+				"[ELAN] Invalid resolution (%d, %d)\n",
+				ts->rows, ts->cols);
+
+		/* set default resolution if TP information is wrong */
+		ts->rows = ELAN_X_MAX;
+		ts->cols = ELAN_Y_MAX;
+
+		rc = ret_fail;
+	}
+
+	/* translate trace number to TSP resolution */
+	ts->cols = ELAN_TS_RESOLUTION(ts->cols);
+	ts->rows = ELAN_TS_RESOLUTION(ts->rows);
+
+	elan_dbg(client,
+			 "[ELAN] resolution rows = 0x%02x, cols = 0x%02x\n",
+			 ts->rows, ts->cols);
+
+	return 0;
+}
+
+
+/**
+ *	elan_touch_get_bc_ver	-	obtain bootcode data from device
+ *	@client: the interface we are querying
+
+ *
+ *	Send a bootcode version command and fill the results into the
+ *	elan device structures. Caller must hold the mutex
+ *
+
+ *	Returns 0 or an error code
+ */
+static int __elan_touch_get_bc_ver(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 get_bc_ver_cmd[] = {0x53, 0x10, 0x00, 0x01};
+	u8 buf_recv[4];
+	int rc;
+
+	/* Command not support in IAP recovery mode */
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return 0;
+
+	rc = elants_acqurie_data(client, get_bc_ver_cmd,
+							 buf_recv, sizeof(buf_recv));
+	if (rc < 0) {
+		dev_err(&client->dev,
+				"elan_ts_acqurie_data failed: get_bc_ver\n");
+		return rc;
+	}
+
+	ts->major_bc_version = (((buf_recv[1] & 0x0f) << 4) |
+							((buf_recv[2]&0xf0) >> 4));
+	ts->minor_bc_version = (((buf_recv[2] & 0x0f) << 4) |
+							((buf_recv[3]&0xf0) >> 4));
+
+	elan_dbg(client,
+			 "ELAN TOUCH MAJOR BC VERSION 0x%02x\n",
+			 ts->major_bc_version);
+	elan_dbg(client,
+			 "ELAN TOUCH MINOR BC VERSION 0x%02x\n",
+			 ts->minor_bc_version);
+
+	return 0;
+}
+
+static int __elan_fastboot(struct i2c_client *client, int *count)
+{
+	int rc = 0;
+
+	rc = elants_boot(client, elan_i2c_slave1, E_BOOT_NORM);
+	if (rc < 0) {
+		if (*count > 0)
+			return -EAGAIN;
+		return -1;
+	}
+
+	rc = elants_boot(client, elan_i2c_master, E_BOOT_NORM);
+	if (rc < 0) {
+		if (*count > 0)
+			return -EAGAIN;
+		return -1;
+	}
+
+	msleep(100);
+
+	return rc;
+}
+
+/**
+ *	@brief elan_open		-	open elan device
+ *	@param input : input device
+ *
+ */
+static int elan_open(struct input_dev *input)
+{
+	struct elants_data *ts = input_get_drvdata(input);
+
+	dev_err(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	/* wait probe work_func done */
+	while ((ts->status & STA_INIT4) == 0)
+		elan_msleep(1);
+
+	return 0;
+}
+
+/**
+ *	@brief elan_close		-	close input device
+ *	@param input : input device
+ *
+ */
+static void elan_close(struct input_dev *input)
+{
+	struct elants_data *ts = input_get_drvdata(input);
+
+	dev_err(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	return;
+}
+
+
+/**
+ *	@brief \b elan_ts_setup		-	initialization process.
+ *	@param client : our i2c client
+ *
+ *	set our TP up
+ *	-# reset
+ *	-# hello packet
+ *	-# fw version
+ *	-# TP info (resolution)
+ *
+ */
+static int __devinit elants_setup(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc, tries = 5, count = 5;
+	int len = 0;
+	bool fastboot = true;
+
+retry:
+	/*! Reset */
+	elan_hw_reset(client);
+
+	ts->rx_size = queue_header_size;
+
+	/* New BootCode */
+	if (fastboot == true) {
+		rc = __elan_fastboot(client, &count);
+		if (rc < 0) {
+			if (rc == -EAGAIN && --count > 0)
+				goto retry;
+			else {
+				len += sprintf(ts->boot_log + len,
+							   "serious bug, BC may be broken!!\n");
+				return -1;
+			}
+		}
+		fastboot = 0;
+	} else {
+		/* Wait bootcode timeout 1 second +
+			Main-flow initial ~100ms */
+		ssleep(2);
+	}
+
+	/*! - elan hello packet init */
+	rc = __hello_packet_handler(client);
+	if (rc < 0) {
+		/* Wrong hello_packet or polling fail, retry */
+		if ((rc == -EINVAL || rc == -ETIMEDOUT) && --tries > 0) {
+			dev_err(&client->dev,
+					"[ELAN] retries=%d, rc=%d\n",
+					tries, rc);
+			goto retry;
+		}
+
+		len += sprintf(ts->boot_log + len,
+					   "retry=%d polling time-out\n", 5-tries);
+
+		dev_err(&client->dev,
+				"hello packet error.\n");
+		/* Go through down*/
+
+		/* if iap mode enable, return and wait for IAP */
+		if (ts->iap_mode == IAP_MODE_ENABLE) {
+			len += sprintf(ts->boot_log + len, "IAP mode enable\n");
+			return rc;
+		}
+	}
+
+	elan_dbg(client,
+			 "__hello_packet_handler ...\n");
+
+	/*! - elan fw version */
+	rc = __fw_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "firmware checking error.\n");
+		len += sprintf(ts->boot_log+len, "fw_packet_error=%x:%x\n",
+					   ts->major_fw_version, ts->minor_fw_version);
+
+		if (rc == -EINVAL) {
+			len += sprintf(ts->boot_log+len,
+						   "FW version is empty, IAP enable!!\n");
+			ts->protocol = ts->protocol |  PRO_UPDATE_FW_MODE;
+			ts->iap_mode = IAP_MODE_ENABLE;
+		}
+
+		/* Go through down*/
+	}
+
+	elan_dbg(client, "__fw_packet_handler...\n");
+
+	/*! - elan TP information */
+	rc = __touch_get_resolution(client);
+	if (rc < 0) {
+		dev_err(&client->dev,
+				"TP information checking error.\n");
+		len += sprintf(ts->boot_log+len,
+					   "touch_get_resolution=%x:%x\n",
+					   ts->rows, ts->cols);
+		/* Go through down*/
+	}
+
+	elan_dbg(client,
+			 "__touch_get_resolution...\n");
+
+
+	/* Get TS BootCode version */
+	rc = __elan_touch_get_bc_ver(client);
+	if (rc < 0) {
+		dev_err(&client->dev,
+				"TP get BC version error.\n");
+		len += sprintf(ts->boot_log+len,
+					   "touch_get_BC_ver=%x:%x\n",
+					   ts->major_bc_version, ts->major_bc_version);
+		/* Go through down*/
+	}
+
+	if (len == 0)
+		len += sprintf(ts->boot_log, "boot success!!\n");
+
+	return rc;
+
+}
+
+
+static int elants_get_power_state(struct i2c_client *client)
+{
+	int rc = 0;
+	const uint8_t cmd[] = {CMD_R_PKT, 0x50, 0x00, 0x01};
+	uint8_t buf[4], power_state;
+
+	rc = elants_acqurie_data(client, cmd, buf, 4);
+	if (rc)
+		return rc;
+
+	power_state = buf[1];
+	elan_dbg(client,
+			 "dump repsponse: %0x\n", power_state);
+	power_state = (power_state & PWR_STATE_MASK) >> 3;
+	elan_dbg(client,
+			 "power state = %s\n",
+			 power_state == PWR_STATE_DEEP_SLEEP ?
+			 "Deep Sleep" : "Normal/Idle");
+
+	return power_state;
+}
+
+
+/**
+ *	@brief \b elan_ts_recv_data		-	received TP data
+ *	@param client: our i2c device
+ *	@param buf : buffer for put received data
+ *
+ *	received data from TP device.
+ */
+static int elants_recv_data(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc = 0, bytes_to_recv;
+
+	dev_dbg(&client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	if (buf == NULL)
+		return -EINVAL;
+
+	mutex_lock(&ts->tr_mutex);
+
+	bytes_to_recv = ts->rx_size;
+	rc = i2c_master_recv(client, buf, bytes_to_recv);
+
+	dev_dbg(&client->dev,
+			"[ELAN] %d:%d:%x:%x, addr=%x\n", bytes_to_recv, rc,
+			buf[0], buf[34], client->addr);
+	dev_dbg(&client->dev,
+			"[ELAN] %x:%x:%x:%x:%x:%x\n", buf[0], buf[1], buf[2],
+			buf[3], buf[4], buf[5]);
+
+	if (rc != bytes_to_recv) {
+		dev_err(&client->dev,
+				"%s: i2c_master_recv error?!\n",
+				__func__);
+		rc = -EINVAL;
+	}
+	mutex_unlock(&ts->tr_mutex);
+
+	return rc;
+}
+
+/**
+ *	elan_touch_pull_frame	-	pull a frame from the fifo
+ *	@ed: our elan touch device
+ *	@ehr: return buffer for the header
+ *	@buf: data buffer
+ *
+ *	Pulls a frame from the FIFO into the provided ehr and data buffer.
+ *	The data buffer must be at least cmd_response_len bytes long.
+ */
+static int elan_touch_pull_frame(struct elants_data *ts, u8 *buf)
+{
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+	WARN_ON(kfifo_get(ts->fifo, buf, cmd_response_len)
+			!= 	cmd_response_len);
+#else
+	WARN_ON(kfifo_out_locked(&ts->fifo, buf, cmd_response_len,
+							 &ts->rx_kfifo_lock)
+			!= cmd_response_len);
+#endif
+	return cmd_response_len;
+}
+
+
+/**
+ *	elan_touch_fifo_clean_old	-	Make room for new frames
+ *	@ed: our elan touch device
+ *	@room: space needed
+ *
+ *	Empty old frames out of the FIFO until we can fit the new one into
+ *	the other end.
+ */
+static void elan_touch_fifo_clean_old(struct elants_data *ts, int room)
+{
+	u8 buffer[cmd_response_len];
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+	while (kfifo_len(ts->fifo) + room >= FIFO_SIZE)
+		elan_touch_pull_frame(ts, buffer);
+#else
+	while (kfifo_len(&ts->fifo) + room >= FIFO_SIZE)
+		elan_touch_pull_frame(ts, buffer);
+#endif
+}
+
+
+/** @brief \b elan_ts_GetRepoInfo	-	parse Multi-queue report header
+ *	@param client : our i2c device
+ *	@param buf : buffer data
+ *
+ *	parsing report header and get data length.
+ *
+ */
+static int elants_GetRepoInfo(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct multi_queue_header *buff = (struct multi_queue_header *)buf;
+	const u8 wait_packet[4] = {0x64, 0x64, 0x64, 0x64};
+	int times = 10, rc = 0;
+
+	switch (buf[idx_finger_header]) {
+	case cmd_header_byte_hello:
+		if (!memcmp(buf, hello_packet, 4))
+			ts->wdt_reset++;
+		return ret_cmdrsp;
+	case cmd_header_byte_response:
+		/* Queue the data, using the fifo lock to serialize the multiple
+		   accesses to the FIFO */
+		elan_dbg(client,
+				 "[ELAN] recv cmd_header_byte_response\n");
+
+		mutex_lock(&ts->fifo_mutex);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+		if (kfifo_len(ts->fifo) + cmd_response_len >= FIFO_SIZE)
+#else
+		if (kfifo_len(&ts->fifo) + cmd_response_len >= FIFO_SIZE)
+
+#endif
+			/* Make room, make room */
+			elan_touch_fifo_clean_old(ts, cmd_response_len);
+		/* Push the data */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 33)
+		kfifo_put(ts->fifo, buf, cmd_response_len);
+#else
+		kfifo_in_locked(&ts->fifo, buf,
+						cmd_response_len, &ts->rx_kfifo_lock);
+#endif
+		mutex_unlock(&ts->fifo_mutex);
+
+		elan_dbg(client,
+				 "[ELAN] wake_up [%02x:%02x:%02x:%02x]\n",
+				 buf[0], buf[1], buf[2], buf[3]);
+		wake_up(&ts->wait);
+		return ret_cmdrsp;
+		/* Buffer mode header */
+	case queue_header_byte_normal:
+		elan_dbg(client,
+				 "[ELAN] report_count=%d report_len=%d\n",
+				 buff->report_count, buff->report_length);
+		if (likely(buff->report_count <= 3)) {
+			ts->mq_header.report_count = buff->report_count;
+			ts->mq_header.report_length = buff->report_length;
+			ts->rx_size = ts->mq_header.report_length;
+		} else
+			return ret_fail;
+
+		break;
+	case queue_header_byte_wait:
+		dev_err(&client->dev,
+				"========queue_header_byte_wait %x:%x:%x:%x========\n",
+				buf[0], buf[1], buf[2], buf[3]);
+		/*! BUGFIX: buff[0] might be wrong (0x63), check buff[1 ~ 3] is enough*/
+		if (!memcmp(buf+1, &wait_packet[1], 3)) {
+			do {
+				udelay(30);
+				elants_recv_data(client, (uint8_t *)buff);
+			} while (buff->packet_id != queue_header_byte_normal &&
+					 --times > 0);
+			if (times > 0)
+				rc = elants_GetRepoInfo(client, (uint8_t *)buff);
+			else
+				return ret_fail;
+			elan_dbg(client,
+					 "Detect Wait_Header:rx_size=%d, report_count=%d \
+							report_len=%d\n", ts->rx_size,
+					 ts->mq_header.report_count,
+					 ts->mq_header.report_length);
+
+		} else
+			dev_err(&client->dev,
+					"[ELAN] ERROR!! wait header:%x:%x:%x:%x\n",
+					buf[0], buf[1], buf[2], buf[3]);
+		break;
+		/* Not buffer mode, it's single word mode */
+	case queue_header_byte_Single:
+		ts->mq_header.report_count = 1;
+		ts->mq_header.report_length = IDX_PACKET_SIZE_WIDTH;
+		ts->rx_size = ts->mq_header.report_length;
+		return ts->rx_size;
+		break;
+	default:
+		dev_err(&client->dev,
+				"unknown multi-queue command!! --%x %x:%x:%x--\n",
+				buf[0], buf[1], buf[2], buf[3]);
+		ts->mq_header_fail++;
+
+		/* If glitch causes frame error, drop all finger report */
+		ts->rx_size = queue_packet_max_len;
+		elants_recv_data(client, (uint8_t *)buff);
+		return ret_fail;
+	}
+
+	return ts->rx_size;
+}
+
+
+/** @brief \b elan_touch_checksum	-	Add for checksum mechanism
+ *	@param client : our i2c device
+ *	@param buf : buffer data
+ *
+ *	caculating checksum for make sure all data validity.
+ *
+ */
+static int elan_touch_checksum(struct i2c_client *client, u8 *buf)
+{
+	u8 i = 0, checksum = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	/*! FIXME: checksum wasn't including width byte */
+	for (i = 0; i < IDX_PACKET_SIZE_WIDTH - 6; i++)
+		checksum = checksum + buf[i];
+
+	ts->checksum_correct = checksum;
+
+	if (checksum != buf[idx_finger_width_checksum]) {
+		ts->checksum_fail++;
+		dev_err(&client->dev,
+				"elan touch checksum fail: %02x:%02x\n",
+				checksum, buf[idx_finger_width_checksum]);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ *	@brief \b elan_touch_parse_fid	-	parse the 10 fid bits
+ *	@param data : the input bit stream
+ *	@param fid : an array of fid values
+ *
+ *	Unpack the 10 bits into an array.
+ *
+ *	FIXME: Review whether we can't just use << operators after making
+ *	sure the bits are native endian ?
+ */
+static inline void elan_touch_parse_fid(u8 *data, u8 *fid)
+{
+	fid[0] = (data[0] & 0x01);
+	fid[1] = (data[0] & 0x02);
+	fid[2] = (data[0] & 0x04);
+	fid[3] = (data[0] & 0x08);
+	fid[4] = (data[0] & 0x10);
+	fid[5] = (data[0] & 0x20);
+	fid[6] = (data[0] & 0x40);
+	fid[7] = (data[0] & 0x80);
+	fid[8] = (data[1] & 0x10);
+	fid[9] = (data[1] & 0x20);
+}
+
+/**
+ *	@brief \b elan_touch_parse_wid	-	parse the 10 wid bits
+ *	@param data : the input bit stream
+ *	@param wid : an array of width level
+ *
+ *	Unpack the 10 bits into an array.
+ *
+ */
+static inline void elan_touch_parse_wid(u8 *data, u8 *wid)
+{
+	wid[0] = (data[0] >> 4);
+	wid[1] = (data[0] & 0x0f);
+	wid[2] = (data[1] >> 4);
+	wid[3] = (data[1] & 0x0f);
+	wid[4] = (data[2] >> 4);
+	wid[5] = (data[2] & 0x0f);
+	wid[6] = (data[3] >> 4);
+	wid[7] = (data[3] & 0x0f);
+	wid[8] = (data[4] >> 4);
+	wid[9] = (data[4] & 0x0f);
+}
+
+
+static inline int elants_parse_xy(
+	uint8_t *data,
+	uint16_t *x,
+	uint16_t *y)
+{
+	*x = *y = 0;
+
+	*x = (data[0] & 0xf0);
+	*x <<= 4;
+	*x |= data[1];
+
+	*y = (data[0] & 0x0f);
+	*y <<= 8;
+	*y |= data[2];
+
+	return 0;
+}
+
+/* transition stage for lookup by table, maybe update finger report
+	using by Win8 50Byte format that having actual value for X, Y width */
+static inline int elan_lookup_wid(
+	u8 data,
+	u16 *w,
+	u16 *h)
+{
+	static u16 pre_w, pre_h, cur_w, cur_h;
+	const u8 width_lookup_table[15][2] = {
+		{3, 2},	{3, 2}, {6, 3},
+		{6, 3},	{10, 3}, {15, 4},
+		{15, 5}, {15, 5}, {15, 5},
+		{15, 5}, {15, 5}, {15, 5},
+		{15, 5}, {15, 5}, {15, 5},
+	};
+
+	cur_w = width_lookup_table[data][0] * 17;
+	cur_h = width_lookup_table[data][1] * 17;
+
+	/* IIR to balance w, h vaule, don't jitter too much */
+	*w = (cur_w + pre_w) >> 1;
+	*h = (cur_h + pre_h) >> 1;
+
+	pre_w = cur_w;
+	pre_h = cur_h;
+
+	return 0;
+}
+
+static int elan_mt_compute_slot(struct mt_device *td)
+{
+	int i;
+	for (i = 0; i < td->maxcontacts; ++i) {
+		if (td->slots[i].contactid == td->curdata.contactid &&
+			td->slots[i].touch_state)
+			return i;
+	}
+	for (i = 0; i < td->maxcontacts; ++i) {
+		if (!td->slots[i].seen_in_this_frame &&
+			!td->slots[i].touch_state)
+			return i;
+	}
+	/* should not occurs. If this happens that means
+	 * that the device sent more touches that it says
+	 * in the report descriptor. It is ignored then. */
+	return -1;
+}
+
+/*
+ * this function is called when a whole contact has been processed,
+ * so that it can assign it to a slot and store the data there
+ */
+static void elan_mt_complete_slot(struct mt_device *td)
+{
+	td->curdata.seen_in_this_frame = true;
+	if (td->curvalid) {
+		int slotnum = elan_mt_compute_slot(td);
+
+		if (slotnum >= 0 && slotnum < td->maxcontacts)
+			td->slots[slotnum] = td->curdata;
+	}
+	td->num_received++;
+}
+
+/*
+ * this function is called when a whole packet has been received and processed,
+ * so that it can decide what to send to the input layer.
+ */
+
+#if (MT_TYPE_B == 0)
+static void elan_mt_emit_event(
+	struct mt_device *td,
+	struct input_dev *input)
+{
+	struct elants_data *ts =
+		container_of(td, struct elants_data, td);
+	int i;
+
+	for (i = 0; i < td->maxcontacts; ++i) {
+		struct mt_slot *s = &(td->slots[i]);
+		if (!s->seen_in_this_frame) {
+			if (s->touch_state) {
+				s->touch_state = false;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 39)
+				/* ingore finger-up event since TF1 seems having problem */
+				input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->touch_state);
+				input_mt_sync(input);
+#endif
+			}
+			s->seen_in_this_frame = false;
+			continue;
+		}
+
+		input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->touch_state);
+
+		if (s->touch_state) {
+			/* this finger is on the screen */
+			int wide = (s->w > s->h);
+			/* divided by two to match visual scale of touch */
+			int major = max(s->w, s->h) >> 1;
+			int minor = min(s->w, s->h) >> 1;
+
+			elan_dbg(ts->client,
+					 "[ELAN] i=%d x=%x y=%x w=%x h=%x, p=%x\n",
+					 i, s->x, s->y, major, minor, s->p);
+
+			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, s->contactid);
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 32)
+			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
+#endif
+			input_event(input, EV_ABS, ABS_MT_WIDTH_MAJOR, major);
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 32)
+			/* Can't not report on Android 2.2, 10th finger will disorder */
+			input_event(input, EV_ABS, ABS_MT_WIDTH_MINOR, minor);
+#endif
+		}
+		input_mt_sync(input);
+		s->seen_in_this_frame = false;
+	}
+
+	input_sync(input);
+	td->num_received = 0;
+}
+#else	/* For Android ICS, input protocol-B */
+static void elan_mt_emit_event(
+	struct mt_device *td,
+	struct input_dev *input)
+{
+	struct elants_data *ts =
+		container_of(td, struct elants_data, td);
+	int i;
+
+	for (i = 0; i < td->maxcontacts; ++i) {
+		struct mt_slot *s = &(td->slots[i]);
+		if (!s->seen_in_this_frame)
+			s->touch_state = false;
+
+		input_mt_slot(input, i);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER, s->touch_state);
+		if (s->touch_state) {
+			/* this finger is on the screen */
+			int wide = (s->w > s->h);
+			/* divided by two to match visual scale of touch */
+			int major = max(s->w, s->h) >> 1;
+			int minor = min(s->w, s->h) >> 1;
+
+			elan_dbg(ts->client,
+					 "[ELAN] i=%d x=%x y=%x w=%x h=%x\n",
+					 i, s->x, s->y, major, minor);
+
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
+			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
+		}
+		s->seen_in_this_frame = false;
+	}
+
+	input_mt_report_pointer_emulation(input, true);
+	input_sync(input);
+	td->num_received = 0;
+}
+
+#endif
+
+
+/** @brief \b elan_mt_event	-	process finger reports
+ *	@param ts: our touchscreen
+ *	@param finger_stat : number of fingers in packet
+ *	@param buf : received buffer
+ *
+ *	Walk the received report and process the finger data, extracting
+ *	and reporting co-ordinates. No locking is needed here as the workqueue
+ *	does our threading for us.
+ */
+static int elan_mt_event(
+	struct elants_data *ts,
+	int finger_stat,
+	u8 *buf)
+{
+	int i;
+	u8 fid[FINGER_NUM], wid[FINGER_NUM];
+	u16 x, y, w, h;
+	struct i2c_client *client = ts->client;
+	struct mt_device *td = &ts->td;
+
+	dev_dbg(&client->dev,
+			"[ELAN] Enter elan_mt_event Func\n");
+
+	/* Parsing Finger, Width field */
+	elan_touch_parse_fid(&buf[idx_finger_state], &fid[0]);
+	elan_touch_parse_wid(&buf[idx_finger_width], &wid[0]);
+
+	/* number of fingers expects in this frame */
+	td->num_expected = finger_stat;
+	for (i = 0; i < td->maxcontacts; i++) {
+		if (finger_stat == 0)
+			break;
+
+		/* tracking id */
+		td->curdata.contactid = (fid[i] > 0) ? i+1 : 0;
+
+		if (td->curdata.contactid == 0)
+			continue;
+
+		td->curdata.touch_state = true;
+
+		elants_parse_xy(&buf[3+i*3], &x, &y);
+		td->curdata.x = x;
+		td->curdata.y = y;
+
+		elan_lookup_wid(wid[i], &w, &h);
+		td->curdata.w = w;
+		td->curdata.h = h;
+
+		finger_stat--;
+
+		elan_mt_complete_slot(td);
+	}
+
+	if (td->num_received >= td->num_expected)
+		elan_mt_emit_event(td, ts->input);
+
+	return 1;
+}
+
+
+
+/** @brief \b elants_report_data	-	report finger report to user space.
+ *	@param client : our i2c device
+ *	@param buf : raw data from TP device.
+ *
+ *	- reporting finger data to user space.
+ *	- packet_fail count
+ *
+ */
+static void elants_report_data(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	switch (buf[idx_finger_header]) {
+	case idx_coordinate_packet_4_finger:
+	case idx_coordinate_packet_10_finger: {
+		u8 finger_stat  = buf[idx_finger_total] & 0x0f;
+		elan_dbg(client,
+				 "[ELAN] finger_stat == %d\n", finger_stat);
+		elan_dbg(client,
+				 "[ELAN] finger:%x:%x:%x:%x:%x\n",
+				 buf[0], buf[1], buf[2], buf[3], buf[4]);
+
+		/* Enter right process, reset int_status*/
+		ts->polling.int_status = 0;
+		ts->packet_received++;
+
+		if (likely(finger_stat != 0)) {
+			ts->td.curvalid = true;
+			/*	Old way for report input event
+						elan_touch_report_fingers(ts, finger_stat, buf);  */
+			elan_mt_event(ts, finger_stat, buf);
+			ts->touched_sync++;
+		} else {
+			input_mt_sync(ts->input);
+			ts->no_touched_sync++;
+			input_sync(ts->input);
+		}
+	}
+	break;
+	default:
+		ts->header_fail++;
+		dev_err(&client->dev,
+				"[ELAN] %s: unknown packet type: %x:%x:%x:%x\n",
+				__func__, buf[0], buf[1], buf[2], buf[3]);
+		break;
+	}
+
+	return;
+}
+
+/** @brief \b elants_drop_packet	-	err handler that drop all packet.
+ *
+ *	mutex protection will at outside this function.
+ *
+ */
+static void elants_drop_packet(struct elants_data *ts)
+{
+	uint8_t buf[queue_packet_max_len] = {0x0};
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return;
+
+	if (gpio_get_value(ts->intr_gpio) != 0)
+		goto end;
+
+	/* -# Read multi_queue header */
+	ts->rx_size = queue_header_size;
+	if (elants_recv_data(ts->client, buf) < 0)
+		goto end;
+
+	/* -# Get multi_queue header info*/
+	if (elants_GetRepoInfo(ts->client, buf) > 0) {
+		/* 3. Get finger report data */
+		elants_recv_data(ts->client, buf);
+		udelay(10);
+		if (gpio_get_value(ts->intr_gpio) != 0)
+			goto end;
+	}
+
+	/* -#received all packet till ts->intr pull high */
+	ts->rx_size = 1;
+	while (gpio_get_value(ts->intr_gpio) == 0) {
+		elants_recv_data(ts->client, buf);
+		udelay(10);
+	}
+
+end:
+	ts->rx_size = queue_header_size;
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Leave %s\n", __func__);
+
+	return;
+}
+
+
+
+/** @brief \b elan_ts_pollWork_func	-	regular processing
+ *	@param work : pass from kernel
+ *
+ *	poll_timer polled processing to occur elan_ts_pollWork_func() to check if our ts
+ *	is abnormal.
+ *
+ */
+static void elants_pollWork_func(struct work_struct *work)
+
+{
+	struct elants_data *ts =
+		container_of(work, struct elants_data, pollingwork);
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		goto fail;
+
+	if (gpio_get_value(ts->intr_gpio) != 0)
+		goto fail;
+	else {
+		ts->polling.int_status++;
+		if (ts->polling.int_status < 3)
+			goto fail;
+	}
+
+	/* - we use mutex_trylock() here since polling is not very important */
+	if (!mutex_trylock(&ts->mutex)) {
+		elan_dbg(ts->client,
+				 "[ELAN] trylock fail! return...\n");
+		goto fail;
+	}
+
+	if (test_bit(idx_finger_report, &ts->busy)) {
+		elan_dbg(ts->client,
+				 "[ELAN] 1.finger_Report processing ... ignore!!\n");
+		goto unlock;
+	}
+
+	if (test_bit(idx_cmd_handshake, &ts->busy)) {
+		elan_dbg(ts->client,
+				 "[ELAN] 2.command processing ... ignore!!\n");
+		goto unlock;
+	}
+
+	dev_err(&ts->client->dev,
+			"[ELAN] Force to release intr_gpio!!\n");
+
+	ts->drop_frame++;
+	elants_drop_packet(ts);
+
+unlock:
+	mutex_unlock(&ts->mutex);
+
+fail:
+	return;
+}
+
+static irqreturn_t elants_work_func(int irq, void *work)
+{
+	struct elants_data *ts = work;
+	uint8_t buf[queue_packet_max_len] = {0x0};
+	u8 pos = 0, rc;
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return IRQ_HANDLED;
+
+	/* - this means that we have already serviced it or glich happen!! */
+	if (gpio_get_value(ts->intr_gpio) != 0) {
+		dev_dbg(&ts->client->dev,
+				"[ELAN] Leave %s(gpio)\n", __func__);
+		return IRQ_HANDLED;
+	}
+
+	mutex_lock(&ts->mutex);
+
+	set_bit(idx_finger_report, &ts->busy);
+
+	/* Report one setting */
+	/* ts->rx_size = 40; */	/* queue_header_size; */
+	/* ts->mq_header.report_count=1;	*/
+
+
+	/* - Read multi_queue header */
+	if (elants_recv_data(ts->client, buf) < 0)
+		goto fail;
+
+	/*  - Get multi_queue header info */
+	rc = elants_GetRepoInfo(ts->client, buf);
+	if (rc < 0 || rc == ret_cmdrsp)
+		goto fail;
+
+	/* - Get finger report data */
+	if (elants_recv_data(ts->client, buf) < 0)
+		goto fail;
+
+	clear_bit(idx_finger_report, &ts->busy);
+
+	mutex_unlock(&ts->mutex);
+
+	/* - parsing report and send out */
+	while (ts->mq_header.report_count--) {
+		if (elan_touch_checksum(ts->client, buf + pos) == 0)
+			elants_report_data(ts->client, buf + pos);
+		pos = pos + IDX_PACKET_SIZE_WIDTH;
+		udelay(10);
+	}
+
+	ts->rx_size = queue_header_size;
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Leave %s\n", __func__);
+	return IRQ_HANDLED;
+
+fail:
+	clear_bit(idx_finger_report, &ts->busy);
+	mutex_unlock(&ts->mutex);
+	ts->rx_size = queue_header_size;
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Leave %s(Fail)\n", __func__);
+	return IRQ_HANDLED;
+}
+
+
+
+/**
+ *	@brief \b elan_touch_timer_func	-	poll processing
+ *	@param timer : our timer
+ *
+ *	Queue polled processing to occur on our touch panel and kick the timer
+ *	off again
+ *
+ *	CHECK: we have no guarantee that the timer will not run multiple times
+ *	within one poll, does it matter ?
+ */
+static enum hrtimer_restart elan_touch_timer_func(struct hrtimer *timer)
+{
+	struct elants_data *ts = container_of(timer, struct elants_data, timer);
+	queue_work(ts->elan_wq, &ts->work);
+	hrtimer_start(&ts->timer,
+				  ktime_set(0, 12500000), HRTIMER_MODE_REL);
+
+	return HRTIMER_NORESTART;
+}
+
+/**
+ *	@brief \b elants_poll_timer_func	- err handler when intr_gpio is low but no isr serviced it.
+ *	@param data : our ts
+ *
+ *	intr_gpio polling checking, it'll force to get data if intr_gpio is low
+ *	and not in isr routine.
+ *
+ */
+static void elants_poll_timer_func(unsigned long data)
+{
+	struct elants_data *ts = (struct elants_data *)data;
+	struct elan_polling *timer = &ts->polling;
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	/* - ignore it if normal work is processing */
+	if (work_pending(&ts->work)) {
+		dev_dbg(&ts->client->dev,
+				"[ELAN] 1.work_pending ... ignore!!\n");
+		goto reset;
+	}
+
+	/* - ignore it if poll_timer work is processing */
+	if (work_pending(&ts->pollingwork)) {
+		dev_dbg(&ts->client->dev,
+				"[ELAN] 2.work_pending ... ignore!!\n");
+		goto reset;
+	}
+
+	if (!queue_work(timer->elan_wq, &ts->pollingwork))
+		dev_err(&ts->client->dev,
+				"[ELAN] pollWork active failed!!\n");
+
+reset:
+	timer->timer.expires = jiffies + 10 * HZ;
+	add_timer(&ts->polling.timer);
+
+	return;
+}
+
+static irqreturn_t elants_irq_handler(int irq, void *dev_id)
+{
+	struct elants_data *ts = dev_id;
+	struct i2c_client *client = ts->client;
+
+	dev_dbg(&client->dev,
+			"[ELAN] %s\n", __func__);
+
+	ts->irq_received++;
+
+	return IRQ_WAKE_THREAD;
+}
+
+
+static int elants_register_interrupt(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int err = 0;
+
+	if (client->irq) {
+
+		ts->use_irq = 1;
+
+		err = request_threaded_irq(client->irq, elants_irq_handler,
+								   elants_work_func,
+								   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+								   client->name, ts);
+		if (err)
+			dev_err(&client->dev,
+					"%s: request_irq %d failed\n",
+					__func__, client->irq);
+
+		ts->status |= STA_USE_IRQ;
+
+		elan_dbg(client,
+				 "[ELAN] %s in interrupt mode\n", ts->input->name);
+	}
+
+	if (!ts->use_irq) {
+		hrtimer_init(&ts->timer,
+					 CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		ts->timer.function = elan_touch_timer_func;
+		hrtimer_start(&ts->timer, ktime_set(1, 0),
+					  HRTIMER_MODE_REL);
+		elan_dbg(client,
+				 "[ELAN] %s in time-polling mode\n", ts->input->name);
+	}
+
+	return err;
+}
+
+static int remove_elants(struct i2c_client *client)
+{
+	int ret = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (&client->dev.kobj)
+		sysfs_remove_group(&client->dev.kobj, &elan_attribute_group);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	if (&ts->early_suspend)
+		unregister_early_suspend(&ts->early_suspend);
+#endif
+
+	if (ts->use_irq) {
+		if (client->irq)
+			free_irq(client->irq, ts);
+	} else {
+		if (&ts->timer)
+			hrtimer_cancel(&ts->timer);
+	}
+
+#if (MT_TYPE_B)
+	input_mt_destroy_slots(ts->input);
+#endif
+
+	if (ts->input)
+		input_unregister_device(ts->input);
+
+	if (ts->elan_wq)
+		destroy_workqueue(ts->elan_wq);
+
+	if (ts->polling.elan_wq)
+		destroy_workqueue(ts->polling.elan_wq);
+
+	if (&ts->polling.timer) {
+		ret = del_timer(&ts->polling.timer);
+		if (ret != 0)
+			dev_err(&client->dev,
+					"[ELAN] del_timer fail!!\n");
+	}
+
+	if (&ts->mutex)
+		mutex_destroy(&ts->mutex);
+	if (&ts->tr_mutex)
+		mutex_destroy(&ts->tr_mutex);
+	if (&ts->fifo_mutex)
+		mutex_destroy(&ts->fifo_mutex);
+
+	if (ts->fw_enabled) {
+		ret = misc_deregister(&ts->firmware);
+		if (ret < 0)
+			dev_err(&client->dev,
+					"[ELAN] misc_deregister fail!!\n");
+	}
+
+	kfree(ts->td.slots);
+
+	/* free kfifo */
+	kfifo_free(&ts->fifo);
+#if (ANDROID)
+	wake_lock_destroy(&ts->wakelock);
+#endif
+
+	kfree(ts);
+
+	return ret;
+}
+
+
+/**
+ *	probe_thread_func	-	init touch device.
+ *	@work: /int work queue
+ *
+ *	Perform real probe for our I2C device and if successful configure
+ *	it up as an input device. If not then clean up and return an error
+ *	code.
+ */
+
+static int probe_thread_func(void *data)
+{
+	struct elants_data *ts = data;
+	struct i2c_client *client = ts->client;
+	int err = 0;
+
+	mutex_lock(&ts->mutex);
+
+	err = elants_setup(client);
+	if (err < 0) {
+		dev_err(&client->dev,
+				"[ELAN] %s probe failed\n",
+				ELAN_DEV_NAME);
+		/* User can IAP anyway, continue */
+	}
+
+	set_bit(BTN_TOUCH, ts->input->keybit);
+
+	/*! - Single touch input params setup */
+	input_set_abs_params(ts->input, ABS_X, 0, ts->cols, 0, 0);
+	input_set_abs_params(ts->input, ABS_Y, 0, ts->rows, 0, 0);
+	input_set_abs_params(ts->input, ABS_PRESSURE, 0, 255, 0, 0);
+
+	/*! @warning FIXME: ABS_MT_PRESSURE can be supported by FW.
+		currently we have done it by ABS_MT_WIDTH_MAJOR */
+	/*! - Multitouch input params setup */
+	input_set_abs_params(ts->input, ABS_MT_POSITION_X, 0, ts->cols, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_POSITION_Y, 0, ts->rows, 0, 0);
+#if (MT_TYPE_B == 0)
+	input_set_abs_params(ts->input, ABS_MT_WIDTH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_WIDTH_MINOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MAJOR, 0, 1, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MINOR, 0, 1, 0, 0);
+
+	input_set_abs_params(ts->input, ABS_MT_TRACKING_ID, 0, FINGER_NUM, 0, 0);
+#else
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
+
+	/* not test, keep mark for less Android-ICS */
+	input_set_abs_params(ts->input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+#endif
+
+	__set_bit(EV_ABS, ts->input->evbit);
+	__set_bit(EV_SYN, ts->input->evbit);
+
+	input_set_drvdata(ts->input, ts);
+
+	err = input_register_device(ts->input);
+	if (err) {
+		dev_err(&client->dev,
+				"[ELAN] %s unable to register input device\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	ts->td.slots = kzalloc(FINGER_NUM * sizeof(struct mt_slot),
+						   GFP_KERNEL);
+	if (!ts->td.slots) {
+		dev_err(&client->dev,
+				"cannot allocate multitouch slots\n");
+		goto fail_un;
+	}
+	ts->td.maxcontacts = FINGER_NUM;
+#if (MT_TYPE_B)
+	input_mt_init_slots(ts->input, ts->td.maxcontacts);
+#endif
+
+	/*! @warning If the firmware device fails we carry on as it doesn't stop normal
+	   usage */
+	private_ts = &ts->firmware;
+	if (elants_register_interrupt(ts->client) < 0) {
+		dev_err(&client->dev,
+				"[ELAN] %s register_interrupt failed!\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	/*! - Register SW watchdog timer */
+	init_timer(&ts->polling.timer);
+	/*! - check intr_gpio every 10secs */
+	ts->polling.timer.expires = jiffies + 10 * HZ;
+	ts->polling.timer.function = &elants_poll_timer_func;
+	ts->polling.timer.data = (unsigned long)ts;
+	add_timer(&ts->polling.timer);
+
+	mutex_unlock(&ts->mutex);
+
+	ts->status |= STA_INIT4;
+
+	return 0;
+
+fail_un:
+	mutex_unlock(&ts->mutex);
+	remove_elants(client);
+	return err;
+}
+
+
+
+/**
+ *	@brief elants_probe	-	probe for touchpad
+ *	@param client : our I2C client
+ *
+ *	Perform setup and probe for our I2C device and if successful configure
+ *	it up as an input device. If not then clean up and return an error
+ *	code.
+ */
+static int __devinit elants_probe(
+	struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	long err = -1;
+	struct elan_i2c_platform_data *pdata = NULL;
+	struct elants_data *ts =
+		kzalloc(sizeof(struct elants_data), GFP_KERNEL);
+
+	if (ts == NULL)
+		return -ENOMEM;
+
+	ts->status |= STA_PROBED;
+
+	mutex_init(&ts->mutex);
+	mutex_init(&ts->tr_mutex);
+	mutex_init(&ts->fifo_mutex);
+	init_waitqueue_head(&ts->wait);
+	spin_lock_init(&ts->rx_kfifo_lock);
+#if (ANDROID)
+	wake_lock_init(&ts->wakelock, WAKE_LOCK_SUSPEND, "elan_touch");
+#endif
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+				"[ELAN] %s: i2c check functionality error\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	/* @{ - Normal operatin (Finger report) */
+	ts->elan_wq = create_singlethread_workqueue("elan_wq");
+	if (!ts->elan_wq) {
+		dev_err(&client->dev,
+				"[ELAN] %s: create workqueue failed\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	/*! - Regular polling Process */
+	ts->polling.elan_wq = create_singlethread_workqueue("elan_poll_wq");
+	if (!ts->polling.elan_wq) {
+		dev_err(&client->dev,
+				"[ELAN] %s: create workqueue failed\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	/* INIT polling machinams */
+	INIT_WORK(&ts->pollingwork, elants_pollWork_func);
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev,
+				"[ELAN] %s no platform data\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	ts->status &= STA_INIT;
+
+	ts->intr_gpio = pdata->intr_gpio;
+	ts->rst_gpio = pdata->rst_gpio;
+	/* set initial i2c address */
+	client->addr = elan_i2c_master;
+	ts->i2caddr = client->addr;
+
+	elan_dbg(client,
+			 "reset=%d, intr=%d\n", ts->rst_gpio, ts->intr_gpio);
+
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+
+	/* INIT kfifo */
+	err = kfifo_alloc(&ts->fifo, FIFO_SIZE, GFP_KERNEL);
+	if (!kfifo_initialized(&ts->fifo)) {
+		dev_err(&client->dev,
+				"%s error kfifo_alloc\n", __func__);
+		goto fail_un;
+	}
+
+
+	/*! - IAP Device Initial */
+	ts->firmware.minor = MISC_DYNAMIC_MINOR;
+	ts->firmware.name = "elan-iap";
+	ts->firmware.fops = &elan_touch_fops;
+	ts->firmware.mode = S_IRWXUGO;
+
+	if (unlikely(misc_register(&ts->firmware) < 0))
+		dev_err(&client->dev,
+				"[ELAN] IAP device register failed!!");
+	else {
+		elan_dbg(client,
+				 "[ELAN] IAP device register finished!!");
+		ts->fw_enabled = 1;
+	}
+
+	ts->status &= STA_INIT2;
+
+	ts->input = input_allocate_device();
+	if (ts->input == NULL) {
+		dev_err(&client->dev,
+				"[ELAN] %s Failed to allocate input device\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	ts->input->name = ELAN_DEV_NAME;
+	ts->input->open = elan_open;
+	ts->input->close = elan_close;
+
+	/* Says HELLO to touch device */
+	ts->thread = kthread_run(probe_thread_func, ts, client->name);
+	if (IS_ERR(ts->thread)) {
+		err = PTR_ERR(ts->thread);
+		goto fail_un;
+	}
+
+	ts->status &= STA_INIT3;
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	ts->early_suspend.level = EARLY_SUSPEND_LEVEL_STOP_DRAWING - 1;
+	ts->early_suspend.suspend = elants_early_suspend;
+	ts->early_suspend.resume = elants_late_resume;
+	register_early_suspend(&ts->early_suspend);
+#endif
+
+	/* - register sysfs  @} */
+	elan_dbg(client,
+			 "[ELAN] create sysfs!!\n");
+	if (sysfs_create_group(&client->dev.kobj, &elan_attribute_group))
+		dev_err(&client->dev,
+				"[ELAN] sysfs create group error\n");
+
+
+	return 0;
+
+fail_un:
+	remove_elants(client);
+	return err;
+}
+
+static int __devexit elants_remove(struct i2c_client *client)
+{
+	return remove_elants(client);
+}
+
+#ifdef CONFIG_PM_SLEEP
+/** @brief \b elan_ts_suspend	-	enter sleep mode
+ *
+ *	when Suspend mode, disable_irq and cancel work queue.
+ *
+ */
+static int elants_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_sleep_cmd[] = {0x54, 0x50, 0x00, 0x01};
+	int rc = 0;
+
+	dev_err(&client->dev,
+			"[ELAN] %s: enter\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return 0;
+
+	disable_irq(client->irq);
+	cancel_work_sync(&ts->work);
+
+	mutex_lock(&ts->mutex);
+	rc = elants_set_data(client,
+						 set_sleep_cmd, sizeof(set_sleep_cmd));
+
+	if (rc < 0)
+		goto end;
+
+	ts->power_state = 0;
+	/* de-active timer */
+	del_timer_sync(&ts->polling.timer);
+
+
+end:
+	mutex_unlock(&ts->mutex);
+	return rc;
+}
+
+
+/** @brief \b elan_ts_resume	-	enter wake-up mode
+ *
+ *	when Wake-up mode, enable_irq.
+ *
+ */
+static int elants_resume(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_active_cmd[] = {0x54, 0x58, 0x00, 0x01};
+	int rc = 0, retry = 5;
+
+	dev_err(&client->dev,
+			"[ELAN] %s: enter\n",
+			__func__);
+
+	/* Command not support in IAP recovery mode */
+	if (ts->protocol & PRO_UPDATE_FW_MODE)
+		return 0;
+
+	mutex_lock(&ts->mutex);
+
+	do {
+		rc = elants_set_data(client,
+							 set_active_cmd, sizeof(set_active_cmd));
+		elan_msleep(2);
+		rc = elants_get_power_state(client);
+		if (unlikely(rc != PWR_STATE_NORMAL))
+			dev_err(&client->dev,
+					"[ELAN] %s: wake up tp failed! err = %d\n",
+					__func__, rc);
+		else
+			break;
+	} while (--retry);
+
+	ts->power_state = 1;
+	mutex_unlock(&ts->mutex);
+
+	/* re-active poll timer */
+	mod_timer(&ts->polling.timer, jiffies + 10 * HZ);
+
+	enable_irq(client->irq);
+
+	return rc;
+}
+#endif
+
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+/** @brief \b elants_early_suspend	-	enter sleep mode
+ *
+ *	This function is called by kernel,
+ *	elan_ts_early_suspend() -> elan_ts_suspend()
+ *
+ */
+static void elants_early_suspend(struct early_suspend *h)
+{
+	struct elants_data *ts =
+		container_of(h, struct elants_data, early_suspend);
+	dev_dbg(&ts->client->dev,
+			"Enter %s\n", __func__);
+
+	elants_suspend(ts->client, PMSG_SUSPEND);
+	return;
+}
+
+/** @brief \b elants_late_resume	-	enter wake-up mode
+ *
+ *	This function is called by kernel,
+ *	elan_ts_late_resume() -> elan_ts_resume()
+ *
+ */
+static void elants_late_resume(struct early_suspend *h)
+{
+	struct elants_data *ts =
+		container_of(h, struct elants_data, early_suspend);
+	dev_dbg(&ts->client->dev,
+			"Enter %s\n", __func__);
+
+	elants_resume(ts->client);
+	return;
+}
+#endif
+
+/*! brief system registeration */
+static const struct i2c_device_id elan_ts_id[] = {
+	{ ELAN_DEV_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, elan_ts_id);
+
+/*! brief system registeration */
+static struct i2c_driver elan_ts_driver = {
+	.probe		= elants_probe,
+	.remove		= __devexit_p(elants_remove),
+#ifndef CONFIG_HAS_EARLYSUSPEND
+	.suspend	= elants_suspend,
+	.resume		= elants_resume,
+#endif
+	.id_table	= elan_ts_id,
+	.driver		= {
+		.name	= ELAN_DEV_NAME,
+		.owner	= THIS_MODULE,
+		.bus    = &i2c_bus_type,
+	},
+};
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 2, 0)
+static int __devinit elan_ts_init(void)
+{
+	return i2c_add_driver(&elan_ts_driver);
+}
+
+static void __exit elan_ts_exit(void)
+{
+	i2c_del_driver(&elan_ts_driver);
+	return;
+}
+module_init(elan_ts_init);
+module_exit(elan_ts_exit);
+#else
+module_i2c_driver(elan_ts_driver);
+#endif
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_DESCRIPTION("Elan TouchScreen Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/elants.h b/include/linux/i2c/elants.h
new file mode 100644
index 0000000..5b45a0c
--- /dev/null
+++ b/include/linux/i2c/elants.h
@@ -0,0 +1,61 @@
+#ifndef _LINUX_I2C_ELANTS_H
+#define _LINUX_I2C_ELANTS_H
+
+#define ELAN_DEV_NAME	"elants_i2c"
+
+/* set TSP resolution by actual TPM */
+#define ELAN_X_MAX  2944
+#define ELAN_Y_MAX  1856
+
+
+/*! @brief \b platform data
+ * @param intr_gpio : gpio pin
+ * @param rst_gpio : interuption pin
+ *
+ * Platform data, all platform dependent variable should put here.
+ *
+ */
+struct elan_i2c_platform_data {
+	unsigned short version;
+	unsigned int abs_x_min;
+	unsigned int abs_x_max;
+	unsigned int abs_y_min;
+	unsigned int abs_y_max;
+	int intr_gpio;
+	int rst_gpio;
+};
+
+struct elan_ioctl_data {
+	int len;
+	char buf[32];
+};
+
+/*! @brief \b ioctl command definition.
+ * @param IOCTL_I2C_SLAVE : set i2c address that would be controled right now.
+ * @param IOCTL_MAJOR_FW_VER : fw major number
+ * @param IOCTL_MINOR_FW_VER : fw minor number
+ * @param IOCTL_RESET : Hardware Reset
+ * @param IOCTL_SET_COMMAND : control command set to TP device.
+ * @param IOCTL_GET_COMMAND : get response from our TP device.
+ * @param IOCTL_IAP_ENABLE : Enter IAP mode
+ * @param IOCTL_IAP_DISABLE : Leave IAP mode
+ * @param IOCTL_I2C_INT : gpio status
+ *
+ *
+ * ioctl command, easy user to control our TP from application.
+ *
+ */
+#define ELAN_IOCTLID		0xD0
+#define IOCTL_I2C_SLAVE		_IOW(ELAN_IOCTLID,  1, int)
+#define IOCTL_MAJOR_FW_VER  _IOR(ELAN_IOCTLID, 2, int)
+#define IOCTL_MINOR_FW_VER  _IOR(ELAN_IOCTLID, 3, int)
+#define IOCTL_RESET			_IOW(ELAN_IOCTLID, 4, int)
+#define IOCTL_I2C_INT		_IOR(ELAN_IOCTLID, 8, int)
+#define IOCTL_SET_COMMAND	_IOW(ELAN_IOCTLID, 9, unsigned long)
+#define IOCTL_GET_COMMAND	_IOR(ELAN_IOCTLID, 10, unsigned long)
+#define IOCTL_IAP_ENABLE	_IOW(ELAN_IOCTLID, 11, int)
+#define IOCTL_IAP_DISABLE	_IOW(ELAN_IOCTLID, 12, int)
+#define IOCTL_CHECK_RECOVERY_MODE	_IOR(ELAN_IOCTLID, 13, int)
+#define IOCTL_BOOTCODE_CMD	_IOW(ELAN_IOCTLID, 14, unsigned long)
+
+#endif /* _LINUX_I2C_ELANTS_H */
-- 
1.7.9.5

