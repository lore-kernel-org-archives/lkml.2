Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1JQVAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:00:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:56647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1JQVAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:00:42 -0400
Date: Mon, 17 Oct 2011 23:00:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <1318879396.4172.92.camel@twins>
Message-ID: <alpine.LFD.2.02.1110172237030.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>  <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>  <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>  <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>  <20111013232521.GA5654@hostway.ca>  <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>  <1318847658.6594.40.camel@twins>  <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com> 
 <1318874090.4172.84.camel@twins>  <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Peter Zijlstra wrote:

> On Mon, 2011-10-17 at 11:31 -0700, Linus Torvalds wrote:
> > On Mon, Oct 17, 2011 at 10:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > I could of course propose this... but I really won't since I'm half
> > > retching by now.. ;-)
> > 
> > Wow. Is this "ugly and fragile code week" and I just didn't get the memo?
> 
> Do I get a price?
> 
> > I do wonder if we might not fix the problem by just taking the
> > *existing* lock in the right order?
> > 
> > IOW, how nasty would be it be to make "scheduler_tick()" just get the
> > cputimer->lock outside or rq->lock?
> > 
> > Sure, we'd hold that lock *much* longer than we need, but how much do
> > we care? Is that a lock that gets contention? It migth be the simple
> > solution for now - I *would* like to get 3.1 out..
> 
> Ah, sadly the tick isn't the only one with the inverted callchain,
> pretty much every callchain in the scheduler ends up in update_curr()
> one way or another.
> 
> The easier way around might be something like this... even when two
> threads in a process race to enable this clock the the wasted time is
> pretty much of the same order as we would otherwise have wasted spinning
> on the lock and the update_gt_cputime() think would end up moving the
> clock fwd to the latest outcome any which way.
> 
> Humm,. Thomas anything?
 
No, that should work. It does not make that call path more racy
against exit, which is another trainwreck at least on 32bit machines
which I discovered while looking for the problems with your patch.

thread_group_cputime() reads task->signal->utime/stime/sum_sched_runtime

These fields are updated in __exit_signal() w/o holding
task->signal->cputimer.lock. So nothing prevents that these values
change while we read them.

All callers of thread_group_cputime() except the scheduler callpath
hold sighand lock, which is also taken in __exit_signal().

So your patch does not make that particular case worse.

That said, I really need some sleep before I can make a final
judgement on that horror. The call paths are such an intermingled mess
that it's not funny anymore. I do that tomorrow morning first thing.

Thanks,

	tglx
