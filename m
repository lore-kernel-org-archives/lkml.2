Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1ADODf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:03:35 -0500
Received: from smtp.nokia.com ([147.243.128.26]:39140 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1ADOCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:02:47 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
Subject: [PATCH v3 2/3] ECI: introducing ECI bus driver
Date: Tue,  4 Jan 2011 16:02:27 +0200
Message-Id: <1294149748-13854-3-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1294149748-13854-2-git-send-email-tapio.vihuri@nokia.com>
References: <1294149748-13854-1-git-send-email-tapio.vihuri@nokia.com>
 <1294149748-13854-2-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
ECI communication.

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 drivers/Kconfig           |    2 +
 drivers/Makefile          |    1 +
 drivers/ecibus/Kconfig    |   35 +++
 drivers/ecibus/Makefile   |   10 +
 drivers/ecibus/ecibus.c   |  583 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/input/eci.h |    8 +
 6 files changed, 639 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ecibus/Kconfig
 create mode 100644 drivers/ecibus/Makefile
 create mode 100644 drivers/ecibus/ecibus.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index a2b902f..f450f98 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
+
+source "drivers/ecibus/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index f3ebb30..11f5d57 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -113,5 +113,6 @@ obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
+obj-$(CONFIG_ECI)		+= ecibus/
 obj-y				+= platform/
 obj-y				+= ieee802154/
diff --git a/drivers/ecibus/Kconfig b/drivers/ecibus/Kconfig
new file mode 100644
index 0000000..f2fc8a4
--- /dev/null
+++ b/drivers/ecibus/Kconfig
@@ -0,0 +1,35 @@
+#
+# ECI driver configuration
+#
+menuconfig ECI
+	bool "ECI support"
+	help
+	  ECI (Enhancement Control Interface) accessory support
+
+	  The Enhancement Control Interface functionality
+	  ECI is better known as Multimedia Headset for Nokia phones.
+	  If headset has many buttons, like play, vol+, vol- etc. then
+	  it is propably ECI accessory.
+	  Among several buttons ECI accessory contains memory for storing
+	  several parameters.
+
+	  Enable ECI support in terminal so that ECI input driver is able
+	  to communicate with ECI accessory
+
+if ECI
+
+config ECI_BUS
+	tristate "ECI bus controller driver"
+	select INPUT_ECI
+	depends on X86_MRST && INPUT_MISC
+	help
+	  This selects a driver for the ECI bus controller
+
+	  ECI bus controller is kind of bridge between host CPU I2C and
+	  ECI accessory ECI communication.
+
+	  Say 'y' here to statically link this module into the kernel or 'm'
+	  to build it as a dynamically loadable module. The module will be
+	  called ecibus.ko
+
+endif # ECI
diff --git a/drivers/ecibus/Makefile b/drivers/ecibus/Makefile
new file mode 100644
index 0000000..ce4206b
--- /dev/null
+++ b/drivers/ecibus/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for kernel ECI drivers.
+#
+
+ifeq ($(CONFIG_ECI_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
+
+# ECI master controller drivers (bus)
+obj-$(CONFIG_ECI_BUS)			+= ecibus.o
diff --git a/drivers/ecibus/ecibus.c b/drivers/ecibus/ecibus.c
new file mode 100644
index 0000000..93266b3
--- /dev/null
+++ b/drivers/ecibus/ecibus.c
@@ -0,0 +1,583 @@
+/*
+ * This file is part of ECI (Enhancement Control Interface) bus controller
+ * driver
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+/*
+ * ECI stands for (Enhancement Control Interface).
+ *
+ * ECI is better known as Multimedia Headset for Nokia phones.
+ * If headset has many buttons, like play, vol+, vol- etc. then it is propably
+ * ECI accessory.
+ *
+ * ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
+ * ECI communication.
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/input/eci.h>
+
+#include <asm/intel_scu_ipc.h>
+
+/*
+ * VPROG2CNT - VPROG2 Control Register
+ * 2.5V | normal | normal
+ * 10   | 111    | 111
+ * 2.5V | off    | off
+ * 10   | 100    | 100
+ */
+#define AvP_MSIC_VPROG2		0xd7
+#define AvP_MSIC_VPROG2_2V5_ON	0xbf
+#define AvP_MSIC_VPROG2_2V5_OFF 0xa4
+
+#define ECIBUS_I2C_ADDRS		0x6d
+#define ECIBUS_STATUS_DATA_READY	0x01
+#define ECIBUS_STATUS_ACCESSORY_INT	0x02
+
+#define ECIBUS_WAIT_IRQ		100	/* msec */
+#define ECI_RST_MIN		62
+#define ECI_RST_WAIT		10	/* msec */
+
+struct ecibus_data {
+	struct i2c_client	*client;
+	struct device		*dev;
+	struct eci_cb		*eci_callback;
+	int			ecibus_rst_gpio;
+	int			ecibus_sw_ctrl_gpio;
+	int			ecibus_int_gpio;
+	wait_queue_head_t	wait;
+	bool			wait_eci_buttons;
+	bool			wait_data;
+};
+
+static struct ecibus_data *the_ed;
+
+#ifdef CONFIG_DEBUG_FS
+static int ecibus_ctrl_read_reg(u8 reg);
+static int ecibus_ctrl_write_reg(u8 reg, u8 param);
+
+static struct dentry *ecibus_debugfs_dir;
+
+static ssize_t debug_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	char buf[80];
+	int len = 0;
+	int ret;
+
+	if (*ppos == 0) {
+		ret = ecibus_ctrl_read_reg(ECIREG_TEST_IN);
+		if (ret < 0)
+			return ret;
+		len += snprintf(buf + len, sizeof(buf) - len, "%02x\n", ret);
+	}
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return ret;
+}
+
+static ssize_t debug_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	char buf[80];
+	int buf_size;
+	unsigned long val;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = '\0';
+	if (!strict_strtoul(buf, 0, &val))
+		ecibus_ctrl_write_reg(ECIREG_TEST_OUT, val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t reset_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct ecibus_data *ed = file->private_data;
+	char buf[80];
+	int len = 0;
+	int ret;
+
+	if (*ppos == 0) {
+		ret = !!gpio_get_value(ed->ecibus_rst_gpio);
+		len = snprintf(buf, sizeof(buf), "%d\n", ret);
+	}
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return ret;
+}
+
+static ssize_t reset_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct ecibus_data *ed = file->private_data;
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (!memcmp(buf, "0", 1))
+		gpio_set_value(ed->ecibus_rst_gpio, 0);
+	else if (!memcmp(buf, "1", 1))
+		gpio_set_value(ed->ecibus_rst_gpio, 1);
+
+	return count;
+}
+
+static int default_open(struct inode *inode, struct file *file)
+{
+	/* Assosiated in debugfs_create_file() */
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations debug_fops = {
+	.open		= default_open,
+	.read		= debug_read,
+	.write		= debug_write,
+};
+
+static const struct file_operations reset_fops = {
+	.open		= default_open,
+	.read		= reset_read,
+	.write		= reset_write,
+};
+
+static void ecibus_uninitialize_debugfs(void)
+{
+	if (ecibus_debugfs_dir)
+		debugfs_remove_recursive(ecibus_debugfs_dir);
+}
+
+static long ecibus_initialize_debugfs(struct ecibus_data *ed)
+{
+	void *ok;
+
+	/* /sys/kernel/debug/ecibus.# */
+	ecibus_debugfs_dir = debugfs_create_dir(dev_name(ed->dev), NULL);
+	if (!ecibus_debugfs_dir)
+		return -ENOENT;
+
+	/* Struct ed assosiated to inode->i_private */
+	ok = debugfs_create_file("debug", S_IRUGO | S_IWUSR,
+			ecibus_debugfs_dir, ed, &debug_fops);
+	if (!ok)
+		goto fail;
+
+	ok = debugfs_create_file("reset", S_IRUGO | S_IWUSR,
+			ecibus_debugfs_dir, ed, &reset_fops);
+	if (!ok)
+		goto fail;
+
+	return 0;
+fail:
+	ecibus_uninitialize_debugfs();
+	return -ENOENT;
+}
+#else
+#define ecibus_initialize_debugfs(ed)	1
+#define ecibus_uninitialize_debugfs()
+#endif
+
+static struct i2c_board_info ecibus_i2c = {
+	I2C_BOARD_INFO("ecibus", ECIBUS_I2C_ADDRS) };
+
+/* For ecibus controller internal registers */
+static int ecibus_ctrl_read_reg(u8 reg)
+{
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_read_byte_data(the_ed->client, reg);
+}
+
+static int ecibus_ctrl_write_reg(u8 reg, u8 param)
+{
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(the_ed->client, reg, param);
+}
+
+/* Reset and learn ECI accessory, ie. get speed */
+static int ecibus_acc_reset(void)
+{
+	s32 ret;
+
+	ecibus_ctrl_write_reg(ECIREG_RST_LEARN, 0);
+
+	msleep(ECI_RST_WAIT);
+
+	ret = ecibus_ctrl_read_reg(ECIREG_RST_LEARN);
+	if (ret < ECI_RST_MIN)
+		return -EIO;
+
+	return 0;
+}
+/* Read always four bytes, as stated in ECI specification */
+static int ecibus_acc_read_direct(u8 addr, char *buf)
+{
+	s32 ret;
+	int i;
+
+	/* Initiate ECI accessory memory read */
+	the_ed->wait_data = false;
+	if (!ecibus_ctrl_write_reg(ECIREG_READ_COUNT, 4))
+		if (ecibus_ctrl_write_reg(ECIREG_READ_DIRECT, addr))
+			return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECIBUS_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		ret = ecibus_ctrl_read_reg(ECIREG_READ_DIRECT + i);
+		if (ret < 0)
+			return ret;
+		buf[i] = ret;
+		usleep_range(2000, 10000);
+	}
+	return 0;
+}
+
+/* Trigger ECI accessory register data write (from accessory) */
+static int ecibus_fire_acc_read_reg(u8 reg, int count)
+{
+	if (!ecibus_ctrl_write_reg(ECIREG_READ_COUNT, count))
+		return i2c_smbus_read_byte_data(the_ed->client, reg);
+	else
+		return -EIO;
+}
+
+/* For ECI accessory internal registers */
+static int ecibus_acc_read_reg(u8 reg, u8 *buf, int count)
+{
+	s32 ret;
+	int i;
+
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	the_ed->wait_data = false;
+	if (ecibus_fire_acc_read_reg(reg, count))
+		return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECIBUS_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < count; i++) {
+		ret = ecibus_ctrl_read_reg(ECIREG_READ_DIRECT + i);
+		if (ret < 0)
+			return ret;
+
+		buf[i] = ret;
+	}
+
+	return 0;
+}
+
+/* ECI accessory register write */
+static int ecibus_acc_write_reg(u8 reg, u8 param)
+{
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(the_ed->client, reg, param);
+}
+
+
+/*
+ * Struct eci_data is ECI input driver (dealing ECI accessories) data.
+ * Struct ecibus_data is this driver data, dealing just ECI communication.
+ * Global eci_register() pairs structs so that we can call ECI input driver
+ * event function with eci_data
+ */
+static void ecibus_emit_buttons(struct ecibus_data *ed, bool force_up)
+{
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+
+	if (force_up)
+		b->buttons = b->buttons_up_mask;
+
+	ed->eci_callback->event(ECI_EVENT_BUTTON, eci);
+}
+
+static void ecibus_get_buttons(u8 *buf)
+{
+	int i, ret;
+
+	for (i = 0; i < 2; i++) {
+		ret = ecibus_ctrl_read_reg(ECIREG_READ_DIRECT + i);
+		buf[i] = ret;
+	}
+}
+
+static irqreturn_t ecibus_irq_handler(int irq, void *_ed)
+{
+	struct ecibus_data *ed = _ed;
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	int status;
+	char buf[4];
+
+	/* Clears ecibus DATA interrupt */
+	status = ecibus_ctrl_read_reg(ECIREG_STATUS);
+
+	if (status & ECIBUS_STATUS_DATA_READY) {
+		/*
+		 * Buttons are special case as we want be fast with them
+		 * and this way we cope with nested button and data interrupts
+		 */
+		if (ed->wait_eci_buttons) {
+			ecibus_get_buttons(buf);
+			b->buttons = cpu_to_le32(*(u32 *)buf);
+			ecibus_emit_buttons(ed, ECI_REAL_BUTTONS);
+			ed->wait_eci_buttons = false;
+		}
+		/* Complete ECI data reading */
+		ed->wait_data = true;
+		wake_up(&ed->wait);
+	}
+
+	/* Accessory interrupt, ie. button pressed */
+	if (status & ECIBUS_STATUS_ACCESSORY_INT) {
+		if (eci->mem_ok) {
+			ecibus_fire_acc_read_reg(ECICMD_PORT_DATA_0, 2);
+			ed->wait_eci_buttons = true;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct eci_hw_ops ecibus_hw_ops = {
+	.acc_reset              = ecibus_acc_reset,
+	.acc_read_direct        = ecibus_acc_read_direct,
+	.acc_read_reg           = ecibus_acc_read_reg,
+	.acc_write_reg          = ecibus_acc_write_reg,
+};
+
+static int __init ecibus_probe(struct platform_device *pdev)
+{
+	struct ecibus_data *ed;
+	struct ecibus_platform_data *pdata = pdev->dev.platform_data;
+	struct i2c_adapter *adapter;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "platform_data not available: %d\n",
+				__LINE__);
+		return -EINVAL;
+	}
+
+	ed = kzalloc(sizeof(*ed), GFP_KERNEL);
+	if (!ed)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ed);
+	ed->dev = &pdev->dev;
+	ed->ecibus_rst_gpio = pdata->ecibus_rst_gpio;
+	ed->ecibus_sw_ctrl_gpio = pdata->ecibus_sw_ctrl_gpio;
+	ed->ecibus_int_gpio = pdata->ecibus_int_gpio;
+
+	if (ed->ecibus_rst_gpio == 0 || ed->ecibus_sw_ctrl_gpio == 0 ||
+			ed->ecibus_int_gpio == 0) {
+		ret = -ENXIO;
+		goto gpio_err;
+	}
+
+	the_ed = ed;
+
+	adapter = i2c_get_adapter(1);
+	if (adapter)
+		ed->client = i2c_new_device(adapter, &ecibus_i2c);
+	if (!ed->client) {
+		dev_err(ed->dev, "could not get i2c device %s at 0x%02x: %d\n",
+				ecibus_i2c.type, ecibus_i2c.addr, __LINE__);
+		kfree(ed);
+
+		return -ENODEV;
+	}
+
+	ret = ecibus_initialize_debugfs(ed);
+	if (ret)
+		dev_err(ed->dev, "could not create debugfs entries: %d\n",
+				__LINE__);
+
+	ret = gpio_request(ed->ecibus_rst_gpio, "ECI_RSTn");
+	if (ret) {
+		dev_err(ed->dev, "could not request ECI_RSTn gpio %d: %d\n",
+				ed->ecibus_rst_gpio, __LINE__);
+		goto rst_gpio_err;
+	}
+
+	gpio_direction_output(ed->ecibus_rst_gpio, 0);
+	gpio_set_value(ed->ecibus_rst_gpio, 1);
+
+	ret = gpio_request(ed->ecibus_sw_ctrl_gpio, "ECI_SW_CTRL");
+	if (ret) {
+		dev_err(ed->dev, "could not request ECI_SW_CTRL gpio %d: %d\n",
+				ed->ecibus_sw_ctrl_gpio, __LINE__);
+		goto sw_ctrl_gpio_err;
+	}
+
+	gpio_direction_input(ed->ecibus_sw_ctrl_gpio);
+
+	ret = gpio_request(ed->ecibus_int_gpio, "ECI_INT");
+	if (ret) {
+		dev_err(ed->dev, "could not request ECI_INT gpio %d: %d\n",
+				ed->ecibus_int_gpio, __LINE__);
+		goto int_gpio_err;
+	}
+
+	gpio_direction_input(ed->ecibus_int_gpio);
+
+	ret = request_threaded_irq(gpio_to_irq(ed->ecibus_int_gpio), NULL,
+			ecibus_irq_handler, IRQF_TRIGGER_RISING, "ECI_INT", ed);
+	if (ret) {
+		dev_err(ed->dev, "could not request irq %d: %d\n",
+				gpio_to_irq(ed->ecibus_int_gpio), __LINE__);
+		goto int_irq_err;
+	}
+
+	/* Register itself to the ECI accessory driver */
+	ed->eci_callback = eci_register(&ecibus_hw_ops);
+	if (IS_ERR(ed->eci_callback)) {
+		ret = PTR_ERR(ed->eci_callback);
+		goto eci_register_err;
+
+	}
+
+	/*
+	 * Turn on vprog2
+	 * Some decent power ctrl interface, please
+	 */
+	intel_scu_ipc_iowrite8(AvP_MSIC_VPROG2, AvP_MSIC_VPROG2_2V5_ON);
+
+	init_waitqueue_head(&ed->wait);
+
+	return 0;
+
+eci_register_err:
+	free_irq(gpio_to_irq(ed->ecibus_int_gpio), ed);
+int_irq_err:
+	gpio_free(ed->ecibus_int_gpio);
+int_gpio_err:
+	gpio_free(ed->ecibus_sw_ctrl_gpio);
+sw_ctrl_gpio_err:
+	gpio_set_value(ed->ecibus_rst_gpio, 0);
+	gpio_free(ed->ecibus_rst_gpio);
+rst_gpio_err:
+	ecibus_uninitialize_debugfs();
+	i2c_unregister_device(ed->client);
+gpio_err:
+	kfree(ed);
+
+	return ret;
+}
+
+static int __exit ecibus_remove(struct platform_device *pdev)
+{
+	struct ecibus_data *ed = platform_get_drvdata(pdev);
+
+	gpio_set_value(ed->ecibus_rst_gpio, 0);
+	gpio_free(ed->ecibus_rst_gpio);
+
+	gpio_free(ed->ecibus_sw_ctrl_gpio);
+
+	free_irq(gpio_to_irq(ed->ecibus_int_gpio), ed);
+	gpio_free(ed->ecibus_int_gpio);
+
+	ecibus_uninitialize_debugfs();
+	i2c_unregister_device(ed->client);
+
+	/*
+	 * Turn off vprog2
+	 * Some decent power ctrl interface, please
+	 */
+	intel_scu_ipc_iowrite8(AvP_MSIC_VPROG2, AvP_MSIC_VPROG2_2V5_OFF);
+
+	kfree(ed);
+
+	return 0;
+}
+
+#ifdef	CONFIG_PM
+
+static int ecibus_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return -ENOSYS;
+}
+#else
+#define	ecibus_suspend	NULL
+#endif
+
+static struct platform_driver ecibus_driver = {
+	.driver		= {
+		.name	= "ecibus",
+		.owner	= THIS_MODULE,
+	},
+	.suspend	= ecibus_suspend,
+	.remove		= __exit_p(ecibus_remove),
+};
+
+static int __init ecibus_init(void)
+{
+	return platform_driver_probe(&ecibus_driver, ecibus_probe);
+}
+module_init(ecibus_init);
+
+static void __exit ecibus_exit(void)
+{
+
+	platform_driver_unregister(&ecibus_driver);
+}
+module_exit(ecibus_exit);
+
+MODULE_DESCRIPTION("ECI accessory controller driver");
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_ALIAS("platform:ecibus");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/input/eci.h b/include/linux/input/eci.h
index 0e22404..a0b5d20 100644
--- a/include/linux/input/eci.h
+++ b/include/linux/input/eci.h
@@ -154,4 +154,12 @@ struct eci_data {
 };
 
 struct eci_cb *eci_register(struct eci_hw_ops *eci_ops);
+
+/* ecibus controller data */
+struct ecibus_platform_data {
+	int			ecibus_rst_gpio;
+	int			ecibus_sw_ctrl_gpio;
+	int			ecibus_int_gpio;
+};
+
 #endif
-- 
1.6.5

