Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295Ab2KCBx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:53:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2KCBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:53:26 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=1sJ11zoWL4i7RTlY1icA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351907604.4004.155.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.32-rt49
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 02 Nov 2012 21:53:24 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.32-rt49 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: cbced358ac79dfeea8ec0be224edb6087730b112


Or to build 3.2.32-rt49 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.32.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.32-rt49.patch.xz


You can also build from 3.2.32-rt48 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.32-rt48-rt49.patch.xz



Enjoy,

-- Steve


Changes from 3.2.32-rt48:

---

Steven Rostedt (1):
      Linux 3.2.32-rt49

Thomas Gleixner (2):
      rcu: Disable RCU_FAST_NO_HZ on RT
      net: netfilter: Serialize xt_write_recseq sections on RT

Watanabe (1):
      hrtimer: Raise softirq if hrtimer irq stalled

----
 include/linux/locallock.h          |    4 ++++
 include/linux/netfilter/x_tables.h |    7 +++++++
 init/Kconfig                       |    2 +-
 kernel/hrtimer.c                   |    9 ++++-----
 localversion-rt                    |    2 +-
 net/netfilter/core.c               |    6 ++++++
 6 files changed, 23 insertions(+), 7 deletions(-)
---------------------------
diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index f1804a3..a5eea5d 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -25,6 +25,9 @@ struct local_irq_lock {
 	DEFINE_PER_CPU(struct local_irq_lock, lvar) = {			\
 		.lock = __SPIN_LOCK_UNLOCKED((lvar).lock) }
 
+#define DECLARE_LOCAL_IRQ_LOCK(lvar)					\
+	DECLARE_PER_CPU(struct local_irq_lock, lvar)
+
 #define local_irq_lock_init(lvar)					\
 	do {								\
 		int __cpu;						\
@@ -220,6 +223,7 @@ static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 #else /* PREEMPT_RT_BASE */
 
 #define DEFINE_LOCAL_IRQ_LOCK(lvar)		__typeof__(const int) lvar
+#define DECLARE_LOCAL_IRQ_LOCK(lvar)		extern __typeof__(const int) lvar
 
 static inline void local_irq_lock_init(int lvar) { }
 
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 32cddf7..bed90da2 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -186,6 +186,7 @@ struct xt_counters_info {
 #ifdef __KERNEL__
 
 #include <linux/netdevice.h>
+#include <linux/locallock.h>
 
 /**
  * struct xt_action_param - parameters for matches/targets
@@ -466,6 +467,8 @@ extern void xt_free_table_info(struct xt_table_info *info);
  */
 DECLARE_PER_CPU(seqcount_t, xt_recseq);
 
+DECLARE_LOCAL_IRQ_LOCK(xt_write_lock);
+
 /**
  * xt_write_recseq_begin - start of a write section
  *
@@ -480,6 +483,9 @@ static inline unsigned int xt_write_recseq_begin(void)
 {
 	unsigned int addend;
 
+	/* RT protection */
+	local_lock(xt_write_lock);
+
 	/*
 	 * Low order bit of sequence is set if we already
 	 * called xt_write_recseq_begin().
@@ -510,6 +516,7 @@ static inline void xt_write_recseq_end(unsigned int addend)
 	/* this is kind of a write_seqcount_end(), but addend is 0 or 1 */
 	smp_wmb();
 	__this_cpu_add(xt_recseq.sequence, addend);
+	local_unlock(xt_write_lock);
 }
 
 /*
diff --git a/init/Kconfig b/init/Kconfig
index 720c182..aa6545f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -469,7 +469,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on TREE_RCU && NO_HZ && SMP
+	depends on TREE_RCU && NO_HZ && SMP && !PREEMPT_RT_FULL
 	default n
 	help
 	  This option causes RCU to attempt to accelerate grace periods
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bca6928..9c09d02 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1527,11 +1527,7 @@ retry:
 	if (expires_next.tv64 == KTIME_MAX ||
 	    !tick_program_event(expires_next, 0)) {
 		cpu_base->hang_detected = 0;
-
-		if (raise)
-			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-
-		return;
+		goto out;
 	}
 
 	/*
@@ -1575,6 +1571,9 @@ retry:
 	tick_program_event(expires_next, 1);
 	printk_once(KERN_WARNING "hrtimer: interrupt took %llu ns\n",
 		    ktime_to_ns(delta));
+out:
+	if (raise)
+		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
 }
 
 /*
diff --git a/localversion-rt b/localversion-rt
index 2470798..4b7dca6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt48
+-rt49
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index afca6c7..aa3f87b 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -20,11 +20,17 @@
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/locallock.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 
 #include "nf_internals.h"
 
+#ifdef CONFIG_PREEMPT_RT_BASE
+DEFINE_LOCAL_IRQ_LOCK(xt_write_lock);
+EXPORT_PER_CPU_SYMBOL(xt_write_lock);
+#endif
+
 static DEFINE_MUTEX(afinfo_mutex);
 
 const struct nf_afinfo __rcu *nf_afinfo[NFPROTO_NUMPROTO] __read_mostly;


