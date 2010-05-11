Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0EKFCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:02:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab0EKFC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:02:28 -0400
Date: Mon, 10 May 2010 22:00:46 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-Id: <20100510220046.3f7cd9bf.akpm@linux-foundation.org>
In-Reply-To: <20100510142652.12ca0824@virtuousgeek.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 14:26:52 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Intel Core i3/5 platforms with integrated graphics support both CPU and
> GPU turbo mode.  CPU turbo mode is opportunistic: the CPU will use any
> available power to increase core frequencies if thermal headroom is
> available.  The GPU side is more manual however; the graphics driver
> must monitor GPU power and temperature and coordinate with a core
> thermal driver to take advantage of available thermal and power headroom
> in the package.
> 
> The intelligent power sharing (IPS) driver is intended to coordinate
> this activity by monitoring MCP (multi-chip package) temperature and
> power, allowing the CPU and/or GPU to increase their power consumption,
> and thus performance, when possible.  The goal is to maximize
> performance within a given platform's TDP (thermal design point).
> 
>
> ...
>
> +#define thm_readb(off) readb(ips->regmap + (off))
> +#define thm_readw(off) readw(ips->regmap + (off))
> +#define thm_readl(off) readl(ips->regmap + (off))
> +#define thm_readq(off) readq(ips->regmap + (off))
> +
> +#define thm_writeb(off, val) writeb((val), ips->regmap + (off))
> +#define thm_writew(off, val) writew((val), ips->regmap + (off))
> +#define thm_writel(off, val) writel((val), ips->regmap + (off))

ick.

static inline unsigned short thm_readw(struct ips_driver *ips, unsigned offset)
{
	readw(ips->regmap + offset);
}

would be nicer.

>
> ...
>
> +static void ips_enable_cpu_turbo(struct ips_driver *ips)
> +{
> +	/* Already on, no need to mess with MSRs */
> +	if (ips->__cpu_turbo_on)
> +		return;
> +
> +	on_each_cpu(do_enable_cpu_turbo, ips, 1);
> +
> +	ips->__cpu_turbo_on = true;
> +}

How does the code ensure that a hot-added CPU comes up in the correct
turbo state?

>
> ...
>
> +static bool cpu_exceeded(struct ips_driver *ips, int cpu)
> +{
> +	unsigned long flags;
> +	int avg;
> +	bool ret = false;
> +
> +	spin_lock_irqsave(&ips->turbo_status_lock, flags);
> +	avg = cpu ? ips->ctv2_avg_temp : ips->ctv1_avg_temp;
> +	if (avg > (ips->limits->core_temp_limit * 100))
> +		ret = true;
> +	if (ips->cpu_avg_power > ips->core_power_limit)
> +		ret = true;
> +	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
> +
> +	if (ret)
> +		printk(KERN_CRIT "CPU power or thermal limit exceeded\n");
> +
> +	return ret;
> +}

afacit these messages might come out at one-per-five-seconds max?

I bet the driver blows up and someone's logs get spammed ;)

>
> ...
>
> +static int ips_adjust(void *data)
> +{
> +	struct ips_driver *ips = data;
> +	unsigned long flags;
> +
> +	dev_dbg(&ips->dev->dev, "starting ips-adjust thread\n");
> +
> +	/*
> +	 * Adjust CPU and GPU clamps every 5s if needed.  Doing it more
> +	 * often isn't recommended due to ME interaction.
> +	 */
> +	do {
> +		bool cpu_busy = ips_cpu_busy(ips);
> +		bool gpu_busy = ips_gpu_busy(ips);
> +
> +		spin_lock_irqsave(&ips->turbo_status_lock, flags);
> +		if (ips->poll_turbo_status)
> +			update_turbo_limits(ips);
> +		spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
> +
> +		/* Update turbo status if necessary */
> +		if (ips->cpu_turbo_enabled)
> +			ips_enable_cpu_turbo(ips);
> +		else
> +			ips_disable_cpu_turbo(ips);
> +
> +		if (ips->gpu_turbo_enabled)
> +			ips_enable_gpu_turbo(ips);
> +		else
> +			ips_disable_gpu_turbo(ips);
> +
> +		/* We're outside our comfort zone, crank them down */
> +		if (!mcp_exceeded(ips)) {
> +			ips_cpu_lower(ips);
> +			ips_gpu_lower(ips);
> +			goto sleep;
> +		}
> +
> +		if (!cpu_exceeded(ips, 0) && cpu_busy)
> +			ips_cpu_raise(ips);
> +		else
> +			ips_cpu_lower(ips);
> +
> +		if (!mch_exceeded(ips) && gpu_busy)
> +			ips_gpu_raise(ips);
> +		else
> +			ips_gpu_lower(ips);
> +
> +sleep:
> +		schedule_timeout_interruptible(msecs_to_jiffies(IPS_ADJUST_PERIOD));
> +	} while(!kthread_should_stop());

please run checkpatch.

> +	dev_dbg(&ips->dev->dev, "ips-adjust thread stopped\n");
> +
> +	return 0;
> +}

