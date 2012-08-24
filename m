Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab2HXJSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:18:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48102 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2HXJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:18:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/5] ARM i.MX: Remove iram_alloc/free, as they are unused in-tree
Date: Fri, 24 Aug 2012 11:17:46 +0200
Message-Id: <1345799866-19876-6-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
References: <1345799866-19876-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of the iram_alloc/free API should
convert to the genalloc API instead:

-	virt = iram_alloc(SIZE, &phys);
+	gen_pool_alloc(iram_pool, SIZE);
+	phys = gen_pool_virt_to_phys(iram_pool, virt);
 	/* ... */
-	iram_free(virt, SIZE);
+	gen_pool_free(iram_pool, virt, SIZE);

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/iram.h |   35 ---------------------------------
 arch/arm/plat-mxc/iram_alloc.c        |   26 ------------------------
 2 files changed, 61 deletions(-)
 delete mode 100644 arch/arm/plat-mxc/include/mach/iram.h

diff --git a/arch/arm/plat-mxc/include/mach/iram.h b/arch/arm/plat-mxc/include/mach/iram.h
deleted file mode 100644
index d5c863f..0000000
--- a/arch/arm/plat-mxc/include/mach/iram.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA 02110-1301, USA.
- */
-#include <linux/errno.h>
-
-#ifdef CONFIG_IRAM_ALLOC
-
-void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
-void iram_free(unsigned long dma_addr, unsigned int size);
-
-#else
-
-static inline void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
-{
-	return NULL;
-}
-
-static inline void iram_free(unsigned long base, unsigned long size) {}
-
-#endif
diff --git a/arch/arm/plat-mxc/iram_alloc.c b/arch/arm/plat-mxc/iram_alloc.c
index 343e96d..0eed213 100644
--- a/arch/arm/plat-mxc/iram_alloc.c
+++ b/arch/arm/plat-mxc/iram_alloc.c
@@ -28,32 +28,6 @@
 
 static struct gen_pool *iram_pool;
 
-void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
-{
-	unsigned long virt;
-
-	if (!iram_pool)
-		return NULL;
-
-	virt = gen_pool_alloc(iram_pool, size);
-	pr_debug("iram alloc - %dB@0x%lX\n", size, *dma_addr);
-	if (!virt)
-		return NULL;
-
-	*dma_addr = gen_pool_virt_to_phys(iram_pool, virt);
-	return (void __iomem *)virt;
-}
-EXPORT_SYMBOL(iram_alloc);
-
-void iram_free(unsigned long addr, unsigned int size)
-{
-	if (!iram_pool)
-		return;
-
-	gen_pool_free(iram_pool, addr, size);
-}
-EXPORT_SYMBOL(iram_free);
-
 static int __devinit iram_probe(struct platform_device *pdev)
 {
 	void __iomem *virt_base;
-- 
1.7.10.4

