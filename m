Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2JaAa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:30:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2JaA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:29:45 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=x4JOzqezCnsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=eyxcYNHtip8A:10 a=VwQbUJbxAAAA:8 a=23Gay-bRqyLVN7q2eI0A:9 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121031002942.905526812@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Oct 2012 20:29:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter LaDow <petela@gocougs.wsu.edu>
Subject: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq sections on RT
References: <20121031002910.195421780@goodmis.org>
Content-Disposition: inline; filename=0003-net-netfilter-Serialize-xt_write_recseq-sections-on-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The netfilter code relies only on the implicit semantics of
local_bh_disable() for serializing wt_write_recseq sections. RT breaks
that and needs explicit serialization here.

Reported-by: Peter LaDow <petela@gocougs.wsu.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
---
 include/linux/locallock.h          |    4 ++++
 include/linux/netfilter/x_tables.h |    7 +++++++
 net/netfilter/core.c               |    6 ++++++
 3 files changed, 17 insertions(+)

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
index 8d674a7..3f2bc57 100644
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
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e1b7e05..151061b 100644
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
-- 
1.7.10.4


