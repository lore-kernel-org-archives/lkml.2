Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0IWSZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:25:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:34744 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0IWSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:25:42 -0400
From: Anders Wallin <Anders.Wallin@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com
Subject: [PATCH 1/1] Adding support for STA2x11/Connext PCIexpress function 0xCC0C.
Date: Thu, 23 Sep 2010 20:25:32 +0200
Message-Id: <a2346cdf6e1020ce81c9f9a526e06a4b9dd10822.1285266234.git.anders.wallin@windriver.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <cover.1285266234.git.anders.wallin@windriver.com>
References: <cover.1285266234.git.anders.wallin@windriver.com>
In-Reply-To: <cover.1285266234.git.anders.wallin@windriver.com>
References: <cover.1285266234.git.anders.wallin@windriver.com>
X-OriginalArrivalTime: 23 Sep 2010 18:25:39.0525 (UTC) FILETIME=[B955EF50:01CB5B4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Wallin <anders.wallin@windriver.com>


Signed-off-by: Anders Wallin <anders.wallin@windriver.com>
---
 arch/x86/include/asm/gpio.h   |    2 +-
 drivers/gpio/Kconfig          |   14 +
 drivers/gpio/Makefile         |    1 +
 drivers/gpio/pl061_pci.c      |  860 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/pl061_pci.h      |   29 ++
 drivers/misc/Kconfig          |   23 ++
 drivers/misc/Makefile         |    3 +
 drivers/misc/sta2x11_apbreg.c |  177 +++++++++
 drivers/misc/sta2x11_apbreg.h |   39 ++
 drivers/misc/sta2x11_mux.c    |  265 +++++++++++++
 drivers/misc/sta2x11_mux.h    |   50 +++
 drivers/misc/sta2x11_sctl.c   |  189 +++++++++
 drivers/misc/sta2x11_sctl.h   |  143 +++++++
 13 files changed, 1794 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/pl061_pci.c
 create mode 100644 drivers/gpio/pl061_pci.h
 create mode 100644 drivers/misc/sta2x11_apbreg.c
 create mode 100644 drivers/misc/sta2x11_apbreg.h
 create mode 100644 drivers/misc/sta2x11_mux.c
 create mode 100644 drivers/misc/sta2x11_mux.h
 create mode 100644 drivers/misc/sta2x11_sctl.c
 create mode 100644 drivers/misc/sta2x11_sctl.h

diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 49dbfdf..9da6f01 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -43,7 +43,7 @@ static inline int gpio_cansleep(unsigned int gpio)
  */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
 static inline int irq_to_gpio(unsigned int irq)
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 510aa20..7afbabb 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -361,4 +361,18 @@ config GPIO_JANZ_TTL
 	  This driver provides support for driving the pins in output
 	  mode only. Input mode is not supported.
 
+config GPIO_PL061_PCI
+	bool "STA2x11/ConneXt PL061_PCI GPIO support"
+	depends on STA2X11_PCI_MUX
+	help
+	  Say yes here to support the STA2x11/ConneXt PL061_PCI GPIO device
+
+config GPIO_PL061_PCI_IRQ
+	bool "ConneXt PL061_PCI gpio_to_irq support"
+	depends on GPIO_PL061_PCI
+	help
+	  The gpiolib has a function called gpio_to_irq that has
+	  the requirement that the number returned should be usable by
+	  calling request_irq.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index fc6019d..0480109 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -8,6 +8,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
+obj-$(CONFIG_GPIO_PL061_PCI)	+= pl061_pci.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
diff --git a/drivers/gpio/pl061_pci.c b/drivers/gpio/pl061_pci.c
new file mode 100644
index 0000000..540a764
--- /dev/null
+++ b/drivers/gpio/pl061_pci.c
@@ -0,0 +1,860 @@
+/*
+ * linux/driver/gpio/pl061_pci.c, pl061 GPIO driver for ConneXt
+ *
+ * STMicroelectronics ConneXt (STA2X11/STA2X10) GPIO file
+ * derived from from linux/driver/gpio/pl061.c
+ *
+ * Copyright (c) 2009-2010 Wind River Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include "../misc/sta2x11_mux.h"
+#include "pl061_pci.h"
+
+/* all gpio registers */
+#define GPIO_DAT	0x00
+#define GPIO_DATS	0x04
+#define GPIO_DATC	0x08
+#define GPIO_PDIS	0x0c
+#define GPIO_DIR	0x10
+#define GPIO_DIRS	0x14
+#define GPIO_DIRC	0x18
+#define GPIO_AFSELA	0x20
+#define GPIO_RIMSC	0x40
+#define GPIO_FIMSC	0x44
+#define GPIO_IS		0x48
+#define GPIO_IC		0x4c
+#define GPIO_PERIPH_ID0	0xfe0
+#define GPIO_PERIPH_ID1	0xfe4
+#define GPIO_PERIPH_ID2	0xfe8
+#define GPIO_PERIPH_ID3	0xfec
+#define GPIO_PCELL_ID0	0xff0
+#define GPIO_PCELL_ID1	0xff4
+#define GPIO_PCELL_ID2	0xff8
+#define GPIO_PCELL_ID3	0xffc
+
+#define DRV_VERSION "1.0"
+
+#define CHIP_REGS_LENGTH	0x1000	/* registers length for each GPIO */
+#define GPIO_BLOCKS		4	/* instances of GPIO blocks */
+#define PINS_PER_CHIP		32	/* pins for each GPIO */
+
+#define PIN_NR	(PINS_PER_CHIP * GPIO_BLOCKS)	/* All pins */
+
+#define nr_to_mask(nr)	(1 << (nr % PINS_PER_CHIP))
+
+struct gpio_alternative {
+	int start;
+	int end;
+};
+
+#define STA2X11_NORTHVILLE
+#ifdef STA2X11_NORTHVILLE
+static struct gpio_alternative alt_cfg[] = {
+	{8, 15},		/* RGB Red   8 bit parallel */
+	{16, 23},		/* RGB Green 8 bit parallel */
+	{24, 31},		/* RGB Blue  8 bit parallel */
+	{32, 34},		/* RGB ctrl */
+	{35, 43},		/* ETH */
+	{44, 45},		/* CAN 2 */
+	{46, 47},		/* MLB */
+	{48, 51},		/* SPI 0 */
+	/* {52, 55 }, *//* SPI 1 */
+	/* {56, 58}, *//* SPI 2 */
+	{60, 61},		/* I2C 0 */
+	{62, 63},		/* I2C 1 */
+	{64, 65},		/* I2C 2 */
+	/* {66, 67}, *//* I2C 3 */
+	/* {68, 74}, *//* MSP 0 */
+	{75, 78},		/* MSP 1 */
+	/* {79, 82}, *//* MSP 2 */
+	{83, 86},		/* MSP 3 */
+	/*{87, 89}, *//* MSP 4 */
+	{91, 94},		/* MSP 5 */
+	/*{95, 100}, *//* SDIO 3 */
+	{105, 110},		/* SDIO 2 */
+	{115, 120},		/* SDIO 1 */
+	{125, 126},		/* rx/tx UART 2 */
+	{127, 127},		/* tx    UART 3 */
+	{0, 0}
+};
+#else
+static struct gpio_alternative alt_cfg[] = {
+	{8, 15},		/* RGB Red   8 bit parallel */
+	{16, 23},		/* RGB Green 8 bit parallel */
+	{24, 31},		/* RGB Blue  8 bit parallel */
+	{32, 34},		/* RGB ctrl */
+	{35, 43},		/* ETH */
+	{44, 45},		/* CAN 2 */
+	{46, 47},		/* MLB */
+	{48, 51},		/* SPI 0 */
+	{52, 55},		/* SPI 1 */
+	{56, 59},		/* SPI 2 */
+	{60, 61},		/* I2C 0 */
+	{62, 63},		/* I2C 1 */
+	{64, 65},		/* I2C 2 */
+	{66, 67},		/* I2C 3 */
+	{68, 74},		/* MSP 0 */
+	{75, 78},		/* MSP 1 */
+	{79, 82},		/* MSP 2 */
+	{83, 86},		/* MSP 3 */
+	{87, 90},		/* MSP 4 */
+	{91, 94},		/* MSP 5 */
+	{95, 100},		/* SDIO 3 */
+	{105, 110},		/* SDIO 2 */
+	{115, 120},		/* SDIO 1 */
+	{125, 126},		/* rx/tx UART 2 */
+	{127, 127},		/* tx    UART 3 */
+	{0, 0}
+};
+#endif
+
+static struct pl061_pci {
+	spinlock_t lock;
+	spinlock_t irq_lock;
+	/* base addr of each GPIO block */
+	void __iomem *reg_base[GPIO_BLOCKS];
+
+	unsigned irq_base;
+	unsigned int irq_type[PIN_NR];
+	char irq_name[PIN_NR][4];
+
+	unsigned int reserved[PIN_NR];
+
+	/** save data for PM */
+	u32 saved_dat[GPIO_BLOCKS];
+	u32 saved_dir[GPIO_BLOCKS];
+	u32 saved_fimsc[GPIO_BLOCKS];
+	u32 saved_rimsc[GPIO_BLOCKS];
+	u32 saved_afsela[GPIO_BLOCKS];
+	u32 saved_pdis[GPIO_BLOCKS];
+
+	u32 values[GPIO_BLOCKS];
+	unsigned gpio_base;
+
+	struct pci_dev *pdev;
+	struct gpio_chip gpio;
+} *gp;
+
+#ifdef CONFIG_DEBUG_FS
+static struct dentry *pl061_pci_debugfs_dir;
+static int pl061_pci_open(struct inode *inode, struct file *file);
+static ssize_t pl061_pci_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos);
+
+static const struct file_operations pl061_pci_operations = {
+	.owner = THIS_MODULE,
+	.open = pl061_pci_open,
+	.read = pl061_pci_read
+};
+
+static void pl061_pci_create_debugfile(char *debugfs_filename,
+				       void __iomem *reg_base)
+{
+	(void)debugfs_create_file(debugfs_filename, S_IFREG | S_IRUGO,
+				  pl061_pci_debugfs_dir, reg_base,
+				  &pl061_pci_operations);
+}
+
+#define BUFSIZE	1024
+static ssize_t pl061_pci_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	char *buf;
+	u32 len = 0;
+	ssize_t ret;
+	void __iomem *reg_base;
+
+	reg_base = (void __iomem *)file->private_data;
+	if (!reg_base)
+		return 0;
+
+	buf = kzalloc(BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return 0;
+
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DAT:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DAT));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DATC:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DATC));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DATS:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DATS));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_PDIS:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_PDIS));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DIR:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DIR));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DIRC:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DIRC));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_DIRS:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_DIRS));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_AFSELA:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_AFSELA));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_RIMSC:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_RIMSC));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_FIMSC:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_FIMSC));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_IS:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_IS));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len, "GPIO_IC:\t\t0x%08x\n",
+		     readl(reg_base + GPIO_IC));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len,
+		     "GPIO_PERIPH:\t\t%02x:%02x:%02x:%02x\n",
+		     readl(reg_base + GPIO_PERIPH_ID0),
+		     readl(reg_base + GPIO_PERIPH_ID1),
+		     readl(reg_base + GPIO_PERIPH_ID2),
+		     readl(reg_base + GPIO_PERIPH_ID3));
+	len +=
+	    snprintf(buf + len, BUFSIZE - len,
+		     "GPIO_PCELL:\t\t%02x:%02x:%02x:%02x\n",
+		     readl(reg_base + GPIO_PCELL_ID0),
+		     readl(reg_base + GPIO_PCELL_ID1),
+		     readl(reg_base + GPIO_PCELL_ID2),
+		     readl(reg_base + GPIO_PCELL_ID3));
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return ret;
+}
+
+static int pl061_pci_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static int __init pl061_pci_debugfs_init(void)
+{
+	/* /sys/kernel/debug/pl061_pci */
+
+	pl061_pci_debugfs_dir = debugfs_create_dir("pl061_pci", NULL);
+	if (!pl061_pci_debugfs_dir)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __exit pl061_pci_debugfs_exit(void)
+{
+	debugfs_remove_recursive(pl061_pci_debugfs_dir);
+
+	return 0;
+}
+#else
+#define pl061_pci_create_debugfile() {}
+#define pl061_pci_debugfs_init() {}
+#define pl061_pci_debugfs_exit() {}
+#endif /* DEBUG_FS */
+
+static int pl061_pci_read_reg(int reg, unsigned nr)
+{
+	u32 value;
+
+	if (nr >= gp->gpio.ngpio)
+		return -EINVAL;
+
+	value = readl(gp->reg_base[nr / PINS_PER_CHIP] + reg);
+
+	return !!(value & (nr_to_mask(nr)));
+}
+
+static int pl061_pci_set_reg(int reg, unsigned nr)
+{
+	unsigned long flags;
+	int tmp;
+
+	if (nr >= gp->gpio.ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&gp->irq_lock, flags);
+
+	tmp = readl(gp->reg_base[nr / PINS_PER_CHIP] + reg);
+	tmp = tmp | nr_to_mask(nr);
+	writel(tmp, gp->reg_base[nr / PINS_PER_CHIP] + reg);
+
+	spin_unlock_irqrestore(&gp->irq_lock, flags);
+	return tmp;
+}
+
+static int pl061_pci_clear_reg(int reg, unsigned nr)
+{
+	unsigned long flags;
+	int tmp;
+
+	if (nr >= gp->gpio.ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&gp->irq_lock, flags);
+
+	tmp = readl(gp->reg_base[nr / PINS_PER_CHIP] + reg);
+	tmp = tmp & ~(nr_to_mask(nr));
+	writel(tmp, gp->reg_base[nr / PINS_PER_CHIP] + reg);
+
+	spin_unlock_irqrestore(&gp->irq_lock, flags);
+	return tmp;
+}
+
+/**
+ * pl061_pci_read_pdis - Read the PL061 PDIS register for GPIO number
+ * @nr: The GPIO number
+ *
+ * Returns the value of the GPIO number PDIS status, or -EINVAL
+ */
+int pl061_pci_read_pdis(unsigned nr)
+{
+	return pl061_pci_read_reg(GPIO_PDIS, nr);
+}
+EXPORT_SYMBOL(pl061_pci_read_pdis);
+
+/**
+ * pl061_pci_read_afsela - Read the PL061 AFSELA register for GPIO number
+ * @nr: The GPIO number
+ *
+ * Returns the value of the GPIO number AFSELA status, or -EINVAL
+ */
+int pl061_pci_read_afsela(unsigned nr)
+{
+	return pl061_pci_read_reg(GPIO_AFSELA, nr);
+}
+EXPORT_SYMBOL(pl061_pci_read_afsela);
+
+/**
+ * pl061_pci_set_pdis - Set the GPIO number in the PDIS PL061 register.
+ * @nr: The GPIO number
+ *
+ * The setting of bits are atomic. Returns the value of the
+ * register after the bits has been set
+ * EINVAL: if gpio number to big
+ */
+int pl061_pci_set_pdis(unsigned nr)
+{
+	return pl061_pci_set_reg(GPIO_PDIS, nr);
+}
+EXPORT_SYMBOL(pl061_pci_set_pdis);
+
+/**
+ * pl061_pci_set_afsela - Set the GPIO number in the AFSELA PL061 register.
+ * @nr: The GPIO number
+ *
+ * The setting of bits are atomic. Returns the value of the
+ * register after the bits has been set
+ * EINVAL: if gpio number to big
+ * EBUSY: if gpio number already taken
+ */
+int pl061_pci_set_afsela(unsigned nr)
+{
+	if (gp->reserved[nr / PINS_PER_CHIP] & nr_to_mask(nr)) {
+		printk(KERN_ERR "%s: gpio(%i) already reserved\n",
+		       __func__, nr);
+		return -EBUSY;
+	}
+	gp->reserved[nr / PINS_PER_CHIP] |= nr_to_mask(nr);
+
+	return pl061_pci_set_reg(GPIO_AFSELA, nr);
+}
+EXPORT_SYMBOL(pl061_pci_set_afsela);
+
+/**
+ * pl061_pci_clear_pdis - Clear the GPIO number in the PDIS PL061 register.
+ * @nr: The GPIO number
+ *
+ * The clearing of bits are atomic. Returns the value of the
+ * register after the bits has been cleared
+ * EINVAL: if gpio number to big
+ */
+int pl061_pci_clear_pdis(unsigned nr)
+{
+	return pl061_pci_clear_reg(GPIO_PDIS, nr);
+}
+EXPORT_SYMBOL(pl061_pci_clear_pdis);
+
+/**
+ * pl061_pci_clear_afsela - Clear the GPIO number in the AFSELA PL061 register.
+ * @nr: The GPIO number
+ *
+ * The clearing of bits are atomic. Returns the value (or EINVAL) of the
+ * register after the bits has been cleared
+ * EINVAL: if gpio number to big
+ * EBUSY: if gpio number already taken
+ */
+int pl061_pci_clear_afsela(unsigned nr)
+{
+	if (!(gp->reserved[nr / PINS_PER_CHIP] & nr_to_mask(nr))) {
+		printk(KERN_ERR "%s: gpio(%i) is not reserved\n",
+		       __func__, nr);
+		return -EBUSY;
+	}
+	gp->reserved[nr / PINS_PER_CHIP] &= ~nr_to_mask(nr);
+	return pl061_pci_clear_reg(GPIO_AFSELA, nr);
+}
+EXPORT_SYMBOL(pl061_pci_clear_afsela);
+
+static int pl061_pci_request(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+
+	if (nr >= gpio->ngpio)
+		return -EINVAL;
+
+	if (nr_to_mask(nr) & pp->reserved[nr / PINS_PER_CHIP])
+		return -EBUSY;
+	return 0;
+}
+
+static int pl061_pci_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+
+	if (nr >= gpio->ngpio)
+		return -EINVAL;
+
+	writel(nr_to_mask(nr), pp->reg_base[nr / PINS_PER_CHIP] + GPIO_DIRC);
+
+	return 0;
+}
+
+static int pl061_pci_direction_output(struct gpio_chip *gpio,
+				      unsigned nr, int value)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+
+	if (nr >= gpio->ngpio)
+		return -EINVAL;
+
+	writel(nr_to_mask(nr), pp->reg_base[nr / PINS_PER_CHIP] + GPIO_DIRS);
+
+	if (value)
+		writel(nr_to_mask(nr),
+		       pp->reg_base[nr / PINS_PER_CHIP] + GPIO_DATS);
+	else
+		writel(nr_to_mask(nr),
+		       pp->reg_base[nr / PINS_PER_CHIP] + GPIO_DATC);
+	return 0;
+}
+
+static int pl061_pci_get_value(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+	u32 value;
+
+	if (nr >= gpio->ngpio)
+		return -EINVAL;
+
+	value = readl(pp->reg_base[nr / PINS_PER_CHIP] + GPIO_DAT);
+
+	return !!(value & (nr_to_mask(nr)));
+}
+
+static void pl061_pci_set_value(struct gpio_chip *gpio, unsigned nr, int value)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+	int offset;
+
+	if (nr >= gpio->ngpio)
+		return;
+	if (value)
+		offset = GPIO_DATS;
+	else
+		offset = GPIO_DATC;
+
+	writel(nr_to_mask(nr), pp->reg_base[nr / PINS_PER_CHIP] + offset);
+
+	return;
+}
+
+#ifdef CONFIG_GPIO_PL061_PCI_IRQ
+static int pl061_pci_to_irq(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
+	void *base;
+
+	if (nr >= gpio->ngpio)
+		return -EINVAL;
+	base = pp->reg_base[nr / PINS_PER_CHIP];
+
+	if (pp->irq_base == (unsigned)-1)
+		return -EINVAL;
+
+	return pp->irq_base + nr;
+}
+
+static void pl061_pci_irq_disable(unsigned irq)
+{
+	struct pl061_pci *pp = get_irq_chip_data(irq);
+	unsigned nr = irq - pp->irq_base;
+	unsigned long flags;
+	u32 gpio_irq;
+	void *base;
+
+	if (nr >= pp->gpio.ngpio)
+		return;
+	base = pp->reg_base[nr / PINS_PER_CHIP];
+
+	spin_lock_irqsave(&pp->irq_lock, flags);
+
+	if (pp->irq_type[nr] & IRQ_TYPE_EDGE_RISING) {
+		gpio_irq = readl(base + GPIO_RIMSC);
+		gpio_irq &= ~(nr_to_mask(nr));
+		writel(gpio_irq, base + GPIO_RIMSC);
+	}
+
+	if (pp->irq_type[nr] & IRQ_TYPE_EDGE_FALLING) {
+		gpio_irq = readl(base + GPIO_FIMSC);
+		gpio_irq &= ~(nr_to_mask(nr));
+		writel(gpio_irq, base + GPIO_FIMSC);
+	}
+
+	spin_unlock_irqrestore(&pp->irq_lock, flags);
+	return;
+}
+
+static void pl061_pci_irq_enable(unsigned irq)
+{
+	struct pl061_pci *pp = get_irq_chip_data(irq);
+	unsigned nr = irq - pp->irq_base;
+	unsigned long flags;
+	u32 gpio_irq;
+	void *base;
+
+	if (nr >= pp->gpio.ngpio)
+		return;
+	base = pp->reg_base[nr / PINS_PER_CHIP];
+
+	spin_lock_irqsave(&pp->irq_lock, flags);
+
+	/* first turn off both interrupt modes */
+	gpio_irq = readl(base + GPIO_RIMSC);
+	gpio_irq &= ~(nr_to_mask(nr));
+	writel(gpio_irq, base + GPIO_RIMSC);
+
+	gpio_irq = readl(base + GPIO_FIMSC);
+	gpio_irq &= ~(nr_to_mask(nr));
+	writel(gpio_irq, base + GPIO_FIMSC);
+
+	/* turn on what was requested. */
+	if (pp->irq_type[nr] & IRQ_TYPE_EDGE_RISING) {
+		gpio_irq = readl(base + GPIO_RIMSC);
+		gpio_irq |= nr_to_mask(nr);
+		writel(gpio_irq, base + GPIO_RIMSC);
+	}
+
+	if (pp->irq_type[nr] & IRQ_TYPE_EDGE_FALLING) {
+		gpio_irq = readl(base + GPIO_FIMSC);
+		gpio_irq |= nr_to_mask(nr);
+		writel(gpio_irq, base + GPIO_FIMSC);
+	}
+
+	spin_unlock_irqrestore(&pp->irq_lock, flags);
+	return;
+}
+
+static int pl061_pci_irq_type(unsigned irq, unsigned trigger)
+{
+	struct pl061_pci *pp = get_irq_chip_data(irq);
+	unsigned nr = irq - pp->irq_base;
+
+	if ((nr < 0) ||
+	    (nr >= pp->gpio.ngpio) ||
+	    (trigger != IRQ_TYPE_EDGE_RISING &&
+	     trigger != IRQ_TYPE_EDGE_FALLING && trigger != IRQ_TYPE_EDGE_BOTH))
+		return -EINVAL;
+
+	pp->irq_type[nr] = trigger;
+	pl061_pci_irq_enable(irq);
+
+	return 0;
+}
+
+static struct irq_chip pl061_pci_irqchip = {
+	.name = "GPIO",
+	.enable = pl061_pci_irq_enable,
+	.disable = pl061_pci_irq_disable,
+	.set_type = pl061_pci_irq_type,
+};
+#endif
+
+/** All GPIO pins share a hardware irq */
+static irqreturn_t pl061_pci_irq_handler(int irq, void *dev_id)
+{
+	struct pl061_pci *pp = (struct pl061_pci *)dev_id;
+	u32 gpio_is = 0;
+	int i, bit;
+	irqreturn_t ret = IRQ_NONE;
+
+	for (i = 0; i < GPIO_BLOCKS; i++) {
+		gpio_is = readl(pp->reg_base[i] + GPIO_IS);
+		if (gpio_is == 0)
+			continue;
+
+		for (bit = 0; bit < 32; bit++) {
+			if (gpio_is & (1 << bit)) {
+				writel(1 << bit, pp->reg_base[i] + GPIO_IC);
+
+#ifdef CONFIG_GPIO_PL061_PCI_IRQ
+				{
+					int irq;
+					irq = pl061_pci_to_irq(&pp->gpio,
+							       bit +
+							       i *
+							       PINS_PER_CHIP);
+					generic_handle_irq(irq);
+				}
+#endif
+				ret = IRQ_HANDLED;
+			}
+		}
+	}
+	return ret;
+}
+
+static void pl061_pci_setup(struct pl061_pci *pp)
+{
+	struct gpio_chip *chip = &(pp->gpio);
+
+	chip->request = pl061_pci_request;
+	chip->direction_input = pl061_pci_direction_input;
+	chip->direction_output = pl061_pci_direction_output;
+	chip->get = pl061_pci_get_value;
+	chip->set = pl061_pci_set_value;
+	chip->ngpio = PIN_NR;
+	chip->label = "GPIO";
+	chip->dev = &(pp->pdev->dev);
+	chip->owner = THIS_MODULE;
+	chip->can_sleep = 0;
+	chip->base = pp->gpio_base;
+#ifdef CONFIG_GPIO_PL061_PCI_IRQ
+	chip->to_irq = pl061_pci_to_irq;
+#endif
+
+	return;
+}
+
+static int pl061_pci_suspend(struct sta2x11_mux_driver *dev, pm_message_t state)
+{
+	struct pl061_pci *pp = dev->priv;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&pp->lock, flags);
+
+	for (i = 0; i < GPIO_BLOCKS; i++) {
+		pp->saved_dat[i] = readl(pp->reg_base[i] + GPIO_DAT);
+		pp->saved_dir[i] = readl(pp->reg_base[i] + GPIO_DIRS);
+		pp->saved_fimsc[i] = readl(pp->reg_base[i] + GPIO_FIMSC);
+		pp->saved_rimsc[i] = readl(pp->reg_base[i] + GPIO_RIMSC);
+		pp->saved_afsela[i] = readl(pp->reg_base[i] + GPIO_AFSELA);
+		pp->saved_pdis[i] = readl(pp->reg_base[i] + GPIO_PDIS);
+
+		/* Clear all interrupts */
+		writel(0xffffffff, pp->reg_base[i] + GPIO_IC);
+		/* Set all gpio's to input direction */
+		writel(0x0, pp->reg_base[i] + GPIO_DIR);
+	}
+
+	spin_unlock_irqrestore(&pp->lock, flags);
+
+	return 0;
+}
+
+static int pl061_pci_resume(struct sta2x11_mux_driver *dev)
+{
+	struct pl061_pci *pp = dev->priv;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&pp->lock, flags);
+
+	for (i = 0; i < GPIO_BLOCKS; i++) {
+		writel(pp->saved_pdis[i], pp->reg_base[i] + GPIO_PDIS);
+		writel(pp->saved_afsela[i], pp->reg_base[i] + GPIO_AFSELA);
+		writel(pp->saved_dir[i], pp->reg_base[i] + GPIO_DIRS);
+		writel(pp->saved_dat[i], pp->reg_base[i] + GPIO_DAT);
+		writel(pp->saved_fimsc[i], pp->reg_base[i] + GPIO_FIMSC);
+		writel(pp->saved_rimsc[i], pp->reg_base[i] + GPIO_RIMSC);
+	}
+
+	spin_unlock_irqrestore(&pp->lock, flags);
+
+	return 0;
+}
+
+static struct sta2x11_mux_driver pl061_driver = {
+	.suspend = pl061_pci_suspend,
+	.resume = pl061_pci_resume,
+};
+
+static int __init pl061_pci_init(void)
+{
+	struct pl061_pci *pp;
+	int err = 0;
+	int i = 0;
+	unsigned int irq;
+
+	printk(KERN_INFO "pl061_pci: Module version " DRV_VERSION "\n");
+	pp = kzalloc(sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	gp = pp;
+
+	err = sta2x11_mux_register(&pl061_driver);
+	if (err) {
+		printk(KERN_ERR
+		       "pl061_pci: could not register with sta2x11_mux %x %d\n",
+		       err, err);
+		goto err_freepp;
+	}
+
+	pp->pdev = pl061_driver.pdev;
+	pp->irq_base = NR_IRQS - PIN_NR;
+	pp->gpio_base = 0;
+
+	spin_lock_init(&(pp->lock));
+	spin_lock_init(&(pp->irq_lock));
+
+	pl061_driver.priv = pp;
+
+	/** init register base for each GPIO */
+	pp->reg_base[0] = pl061_driver.reg_base0;
+
+	for (i = 1; i < GPIO_BLOCKS; i++)
+		pp->reg_base[i] = pp->reg_base[i - 1] + CHIP_REGS_LENGTH;
+
+	pl061_pci_setup(pp);
+
+	/** disable all irqs */
+	for (i = 0; i < GPIO_BLOCKS; i++) {
+		writel(0, pp->reg_base[i] + GPIO_RIMSC);
+		writel(0, pp->reg_base[i] + GPIO_FIMSC);
+		writel(0xffffffff, pp->reg_base[i] + GPIO_IC);
+		writel(0, pp->reg_base[i] + GPIO_AFSELA);
+	}
+
+	irq = pl061_driver.pdev->irq;
+	if (irq < 0) {
+		err = -ENODEV;
+		goto err_freepp;
+	}
+
+	if (request_irq
+	    (irq, pl061_pci_irq_handler, IRQF_SHARED, "pl061_pci", pp)) {
+		printk(KERN_ERR "Failed to request interrupt for pl061_pci.\n");
+		goto err_freepp;
+	}
+#ifdef CONFIG_GPIO_PL061_PCI_IRQ
+	for (i = 0; i < GPIO_BLOCKS * PINS_PER_CHIP; i++) {
+		pl061_pci_direction_input(&pp->gpio, i);
+		pp->irq_type[i] = IRQ_TYPE_EDGE_FALLING;
+		sprintf(&pp->irq_name[i][0], "%d", i);
+		set_irq_chip_and_handler_name(i + pp->irq_base,
+					      &pl061_pci_irqchip,
+					      handle_simple_irq,
+					      &pp->irq_name[i][0]);
+		set_irq_chip_data(i + pp->irq_base, pp);
+	}
+#endif
+
+	/* grab the pins that is in alternative mode so nothing in the
+	 * system can use them
+	 */
+	for (i = 0; alt_cfg[i].start != 0 && alt_cfg[i].end != 0; i++) {
+		int start = alt_cfg[i].start;
+		int end = alt_cfg[i].end;
+		int x;
+		for (x = start; x <= end; x++) {
+			int tmp;
+			tmp = readl(pp->reg_base[x / PINS_PER_CHIP] +
+				    GPIO_AFSELA);
+			tmp |= nr_to_mask(x);
+			pp->reserved[x / PINS_PER_CHIP] |= nr_to_mask(x);
+			writel(tmp, pp->reg_base[x / PINS_PER_CHIP] +
+			       GPIO_AFSELA);
+		}
+	}
+
+	err = gpiochip_add(&pp->gpio);
+	if (err) {
+		printk(KERN_ERR "pl061_pci: Failed to register GPIOs\n");
+		goto err_freepp;
+	}
+
+	pl061_pci_debugfs_init();
+	for (i = 0; i < GPIO_BLOCKS; i++) {
+		char str[5];
+		sprintf(str, "%d", i);
+		pl061_pci_create_debugfile(str, pp->reg_base[i]);
+	}
+
+	return 0;
+
+err_freepp:
+	kfree(pp);
+	gp = NULL;
+	return err;
+}
+
+static void __exit pl061_pci_exit(void)
+{
+	struct pl061_pci *pp = gp;
+
+	/* init failed */
+	if (!gp)
+		return;
+
+	if (gpiochip_remove(&pp->gpio) != 0)
+		printk(KERN_WARNING "pl061_pci: GPIO is busy\n");
+
+	pl061_pci_debugfs_exit();
+
+	free_irq(gp->pdev->irq, pp);
+	kfree(pp);
+	sta2x11_mux_unregister(&pl061_driver);
+
+	return;
+}
+
+/* needs to be started after the sta2x11_mux driver */
+late_initcall(pl061_pci_init);
+module_exit(pl061_pci_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wind River");
+MODULE_DESCRIPTION("pl061 GPIO driver for sta2x11");
diff --git a/drivers/gpio/pl061_pci.h b/drivers/gpio/pl061_pci.h
new file mode 100644
index 0000000..5360900
--- /dev/null
+++ b/drivers/gpio/pl061_pci.h
@@ -0,0 +1,29 @@
+/*
+ * linux/driver/gpio/pl061_pci.h, pl061 GPIO driver for ConneXt
+ *
+ * STMicroelectronics ConneXt (STA2X11/STA2X10) GPIO file
+ * derived from from linux/driver/gpio/pl061.c
+ *
+ * Copyright (c) 2009-2010 Wind River Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+int pl061_pci_read_pdis(unsigned nr);
+int pl061_pci_read_afsela(unsigned nr);
+int pl061_pci_set_pdis(unsigned nr);
+int pl061_pci_set_afsela(unsigned nr);
+int pl061_pci_clear_pdis(unsigned nr);
+int pl061_pci_clear_afsela(unsigned nr);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..3c9f207 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -390,6 +390,29 @@ config BMP085
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config STA2X11_PCI_MUX
+	bool "STA2x11 PCI mux"
+	depends on PCI
+	help
+	  The STMicroelectronics ConneXt (STA2x11)
+	  chip has several unrelated functions in one PCI endpoint function.
+	  This driver is a resource handler for the different drivers.
+
+config STA2X11_PCI_SCTL
+	bool "STA2x11 System control"
+	depends on STA2X11_PCI_MUX
+	help
+	  The STMicroelectronics ConneXt (STA2x11) system control block.
+	  Many ConneXt driver need this and it will be auto selected.
+
+config STA2X11_PCI_APBREG
+	bool "STA2x11 AHB-APB Bridge"
+	depends on STA2X11_PCI_MUX
+	help
+	  The STMicroelectronics ConneXt (STA2x11) AHB-APB Bridge.
+	  CAN/MLB and SaRaC ConneXt driver need this and it will
+	  be auto selected.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 255a80d..0af12b1 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,3 +35,6 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
+obj-$(CONFIG_STA2X11_PCI_MUX)   += sta2x11_mux.o
+obj-$(CONFIG_STA2X11_PCI_SCTL)  += sta2x11_sctl.o
+obj-$(CONFIG_STA2X11_PCI_APBREG)+= sta2x11_apbreg.o
diff --git a/drivers/misc/sta2x11_apbreg.c b/drivers/misc/sta2x11_apbreg.c
new file mode 100644
index 0000000..92bee15
--- /dev/null
+++ b/drivers/misc/sta2x11_apbreg.c
@@ -0,0 +1,177 @@
+/*
+* Copyright (c) 2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*
+*/
+
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "sta2x11_mux.h"
+#include "sta2x11_apbreg.h"
+
+#define DRV_VERSION "1.0"
+
+static struct sta2x11_mux_driver sta2x11_apbreg = {
+	/* .suspend     = sta2x11_apbreg_suspend, */
+	/* .resume      = sta2x11_apbreg_resume, */
+};
+
+static DEFINE_SPINLOCK(my_lock);
+
+/**
+ * sta2x11_apbreg_write - Write a value to the APBREG register
+ * @reg: The APBREG register
+ * @value: The value to be written
+ */
+
+void sta2x11_apbreg_write(int reg, int value)
+{
+	writel(value, sta2x11_apbreg.reg_base1 + reg);
+}
+EXPORT_SYMBOL(sta2x11_apbreg_write);
+
+/**
+ * sta2x11_apbreg_read - Read the APBREG register
+ * @reg: The APBREG register
+ *
+ * Returns the value of the register after the bits has been
+ * cleared
+ */
+int sta2x11_apbreg_read(int reg)
+{
+	return readl(sta2x11_apbreg.reg_base1 + reg);
+}
+EXPORT_SYMBOL(sta2x11_apbreg_read);
+
+/**
+ * sta2x11_apbreg_set - Set the bits in the APBREG register.
+ * @reg: The APBREG register
+ * @value: The bits to be set
+ *
+ * The setting of bits are atomic. Returns the value of the
+ * register after the bits has been cleared
+ */
+int sta2x11_apbreg_set(int reg, int value)
+{
+	unsigned long flags;
+	int tmp;
+
+	spin_lock_irqsave(&my_lock, flags);
+
+	tmp = sta2x11_apbreg_read(reg);
+	tmp = tmp | value;
+	sta2x11_apbreg_write(reg, tmp);
+
+	spin_unlock_irqrestore(&my_lock, flags);
+	return tmp;
+}
+EXPORT_SYMBOL(sta2x11_apbreg_set);
+
+/**
+ * sta2x11_apbreg_clear - Clear the bits in the APBREG register.
+ * @reg: The APBREG register
+ * @value: The bits to be cleared
+ *
+ * The clearing of bits are atomic. Returns the value of the
+ * register after the bits has been cleared
+ */
+int sta2x11_apbreg_clear(int reg, int value)
+{
+	unsigned long flags;
+	int tmp;
+
+	spin_lock_irqsave(&my_lock, flags);
+
+	tmp = sta2x11_apbreg_read(reg);
+	tmp = tmp & ~value;
+	sta2x11_apbreg_write(reg, tmp);
+
+	spin_unlock_irqrestore(&my_lock, flags);
+	return tmp;
+}
+EXPORT_SYMBOL(sta2x11_apbreg_clear);
+
+#ifdef CONFIG_DEBUG_FS
+static int sta2x11_apbreg_show(struct seq_file *s, void *unused)
+{
+	seq_printf(s, "APBREG_BSR:\t0x%08x\n", sta2x11_apbreg_read(APBREG_BSR));
+	seq_printf(s, "APBREG_PAER:\t0x%08x\n",
+		   sta2x11_apbreg_read(APBREG_PAER));
+	seq_printf(s, "APBREG_PWAC:\t0x%08x\n",
+		   sta2x11_apbreg_read(APBREG_PWAC));
+	seq_printf(s, "APBREG_PRAC:\t0x%08x\n",
+		   sta2x11_apbreg_read(APBREG_PRAC));
+	seq_printf(s, "APBREG_PCG:\t0x%08x\n", sta2x11_apbreg_read(APBREG_PCG));
+	seq_printf(s, "APBREG_PUR:\t0x%08x\n", sta2x11_apbreg_read(APBREG_PUR));
+	seq_printf(s, "APBREG_EMU_PCG:\t0x%08x\n",
+		   sta2x11_apbreg_read(APBREG_EMU_PCG));
+	return 0;
+}
+
+static int sta2x11_apbreg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sta2x11_apbreg_show, NULL);
+}
+
+static const struct file_operations sta2x11_apbreg_operations = {
+	.open = sta2x11_apbreg_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init sta2x11_apbreg_debugfs_init(void)
+{
+	/* /sys/kernel/debug/sta2x11_apbreg */
+	(void)debugfs_create_file("sta2x11_apbreg", S_IFREG | S_IRUGO,
+				  NULL, NULL, &sta2x11_apbreg_operations);
+	return 0;
+}
+
+late_initcall(sta2x11_apbreg_debugfs_init);
+
+#endif /* DEBUG_FS */
+
+static int sta2x11_apbreg_init(void)
+{
+	printk(KERN_INFO "sta2x11 system control driver init\n");
+	sta2x11_mux_register(&sta2x11_apbreg);
+
+	return 0;
+}
+
+static void sta2x11_apbreg_exit(void)
+{
+	printk(KERN_INFO "sta2x11 system control driver exit\n");
+	sta2x11_mux_unregister(&sta2x11_apbreg);
+}
+
+/* needs to be started after the sta2x11_mux driver */
+late_initcall(sta2x11_apbreg_init);
+module_exit(sta2x11_apbreg_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wind River");
+MODULE_DESCRIPTION("AHB-APB Bridge for STA2X11");
diff --git a/drivers/misc/sta2x11_apbreg.h b/drivers/misc/sta2x11_apbreg.h
new file mode 100644
index 0000000..31f7dd3
--- /dev/null
+++ b/drivers/misc/sta2x11_apbreg.h
@@ -0,0 +1,39 @@
+/*
+* Copyright (c) 2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*/
+
+#ifndef __STA2X11_APBREG_H
+#define __STA2X11_APBREG_H
+
+#define APBREG_BSR	0x00	/* Bridge Status Register */
+#define APBREG_PAER	0x08	/* Peripherals Address Error Register */
+#define APBREG_PWAC	0x20	/* Peripheral Write Access Control register */
+#define APBREG_PRAC	0x40	/* Peripheral Read Access Control register */
+#define APBREG_PCG	0x60	/* Peripheral Clock Gating Register */
+#define APBREG_PUR	0x80	/* Peripheral Under Reset Register */
+#define APBREG_EMU_PCG	0xA0	/* Emulator Peripheral Clock Gating Register */
+
+#define APBREG_CAN      (1 << 1)
+#define APBREG_SARAC	(1 << 2)
+#define APBREG_MLB	(1 << 3)
+
+void sta2x11_apbreg_write(int reg, int value);
+int sta2x11_apbreg_read(int reg);
+int sta2x11_apbreg_set(int reg, int value);
+int sta2x11_apbreg_clear(int reg, int value);
+
+#endif /* __STA2X11_APBREG_H */
diff --git a/drivers/misc/sta2x11_mux.c b/drivers/misc/sta2x11_mux.c
new file mode 100644
index 0000000..7cec797
--- /dev/null
+++ b/drivers/misc/sta2x11_mux.c
@@ -0,0 +1,265 @@
+/*
+* Copyright (c) 2009-2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*
+* The STMicroelectronics ConneXt (STA2X11)
+* chip has several unrelated functions in one PCI endpoint functions.
+*
+* This driver simply registers the iomemregion and keeps track of the
+* use of this region.
+*
+*/
+
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+
+#include <asm/sta2x11.h>
+#include "sta2x11_mux.h"
+
+#define DRV_VERSION "1.0"
+
+#define GPIO_SIZE (0x1000)
+#define SCTL_SIZE (0x1000)
+#define SCR_SIZE  (0x1000)
+#define TIME_SIZE (0x1000)
+#define IOSPACE_SIZE (GPIO_SIZE*4 + SCTL_SIZE + SCR_SIZE + TIME_SIZE)
+
+static LIST_HEAD(user_list);
+static DEFINE_SPINLOCK(user_list_lock);
+
+static struct pci_dev *dev;
+static void __iomem *reg_base0;
+static void __iomem *reg_base1;
+
+/**
+ * sta2x11_mux_register - Register driver on the pci mux.
+ * @mux: Reference to the driver
+ *
+ * Gives access to pci device and register base address.
+ */
+int sta2x11_mux_register(struct sta2x11_mux_driver *mux)
+{
+
+	struct sta2x11_mux_driver *m;
+
+	if (!mux)
+		return -EINVAL;
+
+	BUG_ON(dev == NULL);
+
+	spin_lock(&user_list_lock);
+
+	/* already in list ? */
+	list_for_each_entry(m, &user_list, node) {
+		if (m == mux) {
+			spin_unlock(&user_list_lock);
+			return 0;
+		}
+	}
+
+	/*
+	 *  export the pci device to the caller
+	 *  use with care.
+	 */
+	mux->pdev = dev;
+	mux->reg_base0 = reg_base0;
+	mux->reg_base1 = reg_base1;
+
+	list_add_tail(&mux->node, &user_list);
+	spin_unlock(&user_list_lock);
+
+	/*
+	 * indicate that this module is in use
+	 * so nobody can do a rmmod on us
+	 */
+
+	return 0;
+}
+EXPORT_SYMBOL(sta2x11_mux_register);
+
+/**
+ * sta2x11_mux_unregister -  Unregister the driver
+ * @mux: Reference to the driver
+ */
+int sta2x11_mux_unregister(struct sta2x11_mux_driver *mux)
+{
+	if (!mux)
+		return -EINVAL;
+
+	BUG_ON(dev == NULL);
+
+	spin_lock(&user_list_lock);
+	list_del(&mux->node);
+	spin_unlock(&user_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(sta2x11_mux_unregister);
+
+static int sta2x11_pci_mux_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct sta2x11_mux_driver *mux;
+
+	spin_lock(&user_list_lock);
+
+	list_for_each_entry(mux, &user_list, node) {
+		if (mux->suspend)
+			mux->suspend(mux, state);
+	}
+	spin_unlock(&user_list_lock);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
+}
+
+static int sta2x11_pci_mux_resume(struct pci_dev *pdev)
+{
+	struct sta2x11_mux_driver *mux;
+	int err;
+
+	pci_set_power_state(pdev, 0);
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+	pci_restore_state(pdev);
+
+	spin_lock(&user_list_lock);
+
+	list_for_each_entry(mux, &user_list, node) {
+		if (mux->resume)
+			mux->resume(mux);
+	}
+	spin_unlock(&user_list_lock);
+
+	return 0;
+}
+
+static int sta2x11_pci_mux_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *pci_id)
+{
+	int err;
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR
+		       "sta2x11_pci_mux_probe: Can't enable device.\n");
+		return err;
+	}
+
+	if (pci_resource_len(pdev, 0) < IOSPACE_SIZE) {
+		err = -ENOSPC;
+		goto err_disable;
+	}
+
+	if (pci_resource_len(pdev, 0) < IOSPACE_SIZE) {
+		err = -ENOSPC;
+		goto err_disable;
+	}
+	if (!request_mem_region(pci_resource_start(pdev, 0),
+				IOSPACE_SIZE, "sta2x11_pci_mux")) {
+		printk(KERN_WARNING
+		       "sta2x11_pci_mux: Can't request iomem (0x%llx).\n",
+		       (unsigned long long)pci_resource_start(pdev, 0));
+		err = -EBUSY;
+		goto err_disable;
+	}
+
+	if (!pdev->msi_enabled) {
+		err = pci_enable_msi(pdev);
+		if (err) {
+			printk(KERN_INFO
+			       "sta2x11_pci_mux: Enable msi failed\n");
+		}
+	}
+
+	/* init register base */
+	reg_base0 = ioremap(pci_resource_start(pdev, 0), IOSPACE_SIZE);
+	if (!reg_base0) {
+		printk(KERN_ERR "sta2x11_pci_mux: ioremap(0) failed\n");
+		err = -EIO;
+		goto err_disable;
+	}
+	reg_base1 = ioremap(pci_resource_start(pdev, 1), IOSPACE_SIZE);
+	if (!reg_base1) {
+		printk(KERN_ERR "sta2x11_pci_mux: ioremap(1) failed\n");
+		err = -EIO;
+		goto err_disable;
+	}
+
+	dev = pdev;
+
+	return 0;
+
+err_disable:
+
+	pci_disable_device(pdev);
+	return err;
+}
+
+static void sta2x11_pci_mux_remove(struct pci_dev *pdev)
+{
+	dev = NULL;
+	iounmap(reg_base0);
+	iounmap(reg_base1);
+	pci_disable_msi(pdev);
+	release_mem_region(pci_resource_start(pdev, 0), IOSPACE_SIZE);
+	pci_disable_device(pdev);
+	return;
+}
+
+static struct pci_device_id sta2x11_pci_mux_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
+	{0,},
+};
+
+MODULE_DEVICE_TABLE(pci, sta2x11_pci_mux_tbl);
+
+static struct pci_driver sta2x11_pci_mux = {
+	.name = "sta2x11_pci_mux",
+	.id_table = sta2x11_pci_mux_tbl,
+	.probe = sta2x11_pci_mux_probe,
+	.remove = sta2x11_pci_mux_remove,
+	.suspend = sta2x11_pci_mux_suspend,
+	.resume = sta2x11_pci_mux_resume,
+};
+
+static int sta2x11_pci_mux_init(void)
+{
+	printk(KERN_INFO "sta2x11_mux driver init\n");
+	return pci_register_driver(&sta2x11_pci_mux);
+}
+
+module_init(sta2x11_pci_mux_init);
+
+static void sta2x11_pci_mux_exit(void)
+{
+	printk(KERN_INFO "sta2x11_mux driver exit\n");
+	pci_unregister_driver(&sta2x11_pci_mux);
+	return;
+}
+
+module_exit(sta2x11_pci_mux_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wind River");
+MODULE_DESCRIPTION("STA2x11 PCI multiplexer for GPIO and System Controller");
diff --git a/drivers/misc/sta2x11_mux.h b/drivers/misc/sta2x11_mux.h
new file mode 100644
index 0000000..765a396
--- /dev/null
+++ b/drivers/misc/sta2x11_mux.h
@@ -0,0 +1,50 @@
+/*
+* Copyright (c) 2009-2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*
+* The STMicroelectronics ConneXt (STA2X11)
+* chip has several unrelated functions in one PCI endpoint functions.
+*
+* This driver simply registers the iomemregion and keeps track of the
+* use of this region.
+*
+*/
+
+#ifndef __STA2X11_MUX_H
+#define __STA2X11_MUX_H
+
+/*
+ * @struct sta2x11_mux_driver
+ *
+ * Gives the driver access to pcie device and register base
+ *
+ */
+struct sta2x11_mux_driver {
+	struct list_head node;
+	struct pci_dev *pdev;    /* actual pci device */
+	void __iomem *reg_base0; /* virtual pointer0  */
+	void __iomem *reg_base1; /* virtual pointer1  */
+	void *priv;		 /* driver private    */
+
+	/* callbacks from pci_driver */
+	int (*suspend) (struct sta2x11_mux_driver *dev, pm_message_t state);
+	int (*resume) (struct sta2x11_mux_driver *dev);
+};
+
+int sta2x11_mux_register(struct sta2x11_mux_driver *mux);
+int sta2x11_mux_unregister(struct sta2x11_mux_driver *mux);
+
+#endif /* __STA2X11_MUX_H */
diff --git a/drivers/misc/sta2x11_sctl.c b/drivers/misc/sta2x11_sctl.c
new file mode 100644
index 0000000..6fbe274
--- /dev/null
+++ b/drivers/misc/sta2x11_sctl.c
@@ -0,0 +1,189 @@
+/*
+* Copyright (c) 2009-2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*
+*/
+
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/bitops.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "sta2x11_mux.h"
+#include "sta2x11_sctl.h"
+
+#define DRV_VERSION "1.0"
+
+static DEFINE_SPINLOCK(my_lock);
+
+static struct sta2x11_mux_driver sta2x11_sctl = {
+	/* .suspend     = sta2x11_sctl_suspend, */
+	/* .resume      = sta2x11_sctl_resume, */
+};
+
+/**
+ * sta2x11_sctl_write - Write a value to the SCTL register
+ * @reg: The SCTL register
+ * @value: The value to be written
+ */
+
+void sta2x11_sctl_write(int reg, int value)
+{
+	writel(value, sta2x11_sctl.reg_base0 + SCTL_BASE + reg);
+}
+EXPORT_SYMBOL(sta2x11_sctl_write);
+
+/**
+ * sta2x11_sctl_read - Read the SCTL register
+ * @reg: The SCTL register
+ *
+ * Returns the value of the register after the bits has been
+ * cleared
+ */
+int sta2x11_sctl_read(int reg)
+{
+	return readl(sta2x11_sctl.reg_base0 + SCTL_BASE + reg);
+}
+EXPORT_SYMBOL(sta2x11_sctl_read);
+
+/**
+ * sta2x11_sctl_set - Set the bits in the SCTL register.
+ * @reg: The SCTL register
+ * @value: The bits to be set
+ *
+ * The setting of bits are atomic. Returns the value of the
+ * register after the bits has been cleared
+ */
+int sta2x11_sctl_set(int reg, int value)
+{
+	unsigned long flags;
+	int tmp;
+
+	spin_lock_irqsave(&my_lock, flags);
+
+	tmp = sta2x11_sctl_read(reg);
+	tmp = tmp | value;
+	sta2x11_sctl_write(reg, tmp);
+
+	spin_unlock_irqrestore(&my_lock, flags);
+	return tmp;
+}
+EXPORT_SYMBOL(sta2x11_sctl_set);
+
+/**
+ * sta2x11_sctl_clear - Clear the bits in the SCTL register.
+ * @reg: The SCTL register
+ * @value: The bits to be cleared
+ *
+ * The clearing of bits are atomic. Returns the value of the
+ * register after the bits has been cleared
+ */
+int sta2x11_sctl_clear(int reg, int value)
+{
+	unsigned long flags;
+	int tmp;
+
+	spin_lock_irqsave(&my_lock, flags);
+
+	tmp = sta2x11_sctl_read(reg);
+	tmp = tmp & ~value;
+	sta2x11_sctl_write(reg, tmp);
+
+	spin_unlock_irqrestore(&my_lock, flags);
+	return tmp;
+}
+EXPORT_SYMBOL(sta2x11_sctl_clear);
+
+#ifdef CONFIG_DEBUG_FS
+static int sta2x11_sctl_show(struct seq_file *s, void *unused)
+{
+	seq_printf(s, "SCCTL:\t\t0x%08x\n", sta2x11_sctl_read(SCCTL));
+	seq_printf(s, "ARMCFG:\t\t0x%08x\n", sta2x11_sctl_read(ARMCFG));
+	seq_printf(s, "SCPLLCTL:\t0x%08x\n", sta2x11_sctl_read(SCPLLCTL));
+	seq_printf(s, "SCPLLFCTRL:\t0x%08x\n", sta2x11_sctl_read(SCPLLFCTRL));
+	seq_printf(s, "SCRESFRACT:\t0x%08x\n", sta2x11_sctl_read(SCRESFRACT));
+	seq_printf(s, "SCRESCTRL1:\t0x%08x\n", sta2x11_sctl_read(SCRESCTRL1));
+	seq_printf(s, "SCRESXTRL2:\t0x%08x\n", sta2x11_sctl_read(SCRESXTRL2));
+	seq_printf(s, "SCPEREN0:\t0x%08x\n", sta2x11_sctl_read(SCPEREN0));
+	seq_printf(s, "SCPEREN1:\t0x%08x\n", sta2x11_sctl_read(SCPEREN1));
+	seq_printf(s, "SCPEREN2:\t0x%08x\n", sta2x11_sctl_read(SCPEREN2));
+	seq_printf(s, "SCGRST:\t\t0x%08x\n", sta2x11_sctl_read(SCGRST));
+	seq_printf(s, "SCPCIPMCR1:\t0x%08x\n", sta2x11_sctl_read(SCPCIPMCR1));
+	seq_printf(s, "SCPCIPMCR2:\t0x%08x\n", sta2x11_sctl_read(SCPCIPMCR2));
+	seq_printf(s, "SCPCIPMSR1:\t0x%08x\n", sta2x11_sctl_read(SCPCIPMSR1));
+	seq_printf(s, "SCPCIPMSR2:\t0x%08x\n", sta2x11_sctl_read(SCPCIPMSR2));
+	seq_printf(s, "SCPCIPMSR3:\t0x%08x\n", sta2x11_sctl_read(SCPCIPMSR3));
+	seq_printf(s, "SCINTREN:\t0x%08x\n", sta2x11_sctl_read(SCINTREN));
+	seq_printf(s, "SCRISR:\t\t0x%08x\n", sta2x11_sctl_read(SCRISR));
+	seq_printf(s, "SCCLKSTAT0:\t0x%08x\n", sta2x11_sctl_read(SCCLKSTAT0));
+	seq_printf(s, "SCCLKSTAT1:\t0x%08x\n", sta2x11_sctl_read(SCCLKSTAT1));
+	seq_printf(s, "SCCLKSTAT2:\t0x%08x\n", sta2x11_sctl_read(SCCLKSTAT2));
+	seq_printf(s, "SCRSTSTA:\t0x%08x\n", sta2x11_sctl_read(SCRSTSTA));
+
+	return 0;
+}
+
+static int sta2x11_sctl_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sta2x11_sctl_show, NULL);
+}
+
+static const struct file_operations sta2x11_sctl_operations = {
+	.open = sta2x11_sctl_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init sta2x11_sctl_debugfs_init(void)
+{
+	/* /sys/kernel/debug/sta2x11_sctl */
+	(void)debugfs_create_file("sta2x11_sctl", S_IFREG | S_IRUGO,
+				  NULL, NULL, &sta2x11_sctl_operations);
+	return 0;
+}
+
+late_initcall(sta2x11_sctl_debugfs_init);
+
+#endif /* DEBUG_FS */
+
+static int sta2x11_sctl_init(void)
+{
+	printk(KERN_INFO "sta2x11 system control driver init\n");
+	sta2x11_mux_register(&sta2x11_sctl);
+
+	return 0;
+}
+
+static void sta2x11_sctl_exit(void)
+{
+	printk(KERN_INFO "sta2x11 system control driver exit\n");
+	sta2x11_mux_unregister(&sta2x11_sctl);
+}
+
+/* needs to be started after the sta2x11_mux driver */
+late_initcall(sta2x11_sctl_init);
+module_exit(sta2x11_sctl_exit);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wind River");
+MODULE_DESCRIPTION("System control for STA2X11");
diff --git a/drivers/misc/sta2x11_sctl.h b/drivers/misc/sta2x11_sctl.h
new file mode 100644
index 0000000..9ee860b
--- /dev/null
+++ b/drivers/misc/sta2x11_sctl.h
@@ -0,0 +1,143 @@
+/*
+* Copyright (c) 2009-2010 Wind River Systems, Inc.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License version 2 as
+* published by the Free Software Foundation.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+* See the GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+*
+*/
+
+#ifndef __STA2X11_SCTL_H
+#define __STA2X11_SCTL_H
+
+#define GPIO_SIZE (0x1000)
+#define SCTL_SIZE (0x1000)
+#define SCR_SIZE  (0x1000)
+#define TIME_SIZE (0x1000)
+#define IOSPACE_SIZE (GPIO_SIZE*4 + SCTL_SIZE + SCR_SIZE + TIME_SIZE)
+
+#define SCTL_BASE (GPIO_SIZE*4)
+
+#define SCCTL		0x0	/* System controller control register */
+#define ARMCFG		0x4	/* ARM configuration register */
+#define SCPLLCTL	0x8	/* PLL control status register */
+#define SCPLLFCTRL	0xc	/* PLL frequency control register */
+#define SCRESFRACT	0x10	/* PLL fractional input register */
+#define SCRESCTRL1	0x14	/* Peripheral reset control 1 */
+#define SCRESXTRL2	0x18	/* Peripheral reset control 2 */
+#define SCPEREN0	0x1c	/* Peripheral clock enable register 0 */
+#define SCPEREN1	0x20	/* Peripheral clock enable register 1 */
+#define SCPEREN2	0x24	/* Peripheral clock enable register 2 */
+#define SCGRST		0x28	/* Peripheral global reset */
+#define SCPCIPMCR1	0x30	/* PCI power management control 1 */
+#define SCPCIPMCR2	0x34	/* PCI power management control 2 */
+#define SCPCIPMSR1	0x38	/* PCI power management status 1 */
+#define SCPCIPMSR2	0x3c	/* PCI power management status 2 */
+#define SCPCIPMSR3	0x40	/* PCI power management status 3 */
+#define SCINTREN	0x44	/* Interrupt enable */
+#define SCRISR		0x48	/* RAW interrupt status */
+#define SCCLKSTAT0	0x4c	/* Peripheral clocks status 0 */
+#define SCCLKSTAT1	0x50	/* Peripheral clocks status 1 */
+#define SCCLKSTAT2	0x54	/* Peripheral clocks status 2 */
+#define SCRSTSTA	0x58	/* Reset status register */
+
+#define SCRESCTRL1_USB_PHY_POR	(1 << 0)
+#define SCRESCTRL1_USB_OTG	(1 << 1)
+#define SCRESCTRL1_USB_HRST	(1 << 2)
+#define SCRESCTRL1_USB_PHY_HOST	(1 << 3)
+#define SCRESCTRL1_SATAII	(1 << 4)
+#define SCRESCTRL1_VIP		(1 << 5)
+#define SCRESCTRL1_PER_MMC0	(1 << 6)
+#define SCRESCTRL1_PER_MMC1	(1 << 7)
+#define SCRESCTRL1_PER_GPIO0	(1 << 8)
+#define SCRESCTRL1_PER_GPIO1	(1 << 9)
+#define SCRESCTRL1_PER_GPIO2	(1 << 10)
+#define SCRESCTRL1_PER_GPIO3	(1 << 11)
+#define SCRESCTRL1_PER_MTU0	(1 << 12)
+#define SCRESCTRL1_KER_SPI0	(1 << 13)
+#define SCRESCTRL1_KER_SPI1	(1 << 14)
+#define SCRESCTRL1_KER_SPI2	(1 << 15)
+#define SCRESCTRL1_KER_MCI0	(1 << 16)
+#define SCRESCTRL1_KER_MCI1	(1 << 17)
+#define SCRESCTRL1_PRE_HSI2C0	(1 << 18)
+#define SCRESCTRL1_PER_HSI2C1	(1 << 19)
+#define SCRESCTRL1_PER_HSI2C2	(1 << 20)
+#define SCRESCTRL1_PER_HSI2C3	(1 << 21)
+#define SCRESCTRL1_PER_MSP0     (1 << 22)
+#define SCRESCTRL1_PER_MSP1     (1 << 23)
+#define SCRESCTRL1_PER_MSP2     (1 << 24)
+#define SCRESCTRL1_PER_MSP3     (1 << 25)
+#define SCRESCTRL1_PER_MSP4     (1 << 26)
+#define SCRESCTRL1_PER_MSP5     (1 << 27)
+#define SCRESCTRL1_PER_MMC      (1 << 28)
+#define SCRESCTRL1_KER_MSP0     (1 << 29)
+#define SCRESCTRL1_KER_MSP1     (1 << 30)
+#define SCRESCTRL1_KER_MSP2     (1 << 31)
+
+#define SCPEREN0_UART0		(1 << 0)
+#define SCPEREN0_UART1		(1 << 1)
+#define SCPEREN0_UART2		(1 << 2)
+#define SCPEREN0_UART3		(1 << 3)
+#define SCPEREN0_MSP0		(1 << 4)
+#define SCPEREN0_MSP1		(1 << 5)
+#define SCPEREN0_MSP2		(1 << 6)
+#define SCPEREN0_MSP3		(1 << 7)
+#define SCPEREN0_MSP4		(1 << 8)
+#define SCPEREN0_MSP5		(1 << 9)
+#define SCPEREN0_SPI0		(1 << 10)
+#define SCPEREN0_SPI1		(1 << 11)
+#define SCPEREN0_SPI2		(1 << 12)
+#define SCPEREN0_I2C0		(1 << 13)
+#define SCPEREN0_I2C1		(1 << 14)
+#define SCPEREN0_I2C2		(1 << 15)
+#define SCPEREN0_I2C3		(1 << 16)
+#define SCPEREN0_SVDO_LVDS	(1 << 17)
+#define SCPEREN0_USB_HOST	(1 << 18)
+#define SCPEREN0_USB_OTG	(1 << 19)
+#define SCPEREN0_MCI0		(1 << 20)
+#define SCPEREN0_MCI1		(1 << 21)
+#define SCPEREN0_MCI2		(1 << 22)
+#define SCPEREN0_MCI3		(1 << 23)
+#define SCPEREN0_SATA		(1 << 24)
+#define SCPEREN0_ETHERNET	(1 << 25)
+#define SCPEREN0_VIC		(1 << 26)
+#define SCPEREN0_DMA_AUDIO	(1 << 27)
+#define SCPEREN0_DMA_SOC	(1 << 28)
+#define SCPEREN0_RAM		(1 << 29)
+#define SCPEREN0_VIP		(1 << 30)
+#define SCPEREN0_ARM		(1 << 31)
+
+#define SCPEREN1_UART0		(1 << 0)
+#define SCPEREN1_UART1		(1 << 1)
+#define SCPEREN1_UART2		(1 << 2)
+#define SCPEREN1_UART3		(1 << 3)
+#define SCPEREN1_MSP0		(1 << 4)
+#define SCPEREN1_MSP1		(1 << 5)
+#define SCPEREN1_MSP2		(1 << 6)
+#define SCPEREN1_MSP3		(1 << 7)
+#define SCPEREN1_MSP4		(1 << 8)
+#define SCPEREN1_MSP5		(1 << 9)
+#define SCPEREN1_SPI0		(1 << 10)
+#define SCPEREN1_SPI1		(1 << 11)
+#define SCPEREN1_SPI2		(1 << 12)
+#define SCPEREN1_I2C0		(1 << 13)
+#define SCPEREN1_I2C1		(1 << 14)
+#define SCPEREN1_I2C2		(1 << 15)
+#define SCPEREN1_I2C3		(1 << 16)
+#define SCPEREN1_USB_PHY	(1 << 17)
+
+void sta2x11_sctl_write(int reg, int value);
+int sta2x11_sctl_read(int reg);
+int sta2x11_sctl_set(int reg, int value);
+int sta2x11_sctl_clear(int reg, int value);
+
+#endif /* __STA2X11_SCTL_H */
-- 
1.7.0.5

