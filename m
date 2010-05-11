Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0EKO77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:59:59 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:60508 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753346Ab0EKO75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:59:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=N2/zxM7HB/20ZJGe5XJRka6DHALc0HZTtqFgvGhGjsov/drcuypCvP1GhJhTENktT6IkRVAqO84bzCLyR90VvkRL3aclMJKph/32qcrP7aD5POfTK9XewWKPomL8k2nD;
Date: Tue, 11 May 2010 07:59:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-ID: <20100511075919.39b768fc@virtuousgeek.org>
In-Reply-To: <20100510220046.3f7cd9bf.akpm@linux-foundation.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
	<20100510220046.3f7cd9bf.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 22:00:46 -0400
Andrew Morton <akpm@linux-foundation.org> wrote:
> > +#define thm_readb(off) readb(ips->regmap + (off))
> > +#define thm_readw(off) readw(ips->regmap + (off))
> > +#define thm_readl(off) readl(ips->regmap + (off))
> > +#define thm_readq(off) readq(ips->regmap + (off))
> > +
> > +#define thm_writeb(off, val) writeb((val), ips->regmap + (off))
> > +#define thm_writew(off, val) writew((val), ips->regmap + (off))
> > +#define thm_writel(off, val) writel((val), ips->regmap + (off))
> 
> ick.
> 
> static inline unsigned short thm_readw(struct ips_driver *ips, unsigned offset)
> {
> 	readw(ips->regmap + offset);
> }
> 
> would be nicer.

Yes, it would.

> >
> > ...
> >
> > +static void ips_enable_cpu_turbo(struct ips_driver *ips)
> > +{
> > +	/* Already on, no need to mess with MSRs */
> > +	if (ips->__cpu_turbo_on)
> > +		return;
> > +
> > +	on_each_cpu(do_enable_cpu_turbo, ips, 1);
> > +
> > +	ips->__cpu_turbo_on = true;
> > +}
> 
> How does the code ensure that a hot-added CPU comes up in the correct
> turbo state?

It doesn't, I guess I'll have to add code to handle the hotplug case.

> > +static bool cpu_exceeded(struct ips_driver *ips, int cpu)
> > +{
> > +	unsigned long flags;
> > +	int avg;
> > +	bool ret = false;
> > +
> > +	spin_lock_irqsave(&ips->turbo_status_lock, flags);
> > +	avg = cpu ? ips->ctv2_avg_temp : ips->ctv1_avg_temp;
> > +	if (avg > (ips->limits->core_temp_limit * 100))
> > +		ret = true;
> > +	if (ips->cpu_avg_power > ips->core_power_limit)
> > +		ret = true;
> > +	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
> > +
> > +	if (ret)
> > +		printk(KERN_CRIT "CPU power or thermal limit exceeded\n");
> > +
> > +	return ret;
> > +}
> 
> afacit these messages might come out at one-per-five-seconds max?
> 
> I bet the driver blows up and someone's logs get spammed ;)

Possibly. :)  I added these at the request of Pavel; I could make them
just print one time though...

> > +sleep:
> > +		schedule_timeout_interruptible(msecs_to_jiffies(IPS_ADJUST_PERIOD));
> > +	} while(!kthread_should_stop());
> 
> please run checkpatch.
> 
> > +	dev_dbg(&ips->dev->dev, "ips-adjust thread stopped\n");
> > +
> > +	return 0;
> > +}
> 
> Did we really need a new kernel thread for this?  Can't use
> schedule_delayed_work() or something?  Maybe slow-work, or one of the
> other just-like-workqueues-only-different things we seem to keep
> adding?

Possibly, but I'm not sure if it would be a net code or complexity
win...  kthreads seem simple enough for this case, and since the driver
only works on small CPU count machines, the extra threads don't seem to
be a big deal.

> 
> > +/*
> > + * Helpers for reading out temp/power values and calculating their
> > + * averages for the decision making and monitoring functions.
> > + */
> > +
> > +static u16 calc_avg_temp(struct ips_driver *ips, u16 *array)
> > +{
> > +	u64 total = 0;
> > +	int i;
> > +	u16 avg;
> > +
> > +	for (i = 0; i < IPS_SAMPLE_COUNT; i++)
> > +		total += (u64)(array[i] * 100);
> 
> Actually, that does work.  Somehow the compiler will promote array[i]
> to u64 _before_ doing the multiplication.  I think.  Still, it looks
> like a deliberate attempt to trick the compiler into doing a
> multiplicative overflow ;)
> 
> > +	avg = (u16)(total / (u64)IPS_SAMPLE_COUNT);
> 
> Are you sure this won't emit a call to a non-existent 64-bit-divide
> library function on i386?
> 
> Did you mean for the driver to be available on 32-bit?

Oh I forgot to include the 32 bit fixes here; I'll need to convert
these to do_div64 I suppose.


