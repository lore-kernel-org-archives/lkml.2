Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2J2IqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:46:04 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:14111 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab2J2Ip5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:45:57 -0400
From: Scott Liu <scott.liu@emc.com.tw>
To: Scott Liu <scott.liu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jesse <jesse@emc.com.tw>, Vincent Wang <vincent.wang@emc.com.tw>,
        Paul <paul.liang@emc.com.tw>
Subject: [PATCH v3] Support Elan Touchscreen eKTF product.
Date: Mon, 29 Oct 2012 08:43:54 +0800
Message-Id: <1351471434-32052-1-git-send-email-scott.liu@emc.com.tw>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for Elan eKTF Touchscreen product, I2C adpater module.

Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
---
Hi Dmitry,
        v3 chagnes:
                * remove elants_prove() thread.
                * follow standard kernel-doc.
                * sysfs only for device information.
                * add ioctl function handled by user.

        Thanks.

 drivers/input/touchscreen/Kconfig      |    9 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/elants_i2c.c | 2265 ++++++++++++++++++++++++++++++++
 include/linux/i2c/elants.h             |   58 +
 4 files changed, 2333 insertions(+)
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
index 0000000..996b7df
--- /dev/null
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -0,0 +1,2265 @@
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
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/jiffies.h>
+#include <linux/hrtimer.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/buffer_head.h>
+#include <linux/version.h>
+#include <linux/kfifo.h>
+#include <linux/slab.h>
+#include <linux/input/mt.h>
+#include <linux/i2c/elants.h>
+
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
+/*
+ * Device, Driver information
+ */
+
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
+/*
+ * Finger report description
+ */
+
+#define MAX_CONTACT_NUM	10
+
+/*
+ *FW Power Saving Mode
+ */
+
+#define PWR_STATE_DEEP_SLEEP	0
+#define PWR_STATE_NORMAL        1
+#define PWR_STATE_MASK          BIT(3)
+
+/*
+ * kfifo buffer size, used for Read command handshake
+ */
+
+#define FIFO_SIZE       (64)
+
+/*
+ *Convert from rows or columns into resolution
+ */
+
+#define ELAN_TS_RESOLUTION(n)   ((n - 1) * 64)
+
+static const char hello_packet[4] = { 0x55, 0x55, 0x55, 0x55 };
+static const char iniap_packet[4] = { 0x55, 0xaa, 0x33, 0xcc };
+static const char recov_packet[4] = { 0x55, 0x55, 0x80, 0x80 };
+
+
+/* driver status flag */
+#define STA_NONINIT         0x00000001
+#define STA_INIT            0x00000002
+#define STA_INIT2           0x00000004
+#define STA_INIT3           0x00000100
+#define STA_INIT4           0x00000200
+#define STA_PROBED          0x00000008
+#define STA_ERR_HELLO_PKT   0x00000010
+#define STA_USE_IRQ         0x00000020
+#define	STA_SLEEP_MODE      0x00000040
+
+/*
+ * Elan I2C Address definition
+ */
+
+#define	DEV_MASTER	0x10
+#define	DEV_SLAVE1	0x20
+#define	DEV_SLAVE2	0x21
+#define	MAX_DEVICE	3
+
+/*
+ * Finger report header byte definition
+ */
+
+#define	REPORT_HEADER_10_FINGER	0x62
+
+/*
+ * Buffer mode Queue Header information
+ */
+
+#define	QUEUE_HEADER_SINGLE	0x62
+#define	QUEUE_HEADER_NORMAL	0X63
+#define QUEUE_HEADER_WAIT	0x64
+#define	QUEUE_HEADER_SIZE	4
+
+#define PACKET_SIZE_WIDTH   40
+#define	MAX_PACKET_LEN	(QUEUE_HEADER_SIZE + (PACKET_SIZE_WIDTH * 3))
+
+/*
+ * Command header definition
+ */
+
+#define	CMD_HEADER_WRITE	0x54
+#define	CMD_HEADER_READ	0x53
+#define CMD_HEADER_6B_READ	0x5B
+#define	CMD_HEADER_RESP	0x52
+#define	CMD_HEADER_6B_RESP	0x9B
+#define	CMD_HEADER_HELLO	0x55
+#define	CMD_HEADER_REK	0x66
+#define	CMD_RESP_LEN	4
+
+
+/*
+ * FW information position
+ */
+
+#define	FW_POS_HEADER	0
+#define	FW_POS_STATE	1
+#define	FW_POS_TOTAL	2
+#define	FW_POS_CHECKSUM	34
+#define	FW_POS_WIDTH	35
+
+/*
+ * test_bit definition
+ */
+
+#define	LOCK_FILE_OPERATE	0
+#define	LOCK_CMD_HANDSHAKE	1
+#define	LOCK_FINGER_REPORT	2
+#define	LOCK_FW_UPDATE	3
+
+/*
+ * kfifo return value definition
+ */
+
+#define RET_OK	0
+#define	RET_CMDRSP	1
+#define	RET_FAIL	-1
+
+/*
+ * define boot condition definition
+ */
+
+#define	E_BOOT_NORM	0
+#define	E_BOOT_IAP	1
+
+
+/**
+ * struct multi_queue_header - used by buffer queue header
+ *
+ * @packet_id: packet_id represented status of buffer.
+ * @report_count: number of finger report in buffer.
+ * @report_length: total length exclusive queue length.
+ */
+struct multi_queue_header {
+	u8		packet_id;
+	u8		report_count;
+	u8		report_length;
+	u8		reserved;
+};
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
+	unsigned mt_flags;	/* flags to pass to input-mt */
+	struct mt_slot *slots;
+};
+
+
+/*
+ * struct elants_data - represents a global define of elants device
+ */
+struct elants_data {
+	int intr_gpio;		/* interupter pin*/
+	int rst_gpio;		/* reset pin*/
+	u8 major_fw_version;
+	u8 minor_fw_version;
+	u8 major_bc_version;
+	u8 minor_bc_version;
+	u8 major_hw_id;
+	u8 minor_hw_id;
+	bool fw_enabled;	/* True if firmware device enabled*/
+	int rows;	/* Panel geometry for input layer*/
+	int cols;
+	int x_max;
+	int y_max;
+	u8 power_state;	/* Power state 0:sleep 1:active*/
+#define IAP_MODE_ENABLE	1	/* TS is in IAP mode already*/
+	unsigned int iap_mode;	/* 1 : Firmware update mode
+							0 : normal*/
+	unsigned int rx_size;		/* Read size in use*/
+
+	struct multi_queue_header mq_header;	/* Multi-queue info */
+
+	struct i2c_client *client;	/* our i2c client*/
+	struct input_dev *input;	/* input device*/
+	struct task_struct	*thread;	/* start probe start*/
+	struct miscdevice firmware;	/* char device for ioctl and IAP*/
+
+	struct mutex mutex;	/* Protects I2C accesses to device*/
+	struct mutex tr_mutex;	/* Protects I2C tx/rx*/
+
+	unsigned long flags;	/* device flags */
+
+	unsigned short i2caddr;	/* elan-iap i2c address*/
+
+	struct kfifo fifo;	/* fifo and processing */
+
+	struct mutex fifo_mutex;	/* Serialize operations around FIFO */
+	wait_queue_head_t wait;
+	spinlock_t rx_kfifo_lock;
+
+	/* Add for TS driver debug */
+	unsigned int status;
+	long int irq_received;
+	long int packet_received;
+	long int touched_sync;
+	long int no_touched_sync;
+	long int checksum_correct;
+	long int wdt_reset;
+	u16 checksum_fail;
+	u16 header_fail;
+	u16	mq_header_fail;
+
+	struct mt_device td;	/* mt device */
+};
+
+
+/*
+ *  Function prototype
+ */
+
+static int
+elan_hw_reset(struct i2c_client *client);
+static int
+elan_touch_pull_frame(struct elants_data *ts,
+					  u8 *buf);
+
+/*
+ *  Global variable
+ */
+
+static struct miscdevice *private_ts;	/* for elan-iap char driver */
+
+#define elants_acqurie_data(a, cmd, buf, c) \
+	elants_async_recv_data(a, cmd, buf, c, c)
+
+/*
+ *  Function implement
+ */
+static inline void elan_msleep(u32 t)
+{
+	/*
+	 * If the sleeping time is 10us - 20ms, usleep_range() is recommended.
+	 * Read Documentation/timers/timers-howto.txt
+	 */
+	usleep_range(t*1000, t*1000 + 500);
+}
+
+/**
+ *	elan_ts_poll - polling intr pin status.
+ *
+ *	@client: our i2c device
+ *
+ *	Return:
+ *		0 means intr pin is low,	\n
+ *		otherwise is high.
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
+		elan_msleep(10);
+	} while (status != 0 && retry > 0);
+
+	elan_dbg(client,
+			 "%s: poll interrupt status %s\n",
+			 __func__, status == 1 ? "high" : "low");
+	return (status == 0 ? 0 : -ETIMEDOUT);
+}
+
+
+/**
+ *	elants_async_recv_data - assynchronize data transferring.
+ *
+ *	@client: our i2c device
+ *	@cmd: asking command
+ *	@buf: result
+ *	@size:  command length usually.
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
+
+/**
+ *	elan_ts_set_data - set command to TP.
+ *
+ *	@client: our i2c device
+ *	@data: command or data which will send to TP.
+ *	@len: command length usually.
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
+ *	elan_ts_get_data - get command to TP.
+ *
+ *	@client: our i2c device
+ *	@data: data to be received from TP.
+ *	@len: command length usually.
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
+
+static int elants_cmd_transfer_once(
+	struct i2c_client *client,
+	const u8 *sbuf, const u8 slen,
+	u8 *rbuf, u8 rlen)
+{
+	int ret = 0;
+	struct elants_data *ts =
+		i2c_get_clientdata(client);
+
+	mutex_lock(&ts->mutex);
+	set_bit(LOCK_CMD_HANDSHAKE, &ts->flags);
+	elants_set_data(client, sbuf, slen);
+	mutex_unlock(&ts->mutex);
+
+	if (sbuf[0] == CMD_HEADER_READ) {
+		/* We will wait for non O_NONBLOCK handles until a signal or data */
+		mutex_lock(&ts->fifo_mutex);
+
+		while (kfifo_len(&ts->fifo) == 0) {
+			mutex_unlock(&ts->fifo_mutex);
+			ret = wait_event_interruptible_timeout(
+					  ts->wait, kfifo_len(&ts->fifo),
+					  msecs_to_jiffies(3000));
+			if (ret <= 0) {
+				ret = -ETIMEDOUT;
+				dev_err(&client->dev,
+						"timeout!! wake_up(ts->wait)\n");
+				goto err2;
+			}
+			mutex_lock(&ts->fifo_mutex);
+		}
+		if (elan_touch_pull_frame(ts, rbuf) < 0) {
+			ret = -1;
+			goto err1;
+		}
+
+		dev_info(&client->dev, "[ELAN] Get Data [%.2x:%.2x:%.2x:%.2x]\n",
+				 rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+err1:
+		mutex_unlock(&ts->fifo_mutex);
+err2:
+		clear_bit(LOCK_CMD_HANDSHAKE, &ts->flags);
+	}
+
+	return (ret > 0) ? 1 : ret;
+}
+
+/*
+ * sysfs interface
+ */
+
+static ssize_t show_fw_version_value(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
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
+	struct i2c_client *client = to_i2c_client(dev);
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
+static DEVICE_ATTR(drv_version, S_IRUGO, show_drvver_value, NULL);
+static DEVICE_ATTR(fw_version, S_IRUGO, show_fw_version_value, NULL);
+static DEVICE_ATTR(bc_version, S_IRUGO, show_bc_version_value, NULL);
+
+
+
+static struct attribute *elan_attributes[] = {
+	&dev_attr_fw_version.attr,
+	&dev_attr_drv_version.attr,
+	&dev_attr_bc_version.attr,
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
+ * elan_hw_reset - hardware reset.
+ *
+ * @client: our i2c device
+ *	retval >0 means reset success,
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
+int elan_iap_open(struct inode *inode, struct file *filp)
+{
+	struct elants_data *ts ;
+
+	filp->private_data = private_ts;
+
+	ts = container_of(filp->private_data,
+					  struct elants_data, firmware);
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	return 0;
+}
+
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
+*	elan_iap_write	- iap write page data
+*
+*	@buff: is page data from user space
+*	@count: is number of data in byte.
+*
+*	purpose for upstream work.
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
+*	elan_iap_read	- read status code from TP
+*
+*	purpose for upstream work.
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
+
+/* This function handles ioctl for the character device */
+static long elan_iap_ioctl(struct file *filp,
+						   unsigned int cmd,
+						   unsigned long arg)
+{
+	struct elants_data *ts =
+		container_of(filp->private_data,
+					 struct elants_data, firmware);
+	int __user *argp = (int __user *)arg;
+	u8 len;
+	int rc;
+
+	switch (cmd) {
+	case IOCTL_I2C_SLAVE:
+		ts->i2caddr = (unsigned short)arg;
+		break;
+	case  IOCTL_IAP_ENABLE: {
+		disable_irq(ts->client->irq);
+		set_bit(LOCK_FW_UPDATE, &ts->flags);
+	}
+	break;
+	case  IOCTL_IAP_DISABLE:
+		clear_bit(LOCK_FW_UPDATE, &ts->flags);
+		enable_irq(ts->client->irq);
+		break;
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
+					 "IOCTL_GET_COMMAND: Get length fail\n");
+			return -EFAULT;
+		}
+
+		if (copy_from_user(&idata,
+						   (const void *)arg,
+						   idata.len + sizeof(int))) {
+			dev_err(&client->dev,
+					 "IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					 idata.buf[0], idata.buf[1], idata.buf[2], idata.buf[3]);
+			return -EFAULT;
+		}
+
+		dev_info(&client->dev, "IOCTL_SET_COMMAND:%x:%x:%x:%x\n",
+				 idata.buf[0], idata.buf[1],
+				 idata.buf[2], idata.buf[3]);
+
+		if (elants_cmd_transfer_once(client,
+									 idata.buf, idata.len,
+									 NULL, 0) < 0)
+			return -ENODEV;
+	}
+	break;
+	case  IOCTL_GET_COMMAND: {
+		struct i2c_client *client = ts->client;
+		struct elan_ioctl_data idata;
+
+		/* Get command length first */
+		if (copy_from_user(&idata.len,
+						   (const void *)arg,
+						   sizeof(idata.len))) {
+			dev_err(&client->dev,
+					 "IOCTL_GET_COMMAND: Get length fail\n");
+			return -EFAULT;
+		}
+
+		/* Get command real length then */
+		if (copy_from_user(&idata, (const void *)arg,
+						   idata.len + sizeof(int))) {
+			dev_err(&client->dev,
+					"IOCTL_GET_COMMAND:%x:%x:%x:%x fail\n",
+					idata.buf[0], idata.buf[1], idata.buf[2], idata.buf[3]);
+			return -EFAULT;
+		}
+
+		dev_info(&client->dev, "IOCTL_GET_COMMAND %x:%x:%x:%x\n",
+				 idata.buf[0], idata.buf[1], idata.buf[2], idata.buf[3]);
+
+		rc = elants_cmd_transfer_once(client,
+									  idata.buf, idata.len,
+									  idata.buf, 4);
+		if (rc < 0) {
+			rc = copy_to_user((void __user *)arg,
+							  (void *)&idata,
+							  4 + sizeof(len));
+			return rc;
+		}
+
+		elan_dbg(client,
+				 "Reponse=%x:%x:%x:%x\n",
+				 idata.buf[0], idata.buf[1],
+				 idata.buf[2], idata.buf[3]);
+
+		if (copy_to_user((void __user *)arg,
+						 (void *)&idata, sizeof(idata)))
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
+	.unlocked_ioctl = elan_iap_ioctl,
+};
+
+
+/**
+ *	elants_is_iap - is it in iap mode ?
+ *
+ *	@client: our i2c device
+ *	@addr: i2c address
+ *
+ *	check whether fw currently is in iap.
+ *	@return:
+ *		 < 0:normal mode
+ *		 > 0:iap mode or abnormal.
+ *		-EINVAL : addr overflow, no such device
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
+	if (unlikely(rc < 0)) {
+		dev_err(&client->dev,
+				"[ELAN] %s: ID 0x%.2x retval=%d!\n",
+				__func__, addr, rc);
+		rc = -ENODEV;
+	} else {
+		if (memcmp(buf_recv, iniap_packet, 4)) {
+			dev_err(&client->dev,
+					"[ELAN] %s: ID 0x%x retval=%d !\n",
+					__func__, addr, rc);
+			rc = -ENODEV;
+		}
+	}
+
+	ts->i2caddr = DEV_MASTER;
+
+	return rc;
+}
+
+static int elants_boot(
+	struct i2c_client *client,
+	u16 addr,
+	u8 type)
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
+		ts->i2caddr = DEV_MASTER;
+		return -EINVAL;
+	}
+	dev_info(&client->dev, "[elan] Boot success -- 0x%x\n", addr);
+	ts->i2caddr = DEV_MASTER;
+	return 0;
+}
+
+static int elants_enter_iap(struct i2c_client *client)
+{
+	int rc = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	elan_hw_reset(client);
+
+	/* Boot devices to IAP mode */
+	rc = elants_boot(client, DEV_MASTER, E_BOOT_IAP);
+	if (rc < 0)
+		return rc;
+
+	elan_msleep(10);
+
+	/* Check if devices can enter IAP mode */
+	rc = elants_is_iap(client, DEV_MASTER);
+	if (rc < 0)
+		return rc;
+
+	ts->iap_mode = IAP_MODE_ENABLE;
+	set_bit(LOCK_FW_UPDATE, &ts->flags);
+	ts->i2caddr = DEV_MASTER;
+
+	return rc;
+}
+
+
+
+/**
+ *	__hello_packet_handler	- hadle hello packet.
+ *
+ *	@client: our i2c device
+ *	@return:
+ *		>0 means success,
+ *		otherwise fail.
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
+	/* Print buf_recv anyway */
+	dev_info(&client->dev, "[ELAN] rc = %d Hello Packet: "	\
+			 "[0x%.2x 0x%.2x 0x%.2x 0x%.2x]\n",
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
+	/* v0.85 IAP recovery mechanism 2012-1022*/
+	if (memcmp(buf_recv, hello_packet, 4)) {
+		/* Check if got 55558080 and
+		 * should receive next 4Byte for BC version
+		 */
+		if (!memcmp(buf_recv, recov_packet, 4)) {
+			dev_info(&client->dev, "[ELAN] got IAP recovery packet!(55558080)\n");
+			rc = elants_get_data(client, buf_recv, 4);
+			if (unlikely(rc != 4)) {
+				dev_err(&client->dev,
+						"Got IAP recovery packet fail!\n");
+				return -ENODEV;
+			}
+
+			/* buf_recv[0,1] is dummy data */
+			ts->major_bc_version = buf_recv[3];
+			ts->minor_bc_version = buf_recv[2];
+
+			dev_info(&client->dev, "[ELAN] BC version = %.2x:%.2x",
+					 ts->major_bc_version,
+					 ts->minor_bc_version);
+		}
+
+		dev_info(&client->dev, "got mainflow recovery message\n");
+		rc = elants_enter_iap(client);
+		if (rc < 0)
+			dev_err(&client->dev, "Enter IAP mode fail!\n");
+		return -ENODEV;
+	}
+
+	ts->i2caddr = DEV_MASTER;
+
+	return rc;
+}
+
+static int __fw_packet_handler(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc, tries = 3;
+	const uint8_t cmd[] = {CMD_HEADER_READ, 0x00, 0x00, 0x01};
+	uint8_t buf_recv[4] = {0x0};
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+retry:
+	rc = elants_acqurie_data(client, cmd, buf_recv, 4);
+	if (rc < 0)
+		return rc;
+
+	if (buf_recv[0] == CMD_HEADER_RESP) {
+		ts->major_fw_version = ((buf_recv[1] & 0x0f) << 4) |
+							   ((buf_recv[2] & 0xf0) >> 4);
+		ts->minor_fw_version = ((buf_recv[2] & 0x0f) << 4) |
+							   ((buf_recv[3] & 0xf0) >> 4);
+
+		if ((ts->major_fw_version == 0x00 &&
+			 ts->minor_fw_version == 0x00) ||
+			(ts->major_fw_version == 0xFF &&
+			 ts->minor_fw_version == 0xFF)) {
+			dev_err(&client->dev,
+					"\n\n[ELAN] FW version is empty, "\
+					"suggest IAP ELAN chip\n\n");
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
+				"\n\n[ELAN] FW version is empty, "\
+				"suggest IAP ELAN chip\n\n");
+		return -EINVAL;
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
+		CMD_HEADER_6B_READ, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	rc = elants_async_recv_data(client, get_resolution_cmd, buf_recv,
+								sizeof(get_resolution_cmd), sizeof(buf_recv));
+	if (rc < 0)
+		return -rc;
+
+	elan_dbg(client,
+			 "[ELAN] %x:%x:%x, :%x:%x:%x, %d\n",
+			 buf_recv[2],  buf_recv[6], buf_recv[10],
+			 buf_recv[3], buf_recv[7], buf_recv[0], rc);
+
+	if (buf_recv[0] != CMD_HEADER_6B_RESP)
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
+	elan_dbg(client, "[ELAN] %x:%x:%x:%x:%x:%x\n", buf_recv[2],
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
+		rc = RET_FAIL;
+	}
+
+	/* translate trace number to TSP resolution */
+	ts->cols = ELAN_TS_RESOLUTION(ts->cols);
+	ts->rows = ELAN_TS_RESOLUTION(ts->rows);
+
+	elan_dbg(client,
+			 "[ELAN] resolution rows=0x%.2x, "\
+			 "cols=0x%.2x\n",
+			 ts->rows, ts->cols);
+
+	return 0;
+}
+
+
+/**
+*	elan_touch_get_bc_ver	- obtain bootcode data from device
+*
+*	@client: the interface we are querying
+*
+*	Send a bootcode version command and fill the results into the
+*	elan device structures. Caller must hold the mutex
+*
+*	Returns 0 or an error code
+*/
+static int __elan_touch_get_bc_ver(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 get_bc_ver_cmd[] = {0x53, 0x10, 0x00, 0x01};
+	u8 buf_recv[4];
+	int rc;
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
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
+
+	rc = elants_boot(client, DEV_MASTER, E_BOOT_NORM);
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
+ *	elan_ts_setup - initialization process.
+ *
+ *	@client: our i2c client
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
+	int rc, tries = 3, count = 3;
+	bool fastboot = true;
+
+retry:
+	/*! Reset */
+	elan_hw_reset(client);
+
+	ts->rx_size = QUEUE_HEADER_SIZE;
+
+	/* New BootCode */
+	if (fastboot == true) {
+		rc = __elan_fastboot(client, &count);
+		if (rc < 0) {
+			if (rc == -EAGAIN && --count > 0)
+				goto retry;
+			else
+				return -1;
+		}
+		fastboot = 0;
+	} else {
+		/* Wait bootcode timeout 1 second +
+		 *	Main-flow initial ~100ms
+		 */
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
+		dev_err(&client->dev,
+				"hello packet error.\n");
+		/* Go through down*/
+	}
+
+	elan_dbg(client,
+			 "__hello_packet_handler ...\n");
+
+	/*! - elan fw version */
+	rc = __fw_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "firmware checking error.\n");
+
+		if (rc == -EINVAL) {
+			set_bit(LOCK_FW_UPDATE, &ts->flags);
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
+
+		/* Go through down*/
+	}
+
+	elan_dbg(client,
+			 "__touch_get_resolution...\n");
+
+	/* Get TS BootCode version */
+	rc = __elan_touch_get_bc_ver(client);
+	if (rc < 0) {
+		dev_err(&client->dev,
+				"TP get BC version error.\n");
+
+		/* Go through down*/
+	}
+
+	return rc;
+}
+
+
+static int elants_get_power_state(struct i2c_client *client)
+{
+	int rc = 0;
+	const uint8_t cmd[] = {CMD_HEADER_READ, 0x50, 0x00, 0x01};
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
+ *	elan_ts_recv_data - received TP data
+ *
+ *	@client: our i2c device
+ *	@buf: buffer for put received data
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
+	elan_dbg(client,
+			"[ELAN] %d:%d:%x:%x, addr=%x\n", bytes_to_recv, rc,
+			buf[0], buf[34], client->addr);
+	elan_dbg(client,
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
+*	elan_touch_pull_frame - pull a frame from the fifo
+*
+*	@ts: our elan touch device
+*	@buf: data buffer
+*
+*	Pulls a frame from the FIFO into the provided ehr and data buffer.
+*	The data buffer must be at least CMD_RESP_LEN bytes long.
+*/
+static int elan_touch_pull_frame(struct elants_data *ts, u8 *buf)
+{
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	WARN_ON(kfifo_out_locked(&ts->fifo, buf, CMD_RESP_LEN,
+							 &ts->rx_kfifo_lock)
+			!= CMD_RESP_LEN);
+	return CMD_RESP_LEN;
+}
+
+
+/**
+ *	elan_touch_fifo_clean_old - Make room for new frames
+ *
+ *	@ed: our elan touch device
+ *	@room: space needed
+ *
+ *	Empty old frames out of the FIFO until we can fit the new one into
+ *	the other end.
+ */
+static void elan_touch_fifo_clean_old(struct elants_data *ts, int room)
+{
+	u8 buffer[CMD_RESP_LEN];
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	while (kfifo_len(&ts->fifo) + room >= FIFO_SIZE)
+		elan_touch_pull_frame(ts, buffer);
+}
+
+
+/**
+ *	elan_ts_GetRepoInfo - parse Multi-queue report header
+ *
+ *	@client: our i2c device
+ *	@buf: buffer data
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
+	switch (buf[FW_POS_HEADER]) {
+	case CMD_HEADER_HELLO:
+		if (!memcmp(buf, hello_packet, 4))
+			ts->wdt_reset++;
+		return RET_CMDRSP;
+	case CMD_HEADER_RESP:
+		/* Queue the data, using the fifo lock to serialize
+		 * the multiple accesses to the FIFO
+		 */
+		elan_dbg(client,
+				 "[ELAN] recv CMD_HEADER_RESP\n");
+
+		mutex_lock(&ts->fifo_mutex);
+		if (kfifo_len(&ts->fifo) + CMD_RESP_LEN >= FIFO_SIZE)
+			/* Make room, make room */
+			elan_touch_fifo_clean_old(ts, CMD_RESP_LEN);
+		/* Push the data */
+		kfifo_in_locked(&ts->fifo, buf,
+						CMD_RESP_LEN, &ts->rx_kfifo_lock);
+		mutex_unlock(&ts->fifo_mutex);
+
+		elan_dbg(client,
+				 "wake_up [%02x:%02x:%02x:%02x]\n",
+				 buf[0], buf[1], buf[2], buf[3]);
+		wake_up_interruptible(&ts->wait);
+		return RET_CMDRSP;
+	case CMD_HEADER_REK:
+		/* re-K comand response, ingore it! */
+		return RET_CMDRSP;
+		/* Buffer mode header */
+	case QUEUE_HEADER_NORMAL:
+		elan_dbg(client,
+				 "report_count=%d report_len=%d\n",
+				 buff->report_count, buff->report_length);
+		if (likely(buff->report_count <= 3)) {
+			ts->mq_header.report_count = buff->report_count;
+			ts->mq_header.report_length = buff->report_length;
+			ts->rx_size = ts->mq_header.report_length;
+		} else
+			return RET_FAIL;
+
+		break;
+	case QUEUE_HEADER_WAIT:
+		dev_info(&client->dev,
+				"QUEUE_HEADER_WAIT %x:%x:%x:%x\n",
+				buf[0], buf[1], buf[2], buf[3]);
+		/*! BUGFIX: buff[0] might be wrong (0x63),
+		 * check buff[1 ~ 3] is enough
+		 */
+		if (!memcmp(buf+1, &wait_packet[1], 3)) {
+			do {
+				udelay(30);
+				elants_recv_data(client, (uint8_t *)buff);
+			} while (buff->packet_id != QUEUE_HEADER_NORMAL &&
+					 --times > 0);
+			if (times > 0)
+				rc = elants_GetRepoInfo(client, (uint8_t *)buff);
+			else
+				return RET_FAIL;
+			elan_dbg(client,
+					 "Detect Wait_Header:rx_size=%d, "\
+					 "report_count=%d report_len=%d\n",
+					 ts->rx_size,
+					 ts->mq_header.report_count,
+					 ts->mq_header.report_length);
+		} else
+			dev_err(&client->dev,
+					"ERROR!! wait header:%x:%x:%x:%x\n",
+					buf[0], buf[1], buf[2], buf[3]);
+		break;
+		/* Not buffer mode, it's single word mode */
+	case QUEUE_HEADER_SINGLE:
+		ts->mq_header.report_count = 1;
+		ts->mq_header.report_length = PACKET_SIZE_WIDTH;
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
+		ts->rx_size = MAX_PACKET_LEN;
+		elants_recv_data(client, (uint8_t *)buff);
+		return RET_FAIL;
+	}
+
+	return ts->rx_size;
+}
+
+
+/**
+ *	elan_touch_checksum -  Add for checksum mechanism
+ *
+ *	@client : our i2c device
+ *	@buf : buffer data
+ *
+ *	caculating checksum for make sure all data validity.
+ */
+static int elan_touch_checksum(struct i2c_client *client, u8 *buf)
+{
+	u8 i = 0, checksum = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	/*! FIXME: checksum wasn't including width byte */
+	for (i = 0; i < PACKET_SIZE_WIDTH - 6; i++)
+		checksum = checksum + buf[i];
+
+	ts->checksum_correct = checksum;
+
+	if (checksum != buf[FW_POS_CHECKSUM]) {
+		ts->checksum_fail++;
+		dev_err(&client->dev,
+				"elan touch checksum fail: %02x:%02x\n",
+				checksum, buf[FW_POS_CHECKSUM]);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ *	elan_touch_parse_fid - parse the 10 fid bits
+ *
+ *	@data: the input bit stream
+ *	@fid: an array of fid values
+ *
+ *	Unpack the 10 bits into an array.
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
+ *	elan_touch_parse_wid - parse the 10 wid bits
+ *
+ *	@data: the input bit stream
+ *	@wid: an array of width level
+ *
+ *	Unpack the 10 bits into an array.
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
+/*
+ *	transition stage for lookup by table, maybe update finger report
+ *	using by Win8 50Byte format that having actual value for X, Y width
+ */
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
+static int elan_mt_compute_slot(struct mt_device *td,
+								struct input_dev *input)
+{
+	return input_mt_get_slot_by_key(input, td->curdata.contactid);
+}
+
+/*
+ * this function is called when a whole contact has been processed,
+ * so that it can assign it to a slot and store the data there
+ */
+static void elan_mt_complete_slot(struct mt_device *td,
+								  struct input_dev *input)
+{
+	struct elants_data *ts =
+		container_of(td, struct elants_data, td);
+
+	if (td->curvalid) {
+		int slotnum = elan_mt_compute_slot(td, input);
+		struct mt_slot *s = &td->curdata;
+
+		if (slotnum < 0 || slotnum >= td->maxcontacts)
+			return;
+
+		input_mt_slot(input, slotnum);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER,
+								   s->touch_state);
+		if (s->touch_state) {
+			/* this finger is on the screen */
+			int wide = (s->w > s->h);
+			/* divided by two to match visual scale of touch */
+			int major = max(s->w, s->h) >> 1;
+			int minor = min(s->w, s->h) >> 1;
+
+			elan_dbg(ts->client,
+					 "[ELAN] slot=%d x=%x y=%x w=%x h=%x\n",
+					 slotnum, s->x, s->y, major, minor);
+
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
+			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
+		}
+	}
+
+	td->num_received++;
+}
+
+/*
+ * this function is called when a whole packet has been received and processed,
+ * so that it can decide what to send to the input layer.
+ */
+static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
+{
+	input_mt_sync_frame(input);
+	input_sync(input);
+	td->num_received = 0;
+}
+
+
+/**
+ *	elan_mt_event - process finger reports
+ *	@ts: our touchscreen
+ *	@finger_stat: number of fingers in packet
+ *	@buf: received buffer
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
+	u8 fid[MAX_CONTACT_NUM], wid[MAX_CONTACT_NUM];
+	u16 x, y, w, h;
+	struct i2c_client *client = ts->client;
+	struct mt_device *td = &ts->td;
+
+	dev_dbg(&client->dev,
+			"[ELAN] Enter elan_mt_event Func\n");
+
+	/* Parsing Finger, Width field */
+	elan_touch_parse_fid(&buf[FW_POS_STATE], &fid[0]);
+	elan_touch_parse_wid(&buf[FW_POS_WIDTH], &wid[0]);
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
+		elan_mt_complete_slot(td, ts->input);
+	}
+
+	if (td->num_received >= td->num_expected)
+		mt_sync_frame(td, ts->input);
+
+	return 1;
+}
+
+
+
+/**
+ *	elants_report_data - report finger report to user space.
+ *
+ *	@client : our i2c device
+ *	@buf : raw data from TP device.
+ *
+ *	- reporting finger data to user space.
+ *	- packet_fail count
+ *
+ */
+static void elants_report_data(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	switch (buf[FW_POS_HEADER]) {
+	case REPORT_HEADER_10_FINGER: {
+		u8 finger_stat  = buf[FW_POS_TOTAL] & 0x0f;
+		elan_dbg(client,
+				 "[ELAN] finger_stat == %d\n", finger_stat);
+		elan_dbg(client,
+				 "[ELAN] finger:%x:%x:%x:%x:%x\n",
+				 buf[0], buf[1], buf[2], buf[3], buf[4]);
+
+		/* Enter right process, reset int_status*/
+		ts->packet_received++;
+
+		if (likely(finger_stat != 0)) {
+			ts->td.curvalid = true;
+			ts->touched_sync++;
+		} else
+			ts->no_touched_sync++;
+
+		/* Handle mt event */
+		elan_mt_event(ts, finger_stat, buf);
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
+
+static irqreturn_t elants_work_func(int irq, void *work)
+{
+	struct elants_data *ts = work;
+	uint8_t buf[MAX_PACKET_LEN] = {0x0};
+	u8 pos = 0, rc;
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Enter %s\n", __func__);
+
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
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
+	set_bit(LOCK_FINGER_REPORT, &ts->flags);
+
+	/* - Read multi_queue header */
+	if (elants_recv_data(ts->client, buf) < 0)
+		goto fail;
+
+	/*  - Get multi_queue header info */
+	rc = elants_GetRepoInfo(ts->client, buf);
+	if (rc < 0 || rc == RET_CMDRSP)
+		goto fail;
+
+	/* - Get finger report data */
+	if (elants_recv_data(ts->client, buf) < 0)
+		goto fail;
+
+	clear_bit(LOCK_FINGER_REPORT, &ts->flags);
+
+	mutex_unlock(&ts->mutex);
+
+	/* - parsing report and send out */
+	while (ts->mq_header.report_count--) {
+		if (elan_touch_checksum(ts->client, buf + pos) == 0)
+			elants_report_data(ts->client, buf + pos);
+		pos = pos + PACKET_SIZE_WIDTH;
+		udelay(10);
+	}
+
+	ts->rx_size = QUEUE_HEADER_SIZE;
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Leave %s\n", __func__);
+	return IRQ_HANDLED;
+
+fail:
+	clear_bit(LOCK_FINGER_REPORT, &ts->flags);
+	mutex_unlock(&ts->mutex);
+	ts->rx_size = QUEUE_HEADER_SIZE;
+
+	dev_dbg(&ts->client->dev,
+			"[ELAN] Leave %s(Fail)\n", __func__);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t elants_irq_handler(int irq, void *dev_id)
+{
+	struct elants_data *ts = dev_id;
+	struct i2c_client *client = ts->client;
+
+	dev_dbg(&client->dev, "[ELAN] %s\n", __func__);
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
+	int err = -1;
+
+	if (client->irq) {
+
+		err = request_threaded_irq(client->irq, elants_irq_handler,
+								   elants_work_func,
+								   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+								   client->name, ts);
+		if (err) {
+			dev_err(&client->dev,
+					"%s: request_irq %d failed\n",
+					__func__, client->irq);
+			goto err;
+		}
+
+		ts->status |= STA_USE_IRQ;
+
+		elan_dbg(client,
+				 "[ELAN] %s in interrupt mode\n", ts->input->name);
+	}
+err:
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
+	if (client->irq)
+		free_irq(client->irq, ts);
+
+	if (ts->input)
+		input_unregister_device(ts->input);
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
+	kfree(ts);
+
+	return ret;
+}
+
+
+/**
+ *	elants_probe - probe for touchpad
+ *
+ *	@client: our I2C client
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
+	mutex_init(&ts->mutex);
+	mutex_init(&ts->tr_mutex);
+	mutex_init(&ts->fifo_mutex);
+	init_waitqueue_head(&ts->wait);
+	spin_lock_init(&ts->rx_kfifo_lock);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+				"[ELAN] %s: i2c check functionality error\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev,
+				"[ELAN] %s no platform data\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	ts->status |= STA_INIT;
+
+	ts->intr_gpio = pdata->intr_gpio;
+	ts->rst_gpio = pdata->rst_gpio;
+	/* set initial i2c address */
+	client->addr = DEV_MASTER;
+	ts->i2caddr = client->addr;
+
+	elan_dbg(client,
+			 "reset=%d, intr=%d\n", ts->rst_gpio, ts->intr_gpio);
+
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+
+	/* initial kfifo */
+	err = kfifo_alloc(&ts->fifo, FIFO_SIZE, GFP_KERNEL);
+	if (!kfifo_initialized(&ts->fifo)) {
+		dev_err(&client->dev,
+				"%s error kfifo_alloc\n", __func__);
+		goto fail_un;
+	}
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
+	mutex_lock(&ts->mutex);
+
+	/* Says HELLO to touch device */
+	err = elants_setup(client);
+	if (err < 0) {
+		ts->status |= STA_ERR_HELLO_PKT;
+		dev_err(&client->dev,
+				"[ELAN] %s probe failed\n",
+				ELAN_DEV_NAME);
+		/* User can do upstream work anyway, continue */
+	}
+
+	ts->status |= STA_INIT2;
+
+	set_bit(BTN_TOUCH, ts->input->keybit);
+
+	/*! - Single touch input params setup */
+	input_set_abs_params(ts->input, ABS_X, 0, ts->cols, 0, 0);
+	input_set_abs_params(ts->input, ABS_Y, 0, ts->rows, 0, 0);
+	input_set_abs_params(ts->input, ABS_PRESSURE, 0, 255, 0, 0);
+
+	/*	WARNING FIXME: ABS_MT_PRESSURE can be supported by FW.
+	 *	currently we have done it by ABS_MT_WIDTH_MAJOR
+	 */
+
+	/* Multitouch input params setup */
+	input_set_abs_params(ts->input, ABS_MT_POSITION_X, 0, ts->cols, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_POSITION_Y, 0, ts->rows, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+
+	__set_bit(EV_ABS, ts->input->evbit);
+	__set_bit(EV_SYN, ts->input->evbit);
+
+	input_set_drvdata(ts->input, ts);
+
+	ts->td.slots = kzalloc(MAX_CONTACT_NUM * sizeof(struct mt_slot),
+						   GFP_KERNEL);
+	if (!ts->td.slots) {
+		dev_err(&client->dev,
+				"cannot allocate multitouch slots\n");
+		goto fail_un;
+	}
+	ts->td.maxcontacts = MAX_CONTACT_NUM;
+	ts->td.mt_flags |= INPUT_PROP_DIRECT;
+
+	input_mt_init_slots(ts->input, ts->td.maxcontacts, ts->td.mt_flags);
+	/* set frame rate as 100fps */
+	input_set_events_per_packet(ts->input, 100);
+
+	err = input_register_device(ts->input);
+	if (err) {
+		dev_err(&client->dev,
+				"[ELAN] %s unable to register input device\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	ts->status |= STA_INIT4;
+
+	/* WARNING If the firmware device fails
+	  * we carry on as it doesn't stop normal usage
+	  */
+	private_ts = &ts->firmware;
+	if (elants_register_interrupt(ts->client) < 0) {
+		dev_err(&client->dev,
+				"[ELAN] %s register_interrupt failed!\n",
+				ELAN_DEV_NAME);
+		goto fail_un;
+	}
+
+	mutex_unlock(&ts->mutex);
+
+	/* register sysfs */
+	elan_dbg(client,
+			 "[ELAN] create sysfs!!\n");
+	if (sysfs_create_group(&client->dev.kobj, &elan_attribute_group))
+		dev_err(&client->dev,
+				"[ELAN] sysfs create group error\n");
+
+	/* Elan Control Device Initial */
+	ts->firmware.minor = MISC_DYNAMIC_MINOR;
+	ts->firmware.name = "elan-cp";
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
+	ts->status |= STA_PROBED;
+
+	return 0;
+
+fail_un:
+	ts->status |= STA_NONINIT;
+	mutex_unlock(&ts->mutex);
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
+static int elants_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_sleep_cmd[] = {0x54, 0x50, 0x00, 0x01};
+	int rc = 0;
+
+	dev_err(&client->dev,
+			"[ELAN] %s: enter\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	disable_irq(client->irq);
+
+	mutex_lock(&ts->mutex);
+	rc = elants_set_data(client,
+						 set_sleep_cmd, sizeof(set_sleep_cmd));
+	if (rc < 0)
+		goto end;
+
+	ts->power_state = 0;
+
+end:
+	mutex_unlock(&ts->mutex);
+	return rc;
+}
+
+static int elants_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_active_cmd[] = {0x54, 0x58, 0x00, 0x01};
+	int rc = 0, retry = 5;
+
+	dev_err(&client->dev,
+			"[ELAN] %s: enter\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
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
+	enable_irq(client->irq);
+
+	return rc;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(elants_pm, elants_suspend, elants_resume);
+
+static const struct i2c_device_id elan_ts_id[] = {
+	{ ELAN_DEV_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, elan_ts_id);
+
+static struct i2c_driver elan_ts_driver = {
+	.probe		= elants_probe,
+	.remove		= __devexit_p(elants_remove),
+	.id_table	= elan_ts_id,
+	.driver		= {
+		.name	= ELAN_DEV_NAME,
+		.owner	= THIS_MODULE,
+		.bus    = &i2c_bus_type,
+		.pm		= &elants_pm,
+	},
+};
+
+module_i2c_driver(elan_ts_driver);
+
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_DESCRIPTION("Elan Microelectronics Touchpanels");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/elants.h b/include/linux/i2c/elants.h
new file mode 100644
index 0000000..b4eea3d
--- /dev/null
+++ b/include/linux/i2c/elants.h
@@ -0,0 +1,58 @@
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
+/**
+ * struct elan_i2c_platform_data platform - used by platform data
+ *
+ * @intr_gpio : gpio pin
+ * @rst_gpio : interuption pin
+ *
+ * Platform data, all platform dependent variable should put here.
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
+/* ioctl data */
+struct elan_ioctl_data {
+	int len;
+	char buf[32];
+};
+
+
+/* ioctl command definition.
+ * @IOCTL_I2C_SLAVE: set i2c address that would be controled right now.
+ * @IOCTL_RESET: Hardware Reset
+ * @IOCTL_SET_COMMAND: control command set to TP device.
+ * @IOCTL_GET_COMMAND: get response from our TP device.
+ * @IOCTL_IAP_ENABLE: Enter IAP mode
+ * @IOCTL_IAP_DISABLE: Leave IAP mode
+ * @IOCTL_I2C_INT: gpio status
+ *
+ *
+ * ioctl command, easy user to control our TP from application.
+ *
+ */
+#define ELAN_IOCTLID		0xD0
+#define IOCTL_I2C_SLAVE		_IOW(ELAN_IOCTLID,  1, int)
+#define IOCTL_RESET			_IOW(ELAN_IOCTLID, 4, int)
+#define IOCTL_I2C_INT		_IOR(ELAN_IOCTLID, 8, int)
+#define IOCTL_SET_COMMAND	_IOW(ELAN_IOCTLID, 9, unsigned long)
+#define IOCTL_GET_COMMAND	_IOR(ELAN_IOCTLID, 10, unsigned long)
+#define IOCTL_IAP_ENABLE	_IOW(ELAN_IOCTLID, 11, int)
+#define IOCTL_IAP_DISABLE	_IOW(ELAN_IOCTLID, 12, int)
+
+#endif /* _LINUX_I2C_ELANTS_H */
-- 
1.7.9.5

