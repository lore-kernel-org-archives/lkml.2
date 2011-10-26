Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab1JZPFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:05:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44718 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064Ab1JZPFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:05:19 -0400
Date: Wed, 26 Oct 2011 17:03:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core/locking changes for v3.2
Message-ID: <20111026150344.GA25000@elte.hu>
References: <20111026132500.GA23461@elte.hu>
 <CA+55aFw84RRBxT0QwDT6dg94OqreS8vwMq7Qog+o0QXqR8vgEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw84RRBxT0QwDT6dg94OqreS8vwMq7Qog+o0QXqR8vgEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Oct 26, 2011 at 3:25 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Note, you will get a conflict in kernel/posix-cpu-timers.c, which i
> > resolved in -tip the following way:
> >
> >        raw_spin_lock_irqsave(&cputimer->lock, flags);
> >        if (!cputimer->running) {
> >                cputimer->running = 1;
> >                /*
> >                 * The POSIX timer interface allows for absolute time expiry
> >                 * values through the TIMER_ABSTIME flag, therefore we have
> >                 * to synchronize the timer to the clock every time we start
> >                 * it.
> >                 */
> >                thread_group_cputime(tsk, &sum);
> >                update_gt_cputime(&cputimer->cputime, &sum);
> >        }
> >        *times = cputimer->cputime;
> >        raw_spin_unlock_irqrestore(&cputimer->lock, flags);
> 
> That seems like a completely bogus resolution. You are 
> re-introducing the incorrect ABBA nesting of cputimer->lock and 
> rq->lock, and basically undoing commit bcd5cff7216f.

oh, i quoted the resolution from the pre-ABBA-fix tree :-/

The one in tip:master is:

void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
{
	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
	struct task_cputime sum;
	unsigned long flags;

	if (!cputimer->running) {
		/*
		 * The POSIX timer interface allows for absolute time expiry
		 * values through the TIMER_ABSTIME flag, therefore we have
		 * to synchronize the timer to the clock every time we start
		 * it.
		 */
		thread_group_cputime(tsk, &sum);
		raw_spin_lock_irqsave(&cputimer->lock, flags);
		cputimer->running = 1;
		update_gt_cputime(&cputimer->cputime, &sum);
	} else
		raw_spin_lock_irqsave(&cputimer->lock, flags);
	*times = cputimer->cputime;
	raw_spin_unlock_irqrestore(&cputimer->lock, flags);
}

Good thing you double checked it.

Thanks,

	Ingo
