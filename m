Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1AaOG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:06:27 -0500
Received: from smtp.nokia.com ([147.243.1.48]:28866 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab1AaOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:07 -0500
From: tapio.vihuri@nokia.com
To: dmitry.torokhov@gmail.com
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: [PATCH v6 2/3] ECI: introducing ECI controller driver
Date: Mon, 31 Jan 2011 16:03:53 +0200
Message-Id: <1296482634-31666-3-git-send-email-tapio.vihuri@nokia.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1296482634-31666-2-git-send-email-tapio.vihuri@nokia.com>
References: <1296482634-31666-1-git-send-email-tapio.vihuri@nokia.com>
 <1296482634-31666-2-git-send-email-tapio.vihuri@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tapio Vihuri <tapio.vihuri@nokia.com>

ECI controller is kind of bridge between host CPU I2C and ECI accessory
ECI communication.

Signed-off-by: Tapio Vihuri <tapio.vihuri@nokia.com>
---
 drivers/input/misc/Kconfig         |   17 +
 drivers/input/misc/Makefile        |    1 +
 drivers/input/misc/eci_at20_ctrl.c |  566 ++++++++++++++++++++++++++++++++++++
 include/linux/input/eci.h          |   24 ++-
 4 files changed, 607 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/eci_at20_ctrl.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index d3d4ab4..e87cf01 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -146,6 +146,9 @@ config INPUT_ECI
 	  - reading ECI configuration memory
 	  - ECI buttons as input events
 
+	  ECI input driver needs some ECI controller driver, select
+	  suitable controlelr driver(s) below.
+
 	  Say 'y' here to statically link this module into the kernel or 'm'
 	  to build it as a dynamically loadable module. The module will be
 	  called eci.ko
@@ -160,6 +163,20 @@ config ECI_DEBUG
 	  accessory's memory.
 	  Add memory and buttons parsing info to module eci.ko
 
+config INPUT_ECI_AT20
+	tristate "ECI controller driver"
+	select INPUT_ECI
+	depends on X86_MRST && INPUT_MISC
+	help
+	  This selects a driver for the ECI controller
+
+	  ECI controller is kind of bridge between host CPU I2C and
+	  ECI accessory ECI communication.
+
+	  Say 'y' here to statically link this module into the kernel or 'm'
+	  to build it as a dynamically loadable module. The module will be
+	  called eci_at20_ctrl.ko
+
 endif # ECI
 
 config INPUT_IXP4XX_BEEPER
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index fa99597..5e3dd7c 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_ECI)			+= eci.o
+obj-$(CONFIG_INPUT_ECI_AT20)		+= eci_at20_ctrl.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
 obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
 obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
