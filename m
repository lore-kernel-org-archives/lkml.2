Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab1EBNWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:22:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab1EBNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:22:45 -0400
Date: Mon, 2 May 2011 15:22:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using
 cluster groups v4
Message-ID: <20110502132232.GA3873@elte.hu>
References: <20110502113445.751391656@openvz.org>
 <20110502114024.222582172@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502114024.222582172@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> In the case of x2apic cluster mode we can group
> IPI register writes based on the cluster group
> instead of individual per-cpu destiantion messages.

typo.

> This reduces the apic register writes and reduces
> the amount of IPI messages (in the best case we can
> reduce it by a factor of 16).
> 
> With this change, microbenchmark measuring the cost
> of flush_tlb_others(), with the flush tlb IPI being
> sent from a cpu in the socket-1 to all the logical
> cpus in socket-2 (on a Westmere-EX system that has
> 20 logical cpus in a socket) is 3x times better now
> (compared to the former 'send one-by-one' algorithm).

What kind of microbenchmark was this, could the actual results and measurement 
methods be shared as well?

> v2: Suresh fixed cpumask allocation to be dynamic,
>     stack allocation is not acceptable for such things
>     because can be exhausted.
> 
> v3: Address Ingo concerns on code style, also a note
>     added just to not forget that we need merge
>     probe_64/32 into some common structure.
> 
> v4: Suresh discovered (and fixed) that cluster
>     infomation must be updated at CPU_UP_PREPARE
>     state otherwise if IPI happens too early we
>     will be in touble having incomplete cluster
>     sibling map.
> 
> Tested-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/include/asm/apic.h           |    2 
>  arch/x86/kernel/apic/probe_64.c       |   13 ++
>  arch/x86/kernel/apic/x2apic_cluster.c |  167 ++++++++++++++++++++++++----------
>  3 files changed, 136 insertions(+), 46 deletions(-)
> 
> Index: tip-linux-2.6/arch/x86/include/asm/apic.h
> ===================================================================
> --- tip-linux-2.6.orig/arch/x86/include/asm/apic.h
> +++ tip-linux-2.6/arch/x86/include/asm/apic.h
> @@ -178,6 +178,8 @@ extern int x2apic_phys;
>  extern void check_x2apic(void);
>  extern void enable_x2apic(void);
>  extern void x2apic_icr_write(u32 low, u32 id);
> +extern void x2apic_init_cpu_notifier(void);
> +
>  static inline int x2apic_enabled(void)
>  {
>  	u64 msr;
> Index: tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
> ===================================================================
> --- tip-linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
> +++ tip-linux-2.6/arch/x86/kernel/apic/probe_64.c
> @@ -55,6 +55,15 @@ static int apicid_phys_pkg_id(int initia
>  void __init default_setup_apic_routing(void)
>  {
>  
> +	/*
> +	 * FIXME:
> +	 *
> +	 * Cleanup the apic routing selection by having an apic driver specific
> +	 * selection routine. Then all we need to do here is iterate through
> +	 * them to finalize the apic selection. That would get rid of the
> +	 * ifdef mess and most of the code here.
> +	 */
> +
>  	enable_IR_x2apic();
>  
>  #ifdef CONFIG_X86_X2APIC
> @@ -71,7 +80,9 @@ void __init default_setup_apic_routing(v
>  #endif
>  
>  	if (apic == &apic_flat && num_possible_cpus() > 8)
> -			apic = &apic_physflat;
> +		apic = &apic_physflat;
> +	else if (apic == &apic_x2apic_cluster)
> +		x2apic_init_cpu_notifier();


Why is there an x2apic specific function in the generic 
default_setup_apic_routing() function?

Instead of that it would be cleaner to extend the apic driver functions with an 
init method, which would be filled in for x2apic and left NULL for the others.

Thanks,

	Ingo
