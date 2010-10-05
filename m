Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0JETMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:12:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60543 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab0JETMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:12:37 -0400
Date: Tue, 5 Oct 2010 21:12:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20101005191223.GA31795@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Eric Dumazet (1):
      rcu: rcu_read_lock_bh_held(): disabling irqs also disables bh

Heiko Carstens (1):
      generic-ipi: Fix deadlock in __smp_call_function_single


 include/linux/rcupdate.h |    2 +-
 kernel/smp.c             |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9fbc54a..83af1f8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -454,7 +454,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * Makes rcu_dereference_check() do the dirty work.
  */
 #define rcu_dereference_bh(p) \
-		rcu_dereference_check(p, rcu_read_lock_bh_held())
+		rcu_dereference_check(p, rcu_read_lock_bh_held() || irqs_disabled())
 
 /**
  * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
diff --git a/kernel/smp.c b/kernel/smp.c
index 75c970c..ed6aacf 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -365,9 +365,10 @@ call:
 EXPORT_SYMBOL_GPL(smp_call_function_any);
 
 /**
- * __smp_call_function_single(): Run a function on another CPU
+ * __smp_call_function_single(): Run a function on a specific CPU
  * @cpu: The CPU to run on.
  * @data: Pre-allocated and setup data structure
+ * @wait: If true, wait until function has completed on specified CPU.
  *
  * Like smp_call_function_single(), but allow caller to pass in a
  * pre-allocated data structure. Useful for embedding @data inside
@@ -376,8 +377,10 @@ EXPORT_SYMBOL_GPL(smp_call_function_any);
 void __smp_call_function_single(int cpu, struct call_single_data *data,
 				int wait)
 {
-	csd_lock(data);
+	unsigned int this_cpu;
+	unsigned long flags;
 
+	this_cpu = get_cpu();
 	/*
 	 * Can deadlock when called with interrupts disabled.
 	 * We allow cpu's that are not yet online though, as no one else can
@@ -387,7 +390,15 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
 		     && !oops_in_progress);
 
-	generic_exec_single(cpu, data, wait);
+	if (cpu == this_cpu) {
+		local_irq_save(flags);
+		data->func(data->info);
+		local_irq_restore(flags);
+	} else {
+		csd_lock(data);
+		generic_exec_single(cpu, data, wait);
+	}
+	put_cpu();
 }
 
 /**
