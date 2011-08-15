Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1HODHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:07:52 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:33221 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1HODHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:07:37 -0400
X-ASG-Debug-ID: 1313377657-082c21200001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH 1/3] ARM: mmp: add sram allocator
Subject: [PATCH 1/3] ARM: mmp: add sram allocator
Date: Mon, 15 Aug 2011 11:09:52 +0800
X-ASG-Orig-Subj: [PATCH 1/3] ARM: mmp: add sram allocator
Message-Id: <1313377794-26721-2-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313377794-26721-1-git-send-email-leoy@marvell.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313377656
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mmp platform, there have two sram banks:
audio sram and internal sram. The audio sram is mainly for audio;
the internal sram is for video, wtm and power management.
So add the sram allocator using genalloc to manage them.

Every sram bank will register its own platform device
info, after the sram allocator create the generic pool
for the sram bank, the user module can use the pool's
name to get the pool handler; then it can use the handler
to alloc/free memory with genalloc APIs.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm/Kconfig                      |    1 +
 arch/arm/mach-mmp/Makefile            |    2 +-
 arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
 arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
 create mode 100644 arch/arm/mach-mmp/sram.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c71a8f..c7545d1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -559,6 +559,7 @@ config ARCH_MMP
 	select TICK_ONESHOT
 	select PLAT_PXA
 	select SPARSE_IRQ
+	select GENERIC_ALLOCATOR
 	help
 	  Support for Marvell's PXA168/PXA910(MMP) and MMP2 processor line.
 
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index b0ac942..169c674 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -7,7 +7,7 @@ obj-y				+= common.o clock.o devices.o time.o
 # SoC support
 obj-$(CONFIG_CPU_PXA168)	+= pxa168.o irq-pxa168.o
 obj-$(CONFIG_CPU_PXA910)	+= pxa910.o irq-pxa168.o
-obj-$(CONFIG_CPU_MMP2)		+= mmp2.o irq-mmp2.o
+obj-$(CONFIG_CPU_MMP2)		+= mmp2.o irq-mmp2.o sram.o
 
 # board support
 obj-$(CONFIG_MACH_ASPENITE)	+= aspenite.o