Did we really need a new kernel thread for this?  Can't use
schedule_delayed_work() or something?  Maybe slow-work, or one of the
other just-like-workqueues-only-different things we seem to keep
adding?

> +/*
> + * Helpers for reading out temp/power values and calculating their
> + * averages for the decision making and monitoring functions.
> + */
> +
> +static u16 calc_avg_temp(struct ips_driver *ips, u16 *array)
> +{
> +	u64 total = 0;
> +	int i;
> +	u16 avg;
> +
> +	for (i = 0; i < IPS_SAMPLE_COUNT; i++)
> +		total += (u64)(array[i] * 100);

Actually, that does work.  Somehow the compiler will promote array[i]
to u64 _before_ doing the multiplication.  I think.  Still, it looks
like a deliberate attempt to trick the compiler into doing a
multiplicative overflow ;)

> +	avg = (u16)(total / (u64)IPS_SAMPLE_COUNT);

Are you sure this won't emit a call to a non-existent 64-bit-divide
library function on i386?

Did you mean for the driver to be available on 32-bit?

> +	return avg;
> +}
> +
>
> ...
>
> +static int ips_monitor(void *data)
> +{
> +	struct ips_driver *ips = data;
> +	struct timer_list timer;
> +	unsigned long seqno_timestamp, expire, last_msecs, last_sample_period;
> +	int i;
> +	u32 *cpu_samples = NULL, *mchp_samples = NULL, old_cpu_power;
> +	u16 *mcp_samples = NULL, *ctv1_samples = NULL, *ctv2_samples = NULL,
> +		*mch_samples = NULL;
> +	u8 cur_seqno, last_seqno;
> +
> +	mcp_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	ctv1_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	ctv2_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	mch_samples = kzalloc(sizeof(u16) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	cpu_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	mchp_samples = kzalloc(sizeof(u32) * IPS_SAMPLE_COUNT, GFP_KERNEL);
> +	if (!mcp_samples || !ctv1_samples || !ctv2_samples || !mch_samples) {
> +		dev_err(&ips->dev->dev,
> +			"failed to allocate sample array, ips disabled\n");
> +		kfree(mcp_samples);
> +		kfree(ctv1_samples);
> +		kfree(ctv2_samples);
> +		kfree(mch_samples);
> +		kfree(cpu_samples);
> +		kthread_stop(ips->adjust);
> +		return -ENOMEM;
> +	}
> +
> +	last_seqno = (thm_readl(THM_ITV) & ITV_ME_SEQNO_MASK) >>
> +		ITV_ME_SEQNO_SHIFT;
> +	seqno_timestamp = get_jiffies_64();
> +
> +	old_cpu_power = thm_readl(THM_CEC) / 65535;
> +	schedule_timeout_interruptible(msecs_to_jiffies(IPS_SAMPLE_PERIOD));
> +
> +	/* Collect an initial average */
> +	for (i = 0; i < IPS_SAMPLE_COUNT; i++) {
> +		u32 mchp, cpu_power;
> +		u16 val;
> +
> +		mcp_samples[i] = read_ptv(ips);
> +
> +		val = read_ctv(ips, 0);
> +		ctv1_samples[i] = val;
> +
> +		val = read_ctv(ips, 1);
> +		ctv2_samples[i] = val;
> +
> +		val = read_mgtv(ips);
> +		mch_samples[i] = val;
> +
> +		cpu_power = get_cpu_power(ips, &old_cpu_power,
> +					  IPS_SAMPLE_PERIOD);
> +		cpu_samples[i] = cpu_power;
> +
> +		if (ips->read_mch_val) {
> +			mchp = ips->read_mch_val();
> +			mchp_samples[i] = mchp;
> +		}
> +
> +		schedule_timeout_interruptible(msecs_to_jiffies(IPS_SAMPLE_PERIOD));
> +		if (kthread_should_stop())
> +			break;
> +	}
> +
> +	ips->mcp_avg_temp = calc_avg_temp(ips, mcp_samples);
> +	ips->ctv1_avg_temp = calc_avg_temp(ips, ctv1_samples);
> +	ips->ctv2_avg_temp = calc_avg_temp(ips, ctv2_samples);
> +	ips->mch_avg_temp = calc_avg_temp(ips, mch_samples);
> +	ips->cpu_avg_power = calc_avg_power(ips, cpu_samples);
> +	ips->mch_avg_power = calc_avg_power(ips, mchp_samples);
> +	kfree(mcp_samples);
> +	kfree(ctv1_samples);
> +	kfree(ctv2_samples);
> +	kfree(mch_samples);
> +	kfree(cpu_samples);
> +	kfree(mchp_samples);
> +
> +	/* Start the adjustment thread now that we have data */
> +	wake_up_process(ips->adjust);
> +
> +	/*
> +	 * Ok, now we have an initial avg.  From here on out, we track the
> +	 * running avg using a decaying average calculation.  This allows
> +	 * us to reduce the sample frequency if the CPU and GPU are idle.
> +	 */
> +	old_cpu_power = thm_readl(THM_CEC);
> +	schedule_timeout_interruptible(msecs_to_jiffies(IPS_SAMPLE_PERIOD));
> +	last_sample_period = IPS_SAMPLE_PERIOD;
> +
> +	setup_deferrable_timer_on_stack(&timer, monitor_timeout,
> +					(unsigned long)current);
> +	do {
> +		u32 cpu_val, mch_val;
> +		u16 val;
> +
> +		/* MCP itself */
> +		val = read_ptv(ips);
> +		ips->mcp_avg_temp = update_average_temp(ips->mcp_avg_temp, val);
> +
> +		/* Processor 0 */
> +		val = read_ctv(ips, 0);
> +		ips->ctv1_avg_temp =
> +			update_average_temp(ips->ctv1_avg_temp, val);
> +		/* Power */
> +		cpu_val = get_cpu_power(ips, &old_cpu_power,
> +					last_sample_period);
> +		ips->cpu_avg_power =
> +			update_average_power(ips->cpu_avg_power, cpu_val);
> +
> +		if (ips->second_cpu) {
> +			/* Processor 1 */
> +			val = read_ctv(ips, 1);
> +			ips->ctv2_avg_temp =
> +				update_average_temp(ips->ctv2_avg_temp, val);
> +		}
> +
> +		/* MCH */
> +		val = read_mgtv(ips);
> +		ips->mch_avg_temp = update_average_temp(ips->mch_avg_temp, val);
> +		/* Power */
> +		if (ips->read_mch_val) {
> +			mch_val = ips->read_mch_val();
> +			ips->mch_avg_power =
> +				update_average_power(ips->mch_avg_power,
> +						     mch_val);
> +		}
> +
> +		/*
> +		 * Make sure ME is updating thermal regs.
> +		 * Note:
> +		 * If it's been more than a second since the last update,
> +		 * the ME is probably hung.
> +		 */
> +		cur_seqno = (thm_readl(THM_ITV) & ITV_ME_SEQNO_MASK) >>
> +			ITV_ME_SEQNO_SHIFT;
> +		if (cur_seqno == last_seqno &&
> +		    time_after(jiffies, seqno_timestamp + HZ)) {
> +			dev_warn(&ips->dev->dev, "ME failed to update for more than 1s, likely hung\n");
> +		} else {
> +			seqno_timestamp = get_jiffies_64();
> +			last_seqno = cur_seqno;
> +		}
> +
> +		last_msecs = jiffies_to_msecs(jiffies);
> +		expire = jiffies + msecs_to_jiffies(IPS_SAMPLE_PERIOD);
> +		mod_timer(&timer, expire);
> +
> +		__set_current_state(TASK_UNINTERRUPTIBLE);

This looks racy.  Should set TASK_UNINTERRUPTIBLE _before_ arming the
timer.

> +		schedule();
> +		__set_current_state(TASK_RUNNING);

Unneeded - schedule() always returns in state TASK_RUNNING.

> +		/* Calculate actual sample period for power averaging */
> +		last_sample_period = jiffies_to_msecs(jiffies) - last_msecs;
> +		if (!last_sample_period)
> +			last_sample_period = 1;
> +	} while(!kthread_should_stop());
> +
> +	del_timer(&timer);

Should be del_timer_sync(), I suspect.

> +	destroy_timer_on_stack(&timer);
> +
> +	dev_dbg(&ips->dev->dev, "ips-monitor thread stopped\n");
> +
> +	return 0;
> +}

erk, so we have two new kernel threads.  Must we?

>
> ...
>
> +static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
> +{
> +	u64 turbo_power, misc_en;
> +	struct ips_mcp_limits *limits = NULL;
> +	u16 tdp;
> +
> +	if (!(boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 37)) {

We don't have #defines for these things?

> +		dev_info(&ips->dev->dev, "Non-IPS CPU detected.\n");
> +		goto out;
> +	}
> +
> +	rdmsrl(IA32_MISC_ENABLE, misc_en);
> +	/*
> +	 * If the turbo enable bit isn't set, we shouldn't try to enable/disable
> +	 * turbo manually or we'll get an illegal MSR access, even though
> +	 * turbo will still be available.
> +	 */
> +	if (!(misc_en & IA32_MISC_TURBO_EN))
> +		; /* add turbo MSR write allowed flag if necessary */
> +
> +	if (strstr(boot_cpu_data.x86_model_id, "CPU       M"))
> +		limits = &ips_sv_limits;
> +	else if (strstr(boot_cpu_data.x86_model_id, "CPU       L"))
> +		limits = &ips_lv_limits;
> +	else if (strstr(boot_cpu_data.x86_model_id, "CPU       U"))
> +		limits = &ips_ulv_limits;
> +	else
> +		dev_info(&ips->dev->dev, "No CPUID match found.\n");
> +
> +	rdmsrl(TURBO_POWER_CURRENT_LIMIT, turbo_power);
> +	tdp = turbo_power & TURBO_TDP_MASK;
> +
> +	/* Sanity check TDP against CPU */
> +	if (limits->mcp_power_limit != (tdp / 8) * 1000) {
> +		dev_warn(&ips->dev->dev, "Warning: CPU TDP doesn't match expected value (found %d, expected %d)\n",
> +			 tdp / 8, limits->mcp_power_limit / 1000);
> +	}
> +
> +out:
> +	return limits;
> +}
>
> ...
>
> +static struct pci_device_id ips_id_table[] = {

DEFINE_PCI_DEVICE_TABLE()?

> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
> +		     PCI_DEVICE_ID_INTEL_THERMAL_SENSOR), },
> +	{ 0, }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, ips_id_table);
> +
> +static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	u64 platform_info;
> +	struct ips_driver *ips;
> +	u32 hts;
> +	int ret = 0;
> +	u16 htshi, trc, trc_required_mask;
> +	u8 tse;
> +
> +	ips = kzalloc(sizeof(struct ips_driver), GFP_KERNEL);
> +	if (!ips)
> +		return -ENOMEM;
> +
> +	pci_set_drvdata(dev, ips);
> +	ips->dev = dev;
> +
> +	ips->limits = ips_detect_cpu(ips);
> +	if (!ips->limits) {
> +		dev_info(&dev->dev, "IPS not supported on this CPU\n");
> +		ret = -ENODEV;

hpa sez ENXIO.

> +		goto error_free;
> +	}
> +
> +	spin_lock_init(&ips->turbo_status_lock);
> +
> +	if (!pci_resource_start(dev, 0)) {
> +		dev_err(&dev->dev, "TBAR not assigned, aborting\n");
> +		ret = -ENODEV;

ditto.  And there are more.

> +		goto error_free;
> +	}
> +
> +	ret = pci_request_regions(dev, "ips thermal sensor");
> +	if (ret) {
> +		dev_err(&dev->dev, "thermal resource busy, aborting\n");
> +		ret = -EBUSY;
> +		goto error_free;
> +	}

