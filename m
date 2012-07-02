Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab2GBL7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:59:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:35381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GBL7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:59:20 -0400
Message-ID: <1341230352.23484.7.camel@twins>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 13:59:12 +0200
In-Reply-To: <20120702113541.GI2907@linux.vnet.ibm.com>
References: <1340964584.2936.40.camel@lappy>
	 <20120629172320.GA2416@linux.vnet.ibm.com> <1341006040.26928.4.camel@lappy>
	 <1341225139.23484.4.camel@twins> <20120702113541.GI2907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 04:35 -0700, Paul E. McKenney wrote:
> On Mon, Jul 02, 2012 at 12:32:19PM +0200, Peter Zijlstra wrote:
> > On Fri, 2012-06-29 at 23:40 +0200, Sasha Levin wrote:
> > > 
> > > The bad news are that what you saw was a lockdep enabled run
> > > (CONFIG_PROVE_RCU is enabled, and lockdep was enabled). There were no
> > > lockdep warnings at any point while reproducing it. 
> > 
> > rcu_switch_from() -> rcu_preempt_note_context_switch() is called _after_
> > the lockdep context switch annotation. Therefore lockdep things the prev
> > task isn't holding any locks anymore.
> 
> In other words, moving rcu_preempt_note_context_switch() deeper into
> the scheduler is totally bogus, and I need to move it back out into the
> original rcu_note_context_switch(), reverting 616c310e (Move PREEMPT_RCU
> preemption to switch_to() invocation), correct?
> 
> Sigh.  "It seemed like a good idea at the time."

It only needs moving back before that spin_release() thing. But unless
there's a reason to do it later, something like the below might be the
right thing. 

---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9bb7d28..7e20e6c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1914,6 +1914,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
+	rcu_switch_from(prev);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 	trace_sched_switch(prev, next);
@@ -2082,7 +2083,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 #endif
 
 	/* Here we just switch the register state and the stack. */
-	rcu_switch_from(prev);
 	switch_to(prev, next, prev);
 
 	barrier();

