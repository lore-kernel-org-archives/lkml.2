Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab2KUCf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:35:29 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2KUC04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:56 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 12/42] SH: Register PFC platform device
Date: Wed, 21 Nov 2012 03:27:13 +0100
Message-Id: <1353464863-10281-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arch code to register the PFC platform device instead of calling the
driver directly. Platform device registration in the sh-pfc driver will
be removed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/sh/include/cpu-common/cpu/pfc.h    |   28 +++++++++++++++++++++++
 arch/sh/kernel/cpu/Makefile             |    2 +-
 arch/sh/kernel/cpu/pfc.c                |   37 +++++++++++++++++++++++++++++++
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c |    3 +-
 arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c |    3 +-
 arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c |    3 +-
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c  |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c |    8 +++---
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c |    3 +-
 arch/sh/kernel/cpu/sh4a/pinmux-shx3.c   |    3 +-
 15 files changed, 92 insertions(+), 16 deletions(-)
 create mode 100644 arch/sh/include/cpu-common/cpu/pfc.h
 create mode 100644 arch/sh/kernel/cpu/pfc.c

diff --git a/arch/sh/include/cpu-common/cpu/pfc.h b/arch/sh/include/cpu-common/cpu/pfc.h
new file mode 100644
index 0000000..00291eb
--- /dev/null
+++ b/arch/sh/include/cpu-common/cpu/pfc.h
@@ -0,0 +1,28 @@
+/*
+ * SH Pin Function Control Initialization
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ARCH_SH_CPU_PFC_H__
+#define __ARCH_SH_CPU_PFC_H__
+
+#include <linux/types.h>
+
+struct pinmux_info;
+struct resource;
+
+int sh_pfc_register(const char *name,
+		    struct resource *resource, u32 num_resources,
+		    struct pinmux_info *pdata);
+
+#endif /* __ARCH_SH_CPU_PFC_H__ */
diff --git a/arch/sh/kernel/cpu/Makefile b/arch/sh/kernel/cpu/Makefile
index fa58bfd..accc7ca 100644
--- a/arch/sh/kernel/cpu/Makefile
+++ b/arch/sh/kernel/cpu/Makefile
@@ -18,4 +18,4 @@ obj-$(CONFIG_ARCH_SHMOBILE)	+= shmobile/
 obj-$(CONFIG_SH_ADC)		+= adc.o
 obj-$(CONFIG_SH_CLK_CPG_LEGACY)	+= clock-cpg.o
 
