Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0JFHqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:46:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab0JFHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56772921"
X-IronPort-AV: E=Sophos;i="4.57,288,1283756400"; 
   d="scan'208";a="20252787"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 08/20 v2] msm: 8x60: gic initialization fixup for RUMI
Date: Wed,  6 Oct 2010 00:42:47 -0700
Message-Id: <1286350979-19328-9-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

On RUMI platform STIs are not enabled by default, contrary to the
GIC spec. The bits for STIs in the enable/enable clear registers
are also RW instead of RO. STIs need to be enabled at initialization
time.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index d30ead1..e7feb99 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -41,9 +42,28 @@ static void __init msm8x60_map_io(void)
 
 static void __init msm8x60_init_irq(void)
 {
+	unsigned int i;
+
 	gic_dist_init(0, MSM_QGIC_DIST_BASE, 1);
 	gic_cpu_base_addr = (void *)MSM_QGIC_CPU_BASE;
 	gic_cpu_init(0, MSM_QGIC_CPU_BASE);
+
+	/* Edge trigger PPIs except AVS_SVICINT and AVS_SVICINTSWDONE */
+	writel(0xFFFFD7FF, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
+
+	/* RUMI does not adhere to GIC spec by enabling STIs by default.
+	 * Enable/clear is supposed to be RO for STIs, but is RW on RUMI.
+	 */
+	writel(0x0000FFFF, MSM_QGIC_DIST_BASE + GIC_DIST_ENABLE_SET);
+
+	/* FIXME: Not installing AVS_SVICINT and AVS_SVICINTSWDONE yet
+	 * as they are configured as level, which does not play nice with
+	 * handle_percpu_irq.
+	 */
+	for (i = GIC_PPI_START; i < GIC_SPI_START; i++) {
+		if (i != AVS_SVICINT && i != AVS_SVICINTSWDONE)
+			set_irq_handler(i, handle_percpu_irq);
+	}
 }
 
 static void __init msm8x60_init(void)
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
