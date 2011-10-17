Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1JQTYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:24:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1JQTYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:24:17 -0400
Subject: Re: Linux 3.1-rc9
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 17 Oct 2011 21:23:16 +0200
In-Reply-To: <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
	 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
	 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
	 <20111013232521.GA5654@hostway.ca>
	 <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	 <1318847658.6594.40.camel@twins>
	 <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
	 <1318874090.4172.84.camel@twins>
	 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318879396.4172.92.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 11:31 -0700, Linus Torvalds wrote:
> On Mon, Oct 17, 2011 at 10:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > I could of course propose this... but I really won't since I'm half
> > retching by now.. ;-)
> 
> Wow. Is this "ugly and fragile code week" and I just didn't get the memo?

Do I get a price?

> I do wonder if we might not fix the problem by just taking the
> *existing* lock in the right order?
> 
> IOW, how nasty would be it be to make "scheduler_tick()" just get the
> cputimer->lock outside or rq->lock?
> 
> Sure, we'd hold that lock *much* longer than we need, but how much do
> we care? Is that a lock that gets contention? It migth be the simple
> solution for now - I *would* like to get 3.1 out..

Ah, sadly the tick isn't the only one with the inverted callchain,
pretty much every callchain in the scheduler ends up in update_curr()
one way or another.

The easier way around might be something like this... even when two
threads in a process race to enable this clock the the wasted time is
pretty much of the same order as we would otherwise have wasted spinning
on the lock and the update_gt_cputime() think would end up moving the
clock fwd to the latest outcome any which way.

Humm,. Thomas anything?


---
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c8008dd..640ded8 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -274,9 +274,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 	struct task_cputime sum;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cputimer->lock, flags);
 	if (!cputimer->running) {
-		cputimer->running = 1;
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
@@ -284,8 +282,11 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
+		spin_lock_irqsave(&cputimer->lock, flags);
+		cputimer->running = 1;
 		update_gt_cputime(&cputimer->cputime, &sum);
-	}
+	} else
+		spin_lock_irqsave(&cputimer->lock, flags);
 	*times = cputimer->cputime;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }

