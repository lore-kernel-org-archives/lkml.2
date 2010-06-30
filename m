Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0F3XvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:51:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47797 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab0F3Xuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:37 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 6/9] dspbridge: remove hw directory
Date: Wed, 30 Jun 2010 18:59:58 -0500
Message-Id: <1277942401-3566-7-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277942401-3566-6-git-send-email-x0095840@ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw directory only was being used for custom iommu implementation
api's, so after the iommu module migration this directory is not
needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/dspbridge/dspioctl.h |    7 -
 drivers/dsp/bridge/Makefile                     |    3 +-
 drivers/dsp/bridge/core/_tiomap.h               |    1 -
 drivers/dsp/bridge/core/io_sm.c                 |    4 -
 drivers/dsp/bridge/core/mmu_fault.c             |    4 -
 drivers/dsp/bridge/core/tiomap3430.c            |   22 +-
 drivers/dsp/bridge/core/tiomap3430_pwr.c        |  183 +------
 drivers/dsp/bridge/core/tiomap_io.c             |    5 +-
 drivers/dsp/bridge/core/ue_deh.c                |    4 -
 drivers/dsp/bridge/hw/EasiGlobal.h              |   41 --
 drivers/dsp/bridge/hw/GlobalTypes.h             |  308 ------------
 drivers/dsp/bridge/hw/MMUAccInt.h               |   76 ---
 drivers/dsp/bridge/hw/MMURegAcM.h               |  226 ---------
 drivers/dsp/bridge/hw/hw_defs.h                 |   60 ---
 drivers/dsp/bridge/hw/hw_mmu.c                  |  587 -----------------------
 drivers/dsp/bridge/hw/hw_mmu.h                  |  161 -------
 drivers/dsp/bridge/rmgr/node.c                  |    4 +-
 17 files changed, 35 insertions(+), 1661 deletions(-)
 delete mode 100644 drivers/dsp/bridge/hw/EasiGlobal.h
 delete mode 100644 drivers/dsp/bridge/hw/GlobalTypes.h
 delete mode 100644 drivers/dsp/bridge/hw/MMUAccInt.h
 delete mode 100644 drivers/dsp/bridge/hw/MMURegAcM.h
 delete mode 100644 drivers/dsp/bridge/hw/hw_defs.h
 delete mode 100644 drivers/dsp/bridge/hw/hw_mmu.c
 delete mode 100644 drivers/dsp/bridge/hw/hw_mmu.h

diff --git a/arch/arm/plat-omap/include/dspbridge/dspioctl.h b/arch/arm/plat-omap/include/dspbridge/dspioctl.h
index 41e0594..bad1801 100644
--- a/arch/arm/plat-omap/include/dspbridge/dspioctl.h
+++ b/arch/arm/plat-omap/include/dspbridge/dspioctl.h
@@ -19,10 +19,6 @@
 #ifndef DSPIOCTL_
 #define DSPIOCTL_
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*
  * Any IOCTLS at or above this value are reserved for standard Bridge driver
  * interfaces.
@@ -65,9 +61,6 @@ struct bridge_ioctl_extproc {
 	/* GPP virtual address. __va does not work for ioremapped addresses */
 	u32 ul_gpp_va;
 	u32 ul_size;		/* Size of the mapped memory in bytes */
-	enum hw_endianism_t endianism;
-	enum hw_mmu_mixed_size_t mixed_mode;
-	enum hw_element_size_t elem_size;
 };
 
 #endif /* DSPIOCTL_ */
diff --git a/drivers/dsp/bridge/Makefile b/drivers/dsp/bridge/Makefile
index 4c2f923..66ca10a 100644
--- a/drivers/dsp/bridge/Makefile
+++ b/drivers/dsp/bridge/Makefile
@@ -13,10 +13,9 @@ librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 		rmgr/nldr.o rmgr/drv_interface.o
 libdload = dynload/cload.o dynload/getsection.o dynload/reloc.o \
 		 dynload/tramp.o
-libhw = hw/hw_mmu.o
 
 bridgedriver-objs = $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
-			$(libdload) $(libhw)
+			$(libdload)
 
 #Machine dependent
 ccflags-y += -D_TI_ -D_DB_TIOMAP -DTMS32060 \
diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index c41fd8e..35f20a7 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -26,7 +26,6 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 #include <dspbridge/devdefs.h>
-#include <hw_defs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
 #include <dspbridge/sync.h>
 #include <dspbridge/clk.h>
diff --git a/drivers/dsp/bridge/core/io_sm.c b/drivers/dsp/bridge/core/io_sm.c
index aca9854..72d64cb 100644
--- a/drivers/dsp/bridge/core/io_sm.c
+++ b/drivers/dsp/bridge/core/io_sm.c
@@ -40,10 +40,6 @@
 #include <dspbridge/ntfy.h>
 #include <dspbridge/sync.h>
 
-/* Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /* Bridge Driver */
 #include <dspbridge/dspdeh.h>
 #include <dspbridge/dspio.h>
diff --git a/drivers/dsp/bridge/core/mmu_fault.c b/drivers/dsp/bridge/core/mmu_fault.c
index d991c6a..54c0bc3 100644
--- a/drivers/dsp/bridge/core/mmu_fault.c
+++ b/drivers/dsp/bridge/core/mmu_fault.c
@@ -33,10 +33,6 @@
 /*  ----------------------------------- Link Driver */
 #include <dspbridge/dspdeh.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*  ----------------------------------- This */
 #include "_deh.h"
 #include <dspbridge/cfg.h>
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index 89867e7..9b6293b 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -34,10 +34,6 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/sync.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*  ----------------------------------- Link Driver */
 #include <dspbridge/dspdefs.h>
 #include <dspbridge/dspchnl.h>
@@ -483,24 +479,18 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	dev_context->mbox->rxq->callback = (int (*)(void *))io_mbox_msg;
 
 /*PM_IVA2GRPSEL_PER = 0xC0;*/
-	temp = (u32) *((reg_uword32 *)
-			((u32) (resources->dw_per_pm_base) + 0xA8));
+	temp = __raw_readl(resources->dw_per_pm_base + 0xA8);
 	temp = (temp & 0xFFFFFF30) | 0xC0;
-	*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8)) =
-	    (u32) temp;
+	__raw_writel(temp, resources->dw_per_pm_base + 0xA8);
 
 /*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
-	temp = (u32) *((reg_uword32 *)
-			((u32) (resources->dw_per_pm_base) + 0xA4));
+	temp = __raw_readl(resources->dw_per_pm_base + 0xA4);
 	temp = (temp & 0xFFFFFF3F);
-	*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4)) =
-	    (u32) temp;
+	__raw_writel(temp, resources->dw_per_pm_base + 0xA4);
 /*CM_SLEEPDEP_PER |= 0x04; */
-	temp = (u32) *((reg_uword32 *)
-			((u32) (resources->dw_per_base) + 0x44));
+	temp = __raw_readl(resources->dw_per_pm_base + 0x44);
 	temp = (temp & 0xFFFFFFFB) | 0x04;
