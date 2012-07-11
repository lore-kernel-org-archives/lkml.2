Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2GKNFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:05:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2GKNFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:05:36 -0400
Message-ID: <1342011904.3462.152.camel@twins>
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Date: Wed, 11 Jul 2012 15:05:04 +0200
In-Reply-To: <alpine.LFD.2.02.1207111425260.32033@ionos>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
	 <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
	 <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 14:45 +0200, Thomas Gleixner wrote:
> On Wed, 11 Jul 2012, Prarit Bhargava wrote:
> > On 07/10/2012 06:43 PM, John Stultz wrote:
> > > clock_was_set() cannot be called from hard interrupt context because
> > > it calls on_each_cpu(). For fixing the widely reported leap seconds
> > > issue it's necessary to call it from the timer interrupt context.
> > > 
> > > Provide a new function which denotes it in the hrtimer cpu base
> > > structure of the cpu on which it is called and raising the timer
> > > softirq.
> > > 
> > > We then execute the clock_was_set() notificiation in the timer softirq
> > > context in hrtimer_run_pending().
> > 
> > I wish there was a nicer way to do this ... but looking at the code I can't
> > figure out a better way.  (no offense John, it's just the way the code is ;) )
> 
> Yeah, I had the same discussion with Peter earlier today. There is
> only a rather limited set of options.
> 
> 1) Retrigger the timer interrupt vectors on all CPUs - except the one
>    we are running on, but we have no interface for that at the moment
> 
> 2) Do the nasty __smp_call_function_single() hack
> 
>    Preallocate call_single_data for all cpus and do a
>    __smp_call_function_single() on all online cpus.
> 
>    This can be called from hard interrupt context or irq disabled
>    regions.
> 
>    That would allow to get rid of the whole delay magic all
>    together.
> 
> Thoughts?

The __smp_call_function_single() thing isn't particularly pretty either
and a lot more code to boot.. 

static DEFINE_PER_CPU(struct call_single_data, cws_csd);

void clock_was_set(void)
{
	int cpu;

	for_each_online_cpu(cpu) {
		struct call_single_data *csd = &per_cpu(cws_csd, cpu);

		if (csd->flags & CSD_FLAG_LOCK)
			continue; /* a pending request is good enough */

		csd->func = retrigger_next_event;

		__smp_call_function_single(cpu, csd, 0);
	}

	timerfd_clock_was_set();
}

It also is a for_each_cpu loop with preemption disabled, not pretty :/
