Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab2GYGbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:31:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47259 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab2GYGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:30:12 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH 2/2] ARM: mach-shmobile: sh7372: Add IPMMU device
Date: Wed, 25 Jul 2012 15:29:02 +0900
Message-Id: <1343197742-13630-3-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1343197742-13630-1-git-send-email-hdk@igel.co.jp>
References: <1343197742-13630-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an IPMMU device and notifies the IPMMU driver which
devices are connected via the IPMMU module.  All devices connected to the main
memory bus via the IPMMU module MUST be registered when SHMOBILE_IPMMU and
SHMOBILE_IOMMU are enabled because physical address cannot be used
while the IPMMU module's MMU function is enabled.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 arch/arm/mach-shmobile/board-ap4evb.c   |    5 +++++
 arch/arm/mach-shmobile/board-mackerel.c |    5 +++++
 arch/arm/mach-shmobile/setup-sh7372.c   |   22 ++++++++++++++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index ace6024..c35bb75 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -59,6 +59,7 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
+#include <mach/ipmmu.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -1434,6 +1435,10 @@ static void __init ap4evb_init(void)
 
 	sh7372_add_standard_devices();
 
+	ipmmu_add_device(&lcdc_device.dev);
+	ipmmu_add_device(&lcdc1_device.dev);
+	ipmmu_add_device(&ceu_device.dev);
+
 	/* HDMI */
 	gpio_request(GPIO_FN_HDMI_HPD, NULL);
 	gpio_request(GPIO_FN_HDMI_CEC, NULL);
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 150122a..1dc9f44 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -58,6 +58,7 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
+#include <mach/ipmmu.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -1612,6 +1613,10 @@ static void __init mackerel_init(void)
 
 	sh7372_add_standard_devices();
 
+	ipmmu_add_device(&lcdc_device.dev);
+	ipmmu_add_device(&hdmi_lcdc_device.dev);
+	ipmmu_add_device(&ceu_device.dev);
+
 	platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
 
 	sh7372_add_device_to_domain(&sh7372_a4lc, &lcdc_device);
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index fafce9c..5045638 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -37,6 +37,7 @@
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
 #include <mach/common.h>
+#include <mach/ipmmu.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -1005,6 +1006,23 @@ static struct platform_device spu1_device = {
 	.num_resources	= ARRAY_SIZE(spu1_resources),
 };
 
+/* IPMMUI (an IPMMU module for ICB/LMB) */
+static struct resource ipmmu_resources[] = {
+	[0] = {
+		.name	= "IPMMUI",
+		.start	= 0xfe951000,
+		.end	= 0xfe9510ff,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device ipmmu_device = {
+	.name           = "ipmmu",
+	.id             = -1,
+	.resource       = ipmmu_resources,
+	.num_resources  = ARRAY_SIZE(ipmmu_resources),
+};
+
 static struct platform_device *sh7372_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -1016,6 +1034,7 @@ static struct platform_device *sh7372_early_devices[] __initdata = {
 	&cmt2_device,
 	&tmu00_device,
 	&tmu01_device,
+	&ipmmu_device,
 };
 
 static struct platform_device *sh7372_late_devices[] __initdata = {
@@ -1057,6 +1076,9 @@ void __init sh7372_add_standard_devices(void)
 	platform_add_devices(sh7372_early_devices,
 			    ARRAY_SIZE(sh7372_early_devices));
 
+	ipmmu_add_device(&vpu_device.dev);
+	ipmmu_add_device(&jpu_device.dev);
+
 	platform_add_devices(sh7372_late_devices,
 			    ARRAY_SIZE(sh7372_late_devices));
 
-- 
1.7.0.4

