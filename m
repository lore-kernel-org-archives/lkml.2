Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab2ILRD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab2ILQ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521334"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 06/24] ARM: msm: io: Change the default static iomappings to be shared
Date: Wed, 12 Sep 2012 09:58:42 -0700
Message-Id: <1347469140-25069-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

With 3.4 kernel the static iomappings can be shared with the ioremap
mappings. If ioremap is called with an address for which a static
mapping already exists, then that mapping should be used instead
of creating a new one.

However, the MT_DEVICE_NONSHARED flag prevents this. Hence, get rid
of this flag. Some targets (7X00) that require the static iomappings
to be NONSHARED use the MSM_DEVICE_TYPE and MSM_CHIP_DEVICE_TYPE macros.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/io.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 2409c0b..af43f6a 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -29,27 +29,31 @@
 
 #include <mach/board.h>
 
-#define MSM_CHIP_DEVICE(name, chip) {			      \
+#define MSM_CHIP_DEVICE_TYPE(name, chip, mem_type) {			      \
 		.virtual = (unsigned long) MSM_##name##_BASE, \
 		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
 		.length = chip##_##name##_SIZE, \
-		.type = MT_DEVICE_NONSHARED, \
+		.type = mem_type, \
 	 }
 
+#define MSM_DEVICE_TYPE(name, mem_type) \
+		MSM_CHIP_DEVICE_TYPE(name, MSM, mem_type)
+#define MSM_CHIP_DEVICE(name, chip) \
+		MSM_CHIP_DEVICE_TYPE(name, chip, MT_DEVICE)
 #define MSM_DEVICE(name) MSM_CHIP_DEVICE(name, MSM)
 
 #if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X27) \
 	|| defined(CONFIG_ARCH_MSM7X25)
 static struct map_desc msm_io_desc[] __initdata = {
-	MSM_DEVICE(VIC),
-	MSM_CHIP_DEVICE(CSR, MSM7X00),
-	MSM_DEVICE(DMOV),
-	MSM_CHIP_DEVICE(GPIO1, MSM7X00),
-	MSM_CHIP_DEVICE(GPIO2, MSM7X00),
-	MSM_DEVICE(CLK_CTL),
+	MSM_DEVICE_TYPE(VIC, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(CSR, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_DEVICE_TYPE(DMOV, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
+	MSM_DEVICE_TYPE(CLK_CTL, MT_DEVICE_NONSHARED),
 #if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
 	defined(CONFIG_DEBUG_MSM_UART3)
-	MSM_DEVICE(DEBUG_UART),
+	MSM_DEVICE_TYPE(DEBUG_UART, MT_DEVICE_NONSHARED),
 #endif
 	{
 		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

