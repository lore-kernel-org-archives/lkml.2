Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab2FUWnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:43:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab2FUWng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:43:36 -0400
Date: Thu, 21 Jun 2012 15:43:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de
Cc: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
Message-Id: <20120621154334.05a74517.akpm@linux-foundation.org>
In-Reply-To: <tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 03:54:20 -0700
"tip-bot for Yan, Zheng" <zheng.z.yan@intel.com> wrote:

> This patch adds the generic Intel uncore PMU support, including helper
> functions that add/delete uncore events, a hrtimer that periodically
> polls the counters to avoid overflow and code that places all events
> for a particular socket onto a single cpu.
> 
> The code design is based on the structure of Sandy Bridge-EP's uncore
> subsystem, which consists of a variety of components, each component
> contains one or more "boxes".
> 
> (Tooling support follows in the next patches.)
>
> ...
>
> +static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
> +{
> +	struct intel_uncore_box *box;
> +	unsigned long flags;
> +	int bit;
> +
> +	box = container_of(hrtimer, struct intel_uncore_box, hrtimer);
> +	if (!box->n_active || box->cpu != smp_processor_id())
> +		return HRTIMER_NORESTART;
> +	/*
> +	 * disable local interrupt to prevent uncore_pmu_event_start/stop
> +	 * to interrupt the update process
> +	 */
> +	local_irq_save(flags);
> +
> +	for_each_set_bit(bit, box->active_mask, UNCORE_PMC_IDX_MAX)
> +		uncore_perf_event_update(box, box->events[bit]);
> +
> +	local_irq_restore(flags);
> +
> +	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
> +	return HRTIMER_RESTART;
> +}

i386 allmodconfig:

arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:728: warning: integer overflow in expression
arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'uncore_pmu_start_hrtimer':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:735: warning: integer overflow in expression


Should we even be compiling this code in an i386 build?


Regardless of that, we have some head-scratching to do:


#define UNCORE_PMU_HRTIMER_INTERVAL       (60 * NSEC_PER_SEC)

and

#define NSEC_PER_SEC    1000000000L

and 60 billion doesn't fit in 32 bits.  So do we fix the
perf_event_intel_uncore.c callsites?  Or do we fix the
UNCORE_PMU_HRTIMER_INTERVAL definition?  Or do we fix the NSEC_PER_SEC
definition?

I'm thinking perhaps the latter.  What *is* the type of a nanosecond in
Linux?  include/linux/ktime.h is pretty insistent that it is u64.  If
so, NSEC_PER_SEC should logically have type ULL.  But changing both its
size and signedness is a pretty big change.
