Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0HKCpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:45:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0HKCpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:45:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QCNrs4o+6owwxsaswA5W0g0lIzycflqyGki4qB29pbk+sfd7rnQikKvUgPcmT9HGtV
         /12bej1XwhDq9b8Y6g5AuYjuGQled8fJqrWPq/sVinH4n6d8ROhSuXNa6FjJlbKhz58B
         d1+0YHEVDaQHhInqp3y1eaQWCcUemPgHdRyoU=
Date: Wed, 11 Aug 2010 04:44:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100811024451.GA26835@nowhere>
References: <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100810204856.GA16571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810204856.GA16571@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 04:48:56PM -0400, Don Zickus wrote:
> On Mon, Aug 09, 2010 at 09:48:29PM +0200, Robert Richter wrote:
> > On 06.08.10 10:21:31, Don Zickus wrote:
> > > On Fri, Aug 06, 2010 at 08:52:03AM +0200, Robert Richter wrote:
> > 
> > > > I was playing around with it yesterday trying to fix this. My idea is
> > > > to skip an unkown nmi if the privious nmi was a *handled* perfctr
> > > 
> > > You might want to add a little more logic that says *handled* _and_ had
> > > more than one perfctr trigger.  Most of the time only one perfctr is
> > > probably triggering, so you might be eating unknown_nmi's needlessly.
> > > 
> > > Just a thought.
> > 
> > Yes, that's true. It could be implemented on top of the patch below.
> 
> I did, but the changes basically revert the bulk of your patch.
> 
> > 
> > > 
> > > > nmi. I will probably post an rfc patch early next week.
> > 
> > Here it comes:
> > 
> > From d2739578199d881ae6a9537c1b96a0efd1cdea43 Mon Sep 17 00:00:00 2001
> > From: Robert Richter <robert.richter@amd.com>
> > Date: Thu, 5 Aug 2010 16:19:59 +0200
> > Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> 
> On top of Robert's patch:
> (compiled tested only because I don't have a fancy button to trigger
> unknown nmis)
> 
> From 548cf5148f47618854a0eff22b1d55db71b6f8fc Mon Sep 17 00:00:00 2001
> From: Don Zickus <dzickus@redhat.com>
> Date: Tue, 10 Aug 2010 16:40:03 -0400
> Subject: [PATCH] perf, x86: only skip NMIs when multiple perfctrs trigger
> 
> A small optimization on top of Robert's patch that limits the
> skipping of NMI's to cases where we detect multiple perfctr events
> have happened.



Yeah, I think that's more reasonable. This lowers even more the chances of
losing important hardware errors.

One comment though:


> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> ---
>  arch/x86/kernel/cpu/perf_event.c |   34 ++++++++++++++++++++--------------
>  1 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index c3cd159..066046d 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1154,7 +1154,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>  		/*
>  		 * event overflow
>  		 */
> -		handled		= 1;
> +		handled		+= 1;
>  		data.period	= event->hw.last_period;
>  
>  		if (!x86_perf_event_set_period(event))
> @@ -1200,7 +1200,7 @@ void perf_events_lapic_init(void)
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
>  }
>  
> -static DEFINE_PER_CPU(unsigned int, perfctr_handled);
> +static DEFINE_PER_CPU(unsigned int, perfctr_skip);
>  
>  static int __kprobes
>  perf_event_nmi_handler(struct notifier_block *self,
> @@ -1208,8 +1208,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  {
>  	struct die_args *args = __args;
>  	struct pt_regs *regs;
> -	unsigned int this_nmi;
> -	unsigned int prev_nmi;
> +	int handled = 0;
>  
>  	if (!atomic_read(&active_events))
>  		return NOTIFY_DONE;
> @@ -1229,14 +1228,11 @@ perf_event_nmi_handler(struct notifier_block *self,
>  		 * was handling a perfctr. Otherwise we pass it and
>  		 * let the kernel handle the unknown nmi.
>  		 *
> -		 * Note: this could be improved if we drop unknown
> -		 * NMIs only if we handled more than one perfctr in
> -		 * the previous NMI.
>  		 */
> -		this_nmi = percpu_read(irq_stat.__nmi_count);
> -		prev_nmi = __get_cpu_var(perfctr_handled);
> -		if (this_nmi == prev_nmi + 1)
> +		if (__get_cpu_var(perfctr_skip)){
> +			__get_cpu_var(perfctr_skip) -=1;
>  			return NOTIFY_STOP;
> +		}
>  		return NOTIFY_DONE;
>  	default:
>  		return NOTIFY_DONE;
> @@ -1246,11 +1242,21 @@ perf_event_nmi_handler(struct notifier_block *self,
>  
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
>  
> -	if (!x86_pmu.handle_irq(regs))
> +	handled = x86_pmu.handle_irq(regs);
> +	if (!handled)
> +		/* not our NMI */
>  		return NOTIFY_DONE;
> -
> -	/* handled */
> -	__get_cpu_var(perfctr_handled) = percpu_read(irq_stat.__nmi_count);
> +	else if (handled > 1)
> +		/*
> +		 * More than one perfctr triggered.  This could have
> +		 * caused a second NMI that we must now skip because
> +		 * we have already handled it.  Remember it.
> +		 *
> +		 * NOTE: We have no way of knowing if a second NMI was
> +		 * actually triggered, so we may accidentally skip a valid
> +		 * unknown nmi later.
> +		 */
> +		__get_cpu_var(perfctr_skip) +=1;



May be make it just a pending bit. I mean not something that can
go further 1, because you can't have more than 1 pending anyway. I don't
know how that could happen you get accidental perctr_skip > 1, may be
expected pending NMIs that don't happen somehow, but better be paranoid with
that, as it's about trying not to miss hardware errors.

Thanks.

