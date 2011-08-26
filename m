Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1HZGBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:01:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:32784 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1HZGBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:01:19 -0400
Date: Fri, 26 Aug 2011 14:01:07 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, scameron@beardog.cce.hp.com,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jens Axboe <jaxboe@fusionio.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [kernel.org users] [KORG] Panics on master backend
Message-ID: <20110826060107.GA28189@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4E53ECEF.7040109@kernel.org>
 <1314129133.8002.102.camel@twins>
 <20110824160806.GA12317@redhat.com>
 <1314267872.27911.6.camel@twins>
 <20110825135429.GA32048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110825135429.GA32048@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:54:29PM +0200, Oleg Nesterov wrote:
> On 08/25, Peter Zijlstra wrote:
> >
> > On Wed, 2011-08-24 at 18:08 +0200, Oleg Nesterov wrote:
> > > >
> > > >  static void ttwu_queue(struct task_struct *p, int cpu)
> > > > @@ -2705,7 +2703,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > > >  	 * this task as prev, wait until its done referencing the task.
> > > >  	 */
> > > >  	while (p->on_cpu) {
> > > > -#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> > > >  		/*
> > > >  		 * In case the architecture enables interrupts in
> > > >  		 * context_switch(), we cannot busy wait, since that
> > > > @@ -2713,11 +2710,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > > >  		 * tries to wake up @prev. So bail and do a complete
> > > >  		 * remote wakeup.
> > > >  		 */
> > > > -		if (ttwu_activate_remote(p, wake_flags))
> > > > +		if (cpu == smp_processor_id() &&
> > >
> > > I think this needs "task_cpu(p) == smp_processor_id()". We can't trust
> > > "cpu", task_cpu() was called before ->on_rq check.
> >
> > Isn't us holding ->pi_lock sufficient to stabilize task_cpu()? If its a
> > running task the initial ->state check would have failed,
> 
> Of course it is not TASK_RUNNING, but it can be running or not.

Yup. Before we go beyond ttwu_remote() in ttwu(), 'cpu' is not safe.
For example, wait_event() could be preempted in between.

But after we go beyond ttwu_remote(), ->pi_lock will stabilize it.

So after we take Oleg's suggestion("task_cpu(p) == smp_processor_id()"),
things we left is just how to account stat correctly.

IMHO, we could get cpu in ttwu_remote() to prevent the side effect of
pull_task().

something like below?

Thanks,
Yong

---
diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..4a1d05d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2540,7 +2540,7 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
  * since all we need to do is flip p->state to TASK_RUNNING, since
  * the task is still ->on_rq.
  */
-static int ttwu_remote(struct task_struct *p, int wake_flags)
+static int ttwu_remote(struct task_struct *p, int wake_flags, int *cpu)
 {
 	struct rq *rq;
 	int ret = 0;
@@ -2548,6 +2548,7 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	rq = __task_rq_lock(p);
 	if (p->on_rq) {
 		ttwu_do_wakeup(rq, p, wake_flags);
+		*cpu = task_cpu(p);
 		ret = 1;
 	}
 	__task_rq_unlock(rq);
@@ -2696,7 +2697,12 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (p->on_rq && ttwu_remote(p, wake_flags))
+	/*
+	 * read cpu for another time if ttwu_remote() success,
+	 * just to prevent task migration in between, otherwise
+	 * we maybe account stat incorrectly.
+	 */
+	if (p->on_rq && ttwu_remote(p, wake_flags, &cpu))
 		goto stat;
 
 #ifdef CONFIG_SMP

