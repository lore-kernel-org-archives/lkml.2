Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2KUCgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:36:21 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab2KUC0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:55 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 11/42] ARM: shmobile: Register PFC platform device
Date: Wed, 21 Nov 2012 03:27:12 +0100
Message-Id: <1353464863-10281-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
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
 arch/arm/mach-shmobile/Makefile      |    2 +-
 arch/arm/mach-shmobile/devices.c     |   37 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/devices.h     |   28 +++++++++++++++++++++++++
 arch/arm/mach-shmobile/pfc-r8a7740.c |    4 ++-
 arch/arm/mach-shmobile/pfc-r8a7779.c |    9 ++++---
 arch/arm/mach-shmobile/pfc-sh7367.c  |    4 ++-
 arch/arm/mach-shmobile/pfc-sh7372.c  |    4 ++-
 arch/arm/mach-shmobile/pfc-sh7377.c  |    4 ++-
 arch/arm/mach-shmobile/pfc-sh73a0.c  |    4 ++-
 9 files changed, 86 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/devices.c
 create mode 100644 arch/arm/mach-shmobile/devices.h

diff --git a/arch/arm/mach-shmobile/Makefile b/arch/arm/mach-shmobile/Makefile
index fe2c97c..f5a0c59 100644
--- a/arch/arm/mach-shmobile/Makefile
+++ b/arch/arm/mach-shmobile/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common objects
-obj-y				:= timer.o console.o clock.o
+obj-y				:= timer.o console.o clock.o devices.o
 
 # CPU objects
 obj-$(CONFIG_ARCH_SH7367)	+= setup-sh7367.o clock-sh7367.o intc-sh7367.o
diff --git a/arch/arm/mach-shmobile/devices.c b/arch/arm/mach-shmobile/devices.c
new file mode 100644
index 0000000..da4210e
--- /dev/null
+++ b/arch/arm/mach-shmobile/devices.c
@@ -0,0 +1,37 @@
+/*
+ * SH Mobile Devices Setup and Initialization
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
+#include "devices.h"
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
diff --git a/arch/arm/mach-shmobile/devices.h b/arch/arm/mach-shmobile/devices.h
new file mode 100644
index 0000000..4816c5b
--- /dev/null
+++ b/arch/arm/mach-shmobile/devices.h
@@ -0,0 +1,28 @@
+/*
+ * SH Mobile Devices Setup and Initialization
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
+#ifndef __ARCH_ARM_MACH_SHMOBILE_DEVICES_H__
+#define __ARCH_ARM_MACH_SHMOBILE_DEVICES_H__
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
+#endif /* __ARCH_ARM_MACH_SHMOBILE_DEVICES_H__ */
diff --git a/arch/arm/mach-shmobile/pfc-r8a7740.c b/arch/arm/mach-shmobile/pfc-r8a7740.c
index 134d1b9..0590b6d 100644
--- a/arch/arm/mach-shmobile/pfc-r8a7740.c
+++ b/arch/arm/mach-shmobile/pfc-r8a7740.c
@@ -24,6 +24,8 @@
 #include <mach/r8a7740.h>
 #include <mach/irqs.h>
 
