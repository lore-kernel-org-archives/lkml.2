Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab2ILO0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:26:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:53362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab2ILO0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:26:44 -0400
Message-ID: <1347459984.15764.34.camel@twins>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 12 Sep 2012 16:26:24 +0200
In-Reply-To: <1347459195-5491-2-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm rather sure Thomas would want to know about this..


On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:
> hrtimer_init() assumes it is called for the current CPU
> as it accesses per-cpu variables (hrtimer_bases).
> 
> However, there can be cases where a hrtimer is initialized
> from a different CPU, so add an entry point to make this
> more explicit.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/linux/hrtimer.h |    3 +++
>  kernel/hrtimer.c        |   17 ++++++++++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 

> +static void __hrtimer_init(int cpu, struct hrtimer *timer, clockid_t clock_id,
>  			   enum hrtimer_mode mode)
>  {
>  	struct hrtimer_cpu_base *cpu_base;
> @@ -1154,7 +1154,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
>  
>  	memset(timer, 0, sizeof(struct hrtimer));
>  
> -	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
> +	cpu_base = &per_cpu(hrtimer_bases, cpu);
>  
>  	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
>  		clock_id = CLOCK_MONOTONIC;


I don't see the point, one of the first things
__hrtimer_start_range_ns() does is switch_hrtimer_base() to swizzle it
to the calling CPUs base.

And since all the perf event rotation muck is strictly per cpu that all
should work out just fine, no?
