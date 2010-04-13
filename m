Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0DMTj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:39:57 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37125 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752530Ab0DMTjy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:39:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=puBR3F9A2BwkTi2m58oTCX5hJSBuEwixEBe9bAWi52qu2tuzM32nvUdocf0xsHQTcO4+rTJTYjJNjuOqwKQNt9YrGeKdT8i364ywl81j7WdWPgwhTn2+fVlbrRKKOHN7;
Date: Tue, 13 Apr 2010 12:40:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-ID: <20100413124017.40178399@virtuousgeek.org>
In-Reply-To: <20100413192453.GB9548@ucw.cz>
References: <1269646146-13296-1-git-send-email-jbarnes@virtuousgeek.org>
	<1269646146-13296-3-git-send-email-jbarnes@virtuousgeek.org>
	<20100413192453.GB9548@ucw.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 21:24:53 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > Intel Core i3/5 platforms with integrated graphics support both CPU and
> > GPU turbo mode.  CPU turbo mode is opportunistic: the CPU will use any
> > available power to increase core frequencies if thermal headroom is
> > available.  The GPU side is more manual however; the graphics driver
> > must monitor GPU power and temperature and coordinate with a core
> > thermal driver to take advantage of available thermal and power headroom
> > in the package.
> 
> Interesting...
> 
> > + * Copyright ÂŠ 2009-2010 Intel Corporation
> 
> AC?

Bad character set I guess.  I'll just change it to (c).

> 
> > + * The basic algorithm is driven by a 5s moving average of tempurature.  If
> > + * thermal headroom is available, the CPU and/or GPU power clamps may be
> > + * adjusted upwards.  If we hit the thermal ceiling or a thermal trigger,
> > + * we scale back the clamp.  Aside from trigger events (when we're critically
> > + * close or over our TDP) we don't adjust the clamps more than once every
> > + * five seconds.
> 
> Ok, if this driver screws up will
> 
> a) cpu/gpu protect itself from damage by overheat?
> 
> b) cpu/gpu protect itself from incorrect operation resulting from
> overtemp?

The CPU will end up throttling itself, reducing performance to keep
within its power budget.  The GPU will just end up hanging if it
overheats, but shouldn't be damaged.

> 
> > + * Related documents:
> > + *   - CDI 403777, 403778 - Auburndale EDS vol 1 & 2
> > + *   - CDI 401376 - Ibex Peak EDS
> > + *   - ref 26037, 26641 - IPS BIOS spec
> > + *   - ref 26489 - Nehalem BIOS writer's guide
> > + *   - ref 26921 - Ibex Peak BIOS Specification
> 
> http references would be nice.

They would be, but these docs are only available under NDA.  If you
have a sales or technical contact you can use the numbers here to get
the right docs.

> return (averun > 1); ?
> 
> But this is wrong test, anyway. One process waiting for disk, and you
> have D state and load average > 1, without cpu load.

Yes, I'm happy to have a better test here.  Not that it matters *too*
much though; we'll allocate more power budget to the CPU, but it will
only use it if needed.  Allocating it more power just gives the turbo
boost capability additional frequency bins.  The CPU won't actually use
those bins unless it detects that it can and will provide some benefit.

> 
> > +/**
> > + * ips_enable_cpu_turbo - enable turbo mode on all CPUs
> > + * @ips: IPS driver struct
> > + *
> > + * Enable turbo mode by clearing the disable bit in IA32_PERF_CTL on
> > + * all logical threads.
> > + */
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
> > +
> > +/**
> > + * do_disable_cpu_turbo - internal turbo disable function
> > + * @data: unused
> > + *
> > + * Internal function for actually updating MSRs.  When we enable/disable
> > + * turbo, we need to do it on each CPU; this function is the one called
> > + * by on_each_cpu() when needed.
> > + */
> > +static void do_disable_cpu_turbo(void *data)
> > +{
> > +	u64 perf_ctl;
> > +
> > +	rdmsrl(IA32_PERF_CTL, perf_ctl);
> > +	if (!(perf_ctl & IA32_PERF_TURBO_DIS)) {
> > +		perf_ctl |= IA32_PERF_TURBO_DIS;
> > +		wrmsrl(IA32_PERF_CTL, perf_ctl);
> > +	}
> > +}
> > +
> > +/**
> > + * ips_disable_cpu_turbo - disable turbo mode on all CPUs
> > + * @ips: IPS driver struct
> > + *
> > + * Disable turbo mode by setting the disable bit in IA32_PERF_CTL on
> > + * all logical threads.
> > + */
> > +static void ips_disable_cpu_turbo(struct ips_driver *ips)
> > +{
> > +	/* Already off, leave it */
> > +	if (!ips->__cpu_turbo_on)
> > +		return;
> > +
> > +	on_each_cpu(do_disable_cpu_turbo, ips, 1);
> > +
> > +	ips->__cpu_turbo_on = false;
> > +}
> 
> Merge above four functions into two, by having 'enable' parameter?
> 
> Wha tprotects you against races?

