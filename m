Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0KYKZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:25:22 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52552 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab0KYKZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:25:21 -0500
Subject: Re: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch
 pmu implementations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        davem <davem@davemloft.net>, Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, paulus <paulus@samba.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Don Zickus <dzickus@redhat.com>
In-Reply-To: <20101117222056.040309789@chello.nl>
References: <20101117221730.002627458@chello.nl>
	 <20101117222056.040309789@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 11:25:13 +0100
Message-ID: <1290680713.2145.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 23:17 +0100, Peter Zijlstra wrote:
> plain text document attachment (perf-fix-hw-init.patch)
> Currently architectures use various random locations to init the PMU
> driver, for some this happens before the perf core code is
> initialized.
> 
> In order to avoid calling perf_pmu_register() before the core code is
> up and running and able to deal with it, move all arch init to at
> least early_initcall (some archs use a later init, which is fine).
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---

<snip alpha,sparc bits>

> Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -1348,7 +1348,7 @@ static void __init pmu_check_apic(void)
>  	pr_info("no hardware sampling interrupt available.\n");
>  }
>  
> -void __init init_hw_perf_events(void)
> +int __init init_hw_perf_events(void)
>  {
>  	struct event_constraint *c;
>  	int err;
> @@ -1363,11 +1363,11 @@ void __init init_hw_perf_events(void)
>  		err = amd_pmu_init();
>  		break;
>  	default:
> -		return;
> +		return 0;
>  	}
>  	if (err != 0) {
>  		pr_cont("no PMU driver, software events only.\n");
> -		return;
> +		return 0;
>  	}
>  
>  	pmu_check_apic();
> @@ -1420,7 +1420,10 @@ void __init init_hw_perf_events(void)
>  
>  	perf_pmu_register(&pmu);
>  	perf_cpu_notifier(x86_pmu_notifier);
> +
> +	return 0;
>  }
> +early_initcall(init_hw_perf_events);
>  
>  static inline void x86_pmu_read(struct perf_event *event)
>  {

Right, so hw perf init happens from (after this patch):

 arch_initcall: powerpc, arm, sh, mips
 early_initcall: x86, sparc, alpha


Now the problem is that the generic watchdog code (kernel/watchdog.c)
tries to create hw perf events, and that too runs from early_initcall.

So my question is, how do we go about curing this, because powerpc, arm,
sh and mips are too late and the rest depends on link order to work, not
really a nice situation.

There's two categories of solutions:
 - move the watchdog later, and
 - move the hw perf init earlier.

The former is undesired because we want the watchdog as early as
possible, the later needs new infrastructure (also, I don't know if the
arch implementations can actually run this early).

So do I create a perf_initcall() or is there another solution that
avoids things like calling the watchdog code from all arch init code?
