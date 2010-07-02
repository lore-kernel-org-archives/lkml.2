Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0GBG1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:27:55 -0400
Received: from smtp.nokia.com ([192.100.122.230]:62292 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0GBG1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:27:51 -0400
Date: Fri, 02 Jul 2010 09:27:31 +0300 (EEST)
Message-Id: <20100702.092731.39168665.Hiroshi.DOYU@nokia.com>
To: x0095840@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, ohad@wizery.com,
       ameya.palande@nokia.com, felipe.contreras@nokia.com
Subject: Re: [PATCH 5/9] dspbridge: add mmufault support
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <1277943660-4112-6-git-send-email-x0095840@ti.com>
References: <1277943660-4112-4-git-send-email-x0095840@ti.com>
	<1277943660-4112-5-git-send-email-x0095840@ti.com>
	<1277943660-4112-6-git-send-email-x0095840@ti.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2010 06:27:38.0001 (UTC) FILETIME=[AA75D010:01CB19AF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

From: ext Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 5/9] dspbridge: add mmufault support
Date: Thu, 1 Jul 2010 02:20:56 +0200

> With changes for iommu migration mmu fault report and dsp track
> dump is broken, this patch fixes that.
> 
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  drivers/dsp/bridge/core/mmu_fault.c  |   93 ++++++---------------------------
>  drivers/dsp/bridge/core/mmu_fault.h  |    5 +-
>  drivers/dsp/bridge/core/tiomap3430.c |    2 +
>  drivers/dsp/bridge/core/ue_deh.c     |   31 +++++-------
>  4 files changed, 34 insertions(+), 97 deletions(-)
> 
> diff --git a/drivers/dsp/bridge/core/mmu_fault.c b/drivers/dsp/bridge/core/mmu_fault.c
> index 5c0124f..d991c6a 100644
> --- a/drivers/dsp/bridge/core/mmu_fault.c
> +++ b/drivers/dsp/bridge/core/mmu_fault.c
> @@ -23,9 +23,12 @@
>  /*  ----------------------------------- Trace & Debug */
>  #include <dspbridge/host_os.h>
>  #include <dspbridge/dbc.h>
> +#include <plat/iommu.h>
>  
>  /*  ----------------------------------- OS Adaptation Layer */
>  #include <dspbridge/drv.h>
> +#include <dspbridge/dev.h>
> +
>  
>  /*  ----------------------------------- Link Driver */
>  #include <dspbridge/dspdeh.h>
> @@ -40,11 +43,6 @@
>  #include "_tiomap.h"
>  #include "mmu_fault.h"
>  
> -static u32 dmmu_event_mask;
> -u32 fault_addr;
> -
> -static bool mmu_check_if_fault(struct bridge_dev_context *dev_context);
> -
>  /*
>   *  ======== mmu_fault_dpc ========
>   *      Deferred procedure call to handle DSP MMU fault.
> @@ -62,78 +60,21 @@ void mmu_fault_dpc(IN unsigned long pRefData)
>   *  ======== mmu_fault_isr ========
>   *      ISR to be triggered by a DSP MMU fault interrupt.
>   */
> -irqreturn_t mmu_fault_isr(int irq, IN void *pRefData)
> -{
> -	struct deh_mgr *deh_mgr_obj = (struct deh_mgr *)pRefData;
> -	struct bridge_dev_context *dev_context;
> -	struct cfg_hostres *resources;
> -
> -	DBC_REQUIRE(irq == INT_DSP_MMU_IRQ);
> -	DBC_REQUIRE(deh_mgr_obj);
> -
> -	if (deh_mgr_obj) {
> -
> -		dev_context =
> -		    (struct bridge_dev_context *)deh_mgr_obj->hbridge_context;
> -
> -		resources = dev_context->resources;
> -
> -		if (!resources) {
> -			dev_dbg(bridge, "%s: Failed to get Host Resources\n",
> -				__func__);
> -			return IRQ_HANDLED;
> -		}
> -		if (mmu_check_if_fault(dev_context)) {
> -			printk(KERN_INFO "***** DSPMMU FAULT ***** IRQStatus "
> -			       "0x%x\n", dmmu_event_mask);
> -			printk(KERN_INFO "***** DSPMMU FAULT ***** fault_addr "
> -			       "0x%x\n", fault_addr);
> -			/*
> -			 * Schedule a DPC directly. In the future, it may be
> -			 * necessary to check if DSP MMU fault is intended for
> -			 * Bridge.
> -			 */
> -			tasklet_schedule(&deh_mgr_obj->dpc_tasklet);
> -
> -			/* Reset err_info structure before use. */
> -			deh_mgr_obj->err_info.dw_err_mask = DSP_MMUFAULT;
> -			deh_mgr_obj->err_info.dw_val1 = fault_addr >> 16;
> -			deh_mgr_obj->err_info.dw_val2 = fault_addr & 0xFFFF;
> -			deh_mgr_obj->err_info.dw_val3 = 0L;
> -			/* Disable the MMU events, else once we clear it will
> -			 * start to raise INTs again */
> -			hw_mmu_event_disable(resources->dw_dmmu_base,
> -					     HW_MMU_TRANSLATION_FAULT);
> -		} else {
> -			hw_mmu_event_disable(resources->dw_dmmu_base,
> -					     HW_MMU_ALL_INTERRUPTS);
> -		}
> -	}
> -	return IRQ_HANDLED;
> -}
> +int mmu_fault_isr(struct iommu *mmu)
>  
> -/*
> - *  ======== mmu_check_if_fault ========
> - *      Check to see if MMU Fault is valid TLB miss from DSP
> - *  Note: This function is called from an ISR
> - */
> -static bool mmu_check_if_fault(struct bridge_dev_context *dev_context)
>  {
> +	struct deh_mgr *dm;
> +	u32 da;
> +
> +	dev_get_deh_mgr(dev_get_first(), &dm);
> +
> +	if (!dm)
> +		return -EPERM;
> +
> +	da = iommu_read_reg(mmu, MMU_FAULT_AD);
> +	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
> +	dm->err_info.dw_val1 = da;
> +	tasklet_schedule(&dm->dpc_tasklet);

I think that the following "iommu_disable()" does disabling MMU.

	Modified arch/arm/plat-omap/iommu.c
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index a202a2c..17407f1 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -800,7 +800,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	if (!stat)
 		return IRQ_HANDLED;
 
-	iommu_disable(obj);
+	iommu_disable(obj);	<- HERE!
 
 	iopgd = iopgd_offset(obj, da);

You can find the latest omap iommu code from:
git://gitorious.org/~doyu/lk/mainline.git v2.6.35-rc3-iommu-for-next

Also I just thought that, passing 'da' to user callback might be
cleaner as below. Then you can avoid the direct access to IOMMU
registers. Basically we should avoid the direct access to IOMMU
registers from client. If you have to, then it would be better to
modify omap iommu code itself.

	Modified arch/arm/plat-omap/iommu.c
diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index a202a2c..64d918e 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -787,13 +787,6 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	if (!obj->refcount)
 		return IRQ_NONE;
 
-	/* Dynamic loading TLB or PTE */
-	if (obj->isr)
-		err = obj->isr(obj);
-
-	if (!err)
-		return IRQ_HANDLED;
-
 	clk_enable(obj->clk);
 	stat = iommu_report_fault(obj, &da);
 	clk_disable(obj->clk);
@@ -802,6 +795,13 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 
 	iommu_disable(obj);
 
+	/* user registered callback */
+	if (obj->isr)
+		err = obj->isr(obj, da);
+
+	if (!err)
+		return IRQ_HANDLED;
+
 	iopgd = iopgd_offset(obj, da);

>  
> -	bool ret = false;
> -	hw_status hw_status_obj;
> -	struct cfg_hostres *resources = dev_context->resources;
> -
> -	if (!resources) {
> -		dev_dbg(bridge, "%s: Failed to get Host Resources in\n",
> -			__func__);
> -		return ret;
> -	}
> -	hw_status_obj =
> -	    hw_mmu_event_status(resources->dw_dmmu_base, &dmmu_event_mask);
> -	if (dmmu_event_mask == HW_MMU_TRANSLATION_FAULT) {
> -		hw_mmu_fault_addr_read(resources->dw_dmmu_base, &fault_addr);
> -		ret = true;
> -	}
> -	return ret;
> +	return 0;
>  }
> diff --git a/drivers/dsp/bridge/core/mmu_fault.h b/drivers/dsp/bridge/core/mmu_fault.h
> index 74db489..df3fba6 100644
> --- a/drivers/dsp/bridge/core/mmu_fault.h
> +++ b/drivers/dsp/bridge/core/mmu_fault.h
> @@ -19,8 +19,6 @@
>  #ifndef MMU_FAULT_
>  #define MMU_FAULT_
>  
> -extern u32 fault_addr;
> -
>  /*
>   *  ======== mmu_fault_dpc ========
>   *      Deferred procedure call to handle DSP MMU fault.
> @@ -31,6 +29,7 @@ void mmu_fault_dpc(IN unsigned long pRefData);
>   *  ======== mmu_fault_isr ========
>   *      ISR to be triggered by a DSP MMU fault interrupt.
>   */
> -irqreturn_t mmu_fault_isr(int irq, IN void *pRefData);
> +int mmu_fault_isr(struct iommu *mmu);
> +
>  
>  #endif /* MMU_FAULT_ */
> diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
> index 96cceea..89867e7 100644
> --- a/drivers/dsp/bridge/core/tiomap3430.c
> +++ b/drivers/dsp/bridge/core/tiomap3430.c
> @@ -57,6 +57,7 @@
>  #include "_tiomap.h"
>  #include "_tiomap_pwr.h"
>  #include "tiomap_io.h"
> +#include "mmu_fault.h"
>  
>  /* Offset in shared mem to write to in order to synchronize start with DSP */
>  #define SHMSYNCOFFSET 4		/* GPP byte offset */
> @@ -382,6 +383,7 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
>  		goto end;
>  	}
>  	dev_context->dsp_mmu = mmu;
> +	mmu->isr = mmu_fault_isr;
>  	sm_sg = dev_context->sh_s;
>  
>  	sm_sg->seg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
> diff --git a/drivers/dsp/bridge/core/ue_deh.c b/drivers/dsp/bridge/core/ue_deh.c
> index ce13e6c..a03d172 100644
> --- a/drivers/dsp/bridge/core/ue_deh.c
> +++ b/drivers/dsp/bridge/core/ue_deh.c
> @@ -18,6 +18,7 @@
>  
>  /*  ----------------------------------- Host OS */
>  #include <dspbridge/host_os.h>
> +#include <plat/iommu.h>
>  
>  /*  ----------------------------------- DSP/BIOS Bridge */
>  #include <dspbridge/std.h>
> @@ -51,12 +52,6 @@
>  #include "_tiomap_pwr.h"
>  #include <dspbridge/io_sm.h>
>  
> -
> -static struct hw_mmu_map_attrs_t map_attrs = { HW_LITTLE_ENDIAN,
> -	HW_ELEM_SIZE16BIT,
> -	HW_MMU_CPUES
> -};
> -
>  static void *dummy_va_addr;
>  
>  int bridge_deh_create(struct deh_mgr **ret_deh_mgr,
> @@ -154,10 +149,10 @@ int bridge_deh_register_notify(struct deh_mgr *deh_mgr, u32 event_mask,
>  void bridge_deh_notify(struct deh_mgr *deh_mgr, u32 ulEventMask, u32 dwErrInfo)
>  {
>  	struct bridge_dev_context *dev_context;
> -	int status = 0;
>  	u32 hw_mmu_max_tlb_count = 31;
>  	struct cfg_hostres *resources;
> -	hw_status hw_status_obj;
> +	u32 fault_addr, tmp;
> +	struct iotlb_entry e;
>  
>  	if (!deh_mgr)
>  		return;
> @@ -181,6 +176,9 @@ void bridge_deh_notify(struct deh_mgr *deh_mgr, u32 ulEventMask, u32 dwErrInfo)
>  		break;
>  	case DSP_MMUFAULT:
>  		/* MMU fault routine should have set err info structure. */
> +		fault_addr = iommu_read_reg(dev_context->dsp_mmu,
> +							MMU_FAULT_AD);
> +
>  		deh_mgr->err_info.dw_err_mask = DSP_MMUFAULT;
>  		dev_err(bridge, "%s: %s, err_info = 0x%x\n",
>  				__func__, "DSP_MMUFAULT", dwErrInfo);
> @@ -206,21 +204,18 @@ void bridge_deh_notify(struct deh_mgr *deh_mgr, u32 ulEventMask, u32 dwErrInfo)
>  			dev_context->num_tlb_entries =
>  				dev_context->fixed_tlb_entries;
>  		}
> -		if (DSP_SUCCEEDED(status)) {
> -			hw_status_obj =
> -				hw_mmu_tlb_add(resources->dw_dmmu_base,
> -						virt_to_phys(dummy_va_addr), fault_addr,
> -						HW_PAGE_SIZE4KB, 1,
> -						&map_attrs, HW_SET, HW_SET);
> -		}
> +		dsp_iotlb_init(&e, fault_addr & PAGE_MASK,
> +			virt_to_phys(dummy_va_addr), IOVMF_PGSZ_4K);
> +		load_iotlb_entry(dev_context->dsp_mmu, &e);
> +
>  
>  		dsp_clk_enable(DSP_CLK_GPT8);
>  
>  		dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
>  
> -		/* Clear MMU interrupt */
> -		hw_mmu_event_ack(resources->dw_dmmu_base,
> -				HW_MMU_TRANSLATION_FAULT);
> +		tmp = iommu_read_reg(dev_context->dsp_mmu, MMU_IRQSTATUS);
> +		iommu_write_reg(dev_context->dsp_mmu, tmp, MMU_IRQSTATUS);
> +

Why is the above necessary?

>  		dump_dsp_stack(deh_mgr->hbridge_context);
>  		dsp_clk_disable(DSP_CLK_GPT8);
>  		break;
> -- 
> 1.6.3.3
> 
