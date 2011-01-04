Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab1ADMei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 07:34:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:49608 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1ADMeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 07:34:37 -0500
Subject: Re: [RFC][PATCH 08/17] sched: Drop the rq argument to
 sched_class::select_task_rq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikj=t0s9MfiG85gR+JkTSBa_F9yFmu1R2rTuHv_@mail.gmail.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.887559254@chello.nl> <20101229143136.GC2728@zhy>
	 <1294053409.2016.59.camel@laptop> <20110103145902.GA7632@redhat.com>
	 <1294068061.2016.84.camel@laptop> <20110103154918.GB7632@redhat.com>
	 <AANLkTikj=t0s9MfiG85gR+JkTSBa_F9yFmu1R2rTuHv_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 13:34:44 +0100
Message-ID: <1294144484.2016.135.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:27 +0800, Yong Zhang wrote:
> On Mon, Jan 3, 2011 at 11:49 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Ah, sorry for the confusion, I only meant sched_exec() case.
> > set_cpus_allowed_ptr() does need need_migrate_task(), of course.
> >
> >
> > As for set_cpus_allowed_ptr()->need_migrate_task() path, I have another
> > question,
> >
> >        static bool need_migrate_task(struct task_struct *p)
> >        {
> >                /*
> >                 * If the task is not on a runqueue (and not running), then
> >                 * the next wake-up will properly place the task.
> >                 */
> >                smp_rmb(); /* finish_lock_switch() */
> >                return p->on_rq || p->on_cpu;
> >        }
> >
> > I don't understand this smp_rmb(). Yes, finish_lock_switch() does
> > wmb() before it clears ->on_cpu, but how these 2 barriers can pair?
> >
> > In fact, I am completely confused. I do not understand why do we
> > check task_running() at all. If we see on_rq == 0 && on_cpu == 1,
> > then this task is going to clear its on_cpu soon, once it finishes
> > context_switch().
> >
> > Probably, this check was needed before, try_to_wake_up() could
> > activate the task_running() task without migrating. But, at first
> > glance, this is no longer possible after this series?
> 
> Yeah, task_running() is not needed after patch 13 which
> may be the suitable place to poke :)

That and patch 6, which removes the false negatives from ->on_rq.
