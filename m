Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2LYLTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:19:52 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52871 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2LYLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:19:49 -0500
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v5 2/4] ARM: mach-shmobile: sh7372: Add IPMMU device
Date: Tue, 25 Dec 2012 20:19:13 +0900
Message-Id: <1356434355-3279-3-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356434355-3279-1-git-send-email-hdk@igel.co.jp>
References: <1356434355-3279-1-git-send-email-hdk@igel.co.jp>
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
 arch/arm/mach-shmobile/setup-sh7372.c | 39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index c917882..04ad98e 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -33,6 +33,7 @@
 #include <linux/sh_timer.h>
 #include <linux/pm_domain.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_data/sh_ipmmu.h>
 #include <mach/dma-register.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
@@ -982,6 +983,43 @@ static struct platform_device spu1_device = {
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
+static const char * const ipmmu_dev_names[] = {
+	"sh_mobile_lcdc_fb.0",
+	"sh_mobile_lcdc_fb.1",
+	"sh_mobile_ceu.0",
+	"uio_pdrv_genirq.0",
+	"uio_pdrv_genirq.1",
+	"uio_pdrv_genirq.2",
+	"uio_pdrv_genirq.3",
+	"uio_pdrv_genirq.4",
+	"uio_pdrv_genirq.5",
+};
+
+static struct shmobile_ipmmu_platform_data ipmmu_platform_data = {
+	.dev_names = ipmmu_dev_names,
+	.num_dev_names = ARRAY_SIZE(ipmmu_dev_names),
+};
+
+static struct platform_device ipmmu_device = {
+	.name           = "ipmmu",
+	.id             = -1,
+	.dev = {
+		.platform_data = &ipmmu_platform_data,
+	},
+	.resource       = ipmmu_resources,
+	.num_resources  = ARRAY_SIZE(ipmmu_resources),
+};
+
 static struct platform_device *sh7372_early_devices[] __initdata = {
 	&scif0_device,
 	&scif1_device,
@@ -993,6 +1031,7 @@ static struct platform_device *sh7372_early_devices[] __initdata = {
 	&cmt2_device,
 	&tmu00_device,
 	&tmu01_device,
+	&ipmmu_device,
 };
 
 static struct platform_device *sh7372_late_devices[] __initdata = {
-- 
1.8.0

