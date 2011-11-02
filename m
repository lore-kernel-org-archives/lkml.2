Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab1KBPVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:21:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50785 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab1KBPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:21:41 -0400
Date: Wed, 2 Nov 2011 15:21:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] OMAP3/4: iommu: adapt to runtime pm
Message-ID: <20111102152116.GB14916@n2100.arm.linux.org.uk>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com> <1320185752-568-5-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320185752-568-5-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 05:15:52PM -0500, Omar Ramirez Luna wrote:
> Use runtime PM functionality interfaced with hwmod enable/idle
> functions, to replace direct clock operations, reset and sysconfig
> handling.
> 
> Tidspbridge uses a macro removed with this patch, for now the value
> is hardcoded to avoid breaking compilation.

You probably want to include people involved with power management on
this, so maybe the linux-pm mailing list, and those involved with
runtime-pm stuff (I think Rafael qualifies as the maintainer for this
stuff, even if he's not listed in MAINTAINERS.)

> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
> ---
>  arch/arm/mach-omap2/iommu2.c                      |   17 --------
>  arch/arm/mach-omap2/omap-iommu.c                  |    1 -
>  arch/arm/plat-omap/include/plat/iommu.h           |    2 -
>  arch/arm/plat-omap/include/plat/iommu2.h          |    2 -
>  drivers/iommu/omap-iommu.c                        |   46 ++++++++-------------
>  drivers/staging/tidspbridge/core/tiomap3430_pwr.c |    2 +-
>  6 files changed, 19 insertions(+), 51 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
> index 60e3363..5adad97 100644
> --- a/arch/arm/mach-omap2/iommu2.c
> +++ b/arch/arm/mach-omap2/iommu2.c
> @@ -25,15 +25,6 @@
>   */
>  #define IOMMU_ARCH_VERSION	0x00000011
>  
> -/* SYSCONF */
> -#define MMU_SYS_IDLE_SHIFT	3
> -#define MMU_SYS_IDLE_FORCE	(0 << MMU_SYS_IDLE_SHIFT)
> -#define MMU_SYS_IDLE_NONE	(1 << MMU_SYS_IDLE_SHIFT)
> -#define MMU_SYS_IDLE_SMART	(2 << MMU_SYS_IDLE_SHIFT)
> -#define MMU_SYS_IDLE_MASK	(3 << MMU_SYS_IDLE_SHIFT)
> -
> -#define MMU_SYS_AUTOIDLE	1
> -
>  /* IRQSTATUS & IRQENABLE */
>  #define MMU_IRQ_MULTIHITFAULT	(1 << 4)
>  #define MMU_IRQ_TABLEWALKFAULT	(1 << 3)
> @@ -96,11 +87,6 @@ static int omap2_iommu_enable(struct omap_iommu *obj)
>  	dev_info(obj->dev, "%s: version %d.%d\n", obj->name,
>  		 (l >> 4) & 0xf, l & 0xf);
>  
> -	l = iommu_read_reg(obj, MMU_SYSCONFIG);
> -	l &= ~MMU_SYS_IDLE_MASK;
> -	l |= (MMU_SYS_IDLE_SMART | MMU_SYS_AUTOIDLE);
> -	iommu_write_reg(obj, l, MMU_SYSCONFIG);
> -
>  	iommu_write_reg(obj, pa, MMU_TTB);
>  
>  	__iommu_set_twl(obj, true);
> @@ -114,7 +100,6 @@ static void omap2_iommu_disable(struct omap_iommu *obj)
>  
>  	l &= ~MMU_CNTL_MASK;
>  	iommu_write_reg(obj, l, MMU_CNTL);
> -	iommu_write_reg(obj, MMU_SYS_IDLE_FORCE, MMU_SYSCONFIG);
>  
>  	dev_dbg(obj->dev, "%s is shutting down\n", obj->name);
>  }
> @@ -244,8 +229,6 @@ omap2_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t len)
>  	char *p = buf;
>  
>  	pr_reg(REVISION);
> -	pr_reg(SYSCONFIG);
> -	pr_reg(SYSSTATUS);
>  	pr_reg(IRQSTATUS);
>  	pr_reg(IRQENABLE);
>  	pr_reg(WALKING_ST);
> diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
> index 669fd07..cad98c7 100644
> --- a/arch/arm/mach-omap2/omap-iommu.c
> +++ b/arch/arm/mach-omap2/omap-iommu.c
> @@ -34,7 +34,6 @@ static int __init omap_iommu_dev_init(struct omap_hwmod *oh, void *unused)
>  	static int i;
>  
>  	pdata.name = oh->name;
> -	pdata.clk_name = oh->main_clk;
>  	pdata.nr_tlb_entries = a->nr_tlb_entries;
>  	pdata.da_start = a->da_start;
>  	pdata.da_end = a->da_end;
> diff --git a/arch/arm/plat-omap/include/plat/iommu.h b/arch/arm/plat-omap/include/plat/iommu.h
> index 01927a5..3842e99 100644
> --- a/arch/arm/plat-omap/include/plat/iommu.h
> +++ b/arch/arm/plat-omap/include/plat/iommu.h
> @@ -28,7 +28,6 @@ struct iotlb_entry {
>  struct omap_iommu {
>  	const char	*name;
>  	struct module	*owner;
> -	struct clk	*clk;
>  	void __iomem	*regbase;
>  	struct device	*dev;
>  	void		*isr_priv;
> @@ -119,7 +118,6 @@ struct omap_mmu_dev_attr {
>  
>  struct iommu_platform_data {
>  	const char *name;
> -	const char *clk_name;
>  	int nr_tlb_entries;
>  	u32 da_start;
>  	u32 da_end;
> diff --git a/arch/arm/plat-omap/include/plat/iommu2.h b/arch/arm/plat-omap/include/plat/iommu2.h
> index d4116b5..1579694 100644
> --- a/arch/arm/plat-omap/include/plat/iommu2.h
> +++ b/arch/arm/plat-omap/include/plat/iommu2.h
> @@ -19,8 +19,6 @@
>   * MMU Register offsets
>   */
>  #define MMU_REVISION		0x00
> -#define MMU_SYSCONFIG		0x10
> -#define MMU_SYSSTATUS		0x14
>  #define MMU_IRQSTATUS		0x18
>  #define MMU_IRQENABLE		0x1c
>  #define MMU_WALKING_ST		0x40
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index bbbf747..3c55be0 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -16,11 +16,11 @@
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/ioport.h>
> -#include <linux/clk.h>
>  #include <linux/platform_device.h>
>  #include <linux/iommu.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <asm/cacheflush.h>
>  
> @@ -123,11 +123,11 @@ static int iommu_enable(struct omap_iommu *obj)
>  	if (!arch_iommu)
>  		return -ENODEV;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_enable(obj->dev);
> +	pm_runtime_get_sync(obj->dev);
>  
>  	err = arch_iommu->enable(obj);
>  
> -	clk_disable(obj->clk);
>  	return err;
>  }
>  
> @@ -136,11 +136,10 @@ static void iommu_disable(struct omap_iommu *obj)
>  	if (!obj)
>  		return;
>  
> -	clk_enable(obj->clk);
> -
>  	arch_iommu->disable(obj);
>  
> -	clk_disable(obj->clk);
> +	pm_runtime_put_sync(obj->dev);
> +	pm_runtime_disable(obj->dev);
>  }
>  
>  /*
> @@ -264,7 +263,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
>  	if (!obj || !obj->nr_tlb_entries || !e)
>  		return -EINVAL;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  
>  	iotlb_lock_get(obj, &l);
>  	if (l.base == obj->nr_tlb_entries) {
> @@ -294,7 +293,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
>  
>  	cr = iotlb_alloc_cr(obj, e);
>  	if (IS_ERR(cr)) {
> -		clk_disable(obj->clk);
> +		pm_runtime_put(obj->dev);
>  		return PTR_ERR(cr);
>  	}
>  
> @@ -308,7 +307,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
>  		l.vict = l.base;
>  	iotlb_lock_set(obj, &l);
>  out:
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(load_iotlb_entry);
> @@ -339,7 +338,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
>  	int i;
>  	struct cr_regs cr;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  
>  	for_each_iotlb_cr(obj, obj->nr_tlb_entries, i, cr) {
>  		u32 start;
> @@ -358,7 +357,7 @@ static void flush_iotlb_page(struct omap_iommu *obj, u32 da)
>  			iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
>  		}
>  	}
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  
>  	if (i == obj->nr_tlb_entries)
>  		dev_dbg(obj->dev, "%s: no page for %08x\n", __func__, da);
> @@ -393,7 +392,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
>  {
>  	struct iotlb_lock l;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  
>  	l.base = 0;
>  	l.vict = 0;
> @@ -401,7 +400,7 @@ static void flush_iotlb_all(struct omap_iommu *obj)
>  
>  	iommu_write_reg(obj, 1, MMU_GFLUSH);
>  
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  }
>  EXPORT_SYMBOL_GPL(flush_iotlb_all);
>  
> @@ -416,9 +415,9 @@ EXPORT_SYMBOL_GPL(flush_iotlb_all);
>   */
>  void iommu_set_twl(struct omap_iommu *obj, bool on)
>  {
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  	arch_iommu->set_twl(obj, on);
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  }
>  EXPORT_SYMBOL_GPL(iommu_set_twl);
>  
> @@ -429,11 +428,11 @@ ssize_t omap_iommu_dump_ctx(struct omap_iommu *obj, char *buf, ssize_t bytes)
>  	if (!obj || !buf)
>  		return -EINVAL;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  
>  	bytes = arch_iommu->dump_ctx(obj, buf, bytes);
>  
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  
>  	return bytes;
>  }
> @@ -447,7 +446,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
>  	struct cr_regs tmp;
>  	struct cr_regs *p = crs;
>  
> -	clk_enable(obj->clk);
> +	pm_runtime_get_sync(obj->dev);
>  	iotlb_lock_get(obj, &saved);
>  
>  	for_each_iotlb_cr(obj, num, i, tmp) {
> @@ -457,7 +456,7 @@ __dump_tlb_entries(struct omap_iommu *obj, struct cr_regs *crs, int num)
>  	}
>  
>  	iotlb_lock_set(obj, &saved);
> -	clk_disable(obj->clk);
> +	pm_runtime_put(obj->dev);
>  
>  	return  p - crs;
>  }
> @@ -821,9 +820,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
>  	if (!obj->refcount)
>  		return IRQ_NONE;
>  
> -	clk_enable(obj->clk);
>  	errs = iommu_report_fault(obj, &da);
> -	clk_disable(obj->clk);
>  	if (errs == 0)
>  		return IRQ_HANDLED;
>  
> @@ -1010,10 +1007,6 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
>  	if (!obj)
>  		return -ENOMEM;
>  
> -	obj->clk = clk_get(&pdev->dev, pdata->clk_name);
> -	if (IS_ERR(obj->clk))
> -		goto err_clk;
> -
>  	obj->nr_tlb_entries = pdata->nr_tlb_entries;
>  	obj->name = pdata->name;
>  	obj->dev = &pdev->dev;
> @@ -1064,8 +1057,6 @@ err_irq:
>  err_ioremap:
>  	release_mem_region(res->start, resource_size(res));
>  err_mem:
> -	clk_put(obj->clk);
> -err_clk:
>  	kfree(obj);
>  	return err;
>  }
> @@ -1086,7 +1077,6 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
>  	release_mem_region(res->start, resource_size(res));
>  	iounmap(obj->regbase);
>  
> -	clk_put(obj->clk);
>  	dev_info(&pdev->dev, "%s removed\n", obj->name);
>  	kfree(obj);
>  	return 0;
> diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
> index 8889a8c..0b7c29d 100644
> --- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
> +++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
> @@ -329,7 +329,7 @@ int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
>  		omap_mbox_restore_ctx(dev_context->mbox);
>  
>  		/* Access MMU SYS CONFIG register to generate a short wakeup */
> -		iommu_read_reg(dev_context->mmu, MMU_SYSCONFIG);
> +		iommu_read_reg(dev_context->mmu, 0x10);
>  
>  		dev_context->brd_state = BRD_RUNNING;
>  
> -- 
> 1.7.0.4
> 