diff --git a/drivers/input/misc/eci_at20_ctrl.c b/drivers/input/misc/eci_at20_ctrl.c
new file mode 100644
index 0000000..5e9d1e7
--- /dev/null
+++ b/drivers/input/misc/eci_at20_ctrl.c
@@ -0,0 +1,566 @@
+/*
+ * This file is part of ECI (Enhancement Control Interface) controller
+ * driver
+ *
+ * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
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
+ * ECI controller is kind of bridge between host CPU I2C and ECI accessory
+ * ECI communication.
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/input/eci.h>
+
+#define DRIVER_NAME	"eci_ctrl"
+
+#define ECIBUS_STATUS_DATA_READY	0x01
+#define ECIBUS_STATUS_ACCESSORY_INT	0x02
+
+#define ECIBUS_WAIT_IRQ		100	/* msec */
+#define ECI_RST_MIN		62
+#define ECI_RST_WAIT		10	/* msec */
+
+struct eci_ctrl_data {
+	struct device		*dev;
+	struct eci_cb		*eci_callback;
+	int			eci_ctrl_rst_gpio;
+	int			eci_ctrl_sw_ctrl_gpio;
+	int			eci_ctrl_int_gpio;
+	wait_queue_head_t	wait;
+	bool			wait_eci_buttons;
+	bool			wait_data;
+};
+
+static struct eci_ctrl_data *the_ed;
+
+#ifdef CONFIG_DEBUG_FS
+static int eci_ctrl_read_reg(u8 reg);
+static int eci_ctrl_write_reg(u8 reg, u8 param);
+static void eci_ctrl_emit_buttons(struct eci_ctrl_data *ed, bool force_up);
+
+static struct dentry *eci_ctrl_debugfs_dir;
+
+static ssize_t reset_read(struct file *file, char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct eci_ctrl_data *ed = file->private_data;
+	char buf[80];
+	int len = 0;
+	int ret;
+
+	if (*ppos == 0) {
+		ret = !!gpio_get_value(ed->eci_ctrl_rst_gpio);
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
+	struct eci_ctrl_data *ed = file->private_data;
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	if (!memcmp(buf, "0", 1))
+		gpio_set_value(ed->eci_ctrl_rst_gpio, 0);
+	else if (!memcmp(buf, "1", 1))
+		gpio_set_value(ed->eci_ctrl_rst_gpio, 1);
+
+	return count;
+}
+
+static ssize_t button_write(struct file *file, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	/* Assosiated in default_open() */
+	struct eci_ctrl_data *ed = file->private_data;
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	char buf[32];
+	int buf_size, ret;
+	unsigned long val;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	b->buttons = val;
+	eci_ctrl_emit_buttons(ed, ECI_REAL_BUTTONS);
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
+static const struct file_operations reset_fops = {
+	.open		= default_open,
+	.read		= reset_read,
+	.write		= reset_write,
+};
+
+static const struct file_operations button_fops = {
+	.open		= default_open,
+	.write		= button_write,
+};
+
+static void eci_ctrl_uninitialize_debugfs(void)
+{
+	if (eci_ctrl_debugfs_dir)
+		debugfs_remove_recursive(eci_ctrl_debugfs_dir);
+}
+
+static long eci_ctrl_initialize_debugfs(struct eci_ctrl_data *ed)
+{
+	void *ok;
+
+	/* /sys/kernel/debug/eci_ctrl */
+	eci_ctrl_debugfs_dir = debugfs_create_dir(ed->dev->driver->name, NULL);
+	if (!eci_ctrl_debugfs_dir)
+		return -ENOENT;
+
+	/* Struct ed assosiated to inode->i_private */
+	ok = debugfs_create_file("reset", S_IRUGO | S_IWUSR,
+			eci_ctrl_debugfs_dir, ed, &reset_fops);
+	if (!ok)
+		goto fail;
+
+	ok = debugfs_create_file("button", S_IWUSR,
+			eci_ctrl_debugfs_dir, ed, &button_fops);
+	if (!ok)
+		goto fail;
+
+	return 0;
+fail:
+	eci_ctrl_uninitialize_debugfs();
+	return -ENOENT;
+}
+#else
+#define eci_ctrl_initialize_debugfs(ed)	1
+#define eci_ctrl_uninitialize_debugfs()
+#endif
+
+/* For eci_ctrl controller internal registers */
+static int eci_ctrl_read_reg(u8 reg)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int eci_ctrl_write_reg(u8 reg, u8 param)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg <= ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg, param);
+}
+
+/* Reset and learn ECI accessory, ie. get speed */
+static int eci_acc_reset(void)
+{
+	s32 ret;
+
+	eci_ctrl_write_reg(ECIREG_RST_LEARN, 0);
+
+	msleep(ECI_RST_WAIT);
+
+	ret = eci_ctrl_read_reg(ECIREG_RST_LEARN);
+	if (ret < ECI_RST_MIN)
+		return -EIO;
+
+	return 0;
+}
+
+/* Read always four bytes, as stated in ECI specification */
+static int eci_acc_read_direct(u8 addr, char *buf)
+{
+	s32 ret;
+	int i;
+
+	/* Initiate ECI accessory memory read */
+	the_ed->wait_data = false;
+	if (!eci_ctrl_write_reg(ECIREG_READ_COUNT, 4))
+		if (eci_ctrl_write_reg(ECIREG_READ_DIRECT, addr))
+			return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECIBUS_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		ret = eci_ctrl_read_reg(ECIREG_READ_DIRECT + i);
+		if (ret < 0)
+			return ret;
+		buf[i] = ret;
+		usleep_range(2000, 10000);
+	}
+	return 0;
+}
+
+/* Trigger ECI accessory register data write (from accessory) */
+static int eci_fire_acc_read_reg(u8 reg, int count)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (!eci_ctrl_write_reg(ECIREG_READ_COUNT, count))
+		return i2c_smbus_read_byte_data(client, reg);
+	else
+		return -EIO;
+}
+
+/* For ECI accessory internal registers */
+static int eci_acc_read_reg(u8 reg, u8 *buf, int count)
+{
+	s32 ret;
+	int i;
+
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	the_ed->wait_data = false;
+	if (eci_fire_acc_read_reg(reg, count))
+		return -EIO;
+
+	if (!wait_event_timeout(the_ed->wait, the_ed->wait_data == true,
+				msecs_to_jiffies(ECIBUS_WAIT_IRQ)))
+		return -EIO;
+
+	for (i = 0; i < count; i++) {
+		ret = eci_ctrl_read_reg(ECIREG_READ_DIRECT + i);
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
+static int eci_acc_write_reg(u8 reg, u8 param)
+{
+	struct i2c_client *client = to_i2c_client(the_ed->dev);
+
+	if (reg > ECICMD_RESERVED)
+		return -EINVAL;
+
+	return i2c_smbus_write_byte_data(client, reg, param);
+}
+
+
+/*
+ * Struct eci_data is ECI input driver (dealing ECI accessories) data.
+ * Struct eci_ctrl_data is this driver data, dealing just ECI communication.
+ * Global eci_register() pairs structs so that we can call ECI input driver
+ * event function with eci_data
+ */
+static void eci_ctrl_emit_buttons(struct eci_ctrl_data *ed, bool force_up)
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
+static void eci_ctrl_get_buttons(u8 *buf, u8 count)
+{
+	int i, ret;
+
+	if (count > 4) {
+		dev_err(the_ed->dev, "Maximum four bytes allowed\n");
+		return;
+	}
+
+	for (i = 0; i <= count; i++) {
+		ret = eci_ctrl_read_reg(ECIREG_READ_DIRECT + i);
+		buf[i] = ret;
+	}
+}
+
+static irqreturn_t eci_ctrl_irq_handler(int irq, void *_ed)
+{
+	struct eci_ctrl_data *ed = _ed;
+	struct eci_data *eci = ed->eci_callback->priv;
+	struct eci_buttons_data *b = &eci->buttons_data;
+	int status;
+	char buf[4];
+
+	/* Clears eci_ctrl DATA interrupt */
+	status = eci_ctrl_read_reg(ECIREG_STATUS);
+
+	if (status & ECIBUS_STATUS_DATA_READY) {
+		/*
+		 * Buttons are special case as we want be fast with them
+		 * and this way we cope with nested button and data interrupts
+		 * The number of bytes needed to read is parsed in ECI
+		 * input driver, based on data in ECI accessory.
+		 * Maximum four bytes.
+		 */
+		if (ed->wait_eci_buttons) {
+			eci_ctrl_get_buttons(buf, eci->port_reg_count);
+			b->buttons = cpu_to_le32(*(u32 *)buf);
+			eci_ctrl_emit_buttons(ed, ECI_REAL_BUTTONS);
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
+			eci_fire_acc_read_reg(ECICMD_PORT_DATA_0, 2);
+			ed->wait_eci_buttons = true;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct eci_hw_ops eci_ctrl_hw_ops = {
+	.acc_reset              = eci_acc_reset,
+	.acc_read_direct        = eci_acc_read_direct,
+	.acc_read_reg           = eci_acc_read_reg,
+	.acc_write_reg          = eci_acc_write_reg,
+};
+
+static struct eci_ctrl_data *eci_ctrl_probe(struct device *dev)
+{
+	struct eci_ctrl_data *ed;
+	struct eci_ctrl_platform_data *pdata = dev->platform_data;
+	int ret;
+
+	if (!pdata) {
+		dev_err(dev, "platform_data not available\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	ed = kzalloc(sizeof(*ed), GFP_KERNEL);
+	if (!ed)
+		return ERR_PTR(-ENOMEM);
+
+	ed->dev = dev;
+	ed->eci_ctrl_rst_gpio = pdata->eci_ctrl_rst_gpio;
+	ed->eci_ctrl_sw_ctrl_gpio = pdata->eci_ctrl_sw_ctrl_gpio;
+	ed->eci_ctrl_int_gpio = pdata->eci_ctrl_int_gpio;
+
+	if (ed->eci_ctrl_rst_gpio == 0 || ed->eci_ctrl_sw_ctrl_gpio == 0 ||
+			ed->eci_ctrl_int_gpio == 0) {
+		ret = -ENXIO;
+		goto gpio_err;
+	}
+
+	the_ed = ed;
+
+	ret = eci_ctrl_initialize_debugfs(ed);
+	if (ret)
+		dev_err(dev, "could not create debugfs entries\n");
+
+	ret = gpio_request(ed->eci_ctrl_rst_gpio, "ECI_RSTn");
+	if (ret) {
+		dev_err(dev, "could not request ECI_RSTn gpio %d\n",
+				ed->eci_ctrl_rst_gpio);
+		goto rst_gpio_err;
+	}
+
+	gpio_direction_output(ed->eci_ctrl_rst_gpio, 0);
+	gpio_set_value(ed->eci_ctrl_rst_gpio, 1);
+
+	ret = gpio_request(ed->eci_ctrl_sw_ctrl_gpio, "ECI_SW_CTRL");
+	if (ret) {
+		dev_err(dev, "could not request ECI_SW_CTRL gpio %d\n",
+				ed->eci_ctrl_sw_ctrl_gpio);
+		goto sw_ctrl_gpio_err;
+	}
+
+	gpio_direction_input(ed->eci_ctrl_sw_ctrl_gpio);
+
+	ret = gpio_request(ed->eci_ctrl_int_gpio, "ECI_INT");
+	if (ret) {
+		dev_err(dev, "could not request ECI_INT gpio %d\n",
+				ed->eci_ctrl_int_gpio);
+		goto int_gpio_err;
+	}
+
+	gpio_direction_input(ed->eci_ctrl_int_gpio);
+
+	ret = request_threaded_irq(gpio_to_irq(ed->eci_ctrl_int_gpio), NULL,
+			eci_ctrl_irq_handler, IRQF_TRIGGER_RISING,
+			"ECI_INT", ed);
+	if (ret) {
+		dev_err(dev, "could not request irq %d\n",
+				gpio_to_irq(ed->eci_ctrl_int_gpio));
+		goto int_irq_err;
+	}
+
+	/* Register itself to the ECI accessory driver */
+	ed->eci_callback = eci_register(&eci_ctrl_hw_ops);
+	if (IS_ERR(ed->eci_callback)) {
+		ret = PTR_ERR(ed->eci_callback);
+		goto eci_register_err;
+	}
+
+	init_waitqueue_head(&ed->wait);
+
+	return ed;
+
+eci_register_err:
+	free_irq(gpio_to_irq(ed->eci_ctrl_int_gpio), ed);
+int_irq_err:
+	gpio_free(ed->eci_ctrl_int_gpio);
+int_gpio_err:
+	gpio_free(ed->eci_ctrl_sw_ctrl_gpio);
+sw_ctrl_gpio_err:
+	gpio_set_value(ed->eci_ctrl_rst_gpio, 0);
+	gpio_free(ed->eci_ctrl_rst_gpio);
+rst_gpio_err:
+	eci_ctrl_uninitialize_debugfs();
+gpio_err:
+	kfree(ed);
+
+	return ERR_PTR(ret);
+}
+
+static int __devinit eci_ctrl_i2c_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct eci_ctrl_data *ed;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS byte data not supported\n");
+		return -EIO;
+	}
+
+	ed = eci_ctrl_probe(&client->dev);
+
+	if (IS_ERR(ed))
+		return PTR_ERR(ed);
+
+	i2c_set_clientdata(client, ed);
+
+	return 0;
+}
+
+static int __exit eci_ctrl_remove(struct i2c_client *client)
+{
+	struct eci_ctrl_data *ed = i2c_get_clientdata(client);
+
+	gpio_set_value(ed->eci_ctrl_rst_gpio, 0);
+	gpio_free(ed->eci_ctrl_rst_gpio);
+
+	gpio_free(ed->eci_ctrl_sw_ctrl_gpio);
+
+	free_irq(gpio_to_irq(ed->eci_ctrl_int_gpio), ed);
+	gpio_free(ed->eci_ctrl_int_gpio);
+
+	eci_ctrl_uninitialize_debugfs();
+
+	kfree(ed);
+
+	return 0;
+}
+
+#ifdef	CONFIG_PM
+
+static int eci_ctrl_suspend(struct i2c_client *client, pm_message_t message)
+{
+	return -ENOSYS;
+}
+#else
+#define	eci_ctrl_suspend	NULL
+#endif
+
+static const struct i2c_device_id eci_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, eci_id);
+
+static struct i2c_driver eci_i2c_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= eci_ctrl_i2c_probe,
+	.remove		= __exit_p(eci_ctrl_remove),
+	.suspend	= eci_ctrl_suspend,
+	.id_table	= eci_id,
+};
+
+static int __init eci_ctrl_init(void)
+{
+	return i2c_add_driver(&eci_i2c_driver);
+}
+module_init(eci_ctrl_init);
+
+static void __exit eci_ctrl_exit(void)
+{
+	i2c_del_driver(&eci_i2c_driver);
+}
+module_exit(eci_ctrl_exit);
+
+MODULE_DESCRIPTION("ECI accessory controller driver");
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_ALIAS("i2c:eci_at20_ctrl");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/input/eci.h b/include/linux/input/eci.h
index 0e22404..868d2fb 100644
--- a/include/linux/input/eci.h
+++ b/include/linux/input/eci.h
@@ -1,7 +1,7 @@
 /*
  * This file is part of ECI (Enhancement Control Interface) driver
  *
- * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ * Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
  *
  * Contact: Tapio Vihuri <tapio.vihuri@nokia.com>
  *
@@ -35,6 +35,21 @@
 #define ECI_REAL_BUTTONS	0
 #define ECI_FORCE_BUTTONS_UP	1
 
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
+#define GPIO_ECI_RSTn		126	/* GP_CORE_030 + 96 */
+#define GPIO_ECI_SW_CTRL	178	/* GP_CORE_082 + 96 */
+#define GPIO_ECI_INT		16	/* GP_AON_016 */
+
 /* fixed in ECI HW, do not change */
 enum {
 	ECICMD_HWID,
@@ -154,4 +169,11 @@ struct eci_data {
 };
 
 struct eci_cb *eci_register(struct eci_hw_ops *eci_ops);
+
+/* eci controller data */
+struct eci_ctrl_platform_data {
+	int		eci_ctrl_rst_gpio;
+	int		eci_ctrl_sw_ctrl_gpio;
+	int		eci_ctrl_int_gpio;
+};
 #endif
-- 
1.6.5

