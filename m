Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2FNHpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:45:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46288 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752987Ab2FNHph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:45:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+dxdJ7la2dcc4zxh4dnsPR9jKpb/sweIU4kprIB/
	8BkxcEmwq3s9MY
Message-ID: <1339659932.7347.76.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <efault@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Jun 2012 09:45:32 +0200
In-Reply-To: <1339571575.7472.78.camel@marge.simpson.net>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
	 <1339435214.7358.43.camel@marge.simpson.net>
	 <20120611180112.GD2521@linux.vnet.ibm.com>
	 <1339438242.7358.62.camel@marge.simpson.net>
	 <1339558508.7472.26.camel@marge.simpson.net>
	 <alpine.LSU.2.00.1206122120460.5221@eggly.anvils>
	 <1339566974.7472.45.camel@marge.simpson.net>
	 <1339571575.7472.78.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 09:12 +0200, Mike Galbraith wrote: 
> On Wed, 2012-06-13 at 07:56 +0200, Mike Galbraith wrote:
> 
> > Question remains though.  Maybe the box hit some other problem that led
> > to death by RCU gripage, but the info I received indicated the box was
> > in the midst of a major spin-fest.
> 
> To (maybe) speak more clearly, since it's a mutex like any other mutex
> that loads of CPUs can hit if you've got loads of CPUs, did huge box
> driver do something that we don't expect so many CPUs to be doing, thus
> instigate simultaneous exit trouble (ie shoot self in foot), or did that
> mutex addition create the exit trouble which box appeared to be having?

Crickets chirping.. I know what _that_ means: "tsk tsk, you dummy" :)

I suspected that would happen, but asked anyway because I couldn't
imagine even 4096 CPUs getting tangled up for an _eternity_ trying to go
to sleep, but the lock which landed after 32-stable where these beasts
earn their daily fuel rods was splattered all over the event.  Oh well.

So, I can forget that and just make the thing not gripe itself to death
should a stall for whatever reason be encountered again.

Rather than mucking about with rcu_cpu_stall_suppress, how about adjust
timeout as you proceed, and block report functions?  That way, there's
no fiddling with things used elsewhere, and it shouldn't matter how
badly console is being be hammered, you get a full report, and maybe
even only one.

Hm, maybe I should forget hoping to keep check_cpu_stall() happy too,
and only silently ignore it when busy.

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0da7b88..e9dd654 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -727,24 +727,29 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
+int rcu_stall_report_in_progress;
+
 static void print_other_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
 	long delta;
 	unsigned long flags;
 	int ndetected;
-	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *root = rcu_get_root(rsp);
+	struct rcu_node *rnp;
 
 	/* Only let one CPU complain about others per time interval. */
 
-	raw_spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&root->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
-	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp) ||
+			rcu_stall_report_in_progress) {
+		raw_spin_unlock_irqrestore(&root->lock, flags);
 		return;
 	}
 	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	rcu_stall_report_in_progress++;
+	raw_spin_unlock_irqrestore(&root->lock, flags);
 
 	/*
 	 * OK, time to rat on our buddy...
@@ -765,16 +770,23 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 				print_cpu_stall_info(rsp, rnp->grplo + cpu);
 				ndetected++;
 			}
+
+		/*
+		 * Push the timeout back as we go.  With a slow serial
+		 * console on a large machine, this may take a while.
+		 */ 
+		raw_spin_lock_irqsave(&root->lock, flags);
+		rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
+		raw_spin_unlock_irqrestore(&root->lock, flags);
 	}
 
 	/*
 	 * Now rat on any tasks that got kicked up to the root rcu_node
 	 * due to CPU offlining.
 	 */
-	rnp = rcu_get_root(rsp);
-	raw_spin_lock_irqsave(&rnp->lock, flags);
-	ndetected = rcu_print_task_stall(rnp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&root->lock, flags);
+	ndetected = rcu_print_task_stall(root);
+	raw_spin_unlock_irqrestore(&root->lock, flags);
 
 	print_cpu_stall_info_end();
 	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
@@ -784,6 +796,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	else if (!trigger_all_cpu_backtrace())
 		dump_stack();
 
+	raw_spin_lock_irqsave(&root->lock, flags);
+	rcu_stall_report_in_progress--;
+	raw_spin_unlock_irqrestore(&root->lock, flags);
+
 	/* If so configured, complain about tasks blocking the grace period. */
 
 	rcu_print_detail_task_stall(rsp);
@@ -796,6 +812,17 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (rcu_stall_report_in_progress) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	/* Reset timeout, dump_stack() may take a while on large machines. */
+	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
+	rcu_stall_report_in_progress++;
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+
 	/*
 	 * OK, time to rat on ourselves...
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
@@ -813,6 +840,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall = jiffies +
 				     3 * jiffies_till_stall_check() + 3;
+	rcu_stall_report_in_progress--;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */

-Mike

