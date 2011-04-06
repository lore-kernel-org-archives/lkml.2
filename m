Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1DFRPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:15:32 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8954 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DFRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:15:27 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V2 1/4] ARM: Xilinx: Add on chip memory for SMP support
Date: Wed, 6 Apr 2011 11:15:07 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1302110110-32208-1-git-send-email-john.linn@xilinx.com>
References: <1302110110-32208-1-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <c46a3b72-ef8c-40c4-8df1-a525248118ad@VA3EHSMHS036.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On chip memory (OCM) is always present and is used
for communication between the CPUs when in SMP mode.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

V2 Changes

These changes were broken out seperately in V2 as they were part of
the patch for the timer in V1, at the request of Michal Simek.

The file name was previously xilinx_soc.h and it was changed to 
zynq_soc.h when moving from mach-xilinx to mach-zynq.

There were a few other minor changes in the boot process with the 
2nd CPU so some minor #defines also changed.

 arch/arm/mach-zynq/common.c                |   16 +++++++++++++++-
 arch/arm/mach-zynq/include/mach/zynq_soc.h |   17 +++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 9a626ba..ff11e04 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -101,7 +101,21 @@ static struct map_desc io_desc[] __initdata = {
 		.type		= MT_DEVICE,
 	},
 #endif
-
+	/* create a mapping for the OCM  (256K) leaving a hole for the
+	 * interrupt vectors which are handled in the kernel
+	 */
+	{
+		.virtual	= OCM_LOW_VIRT,
+		.pfn		= __phys_to_pfn(OCM_LOW_PHYS),
+		.length		= (192 * SZ_1K),
+		.type		= MT_DEVICE_CACHED,
+	},
+	{
+		.virtual	= OCM_HIGH_VIRT,
+		.pfn		= __phys_to_pfn(OCM_HIGH_PHYS),
+		.length		= (60 * SZ_1K),
+		.type		= MT_DEVICE,
+	},
 };
 
 /**
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index d0d3f8f..ff5349c 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -31,6 +31,12 @@
 #define SCU_PERIPH_PHYS			0xF8F00000
 #define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
 
+#define OCM_LOW_PHYS			0xFFFC0000
+#define OCM_LOW_VIRT			OCM_LOW_PHYS
+
+#define OCM_HIGH_PHYS			0xFFFF1000
+#define OCM_HIGH_VIRT			OCM_HIGH_PHYS
+
 /* The following are intended for the devices that are mapped early */
 
 #define TTC0_BASE			IOMEM(TTC0_VIRT)
@@ -38,6 +44,17 @@
 #define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
 #define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
 #define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
+#define OCM_LOW_BASE			IOMEM(OCM_LOW_VIRT)
+#define OCM_HIGH_BASE			IOMEM(OCM_HIGH_VIRT)
+
+/* There are two OCM addresses needed for communication between CPUs in SMP.
+ * The memory addresses are in the high on-chip RAM and these addresses are
+ * mapped flat (virtual = physical). The memory must be mapped early and
+ * non-cached.
+ */
+#define BOOT_ADDR_OFFSET	0xEFF0
+#define BOOT_STATUS_OFFSET	0xEFF4
+#define BOOT_STATUS_CPU1_UP	1
 
 /*
  * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


