Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab1CBWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:14:38 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41704 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab1CBWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:13:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77649851"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Qualcomm PM8921 MFD 2/6] mfd: pm8xxx: Add irq support
Date: Wed,  2 Mar 2011 14:13:17 -0800
Message-Id: <1299104001-5240-3-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Add support for the irq controller in Qualcomm 8xxx pmic. The 8xxx
interrupt controller provides control for gpio and mpp configured as
interrupts in addition to other subdevice interrupts. The interrupt
controller also provides a way to read the real time status of an
interrupt. This real time status is the only way one can get the
input values of gpio and mpp lines.

Change-Id: Ibb23878cd382af9a750d62ab49482f5dc72e3714
Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 drivers/mfd/Kconfig             |   10 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/pm8921-core.c       |   70 ++++-
 drivers/mfd/pm8xxx-irq.c        |  599 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pm8921.h      |    6 +-
 include/linux/mfd/pm8xxx/core.h |    9 +
 include/linux/mfd/pm8xxx/irq.h  |   62 ++++
 7 files changed, 748 insertions(+), 9 deletions(-)
 create mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 include/linux/mfd/pm8xxx/irq.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0a1bc22..45fcc8a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -647,6 +647,16 @@ config MFD_PM8921_CORE
 	  Say M here if you want to include support for PM8921 chip as a module.
 	  This will build a module called "pm8921-core.ko".
 
+config MFD_PM8XXX_IRQ
+	bool "Support for Qualcomm PM8xxx IRQ features"
+	depends on MFD_PM8XXX
+	default y if MFD_PM8XXX
+	help
+	  This is the IRQ driver for Qualcomm PM 8xxx PMIC chips.
+
+	  This is required to use certain other PM 8xxx features, such as GPIO
+	  and MPP.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ec158da..5fc9315 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -84,3 +84,4 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
+obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 46ab2fc..2102e8b 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -19,12 +19,14 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/pm8921.h>
 #include <linux/mfd/pm8xxx/core.h>
+#include <linux/mfd/pm8xxx/irq.h>
 
 #define REG_HWREV		0x002  /* PMIC4 revision */
 #define REG_HWREV_2		0x0E8  /* PMIC4 revision 2 */
 
 struct pm8921 {
-	struct device *dev;
+	struct device			*dev;
+	struct device			*irq_dev;
 };
 
 static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
@@ -61,26 +63,65 @@ static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
 	return msm_ssbi_write(pmic->dev->parent, addr, buf, cnt);
 }
 
+static int pm8921_read_irq_stat(const struct device *dev, int irq)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return pm8xxx_get_irq_stat(pmic->irq_dev, irq);
+}
+
 static struct pm8xxx_drvdata pm8921_drvdata = {
-	.pmic_readb	= pm8921_readb,
-	.pmic_writeb	= pm8921_writeb,
-	.pmic_read_buf	= pm8921_read_buf,
-	.pmic_write_buf = pm8921_write_buf,
+	.pmic_readb		= pm8921_readb,
+	.pmic_writeb		= pm8921_writeb,
+	.pmic_read_buf		= pm8921_read_buf,
+	.pmic_write_buf		= pm8921_write_buf,
+	.pmic_read_irq_stat	= pm8921_read_irq_stat,
+};
+
+static struct __devinitdata mfd_cell irq_cell = {
+	.name	= PM8XXX_IRQ_DEV_NAME,
+	.id	= -1,
 };
 
 static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
 					   *pdata,
