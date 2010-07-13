Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0GMIu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:50:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0GMIu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:50:28 -0400
Date: Tue, 13 Jul 2010 10:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf failed with kernel 2.6.35-rc
Message-ID: <20100713085019.GB7984@elte.hu>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> Peter,
> 
> perf doesn't work on my Nehalem EX machine.
> 1) The 1st start of 'perf top' is ok;
> 2) Kill the 1st perf and restart it. It doesn't work. No data is showed.
> 
> I located below commit:
> commit 1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Mar 26 14:08:44 2010 +0100
> 
>     perf, x86: Add Nehelem PMU programming errata workaround
>     
>     workaround From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Date: Fri Mar 26 13:59:41 CET 2010
>     
>     Implement the workaround for Intel Errata AAK100 and AAP53.
>     
>     Also, remove the Core-i7 name for Nehalem events since there are
>     also Westmere based i7 chips.
> 
> 
> If I comment out the workaround in function intel_pmu_nhm_enable_all,
> perf could work.
> 
> A quick glance shows:
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> should be:
> wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);

> I triggered sysrq to dump PMU registers and found the last bit of
> global status register is 1. I added a status reset operation like below patch:
> 
> --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 09:38:11.000000000 +0800
> +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 14:41:42.000000000 +0800
> @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
>  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
>  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
>  
> -		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
>  		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> +		/*
> +		 * Reset the last 3 bits of global status register in case
> +		 * previous enabling causes overflows.
> +		 */
> +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
>  
>  		for (i = 0; i < 3; i++) {
>  			struct perf_event *event = cpuc->events[i];
>
> 
> However, it still doesn't work. Current right way is to comment out
> the workaround.

Well, how about doing it like this:

		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
		/*
		 * Reset the last 3 bits of global status register in case
		 * previous enabling causes overflows.
		 */
		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
  
 		for (i = 0; i < 3; i++) {
  			struct perf_event *event = cpuc->events[i];
			...
		}

  		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);

I.e. global-mask, overflow-clear, explicit-enable, then global-enable?

Thanks,

	Ingo
