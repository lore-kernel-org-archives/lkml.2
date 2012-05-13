Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2EMBAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 21:00:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab2EMBAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 21:00:15 -0400
From: Richard Zhao <richard.zhao@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: sameo@linux.intel.com, paul.liu@linaro.org,
        broonie@opensource.wolfsonmicro.com, shawn.guo@linaro.org,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH 2/2] mfd: anatop: permit adata be NULL when access register
Date: Sun, 13 May 2012 08:59:54 +0800
Message-Id: <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes anatop register access easier. Anatop has many misc registers,
which may not be a specific driver.

There's only one anatop device for a running system, so we use a global
variable to store struct anatop.

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
---
 drivers/mfd/anatop-mfd.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
index 3bb7c49..b0313210 100644
--- a/drivers/mfd/anatop-mfd.c
+++ b/drivers/mfd/anatop-mfd.c
@@ -41,8 +41,15 @@
 #include <linux/of_address.h>
 #include <linux/mfd/anatop.h>
 
+/* For any running system, there's only one anatop device. */
+static struct anatop *anatop_data;
+
 u32 anatop_read_reg(struct anatop *adata, u32 addr)
 {
+	BUG_ON(!anatop_data);
+	if (!adata)
+		adata = anatop_data;
+
 	return readl(adata->ioreg + addr);
 }
 EXPORT_SYMBOL_GPL(anatop_read_reg);
@@ -51,6 +58,10 @@ void anatop_write_reg(struct anatop *adata, u32 addr, u32 data, u32 mask)
 {
 	u32 val;
 
+	BUG_ON(!anatop_data);
+	if (!adata)
+		adata = anatop_data;
+
 	data &= mask;
 
 	spin_lock(&adata->reglock);
@@ -83,6 +94,7 @@ static int __devinit of_anatop_probe(struct platform_device *pdev)
 	drvdata->ioreg = ioreg;
 	spin_lock_init(&drvdata->reglock);
 	platform_set_drvdata(pdev, drvdata);
+	anatop_data = drvdata;
 	of_platform_populate(np, of_anatop_match, NULL, dev);
 
 	return 0;
-- 
1.7.9.5