There doesn't seem to be much point in assigning the
pci_request_regions() return value to `ret'.  It could just do

	if (pci_request_regions(...)) {
		...
	}

or, better, propagate the pci_request_regions() return value.

> +	ret = pci_enable_device(dev);
> +	if (ret) {
> +		dev_err(&dev->dev, "can't enable PCI device, aborting\n");
> +		goto error_free;
> +	}

Like that.

> +	ips->regmap = ioremap(pci_resource_start(dev, 0),
> +			      pci_resource_len(dev, 0));
> +	if (!ips->regmap) {
> +		dev_err(&dev->dev, "failed to map thermal regs, aborting\n");
> +		ret = -EBUSY;
> +		goto error_release;
> +	}
> +
> +	tse = thm_readb(THM_TSE);
> +	if (tse != TSE_EN) {
> +		dev_err(&dev->dev, "thermal device not enabled (0x%02x), aborting\n", tse);
> +		ret = -ENODEV;
> +		goto error_unmap;
> +	}
> +
> +	trc = thm_readw(THM_TRC);
> +	trc_required_mask = TRC_CORE1_EN | TRC_CORE_PWR | TRC_MCH_EN;
> +	if ((trc & trc_required_mask) != trc_required_mask) {
> +		dev_err(&dev->dev, "thermal reporting for required devices not enabled, aborting\n");
> +		ret = -ENODEV;
> +		goto error_unmap;
> +	}
> +
> +	if (trc & TRC_CORE2_EN)
> +		ips->second_cpu = true;
> +
> +	if (!ips_get_i915_syms(ips)) {
> +		dev_err(&dev->dev, "failed to get i915 symbols, graphics turbo disabled\n");
> +		ips->gpu_turbo_enabled = false;
> +	} else {
> +		dev_dbg(&dev->dev, "graphics turbo enabled\n");
> +		ips->gpu_turbo_enabled = true;
> +	}
> +
> +	update_turbo_limits(ips);
> +	dev_dbg(&dev->dev, "max cpu power clamp: %dW\n",
> +		ips->mcp_power_limit / 10);
> +	dev_dbg(&dev->dev, "max core power clamp: %dW\n",
> +		ips->core_power_limit / 10);
> +	/* BIOS may update limits at runtime */
> +	if (thm_readl(THM_PSC) & PSP_PBRT)
> +		ips->poll_turbo_status = true;
> +
> +	/*
> +	 * Check PLATFORM_INFO MSR to make sure this chip is
> +	 * turbo capable.
> +	 */
> +	rdmsrl(PLATFORM_INFO, platform_info);
> +	if (!(platform_info & PLATFORM_TDP)) {
> +		dev_err(&dev->dev, "platform indicates TDP override unavailable, aborting\n");
> +		ret = -ENODEV;
> +		goto error_unmap;
> +	}
> +
> +	/*
> +	 * IRQ handler for ME interaction
> +	 * Note: don't use MSI here as the PCH has bugs.
> +	 */
> +	pci_disable_msi(dev);
> +	ret = request_irq(dev->irq, ips_irq_handler, IRQF_SHARED, "ips",
> +			  ips);
> +	if (ret) {
> +		dev_err(&dev->dev, "request irq failed, aborting\n");
> +		ret = -EBUSY;

Again, don't trash callee's error code - propagate it.

> +		goto error_unmap;
> +	}
> +
> +	/* Enable aux, hot & critical interrupts */
> +	thm_writeb(THM_TSPIEN, TSPIEN_AUX2_LOHI | TSPIEN_CRIT_LOHI |
> +		   TSPIEN_HOT_LOHI | TSPIEN_AUX_LOHI);
> +	thm_writeb(THM_TEN, TEN_UPDATE_EN);
> +
> +	/* Collect adjustment values */
> +	ips->cta_val = thm_readw(THM_CTA);
> +	ips->pta_val = thm_readw(THM_PTA);
> +	ips->mgta_val = thm_readw(THM_MGTA);
> +
> +	/* Save turbo limits & ratios */
> +	rdmsrl(TURBO_POWER_CURRENT_LIMIT, ips->orig_turbo_limit);
> +
> +	ips_enable_cpu_turbo(ips);
> +	ips->cpu_turbo_enabled = true;
> +
> +	/* Set up the work queue and monitor/adjust threads */
> +	ips->monitor = kthread_run(ips_monitor, ips, "ips-monitor");
> +	if (!ips->monitor) {
> +		dev_err(&dev->dev,
> +			"failed to create thermal monitor thread, aborting\n");
> +		ret = -ENOMEM;
> +		goto error_free_irq;
> +	}
> +
> +	ips->adjust = kthread_create(ips_adjust, ips, "ips-adjust");

Nope, kthread_run() returns IS_ERR() on error.

> +	if (!ips->adjust) {
> +		dev_err(&dev->dev,
> +			"failed to create thermal adjust thread, aborting\n");
> +		ret = -ENOMEM;
> +		goto error_thread_cleanup;
> +	}
> +
> +	hts = (ips->core_power_limit << HTS_PCPL_SHIFT) |
> +		(ips->mcp_temp_limit << HTS_PTL_SHIFT) | HTS_NVV;
> +	htshi = HTS2_PRST_RUNNING << HTS2_PRST_SHIFT;
> +
> +	thm_writew(THM_HTSHI, htshi);
> +	thm_writel(THM_HTS, hts);
> +
> +	ips_debugfs_init(ips);
> +
> +	dev_info(&dev->dev, "IPS driver initialized, MCP temp limit %d\n",
> +		 ips->mcp_temp_limit);
> +	return ret;
> +
> +error_thread_cleanup:
> +	kthread_stop(ips->monitor);
> +error_free_irq:
> +	free_irq(ips->dev->irq, ips);
> +error_unmap:
> +	iounmap(ips->regmap);
> +error_release:
> +	pci_release_regions(dev);
> +error_free:
> +	kfree(ips);
> +	return ret;
> +}
> +
>
> ...
>
> +#ifdef CONFIG_PM
> +static int ips_suspend(struct pci_dev *dev, pm_message_t state)
> +{
> +	return 0;
> +}
> +
> +static int ips_resume(struct pci_dev *dev)
> +{
> +	return 0;
> +}

#else
#define ips_suspend NULL
#define ips_resume NULL

> +#endif /* CONFIG_PM */
> +
> +static void ips_shutdown(struct pci_dev *dev)
> +{
> +}
> +
> +static struct pci_driver ips_pci_driver = {
> +	.name = "intel ips",
> +	.id_table = ips_id_table,
> +	.probe = ips_probe,
> +	.remove = ips_remove,
> +#ifdef CONFIG_PM
> +	.suspend = ips_suspend,
> +	.resume = ips_resume,
> +#endif

and nuke the ifdefs.

> +	.shutdown = ips_shutdown,
> +};
> +
>
> ...
>


I applied both patches, did `make allmodconfig' and tried to make
drivers/platform/x86/intel_ips.o:

