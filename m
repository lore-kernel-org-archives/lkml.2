Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1KBO6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:58:45 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42682 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1KBO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:58:43 -0400
Date: Wed, 2 Nov 2011 07:44:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111102144403.GA22445@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
 <20111101160014.GH2287@linux.vnet.ibm.com>
 <20111101163212.GA19501@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101163212.GA19501@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110214-6078-0000-0000-0000038301AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 12:32:12AM +0800, Wu Fengguang wrote:
> > Hmmmm...  Please see below for a diagnostic patch that prints out who
> > the kernel believes the idle thread is.  Could you please give this
> > a go?
> 
> Sure. Here it goes :)

And here is a possible fix.  Could you please test it?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix idle-task checks

RCU has traditionally relied on idle_cpu() to determine whether a given
CPU is running in the context of an idle task, but recent changes have
invalidated this approach.  This commit therefore switches from idle_cpu
to "current->pid != 0".

Suggested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index f4e7bc3..35f8a07 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -65,7 +65,7 @@ static void rcu_idle_enter_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
@@ -119,7 +119,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
-	if (!idle_cpu(smp_processor_id())) {
+	if (!current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3d7b474..414af68 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -355,7 +355,7 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 		return;
 	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on entry: not idle task",
@@ -449,7 +449,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	smp_mb__after_atomic_inc();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
-	if (!idle_cpu(smp_processor_id())) {
+	if (current->pid != 0) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		trace_rcu_dyntick("Error on exit: not idle task",

