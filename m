Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab2EXQrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:47:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36268 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab2EXQrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:47:39 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 2/2] regmap: mmio: request native endian formatting
Date: Thu, 24 May 2012 10:47:27 -0600
Message-Id: <1337878047-21177-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337878047-21177-1-git-send-email-swarren@wwwdotorg.org>
References: <1337878047-21177-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This will avoid the regmap core converting all addresses and values into
big endian, only for the mmio bus driver to have to convert them back to
native endian.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Validate the the regmap_config specifies default or native endianness
for the register format.
---
 drivers/base/regmap/regmap-mmio.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index febd6de..eec8663 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -37,7 +37,7 @@ static int regmap_mmio_gather_write(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	offset = be32_to_cpup(reg);
+	offset = *(u32 *)reg;
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
@@ -45,14 +45,14 @@ static int regmap_mmio_gather_write(void *context,
 			writeb(*(u8 *)val, ctx->regs + offset);
 			break;
 		case 2:
-			writew(be16_to_cpup(val), ctx->regs + offset);
+			writew(*(u16 *)val, ctx->regs + offset);
 			break;
 		case 4:
-			writel(be32_to_cpup(val), ctx->regs + offset);
+			writel(*(u32 *)val, ctx->regs + offset);
 			break;
 #ifdef CONFIG_64BIT
 		case 8:
-			writeq(be64_to_cpup(val), ctx->regs + offset);
+			writeq(*(u64 *)val, ctx->regs + offset);
 			break;
 #endif
 		default:
@@ -83,7 +83,7 @@ static int regmap_mmio_read(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	offset = be32_to_cpup(reg);
+	offset = *(u32 *)reg;
 
 	while (val_size) {
 		switch (ctx->val_bytes) {
@@ -91,14 +91,14 @@ static int regmap_mmio_read(void *context,
 			*(u8 *)val = readb(ctx->regs + offset);
 			break;
 		case 2:
-			*(u16 *)val = cpu_to_be16(readw(ctx->regs + offset));
+			*(u16 *)val = readw(ctx->regs + offset);
 			break;
 		case 4:
-			*(u32 *)val = cpu_to_be32(readl(ctx->regs + offset));
+			*(u32 *)val = readl(ctx->regs + offset);
 			break;
 #ifdef CONFIG_64BIT
 		case 8:
-			*(u64 *)val = cpu_to_be32(readq(ctx->regs + offset));
+			*(u64 *)val = readq(ctx->regs + offset);
 			break;
 #endif
 		default:
@@ -124,6 +124,8 @@ static struct regmap_bus regmap_mmio = {
 	.gather_write = regmap_mmio_gather_write,
 	.read = regmap_mmio_read,
 	.free_context = regmap_mmio_free_context,
+	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
 };
 
 struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
@@ -162,6 +164,14 @@ struct regmap_mmio_context *regmap_mmio_gen_context(void __iomem *regs,
 	if (config->reg_stride < min_stride)
 		return ERR_PTR(-EINVAL);
 
+	switch (config->reg_format_endian) {
+	case REGMAP_ENDIAN_DEFAULT:
+	case REGMAP_ENDIAN_NATIVE:
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
 	ctx = kzalloc(GFP_KERNEL, sizeof(*ctx));
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
-- 
1.7.0.4

