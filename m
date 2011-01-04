Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1ADOrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:47:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:51776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1ADOra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:47:30 -0500
Subject: Re: [RFC][PATCH 16/17] sched: Move the second half of ttwu() to
 the remote cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110104142805.GA4347@redhat.com>
References: <20101224122338.172750730@chello.nl>
	 <20101224123743.303699501@chello.nl>  <20110104142805.GA4347@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 15:47:21 +0100
Message-ID: <1294152441.2016.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 15:28 +0100, Oleg Nesterov wrote:
> On 12/24, Peter Zijlstra wrote:
> >
> > +static void
> > +ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
> > +{
> > +#ifdef CONFIG_SMP
> > +	if (task_cpu(p) != cpu_of(rq))
> > +		set_task_cpu(p, cpu_of(rq));
> > +#endif
> 
> This looks a bit suspicious.
> 
> If this is called by sched_ttwu_pending() we are holding rq->lock,
> not task_rq_lock(). It seems, we can race with, say, migration
> thread running on task_cpu().

I don't think so, nobody should be migrating a TASK_WAKING task.

> OK, p->state = TASK_WAKING protects us against, say, set_cpus_allowed_ptr()
> which does task_rq_lock(p) and thus checks task_is_waking().
> 
> But, at the same time,
> 
> > +#ifdef CONFIG_SMP
> > +static void ttwu_queue_remote(struct task_struct *p, int cpu)
> > +{
> > +	struct task_struct *next = NULL;
> > +	struct rq *rq = cpu_rq(cpu);
> > +
> > +	for (;;) {
> > +		struct task_struct *old = next;
> > +
> > +		p->wake_entry = next;
> > +		next = cmpxchg(&rq->wake_list, old, p);
> > +		if (next == old)
> > +			break;
> > +	}
> > +
> > +	if (!next)
> > +		smp_send_reschedule(cpu);
> 
> what if that cpu does set_cpus_allowed_ptr(p) ?
> 
> It spins with irq disabled. Once the caller, try_to_wake_up(),
> drops ->pi_lock it will wait for !task_is_waking() forever, no?

Ah, it appears I've already fixed that, let me clean up my current
series and repost.
