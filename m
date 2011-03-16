Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1CPJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 05:51:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:44420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1CPJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 05:51:26 -0400
Subject: Re: [PATCH 22/22] sched: Remove TASK_WAKING
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D797F92.6020504@am.sony.com>
References: <20110302173831.295031866@chello.nl>
	 <20110302174121.858324339@chello.nl>  <4D797F92.6020504@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 10:53:20 +0100
Message-ID: <1300269200.2250.83.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 17:49 -0800, Frank Rowand wrote:
> On 03/02/11 09:38, Peter Zijlstra wrote:
> > With the new locking TASK_WAKING has become obsolete, remove it.
> > 
> > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> > ---
> 
> < snip >
> 
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2175,7 +2175,7 @@ void set_task_cpu(struct task_struct *p,
> >  	 * We should never call set_task_cpu() on a blocked task,
> >  	 * ttwu() will sort out the placement.
> >  	 */
> > -	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
> > +	WARN_ON_ONCE(p->state != TASK_RUNNING &&
> >  			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
> >  
> >  #ifdef CONFIG_LOCKDEP
> > @@ -2613,7 +2613,7 @@ try_to_wake_up(struct task_struct *p, un
> >  	smp_rmb();
> >  
> >  	p->sched_contributes_to_load = !!task_contributes_to_load(p);
> > -	p->state = TASK_WAKING;
> > +	p->state = TASK_RUNNING;
> >  
> >  	if (p->sched_class->task_waking)
> >  		p->sched_class->task_waking(p);
> 
> No harm if the coded as in the patch, but an alternate suggestion
> if you like it:
> 
> The only reason left for "p->state = TASK_RUNNING;" here is when
> cpu is remote.  If cpu is not remote then p->state will be set by:
> 
>    ttwu_queue()
>       ttwu_do_activate()
>          ttwu_do_wakeup()
>             p->state = TASK_RUNNING;
> 
> It would be more clear that setting state to TASK_RUNNING is protecting
> the process until it has been removed from the wake_list by
> sched_ttwu_pending() by setting p->state = TASK_RUNNING in ttwu_queue_remote().
> 

Yeah, its a bit of a maze.. maybe we should just drop this and keep the
slightly redundant but more clear TASK_WAKING around.



