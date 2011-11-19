Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1KSRvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:51:37 -0500
Received: from forward2.mail.yandex.net ([77.88.46.7]:46609 "EHLO
	forward2.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1KSRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:51:36 -0500
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Nov 2011 12:51:35 EST
Message-Id: <20111119213932.dWIuKkI5@smtp3.mail.yandex.net>
Date: Sat, 19 Nov 2011 21:39:32 +0400
To: undisclosed-recipients:;
X-Yandex-Spam: 1
From: <necromant@necromant.ath.cx>
CC: <necromant@necromant.ath.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/1] drivers/char/xilinx-sscu: Xilinx Slave Serial Configuration Uploader driver

This is a bitbang driver that implements slave serial bitstream upload for
Xilinx FPGAs. This is done via gpiolib bitbang, therefore should be portable to
any hardware that has several spare GPIOs. Using his driver you can reprogram
the FPGA without stopping the actual system or popping on any jtag cables.
See documentation note in the patch for details. 

The driver supports multiple instances, therefore you can have as many 
'/dev/fpga's as you want, but it relies on a corresponding platform device to be
created beforehand, with GPIO numbers in platform_data.

Tested on an ARM at91sam9260 development board running at 200Mhz with a Xilinx
XC3S500E Spartan FPGA. The upload of a ~280kbyte bitstream takes about 6 seconds.

Benchmark: 
# time cat /blinky.bin > /dev/fpga0                                                                                                                                                          
real    0m 6.48s                                                                                                                                                                             
user    0m 0.00s                                                                                                                                                                             
sys     0m 6.01s                                                                                                                                                                             
# 

Comments and suggestions welcome. This is my first patch to lkml, so I might be missing
some trivial things.

Regards, 
Andrew

Signed-off-by: Andrew Andrianov <contact@necromant.ath.cx>
CC: Andrew Andrianov <contact@necromant.ath.cx>
---
diff --git a/Documentation/misc-devices/xilinx-sscu.txt b/Documentation/misc-devices/xilinx-sscu.txt
new file mode 100644
index 0000000..7cafd19
--- /dev/null
+++ b/Documentation/misc-devices/xilinx-sscu.txt
@@ -0,0 +1,90 @@
+Kernel driver xilinx-sscu
+=====================
+This is a bitbang driver that implements slave serial bitstream upload for
+Xilinx FPGAs. This is done in a bitbang, therefore should be portable to
+any hardware that has several spare GPIOs. using his driver you can reprogram
+the FPGA without stopping the actual system or popping on any jtag cables.
+
+Setting up the board
+=====================
+This driver attaches to a platform devices, therefore, to use it - you have to
+register it in your board file with any required hardware-specific initialisation.
+All the fields are self-explanatory. Note, you can have as many fpgas attached
+to the system as you want (as long as you have required GPIO lines)
+Here goes an example for arm/mach-at91 board of mine:
+#include <linux/xilinx-sscu.h>
+
+
+static struct xsscu_data charlene_xsscu_pdata[] = {
+  {
+  .name="Xilinx Spartan-XC3S500E",
+  .sout=AT91_PIN_PC7,
+  .prog_b=AT91_PIN_PC9,
+  .clk=AT91_PIN_PC6,
+  .done=AT91_PIN_PC4,
+  .init_b=AT91_PIN_PC10,
+  },
+};
+
+
+static int __init charlene_register_xsscu(struct xsscu_data* pdata, int count)
+{
+  int i,err;
+  struct platform_device *pdev;
+  for (i=0;i<count;i++)
+  {
+   printk(KERN_INFO "Registering xsscu interface for: %s\n", pdata[i].name);
+   at91_set_GPIO_periph(pdata[i].init_b,1);
+   at91_set_GPIO_periph(pdata[i].done,1);
+   at91_set_GPIO_periph(pdata[i].clk,0);
+   at91_set_GPIO_periph(pdata[i].sout,0);
+   at91_set_GPIO_periph(pdata[i].prog_b,0);
+   pdev = platform_device_alloc("xilinx-sscu", i);
+   if (!pdev)
+	{
+	printk(KERN_ERR "Platform device alloc failed - bailing out\n");
+	return 0;
+	}
+   pdev->dev.platform_data=&pdata[i];
+   err = platform_device_add(pdev);
+   if (err) break;
+  }
+  if (err) printk(KERN_INFO "Registration failed: %d\n",err);
+  return err;
+}
+
+Then a call
+charlene_register_xsscu(charlene_xsscu_pdata, ARRAY_SIZE(charlene_xsscu_pdata));
+in board_init will do the trick.
+Note the at91_set_GPIO_periph calls here. They ARE hardware-specific and they
+deatach muxed periphs from the pins and allow using them as plain IO.
+
+
+
+Using /dev/fpga interface
+=====================
+Using this interface is pretty simple. To upload a firmware just write in to
+/dev/fpga0 (1,2 whatever). Something like this:
+cat /path/to/bitstream.bin > /dev/fpga0
+This will issue a reset and upload the configuration to your fpga.
+If you had anything running on it - it will be stopped. Make sure to unload
+any kernel drivers for your homebrew hardware running in FPGA beforehand.
+If you would like to disable the fpga completely in runtime:
+echo "disable" > /dev/fpga0
+This will pull prog_b LOW, effectively stopping anything your FPGA was up to.
+And it will keep it that way until you upload another configuration.
+For information on fpga status:
+cat /dev/fpga0
+This should print you a pretty summary of what's going on.
+That's all. Simple, isn't it?
+
+Delay issues
+=====================
+Have a look at the DELAY macro defined in the code of the driver.
+At my 200Mhz ARM system this was not needed, but if you are running on
+some >1Ghz system, clock might go too fast, and you'll have to define DELAY
+to something like udelay(10);
+According to the datasheet, Spartan can handle compressed bitstreams at
+about 20Mhz max.
+I haven't run into this limit. Yet. If you do - update this document,
+please.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 48987785..9a2e9a7 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,6 +6,16 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config XSSCU
+        bool "Xilinx Slave Serial uploader driver"
+        default n
+        help
+         Say y if you have a Xilinx FPGA and want to bit-bang config data
+         in it, using the /dev/fpga interface in runtime.
+         (In other words - 'cp firmware.bin /dev/fpga')
+         NB: Do not forget to setup gpio pins in platform data.
+
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ce6d605..17a8aab 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_GEN_RTC)		+= genrtc.o
 obj-$(CONFIG_EFI_RTC)		+= efirtc.o
 obj-$(CONFIG_DS1302)		+= ds1302.o
 obj-$(CONFIG_XILINX_HWICAP)	+= xilinx_hwicap/
