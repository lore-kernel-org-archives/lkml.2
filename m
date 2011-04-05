Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1DEVmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:42:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16536 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DEVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:41:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="83946089"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PM8921 MFD V5 2/6] mfd: pm8xxx: Add irq support
Date: Tue,  5 Apr 2011 14:40:53 -0700
Message-Id: <1302039657-19395-3-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the irq controller in Qualcomm 8xxx pmic. The 8xxx
interrupt controller provides control for gpio and mpp configured as
interrupts in addition to other subdevice interrupts. The interrupt
controller also provides a way to read the real time status of an
interrupt. This real time status is the only way one can get the
input values of gpio and mpp lines.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
---
 drivers/mfd/Kconfig               |   10 +
 drivers/mfd/Makefile              |    1 +
 drivers/mfd/pm8921-core.c         |   54 ++++++
 drivers/mfd/pm8xxx-irq.c          |  371 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pm8xxx/core.h   |   10 +
 include/linux/mfd/pm8xxx/irq.h    |   59 ++++++
 include/linux/mfd/pm8xxx/pm8921.h |    4 +
 7 files changed, 509 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 include/linux/mfd/pm8xxx/irq.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f9febb9..38320e2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -689,6 +689,16 @@ config MFD_PM8921_CORE
 	  Say M here if you want to include support for PM8921 chip as a module.
 	  This will build a module called "pm8921-core".
 
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
index e1b446c..f4afcc8 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -89,3 +89,4 @@ obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o
+obj-$(CONFIG_MFD_PM8XXX_IRQ) 	+= pm8xxx-irq.o
diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index a2ecd32..e873b15 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 #include <linux/msm_ssbi.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/pm8xxx/pm8921.h>
@@ -26,6 +27,7 @@
 
 struct pm8921 {
 	struct device			*dev;
+	struct pm_irq_chip		*irq_chip;
 };
 
 static int pm8921_readb(const struct device *dev, u16 addr, u8 *val)
@@ -62,19 +64,53 @@ static int pm8921_write_buf(const struct device *dev, u16 addr, u8 *buf,
 	return msm_ssbi_write(pmic->dev->parent, addr, buf, cnt);
 }
 
+static int pm8921_read_irq_stat(const struct device *dev, int irq)
+{
+	const struct pm8xxx_drvdata *pm8921_drvdata = dev_get_drvdata(dev);
+	const struct pm8921 *pmic = pm8921_drvdata->pm_chip_data;
+
+	return pm8xxx_get_irq_stat(pmic->irq_chip, irq);
+}
+
 static struct pm8xxx_drvdata pm8921_drvdata = {
 	.pmic_readb		= pm8921_readb,
 	.pmic_writeb		= pm8921_writeb,
 	.pmic_read_buf		= pm8921_read_buf,
 	.pmic_write_buf		= pm8921_write_buf,
+	.pmic_read_irq_stat	= pm8921_read_irq_stat,
 };
 
+static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
+					   *pdata,
+					   struct pm8921 *pmic,
+					   u32 rev)
+{
+	int ret = 0, irq_base = 0;
+	struct pm_irq_chip *irq_chip;
+
+	if (pdata->irq_pdata) {
+		pdata->irq_pdata->irq_cdata.nirqs = PM8921_NR_IRQS;
+		pdata->irq_pdata->irq_cdata.rev = rev;
+		irq_base = pdata->irq_pdata->irq_base;
+		irq_chip = pm8xxx_irq_init(pmic->dev, pdata->irq_pdata);
+
+		if (IS_ERR(irq_chip)) {
+			pr_err("Failed to init interrupts ret=%ld\n",
+					PTR_ERR(irq_chip));
+			return PTR_ERR(irq_chip);
+		}
+		pmic->irq_chip = irq_chip;
+	}
+	return ret;
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
@@ -94,6 +130,7 @@ static int __devinit pm8921_probe(struct platform_device *pdev)
 		goto err_read_rev;
 	}
 	pr_info("PMIC revision 1: %02X\n", val);
+	rev = val;
 
 	/* Read PMIC chip revision 2 */
 	rc = msm_ssbi_read(pdev->dev.parent, REG_HWREV_2, &val, sizeof(val));
@@ -103,13 +140,26 @@ static int __devinit pm8921_probe(struct platform_device *pdev)
 		goto err_read_rev;
 	}
 	pr_info("PMIC revision 2: %02X\n", val);
