Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1FGPIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:08:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab1FGPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:08:20 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=XYJHFtupD_QA:10 a=Nfqsw8rmjecA:10 a=5SG0PmZfjMsA:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JfrnYn6hAAAA:8 a=wC7odt5anOTvtjqptcAA:9 a=tdBslllu8H2KfsVTRFgA:7 a=wPNLvfGTeEIA:10 a=3Rfx1nUSh_UA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 7 Jun 2011 11:08:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: correct testing need_resched in
 mutex_spin_on_owner()
Message-ID: <20110607150816.GC27245@home.goodmis.org>
References: <BANLkTimZ8=YYZXZSzauy5ASsP0kwti8uxQ@mail.gmail.com>
 <1307454439.2322.260.camel@twins>
 <BANLkTikvFk7pbcw9PEtPGSK=6WCNLYXCuQ@mail.gmail.com>
 <1307456680.2322.270.camel@twins>
 <BANLkTim1htraTXtGMcyAuH1Wa-G+J05i_g@mail.gmail.com>
 <1307457646.2322.273.camel@twins>
 <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=XTpYTZvetOUDgobRa_S4Cb=+syA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 10:47:21PM +0800, Hillf Danton wrote:
> On Tue, Jun 7, 2011 at 10:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2011-06-07 at 22:36 +0800, Hillf Danton wrote:
> >
> >> If you are right, the following comment also in __mutex_lock_common()
> >>
> >>       for (;;) {
> >>               struct task_struct *owner;
> >>
> >>               /*
> >>                * If there's an owner, wait for it to either
> >>                * release the lock or go to sleep.
> >>                */
> >>               owner = ACCESS_ONCE(lock->owner);
> >>               if (owner && !mutex_spin_on_owner(lock, owner))
> >>                       break;
> >>
> >> looks misleading too, but if owner is on this CPU, for what does we wait?
> >
> > huh, wtf!? it cannot be on this cpu, if it was we wouldn't be running
> > the above code but whatever owner was doing.
> >
> > So my argument was, it cannot be on this cpu, therefore, by checking it
> > is on a cpu, we check its on a different cpu.
> >
> > And I really don't see how any of that is related to the above.
> >
> Oh, it looks you are willing to rethink about testing need_resched?

NO!

Hillf, reading this thread I understand that you have no idea of what is
happening here. You are totally clueless. Let me give you a clue.

The idea of an adaptive mutex is quite simple. If a mutex is held for a
short period of time, and on another CPU a task tries to grab the same
mutex, it would be slower to have that task schedule out than to just
spin waiting for that mutex to be released.

Ideally, this mutex would then act like a spin lock, and things would
run very efficiently. But, as it is not a spin lock, there's things we
must also be aware of.

1) If the owner we are waiting for to release the mutex schedules out.

2) If another task wants us to run on the CPU of the waiter that is
spinning.

3) If the waiter that is spinning runs out of its time quantum and
should yield to another task.

#1 is checked by the owner_running(). If that fails, then we should not
spin anymore and its good to schedule. BTW, the answer why
owner_running() is safe to check owner, is because it grabs rcu_locks()
to make sure it is safe.

#2 and #3 are checked by testing NEED_RESCHED on the waiter (NOT THE
OWNER!).  If the waiter that is spinning should be preempted, the waiter
(not the owner) will have its NEED_RESCHED bit set. That is why the
waiter's NEED_RESCHED flag is checked and not owners.

And also we don't need to check need_resched() in the above code because
the loop checks it anyway, or we break out of the loop.

Understand?

-- Steve

