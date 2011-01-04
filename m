Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADNBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:01:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:46918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1ADNBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:01:37 -0500
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110103180534.GA16502@redhat.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.887559254@chello.nl>  <20110103180534.GA16502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 14:01:33 +0100
Message-ID: <1294146093.2016.137.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 19:05 +0100, Oleg Nesterov wrote:
> On 12/24, Peter Zijlstra wrote:
> >
> > @@ -2680,24 +2681,17 @@ void wake_up_new_task(struct task_struct
> >  {
> >  	unsigned long flags;
> >  	struct rq *rq;
> > -	int cpu __maybe_unused = get_cpu();
> 
> Wait, I think this not right.
> 
> >  #ifdef CONFIG_SMP
> >  	rq = task_rq_lock(p, &flags);
> > -	p->state = TASK_WAKING;
> >
> >  	/*
> >  	 * Fork balancing, do it here and not earlier because:
> >  	 *  - cpus_allowed can change in the fork path
> >  	 *  - any previously selected cpu might disappear through hotplug
> > -	 *
> > -	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
> > -	 * without people poking at ->cpus_allowed.
> >  	 */
> > -	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> > -	set_task_cpu(p, cpu);
> > +	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
> >
> > -	p->state = TASK_RUNNING;
> >  	task_rq_unlock(rq, &flags);
> 
> We need preempt_disable() to protect us against CPU hotplug. This task
> was never activated, it won't be found/migrated if that CPU goes away
> before we take task_rq_lock().

Ah, indeed. I've replaced it by keeping IRQs disabled over the whole
function, no need to restore and save them in the middle.
