Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2I1Rdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:33:35 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44599 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab2I1Rde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:33:34 -0400
Date: Fri, 28 Sep 2012 10:31:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: eqs related warnings in linux-next
Message-ID: <20120928173133.GB2498@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50659D37.2020206@gmail.com>
 <20120928133633.GC12843@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928133633.GC12843@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092817-5930-0000-0000-00000C92CD84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:36:43PM +0200, Frederic Weisbecker wrote:
> On Fri, Sep 28, 2012 at 02:51:03PM +0200, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest with the latest linux-next kernel, I've stumbled on the following during boot:
> > 
> > [  199.224369] WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common+0x4a/0x3a0()
> > [  199.225307] Pid: 1, comm: init Tainted: G        W    3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13
> > [  199.226611] Call Trace:
> > [  199.226951]  [<ffffffff811c8d1a>] ? rcu_eqs_exit_common+0x4a/0x3a0
> > [  199.227773]  [<ffffffff81108e36>] warn_slowpath_common+0x86/0xb0
> > [  199.228572]  [<ffffffff81108f25>] warn_slowpath_null+0x15/0x20
> > [  199.229348]  [<ffffffff811c8d1a>] rcu_eqs_exit_common+0x4a/0x3a0
> > [  199.230037]  [<ffffffff8117f267>] ? __lock_acquire+0x1c37/0x1ca0
> > [  199.230037]  [<ffffffff811c936c>] rcu_eqs_exit+0x9c/0xb0
> > [  199.230037]  [<ffffffff811c940c>] rcu_user_exit+0x8c/0xf0
> > [  199.230037]  [<ffffffff810a98bb>] do_page_fault+0x1b/0x40
> > [  199.230037]  [<ffffffff810a2a90>] do_async_page_fault+0x30/0xa0
> > [  199.230037]  [<ffffffff83a3eea8>] async_page_fault+0x28/0x30
> > [  199.230037]  [<ffffffff819f357b>] ? debug_object_activate+0x6b/0x1b0
> > [  199.230037]  [<ffffffff819f3586>] ? debug_object_activate+0x76/0x1b0
> > [  199.230037]  [<ffffffff8111af13>] ? lock_timer_base.isra.19+0x33/0x70
> > [  199.230037]  [<ffffffff8111d45f>] mod_timer_pinned+0x9f/0x260
> > [  199.230037]  [<ffffffff811c5ff4>] rcu_eqs_enter_common+0x894/0x970
> > [  199.230037]  [<ffffffff839dc2ac>] ? init_post+0x75/0xc8
> > [  199.230037]  [<ffffffff85abfed5>] ? kernel_init+0x1e1/0x1e1
> > [  199.230037]  [<ffffffff811c63df>] rcu_eqs_enter+0xaf/0xc0
> > [  199.230037]  [<ffffffff811c64c5>] rcu_user_enter+0xd5/0x140
> > [  199.230037]  [<ffffffff8107d0fd>] syscall_trace_leave+0xfd/0x150
> > [  199.230037]  [<ffffffff83a3f7af>] int_check_syscall_exit_work+0x34/0x3d
> > [  199.230037] ---[ end trace a582c3a264d5bd1a ]---
> 
> Ok, we can't decently protect against any kind of exception messing up everything
> in the middle of RCU APIs anyway. The only solution is to find out what cause this
> page fault in mod_timer_pinned() and work around that.
> 
> Anybody, an idea?

Wow...  So I pass mod_timer_pinned() the address of a per-CPU timer while
running on that CPU, with interrupts disabled, no less.  I initialize
this timer at CPU_UP_PREPARE time.  So why the page fault?

Please see below for a severe diagnostic patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Exploratory surgery, not for inclusion

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5faf05d..e062d13 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -328,7 +328,7 @@ struct rcu_data {
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 
-#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#define RCU_JIFFIES_TILL_FORCE_QS	 30	/* for rsp->jiffies_force_qs */
 
 #ifdef CONFIG_PROVE_RCU
 #define RCU_STALL_DELAY_DELTA	       (5 * HZ)
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f921154..80dfcec 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1742,7 +1742,6 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	struct timer_list *tp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 	int tne;
 
@@ -1772,8 +1771,6 @@ static void rcu_prepare_for_idle(int cpu)
 		} else {
 			return;
 		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
 		return;
 	}
 
@@ -1786,13 +1783,8 @@ static void rcu_prepare_for_idle(int cpu)
 	 * pending.
 	 */
 	if (!rdtp->idle_first_pass &&
-	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap)) {
-		if (rcu_cpu_has_callbacks(cpu)) {
-			tp = &rdtp->idle_gp_timer;
-			mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
-		}
+	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap))
 		return;
-	}
 	rdtp->idle_first_pass = 0;
 	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted - 1;
 
@@ -1836,8 +1828,6 @@ static void rcu_prepare_for_idle(int cpu)
 				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
 			trace_rcu_prep_idle("Dyntick with lazy callbacks");
 		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
 		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 		return; /* Nothing more to do immediately. */
 	} else if (--(rdtp->dyntick_drain) <= 0) {

