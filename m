Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1FGNMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:12:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51563 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1FGNMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:12:36 -0400
Date: Tue, 7 Jun 2011 15:12:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/urgent] sched: Fix cross-cpu clock sync on remote
 wakeups
Message-ID: <20110607131216.GC27813@aftab>
References: <tip-f01114cb59d670e9b4f2c335930dd57db96e9360@git.kernel.org>
 <20110531125621.GA24439@gere.osrc.amd.com>
 <1306847516.2353.80.camel@twins>
 <20110601070547.GB3368@liondog.tnic>
 <1306924612.2353.176.camel@twins>
 <20110601155017.GD24028@aftab>
 <BANLkTikT6OT-HDi-DR+_ZWEhfp_CYWJ3Hg@mail.gmail.com>
 <1307019866.2497.675.camel@laptop>
 <20110602142340.GA3356@zhy>
 <1307029711.2497.717.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307029711.2497.717.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 11:48:31AM -0400, Peter Zijlstra wrote:
> Crap.. you're right. And I bet other archs don't do that either. With
> NO_HZ you really need irq_enter() for pretty much all interrupts so I
> was assuming the resched IPI had it, but its been special and never
> really needed it. If it would wake an idle cpu the idle loop exit would
> deal with it, if it interrupted userspace the thing was running and
> NO_HZ wasn't relevant.
> 
> Damn. 
> 
> And yes, the only reason I didn't see this on my dev box was because we
> do indeed set that sched_clock_stable thing on wsm. And I never noticed
> on my desktop because firefox/X/etc. consuming heaps of CPU isn't weird
> at all.
> 
> Adding it to all resched int handlers is of course a possibility but
> would slow down the thing, although with the new code, most users are
> now indeed wakeups (excepting weird and wonderful users like KVM).

FWIW, we could set the sched_clock_stable on AMD too - at least on F10h
and later. This will take care of the problem at hand and defer the
issue of slowing down the resched ipi handlers.

I dunno, however, whether we still would need the proper ->tick_gtod
update for correct ttwu accounting regardless of sched_clock_stable on
K8 (unstable TSCs) and maybe even other arches.

> 
> We could of course add it in sched.c since the logic recurses just
> fine.. its not pretty though.. :/
> 
> Thoughts?
> 
> ---
>  kernel/sched.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2fe98ed..365ed6b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2554,7 +2554,23 @@ static void sched_ttwu_pending(void)
>  
>  void scheduler_ipi(void)
>  {
> -	sched_ttwu_pending();
> +	struct rq *rq = this_rq();
> +	struct task_struct *list = xchg(&rq->wake_list, NULL);
> +
> +	if (!list)
> +		return;
> +
> +	irq_enter();
> +	raw_spin_lock(&rq->lock);
> +
> +	while (list) {
> +		struct task_struct *p = list;
> +		list = list->wake_entry;
> +		ttwu_do_activate(rq, p, 0);
> +	}
> +
> +	raw_spin_unlock(&rq->lock);
> +	irq_exit();
>  }
>  
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