+#include "devices.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)					\
 	PORT_10(fn, pfx, sfx),		PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx),	PORT_90(fn, pfx##1, sfx),	\
@@ -2613,5 +2615,5 @@ static struct pinmux_info r8a7740_pinmux_info = {
 
 void r8a7740_pinmux_init(void)
 {
-	register_pinmux(&r8a7740_pinmux_info);
+	sh_pfc_register(NULL, NULL, 0, &r8a7740_pinmux_info);
 }
diff --git a/arch/arm/mach-shmobile/pfc-r8a7779.c b/arch/arm/mach-shmobile/pfc-r8a7779.c
index cbc26ba..f738042 100644
--- a/arch/arm/mach-shmobile/pfc-r8a7779.c
+++ b/arch/arm/mach-shmobile/pfc-r8a7779.c
@@ -23,6 +23,8 @@
 #include <linux/ioport.h>
 #include <mach/r8a7779.h>
 
+#include "devices.h"
+
 #define CPU_32_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_10(fn, pfx##1, sfx),	\
 	PORT_10(fn, pfx##2, sfx), PORT_1(fn, pfx##30, sfx),	\
@@ -2616,9 +2618,6 @@ static struct resource r8a7779_pfc_resources[] = {
 static struct pinmux_info r8a7779_pinmux_info = {
 	.name = "r8a7779_pfc",
 
-	.resource = r8a7779_pfc_resources,
-	.num_resources = ARRAY_SIZE(r8a7779_pfc_resources),
-
 	.unlock_reg = 0xfffc0000, /* PMMR */
 
 	.reserved_id = PINMUX_RESERVED,
@@ -2641,5 +2640,7 @@ static struct pinmux_info r8a7779_pinmux_info = {
 
 void r8a7779_pinmux_init(void)
 {
-	register_pinmux(&r8a7779_pinmux_info);
+	sh_pfc_register(NULL, r8a7779_pfc_resources,
+			ARRAY_SIZE(r8a7779_pfc_resources),
+			&r8a7779_pinmux_info);
 }
diff --git a/arch/arm/mach-shmobile/pfc-sh7367.c b/arch/arm/mach-shmobile/pfc-sh7367.c
index c0c137f..5a4fdf3 100644
--- a/arch/arm/mach-shmobile/pfc-sh7367.c
+++ b/arch/arm/mach-shmobile/pfc-sh7367.c
@@ -21,6 +21,8 @@
 #include <linux/sh_pfc.h>
 #include <mach/sh7367.h>
 
+#include "devices.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx), PORT_90(fn, pfx##1, sfx),	\
@@ -1723,5 +1725,5 @@ static struct pinmux_info sh7367_pinmux_info = {
 
 void sh7367_pinmux_init(void)
 {
-	register_pinmux(&sh7367_pinmux_info);
+	sh_pfc_register(NULL, NULL, 0, &sh7367_pinmux_info);
 }
diff --git a/arch/arm/mach-shmobile/pfc-sh7372.c b/arch/arm/mach-shmobile/pfc-sh7372.c
index 7a1525f..31b539c 100644
--- a/arch/arm/mach-shmobile/pfc-sh7372.c
+++ b/arch/arm/mach-shmobile/pfc-sh7372.c
@@ -26,6 +26,8 @@
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
 
+#include "devices.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx) \
 	PORT_10(fn, pfx, sfx),		PORT_90(fn, pfx, sfx), \
 	PORT_10(fn, pfx##10, sfx),	PORT_10(fn, pfx##11, sfx), \
@@ -1659,5 +1661,5 @@ static struct pinmux_info sh7372_pinmux_info = {
 
 void sh7372_pinmux_init(void)
 {
-	register_pinmux(&sh7372_pinmux_info);
+	sh_pfc_register(NULL, NULL, 0, &sh7372_pinmux_info);
 }
diff --git a/arch/arm/mach-shmobile/pfc-sh7377.c b/arch/arm/mach-shmobile/pfc-sh7377.c
index f3117f6..4a94d20 100644
--- a/arch/arm/mach-shmobile/pfc-sh7377.c
+++ b/arch/arm/mach-shmobile/pfc-sh7377.c
@@ -22,6 +22,8 @@
 #include <linux/sh_pfc.h>
 #include <mach/sh7377.h>
 
+#include "devices.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx, sfx), PORT_90(fn, pfx, sfx),		\
 	PORT_10(fn, pfx##10, sfx),				\
@@ -1684,5 +1686,5 @@ static struct pinmux_info sh7377_pinmux_info = {
 
 void sh7377_pinmux_init(void)
 {
-	register_pinmux(&sh7377_pinmux_info);
+	sh_pfc_register(NULL, NULL, 0, &sh7377_pinmux_info);
 }
diff --git a/arch/arm/mach-shmobile/pfc-sh73a0.c b/arch/arm/mach-shmobile/pfc-sh73a0.c
index b442f9d..3de6c70 100644
--- a/arch/arm/mach-shmobile/pfc-sh73a0.c
+++ b/arch/arm/mach-shmobile/pfc-sh73a0.c
@@ -24,6 +24,8 @@
 #include <mach/sh73a0.h>
 #include <mach/irqs.h>
 
+#include "devices.h"
+
 #define CPU_ALL_PORT(fn, pfx, sfx)				\
 	PORT_10(fn, pfx,    sfx), PORT_10(fn, pfx##1, sfx),	\
 	PORT_10(fn, pfx##2, sfx), PORT_10(fn, pfx##3, sfx),	\
@@ -2799,5 +2801,5 @@ static struct pinmux_info sh73a0_pinmux_info = {
 
 void sh73a0_pinmux_init(void)
 {
-	register_pinmux(&sh73a0_pinmux_info);
+	sh_pfc_register(NULL, NULL, 0, &sh73a0_pinmux_info);
 }
-- 
1.7.8.6