-					   struct pm8921 *pmic)
+					   struct pm8921 *pmic,
+					   u32 rev)
 {
+	int ret = 0;
+	int irq_base = 0;
+
+	if (pdata->irq_pdata) {
+		pdata->irq_pdata->irq_cdata.nirqs = NR_PM8921_IRQS;
+		pdata->irq_pdata->irq_cdata.rev = rev;
+		irq_cell.platform_data = pdata->irq_pdata;
+		irq_cell.data_size = sizeof(struct pm8xxx_irq_platform_data);
+		irq_base = pdata->irq_pdata->irq_base;
+		ret = mfd_add_devices(pmic->dev, 0, &irq_cell, 1,
+					NULL, 0);
+		if (ret < 0) {
+			pr_err("Failed to add irq_subdevice ret=%d\n", ret);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
+static int __devinit match_irq_dev(struct device *dev, void *data)
+{
+	return !strncmp(PM8XXX_IRQ_DEV_NAME, dev_name(dev),
+		PM8XXX_IRQ_DEV_NAME_LEN);
+}
+
 static int __devinit pm8921_probe(struct platform_device *pdev)
 {
 	const struct pm8921_platform_data *pdata = pdev->dev.platform_data;
 	struct pm8921 *pmic;
 	int rc;
 	u8 val;
+	u32 rev;
 
 	if (!pdata) {
 		pr_err("missing platform data\n");
@@ -99,7 +140,8 @@ static int __devinit pm8921_probe(struct platform_device *pdev)
 		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
 		goto err_read_rev;
 	}
-	pr_info("PMIC revision:   %02X\n", val);
+	pr_info("PMIC revision 1: %02X\n", val);
+	rev = val;
 
 	/* Read PMIC chip revision 2 */
 	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
@@ -109,20 +151,32 @@ static int __devinit pm8921_probe(struct platform_device *pdev)
 		goto err_read_rev;
 	}
 	pr_info("PMIC revision 2: %02X\n", val);
+	rev |= val << BITS_PER_BYTE;
 
 	pmic->dev = &pdev->dev;
 	pm8921_drvdata.pm_chip_data = pmic;
 	platform_set_drvdata(pdev, &pm8921_drvdata);
 
-	rc = pm8921_add_subdevices(pdata, pmic);
+	rc = pm8921_add_subdevices(pdata, pmic, rev);
 	if (rc) {
 		pr_err("Cannot add subdevices rc=%d\n", rc);
 		goto err;
 	}
 
+	/*
+	 * Locate the irq device in the mfd subdevices and save a reference
+	 * to it. This is becuase on pm8xxx gpio status is read through the
+	 * interrupt blocks
+	 */
+	pmic->irq_dev = device_find_child(pmic->dev, NULL,
+				match_irq_dev);
+	/* gpio might not work if no irq device is found */
+	WARN_ON(pmic->irq_dev == NULL);
+
 	return 0;
 
 err:
+	mfd_remove_devices(pmic->dev);
 	platform_set_drvdata(pdev, NULL);
 err_read_rev:
 	kfree(pmic);
diff --git a/drivers/mfd/pm8xxx-irq.c b/drivers/mfd/pm8xxx-irq.c
new file mode 100644
index 0000000..b555787
--- /dev/null
+++ b/drivers/mfd/pm8xxx-irq.c
@@ -0,0 +1,599 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/mfd/pm8xxx/core.h>
+#include <linux/mfd/pm8xxx/irq.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/ratelimit.h>
+
+/* PMIC8xxx IRQ */
+
+#define	SSBI_REG_ADDR_IRQ_BASE		0x1BB
+
+#define	SSBI_REG_ADDR_IRQ_ROOT		(SSBI_REG_ADDR_IRQ_BASE + 0)
+#define	SSBI_REG_ADDR_IRQ_M_STATUS1	(SSBI_REG_ADDR_IRQ_BASE + 1)
+#define	SSBI_REG_ADDR_IRQ_M_STATUS2	(SSBI_REG_ADDR_IRQ_BASE + 2)
+#define	SSBI_REG_ADDR_IRQ_M_STATUS3	(SSBI_REG_ADDR_IRQ_BASE + 3)
+#define	SSBI_REG_ADDR_IRQ_M_STATUS4	(SSBI_REG_ADDR_IRQ_BASE + 4)
+#define	SSBI_REG_ADDR_IRQ_BLK_SEL	(SSBI_REG_ADDR_IRQ_BASE + 5)
+#define	SSBI_REG_ADDR_IRQ_IT_STATUS	(SSBI_REG_ADDR_IRQ_BASE + 6)
+#define	SSBI_REG_ADDR_IRQ_CONFIG	(SSBI_REG_ADDR_IRQ_BASE + 7)
+#define	SSBI_REG_ADDR_IRQ_RT_STATUS	(SSBI_REG_ADDR_IRQ_BASE + 8)
+
+#define	PM_IRQF_LVL_SEL		0x01	/* level select */
+#define	PM_IRQF_MASK_FE		0x02	/* mask falling edge */
+#define	PM_IRQF_MASK_RE		0x04	/* mask rising edge */
+#define	PM_IRQF_CLR			0x08	/* clear interrupt */
+#define	PM_IRQF_BITS_MASK		0x70
+#define	PM_IRQF_BITS_SHIFT		4
+#define	PM_IRQF_WRITE		0x80
+
+#define	PM_IRQF_MASK_ALL		(PM_IRQF_MASK_FE | \
+					PM_IRQF_MASK_RE)
+#define PM_IRQF_W_C_M		(PM_IRQF_WRITE |	\
+					PM_IRQF_CLR |	\
+					PM_IRQF_MASK_ALL)
+
+struct pm_irq_chip {
+	struct list_head	link;
+	struct device		*dev;
+	spinlock_t		pm_irq_lock;
+	u8			*irqs_allowed;
+	u16			*irqs_to_handle;
+	u8			*config;
+	unsigned long		*wake_enable;
+	unsigned int		devirq;
+	unsigned int		count_wakeable;
+	unsigned int		irq_base;
+	unsigned int		num_irqs;
+	unsigned int		num_blocks;
+	unsigned int		num_masters;
+};
+
+static LIST_HEAD(pm_irq_chips);
+
+/* Helper Functions */
+static DEFINE_RATELIMIT_STATE(pm8xxx_irq_ratelimit, 60 * HZ, 10);
+
+static inline int pm8xxx_can_print(void)
+{
+	return __ratelimit(&pm8xxx_irq_ratelimit);
+}
+
+static int
+pm8xxx_read_root(const struct pm_irq_chip *chip, u8 *rp)
+{
+	return pm8xxx_readb(chip->dev->parent, SSBI_REG_ADDR_IRQ_ROOT, rp);
+}
+
+static int
+pm8xxx_read_master(const struct pm_irq_chip *chip, u8 m, u8 *bp)
+{
+	return pm8xxx_readb(chip->dev->parent,
+			SSBI_REG_ADDR_IRQ_M_STATUS1 + m, bp);
+}
+
+static int
+pm8xxx_read_block(const struct pm_irq_chip *chip, u8 bp, u8 *ip)
+{
+	int	rc;
+
+	rc = pm8xxx_writeb(chip->dev->parent,
+				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	if (rc) {
+		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
+		goto bail_out;
+	}
+
+	rc = pm8xxx_readb(chip->dev->parent,
+			SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
+	if (rc)
+		pr_err("Failed Reading Status rc=%d\n", rc);
+bail_out:
+	return rc;
+}
+
+static int
+pm8xxx_config_irq(const struct pm_irq_chip *chip, u8 bp, u8 cp)
+{
+	int	rc;
+
+	rc = pm8xxx_writeb(chip->dev->parent,
+				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	if (rc) {
+		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
+		goto bail_out;
+	}
+
+	rc = pm8xxx_writeb(chip->dev->parent,
+				SSBI_REG_ADDR_IRQ_CONFIG, cp);
+	if (rc)
+		pr_err("Failed Configuring IRQ rc=%d\n", rc);
+bail_out:
+	return rc;
+}
+
+static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip,
+				int block, int *handled)
+{
+	int ret = 0;
+	u8 bits, config;
+	int pmirq, irq, k;
+
+	spin_lock(&chip->pm_irq_lock);
+	ret = pm8xxx_read_block(chip, block, &bits);
+	if (ret)
+		goto out;
+	if (!bits) {
+		if (pm8xxx_can_print())
+			pr_err("block bit set in master but no irqs: %d",
+				block);
+		goto out;
+	}
+
+	/* Check IRQ bits */
+	for (k = 0; k < 8; k++) {
+		if (bits & (1 << k)) {
+			pmirq = block * 8 + k;
+			irq = pmirq + chip->irq_base;
+			/* Check spurious interrupts */
+			if (((1 << k) & chip->irqs_allowed[block])) {
+				/* Found one */
+				chip->irqs_to_handle[*handled] = irq;
+				(*handled)++;
+			} else { /* Clear and mask wrong one */
+				config = PM_IRQF_W_C_M |
+					(k << PM_IRQF_BITS_SHIFT);
+
+				pm8xxx_config_irq(chip,
+						  block, config);
+
+				if (pm8xxx_can_print())
+					pr_err("Spurious IRQ: %d "
+					       "[block, bit]="
+					       "[%d, %d]\n",
+					       irq, block, k);
+			}
+		}
+	}
+out:
+	spin_unlock(&chip->pm_irq_lock);
+	return ret;
+}
+
+static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip,
+					int master, int *handled)
+{
+	int ret = 0;
+	u8 blockbits;
+	int block_number, j;
+
+	ret = pm8xxx_read_master(chip, master, &blockbits);
+	if (ret) {
+		pr_err("Failed to read master %d ret=%d\n", master, ret);
+		return ret;
+	}
+	if (!blockbits) {
+		if (pm8xxx_can_print())
+			pr_err("master bit set in root but no blocks: %d",
+				master);
+		return 0;
+	}
+
+	for (j = 0; j < 8; j++)
+		if (blockbits & (1 << j)) {
+			block_number = master * 8 + j;	/* block # */
+			ret |= pm8xxx_irq_block_handler(chip, block_number,
+								handled);
+		}
+	return ret;
+}
+
+static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct pm_irq_chip *chip = get_irq_data(irq);
+	int	i, ret;
+	u8	root;
+	int	masters = 0, handled = 0;
+
+	ret = pm8xxx_read_root(chip, &root);
+	if (ret) {
+		pr_err("Can't read root status ret=%d\n", ret);
+		return;
+	}
+
+	/* on pm8xxx series masters start from bit 1 of the root */
+	masters = root >> 1;
+
+	/* Read allowed masters for blocks. */
+	for (i = 0; i < chip->num_masters; i++)
+		if (masters & (1 << i))
+			pm8xxx_irq_master_handler(chip, i, &handled);
+
+	for (i = 0; i < handled; i++)
+		generic_handle_irq(chip->irqs_to_handle[i]);
+
+	desc->chip->ack(irq);
+
+}
+
+static void pm8xxx_irq_ack(unsigned int irq)
+{
+	const struct pm_irq_chip *chip = get_irq_chip_data(irq);
+	unsigned int pmirq = irq - chip->irq_base;
+	u8	block, config;
+
+	block = pmirq / 8;
+
+	config = PM_IRQF_WRITE | chip->config[pmirq] | PM_IRQF_CLR;
+	/* Keep the mask */
+	if (!(chip->irqs_allowed[block] & (1 << (pmirq % 8))))
+		config |= PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;
+	pm8xxx_config_irq(chip, block, config);
+
+}
+
+static void pm8xxx_irq_mask(unsigned int irq)
+{
+	struct pm_irq_chip *chip = get_irq_chip_data(irq);
+	unsigned int pmirq = irq - chip->irq_base;
+	int	master, irq_bit;
+	u8	block, config;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit = pmirq % 8;
+
+	chip->irqs_allowed[block] &= ~(1 << irq_bit);
+
+	config = PM_IRQF_WRITE | chip->config[pmirq] |
+		PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;
+	pm8xxx_config_irq(chip, block, config);
+}
+
+static void pm8xxx_irq_unmask(unsigned int irq)
+{
+	struct pm_irq_chip *chip = get_irq_chip_data(irq);
+	unsigned int pmirq = irq - chip->irq_base;
+	int	master, irq_bit;
+	u8	block, config, old_irqs_allowed;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit = pmirq % 8;
+
+	old_irqs_allowed = chip->irqs_allowed[block];
+	chip->irqs_allowed[block] |= 1 << irq_bit;
+
+	config = PM_IRQF_WRITE | chip->config[pmirq];
+	pm8xxx_config_irq(chip, block, config);
+}
+
+static int pm8xxx_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	struct pm_irq_chip *chip = get_irq_chip_data(irq);
+	unsigned int pmirq = irq - chip->irq_base;
+	int master, irq_bit;
+	u8 block, config;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit  = pmirq % 8;
+
+	chip->config[pmirq] = (irq_bit << PM_IRQF_BITS_SHIFT) |
+			PM_IRQF_MASK_RE | PM_IRQF_MASK_FE;
+	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
+		if (flow_type & IRQF_TRIGGER_RISING)
+			chip->config[pmirq] &= ~PM_IRQF_MASK_RE;
+		if (flow_type & IRQF_TRIGGER_FALLING)
+			chip->config[pmirq] &= ~PM_IRQF_MASK_FE;
+	} else {
+		chip->config[pmirq] |= PM_IRQF_LVL_SEL;
+
+		if (flow_type & IRQF_TRIGGER_HIGH)
+			chip->config[pmirq] &= ~PM_IRQF_MASK_RE;
+		else
+			chip->config[pmirq] &= ~PM_IRQF_MASK_FE;
+	}
+
+	config = PM_IRQF_WRITE
+		| chip->config[pmirq] | PM_IRQF_CLR;
+	return pm8xxx_config_irq(chip, block, config);
+}
+
+static int pm8xxx_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	struct pm_irq_chip *chip = get_irq_chip_data(irq);
+	unsigned int pmirq = irq - chip->irq_base;
+
+	if (on) {
+		set_bit(pmirq, chip->wake_enable);
+		chip->count_wakeable++;
+	} else {
+		clear_bit(pmirq, chip->wake_enable);
+		chip->count_wakeable--;
+	}
+
+	return 0;
+}
+
+static struct irq_chip pm8xxx_irq_chip = {
+	.name		= "pm8xxx",
+	.ack		= pm8xxx_irq_ack,
+	.mask		= pm8xxx_irq_mask,
+	.unmask		= pm8xxx_irq_unmask,
+	.set_type	= pm8xxx_irq_set_type,
+	.set_wake	= pm8xxx_irq_set_wake,
+};
+
+int pm8xxx_get_irq_stat(const struct device *dev, int irq)
+{
+	struct pm_irq_chip *chip = dev_get_drvdata(dev);
+	int pmirq;
+	int     rc;
+	u8      block, bits, bit;
+	unsigned long flags;
+
+	if (chip == NULL || irq < chip->irq_base ||
+			irq >= chip->irq_base + chip->num_irqs)
+		return -EINVAL;
+
+	pmirq = irq - chip->irq_base;
+
+	block = pmirq / 8;
+	bit = pmirq % 8;
+
+	spin_lock_irqsave(&chip->pm_irq_lock, flags);
+
+	rc = pm8xxx_writeb(chip->dev->parent,
+				SSBI_REG_ADDR_IRQ_BLK_SEL, block);
+	if (rc) {
+		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
+			irq, pmirq, block, rc);
+		goto bail_out;
+	}
+
+	rc = pm8xxx_readb(chip->dev->parent,
+				SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
+	if (rc) {
+		pr_err("Failed Configuring irq=%d pmirq=%d blk=%d rc=%d\n",
+			irq, pmirq, block, rc);
+		goto bail_out;
+	}
+
+	rc = (bits & (1 << bit)) ? 1 : 0;
+
+bail_out:
+	spin_unlock_irqrestore(&chip->pm_irq_lock, flags);
+
+	return rc;
+}
+EXPORT_SYMBOL(pm8xxx_get_irq_stat);
+
+#ifdef CONFIG_PM
+static int pm8xxx_suspend(struct device *dev)
+{
+	const struct pm_irq_chip *chip = dev_get_drvdata(dev);
+	int pmirq;
+
+	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
+		if (chip->config[i] && !test_bit(i, chip->wake_enable)) {
+			if (!((chip->config[i] & PM_IRQF_MASK_ALL)
+			      == PM_IRQF_MASK_ALL)) {
+				irq = i + chip->irq_base;
+				pm8xxx_irq_mask(irq);
+			}
+		}
+	}
+
+	if (!chip->count_wakeable)
+		disable_irq(chip->dev->irq);
+
+	return 0;
+}
+
+void pm8xxx_show_resume_irq(void)
+{
+	struct pm_irq_chip *chip;
+	u8	block, bits;
+	int pmirq;
+
+	list_for_each_entry(chip, &pm_irq_chips, link) {
+		for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
+			if (test_bit(pmirq, chip->wake_enable)) {
+				block = pmirq / 8;
+				if (!pm8xxx_read_block(chip, &block, &bits)) {
+					if (bits & (1 << (pmirq & 0x7)))
+						pr_warning("%d triggered\n",
+						pmirq + chip->pdata.irq_base);
+				}
+			}
+		}
+	}
+}
+
+static int pm8xxx_resume(struct device *dev)
+{
+	const struct pm_irq_chip *chip = dev_get_drvdata(dev);
+	int pmirq;
+
+	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
+		if (chip->config[i] && !test_bit(i, chip->wake_enable)) {
+			if (!((chip->config[i] & PM_IRQF_MASK_ALL)
+			      == PM_IRQF_MASK_ALL)) {
+				irq = i + chip->irq_base;
+				pm8xxx_irq_unmask(irq);
+			}
+		}
+	}
+
+	if (!chip->count_wakeable)
+		enable_irq(chip->dev->irq);
+
+	return 0;
+}
+#else
+#define	pm8xxx_suspend		NULL
+#define	pm8xxx_resume		NULL
+#endif
+
+static const struct dev_pm_ops pm8xxx_pm = {
+	.suspend = pm8xxx_suspend,
+	.resume  = pm8xxx_resume,
+};
+
+static int __devinit pm8xxx_irq_probe(struct platform_device *pdev)
+{
+	const struct pm8xxx_irq_platform_data *pdata = pdev->dev.platform_data;
+	struct pm_irq_chip  *chip;
+	int devirq;
+	int rc;
+	unsigned int pmirq;
+
+	if (!pdata) {
+		pr_err("No platform data\n");
+		return -EINVAL;
+	}
+
+	devirq = pdata->devirq;
+	if (devirq < 0) {
+		pr_err("missing devirq\n");
+		rc = devirq;
+		goto out;
+	}
+
+	chip = kzalloc(sizeof(struct pm_irq_chip), GFP_KERNEL);
+	if (!chip) {
+		pr_err("Cannot alloc pm_irq_chip struct\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	chip->dev = &pdev->dev;
+	chip->devirq = devirq;
+	chip->irq_base = pdata->irq_base;
+	chip->num_irqs = pdata->irq_cdata.nirqs;
+	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
+	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
+	spin_lock_init(&chip->pm_irq_lock);
+
+	chip->irqs_allowed = kzalloc(sizeof(u8) * chip->num_blocks, GFP_KERNEL);
+	if (!chip->irqs_allowed) {
+		pr_err("Cannot alloc irqs_allowed array\n");
+		rc = -ENOMEM;
+		goto free_pm_irq_chip;
+	}
+
+	chip->irqs_to_handle = kzalloc(sizeof(u16) * chip->num_irqs,
+								GFP_KERNEL);
+	if (!chip->irqs_to_handle) {
+		pr_err("Cannot alloc irqs_to_handle array\n");
+		rc = -ENOMEM;
+		goto free_irqs_allowed;
+	}
+	chip->config = kzalloc(sizeof(u8) * chip->num_irqs, GFP_KERNEL);
+	if (!chip->config) {
+		pr_err("Cannot alloc config array\n");
+		rc = -ENOMEM;
+		goto free_irqs_to_handle;
+	}
+	chip->wake_enable = kzalloc(sizeof(unsigned long)
+			* DIV_ROUND_UP(chip->num_irqs, BITS_PER_LONG),
+			GFP_KERNEL);
+	if (!chip->wake_enable) {
+		pr_err("Cannot alloc wake_enable array\n");
+		rc = -ENOMEM;
+		goto free_config;
+	}
+
+	platform_set_drvdata(pdev, chip);
+	list_add(&chip->link, &pm_irq_chips);
+
+	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
+		set_irq_chip(chip->irq_base + pmirq, &pm8xxx_irq_chip);
+		set_irq_chip_data(chip->irq_base + pmirq, chip);
+		set_irq_handler(chip->irq_base + pmirq, handle_level_irq);
+#ifdef CONFIG_ARM
+		set_irq_flags(chip->irq_base + pmirq, IRQF_VALID);
+#else
+		set_irq_noprobe(chip->irq_base + pmirq);
+#endif
+	}
+
+	set_irq_type(devirq, pdata->irq_trigger_flag);
+	set_irq_data(devirq, chip);
+	set_irq_chained_handler(devirq, pm8xxx_irq_handler);
+	set_irq_wake(devirq, 1);
+
+	return 0;
+
+free_config:
+	kfree(chip->config);
+free_irqs_to_handle:
+	kfree(chip->irqs_to_handle);
+free_irqs_allowed:
+	kfree(chip->irqs_allowed);
+free_pm_irq_chip:
+	kfree(chip);
+out:
+	return rc;
+
+}
+
+static int __devexit pm_irq_remove(struct platform_device *pdev)
+{
+	struct pm_irq_chip *chip = platform_get_drvdata(pdev);
+
+	list_del(&chip->link);
+	platform_set_drvdata(pdev, NULL);
+	set_irq_chained_handler(chip->devirq, NULL);
+	kfree(chip->wake_enable);
+	kfree(chip->config);
+	kfree(chip->irqs_to_handle);
+	kfree(chip->irqs_allowed);
+	kfree(chip);
+	return 0;
+}
+
+static struct platform_driver pm8xxx_irq_driver = {
+	.probe		= pm8xxx_irq_probe,
+	.remove		= __devexit_p(pm_irq_remove),
+	.driver		= {
+		.name	= PM8XXX_IRQ_DEV_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &pm8xxx_pm,
+	},
+};
+
+static int __init pm_irq_init(void)
+{
+	return platform_driver_register(&pm8xxx_irq_driver);
+}
+postcore_initcall(pm_irq_init);
+
+static void __exit pm_irq_exit(void)
+{
+	platform_driver_unregister(&pm8xxx_irq_driver);
+}
+module_exit(pm_irq_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PMIC IRQ driver");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:" PM8XXX_IRQ_DEV_NAME);
diff --git a/include/linux/mfd/pm8921.h b/include/linux/mfd/pm8921.h
index 17fc37b..92d21bd 100644
--- a/include/linux/mfd/pm8921.h
+++ b/include/linux/mfd/pm8921.h
@@ -18,9 +18,13 @@
 #define __MFD_PM8921_H
 
 #include <linux/device.h>
+#include <linux/mfd/pm8xxx/irq.h>
+
+#define NR_PM8921_IRQS 256
 
 struct pm8921_platform_data {
-	int irq_base;
+	int				irq_base;
+	struct pm8xxx_irq_platform_data	*irq_pdata;
 };
 
 #endif
diff --git a/include/linux/mfd/pm8xxx/core.h b/include/linux/mfd/pm8xxx/core.h
index 61f1c01..e5aeecf 100644
--- a/include/linux/mfd/pm8xxx/core.h
+++ b/include/linux/mfd/pm8xxx/core.h
@@ -26,6 +26,7 @@ struct pm8xxx_drvdata {
 									int n);
 	int	(*pmic_write_buf) (const struct device *dev, u16 addr, u8 *buf,
 									int n);
+	int	(*pmic_read_irq_stat) (const struct device *dev, int irq);
 	void	*pm_chip_data;
 };
 