Accesses to these should be protected by the parameter lock.  And I
have two variables to differentiate between the hardware being enabled
vs. the software requesting an enable/disable.  They could probably be
named more clearly.

> > +/**
> > + * ips_gpu_busy - is GPU busy?
> > + * @ips: IPS driver struct
> > + *
> > + * Check GPU for load to see whether we should increase its thermal budget.
> > + * We need to call into the i915 driver in this case.
> > + *
> > + * RETURNS:
> > + * True if the GPU could use more power, false otherwise.
> > + */
> > +static bool ips_gpu_busy(struct ips_driver *ips)
> > +{
> > +	return false;
> > +}
> 
> Uh ouch :-).

This part is useless without the corresponding GPU power patch; that'll
add the proper hooks and callbacks here.

> > +/**
> > + * mcp_exceeded - check whether we're outside our thermal & power limits
> > + * @ips: IPS driver struct
> > + *
> > + * Check whether the MCP is over its thermal or power budget.
> > + */
> > +static bool mcp_exceeded(struct ips_driver *ips)
> > +{
> > +	unsigned long flags;
> > +	bool ret = false;
> > +
> > +	spin_lock_irqsave(&ips->turbo_status_lock, flags);
> > +	if (ips->mcp_avg_temp > (ips->mcp_temp_limit * 100))
> > +		ret = true;
> > +	if (ips->cpu_avg_power + ips->mch_avg_power > ips->mcp_power_limit)
> > +		ret = true;
> > +	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
> > +
> > +	return ret;
> > +}
> 
> ...and printk(kern_crit, as this should never happen?)

Probably wouldn't hurt; but I've given myself some leeway here; if
we're near the limit I'd like this check to return true and forcibly
throttle things back, just to make extra sure we don't go over budget.
On most standard voltage platforms this won't really matter, but on
tightly designed ultra-low voltage platforms it's important we never
hit the limit.

> printk?
> 
> Does this have hard limit for 2 cores?

Yes, I don't believe we'll be doing 4 core Arrandale MCPs.  And
follow-on chips won't need this driver.

> 
> 
> > +//	if (ips->mch_avg_power > ips->mch_power_limit)
> > +//		ret = true;
> 
> remove.
> 
> > +	dev_dbg(&ips->dev->dev, "starting ips-adjust thread\n");
> > +
> > +	/*
> > +	 */
> > +	do {
> 
> ?

What my blank comment wasn't clear? :)

> 
> > +static u32 get_cpu_power(struct ips_driver *ips, u32 *last, int period)
> > +{
> > +	u32 val;
> > +	u32 ret;
> > +
> > +	/*
> > +	 * CEC is in joules/65535.  Take difference over time to
> > +	 * get watts.
> > +	 */
> > +	val = thm_readl(THM_CEC);
> > +
> > +	/* period is in ms and we want mW */
> > +	ret = (((val - *last) * 1000) / period);
> > +	ret = (ret * 1000) / 65535;
> > +	*last = val;
> > +
> > +	return ret;
> > +}
> 
> I wonder if we should have milliwatt_t, msec_t and similar, to aid
> with type checking...

Yeah, keeping track of units better would be handy.

> 
> > +static int show_cpu_temp(struct seq_file *m, void *data)
> > +{
> > +	struct ips_driver *ips = m->private;
> > +
> > +	seq_printf(m, "%d.%dÂ°C\n", ips->ctv1_avg_temp / 100,
> > +		   ips->ctv1_avg_temp % 100);
> > +
> > +	return 0;
> > +}
> > +
> 
> Please no unicode at least in user interfaces. Ouch and it is subtly
> wrong. You really want "%d.%02d".
> 
> Ok, interesting. What kind of speedup can it bring?

For the CPU the perf upside isn't that great, maybe 5% or so, and only
with very specific workloads that take advantage of turbo boost.  For
graphics the upside is significant, at least 15% in my basic tests so
far, but Eric and Keith have measured 3x gains in some cases.

-- 
Jesse Barnes, Intel Open Source Technology Center
