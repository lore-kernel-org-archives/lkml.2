Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0JCAei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 20:34:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:38389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0JCAeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 20:34:37 -0400
Subject: Re: [PATCH 1/7] si time accounting accounts bh_disable'd time to
 si -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <AANLkTikwUh57PKNk_fWzXApoYnCqK9NFi-MzSY-QKUc5@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	 <1285788096-29471-2-git-send-email-venki@google.com>
	 <1285844662.2144.9.camel@laptop>
	 <AANLkTinEN8i=Tx-CrdVzv-FGJH5jXaxwsPm-GDf-M_hi@mail.gmail.com>
	 <1285975006.2144.67.camel@laptop>
	 <AANLkTikwUh57PKNk_fWzXApoYnCqK9NFi-MzSY-QKUc5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 03 Oct 2010 02:34:16 +0200
Message-ID: <1286066056.2144.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 08:42 -0700, Venkatesh Pallipadi wrote:
> 
> > The make in_serving_softirq() be something like:
> >  (preempt_count() & SOFTIRQ_OFFSET) || (current->flags & PF_SOFTIRQ)
> >
> 
> Yes. I would also need in_softirq_at_hardirq_tail() for accounting calls :)

Well, you could open-code it there or something.

> >> Also, ksoftirqd adds to softirq counts, does trace softirq, etc. So,
> >> it kind of made sense to add the time also to softirq stats as well.
> >> If we dont account time to softirq stats, then if some user is looking
> >> at say time per softirq using the softirq count will be misled. No?
> >
> > Simply add back the task accounting when you report it?
> >
> >> In the other thread you mentioned doing that will cause problems. Were
> >> you thinking of scheduler issues or are there other problems charging
> >> softirq time this way?
> >
> > Of course there are.. you're double accounting the time of ksoftirqd,
> > and worse, you're adding that back into the equation as part of the !
> > sched_fair time.
> >
> 
> No. There should not be any double accounting with this current
> change. We account softirq processing both at hardirq tail and
> ksoftirqd as CPU softirq time. It will be taken out of ksoftirqd sched
> exec time as with any other thread. And it will be taken out of fair
> time available on the CPU as well. Which to me seems to be the right
> thing to do, as the this is more coupled with the CPU and ksoftirqd is
> just giving context for softirqd to run.

But ksoftirqd is a SCHED_OTHER task, so by taking it out of its runtime
the scheduler will get all confused.

> Changing only hardirq tail to have SOFTIRQ_OFFSET and changing
> ksoftirqd to SOFTIRQ_OFFSET*2 would result in these additional
> ksoftirqd softirqs staying as the part of sched_fair time.
> 
> Or I am totally missing something here? 

Please keep ksoftirq scheduling normal, if people want it to be another
scheduling class, let them change that, but since its a task it should
be a normal task and get scheduled like everybody else, not have some
magic properties.