@@ -63,4 +64,12 @@ static inline int pm8xxx_write_buf(const struct device *dev, u16 addr, u8 *buf,
 	return dd->pmic_write_buf(dev, addr, buf, n);
 }
 
+static inline int pm8xxx_read_irq_stat(const struct device *dev, int irq)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	BUG_ON(!dd);
+	return dd->pmic_read_irq_stat(dev, irq);
+}
+
 #endif
diff --git a/include/linux/mfd/pm8xxx/irq.h b/include/linux/mfd/pm8xxx/irq.h
new file mode 100644
index 0000000..5ea4294
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/irq.h
@@ -0,0 +1,62 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/*
+ * Qualcomm PMIC irq 8xxx driver header file
+ *
+ */
+
+#ifndef __MFD_PM8XXX_IRQ_H
+#define __MFD_PM8XXX_IRQ_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_IRQ_DEV_NAME	"pm8xxx-irq"
+#define PM8XXX_IRQ_DEV_NAME_LEN	10
+
+struct pm8xxx_irq_core_data {
+	u32		rev;
+	int		nirqs;
+};
+
+struct pm8xxx_irq_platform_data {
+	int				irq_base;
+	struct pm8xxx_irq_core_data	irq_cdata;
+	int				devirq;
+	int				irq_trigger_flag;
+};
+
+#ifdef CONFIG_MFD_PM8XXX_IRQ
+/**
+ * pm8xxx_get_irq_stat - get the status of the irq line
+ * @dev: the interrupt device
+ * @irq: the irq number
+ *
+ * The pm8xxx gpio and mpp rely on the interrupt block to read
+ * the values on their pins. This function is to facilitate reading
+ * the status of a gpio or an mpp line. The caller has to convert the
+ * gpio number to irq number.
+ *
+ * RETURNS:
+ * an int indicating the value read on that line
+ */
+int pm8xxx_get_irq_stat(const struct device *dev, int irq);
+void pm8xxx_show_resume_irq(void);
+#else
+static inline int pm8xxx_get_irq_stat(const struct device *dev, int irq)
+{
+	return -ENXIO;
+}
+static inline void pm8xxx_show_resume_irq(void)
+{
+}
+#endif
+#endif
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
