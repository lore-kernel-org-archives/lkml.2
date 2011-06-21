Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1FUHXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:23:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1FUHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:22:14 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 4/8] omap: add remoteproc devices
Date: Tue, 21 Jun 2011 10:18:30 +0300
Message-Id: <1308640714-17961-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1308640714-17961-1-git-send-email-ohad@wizery.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guzman Lugo, Fernando <fernando.lugo@ti.com>

Add omap remoteproc devices for the ipu and dsp remote processors.

TODO:
- rework to use CMA instead of reserving memory at boot

[ohad@wizery.com: commit log, refactored and simplified, still wip]

Signed-off-by: Guzman Lugo, Fernando <fernando.lugo@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/Makefile     |    2 +
 arch/arm/mach-omap2/remoteproc.c |  159 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/remoteproc.c

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index b148077..2b04fe6 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -270,3 +270,5 @@ disp-$(CONFIG_OMAP2_DSS)		:= display.o
 obj-y					+= $(disp-m) $(disp-y)
 
 obj-y					+= common-board-devices.o
+
+obj-$(CONFIG_OMAP_REMOTE_PROC)		+= remoteproc.o
diff --git a/arch/arm/mach-omap2/remoteproc.c b/arch/arm/mach-omap2/remoteproc.c
new file mode 100644
index 0000000..4f846cb
--- /dev/null
+++ b/arch/arm/mach-omap2/remoteproc.c
@@ -0,0 +1,159 @@
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
+#include <linux/remoteproc.h>
+#include <linux/memblock.h>
+
+#include <plat/omap_device.h>
+#include <plat/omap_hwmod.h>
+#include <plat/remoteproc.h>
+#include <plat/dsp.h>
+#include <plat/io.h>
+
+#define L4_PERIPHERAL_L4CFG	(L4_44XX_BASE)
+#define IPU_PERIPHERAL_L4CFG	0xAA000000
+
+#define IPU_MEM_TEXT		0x0
+#define IPU_MEM_DATA		0x80000000
+#define IPU_MEM_IPC		0xA0000000
+
+/*
+ * Memory mappings for the remote M3 subsystem
+ *
+ * Don't change the device addresses (first parameter), otherwise you'd have
+ * to update the firmware (BIOS image) accordingly.
+ *
+ * A 0 physical address (second parameter) means this physical region should
+ * be dynamically carved out at boot time.
+ *
+ * Sizes should be in the form of 2 ^ n * PAGE_SIZE (where n = 0, 1, 2, ...)
+ *
+ * Alignment requirement: at least page-based
+ */
+static struct rproc_mem_entry ipu_memory_maps[] = {
+	{IPU_MEM_IPC, 0, SZ_1M}, /* keep this IPC region first */
+	{IPU_MEM_TEXT, 0, SZ_4M},
+	{IPU_MEM_DATA, 0, SZ_32M},
+	{IPU_PERIPHERAL_L4CFG, L4_PERIPHERAL_L4CFG, SZ_16M},
+	{ }
+};
+
+static struct omap_rproc_pdata omap4_rproc_data[] = {
+	{
+		.name		= "dsp",
+		.iommu_name	= "tesla",
+		.firmware	= "tesla-dsp.bin",
+		.oh_name	= "dsp_c0",
+	},
+	{
+		.name		= "ipu",
+		.iommu_name	= "ducati",
+		.firmware	= "ducati-m3.bin",
+		.oh_name	= "ipu_c0",
+		.oh_name_opt	= "ipu_c1",
+		.memory_maps	= ipu_memory_maps,
+	},
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
+static int __init omap_rproc_init(void)
+{
+	const char *pdev_name = "omap-rproc";
+	struct omap_hwmod *oh[2];
+	struct omap_device *od;
+	int i, ret = 0, oh_count;
+	phys_addr_t paddr, size;
+
+	/* names like ipu_cx/dsp_cx might show up on other OMAPs, too */
+	if (!cpu_is_omap44xx())
+		return 0;
+
+	paddr = omap_dsp_get_mempool_base();
+	size = omap_dsp_get_mempool_size();
+	if (!paddr || !size) {
+		pr_warn("carveout memory is unavailable: 0x%x, 0x%x\n",
+								paddr, size);
+		return -ENOMEM;
+	}
+
+	/* dynamically allocate carveout memory as required by the ipu */
+	for (i = 0; i < ARRAY_SIZE(ipu_memory_maps); i++) {
+		struct rproc_mem_entry *me = &ipu_memory_maps[i];
+
+		if (!me->pa && me->size) {
+			if (me->size > size) {
+				pr_warn("out of carveout memory\n");
+				return -ENOMEM;
+			}
+
+			me->pa = paddr;
+			paddr += me->size;
+			size -= me->size;
+
+			pr_info("0x%x bytes at 0x%x %d\n", me->size, me->pa, i);
+		}
+	}
+
+	/* build the remote proc devices */
+	for (i = 0; i < ARRAY_SIZE(omap4_rproc_data); i++) {
+		const char *oh_name = omap4_rproc_data[i].oh_name;
+		const char *oh_name_opt = omap4_rproc_data[i].oh_name_opt;
+		oh_count = 0;
+
+		oh[0] = omap_hwmod_lookup(oh_name);
+		if (!oh[0]) {
+			pr_err("could not look up %s\n", oh_name);
+			continue;
+		}
+		oh_count++;
+
+		/* ipu has a secondary hwmod entry */
+		if (oh_name_opt) {
+			oh[1] = omap_hwmod_lookup(oh_name_opt);
+			if (!oh[1]) {
+				pr_err("could not look up %s\n", oh_name_opt);
+				continue;
+			}
+			oh_count++;
+		}
+
+		od = omap_device_build_ss(pdev_name, i, oh, oh_count,
+					&omap4_rproc_data[i],
+					sizeof(struct omap_rproc_pdata),
+					omap_rproc_latency,
+					ARRAY_SIZE(omap_rproc_latency),
+					false);
+		if (IS_ERR(od)) {
+			pr_err("Could not build omap_device for %s:%s\n",
+							pdev_name, oh_name);
+			ret = PTR_ERR(od);
+		}
+	}
+
+	return ret;
+}
+/* must be ready in time for device_initcall users */
+subsys_initcall(omap_rproc_init);
-- 
1.7.1