+	rev |= val << BITS_PER_BYTE;
 
 	pmic->dev = &pdev->dev;
 	pm8921_drvdata.pm_chip_data = pmic;
 	platform_set_drvdata(pdev, &pm8921_drvdata);
 
+	rc = pm8921_add_subdevices(pdata, pmic, rev);
+	if (rc) {
+		pr_err("Cannot add subdevices rc=%d\n", rc);
+		goto err;
+	}
+
+	/* gpio might not work if no irq device is found */
+	WARN_ON(pmic->irq_chip == NULL);
+
 	return 0;
 
+err:
+	mfd_remove_devices(pmic->dev);
+	platform_set_drvdata(pdev, NULL);
 err_read_rev:
 	kfree(pmic);
 	return rc;
@@ -125,6 +175,10 @@ static int __devexit pm8921_remove(struct platform_device *pdev)
 		pmic = drvdata->pm_chip_data;
 	if (pmic)
 		mfd_remove_devices(pmic->dev);
+	if (pmic->irq_chip) {
+		pm8xxx_irq_exit(pmic->irq_chip);
+		pmic->irq_chip = NULL;
+	}
 	platform_set_drvdata(pdev, NULL);
 	kfree(pmic);
 
diff --git a/drivers/mfd/pm8xxx-irq.c b/drivers/mfd/pm8xxx-irq.c
new file mode 100644
index 0000000..d452dd0
--- /dev/null
+++ b/drivers/mfd/pm8xxx-irq.c
@@ -0,0 +1,371 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#define	PM_IRQF_LVL_SEL			0x01	/* level select */
+#define	PM_IRQF_MASK_FE			0x02	/* mask falling edge */
+#define	PM_IRQF_MASK_RE			0x04	/* mask rising edge */
+#define	PM_IRQF_CLR			0x08	/* clear interrupt */
+#define	PM_IRQF_BITS_MASK		0x70
+#define	PM_IRQF_BITS_SHIFT		4
+#define	PM_IRQF_WRITE			0x80
+
+#define	PM_IRQF_MASK_ALL		(PM_IRQF_MASK_FE | \
+					PM_IRQF_MASK_RE)
+
+struct pm_irq_chip {
+	struct device		*dev;
+	spinlock_t		pm_irq_lock;
+	unsigned int		devirq;
+	unsigned int		irq_base;
+	unsigned int		num_irqs;
+	unsigned int		num_blocks;
+	unsigned int		num_masters;
+	u8			config[0];
+};
+
+static int pm8xxx_read_root_irq(const struct pm_irq_chip *chip, u8 *rp)
+{
+	return pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_ROOT, rp);
+}
+
+static int pm8xxx_read_master_irq(const struct pm_irq_chip *chip, u8 m, u8 *bp)
+{
+	return pm8xxx_readb(chip->dev,
+			SSBI_REG_ADDR_IRQ_M_STATUS1 + m, bp);
+}
+
+static int pm8xxx_read_block_irq(struct pm_irq_chip *chip, u8 bp, u8 *ip)
+{
+	int	rc;
+
+	spin_lock(&chip->pm_irq_lock);
+	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	if (rc) {
+		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
+		goto bail;
+	}
+
+	rc = pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
+	if (rc)
+		pr_err("Failed Reading Status rc=%d\n", rc);
+bail:
+	spin_unlock(&chip->pm_irq_lock);
+	return rc;
+}
+
+static int pm8xxx_config_irq(struct pm_irq_chip *chip, u8 bp, u8 cp)
+{
+	int	rc;
+
+	spin_lock(&chip->pm_irq_lock);
+	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
+	if (rc) {
+		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
+		goto bail;
+	}
+
+	cp |= PM_IRQF_WRITE;
+	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_CONFIG, cp);
+	if (rc)
+		pr_err("Failed Configuring IRQ rc=%d\n", rc);
+bail:
+	spin_unlock(&chip->pm_irq_lock);
+	return rc;
+}
+
+static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
+{
+	int pmirq, irq, i, ret = 0;
+	u8 bits;
+
+	ret = pm8xxx_read_block_irq(chip, block, &bits);
+	if (ret) {
+		pr_err("Failed reading %d block ret=%d", block, ret);
+		return ret;
+	}
+	if (!bits) {
+		pr_err("block bit set in master but no irqs: %d", block);
+		return 0;
+	}
+
+	/* Check IRQ bits */
+	for (i = 0; i < 8; i++) {
+		if (bits & (1 << i)) {
+			pmirq = block * 8 + i;
+			irq = pmirq + chip->irq_base;
+			generic_handle_irq(irq);
+		}
+	}
+	return 0;
+}
+
+static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip, int master)
+{
+	u8 blockbits;
+	int block_number, i, ret = 0;
+
+	ret = pm8xxx_read_master_irq(chip, master, &blockbits);
+	if (ret) {
+		pr_err("Failed to read master %d ret=%d\n", master, ret);
+		return ret;
+	}
+	if (!blockbits) {
+		pr_err("master bit set in root but no blocks: %d", master);
+		return 0;
+	}
+
+	for (i = 0; i < 8; i++)
+		if (blockbits & (1 << i)) {
+			block_number = master * 8 + i;	/* block # */
+			ret |= pm8xxx_irq_block_handler(chip, block_number);
+		}
+	return ret;
+}
+
+static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct pm_irq_chip *chip = irq_desc_get_handler_data(desc);
+	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
+	u8	root;
+	int	i, ret, masters = 0;
+
+	ret = pm8xxx_read_root_irq(chip, &root);
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
+			pm8xxx_irq_master_handler(chip, i);
+
+	irq_chip->irq_ack(&desc->irq_data);
+}
+
+static void pm8xxx_irq_mask_ack(struct irq_data *d)
+{
+	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
+	unsigned int pmirq = d->irq - chip->irq_base;
+	int	master, irq_bit;
+	u8	block, config;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit = pmirq % 8;
+
+	config = chip->config[pmirq] | PM_IRQF_MASK_ALL | PM_IRQF_CLR;
+	pm8xxx_config_irq(chip, block, config);
+}
+
+static void pm8xxx_irq_unmask(struct irq_data *d)
+{
+	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
+	unsigned int pmirq = d->irq - chip->irq_base;
+	int	master, irq_bit;
+	u8	block, config;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit = pmirq % 8;
+
+	config = chip->config[pmirq];
+	pm8xxx_config_irq(chip, block, config);
+}
+
+static int pm8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
+{
+	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
+	unsigned int pmirq = d->irq - chip->irq_base;
+	int master, irq_bit;
+	u8 block, config;
+
+	block = pmirq / 8;
+	master = block / 8;
+	irq_bit  = pmirq % 8;
+
+	chip->config[pmirq] = (irq_bit << PM_IRQF_BITS_SHIFT)
+							| PM_IRQF_MASK_ALL;
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
+	config = chip->config[pmirq] | PM_IRQF_CLR;
+	return pm8xxx_config_irq(chip, block, config);
+}
+
+static int pm8xxx_irq_set_wake(struct irq_data *d, unsigned int on)
+{
+	return 0;
+}
+
+static struct irq_chip pm8xxx_irq_chip = {
+	.name		= "pm8xxx",
+	.irq_mask_ack	= pm8xxx_irq_mask_ack,
+	.irq_unmask	= pm8xxx_irq_unmask,
+	.irq_set_type	= pm8xxx_irq_set_type,
+	.irq_set_wake	= pm8xxx_irq_set_wake,
+	.flags		= IRQCHIP_MASK_ON_SUSPEND,
+};
+
+/**
+ * pm8xxx_get_irq_stat - get the status of the irq line
+ * @chip: pointer to identify a pmic irq controller
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
+int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
+{
+	int pmirq, rc;
+	u8  block, bits, bit;
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
+	rc = pm8xxx_writeb(chip->dev, SSBI_REG_ADDR_IRQ_BLK_SEL, block);
+	if (rc) {
+		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
+			irq, pmirq, block, rc);
+		goto bail_out;
+	}
+
+	rc = pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
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
+EXPORT_SYMBOL_GPL(pm8xxx_get_irq_stat);
+
+struct pm_irq_chip *  __devinit pm8xxx_irq_init(struct device *dev,
+				const struct pm8xxx_irq_platform_data *pdata)
+{
+	struct pm_irq_chip  *chip;
+	int devirq, rc;
+	unsigned int pmirq;
+
+	if (!pdata) {
+		pr_err("No platform data\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	devirq = pdata->devirq;
+	if (devirq < 0) {
+		pr_err("missing devirq\n");
+		rc = devirq;
+		return ERR_PTR(-EINVAL);
+	}
+
+	chip = kzalloc(sizeof(struct pm_irq_chip)
+			+ sizeof(u8) * pdata->irq_cdata.nirqs, GFP_KERNEL);
+	if (!chip) {
+		pr_err("Cannot alloc pm_irq_chip struct\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	chip->dev = dev;
+	chip->devirq = devirq;
+	chip->irq_base = pdata->irq_base;
+	chip->num_irqs = pdata->irq_cdata.nirqs;
+	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
+	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
+	spin_lock_init(&chip->pm_irq_lock);
+
+	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
+		irq_set_chip_and_handler(chip->irq_base + pmirq,
+				&pm8xxx_irq_chip,
+				handle_level_irq);
+		irq_set_chip_data(chip->irq_base + pmirq, chip);
+#ifdef CONFIG_ARM
+		set_irq_flags(chip->irq_base + pmirq, IRQF_VALID);
+#else
+		irq_set_noprobe(chip->irq_base + pmirq);
+#endif
+	}
+
+	irq_set_irq_type(devirq, pdata->irq_trigger_flag);
+	irq_set_handler_data(devirq, chip);
+	irq_set_chained_handler(devirq, pm8xxx_irq_handler);
+	set_irq_wake(devirq, 1);
+
+	return chip;
+}
+
+int __devexit pm8xxx_irq_exit(struct pm_irq_chip *chip)
+{
+	irq_set_chained_handler(chip->devirq, NULL);
+	kfree(chip);
+	return 0;
+}
diff --git a/include/linux/mfd/pm8xxx/core.h b/include/linux/mfd/pm8xxx/core.h
index 36ccb33..bd2f4f6 100644
--- a/include/linux/mfd/pm8xxx/core.h
+++ b/include/linux/mfd/pm8xxx/core.h
@@ -27,6 +27,7 @@ struct pm8xxx_drvdata {
 									int n);
 	int	(*pmic_write_buf) (const struct device *dev, u16 addr, u8 *buf,
 									int n);
+	int	(*pmic_read_irq_stat) (const struct device *dev, int irq);
 	void	*pm_chip_data;
 };
 
@@ -68,4 +69,13 @@ static inline int pm8xxx_write_buf(const struct device *dev, u16 addr, u8 *buf,
 	return dd->pmic_write_buf(dev, addr, buf, n);
 }
 
+static inline int pm8xxx_read_irq_stat(const struct device *dev, int irq)
+{
+	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
+
+	if (!dd)
+		return -EINVAL;
+	return dd->pmic_read_irq_stat(dev, irq);
+}
+
 #endif
diff --git a/include/linux/mfd/pm8xxx/irq.h b/include/linux/mfd/pm8xxx/irq.h
new file mode 100644
index 0000000..4b21769
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/irq.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
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
+#include <linux/err.h>
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
+struct pm_irq_chip;
+
+#ifdef CONFIG_MFD_PM8XXX_IRQ
+int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq);
+struct pm_irq_chip * __devinit pm8xxx_irq_init(struct device *dev,
+				const struct pm8xxx_irq_platform_data *pdata);
+int __devexit pm8xxx_irq_exit(struct pm_irq_chip *chip);
+#else
+static inline int pm8xxx_get_irq_stat(struct pm_irq_chip *chip, int irq)
+{
+	return -ENXIO;
+}
+static inline struct pm_irq_chip * __devinit pm8xxx_irq_init(
+				const struct device *dev,
+				const struct pm8xxx_irq_platform_data *pdata)
+{
+	return ERR_PTR(-ENXIO);
+}
+static inline int __devexit pm8xxx_irq_exit(struct pm_irq_chip *chip)
+{
+	return -ENXIO;
+}
+#endif /* CONFIG_MFD_PM8XXX_IRQ */
+#endif /* __MFD_PM8XXX_IRQ_H */
diff --git a/include/linux/mfd/pm8xxx/pm8921.h b/include/linux/mfd/pm8xxx/pm8921.h
index 33fbe9c..d5517fd 100644
--- a/include/linux/mfd/pm8xxx/pm8921.h
+++ b/include/linux/mfd/pm8xxx/pm8921.h
@@ -19,9 +19,13 @@
 #define __MFD_PM8921_H
 
 #include <linux/device.h>
+#include <linux/mfd/pm8xxx/irq.h>
+
+#define PM8921_NR_IRQS		256
 
 struct pm8921_platform_data {
 	int					irq_base;
+	struct pm8xxx_irq_platform_data		*irq_pdata;
 };
 
 #endif
-- 
1.7.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
