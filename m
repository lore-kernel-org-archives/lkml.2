Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1JYJut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:50:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41435 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab1JYJtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:49:04 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 5/7] ARM: OMAP: add amp/remoteproc support
Date: Tue, 25 Oct 2011 11:48:24 +0200
Message-Id: <1319536106-25802-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an omap-rproc device with which one can start using OMAP4's
dual-M3 "Ducati" ipu subsystem.

Currently we're adding support only for the first M3 core (hence
the name "ipu_c0"); support for the second M3 core, as well as for
the DSP subsystem, will be added later on.

Bind this device to its dedicated IOMMU device, and assign it a
dedicated mailbox instance too.

In addition, reserve it a physically contiguous memory region using
the upcoming CMA mechanism (this makes this patch impossible to merge
at this point, but this patch only).

This patch also depends on:
- https://lkml.org/lkml/2011/9/25/44
- http://www.spinics.net/lists/linux-omap/msg59342.html

Note: at this point we're using a fixed CMA base address (as defined by
OMAP_RPROC_CMA_BASE), but this will go away once the generic iommu-based
DMA API will materialize, because at that point we will (almost) not care about
the physical location of the CMA memory.

Based on (but now quite far from) work done by Fernando Guzman Lugo
<fernando.lugo@ti.com>.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 MAINTAINERS                      |    6 ++
 arch/arm/mach-omap2/Makefile     |    4 +
 arch/arm/mach-omap2/remoteproc.c |  167 ++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/common.c      |    3 +-
 drivers/amp/remoteproc/Kconfig   |   14 +++-
 5 files changed, 192 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/mach-omap2/remoteproc.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2812cd7..db3b08a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4597,6 +4597,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
 F:	arch/arm/*omap*/
 
+OMAP ASYNCHRONOUS MULTIPROCESSING (AMP) SUPPORT
+M:	Ohad Ben-Cohen <ohad@wizery.com>
+L:	linux-omap@vger.kernel.org
+S:	Maintained
+F:	arch/arm/*omap*/*remoteproc*
+
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 5129785..6b567ea 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -270,3 +270,7 @@ disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
 
 obj-y					+= common-board-devices.o twl-common.o
