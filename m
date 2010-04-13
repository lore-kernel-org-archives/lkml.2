Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0DMTZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:25:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52359 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857Ab0DMTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:25:07 -0400
Date: Tue, 13 Apr 2010 21:24:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
	driver
Message-ID: <20100413192453.GB9548@ucw.cz>
References: <1269646146-13296-1-git-send-email-jbarnes@virtuousgeek.org> <1269646146-13296-3-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269646146-13296-3-git-send-email-jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Intel Core i3/5 platforms with integrated graphics support both CPU and
> GPU turbo mode.  CPU turbo mode is opportunistic: the CPU will use any
> available power to increase core frequencies if thermal headroom is
> available.  The GPU side is more manual however; the graphics driver
> must monitor GPU power and temperature and coordinate with a core
> thermal driver to take advantage of available thermal and power headroom
> in the package.

Interesting...

> + * Copyright ÂŠ 2009-2010 Intel Corporation

AC?

> + * The basic algorithm is driven by a 5s moving average of tempurature.  If
> + * thermal headroom is available, the CPU and/or GPU power clamps may be
> + * adjusted upwards.  If we hit the thermal ceiling or a thermal trigger,
> + * we scale back the clamp.  Aside from trigger events (when we're critically
> + * close or over our TDP) we don't adjust the clamps more than once every
> + * five seconds.

Ok, if this driver screws up will

a) cpu/gpu protect itself from damage by overheat?

b) cpu/gpu protect itself from incorrect operation resulting from
overtemp?

> + * Related documents:
> + *   - CDI 403777, 403778 - Auburndale EDS vol 1 & 2
> + *   - CDI 401376 - Ibex Peak EDS
> + *   - ref 26037, 26641 - IPS BIOS spec
> + *   - ref 26489 - Nehalem BIOS writer's guide
> + *   - ref 26921 - Ibex Peak BIOS Specification

http references would be nice.

> +	int core_temp_limit; /* Â°C */

AdegreesC? (More then one instance; avoid unicode?)

> +/**
> + * ips_cpu_busy - is CPU busy?
> + * @ips: IPS driver struct
> + *
> + * Check CPU for load to see whether we should increase its thermal budget.
> + *
> + * RETURNS:
> + * True if the CPU could use more power, false otherwise.
> + */
> +static bool ips_cpu_busy(struct ips_driver *ips)
> +{
> +	if ((avenrun[0] >> FSHIFT) > 1)
> +		return true;
> +
> +	return false;
> +}

return (averun > 1); ?

But this is wrong test, anyway. One process waiting for disk, and you
have D state and load average > 1, without cpu load.

> +/**
> + * ips_enable_cpu_turbo - enable turbo mode on all CPUs
> + * @ips: IPS driver struct
> + *
> + * Enable turbo mode by clearing the disable bit in IA32_PERF_CTL on
> + * all logical threads.
> + */
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
> +
> +/**
> + * do_disable_cpu_turbo - internal turbo disable function
> + * @data: unused
> + *
> + * Internal function for actually updating MSRs.  When we enable/disable
> + * turbo, we need to do it on each CPU; this function is the one called
> + * by on_each_cpu() when needed.
> + */
> +static void do_disable_cpu_turbo(void *data)
> +{
> +	u64 perf_ctl;
> +
> +	rdmsrl(IA32_PERF_CTL, perf_ctl);
> +	if (!(perf_ctl & IA32_PERF_TURBO_DIS)) {
> +		perf_ctl |= IA32_PERF_TURBO_DIS;
> +		wrmsrl(IA32_PERF_CTL, perf_ctl);
> +	}
> +}
> +
> +/**
> + * ips_disable_cpu_turbo - disable turbo mode on all CPUs
> + * @ips: IPS driver struct
> + *
> + * Disable turbo mode by setting the disable bit in IA32_PERF_CTL on
> + * all logical threads.
> + */
> +static void ips_disable_cpu_turbo(struct ips_driver *ips)
> +{
> +	/* Already off, leave it */
> +	if (!ips->__cpu_turbo_on)
> +		return;
> +
> +	on_each_cpu(do_disable_cpu_turbo, ips, 1);
> +
> +	ips->__cpu_turbo_on = false;
> +}

Merge above four functions into two, by having 'enable' parameter?

Wha tprotects you against races?

> +/**
> + * ips_gpu_busy - is GPU busy?
> + * @ips: IPS driver struct
> + *
> + * Check GPU for load to see whether we should increase its thermal budget.
> + * We need to call into the i915 driver in this case.
> + *
> + * RETURNS:
> + * True if the GPU could use more power, false otherwise.
> + */
> +static bool ips_gpu_busy(struct ips_driver *ips)
> +{
> +	return false;
> +}

Uh ouch :-).



> +/**
> + * mcp_exceeded - check whether we're outside our thermal & power limits
> + * @ips: IPS driver struct
> + *
> + * Check whether the MCP is over its thermal or power budget.
> + */
> +static bool mcp_exceeded(struct ips_driver *ips)
> +{
> +	unsigned long flags;
> +	bool ret = false;
> +
> +	spin_lock_irqsave(&ips->turbo_status_lock, flags);
> +	if (ips->mcp_avg_temp > (ips->mcp_temp_limit * 100))
> +		ret = true;
> +	if (ips->cpu_avg_power + ips->mch_avg_power > ips->mcp_power_limit)
> +		ret = true;
> +	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
> +
> +	return ret;
> +}

...and printk(kern_crit, as this should never happen?)


> +/**
> + * cpu_exceeded - check whether a CPU core is outside its limits
> + * @ips: IPS driver struct
> + * @cpu: CPU number to check
> + *
> + * Check a given CPU's average temp or power is over its limit.
> + */
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
> +	return ret;
> +}

printk?

Does this have hard limit for 2 cores?


> +//	if (ips->mch_avg_power > ips->mch_power_limit)
> +//		ret = true;

remove.

> +	dev_dbg(&ips->dev->dev, "starting ips-adjust thread\n");
> +
> +	/*
> +	 */
> +	do {

?

> +static u32 get_cpu_power(struct ips_driver *ips, u32 *last, int period)
> +{
> +	u32 val;
> +	u32 ret;
> +
> +	/*
> +	 * CEC is in joules/65535.  Take difference over time to
> +	 * get watts.
> +	 */
> +	val = thm_readl(THM_CEC);
> +
> +	/* period is in ms and we want mW */
> +	ret = (((val - *last) * 1000) / period);
> +	ret = (ret * 1000) / 65535;
> +	*last = val;
> +
> +	return ret;
> +}

I wonder if we should have milliwatt_t, msec_t and similar, to aid
with type checking...

> +static int show_cpu_temp(struct seq_file *m, void *data)
> +{
> +	struct ips_driver *ips = m->private;
> +
> +	seq_printf(m, "%d.%dÂ°C\n", ips->ctv1_avg_temp / 100,
> +		   ips->ctv1_avg_temp % 100);
> +
> +	return 0;
> +}
> +

Please no unicode at least in user interfaces. Ouch and it is subtly
wrong. You really want "%d.%02d".

Ok, interesting. What kind of speedup can it bring?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
