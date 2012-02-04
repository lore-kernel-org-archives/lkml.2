Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2BDBtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 20:49:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57162 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2BDBqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 20:46:32 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 42/47] rcu: Convert WARN_ON_ONCE() in rcu_lock_acquire() to lockdep
Date: Fri,  3 Feb 2012 17:45:17 -0800
Message-Id: <1328319922-30828-42-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020401-2398-0000-0000-000003ED6AA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The WARN_ON_ONCE() in rcu_lock_acquire() results in infinite recursion
on S390, and also doesn't print very much information.  Remove this.

Updated patch to add lockdep-RCU assertions to RCU's read-side primitives.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 ++++++++++++--
 include/linux/srcu.h     |    4 ++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 146d37d..6ee663c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -248,13 +248,11 @@ static inline int rcu_is_cpu_idle(void)
 
 static inline void rcu_lock_acquire(struct lockdep_map *map)
 {
-	WARN_ON_ONCE(rcu_is_cpu_idle());
 	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
 }
 
 static inline void rcu_lock_release(struct lockdep_map *map)
 {
-	WARN_ON_ONCE(rcu_is_cpu_idle());
 	lock_release(map, 1, _THIS_IP_);
 }
 
@@ -699,6 +697,8 @@ static inline void rcu_read_lock(void)
 	__rcu_read_lock();
 	__acquire(RCU);
 	rcu_lock_acquire(&rcu_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock() used illegally while idle");
 }
 
 /*
@@ -718,6 +718,8 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
@@ -745,6 +747,8 @@ static inline void rcu_read_lock_bh(void)
 	local_bh_disable();
 	__acquire(RCU_BH);
 	rcu_lock_acquire(&rcu_bh_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock_bh() used illegally while idle");
 }
 
 /*
@@ -754,6 +758,8 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock_bh() used illegally while idle");
 	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	local_bh_enable();
@@ -777,6 +783,8 @@ static inline void rcu_read_lock_sched(void)
 	preempt_disable();
 	__acquire(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_lock_sched() used illegally while idle");
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -793,6 +801,8 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9a32372..d3d5fa5 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -172,6 +172,8 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 	int retval = __srcu_read_lock(sp);
 
 	rcu_lock_acquire(&(sp)->dep_map);
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "srcu_read_lock() used illegally while idle");
 	return retval;
 }
 
@@ -185,6 +187,8 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
+	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+			   "srcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
-- 
1.7.8

