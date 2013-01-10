Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3AJOC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:02:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3AJOCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:02:55 -0500
Date: Thu, 10 Jan 2013 09:02:15 -0500
From: Don Zickus <dzickus@redhat.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-ID: <20130110140215.GP88797@redhat.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357783059-13923-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:57:39PM -0800, Colin Cross wrote:
> Emulate NMIs on systems where they are not available by using timer
> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> to check that the next cpu is processing hrtimer interrupts by
> verifying that a counter is increasing.
> 
> This patch is useful on systems where the hardlockup detector is not
> available due to a lack of NMIs, for example most ARM SoCs.

I have seen other cpus, like Sparc I think, create a 'virtual NMI' by
reserving an IRQ line as 'special' (can not be masked).  Not sure if that
is something worth looking at here (or even possible).

> Without this patch any cpu stuck with interrupts disabled can
> cause a hardware watchdog reset with no debugging information,
> but with this patch the kernel can detect the lockup and panic,
> which can result in useful debugging info.

<SNIP>
> +#ifdef CONFIG_HARDLOCKUP_DETECTOR_OTHER_CPU
> +static int is_hardlockup_other_cpu(int cpu)
> +{
> +	unsigned long hrint = per_cpu(hrtimer_interrupts, cpu);
> +
> +	if (per_cpu(hrtimer_interrupts_saved, cpu) == hrint)
> +		return 1;
> +
> +	per_cpu(hrtimer_interrupts_saved, cpu) = hrint;
> +	return 0;

Will this race with the other cpu you are checking?  For example if cpuA
just updated its hrtimer_interrupts_saved and cpuB goes to check cpuA's
hrtimer_interrupts_saved, it seems possible that cpuB could falsely assume
cpuA is stuck?


> +}
> +
> +static void watchdog_check_hardlockup_other_cpu(void)
> +{
> +	int cpu;
> +	cpumask_t cpus = watchdog_cpus;
> +
> +	/*
> +	 * Test for hardlockups every 3 samples.  The sample period is
> +	 *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
> +	 *  watchdog_thresh (over by 20%).
> +	 */
> +	if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> +		return;
> +
> +	/* check for a hardlockup on the next cpu */
> +	cpu = cpumask_next(smp_processor_id(), &cpus);
> +	if (cpu >= nr_cpu_ids)
> +		cpu = cpumask_first(&cpus);
> +	if (cpu == smp_processor_id())
> +		return;
> +
> +	smp_rmb();
> +
> +	if (per_cpu(watchdog_nmi_touch, cpu) == true) {
> +		per_cpu(watchdog_nmi_touch, cpu) = false;
> +		return;
> +	}

Same race here.  Usually touch_nmi_watchdog is reserved for those
functions that plan on disabling interrupts for a while.  cpuB could set
cpuA's watchdog_nmi_touch to false here expecting not to revisit this
variable for another couple of seconds.  While cpuA could read this
variable milliseconds later after cpuB sets it and falsely assume there is
a lockup?

Perhaps I am misreading the code?

If not, I don't have a good idea on how to solve those races off the top of my
head unfortunately.

Cheers,
Don
