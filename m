Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2IKGKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:10:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62026 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2IKGKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:10:38 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v3 2/2] ARM: mach-shmobile: sh7372: Add IPMMU device
Date: Tue, 11 Sep 2012 15:10:14 +0900
Message-Id: <1347343814-32299-3-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1347343814-32299-1-git-send-email-hdk@igel.co.jp>
References: <1347343814-32299-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an IPMMU device and notifies the IPMMU driver which
devices are connected via the IPMMU module.  All devices connected to the main
memory bus via the IPMMU module MUST be registered when SHMOBILE_IPMMU and
SHMOBILE_IOMMU are enabled because physical address cannot be used
while the IPMMU module's MMU function is enabled.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
Tested-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/arm/mach-shmobile/board-ap4evb.c   |    5 +++++
 arch/arm/mach-shmobile/board-mackerel.c |    5 +++++
 arch/arm/mach-shmobile/setup-sh7372.c   |   26 ++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index f172ca8..ce6d796 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -61,6 +61,7 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
+#include <mach/ipmmu.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -1448,6 +1449,10 @@ static void __init ap4evb_init(void)
 
 	sh7372_add_standard_devices();
 
+	ipmmu_add_device(&lcdc_device.dev);
+	ipmmu_add_device(&lcdc1_device.dev);
+	ipmmu_add_device(&ceu_device.dev);
+
 	/* HDMI */
 	gpio_request(GPIO_FN_HDMI_HPD, NULL);
 	gpio_request(GPIO_FN_HDMI_CEC, NULL);
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index c129542..8bc4faf 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -60,6 +60,7 @@
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
+#include <mach/ipmmu.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -1622,6 +1623,10 @@ static void __init mackerel_init(void)
 
 	sh7372_add_standard_devices();
 
+	ipmmu_add_device(&lcdc_device.dev);
+	ipmmu_add_device(&hdmi_lcdc_device.dev);
+	ipmmu_add_device(&ceu_device.dev);
+
 	platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
 
 	rmobile_add_device_to_domain(&sh7372_pd_a4lc, &lcdc_device);
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 838a87b..399d26d 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -38,6 +38,7 @@
 #include <mach/irqs.h>
 #include <mach/sh7372.h>
 #include <mach/common.h>
+#include <mach/ipmmu.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -968,6 +969,23 @@ static struct platform_device spu1_device = {
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
@@ -979,6 +997,7 @@ static struct platform_device *sh7372_early_devices[] __initdata = {
 	&cmt2_device,
 	&tmu00_device,
 	&tmu01_device,
+	&ipmmu_device,
 };
 
 static struct platform_device *sh7372_late_devices[] __initdata = {
@@ -1020,6 +1039,13 @@ void __init sh7372_add_standard_devices(void)
 	platform_add_devices(sh7372_early_devices,
 			    ARRAY_SIZE(sh7372_early_devices));
 
+	ipmmu_add_device(&vpu_device.dev);
+	ipmmu_add_device(&jpu_device.dev);
+	ipmmu_add_device(&veu0_device.dev);
+	ipmmu_add_device(&veu1_device.dev);
+	ipmmu_add_device(&veu2_device.dev);
+	ipmmu_add_device(&veu3_device.dev);
+
 	platform_add_devices(sh7372_late_devices,
 			    ARRAY_SIZE(sh7372_late_devices));
 
-- 
1.7.0.4

