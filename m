Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1FXDx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 23:53:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33363 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab1FXDxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 23:53:25 -0400
Date: Thu, 23 Jun 2011 20:53:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
Message-ID: <20110624035311.GB2266@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 01:12:37AM +0200, Frederic Weisbecker wrote:
> This time I have no current practical cases to fix. Those I fixed
> in previous versions were actually using rcu_dereference_raw(), which
> is legal in extended qs.
> 
> Frederic Weisbecker (3):
>   rcu: Detect illegal rcu dereference in extended quiescent state
>   rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
>   rcu: Warn when rcu_read_lock() is used in extended quiescent state
> 
>  include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
>  kernel/lockdep.c         |    4 +++
>  kernel/rcupdate.c        |    4 +++
>  kernel/rcutiny.c         |   13 +++++++++
>  kernel/rcutree.c         |   14 +++++++++
>  5 files changed, 93 insertions(+), 10 deletions(-)

Queued, thank you, Frederic!

I have also applied your approach to SRCU, and I applied the following
to simplify the code a bit -- please let me know if there are any
problems with this approach.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Remove one layer of abstraction from PROVE_RCU checking

Simplify things a bit by substituting the definitions of the single-line
rcu_read_acquire(), rcu_read_release(), rcu_read_acquire_bh(),
rcu_read_release_bh(), rcu_read_acquire_sched(), and
rcu_read_release_sched() functions at their call points.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 16717c3..7b0cdf4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -264,41 +264,8 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 }
 
 extern struct lockdep_map rcu_lock_map;
-
-static inline void rcu_read_acquire(void)
-{
-	rcu_lock_acquire(&rcu_lock_map);
-}
-
-static inline void rcu_read_release(void)
-{
-	rcu_lock_release(&rcu_lock_map);
-}
-
 extern struct lockdep_map rcu_bh_lock_map;
-
-static inline void rcu_read_acquire_bh(void)
-{
-	rcu_lock_acquire(&rcu_bh_lock_map);
-}
-
-static inline void rcu_read_release_bh(void)
-{
-	rcu_lock_release(&rcu_bh_lock_map);
-}
-
 extern struct lockdep_map rcu_sched_lock_map;
-
-static inline void rcu_read_acquire_sched(void)
-{
-	rcu_lock_acquire(&rcu_sched_lock_map);
-}
-
-static inline void rcu_read_release_sched(void)
-{
-	rcu_lock_release(&rcu_sched_lock_map);
-}
-
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
@@ -369,12 +336,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-# define rcu_read_acquire()		do { } while (0)
-# define rcu_read_release()		do { } while (0)
-# define rcu_read_acquire_bh()		do { } while (0)
-# define rcu_read_release_bh()		do { } while (0)
-# define rcu_read_acquire_sched()	do { } while (0)
-# define rcu_read_release_sched()	do { } while (0)
+# define rcu_lock_acquire(a)		do { } while (0)
+# define rcu_lock_release(a)		do { } while (0)
 
 static inline int rcu_read_lock_held(void)
 {
@@ -717,7 +680,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_read_acquire();
+	rcu_lock_acquire(&rcu_lock_map);
 }
 
 /*
@@ -737,7 +700,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_read_release();
+	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -758,7 +721,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	__rcu_read_lock_bh();
 	__acquire(RCU_BH);
-	rcu_read_acquire_bh();
+	rcu_lock_acquire(&rcu_bh_lock_map);
 }
 
 /*
@@ -768,7 +731,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release_bh();
+	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	__rcu_read_unlock_bh();
 }
@@ -785,7 +748,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire_sched();
+	rcu_lock_acquire(&rcu_sched_lock_map);
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -802,7 +765,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release_sched();
+	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
 }
