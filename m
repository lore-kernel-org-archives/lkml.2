Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2JCOtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:49:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab2JCOts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:49:48 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>
CC: <afzal@ti.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <ivan.djelic@parrot.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 2/4] mtd: devices: elm: Add support for ELM error correction
Date: Wed, 3 Oct 2012 19:59:47 +0530
Message-ID: <1349274589-11389-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms containing the ELM module can be used to correct errors
reported by BCH 4, 8 & 16 bit ECC scheme. For now only 4 & 8 bit
support is added.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
---
:000000 100644 0000000... b88ee83... A	Documentation/devicetree/bindings/mtd/elm.txt
:100644 100644 395733a... 0f6a94b... M	drivers/mtd/devices/Makefile
:000000 100644 0000000... 802b572... A	drivers/mtd/devices/elm.c
:000000 100644 0000000... eb53163... A	include/linux/platform_data/elm.h
 Documentation/devicetree/bindings/mtd/elm.txt |   18 +
 drivers/mtd/devices/Makefile                  |    4 +-
 drivers/mtd/devices/elm.c                     |  440 +++++++++++++++++++++++++
 include/linux/platform_data/elm.h             |   60 ++++
 4 files changed, 521 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/elm.txt b/Documentation/devicetree/bindings/mtd/elm.txt
new file mode 100644
index 0000000..b88ee83
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/elm.txt
@@ -0,0 +1,18 @@
+Error location module
+
+Required properties:
+- compatible: Must be "ti,elm"
+- reg: physical base address and size of the registers map.
+- interrupts: Interrupt number for the elm.
+- interrupt-parent: The parent interrupt controller
+
+Optional properties:
+- ti,hwmods: Name of the hwmod associated to the elm
+
+Example:
+elm: elm@0 {
+	compatible	= "ti,elm";
+	reg = <0x48080000 0x2000>;
+	interrupt-parent = <&intc>;
+	interrupts = <4>;
+};
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index 395733a..0f6a94b 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -17,8 +17,10 @@ obj-$(CONFIG_MTD_LART)		+= lart.o
 obj-$(CONFIG_MTD_BLOCK2MTD)	+= block2mtd.o
 obj-$(CONFIG_MTD_DATAFLASH)	+= mtd_dataflash.o
 obj-$(CONFIG_MTD_M25P80)	+= m25p80.o
+obj-$(CONFIG_MTD_NAND_OMAP2)	+= elm.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
 obj-$(CONFIG_MTD_BCM47XXSFLASH)	+= bcm47xxsflash.o
 
