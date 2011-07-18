Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1GRLPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:15:54 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:46804 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1GRLPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:15:53 -0400
X-ASG-Debug-ID: 1310987752-082ed9310001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        haojian.zhuang@marvell.com, nicolas.pitre@linaro.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH 2/2] ARM: mmp: add audio sram allocator
Subject: [PATCH 2/2] ARM: mmp: add audio sram allocator
Date: Mon, 18 Jul 2011 19:18:08 +0800
X-ASG-Orig-Subj: [PATCH 2/2] ARM: mmp: add audio sram allocator
Message-Id: <1310987888-541-3-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310987888-541-1-git-send-email-leoy@marvell.com>
References: <1310987888-541-1-git-send-email-leoy@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1310987752
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the audio sram allocator, so that can dynamically
allocated to several pcm devices.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm/Kconfig                            |    1 +
 arch/arm/mach-mmp/Makefile                  |    2 +-
 arch/arm/mach-mmp/audio_sram.c              |  118 +++++++++++++++++++++++++++
 arch/arm/mach-mmp/include/mach/audio_sram.h |   31 +++++++
 4 files changed, 151 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/audio_sram.c
 create mode 100644 arch/arm/mach-mmp/include/mach/audio_sram.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3eacf57..480e1524 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -546,6 +546,7 @@ config ARCH_MMP
 	select TICK_ONESHOT
 	select PLAT_PXA
 	select SPARSE_IRQ
+	select GENERIC_ALLOCATOR
 	help
 	  Support for Marvell's PXA168/PXA910(MMP) and MMP2 processor line.
 
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index b0ac942..290182b 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -7,7 +7,7 @@ obj-y				+= common.o clock.o devices.o time.o
 # SoC support
 obj-$(CONFIG_CPU_PXA168)	+= pxa168.o irq-pxa168.o
 obj-$(CONFIG_CPU_PXA910)	+= pxa910.o irq-pxa168.o
-obj-$(CONFIG_CPU_MMP2)		+= mmp2.o irq-mmp2.o
+obj-$(CONFIG_CPU_MMP2)		+= mmp2.o irq-mmp2.o audio_sram.o
 
 # board support
 obj-$(CONFIG_MACH_ASPENITE)	+= aspenite.o
diff --git a/arch/arm/mach-mmp/audio_sram.c b/arch/arm/mach-mmp/audio_sram.c
new file mode 100644
index 0000000..2d893fb
--- /dev/null
+++ b/arch/arm/mach-mmp/audio_sram.c
@@ -0,0 +1,118 @@
+/*
+ *  linux/arch/arm/mach-mmp/audio_sram.c
+ *
+ *  based on mach-davinci/sram.c - DaVinci simple SRAM allocator
+ *
+ *  Copyright (c) 2011 Marvell Semiconductors Inc.
+ *  All Rights Reserved
+ *
+ *  Add for mmp audio sram support - Leo Yan <leoy@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/genalloc.h>
+
+#include <mach/audio_sram.h>
+
+static struct gen_pool *sram_pool;
+static u32 audio_sram_phys;
+static void __iomem *audio_sram_virt;
+static u32 audio_sram_size;
+
+void *audio_sram_alloc(size_t len, dma_addr_t *dma)
+{
+	unsigned long vaddr;
+	dma_addr_t dma_base = (dma_addr_t)audio_sram_phys;
+
+	if (dma)
+		*dma = 0;
+	if (!sram_pool || (dma && !dma_base))
+		return NULL;
+
+	vaddr = gen_pool_alloc(sram_pool, len);
+	if (!vaddr)
+		return NULL;
+
+	if (dma)
+		*dma = dma_base + (vaddr - (unsigned long)audio_sram_virt);
+	return (void *)vaddr;
+}
+EXPORT_SYMBOL(audio_sram_alloc);
+
+void audio_sram_free(void *addr, size_t len)
+{
+	gen_pool_free(sram_pool, (unsigned long) addr, len);
+}
+EXPORT_SYMBOL(audio_sram_free);
+
+static int __devinit audio_sram_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	int ret = 0;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		ret = -ENODEV;
+		goto out;
+	}
+	audio_sram_phys = res->start;
+	audio_sram_size = res->end - res->start + 1;
+	audio_sram_virt = ioremap(audio_sram_phys, audio_sram_size);
+
+	sram_pool = gen_pool_create(ilog2(AUDIO_SRAM_GRANULARITY), -1);
+	if (!sram_pool) {
+		dev_err(&pdev->dev, "create pool failed\n");
+		ret = -ENOMEM;
+		goto create_pool_err;
+	}
+
+	ret = gen_pool_add(sram_pool, (unsigned long)audio_sram_virt,
+			   audio_sram_size, -1);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "add new chunk failed\n");
+		ret = -ENOMEM;
+		goto add_chunk_err;
+	}
+
+	return 0;
+
+add_chunk_err:
+	gen_pool_destroy(sram_pool);
+create_pool_err:
+	iounmap(audio_sram_virt);
+out:
+	return ret;
+}
+
+static int __devexit audio_sram_remove(struct platform_device *pdev)
+{
+	gen_pool_destroy(sram_pool);
+	iounmap(audio_sram_virt);
+	return 0;
+}
+
+static struct platform_driver audio_sram_driver = {
+	.probe		= audio_sram_probe,
+	.remove		= audio_sram_remove,
+	.driver		= {
+		.name	= "audio_sram",
+	},
+};
+
+static int __init audio_sram_init(void)
+{
+	return platform_driver_register(&audio_sram_driver);
+}
+core_initcall(audio_sram_init);
+
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/mach-mmp/include/mach/audio_sram.h b/arch/arm/mach-mmp/include/mach/audio_sram.h
new file mode 100644
index 0000000..08713f4
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/audio_sram.h
@@ -0,0 +1,31 @@
+/*
+ *  linux/arch/arm/mach-mmp/include/mach/audio_sram.h
+ *
+ *  PXA688 Audio SRAM Memory Management
+ *
+ *  Copyright (c) 2011 Marvell Semiconductors Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_ARCH_AUDIO_SRAM_H
+#define __ASM_ARCH_AUDIO_SRAM_H
+
+/* ARBITRARY:  SRAM allocations are multiples of this 2^N size */
+#define AUDIO_SRAM_GRANULARITY	1024
+
+/*
+ * SRAM allocations return a CPU virtual address, or NULL on error.
+ * If a DMA address is requested and the SRAM supports DMA, its
+ * mapped address is also returned.
+ *
+ * Errors include SRAM memory not being available, and requesting
+ * DMA mapped SRAM on systems which don't allow that.
+ */
+extern void *audio_sram_alloc(size_t len, dma_addr_t *dma);
+extern void audio_sram_free(void *addr, size_t len);
+
+#endif /* __ASM_ARCH_AUDIO_SRAM_H */
-- 
1.7.4.1