-	*((reg_uword32 *) ((u32) (resources->dw_per_base) + 0x44)) =
-	    (u32) temp;
+	__raw_writel(temp, resources->dw_per_pm_base + 0x44);
 
 /*CM_CLKSTCTRL_IVA2 = 0x00000003 -To Allow automatic transitions */
 	(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_ENABLE_AUTO,
diff --git a/drivers/dsp/bridge/core/tiomap3430_pwr.c b/drivers/dsp/bridge/core/tiomap3430_pwr.c
index a45db99..6746fc5 100644
--- a/drivers/dsp/bridge/core/tiomap3430_pwr.c
+++ b/drivers/dsp/bridge/core/tiomap3430_pwr.c
@@ -27,10 +27,6 @@
 #include <dspbridge/dev.h>
 #include <dspbridge/iodefs.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 #include <dspbridge/pwr_sh.h>
 
 /*  ----------------------------------- Bridge Driver */
@@ -412,7 +408,7 @@ void dsp_clk_wakeup_event_ctrl(u32 ClkId, bool enable)
 	struct cfg_hostres *resources;
 	int status = 0;
 	u32 iva2_grpsel;
-	u32 mpu_grpsel;
+	u32 mpu_grpsel, mask;
 	struct dev_object *hdev_object = NULL;
 	struct bridge_dev_context *bridge_context = NULL;
 
@@ -430,175 +426,46 @@ void dsp_clk_wakeup_event_ctrl(u32 ClkId, bool enable)
 
 	switch (ClkId) {
 	case BPWR_GP_TIMER5:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_GPT5;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_GPT5;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_GPT5;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_GPT5;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = OMAP3430_GRPSEL_GPT5;
 		break;
 	case BPWR_GP_TIMER6:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_GPT6;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_GPT6;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_GPT6;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_GPT6;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = OMAP3430_GRPSEL_GPT6;
 		break;
 	case BPWR_GP_TIMER7:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_GPT7;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_GPT7;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_GPT7;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_GPT7;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = OMAP3430_GRPSEL_GPT7;
 		break;
 	case BPWR_GP_TIMER8:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_GPT8;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_GPT8;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_GPT8;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_GPT8;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = OMAP3430_GRPSEL_GPT8;
 		break;
 	case BPWR_MCBSP1:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_core_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_core_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_MCBSP1;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_MCBSP1;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_MCBSP1;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_MCBSP1;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_core_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_core_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = BPWR_MCBSP1;
 		break;
 	case BPWR_MCBSP2:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_MCBSP2;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_MCBSP2;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_MCBSP2;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_MCBSP2;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = BPWR_MCBSP2;
 		break;
 	case BPWR_MCBSP3:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_MCBSP3;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_MCBSP3;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_MCBSP3;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_MCBSP3;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = BPWR_MCBSP3;
 		break;
 	case BPWR_MCBSP4:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_per_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_per_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_MCBSP4;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_MCBSP4;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_MCBSP4;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_MCBSP4;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = BPWR_MCBSP4;
 		break;
 	case BPWR_MCBSP5:
-		iva2_grpsel = (u32) *((reg_uword32 *)
-				       ((u32) (resources->dw_core_pm_base) +
-					0xA8));
-		mpu_grpsel = (u32) *((reg_uword32 *)
-				      ((u32) (resources->dw_core_pm_base) +
-				       0xA4));
-		if (enable) {
-			iva2_grpsel |= OMAP3430_GRPSEL_MCBSP5;
-			mpu_grpsel &= ~OMAP3430_GRPSEL_MCBSP5;
-		} else {
-			mpu_grpsel |= OMAP3430_GRPSEL_MCBSP5;
-			iva2_grpsel &= ~OMAP3430_GRPSEL_MCBSP5;
-		}
-		*((reg_uword32 *) ((u32) (resources->dw_core_pm_base) + 0xA8))
-		    = iva2_grpsel;
-		*((reg_uword32 *) ((u32) (resources->dw_core_pm_base) + 0xA4))
-		    = mpu_grpsel;
+		mask = BPWR_MCBSP5;
 		break;
+	default:
+		return;
+
 	}
+	iva2_grpsel = __raw_readl(resources->dw_per_pm_base + 0xA8);
+	mpu_grpsel = __raw_readl(resources->dw_per_pm_base + 0xA4);
+	if (enable) {
+		iva2_grpsel |= mask;
+		mpu_grpsel &= ~mask;
+	} else {
+		mpu_grpsel |= mask;
+		iva2_grpsel &= ~mask;
+	}
+	__raw_writel(iva2_grpsel, resources->dw_per_pm_base + 0xA8);
+	__raw_writel(mpu_grpsel, resources->dw_per_pm_base + 0xA4);
+
 }
diff --git a/drivers/dsp/bridge/core/tiomap_io.c b/drivers/dsp/bridge/core/tiomap_io.c
index c23ca66..3c0d3a3 100644
--- a/drivers/dsp/bridge/core/tiomap_io.c
+++ b/drivers/dsp/bridge/core/tiomap_io.c
@@ -142,7 +142,7 @@ int read_ext_dsp_data(struct bridge_dev_context *hDevContext,
 				    ul_shm_base_virt - ul_tlb_base_virt;
 				ul_shm_offset_virt +=
 				    PG_ALIGN_HIGH(ul_ext_end - ul_dyn_ext_base +
-						  1, HW_PAGE_SIZE64KB);
+						  1, PAGE_SIZE * 16);
 				dw_ext_prog_virt_mem -= ul_shm_offset_virt;
 				dw_ext_prog_virt_mem +=
 				    (ul_ext_base - ul_dyn_ext_base);
@@ -394,7 +394,6 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		omap_dspbridge_dev->dev.platform_data;
 	struct cfg_hostres *resources = dev_context->resources;
 	int status = 0;
-	u32 temp;
 
 	if (!dev_context->mbox)
 		return 0;
@@ -438,7 +437,7 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		omap_mbox_restore_ctx(dev_context->mbox);
 
 		/* Access MMU SYS CONFIG register to generate a short wakeup */
