Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0JZAj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:39:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55398 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab0JZAia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:30 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 2/8] staging: tidspbridge - add kconfig parameter for DMM size
Date: Mon, 25 Oct 2010 19:51:40 -0500
Message-Id: <1288054306-4361-3-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-2-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new kconfig parameter for DMM size is added. Also DMM is
allocated after the end of SHM area. So that the checks on
DSP are still valid and we avoid using areas between SHM
which are not mapped reducing the probability of shared
memory corruption.

NOTE: This patch has a dependency on this patch:

"omap: iommu - create new api to set valid da range"

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Kconfig                |    8 ++++++++
 drivers/staging/tidspbridge/core/tiomap3430.c      |   20 ++++++++++++++++++--
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |    3 +++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 672008f..37e47f5 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -42,6 +42,14 @@ config TIDSPBRIDGE_MEMPOOL_SIZE
 	  Allocate specified size of memory at booting time to avoid allocation
 	  failure under heavy memory fragmentation after some use time.
 
+config TIDSPBRIDGE_DMM_SIZE
+	hex "DMM capable memory size (Byte)"
+	depends on TIDSPBRIDGE
+	default "0x10000000"
+	help
+	  Memory size of DSP virtual address for Dynamic Memory Mapping.
+	  Please make sure the size is 4K aligned.
+
 config TIDSPBRIDGE_DEBUG
 	bool "Debug Support"
 	depends on TIDSPBRIDGE
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index c28dcf1..88c8c71 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -345,7 +345,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 					OMAP343X_CONTROL_IVA2_BOOTMOD));
 		}
 	}
-
 	if (!status) {
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -362,6 +361,11 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	if (!status) {
 		dev_context->dsp_mmu = mmu;
 		sm_sg = &dev_context->sh_s;
+		/* Set valid range to map shared memory */
+		status = iommu_set_da_range(mmu, sm_sg->seg0_da,
+					sm_sg->seg1_da + sm_sg->seg1_size);
+	}
+	if (!status) {
 		sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
 			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
 		if (IS_ERR_VALUE(sg0_da)) {
@@ -411,7 +415,19 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			l4_i++;
 		}
 	}
-
+	if (!status) {
+		/* Set valid range for DMM mappings */
+		if (MAX_DSP_MMU_DA - CONFIG_TIDSPBRIDGE_DMM_SIZE <
+					sm_sg->seg1_da + sm_sg->seg1_size) {
+			dev_err(bridge, "DMM size too big!\n");
+			status = -ENOMEM;
+		} else {
+			status = iommu_set_da_range(mmu,
+				sm_sg->seg1_da + sm_sg->seg1_size,
+				sm_sg->seg1_da + sm_sg->seg1_size +
+				CONFIG_TIDSPBRIDGE_DMM_SIZE);
+		}
+	}
 	/* Lock the above TLB entries and get the BIOS and load monitor timer
 	 * information */
 	if (!status) {
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
index cb38d4c..bbbe9e6 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
@@ -22,6 +22,9 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 
+/* Last patch is not mapped to detect buffer overflow in DSP side */
+#define MAX_DSP_MMU_DA 0xFFFFF000
+
 /**
  * dsp_mmu_init() - initialize dsp_mmu module and returns a handle
  *
-- 
1.6.3.3

