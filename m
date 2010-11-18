Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0KRLMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:12:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:37488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab0KRLMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:12:52 -0500
Subject: Re: [PATCH 3/4] perf-events: Add support for supplementary event
 registers v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1290077254-12165-4-git-send-email-andi@firstfloor.org>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
	 <1290077254-12165-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 12:12:59 +0100
Message-ID: <1290078779.2109.1341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 11:47 +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Intel Nehalem/Westmere have a special OFFCORE_RESPONSE event
> that can be used to monitor any offcore accesses from a core.
> This is a very useful event for various tunings, and it's
> also needed to implement the generic LLC-* events correctly.
> 
> Unfortunately this event requires programming a mask in a separate
> register. And worse this separate register is per core, not per
> CPU thread.
> 
> This patch adds:
> - Teaches perf_events that OFFCORE_RESPONSE needs extra parameters.
> The extra parameters are passed by user space in the unused upper
> 32bits of the config word.
> - Add support to the Intel perf_event core to schedule per
> core resources. This adds fairly generic infrastructure that
> can be also used for other per core resources.
> The basic code has is patterned after the similar AMD northbridge
> constraints code.
> 
> Thanks to Stephane Eranian who pointed out some problems
> in the original version and suggested improvements.
> 
> Full git tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git perf-offcore2
> Cc: eranian@google.com
> v2: Lots of updates based on review feedback. Also fixes some issues
> v3: Fix hotplug. Handle multiple extra registers. Fix init order.
> Various improvements.

Stuff like that shouldn't be mixed in with the tags and usually goes
below the --- separator since its not supposed to end up in the
committed changelog.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |   70 ++++++++++++
>  arch/x86/kernel/cpu/perf_event_intel.c |  192 ++++++++++++++++++++++++++++++++
>  include/linux/perf_event.h             |    2 +
>  3 files changed, 264 insertions(+), 0 deletions(-)

> @@ -876,6 +944,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
>  					  u64 enable_mask)
>  {
>  	wrmsrl(hwc->config_base + hwc->idx, hwc->config | enable_mask);
> +	if (hwc->extra_reg)
> +		wrmsrl(hwc->extra_reg, hwc->extra_config);
>  }

Just wondering, shouldn't we program the extra msr _before_ we flip the
enable bit?

> +static __init int init_intel_percore(void)
> +{
> +	int cpu;
> +
> +	if (!needs_percore)
> +		return 0;
> +
> +	intel_percore = alloc_percpu(struct intel_percore);
> +	if (!intel_percore)
> +		return -ENOMEM;
> +	for_each_possible_cpu(cpu)
> +		raw_spin_lock_init(&per_cpu_ptr(intel_percore, cpu)->lock);
> +
> +	return 0;
> +}
> +/* 
> + * Runs later because per cpu allocations don't work early on.
> + */
> +__initcall(init_intel_percore);

I've got a patch moving the whole pmu init to early_initcall(), which is
after mm_init() so it would actually work.
