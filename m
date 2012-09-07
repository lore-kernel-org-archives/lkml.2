Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2IGMoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:44:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56473 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab2IGMn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:43:59 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 4/6] ARM i.MX: remove IRAM_ALLOC facility
Date: Fri,  7 Sep 2012 14:43:46 +0200
Message-Id: <1347021828-23034-5-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347021828-23034-1-git-send-email-p.zabel@pengutronix.de>
References: <1347021828-23034-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A generic on-chip SRAM allocator driver can be used instead.
Users of the iram_alloc/free API should convert to the genalloc API:

-	virt = iram_alloc(SIZE, &phys);
+	gen_pool_alloc(iram_pool, SIZE);
+	phys = gen_pool_virt_to_phys(iram_pool, virt);
 	/* ... */
-	iram_free(virt, SIZE);
+	gen_pool_free(iram_pool, virt, SIZE);

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/plat-mxc/Kconfig             |    4 --
 arch/arm/plat-mxc/Makefile            |    1 -
 arch/arm/plat-mxc/include/mach/iram.h |   41 ------------------
 arch/arm/plat-mxc/iram_alloc.c        |   73 ---------------------------------
 4 files changed, 119 deletions(-)
 delete mode 100644 arch/arm/plat-mxc/include/mach/iram.h
 delete mode 100644 arch/arm/plat-mxc/iram_alloc.c

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index baf9064..8e63f10 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -82,8 +82,4 @@ config IMX_HAVE_IOMUX_V1
 config ARCH_MXC_IOMUX_V3
 	bool
 
-config IRAM_ALLOC
-	bool
-	select GENERIC_ALLOCATOR
-
 endif
diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index 6ac7200..bdf370f 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_MXC_AVIC) += avic.o
 
 obj-$(CONFIG_IMX_HAVE_IOMUX_V1) += iomux-v1.o
 obj-$(CONFIG_ARCH_MXC_IOMUX_V3) += iomux-v3.o
-obj-$(CONFIG_IRAM_ALLOC) += iram_alloc.o
 obj-$(CONFIG_MXC_ULPI) += ulpi.o
 obj-$(CONFIG_MXC_USE_EPIT) += epit.o
 obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
diff --git a/arch/arm/plat-mxc/include/mach/iram.h b/arch/arm/plat-mxc/include/mach/iram.h
deleted file mode 100644
index 022690c..0000000
--- a/arch/arm/plat-mxc/include/mach/iram.h
+++ /dev/null
@@ -1,41 +0,0 @@
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
-int __init iram_init(unsigned long base, unsigned long size);
-void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr);
-void iram_free(unsigned long dma_addr, unsigned int size);
-
-#else
-
-static inline int __init iram_init(unsigned long base, unsigned long size)
-{
-	return -ENOMEM;
-}
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
deleted file mode 100644
index 074c386..0000000
--- a/arch/arm/plat-mxc/iram_alloc.c
+++ /dev/null
@@ -1,73 +0,0 @@
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
-
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/genalloc.h>
-#include <mach/iram.h>
-
-static unsigned long iram_phys_base;
-static void __iomem *iram_virt_base;
-static struct gen_pool *iram_pool;
-
-static inline void __iomem *iram_phys_to_virt(unsigned long p)
-{
-	return iram_virt_base + (p - iram_phys_base);
-}
-
-void __iomem *iram_alloc(unsigned int size, unsigned long *dma_addr)
-{
-	if (!iram_pool)
-		return NULL;
-
-	*dma_addr = gen_pool_alloc(iram_pool, size);
-	pr_debug("iram alloc - %dB@0x%lX\n", size, *dma_addr);
-	if (!*dma_addr)
-		return NULL;
-	return iram_phys_to_virt(*dma_addr);
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
-int __init iram_init(unsigned long base, unsigned long size)
-{
-	iram_phys_base = base;
-
-	iram_pool = gen_pool_create(PAGE_SHIFT, -1);
-	if (!iram_pool)
-		return -ENOMEM;
-
-	gen_pool_add(iram_pool, base, size, -1);
-	iram_virt_base = ioremap(iram_phys_base, size);
-	if (!iram_virt_base)
-		return -EIO;
-
-	pr_debug("i.MX IRAM pool: %ld KB@0x%p\n", size / 1024, iram_virt_base);
-	return 0;
-}
-- 
1.7.10.4

