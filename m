Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161433Ab2JXWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:10:59 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64288 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161397Ab2JXWJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:09:43 -0400
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Victor Manuel Jaquez Leal <vjaquez@igalia.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: [PATCH 4/6] staging: tidspbridge: ioremap dsp sync addr
Date: Wed, 24 Oct 2012 17:09:18 -0500
Message-Id: <1351116560-6918-5-git-send-email-omar.ramirez@copitl.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
References: <1351116560-6918-1-git-send-email-omar.ramirez@copitl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the type of sync_addr to 'void __iomem *' and ioremap the
physical address in the shared memory so we can access it using
_raw_*. While at it, drop 'dw_' prefix.

Fix the warning associated with dsp's sync_addr:

warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast
../io.h:88: note: expected 'volatile void *' but argument is of type 'u32'

Signed-off-by: Omar Ramirez Luna <omar.ramirez@copitl.com>
---

Intended for 3.7 due to code changes during rc1.

 drivers/staging/tidspbridge/core/tiomap3430.c |   37 +++++++++++++++++--------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 066a3ce..f619fb3 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -126,7 +126,8 @@ static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
 				  u32 ul_num_bytes,
 				  struct hw_mmu_map_attrs_t *hw_attrs);
 
-bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
+bool wait_for_start(struct bridge_dev_context *dev_context,
+			void __iomem *sync_addr);
 
 /*  ----------------------------------- Globals */
 
@@ -363,10 +364,11 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = dev_ctxt;
-	u32 dw_sync_addr = 0;
+	void __iomem *sync_addr;
 	u32 ul_shm_base;	/* Gpp Phys SM base addr(byte) */
 	u32 ul_shm_base_virt;	/* Dsp Virt SM base addr */
 	u32 ul_tlb_base_virt;	/* Base of MMU TLB entry */
+	u32 shm_sync_pa;
 	/* Offset of shm_base_virt from tlb_base_virt */
 	u32 ul_shm_offset_virt;
 	s32 entry_ndx;
@@ -397,15 +399,22 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	/* Kernel logical address */
 	ul_shm_base = dev_context->atlb_entry[0].gpp_va + ul_shm_offset_virt;
 
+	/* SHM physical sync address */
+	shm_sync_pa = dev_context->atlb_entry[0].gpp_pa + ul_shm_offset_virt +
+			SHMSYNCOFFSET;
+
 	/* 2nd wd is used as sync field */
-	dw_sync_addr = ul_shm_base + SHMSYNCOFFSET;
+	sync_addr = ioremap(shm_sync_pa, SZ_32);
+	if (!sync_addr)
+		return -ENOMEM;
+
 	/* Write a signature into the shm base + offset; this will
 	 * get cleared when the DSP program starts. */
 	if ((ul_shm_base_virt == 0) || (ul_shm_base == 0)) {
 		pr_err("%s: Illegal SM base\n", __func__);
 		status = -EPERM;
 	} else
-		__raw_writel(0xffffffff, dw_sync_addr);
+		__raw_writel(0xffffffff, sync_addr);
 
 	if (!status) {
 		resources = dev_context->resources;
@@ -419,8 +428,10 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			 * function is made available.
 			 */
 			void __iomem *ctrl = ioremap(0x48002000, SZ_4K);
-			if (!ctrl)
+			if (!ctrl) {
+				iounmap(sync_addr);
 				return -ENOMEM;
+			}
 
 			(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK,
 					OMAP3430_RST1_IVA2_MASK, OMAP3430_IVA2_MOD,
@@ -588,15 +599,15 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
-		dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", dw_sync_addr);
+		dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", *(u32 *)sync_addr);
 		dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dsp_addr);
 		if (dsp_debug)
-			while (__raw_readw(dw_sync_addr))
+			while (__raw_readw(sync_addr))
 				;
 
 		/* Wait for DSP to clear word in shared memory */
 		/* Read the Location */
-		if (!wait_for_start(dev_context, dw_sync_addr))
+		if (!wait_for_start(dev_context, sync_addr))
 			status = -ETIMEDOUT;
 
 		dev_get_symbol(dev_context->dev_obj, "_WDT_enable", &wdt_en);
@@ -612,7 +623,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			/* Write the synchronization bit to indicate the
 			 * completion of OPP table update to DSP
 			 */
-			__raw_writel(0XCAFECAFE, dw_sync_addr);
+			__raw_writel(0XCAFECAFE, sync_addr);
 
 			/* update board state */
 			dev_context->brd_state = BRD_RUNNING;
@@ -621,6 +632,9 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			dev_context->brd_state = BRD_UNKNOWN;
 		}
 	}
+
+	iounmap(sync_addr);
+
 	return status;
 }
 
@@ -1796,12 +1810,13 @@ static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
  *  ======== wait_for_start ========
  *      Wait for the singal from DSP that it has started, or time out.
  */
-bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr)
+bool wait_for_start(struct bridge_dev_context *dev_context,
+			void __iomem *sync_addr)
 {
 	u16 timeout = TIHELEN_ACKTIMEOUT;
 
 	/*  Wait for response from board */
-	while (__raw_readw(dw_sync_addr) && --timeout)
+	while (__raw_readw(sync_addr) && --timeout)
 		udelay(10);
 
 	/*  If timed out: return false */
-- 
1.7.9.5

