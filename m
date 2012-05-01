Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2EAADs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:03:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49498 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab2EAADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:03:45 -0400
Date: Mon, 30 Apr 2012 17:02:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120501000245.GA4329@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
 <20120428034257.GA2495@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120428034257.GA2495@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050100-6148-0000-0000-00000572DF4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 08:42:58PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 27, 2012 at 02:15:20PM +0200, Pascal Chapperon wrote:
> > Le 18/04/2012 17:23, Paul E. McKenney a écrit :
> > > On Wed, Apr 18, 2012 at 05:00:14PM +0200, Pascal Chapperon wrote:
> > >> Le 18/04/2012 16:01, Paul E. McKenney a écrit :
> > >>> On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
> > >>>> Mount and umount operations are not slower with RCU_FAST_NO_HZ during
> > >>>> runtime; systemctl start and stop operations are also not slower. In
> > >>>> fact, i couldn't find a single operation slower during runtime with
> > >>>> RCU_FAST_NO_HZ.
> > >>>
> > >>> Your boot-time setup is such that all CPUs are online before the
> > >>> boot-time mount operations take place, right?
> > >> Yes :
> > >> [ 0.242697] Brought up 8 CPUs
> > >> [ 0.242699] Total of 8 processors activated (35118.33 BogoMIPS).
> > >>
> > >>> Struggling to understand
> > >>> how RCU can tell the difference between post-CPU-bringup boot time
> > >>> and run time...
> > >>>
> > >> systemd is controlling the whole boot process including mount
> > >> operation (apart root filesystem) and as I can see, uses heavily
> > >> sockets to do it (not to mention cpu-affinity). It controls also the
> > >> major part of umount operations. Is it possible that your patch hits
> > >> a systemd bug ?
> > > 
> > > Is it possible that systemd is using network operations that include
> > > synchronize_rcu()? Then if you did the same operation from the
> > > command line at runtime, you might not see the slowdown.
> > > 
> > > Is it possible for you to convince systemd to collect RCU event tracing
> > > during the slow operation? RCU event tracing is available under
> > > /sys/kernel/debug/tracing/rcu.
> > >
> > .
> > I have collected the RCU event tracing during a slow boot with
> > FAST_NO_HZ (and the same without FAST_NO_HZ, same kernel config).
> > The full logs and associated "systemd-analyze plot" can be found
> > (in comment 32) at :
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=806548
> > 
> > With FAST_NO_HZ, almost each rcu_prep_idle is followed by ksoftirqd
> > (75000 ksoftirqd lines with FAST_NO_HZ, 4000 without).
> > 
> > Sorry, the logs are very huge, but I can't figure where are the 
> > plots of some interest. 
> 
> Thank you for collecting them!  I clearly will need to do some scripting.  ;-)

And it appears that your system is migrating timers without waking up
the CPU on which the timer was posted.  This explains the slowdowns:
RCU assumes that the timer will either fire on the CPU that it was posted
on or that that CPU will be awakened when it goes offline.  If the timer
does not fire on that CPU and that CPU is not otherwise awakened, then
that CPU's RCU callbacks can be indefinitely postponed, which could account
for the slowdowns that you were seeing.

Please see below for a lightly tested patch that should address this
problem, and thank you again for your patient testing efforts!

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make RCU_FAST_NO_HZ handle timer migration

The current RCU_FAST_NO_HZ assumes that timers do not migrate unless a
CPU goes offline, in which case it assumes that the CPU will have to come
out of dyntick-idle mode (cancelling the timer) in order to go offline.
This is important because when RCU_FAST_NO_HZ permits a CPU to enter
dyntick-idle mode despite having RCU callbacks pending, it posts a timer
on that CPU to force a wakeup on that CPU.  This wakeup ensures that the
CPU will eventually handle the end of the grace period, including invoking
its RCU callbacks.

However, Pascal Chapperon's test setup shows that the timer handler
rcu_idle_gp_timer_func() really does get invoked in some cases.  This is
problematic because this can cause the CPU that entered dyntick-idle
mode despite still having RCU callbacks pending to remain in
dyntick-idle mode indefinitely, which means that its RCU callbacks might
never be invoked.  This situation can result in grace-period delays or
even system hangs, which matches Pascal's observations of slow boot-up
and shutdown (https://lkml.org/lkml/2012/4/5/142).  See also the bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=806548

This commit therefore causes the "should never be invoked" timer handler
rcu_idle_gp_timer_func() to use smp_call_function_single() to wake up
the CPU for which the timer was intended, allowing that CPU to invoke
its RCU callbacks in a timely manner.

Reported-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/trace/events/rcu.h |    1 +
 kernel/rcutree_plugin.h    |   23 ++++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index aaa55e1..1480900 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -292,6 +292,7 @@ TRACE_EVENT(rcu_dyntick,
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ *	"Demigrate": Timer fired on wrong CPU, woke up correct CPU.
  *	"Cleanup after idle": Idle exited, timer canceled.
  */
 TRACE_EVENT(rcu_prep_idle,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dc12efc..bbd064a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1994,16 +1994,33 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ *
+ */
+void rcu_idle_demigrate(void *unused)
+{
+	trace_rcu_prep_idle("Demigrate");
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
  * real work is done upon re-entry to idle, or by the next scheduling-clock
  * interrupt should idle not be re-entered.
+ *
+ * One special case: the timer gets migrated without awakening the CPU
+ * on which the timer was scheduled on.  In this case, we must wake up
+ * that CPU.  We do so with smp_call_function_single().
  */
-static void rcu_idle_gp_timer_func(unsigned long unused)
+static void rcu_idle_gp_timer_func(unsigned long cpu_in)
 {
-	WARN_ON_ONCE(1); /* Getting here can hang the system... */
+	int cpu = (int)cpu_in;
+
 	trace_rcu_prep_idle("Timer");
+	if (cpu != smp_processor_id())
+		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
+	else
+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
 }
 
 /*
@@ -2012,7 +2029,7 @@ static void rcu_idle_gp_timer_func(unsigned long unused)
 static void rcu_prepare_for_idle_init(int cpu)
 {
 	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
-		    rcu_idle_gp_timer_func, 0);
+		    rcu_idle_gp_timer_func, cpu);
 }
 
 /*

