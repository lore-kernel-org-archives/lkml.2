Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2JDJLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab2JDJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:11:23 -0400
Date: Thu, 4 Oct 2012 11:10:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, x86@vger.kernel.org,
        eranian@google.com, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: Re: [06/31] perf, kvm: Support the intx/intx_cp modifiers in KVM
 arch perfmon emulation
Message-ID: <20121004091059.GY23096@redhat.com>
References: <1349221731-15665-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349221731-15665-7-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:48:26PM -0000, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This is not arch perfmon, but older CPUs will just ignore it. This makes
> it possible to do at least some TSX measurements from a KVM guest
> 
> Cc: avi@redhat.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
> arch/x86/kvm/pmu.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 9b7ec11..f72a409 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -160,7 +160,7 @@ static void stop_counter(struct kvm_pmc *pmc)
>  
>  static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		unsigned config, bool exclude_user, bool exclude_kernel,
> -		bool intr)
> +		bool intr, bool intx, bool intx_cp)
>  {
>  	struct perf_event *event;
>  	struct perf_event_attr attr = {
> @@ -173,6 +173,11 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		.exclude_kernel = exclude_kernel,
>  		.config = config,
>  	};
> +	/* Will be ignored on CPUs that don't support this. */
> +	if (intx)
> +		attr.config |= HSW_INTX;
> +	if (intx_cp)
> +		attr.config |= HSW_INTX_CHECKPOINTED;
>  
>  	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
>  
> @@ -239,7 +244,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  	reprogram_counter(pmc, type, config,
>  			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
>  			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> -			eventsel & ARCH_PERFMON_EVENTSEL_INT);
> +			eventsel & ARCH_PERFMON_EVENTSEL_INT,
> +			!!(eventsel & HSW_INTX),
> +			!!(eventsel & HSW_INTX_CHECKPOINTED));
Before reprogram_gp_counter() is called from kvm_pmu_set_msr() eventsel
is checked for reserved bits. Both HSW_INTX and HSW_INTX_CHECKPOINTED
are marked as reserved currently. Reserved bit mask should depend on
cpuid bits provided to a guest.

>  }
>  
>  static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
> @@ -256,7 +263,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
>  			arch_events[fixed_pmc_events[idx]].event_type,
>  			!(en & 0x2), /* exclude user */
>  			!(en & 0x1), /* exclude kernel */
> -			pmi);
> +			pmi, false, false);
>  }
>  
>  static inline u8 fixed_en_pmi(u64 ctrl, int idx)

--
			Gleb.
