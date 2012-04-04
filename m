Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2DDVss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:48:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39735 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2DDVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:48:45 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 4/6] regmap: add MMIO bus support
Date: Wed,  4 Apr 2012 15:48:31 -0600
Message-Id: <1333576113-13196-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This is a basic memory-mapped-IO bus for regmap. It has the following
features and limitations:

* Registers themselves may be 8, 16, 32, or 64-bit. 64-bit is only
  supported on 64-bit platforms.
* Register offsets are limited to precisely 32-bit.
* IO is performed using readl/writel, with no provision for using the
  __raw_readl or readl_relaxed variants.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/Kconfig       |    3 +
 drivers/base/regmap/Makefile      |    1 +
 drivers/base/regmap/regmap-mmio.c |  217 +++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |    6 +
 4 files changed, 227 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/regmap/regmap-mmio.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 0f6c7fb..9ef0a53 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -14,5 +14,8 @@ config REGMAP_I2C
 config REGMAP_SPI
 	tristate
 
+config REGMAP_MMIO
+	tristate
+
 config REGMAP_IRQ
 	bool
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index defd579..5e75d1b 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -3,4 +3,5 @@ obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
+obj-$(CONFIG_REGMAP_MMIO) += regmap-mmio.o
 obj-$(CONFIG_REGMAP_IRQ) += regmap-irq.o
diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
new file mode 100644
index 0000000..1a7b5ee
--- /dev/null
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -0,0 +1,217 @@
+/*
+ * Register map access API - MMIO support
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+struct regmap_mmio_context {
+	void __iomem *regs;
+	unsigned val_bytes;
+};
+
+static int regmap_mmio_gather_write(void *context,
+				    const void *reg, size_t reg_size,
+				    const void *val, size_t val_size)
+{
+	struct regmap_mmio_context *ctx = context;
+	u32 offset;
+
+	if (reg_size != 4)
+		return -EIO;
+	if (val_size % ctx->val_bytes)
+		return -EIO;
+
+	offset = be32_to_cpup(reg);
+
+	while (val_size) {
+		switch (ctx->val_bytes) {
+		case 1:
+			writeb(*(u8 *)val, ctx->regs + offset);
+			break;
+		case 2:
+			writew(be16_to_cpup(val), ctx->regs + offset);
+			break;
+		case 4:
+			writel(be32_to_cpup(val), ctx->regs + offset);
+			break;
+#ifdef CONFIG_64BIT
+		case 8:
+			writeq(be64_to_cpup(val), ctx->regs + offset);
+			break;
+#endif
+		default:
+			/* Should be caught by regmap_mmio_check_config */
+			return -EIO;
+		}
+		val_size -= ctx->val_bytes;
+		val += ctx->val_bytes;
+		offset += ctx->val_bytes;
+	}
+
+	return 0;
+}
+
+static int regmap_mmio_write(void *context, const void *data, size_t count)
+{
+	if (count < 4)
+		return -EIO;
+	return regmap_mmio_gather_write(context, data, 4, data + 4, count - 4);
+}
+
+static int regmap_mmio_read(void *context,
+			    const void *reg, size_t reg_size,
+			    void *val, size_t val_size)
+{
+	struct regmap_mmio_context *ctx = context;
+	u32 offset;
+
+	if (reg_size != 4)
+		return -EIO;
+	if (val_size % ctx->val_bytes)
+		return -EIO;
+
+	offset = be32_to_cpup(reg);
+
+	while (val_size) {
+		switch (ctx->val_bytes) {
+		case 1:
+			*(u8 *)val = readb(ctx->regs + offset);
+			break;
+		case 2:
+			*(u16 *)val = cpu_to_be16(readw(ctx->regs + offset));
+			break;
+		case 4:
+			*(u32 *)val = cpu_to_be32(readl(ctx->regs + offset));
+			break;
+#ifdef CONFIG_64BIT
+		case 8:
+			*(u64 *)val = cpu_to_be32(readq(ctx->regs + offset));
+			break;
+#endif
+		default:
+			/* Should be caught by regmap_mmio_check_config */
+			return -EIO;
+		}
+		val_size -= ctx->val_bytes;
+		val += ctx->val_bytes;
+		offset += ctx->val_bytes;
+	}
+
+	return 0;
+}
+
+static void regmap_mmio_free_context(void *context)
+{
+	kfree(context);
+}
+
+static struct regmap_bus regmap_mmio = {
+	.fast_io = true,
+	.write = regmap_mmio_write,
+	.gather_write = regmap_mmio_gather_write,
+	.read = regmap_mmio_read,
+	.free_context = regmap_mmio_free_context,
+};
+
+struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
+					const struct regmap_config *config)
+{
+	struct regmap_mmio_context *ctx;
+
+	if (config->reg_bits != 32)
+		return ERR_PTR(-EINVAL);
+
+	if (config->pad_bits)
+		return ERR_PTR(-EINVAL);
+
+	switch (config->val_bits) {
+	case 8:
+	case 16:
+	case 32:
+#ifdef CONFIG_64BIT
+	case 64:
+#endif
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	ctx = kzalloc(GFP_KERNEL, sizeof(*ctx));
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	ctx->regs = regs;
+	ctx->val_bytes = config->val_bits / 8;
+
+	return ctx;
+}
+
+/**
+ * regmap_init_mmio(): Initialise register map
+ *
+ * @dev: Device that will be interacted with
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_mmio(struct device *dev,
+				void __iomem *regs,
+				const struct regmap_config *config)
+{
+	struct regmap_mmio_context *ctx;
+
+	ctx = regmap_mmio_gen_context(regs, config);
+	if (IS_ERR(ctx))
+		return ERR_CAST(ctx);
+
+	return regmap_init(dev, &regmap_mmio, ctx, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_mmio);
+
+/**
+ * devm_regmap_init_mmio(): Initialise managed register map
+ *
+ * @dev: Device that will be interacted with
+ * @regs: Pointer to memory-mapped IO region
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_mmio(struct device *dev,
+				     void __iomem *regs,
+				     const struct regmap_config *config)
+{
+	struct regmap_mmio_context *ctx;
+
+	ctx = regmap_mmio_gen_context(regs, config);
+	if (IS_ERR(ctx))
+		return ERR_CAST(ctx);
+
+	return devm_regmap_init(dev, &regmap_mmio, ctx, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_mmio);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 3ff16f0..680ddd7 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -142,6 +142,9 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
+struct regmap *regmap_init_mmio(struct device *dev,
+				void __iomem *regs,
+				const struct regmap_config *config);
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
@@ -151,6 +154,9 @@ struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
 struct regmap *devm_regmap_init_spi(struct spi_device *dev,
 				    const struct regmap_config *config);
+struct regmap *devm_regmap_init_mmio(struct device *dev,
+				     void __iomem *regs,
+				     const struct regmap_config *config);
 
 void regmap_exit(struct regmap *map);
 int regmap_reinit_cache(struct regmap *map,
-- 
1.7.0.4