-CFLAGS_docg3.o			+= -I$(src)
\ No newline at end of file
+
+CFLAGS_docg3.o			+= -I$(src)
diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
new file mode 100644
index 0000000..802b572
--- /dev/null
+++ b/drivers/mtd/devices/elm.c
@@ -0,0 +1,440 @@
+/*
+ * Error Location Module
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_data/elm.h>
+
+#define ELM_IRQSTATUS			0x018
+#define ELM_IRQENABLE			0x01c
+#define ELM_LOCATION_CONFIG		0x020
+#define ELM_PAGE_CTRL			0x080
+#define ELM_SYNDROME_FRAGMENT_0		0x400
+#define ELM_SYNDROME_FRAGMENT_6		0x418
+#define ELM_LOCATION_STATUS		0x800
+#define ELM_ERROR_LOCATION_0		0x880
+
+/* ELM Interrupt Status Register */
+#define INTR_STATUS_PAGE_VALID		BIT(8)
+
+/* ELM Interrupt Enable Register */
+#define INTR_EN_PAGE_MASK		BIT(8)
+
+/* ELM Location Configuration Register */
+#define ECC_BCH_LEVEL_MASK		0x3
+
+/* ELM syndrome */
+#define ELM_SYNDROME_VALID		BIT(16)
+
+/* ELM_LOCATION_STATUS Register */
+#define ECC_CORRECTABLE_MASK		BIT(8)
+#define ECC_NB_ERRORS_MASK		0x1f
+
+/* ELM_ERROR_LOCATION_0-15 Registers */
+#define ECC_ERROR_LOCATION_MASK		0x1fff
+
+#define ELM_ECC_SIZE			0x7ff
+
+#define SYNDROME_FRAGMENT_REG_SIZE	0x40
+#define ERROR_LOCATION_SIZE		0x100
+#define MAX_BCH_ELM_ERROR		16
+#define ELM_FRAGMENT_REG		7
+
+typedef u32 syn_t[ELM_FRAGMENT_REG];
+typedef u32 elm_error_t[MAX_BCH_ELM_ERROR];
+
+struct elm_info {
+	struct device *dev;
+	void __iomem *elm_base;
+	struct completion elm_completion;
+	struct list_head list;
+	enum bch_ecc bch_type;
+};
+
+static LIST_HEAD(elm_devices);
+
+static void elm_write_reg(void *offset, u32 val)
+{
+	writel(val, offset);
+}
+
+static u32 elm_read_reg(void *offset)
+{
+	return readl(offset);
+}
+
+/**
+ * elm_config - Configure ELM module
+ * @info:	elm info
+ */
+static void elm_config(struct elm_info *info)
+{
+	u32 reg_val;
+
+	reg_val = (info->bch_type & ECC_BCH_LEVEL_MASK) | (ELM_ECC_SIZE << 16);
+	elm_write_reg(info->elm_base + ELM_LOCATION_CONFIG, reg_val);
+}
+
+/**
+ * elm_configure_page_mode - Enable/Disable page mode
+ * @info:	elm info
+ * @index:	index number of syndrome fragment vector
+ * @enable:	enable/disable flag for page mode
+ *
+ * Enable page mode for syndrome fragment index
+ */
+static void elm_configure_page_mode(struct elm_info *info, int index,
+		bool enable)
+{
+	u32 reg_val;
+
+	reg_val = elm_read_reg(info->elm_base + ELM_PAGE_CTRL);
+	if (enable)
+		reg_val |= BIT(index);	/* enable page mode */
+	else
+		reg_val &= ~BIT(index);	/* disable page mode */
+
+	elm_write_reg(info->elm_base + ELM_PAGE_CTRL, reg_val);
+}
+
+static void rearrange_bch4(u8 *syndrome)
+{
+	/*
+	 * BCH4 has 52 bit used for ecc, but OOB stored with
+	 * nibble 0 appended, removes appended 0 nibble
+	 */
+	u64 *dst = (u64 *)syndrome;
+	*dst >>= 4;
+}
+
+/**
+ * elm_reverse_eccdata - Reverse ecc data
+ * @info:	elm info
+ * @ecc_data:	buffer for calculated ecc
+ * @syndrome:	buffer for syndrome polynomial
+ *
+ * ecc_data has to be reversed for syndrome vector
+ */
+static void elm_reverse_eccdata(struct elm_info *info, u8 *ecc_data,
+		u8 *syndrome)
+{
+	int i;
+	int bch_size = info->bch_type ? BCH8_ECC_OOB_BYTES : BCH4_SIZE;
+
+	for (i = 0; i < bch_size; i++)
+		syndrome[bch_size - 1 - i] = ecc_data[i];
+
+	/*
+	 * syndrome polynomial to be rearranged for BCH 4 ecc scheme as 52
+	 * bits being used and 4 bits being appended in syndrome vector
+	 */
+	if (info->bch_type == BCH4_ECC)
+		rearrange_bch4(syndrome);
+}
+
+/**
+ * elm_load_syndrome - Load ELM syndrome reg
+ * @info:	elm info
+ * @index:	syndrome fragment index
+ * @syndrome:	Syndrome polynomial
+ *
+ * Load syndrome fragment registers with syndrome polynomial
+ */
+static void elm_load_syndrome(struct elm_info *info, int index, u8 *syndrome)
+{
+	int i;
+	int max = info->bch_type ? BCH8_SYNDROME_SIZE : BCH4_SYNDROME_SIZE;
+	void *syn_frag_base = info->elm_base + ELM_SYNDROME_FRAGMENT_0;
+	syn_t *syn_fragment;
+	u32 reg_val;
+
+	elm_configure_page_mode(info, index, true);
+	syn_fragment = syn_frag_base + SYNDROME_FRAGMENT_REG_SIZE * index;
+
+	for (i = 0; i < max; i++) {
+		reg_val = syndrome[0] | syndrome[1] << 8 | syndrome[2] << 16 |
+			syndrome[3] << 24;
+		elm_write_reg(*syn_fragment + i, reg_val);
+		/* Update syndrome polynomial pointer */
+		syndrome += 4;
+	}
+}
+
+/**
+ * elm_start_processing - start elm syndrome processing
+ * @info:	elm info
+ * @err_vec:	elm error vectors
+ *
+ * Set syndrome valid bit for syndrome fragment registers for which
+ * elm syndrome fragment registers are loaded. This enables elm module
+ * to start processing syndrome vectors.
+ */
+static void elm_start_processing(struct elm_info *info,
+		struct elm_errorvec *err_vec)
+{
+	int i;
+	void *offset;
+	u32 reg_val;
+
+	/*
+	 * Set syndrome vector valid so that ELM module will process it for
+	 * vectors error is reported
+	 */
+	for (i = 0; i < ERROR_VECTOR_MAX; i++) {
+		if (err_vec[i].error_reported) {
+			offset = info->elm_base + ELM_SYNDROME_FRAGMENT_6 + i *
+				SYNDROME_FRAGMENT_REG_SIZE;
+			reg_val = elm_read_reg(offset);
+			reg_val |= ELM_SYNDROME_VALID;
+			elm_write_reg(offset, reg_val);
+		}
+	}
+}
+
+/**
+ * elm_error_correction - locate correctable error position
+ * @info:	elm info
+ * @err_vec:	elm error vectors
+ *
+ * On completion of processing by elm module, error location status
+ * register updated with correctable/uncorrectable error information.
+ * In case of correctable errors, number of errors located from
+ * elm location status register & read the these many positions from
+ * elm error location register.
+ */
+static void elm_error_correction(struct elm_info *info,
+		struct elm_errorvec *err_vec)
+{
+	int i, j, errors = 0;
+	void *err_loc_base = info->elm_base + ELM_ERROR_LOCATION_0;
+	elm_error_t *err_loc;
+	void *offset;
+	u32 reg_val;
+
+	for (i = 0; i < ERROR_VECTOR_MAX; i++) {
+		/* check error reported */
+		if (err_vec[i].error_reported) {
+			offset = info->elm_base + ELM_LOCATION_STATUS +
+				i * ERROR_LOCATION_SIZE;
+			reg_val = elm_read_reg(offset);
+			/* check correctable error or not */
+			if (reg_val & ECC_CORRECTABLE_MASK) {
+				err_loc = err_loc_base +
+					i * ERROR_LOCATION_SIZE;
+				/* read count of correctable errors */
+				err_vec[i].error_count = reg_val &
+					ECC_NB_ERRORS_MASK;
+
+				/* update the error locations in error vector */
+				for (j = 0; j < err_vec[i].error_count; j++) {
+
+					reg_val = elm_read_reg(*err_loc + j);
+					err_vec[i].error_loc[j] = reg_val &
+						ECC_ERROR_LOCATION_MASK;
+				}
+
+				errors += err_vec[i].error_count;
+			} else {
+				err_vec[i].error_uncorrectable++;
+			}
+
+			/* clearing interrupts for processed error vectors */
+			elm_write_reg(info->elm_base + ELM_IRQSTATUS, BIT(i));
+
+			/* disable page mode */
+			elm_configure_page_mode(info, i, false);
+		}
+	}
+
+	return;
+}
+
+/**
+ * elm_decode_bch_error_page - Locate error position
+ * @info:	elm info
+ * @ecc_calc:	calculated ECC bytes from GPMC
+ * @err_vec:	elm error vectors
+ *
+ * Called with one or greater reported and is vectors with error reported
+ * is updated in err_vec[].error_reported
+ */
+void elm_decode_bch_error_page(struct device *dev, u8 *ecc_calc,
+		struct elm_errorvec *err_vec)
+{
+	int i;
+	u8 syndrome[BCH_MAX_ECC_BYTES_PER_SECTOR] = {0}, *syn_p;
+	struct elm_info *info = dev_get_drvdata(dev);
+	u32 reg_val;
+
+	/* enable page mode interrupt */
+	reg_val = elm_read_reg(info->elm_base + ELM_IRQSTATUS);
+	elm_write_reg(info->elm_base + ELM_IRQSTATUS,
+			reg_val & INTR_STATUS_PAGE_VALID);
+	elm_write_reg(info->elm_base + ELM_IRQENABLE, INTR_EN_PAGE_MASK);
+
+	syn_p = syndrome;
+	for (i = 0; i < ERROR_VECTOR_MAX; i++) {
+		if (err_vec[i].error_reported) {
+			elm_reverse_eccdata(info, ecc_calc, syn_p);
+			elm_load_syndrome(info, i, syn_p);
+		}
+
+		ecc_calc += info->bch_type ? BCH8_SIZE : BCH4_SIZE;
+		syn_p += OOB_SECTOR_SIZE;
+	}
+
+	elm_start_processing(info, err_vec);
+
+	/*
+	 * In case of error reported, wait for ELM module to finish
+	 * locating error correction
+	 */
+	wait_for_completion(&info->elm_completion);
+
+	/* disable page mode interrupt */
+	reg_val = elm_read_reg(info->elm_base + ELM_IRQENABLE);
+	elm_write_reg(info->elm_base + ELM_IRQENABLE,
+			reg_val & ~INTR_EN_PAGE_MASK);
+	elm_error_correction(info, err_vec);
+}
+EXPORT_SYMBOL(elm_decode_bch_error_page);
+
+static irqreturn_t elm_isr(int this_irq, void *dev_id)
+{
+	u32 reg_val;
+	struct elm_info *info = dev_id;
+
+	reg_val = elm_read_reg(info->elm_base + ELM_IRQSTATUS);
+
+	/* all error vectors processed */
+	if (reg_val & INTR_STATUS_PAGE_VALID) {
+		elm_write_reg(info->elm_base + ELM_IRQSTATUS,
+				reg_val & INTR_STATUS_PAGE_VALID);
+		complete(&info->elm_completion);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+struct device *elm_request(enum bch_ecc bch_type)
+{
+	struct elm_info *info;
+
+	list_for_each_entry(info, &elm_devices, list) {
+		if (info && info->dev) {
+				info->bch_type = bch_type;
+				elm_config(info);
+				return info->dev;
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(elm_request);
+
+static int __devinit elm_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct resource *res, *irq;
+	struct elm_info *info;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	info->dev = &pdev->dev;
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq) {
+		dev_err(&pdev->dev, "no irq resource defined\n");
+		return -ENODEV;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		return -ENODEV;
+	}
+
+
+	info->elm_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!info->elm_base)
+		return -EADDRNOTAVAIL;
+
+
+	ret = devm_request_irq(&pdev->dev, irq->start, elm_isr, 0,
+			pdev->name, info);
+	if (ret) {
+		dev_err(&pdev->dev, "failure requesting irq %i\n", irq->start);
+		return ret;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	if (pm_runtime_get_sync(&pdev->dev)) {
+		ret = -EINVAL;
+		pm_runtime_disable(&pdev->dev);
+		dev_err(&pdev->dev, "can't enable clock\n");
+		return ret;
+	}
+
+	init_completion(&info->elm_completion);
+	INIT_LIST_HEAD(&info->list);
+	list_add(&info->list, &elm_devices);
+	platform_set_drvdata(pdev, info);
+	return ret;
+}
+
+static int __devexit elm_remove(struct platform_device *pdev)
+{
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+
+#ifdef CONFIG_OF
+static const struct of_device_id elm_of_match[] = {
+	{ .compatible = "ti,elm" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, elm_of_match);
+#endif
+
+static struct platform_driver elm_driver = {
+	.driver		= {
+		.name	= "elm",
+		.of_match_table = of_match_ptr(elm_of_match),
+		.owner	= THIS_MODULE,
+	},
+	.probe		= elm_probe,
+	.remove		= __devexit_p(elm_remove),
+};
+
+module_platform_driver(elm_driver);
+
+MODULE_DESCRIPTION("ELM driver for BCH error correction");
+MODULE_AUTHOR("Texas Instruments");
+MODULE_ALIAS("platform: elm");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/elm.h b/include/linux/platform_data/elm.h
new file mode 100644
index 0000000..eb53163
--- /dev/null
+++ b/include/linux/platform_data/elm.h
@@ -0,0 +1,60 @@
+/*
+ * BCH Error Location Module
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ELM_H
+#define __ELM_H
+
+enum bch_ecc {
+	BCH4_ECC = 0,
+	BCH8_ECC,
+	BCH16_ECC,
+};
+
+/* ELM support 8 error syndrome process */
+#define ERROR_VECTOR_MAX		8
+#define OOB_SECTOR_SIZE			16
+
+#define BCH_MAX_ECC_BYTES_PER_SECTOR	(OOB_SECTOR_SIZE * ERROR_VECTOR_MAX)
+
+#define BCH8_ECC_OOB_BYTES		13
+/* RBL requires 14 byte even though BCH8 uses only 13 byte */
+#define BCH8_SIZE			(BCH8_ECC_OOB_BYTES + 1)
+#define BCH4_SIZE			7
+
+#define	BCH8_SYNDROME_SIZE		4	/* 13 bytes of ecc */
+#define	BCH4_SYNDROME_SIZE		2	/* 7 bytes of ecc */
+
+/**
+ * struct elm_errorvec - error vector for elm
+ * @error_reported:		set true for vectors error is reported
+ *
+ * @error_count:		number of correctable errors in the sector
+ * @error_uncorrectable:	number of uncorrectable errors
+ * @error_loc:			buffer for error location
+ *
+ */
+struct elm_errorvec {
+	bool error_reported;
+	int error_count;
+	int error_uncorrectable;
+	int error_loc[ERROR_VECTOR_MAX];
+};
+
+void elm_decode_bch_error_page(struct device *dev, u8 *ecc_calc,
+		struct elm_errorvec *err_vec);
+struct device *elm_request(enum bch_ecc bch_type);
+#endif /* __ELM_H */
-- 
1.7.0.4

