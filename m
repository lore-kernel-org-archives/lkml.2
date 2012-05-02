Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2EBUZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:25:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2EBUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:25:50 -0400
Date: Wed, 2 May 2012 13:25:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
In-Reply-To: <20120501232516.GR2441@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils> <1335832418.20866.95.camel@pasglop> <alpine.LSU.2.00.1204302142310.27208@eggly.anvils> <20120501142208.GA2441@linux.vnet.ibm.com> <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012, Paul E. McKenney wrote:
> > > > > On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> > > > > > 
> > > > > > BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> > > > > > in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> > > > > > Call Trace:
> > > > > > [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> > > > > > [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> > > > > > [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> > > > > > [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> > > > > > [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> > > > > > [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30

Got it at last.  Embarrassingly obvious.  __rcu_read_lock() and
__rcu_read_unlock() are not safe to be using __this_cpu operations,
the cpu may change in between the rmw's read and write: they should
be using this_cpu operations (or, I put preempt_disable/enable in the
__rcu_read_unlock below).  __this_cpus there work out fine on x86,
which was given good instructions to use; but not so well on PowerPC.

I've been running successfully for an hour now with the patch below;
but I expect you'll want to consider the tradeoffs, and may choose a
different solution.

Hugh

--- 3.4-rc4-next-20120427/include/linux/rcupdate.h	2012-04-28 09:26:38.000000000 -0700
+++ testing/include/linux/rcupdate.h	2012-05-02 11:46:06.000000000 -0700
@@ -159,7 +159,7 @@ DECLARE_PER_CPU(struct task_struct *, rc
  */
 static inline void __rcu_read_lock(void)
 {
-	__this_cpu_inc(rcu_read_lock_nesting);
+	this_cpu_inc(rcu_read_lock_nesting);
 	barrier(); /* Keep code within RCU read-side critical section. */
 }
 
--- 3.4-rc4-next-20120427/kernel/rcupdate.c	2012-04-28 09:26:40.000000000 -0700
+++ testing/kernel/rcupdate.c	2012-05-02 11:44:13.000000000 -0700
@@ -72,6 +72,7 @@ DEFINE_PER_CPU(struct task_struct *, rcu
  */
 void __rcu_read_unlock(void)
 {
+	preempt_disable();
 	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
 		__this_cpu_dec(rcu_read_lock_nesting);
 	else {
@@ -83,13 +84,14 @@ void __rcu_read_unlock(void)
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		__this_cpu_write(rcu_read_lock_nesting, 0);
 	}
-#ifdef CONFIG_PROVE_LOCKING
+#if 1 /* CONFIG_PROVE_LOCKING */
 	{
 		int rln = __this_cpu_read(rcu_read_lock_nesting);
 
-		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
+		BUG_ON(rln < 0 && rln > INT_MIN / 2);
 	}
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
--- 3.4-rc4-next-20120427/kernel/sched/core.c	2012-04-28 09:26:40.000000000 -0700
+++ testing/kernel/sched/core.c	2012-05-01 22:40:46.000000000 -0700
@@ -2024,7 +2024,7 @@ asmlinkage void schedule_tail(struct tas
 {
 	struct rq *rq = this_rq();
 
-	rcu_switch_from(prev);
+	/* rcu_switch_from(prev); */
 	rcu_switch_to();
 	finish_task_switch(rq, prev);
 
@@ -7093,6 +7093,10 @@ void __might_sleep(const char *file, int
 		"BUG: sleeping function called from invalid context at %s:%d\n",
 			file, line);
 	printk(KERN_ERR
+		"cpu=%d preempt_count=%x preempt_offset=%x rcu_nesting=%x nesting_save=%x\n",
+		raw_smp_processor_id(), preempt_count(), preempt_offset,
+		rcu_preempt_depth(), current->rcu_read_lock_nesting_save); 
+	printk(KERN_ERR
 		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
 			in_atomic(), irqs_disabled(),
 			current->pid, current->comm);
