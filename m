Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2DQQpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:45:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54623 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab2DQQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:45:42 -0400
Date: Tue, 17 Apr 2012 09:45:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: New RCU related warning due to rcu_preempt_depth() changes
Message-ID: <20120417164503.GA27031@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
 <20120417150556.GB2404@linux.vnet.ibm.com>
 <CA+1xoqc=ssJmfMTogN8H_8yqNXys8-yJbx7=XVVSN3CvOPcyWA@mail.gmail.com>
 <20120417155316.GE2404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120417155316.GE2404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041716-4242-0000-0000-0000015F85FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 08:53:16AM -0700, Paul E. McKenney wrote:
> On Tue, Apr 17, 2012 at 05:36:59PM +0200, Sasha Levin wrote:
> > On Tue, Apr 17, 2012 at 5:05 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Tue, Apr 17, 2012 at 10:42:47AM +0200, Sasha Levin wrote:
> > >> Hi Paul,
> > >>
> > >> It looks like commit 7298b03 ("rcu: Move __rcu_read_lock() and
> > >> __rcu_read_unlock() to per-CPU variables") is causing the following
> > >> warning (I've added the extra fields on the second line):
> > >>
> > >> [   77.330920] BUG: sleeping function called from invalid context at
> > >> mm/memory.c:3933
> > >> [   77.336571] in_atomic(): 0, irqs_disabled(): 0, preempt count: 0,
> > >> preempt offset: 0, rcu depth: 1, pid: 5669, name: trinity
> > >> [   77.344135] no locks held by trinity/5669.
> > >> [   77.349644] Pid: 5669, comm: trinity Tainted: G        W
> > >> 3.4.0-rc3-next-20120417-sasha-dirty #83
> > >> [   77.354401] Call Trace:
> > >> [   77.355956]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
> > >> [   77.358811]  [<ffffffff81198eaf>] might_fault+0x2f/0xa0
> > >> [   77.361997]  [<ffffffff810e3228>] schedule_tail+0x88/0xb0
> > >> [   77.364671]  [<ffffffff826a01d3>] ret_from_fork+0x13/0x80
> > >>
> > >> As you can see, rcu_preempt_depth() returns 1 when running in that
> > >> context, which looks pretty odd.
> > >
> > > Ouch!!!
> > >
> > > So it looks like I missed a place where I need to save and restore
> > > the new per-CPU rcu_read_lock_nesting and rcu_read_unlock_special
> > > variables.  My (probably hopelessly naive) guess is that I need to add
> > > a rcu_switch_from() and rcu_switch_to() into schedule_tail(), but to
> > > make rcu_switch_from() take the task_struct pointer as an argument,
> > > passing in prev.
> > >
> > > Does this make sense, or am I still missing something here?
> > 
> > I've let the test run for a bit more, and it appears that I'm getting
> > this warning from lots of different sources, would this
> > schedule_tail() fix all of them?
> 
> If I understand the failure correctly, yes.  If the task switches without
> RCU paying attention, the nesting count for both the outgoing and the
> incoming tasks can get messed up.  The messed-up counts could easily
> cause problems downstream.
> 
> Of course, there might well be additional bugs.
> 
> I will put a speculative patch together and send it along.

And here it is, testing just started.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Add RCU context switching to schedule_tail()

The new rcu_read_lock_nesting and rcu_read_unlock_special per-CPU
variables must be saved and restored at every context switch, including
those involving schedule_tail().  This commit therefore adds the saving
and restoring to schedul_tail().

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 25a7fea..32272d4 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -704,7 +704,7 @@ static void stack_proc(void *arg)
 	struct task_struct *from = current, *to = arg;
 
 	to->thread.saved_task = from;
-	rcu_switch_from();
+	rcu_switch_from(from);
 	switch_to(from, to, from);
 	rcu_switch_to();
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2468cb..0d48609 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1937,10 +1937,8 @@ static inline void rcu_copy_process(struct task_struct *p)
  *
  * The caller must have disabled preemption.
  */
-static inline void rcu_switch_from(void)
+static inline void rcu_switch_from(struct task_struct *t)
 {
-	struct task_struct *t = current;
-
 	if (__this_cpu_read(rcu_read_lock_nesting) != 0)
 		rcu_preempt_note_context_switch();
 	t->rcu_read_lock_nesting_save = __this_cpu_read(rcu_read_lock_nesting);
@@ -1991,7 +1989,7 @@ static inline void rcu_copy_process(struct task_struct *p)
 {
 }
 
-static inline void rcu_switch_from(void)
+static inline void rcu_switch_from(struct task_struct *t)
 {
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51ce537..17ae267 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2024,6 +2024,8 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 {
 	struct rq *rq = this_rq();
 
+	rcu_switch_from(prev);
+	rcu_switch_to();
 	finish_task_switch(rq, prev);
 
 	/*
@@ -2083,7 +2085,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from();
+	rcu_switch_from(current);
 	switch_to(prev, next, prev);
 	rcu_switch_to();
 

