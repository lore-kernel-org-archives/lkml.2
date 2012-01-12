Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2ALHZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:25:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44081 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab2ALHZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:25:43 -0500
Message-ID: <1326353130.2442.177.camel@twins>
Subject: Re: [Question] sched: Should nr_uninterruptible be decremented in
 ttwu_do_activate()?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jan 2012 08:25:30 +0100
In-Reply-To: <CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
References: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
	 <1326302955.2442.174.camel@twins>
	 <CADZ9YHiC8732D=D8KpkT0d+81_BNdAvj0ZJLwL5mhyq9OPLW0Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 12:09 +0600, Rakib Mullick wrote:
> On Wed, Jan 11, 2012 at 11:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2012-01-11 at 23:22 +0600, Rakib Mullick wrote:
> >> Hello all,
> >>
> >> In ttwu_do_activate(), we're decrementing nr_uninterruptible if
> >> p->sched_contributes_to_load (for SMP=y). But, we're also decrementing
> >> nr_uninterruptible from activate_task at the same path. Why we're
> >> doing it twice for a single task activation path?
> >
> > activate_task() does:
> >
> >  if (task_contributes_to_load(p))
> >   rq->nr_uninterruptible--;
> >
> > Now task_contributes_to_load() reads like:
> >
> > #define task_contributes_to_load(task)  \
> >                                ((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
> >                                 (task->flags & PF_FREEZING) == 0)
> >
> > which will be false, since we've set TASK_WAKING.
> 
> Enough confusing. TASK_WAKING will be set when called from
> try_to_wake_up(). ttwu_do_activate() gets called from other places:
> scheduler_ipi() and sched_ttwu_pending() (at the time of cpu goes
> down). TASK_WAKING will be not set at that time,

Yes it will be, the only way to get on that list is throught
ttwu_queue_remote() at which point tasks are TASK_WAKING.

>  moreover it is
> possible that, task has p->sched_contributes_to_load is set and latter
> on gets wake up by sched_ttwu_pending/scheduler_ipi() call.

That's the entire point. But all ways to ttwu_queue_remote() explicitly
set ->sched_contributes_to_load.
