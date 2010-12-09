Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab0LIU5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:57:43 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49813 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab0LIU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:57:41 -0500
Date: Thu, 9 Dec 2010 12:57:37 -0800
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org, Ben Gardner <bgardner@wabtec.com>
Subject: [PATCH] cs5535: deprecate older cs5535_gpio driver
Message-ID: <20101209125737.065e91fd@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The newer drivers/gpio/cs5535-gpio.c replaces
drivers/misc/cs5535_gpio.c.  The new driver has been in the tree
for a little while, and has received some testing; it's time to mark
the old one as deprecated.  I'm thinking removal around 2.6.40 would
be good, provided we're not missing critical functionality in the
newer driver.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 Documentation/feature-removal-schedule.txt |   14 ++
 drivers/char/Kconfig                       |    9 -
 drivers/char/Makefile                      |    1 -
 drivers/char/cs5535_gpio.c                 |  259 ----------------------------
 drivers/staging/Kconfig                    |    2 +
 drivers/staging/Makefile                   |    1 +
 drivers/staging/cs5535_gpio/Kconfig        |   11 ++
 drivers/staging/cs5535_gpio/Makefile       |    1 +
 drivers/staging/cs5535_gpio/TODO           |    6 +
 drivers/staging/cs5535_gpio/cs5535_gpio.c  |  259 ++++++++++++++++++++++++++++
 10 files changed, 294 insertions(+), 269 deletions(-)
 delete mode 100644 drivers/char/cs5535_gpio.c
 create mode 100644 drivers/staging/cs5535_gpio/Kconfig
 create mode 100644 drivers/staging/cs5535_gpio/Makefile
 create mode 100644 drivers/staging/cs5535_gpio/TODO
 create mode 100644 drivers/staging/cs5535_gpio/cs5535_gpio.c

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 6c2f55e..5092646 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -191,6 +191,20 @@ Why:	/proc/<pid>/oom_adj allows userspace to influence the oom killer's
 
 ---------------------------
 