+
+ifneq ($(CONFIG_OMAP_REMOTEPROC),)
+obj-y					+= remoteproc.o
+endif
diff --git a/arch/arm/mach-omap2/remoteproc.c b/arch/arm/mach-omap2/remoteproc.c
new file mode 100644
index 0000000..342d446
--- /dev/null
+++ b/arch/arm/mach-omap2/remoteproc.c
@@ -0,0 +1,167 @@
+/*
+ * Remote processor machine-specific module for OMAP4
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/amp/remoteproc.h>
+#include <linux/dma-contiguous.h>
+#include <linux/dma-mapping.h>
+
+#include <plat/omap_device.h>
+#include <plat/omap_hwmod.h>
+#include <plat/remoteproc.h>
+#include <plat/iommu.h>
+
+/*
+ * Temporarily define the CMA base address explicitly.
+ *
+ * This will go away as soon as we have the IOMMU-based generic
+ * DMA API in place.
+ */
+#define OMAP_RPROC_CMA_BASE	(0xa9800000)
+
+/*
+ * These data structures define platform-specific information
+ * needed for each supported remote processor.
+ *
+ * At this point we only support the remote dual M3 "Ducati" imaging
+ * subsystem (aka "ipu"), but later on we'll also add support for the
+ * DSP ("Tesla").
+ */
+static struct omap_rproc_pdata omap4_rproc_data[] = {
+	{
+		.name		= "ipu_c0",
+		.firmware	= "ducati-m3-core0.xem3",
+		.mbox_name	= "mailbox-1",
+		.oh_name	= "ipu_c0",
+	},
+};
+
+static struct omap_iommu_arch_data omap4_rproc_iommu[] = {
+	{ .name = "ducati" },
+};
+
+static struct omap_device_pm_latency omap_rproc_latency[] = {
+	{
+		.deactivate_func = omap_device_idle_hwmods,
+		.activate_func = omap_device_enable_hwmods,
+		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
+	},
+};
+
+static struct platform_device omap4_ducati = {
+	.name	= "omap-rproc",
+	.id	= 1, /* reserve 0 for tesla. we respect. */
+};
+
+static struct platform_device *omap4_rproc_devs[] __initdata = {
+	&omap4_ducati,
+};
+
+void __init omap_rproc_reserve_cma(void)
+{
+	int ret;
+
+	/* reserve CMA memory for OMAP4's M3 "ducati" remote processor */
+	ret = dma_declare_contiguous(&omap4_ducati.dev,
+					CONFIG_OMAP_DUCATI_CMA_SIZE,
+					OMAP_RPROC_CMA_BASE, 0);
+	if (ret)
+		pr_err("dma_declare_contiguous failed %d\n", ret);
+}
+
+static int __init omap_rproc_init(void)
+{
+	struct omap_hwmod *oh[2];
+	struct omap_device *od;
+	int i, ret = 0, oh_count;
+
+	/* names like ipu_cx/dsp_cx might show up on other OMAPs, too */
+	if (!cpu_is_omap44xx())
+		return 0;
+
+	/* build the remote proc devices */
+	for (i = 0; i < ARRAY_SIZE(omap4_rproc_data); i++) {
+		const char *oh_name = omap4_rproc_data[i].oh_name;
+		const char *oh_name_opt = omap4_rproc_data[i].oh_name_opt;
+		struct platform_device *pdev = omap4_rproc_devs[i];
+		oh_count = 0;
+
+		oh[0] = omap_hwmod_lookup(oh_name);
+		if (!oh[0]) {
+			pr_err("could not look up %s\n", oh_name);
+			continue;
+		}
+		oh_count++;
+
+		/*
+		 * ipu might have a secondary hwmod entry (for configurations
+		 * where we want both M3 cores to be represented by a single
+		 * device).
+		 */
+		if (oh_name_opt) {
+			oh[1] = omap_hwmod_lookup(oh_name_opt);
+			if (!oh[1]) {
+				pr_err("could not look up %s\n", oh_name_opt);
+				continue;
+			}
+			oh_count++;
+		}
+
+		omap4_rproc_data[i].device_enable = omap_device_enable;
+		omap4_rproc_data[i].device_shutdown = omap_device_shutdown;
+
+		device_initialize(&pdev->dev);
+
+		/* Set dev_name early to allow dev_xxx in omap_device_alloc */
+		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
+
+		od = omap_device_alloc(pdev, oh, oh_count,
+					omap_rproc_latency,
+					ARRAY_SIZE(omap_rproc_latency));
+		if (!od) {
+			dev_err(&pdev->dev, "omap_device_alloc failed\n");
+			put_device(&pdev->dev);
+			ret = PTR_ERR(od);
+			continue;
+		}
+
+		ret = platform_device_add_data(pdev,
+					&omap4_rproc_data[i],
+					sizeof(struct omap_rproc_pdata));
+		if (ret) {
+			dev_err(&pdev->dev, "can't add pdata\n");
+			omap_device_delete(od);
+			put_device(&pdev->dev);
+			continue;
+		}
+
+		/* attach the remote processor to its iommu device */
+		pdev->dev.archdata.iommu = &omap4_rproc_iommu[i];
+
+		ret = omap_device_register(pdev);
+		if (ret) {
+			dev_err(&pdev->dev, "omap_device_register failed\n");
+			omap_device_delete(od);
+			put_device(&pdev->dev);
+			continue;
+		}
+	}
+
+	return ret;
+}
+device_initcall(omap_rproc_init);
diff --git a/arch/arm/plat-omap/common.c b/arch/arm/plat-omap/common.c
index d9f10a3..e2aa143 100644
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -20,7 +20,7 @@
 #include <plat/board.h>
 #include <plat/vram.h>
 #include <plat/dsp.h>
-
+#include <plat/remoteproc.h>
 
 #define NO_LENGTH_CHECK 0xffffffff
 
@@ -65,4 +65,5 @@ void __init omap_reserve(void)
 	omapfb_reserve_sdram_memblock();
 	omap_vram_reserve_sdram_memblock();
 	omap_dsp_reserve_sdram_memblock();
+	omap_rproc_reserve_cma();
 }
diff --git a/drivers/amp/remoteproc/Kconfig b/drivers/amp/remoteproc/Kconfig
index 78ebff9..e1c617e 100644
--- a/drivers/amp/remoteproc/Kconfig
+++ b/drivers/amp/remoteproc/Kconfig
@@ -21,4 +21,16 @@ config OMAP_REMOTEPROC
 	  offloaded to remote DSP processors using this framework).
 
 	  It's safe to say n here if you're not interested in multimedia
-	  offloading or just want a bare minimum kernel.
\ No newline at end of file
+	  offloading or just want a bare minimum kernel.
+
+# Amount of CMA memory to reserve for OMAP's dual-M3 "Ducati" sub-system.
+# We need quite much. Fortunately, CMA makes sure this memory isn't
+# wasted in case we're not loading the remote processors.
+config OMAP_DUCATI_CMA_SIZE
+	hex "Ducati M3 physically contiguous memory pool size (in bytes)"
+	depends on OMAP_REMOTEPROC
+	default 0x6500000
+	help
+	  Allocate a specified size of physically contiguous memory (CMA)
+	  for OMAP's dual M3 "Ducati" sub-system. Vast majority of this
+	  memory isn't wasted in case the M3 sub-system isn't loaded.
-- 
1.7.5.4

