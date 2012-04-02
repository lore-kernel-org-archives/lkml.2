Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2DBG04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:26:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44884 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2DBG0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:26:55 -0400
X-IronPort-AV: E=Sophos;i="4.75,355,1330876800"; 
   d="scan'208";a="4671462"
Message-ID: <4F7947EB.5040809@cn.fujitsu.com>
Date: Mon, 02 Apr 2012 14:32:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove the context test in rcu_read_unlock_special()
References: <4F741B98.2070709@cn.fujitsu.com> <20120329215613.GX2450@linux.vnet.ibm.com>
In-Reply-To: <20120329215613.GX2450@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 14:26:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/02 14:26:43,
	Serialize complete at 2012/04/02 14:26:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 05:56 AM, Paul E. McKenney wrote:
> On Thu, Mar 29, 2012 at 04:21:44PM +0800, Lai Jiangshan wrote:
>> Because of commit#26861f and #10f39bb1b2, the context test in
>> rcu_read_unlock_special() are not needed.
>>
>> commit#26861f and #10f39bb1b2 ensure ->rcu_read_unlock_special is zero
>> after rcu_read_unlock(), which implies:
>>
>> if ->rcu_read_unlock_special is non-zero, the out-most RCU C.S. can
>> be interrupted or can be preempted, such context is safe to
>> call rcu_read_unlock_special().
> 
> In theory, I am very much in favor of this, but in practice we need to
> put a WARN_ON_ONCE() in the "if" statement to be removed for a few years
> first.  If there are never any warnings (or, more likely, once such
> warnings have been fixed for some time), then this patch below would be
> eminently sensible.
> 

Add BUG_ON() instead, how about it?
Thanks,
Lai

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..22e2ef1 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -571,12 +571,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	if (special & RCU_READ_UNLOCK_NEED_QS)
 		rcu_preempt_cpu_qs();
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..e90593e 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -210,6 +210,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else if (t->rcu_read_lock_nesting < 0 &&
 		   t->rcu_read_unlock_special) {
+		WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN);
 
 		/*
 		 * Complete exit from RCU read-side critical section on
@@ -239,7 +240,10 @@ static void rcu_preempt_note_context_switch(int cpu)
  */
 void __rcu_read_lock(void)
 {
-	current->rcu_read_lock_nesting++;
+	struct task_struct *t = current;
+
+	BUG_ON(!t->rcu_read_lock_nesting && t->rcu_read_unlock_special);
+	t->rcu_read_lock_nesting++;
 	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -338,12 +342,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_qs(smp_processor_id());
 	}
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
@@ -439,6 +437,7 @@ void __rcu_read_unlock(void)
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
+		BUG_ON(t->rcu_read_unlock_special);
 	}
 #ifdef CONFIG_PROVE_LOCKING
 	{
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 671f959..7074f97 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -318,12 +318,8 @@ static inline void invoke_softirq(void)
 #else
 		do_softirq();
 #endif
-	} else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	} else
 		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
 }
 
 /*
