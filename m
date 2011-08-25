Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1HYN6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:58:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1HYN6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:58:05 -0400
Date: Thu, 25 Aug 2011 15:54:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, "yong.zhang0" <yong.zhang0@gmail.com>,
        scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110825135429.GA32048@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins> <20110824160806.GA12317@redhat.com> <1314267872.27911.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314267872.27911.6.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Peter Zijlstra wrote:
>
> On Wed, 2011-08-24 at 18:08 +0200, Oleg Nesterov wrote:
> > >
> > >  static void ttwu_queue(struct task_struct *p, int cpu)
> > > @@ -2705,7 +2703,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > >  	 * this task as prev, wait until its done referencing the task.
> > >  	 */
> > >  	while (p->on_cpu) {
> > > -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> > >  		/*
> > >  		 * In case the architecture enables interrupts in
> > >  		 * context_switch(), we cannot busy wait, since that
> > > @@ -2713,11 +2710,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > >  		 * tries to wake up @prev. So bail and do a complete
> > >  		 * remote wakeup.
> > >  		 */
> > > -		if (ttwu_activate_remote(p, wake_flags))
> > > +		if (cpu == smp_processor_id() &&
> >
> > I think this needs "task_cpu(p) == smp_processor_id()". We can't trust
> > "cpu", task_cpu() was called before ->on_rq check.
>
> Isn't us holding ->pi_lock sufficient to stabilize task_cpu()? If its a
> running task the initial ->state check would have failed,

Of course it is not TASK_RUNNING, but it can be running or not.

> and thus its a
> proper wakeup when we get here and thus ->pi_lock is serializing things.

I am not sure. If ->on_rq is true, we need rq->lock. Say, pull_task() can
change its cpu.

> > 	--- x/kernel/sched.c
> > 	+++ x/kernel/sched.c
> > 	@@ -2694,10 +2694,11 @@ try_to_wake_up(struct task_struct *p, un
> > 			goto out;
> > 	 
> > 		success = 1; /* we're going to change ->state */
> > 	-	cpu = task_cpu(p);
> > 	 
> > 	-	if (p->on_rq && ttwu_remote(p, wake_flags))
> > 	+	if (p->on_rq && ttwu_remote(p, wake_flags)) {
> > 	+		cpu = task_cpu(p); /* for ttwu_stat() */
> > 			goto stat;
> > 	+	}
> > 	 
> > 	 #ifdef CONFIG_SMP
> > 		/*
>
> Would result in the same problem as below...

I see, thanks.

Yes, ttwu_queue(p, cpu) needs this task_cpu() without CONFIG_SMP.

Oleg.