diff --git a/arch/arm/mach-mmp/include/mach/sram.h b/arch/arm/mach-mmp/include/mach/sram.h
new file mode 100644
index 0000000..239e0fc
--- /dev/null
+++ b/arch/arm/mach-mmp/include/mach/sram.h
@@ -0,0 +1,35 @@
+/*
+ *  linux/arch/arm/mach-mmp/include/mach/sram.h
+ *
+ *  SRAM Memory Management
+ *
+ *  Copyright (c) 2011 Marvell Semiconductors Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_ARCH_SRAM_H
+#define __ASM_ARCH_SRAM_H
+
+#include <linux/genalloc.h>
+
+/* ARBITRARY:  SRAM allocations are multiples of this 2^N size */
+#define SRAM_GRANULARITY	512
+
+enum sram_type {
+	MMP_SRAM_UNDEFINED = 0,
+	MMP_ASRAM,
+	MMP_ISRAM,
+};
+
+struct sram_platdata {
+	char *pool_name;
+	int granularity;
+};
+
+extern struct gen_pool *sram_get_gpool(char *pool_name);
+
+#endif /* __ASM_ARCH_SRAM_H */
diff --git a/arch/arm/mach-mmp/sram.c b/arch/arm/mach-mmp/sram.c
new file mode 100644
index 0000000..4304f95
--- /dev/null
+++ b/arch/arm/mach-mmp/sram.c
@@ -0,0 +1,168 @@
+/*
+ *  linux/arch/arm/mach-mmp/sram.c
+ *
+ *  based on mach-davinci/sram.c - DaVinci simple SRAM allocator
+ *
+ *  Copyright (c) 2011 Marvell Semiconductors Inc.
+ *  All Rights Reserved
+ *
+ *  Add for mmp sram support - Leo Yan <leoy@marvell.com>
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
+#include <linux/slab.h>
+#include <linux/genalloc.h>
+
+#include <mach/sram.h>
+
+struct sram_bank_info {
+	char *pool_name;
+	struct gen_pool *gpool;
+	int granularity;
+
+	phys_addr_t sram_phys;
+	void __iomem *sram_virt;
+	u32 sram_size;
+
+	struct list_head node;
+};
+
+static DEFINE_MUTEX(sram_lock);
+static LIST_HEAD(sram_bank_list);
+
+struct gen_pool *sram_get_gpool(char *pool_name)
+{
+	struct sram_bank_info *info = NULL;
+
+	if (!pool_name)
+		return NULL;
+
+	mutex_lock(&sram_lock);
+
+	list_for_each_entry(info, &sram_bank_list, node)
+		if (!strcmp(pool_name, info->pool_name))
+			break;
+
+	mutex_unlock(&sram_lock);
+
+	if (&info->node == &sram_bank_list)
+		return NULL;
+
+	return info->gpool;
+}
+EXPORT_SYMBOL(sram_get_gpool);
+
+static int __devinit sram_probe(struct platform_device *pdev)
+{
+	struct sram_platdata *pdata = pdev->dev.platform_data;
+	struct sram_bank_info *info;
+	struct resource *res;
+	int ret = 0;
+
+	if (!pdata && !pdata->pool_name)
+		return -ENODEV;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!resource_size(res))
+		return 0;
+
+	info->sram_phys   = (phys_addr_t)res->start;
+	info->sram_size   = resource_size(res);
+	info->sram_virt   = ioremap(info->sram_phys, info->sram_size);
+	info->pool_name	  = kstrdup(pdata->pool_name, GFP_KERNEL);
+	info->granularity = pdata->granularity;
+
+	info->gpool = gen_pool_create(ilog2(info->granularity), -1);
+	if (!info->gpool) {
+		dev_err(&pdev->dev, "create pool failed\n");
+		ret = -ENOMEM;
+		goto create_pool_err;
+	}
+
+	ret = gen_pool_add_virt(info->gpool, (unsigned long)info->sram_virt,
+				info->sram_phys, info->sram_size, -1);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "add new chunk failed\n");
+		ret = -ENOMEM;
+		goto add_chunk_err;
+	}
+
+	mutex_lock(&sram_lock);
+	list_add(&info->node, &sram_bank_list);
+	mutex_unlock(&sram_lock);
+
+	platform_set_drvdata(pdev, info);
+
+	dev_info(&pdev->dev, "initialized\n");
+	return 0;
+
+add_chunk_err:
+	gen_pool_destroy(info->gpool);
+create_pool_err:
+	iounmap(info->sram_virt);
+	kfree(info->pool_name);
+out:
+	kfree(info);
+	return ret;
+}
+
+static int __devexit sram_remove(struct platform_device *pdev)
+{
+	struct sram_bank_info *info;
+
+	info = platform_get_drvdata(pdev);
+	if (info == NULL)
+		return -ENODEV;
+
+	mutex_lock(&sram_lock);
+	list_del(&info->node);
+	mutex_unlock(&sram_lock);
+
+	gen_pool_destroy(info->gpool);
+	iounmap(info->sram_virt);
+	kfree(info->pool_name);
+	kfree(info);
+	return 0;
+}
+
+static const struct platform_device_id sram_id_table[] = {
+	{ "asram", MMP_ASRAM },
+	{ "isram", MMP_ISRAM },
+	{ }
+};
+
+static struct platform_driver sram_driver = {
+	.probe		= sram_probe,
+	.remove		= sram_remove,
+	.driver		= {
+		.name	= "mmp-sram",
+	},
+	.id_table	= sram_id_table,
+};
+
+static int __init sram_init(void)
+{
+	return platform_driver_register(&sram_driver);
+}
+core_initcall(sram_init);
+
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

