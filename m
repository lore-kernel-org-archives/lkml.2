Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1AXJHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:07:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45522 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1AXJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:07:29 -0500
Date: Mon, 24 Jan 2011 09:07:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        Gary King <gking@nvidia.com>, linux-kernel@vger.kernel.org,
        olof@lixom.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] ARM: tegra: Add suspend and hotplug support
Message-ID: <20110124090708.GA16202@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-14-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295834493-5019-14-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 06:01:18PM -0800, Colin Cross wrote:
> Tegra supports three low power modes that involve powering down the CPU.

It is a common misconception that on CPU hot-unplug you need to save the
entire universe of the CPU going down.

When CPUs are hot-plugged, they reinitialize, which includes resetting
most of the CPU state.

There is no point saving the user register state, svc register state,
abort register state, interrupt register state, undefined mode register
state, TTB base registers, TTB control register, memory type remapping
registers nor the context register.  These are all reinitialized when
the CPU is brought up again.

VFP state should already be saved - when a CPU is hot-unplugged, we can't
leave a threads VFP register set stored in that hardware as it would
become inaccessible, so there's no point saving VFP state.  Recently
code was added to invalidate the software VFP state for a CPU being
hot-unplugged and reinitialize the VFP hardware on CPU hotplug.

We also have the necessary hooks into the PM code to deal with VFP state
saving/restore on PM suspend/resume.

The breakpoint/watchdog stuff _should_ be handled by the breakpoint/
watchdog code, not by each individual platform.  Please can you work
with Will Deacon if this is not the case to ensure that the breakpoint/
watchdog code can handle CPU hotplug.

Lastly, L2 cache controller should have suspend/resume support added.

We _really_ need to stop having platforms manually saving lots of CPU
state for suspend/hot unplug.

That should reduce the amount of state you're saving down to something
more manageable.

> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +
> +int platform_cpu_kill(unsigned int cpu)
> +{
> +	unsigned int reg;
> +
> +	do {
> +		reg = readl(CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
> +		cpu_relax();
> +	} while (!(reg & (1<<cpu)));
> +
> +	spin_lock(&boot_lock);
> +	reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> +	writel(reg | (1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
> +	spin_unlock(&boot_lock);
> +
> +	return 1;
> +}
> +
> +void platform_cpu_die(unsigned int cpu)
> +{
> +#ifdef DEBUG
> +	unsigned int this_cpu = hard_smp_processor_id();
> +
> +	if (cpu != this_cpu) {
> +		printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
> +			   this_cpu, cpu);
> +		BUG();
> +	}
> +#endif
> +
> +	gic_cpu_exit(0);
> +	barrier();
> +	flush_cache_all();
> +	barrier();
> +	__cortex_a9_save(0);
> +
> +	/*
> +	 * __cortex_a9_save can return through __cortex_a9_restore, but that
> +	 * should never happen for a hotplugged cpu
> +	 */
> +	BUG();
> +}
> +
> +int platform_cpu_disable(unsigned int cpu)
> +{
> +	/*
> +	 * we don't allow CPU 0 to be shutdown (it is still too special
> +	 * e.g. clock tick interrupts)
> +	 */
> +	if (unlikely(!tegra_context_area))
> +		return -ENXIO;
> +
> +	return cpu == 0 ? -EPERM : 0;
> +}
> +#endif

Please leave this in hotplug.c so that it matches what other platforms
do.  Otherwise it's likely to be missed by any updates that happen
architecture-wide.