drivers/platform/x86/intel_ips.c: In function 'ips_get_i915_syms':
drivers/platform/x86/intel_ips.c:1361: error: 'i915_read_mch_val' undeclared (first use in this function)
drivers/platform/x86/intel_ips.c:1361: error: (Each undeclared identifier is reported only once
drivers/platform/x86/intel_ips.c:1361: error: for each function it appears in.)
drivers/platform/x86/intel_ips.c:1361: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/intel_ips.c:1361: warning: cast from pointer to integer of different size
drivers/platform/x86/intel_ips.c:1361: warning: assignment makes pointer from integer without a cast
drivers/platform/x86/intel_ips.c:1364: error: 'i915_gpu_raise' undeclared (first use in this function)
drivers/platform/x86/intel_ips.c:1364: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/intel_ips.c:1364: warning: cast from pointer to integer of different size
drivers/platform/x86/intel_ips.c:1364: warning: assignment makes pointer from integer without a cast
drivers/platform/x86/intel_ips.c:1367: error: 'i915_gpu_lower' undeclared (first use in this function)
drivers/platform/x86/intel_ips.c:1367: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/intel_ips.c:1367: warning: cast from pointer to integer of different size
drivers/platform/x86/intel_ips.c:1367: warning: assignment makes pointer from integer without a cast
drivers/platform/x86/intel_ips.c:1370: error: 'i915_gpu_busy' undeclared (first use in this function)
drivers/platform/x86/intel_ips.c:1370: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/intel_ips.c:1370: warning: cast from pointer to integer of different size
drivers/platform/x86/intel_ips.c:1370: warning: assignment makes pointer from integer without a cast
drivers/platform/x86/intel_ips.c:1373: error: 'i915_gpu_turbo_disable' undeclared (first use in this function)
drivers/platform/x86/intel_ips.c:1373: warning: type defaults to 'int' in declaration of 'type name'
drivers/platform/x86/intel_ips.c:1373: warning: cast from pointer to integer of different size
drivers/platform/x86/intel_ips.c:1373: warning: assignment makes pointer from integer without a cast

Both x86_64 and i386 fail.
