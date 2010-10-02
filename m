Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0JBK6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:58:31 -0400
Received: from www.tglx.de ([62.245.132.106]:47276 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0JBK6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:58:30 -0400
Date: Sat, 2 Oct 2010 12:57:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: miltonm@bga.com, Ian Campbell <ian.campbell@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
In-Reply-To: <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
Message-ID: <alpine.LFD.2.00.1010021248150.14550@localhost6.localdomain6>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com> <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010, Nishanth Aravamudan wrote:

> The use of online_mask requires architecture code to be hotplug-aware to
> account for IRQ round-robin'ing. With user-driven dynamic SMT, this
> could commonly occur even without physical hotplug. Without this change
> and "pseries/xics: use cpu_possible_mask rather than cpu_all_mask", IRQs
> are all routed to CPU0 on power machines with XICS not running
> irqbalance.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> ---
> I have boot-tested this on ppc64, but not yet on x86/x86_64. This is
> generic-code, and perhaps an audit of all .set_affinity functions should
> occur before upstream acceptance?
> ---
>  kernel/irq/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index c3003e9..ef85b95 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -175,7 +175,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
>  			desc->status &= ~IRQ_AFFINITY_SET;
>  	}
>  
> -	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
> +	cpumask_and(desc->affinity, cpu_possible_mask, irq_default_affinity);

Hmm, that looks dangerous. And auditing everything is rather horrible
especially when we need to add cpumask_and(..., cpu_online_mask, ..)
all over the place.

We should rather have something like:

cpumask_var_t *cpumask_restrict_to = &cpu_online_mask;

+	cpumask_and(desc->affinity, *cpumask_restrict_to, irq_default_affinity);

So an arch can override it in arch_early_irq_init().

Thanks,

	tglx

