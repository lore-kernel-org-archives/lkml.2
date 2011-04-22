Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1DVN0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:26:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:21848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1DVN0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,253,1301900400"; 
   d="scan'208";a="737021676"
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore
 support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
In-Reply-To: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 21:26:38 +0800
Message-Id: <1303478798.2461.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 20:59 +0800, Stephane Eranian wrote:
> Lin,
> 
> In arch/x86/include/asm/smp.h, you added:
> 
> static inline bool cpu_has_ht_siblings(void)
> {
>        bool has_siblings = false;
> #ifdef CONFIG_SMP
>        has_siblings = cpu_has_ht && smp_num_siblings > 1;
> #endif
>        return has_siblings;
> }
> 
> I am wondering about the goal of this function.
> 
> Is it supposed to return whether or not HT is enabled?
> 
> Ht enabled != HT supported

It's used to check if HT is supported.

We had some long discussions months ago about how to check if HT is
enabled. http://marc.info/?t=129346430400004&r=1&w=2

But unfortunately, we didn't find a way to check if HT is enabled.
So I just check if HT is supported.

> 
> On my systems (NHM or SNB), its value does not change
> when I enable/disable HT.
> 
> Looking at Intel's AP-485 (CPUID documentation), they
> clearly say that none of the Leaf functions which report
> about HT or the number of logical cores, can be used to
> detect HT enabled or disabled. Seems those leaf functions
> are the basis for smp_num_siblings. The trick in Table-5.5
> for bit 28 with CPUID(1).EBX[23:16] used in detect_ht()
> is about HT supported and not HT enabled.
> 
> HT supported means multi-core or multi-thread supported.
> 
> Going back to the perf_event code, I wonder what is the
> point of using this function in intel_pmu_cpu_prepare(), then.
> 
> I suspect you wanted to know whether or not HT was enabled.
> But that's not going to work. If you want that functionality, then
> I tried:
> 
> +static inline int is_ht_enabled(void)
> +{
> +       bool has_ht = false;
> +#ifdef CONFIG_SMP
> +       int w;
> +       w = cpumask_weight(cpu_sibling_mask(smp_processor_id()));
> +       has_ht = cpu_has_ht && w > 1;
> +#endif
> +       return has_ht;
> +}
> 
> But that cannot be used in the CPU hotplug callback for prepare(),
> it is too early.
> 
> OTOH, you need some validation even in the case HT is off. No two events
> scheduled together on the same PMU can have different values for the extra
> reg. Thus, the fact that cpu_has_ht_siblings() is imune to HT state helps here,
> but then what's the point of it?

The points is to avoid the percore resource allocations(which are used
to sync between HTs) if HT is not supported.

> 
> I am preparing a patch that builds on your patch and improves
> support for those events or features which require an extra
> (shared) register. They are differences between NHM/WSM
> and SNB.