+What:	CS5535/CS5536 obsolete GPIO driver
+When:	June 2011
+Files:	drivers/staging/cs5535_gpio/*
+Check:	drivers/staging/cs5535_gpio/cs5535_gpio.c
+Why:	A newer driver replaces this; it is drivers/gpio/cs5535-gpio.c, and
+	integrates with the Linux GPIO subsystem.  The old driver has been
+	moved to staging, and will be removed altogether around 2.6.40.
+	Please test the new driver, and ensure that the functionality you
+	need and any bugfixes from the old driver are available in the new
+	one.
+Who:	Andres Salomon <dilinger@queued.net>
+
+--------------------------
+
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..72d5235 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1038,15 +1038,6 @@ config NSC_GPIO
 	  pc8736x_gpio drivers.  If those drivers are built as
 	  modules, this one will be too, named nsc_gpio
 
-config CS5535_GPIO
-	tristate "AMD CS5535/CS5536 GPIO (Geode Companion Device)"
-	depends on X86_32
-	help
-	  Give userspace access to the GPIO pins on the AMD CS5535 and
-	  CS5536 Geode companion devices.
-
-	  If compiled as a module, it will be called cs5535_gpio.
-
 config RAW_DRIVER
 	tristate "RAW driver (/dev/raw/rawN)"
 	depends on BLOCK
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index ba53ec9..d5132e3 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -81,7 +81,6 @@ obj-$(CONFIG_NWFLASH)		+= nwflash.o
 obj-$(CONFIG_SCx200_GPIO)	+= scx200_gpio.o
 obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gpio.o
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
-obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
deleted file mode 100644
index 0cf1e5f..0000000
--- a/drivers/char/cs5535_gpio.c
+++ /dev/null
@@ -1,259 +0,0 @@
-/*
- * AMD CS5535/CS5536 GPIO driver.
- * Allows a user space process to play with the GPIO pins.
- *
- * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/cdev.h>
-#include <linux/ioport.h>
-#include <linux/pci.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-
-#define NAME			"cs5535_gpio"
-
-MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
-MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO Pin Driver");
-MODULE_LICENSE("GPL");
-
-static int major;
-module_param(major, int, 0);
-MODULE_PARM_DESC(major, "Major device number");
-
-static ulong mask;
-module_param(mask, ulong, 0);
-MODULE_PARM_DESC(mask, "GPIO channel mask");
-
-#define MSR_LBAR_GPIO		0x5140000C
-
-static u32 gpio_base;
-
-static struct pci_device_id divil_pci[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
-	{ } /* NULL entry */
-};
-MODULE_DEVICE_TABLE(pci, divil_pci);
-
-static struct cdev cs5535_gpio_cdev;
-
-/* reserve 32 entries even though some aren't usable */
-#define CS5535_GPIO_COUNT	32
-
-/* IO block size */
-#define CS5535_GPIO_SIZE	256
-
-struct gpio_regmap {
-	u32	rd_offset;
-	u32	wr_offset;
-	char	on;
-	char	off;
-};
-static struct gpio_regmap rm[] =
-{
-	{ 0x30, 0x00, '1', '0' },	/* GPIOx_READ_BACK / GPIOx_OUT_VAL */
-	{ 0x20, 0x20, 'I', 'i' },	/* GPIOx_IN_EN */
-	{ 0x04, 0x04, 'O', 'o' },	/* GPIOx_OUT_EN */
-	{ 0x08, 0x08, 't', 'T' },	/* GPIOx_OUT_OD_EN */
-	{ 0x18, 0x18, 'P', 'p' },	/* GPIOx_OUT_PU_EN */
-	{ 0x1c, 0x1c, 'D', 'd' },	/* GPIOx_OUT_PD_EN */
-};
-
-
-/**
- * Gets the register offset for the GPIO bank.
- * Low (0-15) starts at 0x00, high (16-31) starts at 0x80
- */
-static inline u32 cs5535_lowhigh_base(int reg)
-{
-	return (reg & 0x10) << 3;
-}
-
-static ssize_t cs5535_gpio_write(struct file *file, const char __user *data,
-				 size_t len, loff_t *ppos)
-{
-	u32	m = iminor(file->f_path.dentry->d_inode);
-	int	i, j;
-	u32	base = gpio_base + cs5535_lowhigh_base(m);
-	u32	m0, m1;
-	char	c;
-
-	/**
-	 * Creates the mask for atomic bit programming.
-	 * The high 16 bits and the low 16 bits are used to set the mask.
-	 * For example, GPIO 15 maps to 31,15: 0,1 => On; 1,0=> Off
-	 */
-	m1 = 1 << (m & 0x0F);
-	m0 = m1 << 16;
-
-	for (i = 0; i < len; ++i) {
-		if (get_user(c, data+i))
-			return -EFAULT;
-
-		for (j = 0; j < ARRAY_SIZE(rm); j++) {
-			if (c == rm[j].on) {
-				outl(m1, base + rm[j].wr_offset);
-				/* If enabling output, turn off AUX 1 and AUX 2 */
-				if (c == 'O') {
-					outl(m0, base + 0x10);
-					outl(m0, base + 0x14);
-				}
-				break;
-			} else if (c == rm[j].off) {
-				outl(m0, base + rm[j].wr_offset);
-				break;
-			}
-		}
-	}
-	*ppos = 0;
-	return len;
-}
-
-static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
-				size_t len, loff_t *ppos)
-{
-	u32	m = iminor(file->f_path.dentry->d_inode);
-	u32	base = gpio_base + cs5535_lowhigh_base(m);
-	int	rd_bit = 1 << (m & 0x0f);
-	int	i;
-	char	ch;
-	ssize_t	count = 0;
-
-	if (*ppos >= ARRAY_SIZE(rm))
-		return 0;
-
-	for (i = *ppos; (i < (*ppos + len)) && (i < ARRAY_SIZE(rm)); i++) {
-		ch = (inl(base + rm[i].rd_offset) & rd_bit) ?
-		     rm[i].on : rm[i].off;
-
-		if (put_user(ch, buf+count))
-			return -EFAULT;
-
-		count++;
-	}
-
-	/* add a line-feed if there is room */
-	if ((i == ARRAY_SIZE(rm)) && (count < len)) {
-		put_user('\n', buf + count);
-		count++;
-	}
-
-	*ppos += count;
-	return count;
-}
-
-static int cs5535_gpio_open(struct inode *inode, struct file *file)
-{
-	u32 m = iminor(inode);
-
-	/* the mask says which pins are usable by this driver */
-	if ((mask & (1 << m)) == 0)
-		return -EINVAL;
-
-	return nonseekable_open(inode, file);
-}
-
-static const struct file_operations cs5535_gpio_fops = {
-	.owner	= THIS_MODULE,
-	.write	= cs5535_gpio_write,
-	.read	= cs5535_gpio_read,
-	.open	= cs5535_gpio_open,
-	.llseek = no_llseek,
-};
-
-static int __init cs5535_gpio_init(void)
-{
-	dev_t	dev_id;
-	u32	low, hi;
-	int	retval;
-
-	if (pci_dev_present(divil_pci) == 0) {
-		printk(KERN_WARNING NAME ": DIVIL not found\n");
-		return -ENODEV;
-	}
-
-	/* Grab the GPIO I/O range */
-	rdmsr(MSR_LBAR_GPIO, low, hi);
-
-	/* Check the mask and whether GPIO is enabled (sanity check) */
-	if (hi != 0x0000f001) {
-		printk(KERN_WARNING NAME ": GPIO not enabled\n");
-		return -ENODEV;
-	}
-
-	/* Mask off the IO base address */
-	gpio_base = low & 0x0000ff00;
-
-	/**
-	 * Some GPIO pins
-	 *  31-29,23 : reserved (always mask out)
-	 *  28       : Power Button
-	 *  26       : PME#
-	 *  22-16    : LPC
-	 *  14,15    : SMBus
-	 *  9,8      : UART1
-	 *  7        : PCI INTB
-	 *  3,4      : UART2/DDC
-	 *  2        : IDE_IRQ0
-	 *  0        : PCI INTA
-	 *
-	 * If a mask was not specified, be conservative and only allow:
-	 *  1,2,5,6,10-13,24,25,27
-	 */
-	if (mask != 0)
-		mask &= 0x1f7fffff;
-	else
-		mask = 0x0b003c66;
-
-	if (!request_region(gpio_base, CS5535_GPIO_SIZE, NAME)) {
-		printk(KERN_ERR NAME ": can't allocate I/O for GPIO\n");
-		return -ENODEV;
-	}
-
-	if (major) {
-		dev_id = MKDEV(major, 0);
-		retval = register_chrdev_region(dev_id, CS5535_GPIO_COUNT,
-						NAME);
-	} else {
-		retval = alloc_chrdev_region(&dev_id, 0, CS5535_GPIO_COUNT,
-					     NAME);
-		major = MAJOR(dev_id);
-	}
-
-	if (retval) {
-		release_region(gpio_base, CS5535_GPIO_SIZE);
-		return -1;
-	}
-
-	printk(KERN_DEBUG NAME ": base=%#x mask=%#lx major=%d\n",
-	       gpio_base, mask, major);
-
-	cdev_init(&cs5535_gpio_cdev, &cs5535_gpio_fops);
-	cdev_add(&cs5535_gpio_cdev, dev_id, CS5535_GPIO_COUNT);
-
-	return 0;
-}
-
-static void __exit cs5535_gpio_cleanup(void)
-{
-	dev_t dev_id = MKDEV(major, 0);
-
-	cdev_del(&cs5535_gpio_cdev);
-	unregister_chrdev_region(dev_id, CS5535_GPIO_COUNT);
-	release_region(gpio_base, CS5535_GPIO_SIZE);
-}
-
-module_init(cs5535_gpio_init);
-module_exit(cs5535_gpio_cleanup);
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 5eafdf4..60eca89 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -121,6 +121,8 @@ source "drivers/staging/memrar/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
+source "drivers/staging/cs5535_gpio/Kconfig"
+
 source "drivers/staging/zram/Kconfig"
 
 source "drivers/staging/wlags49_h2/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index a97a955..c7e6e68 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_HYPERV)		+= hv/
 obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
 obj-$(CONFIG_IIO)		+= iio/
+obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio/
 obj-$(CONFIG_ZRAM)		+= zram/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
diff --git a/drivers/staging/cs5535_gpio/Kconfig b/drivers/staging/cs5535_gpio/Kconfig
new file mode 100644
index 0000000..a1b3a8d
--- /dev/null
+++ b/drivers/staging/cs5535_gpio/Kconfig
@@ -0,0 +1,11 @@
+config CS5535_GPIO
+	tristate "AMD CS5535/CS5536 GPIO (Geode Companion Device)"
+	depends on X86_32
+	help
+	  Note: this driver is DEPRECATED.  Please use the cs5535-gpio module
+	  in the GPIO section instead (CONFIG_GPIO_CS5535).
+
+	  Give userspace access to the GPIO pins on the AMD CS5535 and
+	  CS5536 Geode companion devices.
+
+	  If compiled as a module, it will be called cs5535_gpio.
diff --git a/drivers/staging/cs5535_gpio/Makefile b/drivers/staging/cs5535_gpio/Makefile
new file mode 100644
index 0000000..d67c4b8
--- /dev/null
+++ b/drivers/staging/cs5535_gpio/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
diff --git a/drivers/staging/cs5535_gpio/TODO b/drivers/staging/cs5535_gpio/TODO
new file mode 100644
index 0000000..98d1cd1
--- /dev/null
+++ b/drivers/staging/cs5535_gpio/TODO
@@ -0,0 +1,6 @@
+This is an obsolete driver for some the CS5535 and CS5536 southbridge GPIOs.
+It has been replaced by a driver that makes use of the Linux GPIO subsystem.
+Please switch to that driver, and let dilinger@queued.net know if there's
+anything missing from the new driver.
+
+This driver is scheduled for removal in 2.6.40.
diff --git a/drivers/staging/cs5535_gpio/cs5535_gpio.c b/drivers/staging/cs5535_gpio/cs5535_gpio.c
new file mode 100644
index 0000000..0cf1e5f
--- /dev/null
+++ b/drivers/staging/cs5535_gpio/cs5535_gpio.c
@@ -0,0 +1,259 @@
+/*
+ * AMD CS5535/CS5536 GPIO driver.
+ * Allows a user space process to play with the GPIO pins.
+ *
+ * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/cdev.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+
+#include <asm/uaccess.h>
+#include <asm/io.h>
+
+
+#define NAME			"cs5535_gpio"
+
+MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
+MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO Pin Driver");
+MODULE_LICENSE("GPL");
+
+static int major;
+module_param(major, int, 0);
+MODULE_PARM_DESC(major, "Major device number");
+
+static ulong mask;
+module_param(mask, ulong, 0);
+MODULE_PARM_DESC(mask, "GPIO channel mask");
+
+#define MSR_LBAR_GPIO		0x5140000C
+
+static u32 gpio_base;
+
+static struct pci_device_id divil_pci[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
+	{ } /* NULL entry */
+};
+MODULE_DEVICE_TABLE(pci, divil_pci);
+
+static struct cdev cs5535_gpio_cdev;
+
+/* reserve 32 entries even though some aren't usable */
+#define CS5535_GPIO_COUNT	32
+
+/* IO block size */
+#define CS5535_GPIO_SIZE	256
+
+struct gpio_regmap {
+	u32	rd_offset;
+	u32	wr_offset;
+	char	on;
+	char	off;
+};
+static struct gpio_regmap rm[] =
+{
+	{ 0x30, 0x00, '1', '0' },	/* GPIOx_READ_BACK / GPIOx_OUT_VAL */
+	{ 0x20, 0x20, 'I', 'i' },	/* GPIOx_IN_EN */
+	{ 0x04, 0x04, 'O', 'o' },	/* GPIOx_OUT_EN */
+	{ 0x08, 0x08, 't', 'T' },	/* GPIOx_OUT_OD_EN */
+	{ 0x18, 0x18, 'P', 'p' },	/* GPIOx_OUT_PU_EN */
+	{ 0x1c, 0x1c, 'D', 'd' },	/* GPIOx_OUT_PD_EN */
+};
+
+
+/**
+ * Gets the register offset for the GPIO bank.
+ * Low (0-15) starts at 0x00, high (16-31) starts at 0x80
+ */
+static inline u32 cs5535_lowhigh_base(int reg)
+{
+	return (reg & 0x10) << 3;
+}
+
+static ssize_t cs5535_gpio_write(struct file *file, const char __user *data,
+				 size_t len, loff_t *ppos)
+{
+	u32	m = iminor(file->f_path.dentry->d_inode);
+	int	i, j;
+	u32	base = gpio_base + cs5535_lowhigh_base(m);
+	u32	m0, m1;
+	char	c;
+
+	/**
+	 * Creates the mask for atomic bit programming.
+	 * The high 16 bits and the low 16 bits are used to set the mask.
+	 * For example, GPIO 15 maps to 31,15: 0,1 => On; 1,0=> Off
+	 */
+	m1 = 1 << (m & 0x0F);
+	m0 = m1 << 16;
+
+	for (i = 0; i < len; ++i) {
+		if (get_user(c, data+i))
+			return -EFAULT;
+
+		for (j = 0; j < ARRAY_SIZE(rm); j++) {
+			if (c == rm[j].on) {
+				outl(m1, base + rm[j].wr_offset);
+				/* If enabling output, turn off AUX 1 and AUX 2 */
+				if (c == 'O') {
+					outl(m0, base + 0x10);
+					outl(m0, base + 0x14);
+				}
+				break;
+			} else if (c == rm[j].off) {
+				outl(m0, base + rm[j].wr_offset);
+				break;
+			}
+		}
+	}
+	*ppos = 0;
+	return len;
+}
+
+static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
+				size_t len, loff_t *ppos)
+{
+	u32	m = iminor(file->f_path.dentry->d_inode);
+	u32	base = gpio_base + cs5535_lowhigh_base(m);
+	int	rd_bit = 1 << (m & 0x0f);
+	int	i;
+	char	ch;
+	ssize_t	count = 0;
+
+	if (*ppos >= ARRAY_SIZE(rm))
+		return 0;
+
+	for (i = *ppos; (i < (*ppos + len)) && (i < ARRAY_SIZE(rm)); i++) {
+		ch = (inl(base + rm[i].rd_offset) & rd_bit) ?
+		     rm[i].on : rm[i].off;
+
+		if (put_user(ch, buf+count))
+			return -EFAULT;
+
+		count++;
+	}
+
+	/* add a line-feed if there is room */
+	if ((i == ARRAY_SIZE(rm)) && (count < len)) {
+		put_user('\n', buf + count);
+		count++;
+	}
+
+	*ppos += count;
+	return count;
+}
+
+static int cs5535_gpio_open(struct inode *inode, struct file *file)
+{
+	u32 m = iminor(inode);
+
+	/* the mask says which pins are usable by this driver */
+	if ((mask & (1 << m)) == 0)
+		return -EINVAL;
+
+	return nonseekable_open(inode, file);
+}
+
+static const struct file_operations cs5535_gpio_fops = {
+	.owner	= THIS_MODULE,
+	.write	= cs5535_gpio_write,
+	.read	= cs5535_gpio_read,
+	.open	= cs5535_gpio_open,
+	.llseek = no_llseek,
+};
+
+static int __init cs5535_gpio_init(void)
+{
+	dev_t	dev_id;
+	u32	low, hi;
+	int	retval;
+
+	if (pci_dev_present(divil_pci) == 0) {
+		printk(KERN_WARNING NAME ": DIVIL not found\n");
+		return -ENODEV;
+	}
+
+	/* Grab the GPIO I/O range */
+	rdmsr(MSR_LBAR_GPIO, low, hi);
+
+	/* Check the mask and whether GPIO is enabled (sanity check) */
+	if (hi != 0x0000f001) {
+		printk(KERN_WARNING NAME ": GPIO not enabled\n");
+		return -ENODEV;
+	}
+
+	/* Mask off the IO base address */
+	gpio_base = low & 0x0000ff00;
+
+	/**
+	 * Some GPIO pins
+	 *  31-29,23 : reserved (always mask out)
+	 *  28       : Power Button
+	 *  26       : PME#
+	 *  22-16    : LPC
+	 *  14,15    : SMBus
+	 *  9,8      : UART1
+	 *  7        : PCI INTB
+	 *  3,4      : UART2/DDC
+	 *  2        : IDE_IRQ0
+	 *  0        : PCI INTA
+	 *
+	 * If a mask was not specified, be conservative and only allow:
+	 *  1,2,5,6,10-13,24,25,27
+	 */
+	if (mask != 0)
+		mask &= 0x1f7fffff;
+	else
+		mask = 0x0b003c66;
+
+	if (!request_region(gpio_base, CS5535_GPIO_SIZE, NAME)) {
+		printk(KERN_ERR NAME ": can't allocate I/O for GPIO\n");
+		return -ENODEV;
+	}
+
+	if (major) {
+		dev_id = MKDEV(major, 0);
+		retval = register_chrdev_region(dev_id, CS5535_GPIO_COUNT,
+						NAME);
+	} else {
+		retval = alloc_chrdev_region(&dev_id, 0, CS5535_GPIO_COUNT,
+					     NAME);
+		major = MAJOR(dev_id);
+	}
+
+	if (retval) {
+		release_region(gpio_base, CS5535_GPIO_SIZE);
+		return -1;
+	}
+
+	printk(KERN_DEBUG NAME ": base=%#x mask=%#lx major=%d\n",
+	       gpio_base, mask, major);
+
+	cdev_init(&cs5535_gpio_cdev, &cs5535_gpio_fops);
+	cdev_add(&cs5535_gpio_cdev, dev_id, CS5535_GPIO_COUNT);
+
+	return 0;
+}
+
+static void __exit cs5535_gpio_cleanup(void)
+{
+	dev_t dev_id = MKDEV(major, 0);
+
+	cdev_del(&cs5535_gpio_cdev);
+	unregister_chrdev_region(dev_id, CS5535_GPIO_COUNT);
+	release_region(gpio_base, CS5535_GPIO_SIZE);
+}
+
+module_init(cs5535_gpio_init);
+module_exit(cs5535_gpio_cleanup);
-- 
1.7.2.3