-		temp = *(reg_uword32 *) (resources->dw_dmmu_base + 0x10);
+		__raw_readl(resources->dw_dmmu_base + 0x10);
 
 		dev_context->dw_brd_state = BRD_RUNNING;
 	} else if (dev_context->dw_brd_state == BRD_RETENTION) {
diff --git a/drivers/dsp/bridge/core/ue_deh.c b/drivers/dsp/bridge/core/ue_deh.c
index a03d172..72cc6c0 100644
--- a/drivers/dsp/bridge/core/ue_deh.c
+++ b/drivers/dsp/bridge/core/ue_deh.c
@@ -41,10 +41,6 @@
 #include <dspbridge/dspapi.h>
 #include <dspbridge/wdt.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*  ----------------------------------- This */
 #include "mmu_fault.h"
 #include "_tiomap.h"
diff --git a/drivers/dsp/bridge/hw/EasiGlobal.h b/drivers/dsp/bridge/hw/EasiGlobal.h
deleted file mode 100644
index 9b45aa7..0000000
--- a/drivers/dsp/bridge/hw/EasiGlobal.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * EasiGlobal.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _EASIGLOBAL_H
-#define _EASIGLOBAL_H
-#include <linux/types.h>
-
-/*
- * DEFINE:        READ_ONLY, WRITE_ONLY &  READ_WRITE
- *
- * DESCRIPTION: Defines used to describe register types for EASI-checker tests.
- */
-
-#define READ_ONLY    1
-#define WRITE_ONLY   2
-#define READ_WRITE   3
-
-/*
- * MACRO:        _DEBUG_LEVEL1_EASI
- *
- * DESCRIPTION:  A MACRO which can be used to indicate that a particular beach
- *               register access function was called.
- *
- * NOTE:         We currently dont use this functionality.
- */
-#define _DEBUG_LEVEL1_EASI(easiNum)     ((void)0)
-
-#endif /* _EASIGLOBAL_H */
diff --git a/drivers/dsp/bridge/hw/GlobalTypes.h b/drivers/dsp/bridge/hw/GlobalTypes.h
deleted file mode 100644
index 9b55150..0000000
--- a/drivers/dsp/bridge/hw/GlobalTypes.h
+++ /dev/null
@@ -1,308 +0,0 @@
-/*
- * GlobalTypes.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Global HW definitions
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _GLOBALTYPES_H
-#define _GLOBALTYPES_H
-
-/*
- * Definition: TRUE, FALSE
- *
- * DESCRIPTION:  Boolean Definitions
- */
-#ifndef TRUE
-#define FALSE	0
-#define TRUE	(!(FALSE))
-#endif
-
-/*
- * Definition: NULL
- *
- * DESCRIPTION:  Invalid pointer
- */
-#ifndef NULL
-#define NULL	(void *)0
-#endif
-
-/*
- * Definition: RET_CODE_BASE
- *
- * DESCRIPTION:  Base value for return code offsets
- */
-#define RET_CODE_BASE	0
-
-/*
- * Definition: *BIT_OFFSET
- *
- * DESCRIPTION:  offset in bytes from start of 32-bit word.
- */
-#define LOWER16BIT_OFFSET	  0
-#define UPPER16BIT_OFFSET	  2
-
-#define LOWER8BIT_OFFSET	   0
-#define LOWER_MIDDLE8BIT_OFFSET    1
-#define UPPER_MIDDLE8BIT_OFFSET    2
-#define UPPER8BIT_OFFSET	   3
-
-#define LOWER8BIT_OF16_OFFSET      0
-#define UPPER8BIT_OF16_OFFSET      1
-
-/*
- * Definition: *BIT_SHIFT
- *
- * DESCRIPTION:  offset in bits from start of 32-bit word.
- */
-#define LOWER16BIT_SHIFT	  0
-#define UPPER16BIT_SHIFT	  16
-
-#define LOWER8BIT_SHIFT	   0
-#define LOWER_MIDDLE8BIT_SHIFT    8
-#define UPPER_MIDDLE8BIT_SHIFT    16
-#define UPPER8BIT_SHIFT	   24
-
-#define LOWER8BIT_OF16_SHIFT      0
-#define UPPER8BIT_OF16_SHIFT      8
-
-/*
- * Definition: LOWER16BIT_MASK
- *
- * DESCRIPTION: 16 bit mask used for inclusion of lower 16 bits i.e. mask out
- *		the upper 16 bits
- */
-#define LOWER16BIT_MASK	0x0000FFFF
-
-/*
- * Definition: LOWER8BIT_MASK
- *
- * DESCRIPTION: 8 bit masks used for inclusion of 8 bits i.e. mask out
- *		the upper 16 bits
- */
-#define LOWER8BIT_MASK	   0x000000FF
-
-/*
- * Definition: RETURN32BITS_FROM16LOWER_AND16UPPER(lower16Bits, upper16Bits)
- *
- * DESCRIPTION: Returns a 32 bit value given a 16 bit lower value and a 16
- *		bit upper value
- */
-#define RETURN32BITS_FROM16LOWER_AND16UPPER(lower16Bits, upper16Bits)\
-    (((((u32)lower16Bits)  & LOWER16BIT_MASK)) | \
-     (((((u32)upper16Bits) & LOWER16BIT_MASK) << UPPER16BIT_SHIFT)))
-
-/*
- * Definition: RETURN16BITS_FROM8LOWER_AND8UPPER(lower16Bits, upper16Bits)
- *
- * DESCRIPTION:  Returns a 16 bit value given a 8 bit lower value and a 8
- *	       bit upper value
- */
-#define RETURN16BITS_FROM8LOWER_AND8UPPER(lower8Bits, upper8Bits)\
-    (((((u32)lower8Bits)  & LOWER8BIT_MASK)) | \
-     (((((u32)upper8Bits) & LOWER8BIT_MASK) << UPPER8BIT_OF16_SHIFT)))
-
-/*
- * Definition: RETURN32BITS_FROM48BIT_VALUES(lower8Bits, lowerMiddle8Bits,
- * 					lowerUpper8Bits, upper8Bits)
- *
- * DESCRIPTION:  Returns a 32 bit value given four 8 bit values
- */
-#define RETURN32BITS_FROM48BIT_VALUES(lower8Bits, lowerMiddle8Bits,\
-	lowerUpper8Bits, upper8Bits)\
-	(((((u32)lower8Bits) & LOWER8BIT_MASK)) | \
-	(((((u32)lowerMiddle8Bits) & LOWER8BIT_MASK) <<\
-		LOWER_MIDDLE8BIT_SHIFT)) | \
-	(((((u32)lowerUpper8Bits) & LOWER8BIT_MASK) <<\
-		UPPER_MIDDLE8BIT_SHIFT)) | \
-	(((((u32)upper8Bits) & LOWER8BIT_MASK) <<\
-		UPPER8BIT_SHIFT)))
-
-/*
- * Definition: READ_LOWER16BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 16 lower bits of 32bit value
- */
-#define READ_LOWER16BITS_OF32(value32bits)\
-    ((u16)((u32)(value32bits) & LOWER16BIT_MASK))
-
-/*
- * Definition: READ_UPPER16BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 16 lower bits of 32bit value
- */
-#define READ_UPPER16BITS_OF32(value32bits)\
-	(((u16)((u32)(value32bits) >> UPPER16BIT_SHIFT)) &\
-	LOWER16BIT_MASK)
-
-/*
- * Definition: READ_LOWER8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower bits of 32bit value
- */
-#define READ_LOWER8BITS_OF32(value32bits)\
-    ((u8)((u32)(value32bits) & LOWER8BIT_MASK))
-
-/*
- * Definition: READ_LOWER_MIDDLE8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower middle bits of 32bit value
- */
-#define READ_LOWER_MIDDLE8BITS_OF32(value32bits)\
-	(((u8)((u32)(value32bits) >> LOWER_MIDDLE8BIT_SHIFT)) &\
-	LOWER8BIT_MASK)
-
-/*
- * Definition: READ_LOWER_MIDDLE8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 lower middle bits of 32bit value
- */
-#define READ_UPPER_MIDDLE8BITS_OF32(value32bits)\
-	(((u8)((u32)(value32bits) >> LOWER_MIDDLE8BIT_SHIFT)) &\
-	LOWER8BIT_MASK)
-
-/*
- * Definition: READ_UPPER8BITS_OF32(value32bits)
- *
- * DESCRIPTION:  Returns a 8 upper bits of 32bit value
- */
-#define READ_UPPER8BITS_OF32(value32bits)\
-    (((u8)((u32)(value32bits) >> UPPER8BIT_SHIFT)) & LOWER8BIT_MASK)
-
-/*
- * Definition: READ_LOWER8BITS_OF16(value16bits)
- *
- * DESCRIPTION:  Returns a 8 lower bits of 16bit value
- */
-#define READ_LOWER8BITS_OF16(value16bits)\
-    ((u8)((u16)(value16bits) & LOWER8BIT_MASK))
-
-/*
- * Definition: READ_UPPER8BITS_OF16(value32bits)
- *
- * DESCRIPTION:  Returns a 8 upper bits of 16bit value
- */
-#define READ_UPPER8BITS_OF16(value16bits)\
-    (((u8)((u32)(value16bits) >> UPPER8BIT_SHIFT)) & LOWER8BIT_MASK)
-
-/* UWORD16:  16 bit tpyes */
-
-/* reg_uword8, reg_word8: 8 bit register types */
-typedef volatile unsigned char reg_uword8;
-typedef volatile signed char reg_word8;
-
-/* reg_uword16, reg_word16: 16 bit register types */
-#ifndef OMAPBRIDGE_TYPES
-typedef volatile unsigned short reg_uword16;
-#endif
-typedef volatile short reg_word16;
-
-/* reg_uword32, REG_WORD32: 32 bit register types */
-typedef volatile unsigned long reg_uword32;
-
-/* FLOAT
- *
- * Type to be used for floating point calculation. Note that floating point
- * calculation is very CPU expensive, and you should only  use if you
- * absolutely need this. */
-
-/* boolean_t:  Boolean Type True, False */
-/* return_code_t:  Return codes to be returned by all library functions */
-enum return_code_label {
-	RET_OK = 0,
-	RET_FAIL = -1,
-	RET_BAD_NULL_PARAM = -2,
-	RET_PARAM_OUT_OF_RANGE = -3,
-	RET_INVALID_ID = -4,
-	RET_EMPTY = -5,
-	RET_FULL = -6,
-	RET_TIMEOUT = -7,
-	RET_INVALID_OPERATION = -8,
-
-	/* Add new error codes at end of above list */
-
-	RET_NUM_RET_CODES	/* this should ALWAYS be LAST entry */
-};
-
-/* MACRO: RD_MEM8, WR_MEM8
- *
- * DESCRIPTION:  32 bit memory access macros
- */
-#define RD_MEM8(addr)	((u8)(*((u8 *)(addr))))
-#define WR_MEM8(addr, data)	(*((u8 *)(addr)) = (u8)(data))
-
-/* MACRO: RD_MEM8_VOLATILE, WR_MEM8_VOLATILE
- *
- * DESCRIPTION:  8 bit register access macros
- */
-#define RD_MEM8_VOLATILE(addr)	((u8)(*((reg_uword8 *)(addr))))
-#define WR_MEM8_VOLATILE(addr, data) (*((reg_uword8 *)(addr)) = (u8)(data))
-
-/*
- * MACRO: RD_MEM16, WR_MEM16
- *
- * DESCRIPTION:  16 bit memory access macros
- */
-#define RD_MEM16(addr)	((u16)(*((u16 *)(addr))))
-#define WR_MEM16(addr, data)	(*((u16 *)(addr)) = (u16)(data))
-
-/*
- * MACRO: RD_MEM16_VOLATILE, WR_MEM16_VOLATILE
- *
- * DESCRIPTION:  16 bit register access macros
- */
-#define RD_MEM16_VOLATILE(addr)	((u16)(*((reg_uword16 *)(addr))))
-#define WR_MEM16_VOLATILE(addr, data)	(*((reg_uword16 *)(addr)) =\
-					(u16)(data))
-
-/*
- * MACRO: RD_MEM32, WR_MEM32
- *
- * DESCRIPTION:  32 bit memory access macros
- */
-#define RD_MEM32(addr)	((u32)(*((u32 *)(addr))))
-#define WR_MEM32(addr, data)	(*((u32 *)(addr)) = (u32)(data))
-
-/*
- * MACRO: RD_MEM32_VOLATILE, WR_MEM32_VOLATILE
- *
- * DESCRIPTION:  32 bit register access macros
- */
-#define RD_MEM32_VOLATILE(addr)	((u32)(*((reg_uword32 *)(addr))))
-#define WR_MEM32_VOLATILE(addr, data)	(*((reg_uword32 *)(addr)) =\
-					(u32)(data))
-
-/* Not sure if this all belongs here */
-
-#define CHECK_RETURN_VALUE(actualValue, expectedValue,  returnCodeIfMismatch,\
-	spyCodeIfMisMatch)
-#define CHECK_RETURN_VALUE_RET(actualValue, expectedValue, returnCodeIfMismatch)
-#define CHECK_RETURN_VALUE_RES(actualValue, expectedValue, spyCodeIfMisMatch)
-#define CHECK_RETURN_VALUE_RET_VOID(actualValue, expectedValue,\
-	spyCodeIfMisMatch)
-
-#define CHECK_INPUT_PARAM(actualValue, invalidValue, returnCodeIfMismatch,\
-	spyCodeIfMisMatch)
-#define CHECK_INPUT_PARAM_NO_SPY(actualValue, invalidValue,\
-	returnCodeIfMismatch)
-#define CHECK_INPUT_RANGE(actualValue, minValidValue, maxValidValue,\
-	returnCodeIfMismatch, spyCodeIfMisMatch)
-#define CHECK_INPUT_RANGE_NO_SPY(actualValue, minValidValue, maxValidValue,\
-	returnCodeIfMismatch)
-#define CHECK_INPUT_RANGE_MIN0(actualValue, maxValidValue,\
-	returnCodeIfMismatch, spyCodeIfMisMatch)
-#define CHECK_INPUT_RANGE_NO_SPY_MIN0(actualValue, maxValidValue,\
-	returnCodeIfMismatch)
-
-#endif /* _GLOBALTYPES_H */
diff --git a/drivers/dsp/bridge/hw/MMUAccInt.h b/drivers/dsp/bridge/hw/MMUAccInt.h
deleted file mode 100644
index 1cefca3..0000000
--- a/drivers/dsp/bridge/hw/MMUAccInt.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * MMUAccInt.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_ACC_INT_H
-#define _MMU_ACC_INT_H
-
-/* Mappings of level 1 EASI function numbers to function names */
-
-#define EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32 (MMU_BASE_EASIL1 + 3)
-#define EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32  (MMU_BASE_EASIL1 + 17)
-#define EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32    (MMU_BASE_EASIL1 + 39)
-#define EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 51)
-#define EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32 (MMU_BASE_EASIL1 + 102)
-#define EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 103)
-#define EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32 (MMU_BASE_EASIL1 + 156)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32 (MMU_BASE_EASIL1 + 174)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32   (MMU_BASE_EASIL1 + 180)
-#define EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32     (MMU_BASE_EASIL1 + 190)
-#define EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32   (MMU_BASE_EASIL1 + 194)
-#define EASIL1_MMUMMU_TTB_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 198)
-#define EASIL1_MMUMMU_LOCK_READ_REGISTER32   (MMU_BASE_EASIL1 + 203)
-#define EASIL1_MMUMMU_LOCK_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 204)
-#define EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32  (MMU_BASE_EASIL1 + 205)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32 (MMU_BASE_EASIL1 + 209)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32 (MMU_BASE_EASIL1 + 211)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32  (MMU_BASE_EASIL1 + 212)
-#define EASIL1_MMUMMU_LD_TLB_READ_REGISTER32    (MMU_BASE_EASIL1 + 213)
-#define EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 214)
-#define EASIL1_MMUMMU_CAM_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 226)
-#define EASIL1_MMUMMU_RAM_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 268)
-#define EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 322)
-
-/* Register offset address definitions */
-#define MMU_MMU_SYSCONFIG_OFFSET   0x10
-#define MMU_MMU_IRQSTATUS_OFFSET  0x18
-#define MMU_MMU_IRQENABLE_OFFSET    0x1c
-#define MMU_MMU_WALKING_ST_OFFSET 0x40
-#define MMU_MMU_CNTL_OFFSET   0x44
-#define MMU_MMU_FAULT_AD_OFFSET  0x48
-#define MMU_MMU_TTB_OFFSET  0x4c
-#define MMU_MMU_LOCK_OFFSET   0x50
-#define MMU_MMU_LD_TLB_OFFSET  0x54
-#define MMU_MMU_CAM_OFFSET   0x58
-#define MMU_MMU_RAM_OFFSET   0x5c
-#define MMU_MMU_GFLUSH_OFFSET  0x60
-#define MMU_MMU_FLUSH_ENTRY_OFFSET  0x64
-/* Bitfield mask and offset declarations */
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_MASK  0x18
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET  3
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK  0x1
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET   0
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_MASK 0x1
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET  0
-#define MMU_MMU_CNTL_TWL_ENABLE_MASK 0x4
-#define MMU_MMU_CNTL_TWL_ENABLE_OFFSET 2
-#define MMU_MMU_CNTL_MMU_ENABLE_MASK    0x2
-#define MMU_MMU_CNTL_MMU_ENABLE_OFFSET   1
-#define MMU_MMU_LOCK_BASE_VALUE_MASK 0xfc00
-#define MMU_MMU_LOCK_BASE_VALUE_OFFSET   10
-#define MMU_MMU_LOCK_CURRENT_VICTIM_MASK   0x3f0
-#define MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET    4
-
-#endif /* _MMU_ACC_INT_H */
diff --git a/drivers/dsp/bridge/hw/MMURegAcM.h b/drivers/dsp/bridge/hw/MMURegAcM.h
deleted file mode 100644
index 8c0c549..0000000
--- a/drivers/dsp/bridge/hw/MMURegAcM.h
+++ /dev/null
@@ -1,226 +0,0 @@
-/*
- * MMURegAcM.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_REG_ACM_H
-#define _MMU_REG_ACM_H
-
-#include <GlobalTypes.h>
-#include <linux/io.h>
-#include <EasiGlobal.h>
-
-#include "MMUAccInt.h"
-
-#if defined(USE_LEVEL_1_MACROS)
-
-#define MMUMMU_SYSCONFIG_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
-      __raw_readl((baseAddress)+MMU_MMU_SYSCONFIG_OFFSET))
-
-#define MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
-    newValue <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
-    newValue &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
-    newValue <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
-    newValue &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_IRQSTATUS_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUSReadRegister32),\
-      __raw_readl((baseAddress)+MMU_MMU_IRQSTATUS_OFFSET))
-
-#define MMUMMU_IRQSTATUS_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_IRQENABLE_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
-      __raw_readl((baseAddress)+MMU_MMU_IRQENABLE_OFFSET))
-
-#define MMUMMU_IRQENABLE_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_WALKING_STTWL_RUNNING_READ32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
-      (((__raw_readl(((baseAddress)+(MMU_MMU_WALKING_ST_OFFSET))))\
-      & MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
-      MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_READ32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
-      (((__raw_readl(((baseAddress)+(MMU_MMU_CNTL_OFFSET)))) &\
-      MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
-      MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
-    newValue <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
-    newValue &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_CNTLMMU_ENABLE_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
-    newValue <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
-    newValue &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_FAULT_AD_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
-      __raw_readl((baseAddress)+MMU_MMU_FAULT_AD_OFFSET))
-
-#define MMUMMU_TTB_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_TTB_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_LOCK_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
-      __raw_readl((baseAddress)+MMU_MMU_LOCK_OFFSET))
-
-#define MMUMMU_LOCK_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_LOCK_BASE_VALUE_READ32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
-      (((__raw_readl(((baseAddress)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
-      MMU_MMU_LOCK_BASE_VALUE_OFFSET))
-
-#define MMUMMU_LOCK_BASE_VALUE_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCKBaseValueWrite32);\
-    data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
-    newValue <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
-    newValue &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_READ32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
-      (((__raw_readl(((baseAddress)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
-      MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((baseAddress)+offset);\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
-    data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
-    newValue <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
-    newValue &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
-    newValue |= data;\
-    __raw_writel(newValue, baseAddress+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_SET32(var, value)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
-      (((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
-      (((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
-
-#define MMUMMU_LD_TLB_READ_REGISTER32(baseAddress)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
-      __raw_readl((baseAddress)+MMU_MMU_LD_TLB_OFFSET))
-
-#define MMUMMU_LD_TLB_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_CAM_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_CAM_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_RAM_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_RAM_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#define MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(baseAddress, value)\
-{\
-    const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
-    register u32 newValue = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
-    __raw_writel(newValue, (baseAddress)+offset);\
-}
-
-#endif /* USE_LEVEL_1_MACROS */
-
-#endif /* _MMU_REG_ACM_H */
diff --git a/drivers/dsp/bridge/hw/hw_defs.h b/drivers/dsp/bridge/hw/hw_defs.h
deleted file mode 100644
index 98f6045..0000000
--- a/drivers/dsp/bridge/hw/hw_defs.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * hw_defs.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Global HW definitions
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_DEFS_H
-#define _HW_DEFS_H
-
-#include <GlobalTypes.h>
-
-/* Page size */
-#define HW_PAGE_SIZE4KB   0x1000
-#define HW_PAGE_SIZE64KB  0x10000
-#define HW_PAGE_SIZE1MB   0x100000
-#define HW_PAGE_SIZE16MB  0x1000000
-
-/* hw_status:  return type for HW API */
-typedef long hw_status;
-
-/*  Macro used to set and clear any bit */
-#define HW_CLEAR	0
-#define HW_SET		1
-
-/* hw_endianism_t:  Enumerated Type used to specify the endianism
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_endianism_t {
-	HW_LITTLE_ENDIAN,
-	HW_BIG_ENDIAN
-};
-
-/* hw_element_size_t:  Enumerated Type used to specify the element size
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_element_size_t {
-	HW_ELEM_SIZE8BIT,
-	HW_ELEM_SIZE16BIT,
-	HW_ELEM_SIZE32BIT,
-	HW_ELEM_SIZE64BIT
-};
-
-/* hw_idle_mode_t:  Enumerated Type used to specify Idle modes */
-enum hw_idle_mode_t {
-	HW_FORCE_IDLE,
-	HW_NO_IDLE,
-	HW_SMART_IDLE
-};
-
-#endif /* _HW_DEFS_H */
diff --git a/drivers/dsp/bridge/hw/hw_mmu.c b/drivers/dsp/bridge/hw/hw_mmu.c
deleted file mode 100644
index 965b659..0000000
--- a/drivers/dsp/bridge/hw/hw_mmu.c
+++ /dev/null
@@ -1,587 +0,0 @@
-/*
- * hw_mmu.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * API definitions to setup MMU TLB and PTE
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#include <GlobalTypes.h>
-#include <linux/io.h>
-#include "MMURegAcM.h"
-#include <hw_defs.h>
-#include <hw_mmu.h>
-#include <linux/types.h>
-
-#define MMU_BASE_VAL_MASK	0xFC00
-#define MMU_PAGE_MAX	     3
-#define MMU_ELEMENTSIZE_MAX      3
-#define MMU_ADDR_MASK	    0xFFFFF000
-#define MMU_TTB_MASK	     0xFFFFC000
-#define MMU_SECTION_ADDR_MASK    0xFFF00000
-#define MMU_SSECTION_ADDR_MASK   0xFF000000
-#define MMU_PAGE_TABLE_MASK      0xFFFFFC00
-#define MMU_LARGE_PAGE_MASK      0xFFFF0000
-#define MMU_SMALL_PAGE_MASK      0xFFFFF000
-
-#define MMU_LOAD_TLB	0x00000001
-
-/*
- * hw_mmu_page_size_t: Enumerated Type used to specify the MMU Page Size(SLSS)
- */
-enum hw_mmu_page_size_t {
-	HW_MMU_SECTION,
-	HW_MMU_LARGE_PAGE,
-	HW_MMU_SMALL_PAGE,
-	HW_MMU_SUPERSECTION
-};
-
-/*
- * FUNCTION	      : mmu_flush_entry
- *
- * INPUTS:
- *
- *       Identifier      : baseAddress
- *       Type		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- * RETURNS:
- *
- *       Type		: hw_status
- *       Description     : RET_OK		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer
- *						Paramater was set to NULL
- *
- * PURPOSE:	      : Flush the TLB entry pointed by the
- *			lock counter register
- *			even if this entry is set protected
- *
- * METHOD:	       : Check the Input parameter and Flush a
- *			 single entry in the TLB.
- */
-static hw_status mmu_flush_entry(const void __iomem *baseAddress);
-
-/*
- * FUNCTION	      : mmu_set_cam_entry
- *
- * INPUTS:
- *
- *       Identifier      : baseAddress
- *       TypE		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : pageSize
- *       TypE		: const u32
- *       Description     : It indicates the page size
- *
- *       Identifier      : preservedBit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is preserved entry
- *							or not
- *
- *       Identifier      : validBit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is valid entry or not
- *
- *
- *       Identifier      : virtual_addr_tag
- *       Type	    	: const u32
- *       Description     : virtual Address
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : RET_OK		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *						   was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
- *						   of Range
- *
- * PURPOSE:	      	: Set MMU_CAM reg
- *
- * METHOD:	       	: Check the Input parameters and set the CAM entry.
- */
-static hw_status mmu_set_cam_entry(const void __iomem *baseAddress,
-				   const u32 pageSize,
-				   const u32 preservedBit,
-				   const u32 validBit,
-				   const u32 virtual_addr_tag);
-
-/*
- * FUNCTION	      : mmu_set_ram_entry
- *
- * INPUTS:
- *
- *       Identifier      : baseAddress
- *       Type	    	: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : physicalAddr
- *       Type	    	: const u32
- *       Description     : Physical Address to which the corresponding
- *			 virtual   Address shouldpoint
- *
- *       Identifier      : endianism
- *       Type	    	: hw_endianism_t
- *       Description     : endianism for the given page
- *
- *       Identifier      : element_size
- *       Type	    	: hw_element_size_t
- *       Description     : The element size ( 8,16, 32 or 64 bit)
- *
- *       Identifier      : mixed_size
- *       Type	    	: hw_mmu_mixed_size_t
- *       Description     : Element Size to follow CPU or TLB
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : RET_OK		 -- No errors occured
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *							was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
- *							out of Range
- *
- * PURPOSE:	      : Set MMU_CAM reg
- *
- * METHOD:	       : Check the Input parameters and set the RAM entry.
- */
-static hw_status mmu_set_ram_entry(const void __iomem *baseAddress,
-				   const u32 physicalAddr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size);
-
-/* HW FUNCTIONS */
-
-hw_status hw_mmu_enable(const void __iomem *baseAddress)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(baseAddress, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_disable(const void __iomem *baseAddress)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(baseAddress, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_num_locked_set(const void __iomem *baseAddress,
-				u32 numLockedEntries)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_LOCK_BASE_VALUE_WRITE32(baseAddress, numLockedEntries);
-
-	return status;
-}
-
-hw_status hw_mmu_victim_num_set(const void __iomem *baseAddress,
-				u32 victimEntryNum)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(baseAddress, victimEntryNum);
-
-	return status;
-}
-
-hw_status hw_mmu_event_ack(const void __iomem *baseAddress, u32 irqMask)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_IRQSTATUS_WRITE_REGISTER32(baseAddress, irqMask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_disable(const void __iomem *baseAddress, u32 irqMask)
-{
-	hw_status status = RET_OK;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(baseAddress);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(baseAddress, irq_reg & ~irqMask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_enable(const void __iomem *baseAddress, u32 irqMask)
-{
-	hw_status status = RET_OK;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(baseAddress);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(baseAddress, irq_reg | irqMask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_status(const void __iomem *baseAddress, u32 *irqMask)
-{
-	hw_status status = RET_OK;
-
-	*irqMask = MMUMMU_IRQSTATUS_READ_REGISTER32(baseAddress);
-
-	return status;
-}
-
-hw_status hw_mmu_fault_addr_read(const void __iomem *baseAddress, u32 *addr)
-{
-	hw_status status = RET_OK;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
-	/* read values from register */
-	*addr = MMUMMU_FAULT_AD_READ_REGISTER32(baseAddress);
-
-	return status;
-}
-
-hw_status hw_mmu_ttb_set(const void __iomem *baseAddress, u32 TTBPhysAddr)
-{
-	hw_status status = RET_OK;
-	u32 load_ttb;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
-	load_ttb = TTBPhysAddr & ~0x7FUL;
-	/* write values to register */
-	MMUMMU_TTB_WRITE_REGISTER32(baseAddress, load_ttb);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_enable(const void __iomem *baseAddress)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(baseAddress, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_disable(const void __iomem *baseAddress)
-{
-	hw_status status = RET_OK;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(baseAddress, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_flush(const void __iomem *baseAddress, u32 virtualAddr,
-			   u32 pageSize)
-{
-	hw_status status = RET_OK;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t pg_size_bits;
-
-	switch (pageSize) {
-	case HW_PAGE_SIZE4KB:
-		pg_size_bits = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		pg_size_bits = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pg_size_bits = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		pg_size_bits = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return RET_FAIL;
-	}
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtualAddr & MMU_ADDR_MASK) >> 12);
-
-	mmu_set_cam_entry(baseAddress, pg_size_bits, 0, 0, virtual_addr_tag);
-
-	mmu_flush_entry(baseAddress);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_add(const void __iomem *baseAddress,
-			 u32 physicalAddr,
-			 u32 virtualAddr,
-			 u32 pageSize,
-			 u32 entryNum,
-			 struct hw_mmu_map_attrs_t *map_attrs,
-			 s8 preservedBit, s8 validBit)
-{
-	hw_status status = RET_OK;
-	u32 lock_reg;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t mmu_pg_size;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(pageSize, MMU_PAGE_MAX, RET_PARAM_OUT_OF_RANGE,
-			       RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(map_attrs->element_size, MMU_ELEMENTSIZE_MAX,
-			       RET_PARAM_OUT_OF_RANGE, RES_MMU_BASE +
-			       RES_INVALID_INPUT_PARAM);
-
-	switch (pageSize) {
-	case HW_PAGE_SIZE4KB:
-		mmu_pg_size = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		mmu_pg_size = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		mmu_pg_size = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		mmu_pg_size = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return RET_FAIL;
-	}
-
-	lock_reg = MMUMMU_LOCK_READ_REGISTER32(baseAddress);
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtualAddr & MMU_ADDR_MASK) >> 12);
-
-	/* Write the fields in the CAM Entry Register */
-	mmu_set_cam_entry(baseAddress, mmu_pg_size, preservedBit, validBit,
-			  virtual_addr_tag);
-
-	/* Write the different fields of the RAM Entry Register */
-	/* endianism of the page,Element Size of the page (8, 16, 32, 64 bit) */
-	mmu_set_ram_entry(baseAddress, physicalAddr, map_attrs->endianism,
-			  map_attrs->element_size, map_attrs->mixed_size);
-
-	/* Update the MMU Lock Register */
-	/* currentVictim between lockedBaseValue and (MMU_Entries_Number - 1) */
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(baseAddress, entryNum);
-
-	/* Enable loading of an entry in TLB by writing 1
-	   into LD_TLB_REG register */
-	MMUMMU_LD_TLB_WRITE_REGISTER32(baseAddress, MMU_LOAD_TLB);
-
-	MMUMMU_LOCK_WRITE_REGISTER32(baseAddress, lock_reg);
-
-	return status;
-}
-
-hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-			 u32 physicalAddr,
-			 u32 virtualAddr,
-			 u32 pageSize, struct hw_mmu_map_attrs_t *map_attrs)
-{
-	hw_status status = RET_OK;
-	u32 pte_addr, pte_val;
-	s32 num_entries = 1;
-
-	switch (pageSize) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SMALL_PAGE_MASK);
-		pte_val =
-		    ((physicalAddr & MMU_SMALL_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 2);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtualAddr &
-					      MMU_LARGE_PAGE_MASK);
-		pte_val =
-		    ((physicalAddr & MMU_LARGE_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 1);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val =
-		    ((((physicalAddr & MMU_SECTION_ADDR_MASK) |
-		       (map_attrs->endianism << 15) | (map_attrs->
-						       element_size << 10) |
-		       (map_attrs->mixed_size << 17)) & ~0x40000) | 0x2);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SSECTION_ADDR_MASK);
-		pte_val =
-		    (((physicalAddr & MMU_SSECTION_ADDR_MASK) |
-		      (map_attrs->endianism << 15) | (map_attrs->
-						      element_size << 10) |
-		      (map_attrs->mixed_size << 17)
-		     ) | 0x40000 | 0x2);
-		break;
-
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val = (physicalAddr & MMU_PAGE_TABLE_MASK) | 1;
-		break;
-
-	default:
-		return RET_FAIL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = pte_val;
-
-	return status;
-}
-
-hw_status hw_mmu_pte_clear(const u32 pg_tbl_va, u32 virtualAddr, u32 page_size)
-{
-	hw_status status = RET_OK;
-	u32 pte_addr;
-	s32 num_entries = 1;
-
-	switch (page_size) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SMALL_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtualAddr &
-					      MMU_LARGE_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SECTION_ADDR_MASK);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtualAddr &
-					      MMU_SSECTION_ADDR_MASK);
-		break;
-
-	default:
-		return RET_FAIL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = 0;
-
-	return status;
-}
-
-/* mmu_flush_entry */
-static hw_status mmu_flush_entry(const void __iomem *baseAddress)
-{
-	hw_status status = RET_OK;
-	u32 flush_entry_data = 0x1;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
-	/* write values to register */
-	MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(baseAddress, flush_entry_data);
-
-	return status;
-}
-
-/* mmu_set_cam_entry */
-static hw_status mmu_set_cam_entry(const void __iomem *baseAddress,
-				   const u32 pageSize,
-				   const u32 preservedBit,
-				   const u32 validBit,
-				   const u32 virtual_addr_tag)
-{
-	hw_status status = RET_OK;
-	u32 mmu_cam_reg;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-
-	mmu_cam_reg = (virtual_addr_tag << 12);
-	mmu_cam_reg = (mmu_cam_reg) | (pageSize) | (validBit << 2) |
-	    (preservedBit << 3);
-
-	/* write values to register */
-	MMUMMU_CAM_WRITE_REGISTER32(baseAddress, mmu_cam_reg);
-
-	return status;
-}
-
-/* mmu_set_ram_entry */
-static hw_status mmu_set_ram_entry(const void __iomem *baseAddress,
-				   const u32 physicalAddr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size)
-{
-	hw_status status = RET_OK;
-	u32 mmu_ram_reg;
-
-	/*Check the input Parameters */
-	CHECK_INPUT_PARAM(baseAddress, 0, RET_BAD_NULL_PARAM,
-			  RES_MMU_BASE + RES_INVALID_INPUT_PARAM);
-	CHECK_INPUT_RANGE_MIN0(element_size, MMU_ELEMENTSIZE_MAX,
-			       RET_PARAM_OUT_OF_RANGE, RES_MMU_BASE +
-			       RES_INVALID_INPUT_PARAM);
-
-	mmu_ram_reg = (physicalAddr & MMU_ADDR_MASK);
-	mmu_ram_reg = (mmu_ram_reg) | ((endianism << 9) | (element_size << 7) |
-				       (mixed_size << 6));
-
-	/* write values to register */
-	MMUMMU_RAM_WRITE_REGISTER32(baseAddress, mmu_ram_reg);
-
-	return status;
-
-}
diff --git a/drivers/dsp/bridge/hw/hw_mmu.h b/drivers/dsp/bridge/hw/hw_mmu.h
deleted file mode 100644
index 9b13468..0000000
--- a/drivers/dsp/bridge/hw/hw_mmu.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * hw_mmu.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * MMU types and API declarations
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_MMU_H
-#define _HW_MMU_H
-
-#include <linux/types.h>
-
-/* Bitmasks for interrupt sources */
-#define HW_MMU_TRANSLATION_FAULT   0x2
-#define HW_MMU_ALL_INTERRUPTS      0x1F
-
-#define HW_MMU_COARSE_PAGE_SIZE 0x400
-
-/* hw_mmu_mixed_size_t:  Enumerated Type used to specify whether to follow
-			CPU/TLB Element size */
-enum hw_mmu_mixed_size_t {
-	HW_MMU_TLBES,
-	HW_MMU_CPUES
-};
-
-/* hw_mmu_map_attrs_t:  Struct containing MMU mapping attributes */
-struct hw_mmu_map_attrs_t {
-	enum hw_endianism_t endianism;
-	enum hw_element_size_t element_size;
-	enum hw_mmu_mixed_size_t mixed_size;
-	bool donotlockmpupage;
-};
-
-extern hw_status hw_mmu_enable(const void __iomem *baseAddress);
-
-extern hw_status hw_mmu_disable(const void __iomem *baseAddress);
-
-extern hw_status hw_mmu_num_locked_set(const void __iomem *baseAddress,
-				       u32 numLockedEntries);
-
-extern hw_status hw_mmu_victim_num_set(const void __iomem *baseAddress,
-				       u32 victimEntryNum);
-
-/* For MMU faults */
-extern hw_status hw_mmu_event_ack(const void __iomem *baseAddress,
-				  u32 irqMask);
-
-extern hw_status hw_mmu_event_disable(const void __iomem *baseAddress,
-				      u32 irqMask);
-
-extern hw_status hw_mmu_event_enable(const void __iomem *baseAddress,
-				     u32 irqMask);
-
-extern hw_status hw_mmu_event_status(const void __iomem *baseAddress,
-				     u32 *irqMask);
-
-extern hw_status hw_mmu_fault_addr_read(const void __iomem *baseAddress,
-					u32 *addr);
-
-/* Set the TT base address */
-extern hw_status hw_mmu_ttb_set(const void __iomem *baseAddress,
-				u32 TTBPhysAddr);
-
-extern hw_status hw_mmu_twl_enable(const void __iomem *baseAddress);
-
-extern hw_status hw_mmu_twl_disable(const void __iomem *baseAddress);
-
-extern hw_status hw_mmu_tlb_flush(const void __iomem *baseAddress,
-				  u32 virtualAddr, u32 pageSize);
-
-extern hw_status hw_mmu_tlb_add(const void __iomem *baseAddress,
-				u32 physicalAddr,
-				u32 virtualAddr,
-				u32 pageSize,
-				u32 entryNum,
-				struct hw_mmu_map_attrs_t *map_attrs,
-				s8 preservedBit, s8 validBit);
-
-/* For PTEs */
-extern hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-				u32 physicalAddr,
-				u32 virtualAddr,
-				u32 pageSize,
-				struct hw_mmu_map_attrs_t *map_attrs);
-
-extern hw_status hw_mmu_pte_clear(const u32 pg_tbl_va,
-				  u32 page_size, u32 virtualAddr);
-
-static inline u32 hw_mmu_pte_addr_l1(u32 L1_base, u32 va)
-{
-	u32 pte_addr;
-	u32 va31_to20;
-
-	va31_to20 = va >> (20 - 2);	/* Left-shift by 2 here itself */
-	va31_to20 &= 0xFFFFFFFCUL;
-	pte_addr = L1_base + va31_to20;
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_addr_l2(u32 L2_base, u32 va)
-{
-	u32 pte_addr;
-
-	pte_addr = (L2_base & 0xFFFFFC00) | ((va >> 10) & 0x3FC);
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_coarse_l1(u32 pte_val)
-{
-	u32 pte_coarse;
-
-	pte_coarse = pte_val & 0xFFFFFC00;
-
-	return pte_coarse;
-}
-
-static inline u32 hw_mmu_pte_size_l1(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if ((pte_val & 0x3) == 0x1) {
-		/* Points to L2 PT */
-		pte_size = HW_MMU_COARSE_PAGE_SIZE;
-	}
-
-	if ((pte_val & 0x3) == 0x2) {
-		if (pte_val & (1 << 18))
-			pte_size = HW_PAGE_SIZE16MB;
-		else
-			pte_size = HW_PAGE_SIZE1MB;
-	}
-
-	return pte_size;
-}
-
-static inline u32 hw_mmu_pte_size_l2(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if (pte_val & 0x2)
-		pte_size = HW_PAGE_SIZE4KB;
-	else if (pte_val & 0x1)
-		pte_size = HW_PAGE_SIZE64KB;
-
-	return pte_size;
-}
-
-#endif /* _HW_MMU_H */
diff --git a/drivers/dsp/bridge/rmgr/node.c b/drivers/dsp/bridge/rmgr/node.c
index 3d2cf96..e1b3128 100644
--- a/drivers/dsp/bridge/rmgr/node.c
+++ b/drivers/dsp/bridge/rmgr/node.c
@@ -621,9 +621,7 @@ func_cont:
 			ul_gpp_mem_base = (u32) host_res->dw_mem_base[1];
 			off_set = pul_value - dynext_base;
 			ul_stack_seg_addr = ul_gpp_mem_base + off_set;
-			ul_stack_seg_val = (u32) *((reg_uword32 *)
-						    ((u32)
-						     (ul_stack_seg_addr)));
+			ul_stack_seg_val = __raw_readl(ul_stack_seg_addr);
 
 			dev_dbg(bridge, "%s: StackSegVal = 0x%x, StackSegAddr ="
 				" 0x%x\n", __func__, ul_stack_seg_val,
-- 
1.7.0.4

