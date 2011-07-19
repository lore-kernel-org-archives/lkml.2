Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GSWlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:41:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59431 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1GSWlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:41:44 -0400
Date: Tue, 19 Jul 2011 15:41:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: kernelmail.jms@gmail.com, kulkarni.ravi4@gmail.com
Cc: linux-kernel@vger.kernel.org, cmm@us.ibm.com
Subject: Fw: RCU boot debug patch
Message-ID: <20110719224142.GT2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Julie and Ravi,

Although we arrived at a patch that worked for both of you, we never did
identify exactly which RCU callback (or other issue) that was causing
the problem.  It would be good to do this in case there is some other
problem lurking that might bite us in the future.  Mingming has therefore
put together the following diagnostic patch which should identify the
callbacks, please see below.

So could you please run this and let us know what you find?  There should
at least be a message for artificial_callback().

							Thanx, Paul

------------------------------------------------------------------------

A debug patch to verify if there is RCU callbacks before the rcu scheduler is active. Please looking
at the dmesg to see if any message print out related to this other than the artificial one.

Signed_off_by: Mingming Cao <cmm@us.ibm.com>
diff --git a/init/main.c b/init/main.c
index d7211fa..2abc1a5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -452,11 +452,13 @@ static void __init mm_init(void)
 	pgtable_cache_init();
 	vmalloc_init();
 }
+static void artificial_callback(struct rcu_head *p) {};

 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
+	static struct rcu_head artificial_rcu_head;

 	smp_setup_processor_id();

@@ -531,6 +533,7 @@ asmlinkage void __init start_kernel(void)
 	idr_init_cache();
 	perf_event_init();
 	rcu_init();
+	call_rcu(&artificial_rcu_head, artificial_callback);	
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..60ca927 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1514,6 +1514,11 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	head->func = func;
 	head->next = NULL;

+	if ((system_state == SYSTEM_BOOTING) && (!rcu_scheduler_active))
+		printk(KERN_ALERT "RCU scheduler is not active yet, "
+		        "Calling _call_rcu() with this function %pf\n",
+			func);
+
 	smp_mb(); /* Ensure RCU update seen before callback registry. */

 	/*



