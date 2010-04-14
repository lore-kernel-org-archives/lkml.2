Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0DNBtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:49:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34880 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab0DNBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:49:33 -0400
Date: Tue, 13 Apr 2010 18:49:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Weird rcu lockdep warning
Message-ID: <20100414014930.GI2538@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100413200432.GB5099@nowhere>
 <20100413234043.GG2538@linux.vnet.ibm.com>
 <20100414000226.GH5602@nowhere>
 <20100413.171306.25868761.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413.171306.25868761.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 05:13:06PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Wed, 14 Apr 2010 02:02:27 +0200
> 
> > I just have a guess though....
> > This seems to always happen from NMI path, and lockdep is disabled on NMI.
> > I suspect the lock_acquire() performed by rcu_read_lock() is just ignored
> > and then the rcu_read_lock_held() check has the wrong result...
> 
> Yeah, I bet that's it too.
> 
> lock_is_held() can't return anything meaningful while lockdep is
> disabled, which it is during NMIs.

Ah!  So I just need to add a "current->lockdep_recursion"
check to debug_lockdep_rcu_enabled().  And move the function to
kernel/rcutree_plugin.h to avoid #include hell.

See below for (untested) patch.

						Thanx, Paul

------------------------------------------------------------------------

 include/linux/rcupdate.h |    5 +----
 kernel/rcutree_plugin.h  |   11 +++++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

commit 304d8da6cd791a81ce3164f867e1b3ef4f9af1d1
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Apr 13 18:45:51 2010 -0700

    rcu: Make RCU lockdep check the lockdep_recursion variable
    
    The lockdep facility temporarily disables lockdep checking by incrementing
    the current->lockdep_recursion variable.  Such disabling happens in NMIs
    and in other situations where lockdep might expect to recurse on itself.
    This patch therefore checks current->lockdep_recursion, disabling RCU
    lockdep splats when this variable is non-zero.
    
    Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
    Reported-by: David Miller <davem@davemloft.net>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9f1ddfe..07db2fe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -101,10 +101,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
-static inline int debug_lockdep_rcu_enabled(void)
-{
-	return likely(rcu_scheduler_active && debug_locks);
-}
+extern int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 79b53bd..2169abe 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1067,3 +1067,14 @@ static void rcu_needs_cpu_flush(void)
 }
 
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int debug_lockdep_rcu_enabled(void)
+{
+	return likely(rcu_scheduler_active &&
+		      debug_locks &&
+		      current->lockdep_recursion == 0);
+}
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
