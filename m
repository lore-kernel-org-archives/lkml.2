Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab0IHLMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:12:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0IHLMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:12:38 -0400
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: balbir@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>,
        ikael Starvik <starvik@axis.com>, dhowells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=FO3fx4F16CUXAzdKYTNoPjZaLfUvsqBJzAPV1@mail.gmail.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
	 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
	 <1282636286.2605.2307.camel@laptop>
	 <20100824080515.GK4684@balbir.in.ibm.com>
	 <1282640953.2605.2428.camel@laptop>
	 <20100824113801.GO4684@balbir.in.ibm.com>
	 <1282650835.2605.2629.camel@laptop>
	 <AANLkTi=QuD7v1PP9PaJt_Dz1N-JKC1e6km1TE_YE6iJk@mail.gmail.com>
	 <1282682357.2605.3219.camel@laptop>
	 <AANLkTi=FO3fx4F16CUXAzdKYTNoPjZaLfUvsqBJzAPV1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 13:12:00 +0200
Message-ID: <1283944320.23762.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 19:02 -0700, Venkatesh Pallipadi wrote:
> On Tue, Aug 24, 2010 at 1:39 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-08-24 at 12:20 -0700, Venkatesh Pallipadi wrote:
> >
> >
> >> - I started looking as not accounting this time to tasks themselves.
> >> This was really tricky as things are tightly tied to scheduler
> >> vruntime to get it right.
> >
> > I'm not exactly sure where that would get complicated, simply treat
> > interrupts the same as preemptions by other tasks and things should
> > basically work out rather straight forward from that.
> >
> 
> Atleast the way I tried it turned out to be messy. Keep track of time
> at si and hi
> and remove it from update_curr delta. I did it that way as I didn't
> want to take rq lock
> on hi si path. Doing it as preemption with put_prev/pick_next would be
> expensive. No?
> Or you meant it some other way?

No, removing it from update_curr()'s delta is exactly what I meant. That
gives the same end result as if the task were preempted (ie. it ran
less).

> >> I am not even sure I got it totally right
> >> :(, but I did play with the patch a bit. And noticed there were
> >> multiple issues. 1) A silly case as in of two tasks on one CPU, one
> >> task totally CPU bound and another task doing network recv. This is
> >> how task and softirq time looks like for this (10s samples)
> >> (loop)  (nc)
> >> 503 9   502 301
> >> 502 8   502 303
> >> 502 9   501 302
> >> 502 8   502 302
> >> 503 9   501 302
> >> Now, when I did "not account si time to task", the loop task ended up
> >> getting a lot less CPU time and doing less work as nc task doing rcv
> >> got more CPU share, which was not right thing to do. IIRC, I had
> >> something like <300 centiseconds for loop after the change (with si
> >> activity increasing due to higher runtime of nc task).
> >
> > Well, that actually makes sense and I wouldn't call it wrong.
> 
> I meant, that will make nc run for more than its fair share.

No it wouldn't, it would make nc run exactly its fair share. SoftIRQ
time isn't nc time, so by not accounting it to nc, nc gets to run more.

> >> So, even though it seems accounting irq time as "system time" seems
> >> the right thing to do, it can break scheduling in many ways. May be
> >> hardirq can be accounted as system time. But, dealing with softirq is
> >> tricky as they can be related to the task.
> >
> > I haven't yet seen any scheduler breakage here, it will divide time
> > differently, but not in a broken way, if the system consumes 1/3rd of
> > the time, there's only 2/3rd left to fairly distribute between tasks, so
> > something like, 1/3-loop 1/3-nc 1/3-softirq makes perfect sense.
> >
> > You'd get exactly the same kind of thing if you replace (soft)irq with a
> > FIFO task.
> >
> 
> But, FIFO in that case would be some unrelated task taking away CPU.
> Here one task can take more than its share due to si.

No, how is being preempted by an unrelated task (FIFO whatever)
different from being 'preempted' by unrelated SoftIRQ processing?


> > This is where I strongly disagree, providing an interface that cannot
> > possibly be implemented correctly just so you can fudge something (still
> > not sure what from userspace) seems a very bad idea indeed.
> >
> 
> I don't think correctness is a problem. TSC is pretty good for this
> purpose on current hardware. I agree that usability is debatable.

Like already argued, it is a correctness issue, TSC is only an accuracy
issue, but since you cannot properly attribute this very accurate time
measurement, you're still totally incorrect.

> If you strongly think that the right way is to make both si and hi
> "system time" and that will not cause unfairness and slowdown for some
> unrelated tasks, I can try to cleanup the patch I had for that and
> send it out. I am afraid though, it will cause some regression and we
> will end up back at square one after a month or so. :(

Sure it will affect some workloads, but its also more correct. If
network workloads suffer we can look at sorting out some of those
problems. But really SoftIRQ != task context and thus should not be
accounted to said task.
