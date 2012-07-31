Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2GaAy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 20:54:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2GaAy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 20:54:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6788"; a="216142492"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] msm: io: Change the default static iomappings to be shared
Date: Mon, 30 Jul 2012 17:54:21 -0700
Message-Id: <1343696061-11445-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.4 kernel the static iomappings can be shared with the ioremap
mappings. If ioremap is called with an address for which a static
mapping already exists, then that mapping should be used instead
of creating a new one.
However, the MT_DEVICE_NONSHARED flag prevents this. Hence, get rid
of this flag. Some targets (7X00) that require the static iomappings
to be NONSHARED use the MSM_DEVICE_TYPE and MSM_CHIP_DEVICE_TYPE macros.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/io.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 61d61cb..9f4b4ba 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -33,23 +33,32 @@
 		.virtual = (unsigned long) MSM_##name##_BASE, \
 		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
 		.length = chip##_##name##_SIZE, \
-		.type = MT_DEVICE_NONSHARED, \
+		.type = MT_DEVICE, \
+	 }
+
+#define MSM_CHIP_DEVICE_TYPE(name, chip, mem_type) {			      \
+		.virtual = (unsigned long) MSM_##name##_BASE, \
+		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
+		.length = chip##_##name##_SIZE, \
+		.type = mem_type, \
 	 }
 
 #define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
+#define MSM_DEVICE_TYPE(name, mem_type) \
+		MSM_CHIP_DEVICE_TYPE(name, MSM, mem_type)
 
 #if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
 	|| defined(CONFIG_ARCH_MSM7X25)
 static struct map_desc msm_io_desc[] __initdata = {
-	MSM_DEVICE(VIC),
-	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(DMOV),
-	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
-	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
-	MSM_CHIP_DEVICE(CLK_CTL, MSM7X00),
+	MSM_DEVICE_TYPE(VIC, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(CSR, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_DEVICE_TYPE(DMOV, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(CLK_CTL, MSM7X00, MT_DEVICE_NONSHARED),
 #if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
 	defined(CONFIG_DEBUG_MSM_UART3)
-	MSM_DEVICE(DEBUG_UART),
+	MSM_DEVICE_TYPE(DEBUG_UART, MT_DEVICE_NONSHARED),
 #endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

