Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1EBJzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:55:05 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1569 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab1EBJzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:55:02 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 05:55:02 EDT
From: Maarten ter Huurne <maarten@treewalker.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] MIPS: JZ4740: setup: Autodetect physical memory.
Date: Mon,  2 May 2011 11:47:00 +0200
Message-Id: <1304329620-17659-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume that the boot loader knows the physical memory of the system and
deduce that information from the contents of the SDRAM control register.
It is still possible to override with with the "mem=" parameter, but we
have a sensible default now.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/mips/jz4740/setup.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/mips/jz4740/setup.c b/arch/mips/jz4740/setup.c
index 6a9e14d..d97cfbf 100644
--- a/arch/mips/jz4740/setup.c
+++ b/arch/mips/jz4740/setup.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  Copyright (C) 2011, Maarten ter Huurne <maarten@treewalker.org>
  *  JZ4740 setup code
  *
  *  This program is free software; you can redistribute it and/or modify it
@@ -14,13 +15,44 @@
  */
 
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 
+#include <asm/bootinfo.h>
+
+#include <asm/mach-jz4740/base.h>
+
 #include "reset.h"
 
+
+#define JZ4740_EMC_SDRAM_CTRL 0x80
+
+
+static void __init jz4740_detect_mem(void)
+{
+	void __iomem *jz_emc_base;
+	u32 ctrl, bus, bank, rows, cols;
+	phys_t size;
+
+	jz_emc_base = ioremap(JZ4740_EMC_BASE_ADDR, 0x100);
+	ctrl = readl(jz_emc_base + JZ4740_EMC_SDRAM_CTRL);
+	bus = 2 - ((ctrl >> 31) & 1);
+	bank = 1 + ((ctrl >> 19) & 1);
+	cols = 8 + ((ctrl >> 26) & 7);
+	rows = 11 + ((ctrl >> 20) & 3);
+	printk(KERN_DEBUG
+		"SDRAM preconfigured: bus:%u bank:%u rows:%u cols:%u\n",
+		bus, bank, rows, cols);
+	iounmap(jz_emc_base);
+
+	size = 1 << (bus + bank + cols + rows);
+	add_memory_region(0, size, BOOT_MEM_RAM);
+}
+
 void __init plat_mem_setup(void)
 {
 	jz4740_reset_init();
+	jz4740_detect_mem();
 }
 
 const char *get_system_type(void)
-- 
1.7.3.4

