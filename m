Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1AXJ0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:26:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14453 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1AXJ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L2ZPauDHQt68dn4Oh841+N9ychvZCzHUIXIWdyh9tdDPGOhTvjX7pqVSXwZFIMtxf7
         kz5c2RDGN1SI6rRoU3EA==
MIME-Version: 1.0
In-Reply-To: <20110124090708.GA16202@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-14-git-send-email-ccross@android.com>
	<20110124090708.GA16202@n2100.arm.linux.org.uk>
Date: Mon, 24 Jan 2011 01:26:39 -0800
X-Google-Sender-Auth: XHieDVyKwLqUxnz5ZQBJL-3vBbE
Message-ID: <AANLkTimEdkMsv+NERv6E6AyBcAKv9szJBsJYHmFBDnbS@mail.gmail.com>
Subject: Re: [PATCH v2 13/28] ARM: tegra: Add suspend and hotplug support
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        Gary King <gking@nvidia.com>, linux-kernel@vger.kernel.org,
        olof@lixom.net, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 1:07 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 23, 2011 at 06:01:18PM -0800, Colin Cross wrote:
>> Tegra supports three low power modes that involve powering down the CPU.
>
> It is a common misconception that on CPU hot-unplug you need to save the
> entire universe of the CPU going down.
>
> When CPUs are hot-plugged, they reinitialize, which includes resetting
> most of the CPU state.

The hotplug code path on Tegra currently shares the same path as cpu
idle, because the CPU ends up in the same state for both.  This
version of the patch ensures that when the cpu is brought back online,
it goes through the normal reset vector.  In hotplug, the state ends
up getting saved on the way down, but not used on the way back up.

> There is no point saving the user register state, svc register state,
> abort register state, interrupt register state, undefined mode register
> state, TTB base registers, TTB control register, memory type remapping
> registers nor the context register.  These are all reinitialized when
> the CPU is brought up again.

The register state is fixed in this version of the patch by calling
cpu_init() in the resume and idle code.  I'll look again if there is a
better way of handling the rest of the registers, but this code is
mostly needed for the suspend and idle cases where the normal boot
process is not used.

> VFP state should already be saved - when a CPU is hot-unplugged, we can't
> leave a threads VFP register set stored in that hardware as it would
> become inaccessible, so there's no point saving VFP state.  Recently
> code was added to invalidate the software VFP state for a CPU being
> hot-unplugged and reinitialize the VFP hardware on CPU hotplug.

Despite what the patch description says, this version of the patch
does not save VFP state any more.  I will update the description.  It
looks like if CONFIG_SMP=y, the VFP code saves the VFP context on
every task switch, so nothing is needed during cpu idle.  However, if
CONFIG_SMP=n, I think some way to save the VFP context is needed.

> We also have the necessary hooks into the PM code to deal with VFP state
> saving/restore on PM suspend/resume.
>
> The breakpoint/watchdog stuff _should_ be handled by the breakpoint/
> watchdog code, not by each individual platform.  Please can you work
> with Will Deacon if this is not the case to ensure that the breakpoint/
> watchdog code can handle CPU hotplug.

This version of the patch does not save breakpoint/watchdogs, but
something will need to save them during idle when the cpu is powered
down.

> Lastly, L2 cache controller should have suspend/resume support added.

Patch 4 in this series improves the L2 controller's PM support, and
this patch uses l2x0_disable, l2x0_enable, and l2x0_init.

> We _really_ need to stop having platforms manually saving lots of CPU
> state for suspend/hot unplug.
>
> That should reduce the amount of state you're saving down to something
> more manageable.
>
>> +
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +
>> +int platform_cpu_kill(unsigned int cpu)
>> +{
>> +     unsigned int reg;
>> +
>> +     do {
>> +             reg = readl(CLK_RST_CONTROLLER_RST_CPU_CMPLX_SET);
>> +             cpu_relax();
>> +     } while (!(reg & (1<<cpu)));
>> +
>> +     spin_lock(&boot_lock);
>> +     reg = readl(CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
>> +     writel(reg | (1<<(8+cpu)), CLK_RST_CONTROLLER_CLK_CPU_CMPLX);
>> +     spin_unlock(&boot_lock);
>> +
>> +     return 1;
>> +}
>> +
>> +void platform_cpu_die(unsigned int cpu)
>> +{
>> +#ifdef DEBUG
>> +     unsigned int this_cpu = hard_smp_processor_id();
>> +
>> +     if (cpu != this_cpu) {
>> +             printk(KERN_CRIT "Eek! platform_cpu_die running on %u, should be %u\n",
>> +                        this_cpu, cpu);
>> +             BUG();
>> +     }
>> +#endif
>> +
>> +     gic_cpu_exit(0);
>> +     barrier();
>> +     flush_cache_all();
>> +     barrier();
>> +     __cortex_a9_save(0);
>> +
>> +     /*
>> +      * __cortex_a9_save can return through __cortex_a9_restore, but that
>> +      * should never happen for a hotplugged cpu
>> +      */
>> +     BUG();
>> +}
>> +
>> +int platform_cpu_disable(unsigned int cpu)
>> +{
>> +     /*
>> +      * we don't allow CPU 0 to be shutdown (it is still too special
>> +      * e.g. clock tick interrupts)
>> +      */
>> +     if (unlikely(!tegra_context_area))
>> +             return -ENXIO;
>> +
>> +     return cpu == 0 ? -EPERM : 0;
>> +}
>> +#endif
>
> Please leave this in hotplug.c so that it matches what other platforms
> do.  Otherwise it's likely to be missed by any updates that happen
> architecture-wide.

Will do