> > +		last_msecs = jiffies_to_msecs(jiffies);
> > +		expire = jiffies + msecs_to_jiffies(IPS_SAMPLE_PERIOD);
> > +		mod_timer(&timer, expire);
> > +
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> 
> This looks racy.  Should set TASK_UNINTERRUPTIBLE _before_ arming the
> timer.

Ah ok, will fix.

> 
> > +		schedule();
> > +		__set_current_state(TASK_RUNNING);
> 
> Unneeded - schedule() always returns in state TASK_RUNNING.

Great.

> 
> > +		/* Calculate actual sample period for power averaging */
> > +		last_sample_period = jiffies_to_msecs(jiffies) - last_msecs;
> > +		if (!last_sample_period)
> > +			last_sample_period = 1;
> > +	} while(!kthread_should_stop());
> > +
> > +	del_timer(&timer);
> 
> Should be del_timer_sync(), I suspect.

Wouldn't hurt at least.

> > +static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
> > +{
> > +	u64 turbo_power, misc_en;
> > +	struct ips_mcp_limits *limits = NULL;
> > +	u16 tdp;
> > +
> > +	if (!(boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 37)) {
> 
> We don't have #defines for these things?

I don't think so; they correspond to long marketing strings afaik.

> > +		dev_info(&ips->dev->dev, "Non-IPS CPU detected.\n");
> > +		goto out;
> > +	}
> > +
> > +	rdmsrl(IA32_MISC_ENABLE, misc_en);
> > +	/*
> > +	 * If the turbo enable bit isn't set, we shouldn't try to enable/disable
> > +	 * turbo manually or we'll get an illegal MSR access, even though
> > +	 * turbo will still be available.
> > +	 */
> > +	if (!(misc_en & IA32_MISC_TURBO_EN))
> > +		; /* add turbo MSR write allowed flag if necessary */
> > +
> > +	if (strstr(boot_cpu_data.x86_model_id, "CPU       M"))
> > +		limits = &ips_sv_limits;
> > +	else if (strstr(boot_cpu_data.x86_model_id, "CPU       L"))
> > +		limits = &ips_lv_limits;
> > +	else if (strstr(boot_cpu_data.x86_model_id, "CPU       U"))
> > +		limits = &ips_ulv_limits;
> > +	else
> > +		dev_info(&ips->dev->dev, "No CPUID match found.\n");
> > +
> > +	rdmsrl(TURBO_POWER_CURRENT_LIMIT, turbo_power);
> > +	tdp = turbo_power & TURBO_TDP_MASK;
> > +
> > +	/* Sanity check TDP against CPU */
> > +	if (limits->mcp_power_limit != (tdp / 8) * 1000) {
> > +		dev_warn(&ips->dev->dev, "Warning: CPU TDP doesn't match expected value (found %d, expected %d)\n",
> > +			 tdp / 8, limits->mcp_power_limit / 1000);
> > +	}
> > +
> > +out:
> > +	return limits;
> > +}
> >
> > ...
> >
> > +static struct pci_device_id ips_id_table[] = {
> 
> DEFINE_PCI_DEVICE_TABLE()?

I guess that would be a little cleaner.

> 
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> > +		     PCI_DEVICE_ID_INTEL_THERMAL_SENSOR), },
> > +	{ 0, }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, ips_id_table);
> > +
> > +static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
> > +{
> > +	u64 platform_info;
> > +	struct ips_driver *ips;
> > +	u32 hts;
> > +	int ret = 0;
> > +	u16 htshi, trc, trc_required_mask;
> > +	u8 tse;
> > +
> > +	ips = kzalloc(sizeof(struct ips_driver), GFP_KERNEL);
> > +	if (!ips)
> > +		return -ENOMEM;
> > +
> > +	pci_set_drvdata(dev, ips);
> > +	ips->dev = dev;
> > +
> > +	ips->limits = ips_detect_cpu(ips);
> > +	if (!ips->limits) {
> > +		dev_info(&dev->dev, "IPS not supported on this CPU\n");
> > +		ret = -ENODEV;
> 
> hpa sez ENXIO.

Oh I've never used that value before, fine with me.

> 
> > +		goto error_free;
> > +	}
> > +
> > +	spin_lock_init(&ips->turbo_status_lock);
> > +
> > +	if (!pci_resource_start(dev, 0)) {
> > +		dev_err(&dev->dev, "TBAR not assigned, aborting\n");
> > +		ret = -ENODEV;
> 
> ditto.  And there are more.
> 
> > +		goto error_free;
> > +	}
> > +
> > +	ret = pci_request_regions(dev, "ips thermal sensor");
> > +	if (ret) {
> > +		dev_err(&dev->dev, "thermal resource busy, aborting\n");
> > +		ret = -EBUSY;
> > +		goto error_free;
> > +	}
> 
> There doesn't seem to be much point in assigning the
> pci_request_regions() return value to `ret'.  It could just do
> 
> 	if (pci_request_regions(...)) {
> 		...
> 	}
> 
> or, better, propagate the pci_request_regions() return value.

Yeah, I should remove the forced -EBUSY; though I think that's the only
things pci_request_regions can return anyway...


> > +	if (ret) {
> > +		dev_err(&dev->dev, "request irq failed, aborting\n");
> > +		ret = -EBUSY;
> 
> Again, don't trash callee's error code - propagate it.

Yep.

> 
> > +		goto error_unmap;
> > +	}
> > +
> > +	/* Enable aux, hot & critical interrupts */
> > +	thm_writeb(THM_TSPIEN, TSPIEN_AUX2_LOHI | TSPIEN_CRIT_LOHI |
> > +		   TSPIEN_HOT_LOHI | TSPIEN_AUX_LOHI);
> > +	thm_writeb(THM_TEN, TEN_UPDATE_EN);
> > +
> > +	/* Collect adjustment values */
> > +	ips->cta_val = thm_readw(THM_CTA);
> > +	ips->pta_val = thm_readw(THM_PTA);
> > +	ips->mgta_val = thm_readw(THM_MGTA);
> > +
> > +	/* Save turbo limits & ratios */
> > +	rdmsrl(TURBO_POWER_CURRENT_LIMIT, ips->orig_turbo_limit);
> > +
> > +	ips_enable_cpu_turbo(ips);
> > +	ips->cpu_turbo_enabled = true;
> > +
> > +	/* Set up the work queue and monitor/adjust threads */
> > +	ips->monitor = kthread_run(ips_monitor, ips, "ips-monitor");
> > +	if (!ips->monitor) {
> > +		dev_err(&dev->dev,
> > +			"failed to create thermal monitor thread, aborting\n");
> > +		ret = -ENOMEM;
> > +		goto error_free_irq;
> > +	}
> > +
> > +	ips->adjust = kthread_create(ips_adjust, ips, "ips-adjust");
> 
> Nope, kthread_run() returns IS_ERR() on error.

Oops, will fix.


> > +#ifdef CONFIG_PM
> > +	.suspend = ips_suspend,
> > +	.resume = ips_resume,
> > +#endif
> 
> and nuke the ifdefs.

Will do.

> 
> > +	.shutdown = ips_shutdown,
> > +};
> > +
> >
> > ...
> >
> 
> 
> I applied both patches, did `make allmodconfig' and tried to make
> drivers/platform/x86/intel_ips.o:
> 
> drivers/platform/x86/intel_ips.c: In function 'ips_get_i915_syms':
> drivers/platform/x86/intel_ips.c:1361: error: 'i915_read_mch_val' undeclared (first use in this function)
> drivers/platform/x86/intel_ips.c:1361: error: (Each undeclared identifier is reported only once
> drivers/platform/x86/intel_ips.c:1361: error: for each function it appears in.)
> drivers/platform/x86/intel_ips.c:1361: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/intel_ips.c:1361: warning: cast from pointer to integer of different size
> drivers/platform/x86/intel_ips.c:1361: warning: assignment makes pointer from integer without a cast
> drivers/platform/x86/intel_ips.c:1364: error: 'i915_gpu_raise' undeclared (first use in this function)
> drivers/platform/x86/intel_ips.c:1364: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/intel_ips.c:1364: warning: cast from pointer to integer of different size
> drivers/platform/x86/intel_ips.c:1364: warning: assignment makes pointer from integer without a cast
> drivers/platform/x86/intel_ips.c:1367: error: 'i915_gpu_lower' undeclared (first use in this function)
> drivers/platform/x86/intel_ips.c:1367: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/intel_ips.c:1367: warning: cast from pointer to integer of different size
> drivers/platform/x86/intel_ips.c:1367: warning: assignment makes pointer from integer without a cast
> drivers/platform/x86/intel_ips.c:1370: error: 'i915_gpu_busy' undeclared (first use in this function)
> drivers/platform/x86/intel_ips.c:1370: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/intel_ips.c:1370: warning: cast from pointer to integer of different size
> drivers/platform/x86/intel_ips.c:1370: warning: assignment makes pointer from integer without a cast
> drivers/platform/x86/intel_ips.c:1373: error: 'i915_gpu_turbo_disable' undeclared (first use in this function)
> drivers/platform/x86/intel_ips.c:1373: warning: type defaults to 'int' in declaration of 'type name'
> drivers/platform/x86/intel_ips.c:1373: warning: cast from pointer to integer of different size
> drivers/platform/x86/intel_ips.c:1373: warning: assignment makes pointer from integer without a cast
> 
> Both x86_64 and i386 fail.

Arg, forgot to include the i915_drm.h changes in the patch (they're
sitting right here in my tree preventing compiler errors); will fix.

-- 
Jesse Barnes, Intel Open Source Technology Center