+obj-$(CONFIG_XSSCU)		+= xilinx-sscu.o
 ifeq ($(CONFIG_GENERIC_NVRAM),y)
   obj-$(CONFIG_NVRAM)	+= generic_nvram.o
 else
diff --git a/drivers/char/xilinx-sscu.c b/drivers/char/xilinx-sscu.c
new file mode 100644
index 0000000..cdeeb09
--- /dev/null
+++ b/drivers/char/xilinx-sscu.c
@@ -0,0 +1,341 @@
+/*
+ *  linux/drivers/char/xilinx-sscu.c
+ *
+ *  Copyright (C) 2011 Andrew 'Necromant' Andrianov <contact@necromant.ath.cx>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include <linux/types.h>
+#include <linux/cdev.h>
+
+#include <linux/xilinx-sscu.h>
+#include <linux/miscdevice.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+
+#define DRVNAME "xilinx-sscu"
+#define DEVNAME "fpga"
+#define DRVVER	"0.1"
+
+static int g_debug;
+module_param(g_debug, int, 0);	/* and these 2 lines */
+MODULE_PARM_DESC(g_debug, "Print lots of useless debug info.");
+
+/* This delay is system specific. In my case (200Mhz ARM) I can safely
+   define it to nothing to speed things up. But on a faster system you
+   may want to define it to something, e.g. udelay(100) if the clk will
+   get too fast and crew things up. I do not have a chance to check if
+   it's needed on a faster system, so I left it here to be 100% sure.
+   Have fun
+*/
+
+#define DELAY
+
+#define DBG(fmt, ...)	if (g_debug) \
+    printk(KERN_DEBUG "%s/%s: " fmt " \n", DRVNAME, __FUNCTION__, ##__VA_ARGS__)
+#define INF(fmt, ...)	printk(KERN_INFO "%s: " fmt " \n", DRVNAME, ##__VA_ARGS__)
+#define ERR(fmt, ...)	printk(KERN_ERR "%s: " fmt " \n", DRVNAME, ##__VA_ARGS__)
+
+static inline char *xsscu_state2char(struct xsscu_device_data *dev_data)
+{
+	switch (dev_data->state) {
+	case XSSCU_STATE_UPLOAD_DONE:
+	case XSSCU_STATE_IDLE:
+		if (gpio_get_value(dev_data->pdata->done))
+			return "Online";
+		else
+			return "Unprogrammed/Error";
+	case XSSCU_STATE_DISABLED:
+		return "Offline";
+	case XSSCU_STATE_PROG_ERROR:
+		return "Bitstream error";
+	default:
+		return "Bug!";
+	}
+}
+
+static int xsscu_open(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc;
+	struct xsscu_device_data *dev_data;
+	misc = file->private_data;
+	dev_data = misc->this_device->platform_data;
+	if (dev_data->open)
+		return -EBUSY;
+	dev_data->open++;
+	DBG("Device %s opened", dev_data->pdata->name);
+	sprintf(dev_data->msg_buffer,
+		"DEVICE:\t%s\nINIT_B:\t%d\nDONE:\t%d\nSTATE:\t%s\n",
+		dev_data->pdata->name,
+		gpio_get_value(dev_data->pdata->init_b),
+		gpio_get_value(dev_data->pdata->done),
+		xsscu_state2char(dev_data)
+	    );
+	dev_data->read_ptr = dev_data->msg_buffer;
+	return 0;
+}
+
+static int send_clocks(struct xsscu_data *p, int c)
+{
+
+	while (c--) {
+		gpio_direction_output(p->clk, 0);
+		DELAY;
+		gpio_direction_output(p->clk, 1);
+		DELAY;
+		if (1 == gpio_get_value(p->done))
+			return 0;
+	}
+	return 1;
+}
+
+static inline void xsscu_dbg_state(struct xsscu_data *p)
+{
+	DBG("INIT_B: %d | DONE: %d",
+	    gpio_get_value(p->init_b), gpio_get_value(p->done));
+}
+
+static int xsscu_release(struct inode *inode, struct file *file)
+{
+	struct miscdevice *misc;
+	struct xsscu_device_data *dev_data;
+	int err = 0;
+	misc = file->private_data;
+	dev_data = misc->this_device->platform_data;
+	dev_data->open--;
+	switch (dev_data->state) {
+	case XSSCU_STATE_UPLOADING:
+		err = send_clocks(dev_data->pdata, 10000);
+		dev_data->state = XSSCU_STATE_UPLOAD_DONE;
+		break;
+	case XSSCU_STATE_DISABLED:
+		err = 0;
+		break;
+	}
+
+	if (err) {
+		ERR("DONE not HIGH or other programming error");
+		dev_data->state = XSSCU_STATE_PROG_ERROR;
+	}
+	xsscu_dbg_state(dev_data->pdata);
+	DBG("Device closed");
+	/* We must still close the device, hence return ok */
+	return 0;
+}
+
+static ssize_t xsscu_read(struct file *filp, char *buffer,
+			  size_t length,
+			  loff_t *offset)
+{
+	struct miscdevice *misc;
+	struct xsscu_device_data *dev_data;
+	int bytes_read = 0;
+	misc = filp->private_data;
+	dev_data = misc->this_device->platform_data;
+
+	if (*dev_data->read_ptr == 0)
+		return 0;
+	while (length && *dev_data->read_ptr) {
+		put_user(*(dev_data->read_ptr++), buffer++);
+		length--;
+		bytes_read++;
+	}
+	return bytes_read;
+}
+
+static int xsscu_reset_fpga(struct xsscu_data *p)
+{
+	int i = 50;
+	DBG("Resetting FPGA...");
+	gpio_direction_output(p->prog_b, 0);
+	mdelay(1);
+	gpio_direction_output(p->prog_b, 1);
+	while (i--) {
+		xsscu_dbg_state(p);
+		if (gpio_get_value(p->init_b) == 1)
+			return 0;
+		mdelay(1);
+	}
+	ERR("FPGA reset failed");
+	return 1;
+}
+
+static ssize_t xsscu_write(struct file *filp,
+			   const char *buff, size_t len, loff_t * off)
+{
+	struct miscdevice *misc;
+	struct xsscu_device_data *dev_data;
+	int i;
+	int k;
+	i = 0;
+	misc = filp->private_data;
+	dev_data = misc->this_device->platform_data;
+
+	if ((*off == 0)) {
+		if (strncmp(buff, "disable", 7) == 0) {
+			DBG("Disabling FPGA");
+			gpio_direction_output(dev_data->pdata->prog_b, 0);
+			dev_data->state = XSSCU_STATE_DISABLED;
+			goto all_written;
+		} else if (xsscu_reset_fpga(dev_data->pdata) != 0)
+			return -EIO;
+		/*Wait a little bit, before starting to clock the fpga,
+		as the datasheet suggests */
+		mdelay(1);
+		gpio_direction_output(dev_data->pdata->clk, 0);
+		dev_data->state = XSSCU_STATE_UPLOADING;
+	}
+	/* bitbang data */
+	while (i < len) {
+		for (k = 7; k >= 0; k--) {
+			gpio_direction_output(dev_data->pdata->sout,
+					      (buff[i] & (1 << k)));
+			gpio_direction_output(dev_data->pdata->clk, 1);
+			DELAY;
+			gpio_direction_output(dev_data->pdata->clk, 0);
+			DELAY;
+		}
+		i++;
+	}
+all_written:
+	*off += len;
+	return len;
+}
+
+static const struct file_operations xsscu_fileops = {
+	.owner = THIS_MODULE,
+	.write = xsscu_write,
+	.read = xsscu_read,
+	.open = xsscu_open,
+	.release = xsscu_release,
+	.llseek = no_llseek,
+};
+
+static int xsscu_create_miscdevice(struct platform_device *p, int id)
+{
+	struct miscdevice *mdev;
+	struct xsscu_device_data *dev_data;
+	char *nm;
+	int err;
+	mdev = kzalloc(sizeof(struct miscdevice), GFP_KERNEL);
+	if (!mdev) {
+		ERR("Misc device allocation failed");
+		return -ENOMEM;
+	}
+	nm = kzalloc(64, GFP_KERNEL);
+	if (!nm) {
+		err = -ENOMEM;
+		goto freemisc;
+	}
+	dev_data = kzalloc(sizeof(struct xsscu_device_data), GFP_KERNEL);
+	if (!dev_data) {
+		err = -ENOMEM;
+		goto freenm;
+	}
+
+	snprintf(nm, 64, "fpga%d", id);
+	mdev->name = nm;
+	mdev->fops = &xsscu_fileops;
+	mdev->minor = MISC_DYNAMIC_MINOR;
+	err = misc_register(mdev);
+	if (!err) {
+		mdev->this_device->platform_data = dev_data;
+		dev_data->pdata = p->dev.platform_data;
+	}
+
+	return err;
+
+freenm:
+	kfree(nm);
+freemisc:
+	kfree(mdev);
+
+	return err;
+}
+
+static int xsscu_probe(struct platform_device *p)
+{
+	int err;
+	int id;
+	struct xsscu_data *pdata = p->dev.platform_data;
+	/* some id magic */
+	if (p->id == -1)
+		id = 0;
+	else
+		id = p->id;
+	DBG("Probing xsscu platform device with id %d", p->id);
+	if (!pdata) {
+		ERR("Missing platform_data, sorry dude");
+		return -ENOMEM;
+	}
+	/* claim gpio pins */
+	err = gpio_request(pdata->clk, "xilinx-sscu-clk") +
+	    gpio_request(pdata->done, "xilinx-sscu-done") +
+	    gpio_request(pdata->init_b, "xilinx-sscu-init_b") +
+	    gpio_request(pdata->prog_b, "xilinx-sscu-prog_b") +
+	    gpio_request(pdata->sout, "xilinx-sscu-sout");
+	if (err) {
+		ERR("Failed to claim required GPIOs, bailing out");
+		return err;
+	}
+
+	gpio_direction_input(pdata->init_b);
+	gpio_direction_input(pdata->done);
+
+	err = xsscu_create_miscdevice(p, id);
+	if (!err)
+		INF("FPGA Device %s registered as /dev/fpga%d", pdata->name,
+		    id);
+	return err;
+}
+
+static struct platform_driver xsscu_driver = {
+	.probe = xsscu_probe,
+	.driver = {
+		   .name = DRVNAME,
+		   .owner = THIS_MODULE,
+		   }
+};
+
+static int __init xsscu_init(void)
+{
+	INF("Xilinx Slave Serial Configuration Upload Driver " DRVVER);
+	return platform_driver_register(&xsscu_driver);
+}
+
+static void __exit xsscu_cleanup(void)
+{
+	/* Normally you would not like to unload this driver. */
+}
+
+module_init(xsscu_init);
+module_exit(xsscu_cleanup);
+
+MODULE_AUTHOR("Andrew 'Necromant' Andrianov <necromant@necromant.ath.cx>");
+MODULE_DESCRIPTION("Xilinx Slave Serial BitBang Uploader driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/xilinx-sscu.h b/include/linux/xilinx-sscu.h
new file mode 100644
index 0000000..bf56ba9
--- /dev/null
+++ b/include/linux/xilinx-sscu.h
@@ -0,0 +1,27 @@
+#ifndef _XILINX_SSCU
+#define _XILINX_SSCU
+struct xsscu_data {
+	char s *name;
+	unsigned int clk;
+	unsigned int sout;
+	unsigned int init_b;
+	unsigned int prog_b;
+	unsigned int done;
+};
+
+enum {
+	XSSCU_STATE_IDLE,
+	XSSCU_STATE_UPLOADING,
+	XSSCU_STATE_UPLOAD_DONE,
+	XSSCU_STATE_DISABLED,
+	XSSCU_STATE_PROG_ERROR,
+};
+
+struct xsscu_device_data {
+	struct xsscu_data *pdata;
+	int open;
+	int state;
+	char *read_ptr;
+	char msg_buffer[128];
+};
+#endif