-obj-y	+= irq/ init.o clock.o fpu.o proc.o
+obj-y	+= irq/ init.o clock.o fpu.o pfc.o proc.o
diff --git a/arch/sh/kernel/cpu/pfc.c b/arch/sh/kernel/cpu/pfc.c
new file mode 100644
index 0000000..a19b56d
--- /dev/null
+++ b/arch/sh/kernel/cpu/pfc.c
@@ -0,0 +1,37 @@
+/*
+ * SH Pin Function Control Initialization
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <cpu/pfc.h>
+
+static struct platform_device sh_pfc_device = {
+	.name		= "sh-pfc",
+	.id		= -1,
+};
+
+int __init sh_pfc_register(const char *name,
+			   struct resource *resource, u32 num_resources,
+			   struct pinmux_info *pdata)
+{
+	if (name)
+		sh_pfc_device.name = name;
+	sh_pfc_device.dev.platform_data = pdata;
+	sh_pfc_device.num_resources = num_resources;
+	sh_pfc_device.resource = resource;
+
+	return platform_device_register(&sh_pfc_device);
+}
diff --git a/arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c b/arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c
index c465af7..ef66de4 100644
--- a/arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c
+++ b/arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7203.h>
 
 enum {
@@ -1592,6 +1593,6 @@ static struct pinmux_info sh7203_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7203_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7203_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c b/arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c
index b055b55..0fdd36f 100644
--- a/arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c
+++ b/arch/sh/kernel/cpu/sh2a/pinmux-sh7264.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7264.h>
 
 enum {
@@ -2131,6 +2132,6 @@ static struct pinmux_info sh7264_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7264_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7264_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c b/arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c
index 039e458..78462e9 100644
--- a/arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c
+++ b/arch/sh/kernel/cpu/sh2a/pinmux-sh7269.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7269.h>
 
 enum {
@@ -2834,6 +2835,6 @@ static struct pinmux_info sh7269_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7269_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7269_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh3/pinmux-sh7720.c b/arch/sh/kernel/cpu/sh3/pinmux-sh7720.c
index 9ca1546..cf139f2 100644
--- a/arch/sh/kernel/cpu/sh3/pinmux-sh7720.c
+++ b/arch/sh/kernel/cpu/sh3/pinmux-sh7720.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7720.h>
 
 enum {
@@ -1236,7 +1237,7 @@ static struct pinmux_info sh7720_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7720_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7720_pinmux_info);
 }
 
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c
index 0688a75..a659d25 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7722.h>
 
 enum {
@@ -1778,7 +1779,7 @@ static struct pinmux_info sh7722_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7722_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7722_pinmux_info);
 }
 
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c
index 88bf5ec..8fabf8c 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7723.h>
 
 enum {
@@ -1903,7 +1904,7 @@ static struct pinmux_info sh7723_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7723_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7723_pinmux_info);
 }
 
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c
index 1af0f95..c1445e0 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7724.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7724.h>
 
 enum {
@@ -2225,6 +2226,6 @@ static struct pinmux_info sh7724_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7724_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7724_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c
index eed3b9d..373f626 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7734.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/ioport.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7734.h>
 
 #define CPU_32_PORT(fn, pfx, sfx)				\
@@ -2467,9 +2468,6 @@ static struct resource sh7734_pfc_resources[] = {
 static struct pinmux_info sh7734_pinmux_info = {
 	.name = "sh7734_pfc",
 
-	.resource = sh7734_pfc_resources,
-	.num_resources = ARRAY_SIZE(sh7734_pfc_resources),
-
 	.unlock_reg = 0xFFFC0000,
 
 	.reserved_id = PINMUX_RESERVED,
@@ -2492,6 +2490,8 @@ static struct pinmux_info sh7734_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7734_pinmux_info);
+	return sh_pfc_register(NULL, sh7734_pfc_resources,
+			       ARRAY_SIZE(sh7734_pfc_resources),
+			       &sh7734_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c
index 4c74bd0..d20e7d5 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7757.h>
 
 enum {
@@ -2282,6 +2283,6 @@ static struct pinmux_info sh7757_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7757_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7757_pinmux_info);
 }
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c
index 5ebc25f..8dd6152 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7785.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7785.h>
 
 enum {
@@ -1304,7 +1305,7 @@ static struct pinmux_info sh7785_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7785_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7785_pinmux_info);
 }
 
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c b/arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c
index 4229e07..6e6ba83 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/sh7786.h>
 
 enum {
@@ -837,7 +838,7 @@ static struct pinmux_info sh7786_pinmux_info = {
 
 static int __init plat_pinmux_setup(void)
 {
-	return register_pinmux(&sh7786_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &sh7786_pinmux_info);
 }
 
 arch_initcall(plat_pinmux_setup);
diff --git a/arch/sh/kernel/cpu/sh4a/pinmux-shx3.c b/arch/sh/kernel/cpu/sh4a/pinmux-shx3.c
index aaa5338..98be7ae 100644
--- a/arch/sh/kernel/cpu/sh4a/pinmux-shx3.c
+++ b/arch/sh/kernel/cpu/sh4a/pinmux-shx3.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gpio.h>
+#include <cpu/pfc.h>
 #include <cpu/shx3.h>
 
 enum {
@@ -582,6 +583,6 @@ static struct pinmux_info shx3_pinmux_info = {
 
 static int __init shx3_pinmux_setup(void)
 {
-	return register_pinmux(&shx3_pinmux_info);
+	return sh_pfc_register(NULL, NULL, 0, &shx3_pinmux_info);
 }
 arch_initcall(shx3_pinmux_setup);
-- 
1.7.8.6

