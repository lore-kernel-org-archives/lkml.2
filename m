Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2AIREB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 12:04:01 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48345 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2AIRD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 12:03:59 -0500
Date: Mon, 9 Jan 2012 09:03:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [GIT PULL] percpu changes for v3.3-rc1
Message-ID: <20120109170353.GA7421@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains single patch from Christoph to remove
irqsafe variant of this_cpu operations.  Further cleanup will happen
in the next cycle.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.3

Pulling the branch will produce two conflicts in
arch/x86/include/asm/percpu.h against Jan's cebef5beed "x86: Fix and
improve percpu_cmpxchg{8,16}b_double()" which updates x86
implementation of cmpxchg ops.  The conflicts can be easily resolved
by removing irqsafe variants from cebef5beed.

For verfication, test merge is available in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git test-merge

Thank you.

Christoph Lameter (1):
      percpu: Remove irqsafe_cpu_xxx variants

 arch/s390/include/asm/percpu.h     |   44 ++++----
 arch/x86/include/asm/percpu.h      |   28 ------
 include/linux/netdevice.h          |    4 +-
 include/linux/netfilter/x_tables.h |    4 +-
 include/linux/percpu.h             |  190 ++++-------------------------------
 include/net/snmp.h                 |   14 ++--
 mm/slub.c                          |    6 +-
 net/caif/caif_dev.c                |    4 +-
 net/caif/cffrml.c                  |    4 +-
 9 files changed, 62 insertions(+), 236 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 5325c89..0fbd189 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -19,7 +19,7 @@
 #define ARCH_NEEDS_WEAK_PER_CPU
 #endif
 
-#define arch_irqsafe_cpu_to_op(pcp, val, op)				\
+#define arch_this_cpu_to_op(pcp, val, op)				\
 do {									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ old__, new__, prev__;				\
@@ -41,27 +41,27 @@ do {									\
 	preempt_enable();						\
 } while (0)
 
-#define irqsafe_cpu_add_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, +)
-#define irqsafe_cpu_add_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, +)
-#define irqsafe_cpu_add_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, +)
-#define irqsafe_cpu_add_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, +)
+#define this_cpu_add_1(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_2(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_4(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_8(pcp, val) arch_this_cpu_to_op(pcp, val, +)
 
-#define irqsafe_cpu_and_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
+#define this_cpu_and_1(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_2(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_4(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_8(pcp, val) arch_this_cpu_to_op(pcp, val, &)
 
-#define irqsafe_cpu_or_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
+#define this_cpu_or_1(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_2(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_4(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_8(pcp, val) arch_this_cpu_to_op(pcp, val, |)
 
-#define irqsafe_cpu_xor_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
+#define this_cpu_xor_1(pcp, val) arch_this_cpu_to_op(pcp, val, ^)
+#define this_cpu_xor_2(pcp, val) arch_this_cpu_to_op(pcp, val, ^)
+#define this_cpu_xor_4(pcp, val) arch_this_cpu_to_op(pcp, val, ^)
+#define this_cpu_xor_8(pcp, val) arch_this_cpu_to_op(pcp, val, ^)
 
-#define arch_irqsafe_cpu_cmpxchg(pcp, oval, nval)			\
+#define arch_this_cpu_cmpxchg(pcp, oval, nval)			\
 ({									\
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ ret__;						\
@@ -79,10 +79,10 @@ do {									\
 	ret__;								\
 })
 
-#define irqsafe_cpu_cmpxchg_1(pcp, oval, nval) arch_irqsafe_cpu_cmpxchg(pcp, oval, nval)
-#define irqsafe_cpu_cmpxchg_2(pcp, oval, nval) arch_irqsafe_cpu_cmpxchg(pcp, oval, nval)
-#define irqsafe_cpu_cmpxchg_4(pcp, oval, nval) arch_irqsafe_cpu_cmpxchg(pcp, oval, nval)
-#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval) arch_irqsafe_cpu_cmpxchg(pcp, oval, nval)
+#define this_cpu_cmpxchg_1(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
+#define this_cpu_cmpxchg_2(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
+#define this_cpu_cmpxchg_4(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
+#define this_cpu_cmpxchg_8(pcp, oval, nval) arch_this_cpu_cmpxchg(pcp, oval, nval)
 
 #include <asm-generic/percpu.h>
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3470c9d..562ccb5 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -414,22 +414,6 @@ do {									\
 #define this_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
 
-#define irqsafe_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
-#define irqsafe_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
-#define irqsafe_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
-#define irqsafe_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
-#define irqsafe_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
-#define irqsafe_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
-#define irqsafe_cpu_or_1(pcp, val)	percpu_to_op("or", (pcp), val)
-#define irqsafe_cpu_or_2(pcp, val)	percpu_to_op("or", (pcp), val)
-#define irqsafe_cpu_or_4(pcp, val)	percpu_to_op("or", (pcp), val)
-#define irqsafe_cpu_xor_1(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define irqsafe_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define irqsafe_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define irqsafe_cpu_xchg_1(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_2(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_xchg_4(pcp, nval)	percpu_xchg_op(pcp, nval)
-
 #ifndef CONFIG_M386
 #define __this_cpu_add_return_1(pcp, val) percpu_add_return_op(pcp, val)
 #define __this_cpu_add_return_2(pcp, val) percpu_add_return_op(pcp, val)
@@ -445,9 +429,6 @@ do {									\
 #define this_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #define this_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#define irqsafe_cpu_cmpxchg_1(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define irqsafe_cpu_cmpxchg_2(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-#define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 #endif /* !CONFIG_M386 */
 
 #ifdef CONFIG_X86_CMPXCHG64
@@ -467,7 +448,6 @@ do {									\
 
 #define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
 #define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg8b_double(pcp1, o1, o2, n1, n2)
 #endif /* CONFIG_X86_CMPXCHG64 */
 
 /*
@@ -495,13 +475,6 @@ do {									\
 #define this_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
 #define this_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
 
-#define irqsafe_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
-#define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
-#define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
-#define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
-#define irqsafe_cpu_xchg_8(pcp, nval)	percpu_xchg_op(pcp, nval)
-#define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	percpu_cmpxchg_op(pcp, oval, nval)
-
 /*
  * Pretty complex macro to generate cmpxchg16 instruction.  The instruction
  * is not supported on early AMD64 processors so we must be able to emulate
@@ -532,7 +505,6 @@ do {									\
 
 #define __this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
 #define this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
-#define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)	percpu_cmpxchg16b_double(pcp1, o1, o2, n1, n2)
 
 #endif
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a82ad4d..ca8d9bc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2115,7 +2115,7 @@ extern void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
-	irqsafe_cpu_dec(*dev->pcpu_refcnt);
+	this_cpu_dec(*dev->pcpu_refcnt);
 }
 
 /**
@@ -2126,7 +2126,7 @@ static inline void dev_put(struct net_device *dev)
  */
 static inline void dev_hold(struct net_device *dev)
 {
-	irqsafe_cpu_inc(*dev->pcpu_refcnt);
+	this_cpu_inc(*dev->pcpu_refcnt);
 }
 
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 32cddf7..8d674a7 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -471,7 +471,7 @@ DECLARE_PER_CPU(seqcount_t, xt_recseq);
  *
  * Begin packet processing : all readers must wait the end
  * 1) Must be called with preemption disabled
- * 2) softirqs must be disabled too (or we should use irqsafe_cpu_add())
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
  * Returns :
  *  1 if no recursion on this cpu
  *  0 if recursion detected
@@ -503,7 +503,7 @@ static inline unsigned int xt_write_recseq_begin(void)
  *
  * End packet processing : all readers can proceed
  * 1) Must be called with preemption disabled
- * 2) softirqs must be disabled too (or we should use irqsafe_cpu_add())
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
  */
 static inline void xt_write_recseq_end(unsigned int addend)
 {
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9ca008f..32cd1f6 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -172,10 +172,10 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
  * equal char, int or long.  percpu_read() evaluates to a lvalue and
  * all others to void.
  *
- * These operations are guaranteed to be atomic w.r.t. preemption.
- * The generic versions use plain get/put_cpu_var().  Archs are
+ * These operations are guaranteed to be atomic.
+ * The generic versions disable interrupts.  Archs are
  * encouraged to implement single-instruction alternatives which don't
- * require preemption protection.
+ * require protection.
  */
 #ifndef percpu_read
 # define percpu_read(var)						\
@@ -347,9 +347,10 @@ do {									\
 
 #define _this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
-	preempt_disable();						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
 	*__this_cpu_ptr(&(pcp)) op val;					\
-	preempt_enable();						\
+	local_irq_restore(flags);					\
 } while (0)
 
 #ifndef this_cpu_write
@@ -447,10 +448,11 @@ do {									\
 #define _this_cpu_generic_add_return(pcp, val)				\
 ({									\
 	typeof(pcp) ret__;						\
-	preempt_disable();						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
 	__this_cpu_add(pcp, val);					\
 	ret__ = __this_cpu_read(pcp);					\
-	preempt_enable();						\
+	local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -476,10 +478,11 @@ do {									\
 
 #define _this_cpu_generic_xchg(pcp, nval)				\
 ({	typeof(pcp) ret__;						\
-	preempt_disable();						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
 	ret__ = __this_cpu_read(pcp);					\
 	__this_cpu_write(pcp, nval);					\
-	preempt_enable();						\
+	local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -501,12 +504,14 @@ do {									\
 #endif
 
 #define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({	typeof(pcp) ret__;						\
-	preempt_disable();						\
+({									\
+	typeof(pcp) ret__;						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
 	ret__ = __this_cpu_read(pcp);					\
 	if (ret__ == (oval))						\
 		__this_cpu_write(pcp, nval);				\
-	preempt_enable();						\
+	local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -538,10 +543,11 @@ do {									\
 #define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 ({									\
 	int ret__;							\
-	preempt_disable();						\
+	unsigned long flags;						\
+	local_irq_save(flags);						\
 	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
 			oval1, oval2, nval1, nval2);			\
-	preempt_enable();						\
+	local_irq_restore(flags);					\
 	ret__;								\
 })
 
@@ -567,9 +573,9 @@ do {									\
 #endif
 
 /*
- * Generic percpu operations that do not require preemption handling.
+ * Generic percpu operations for context that are safe from preemption/interrupts.
  * Either we do not care about races or the caller has the
- * responsibility of handling preemptions issues. Arch code can still
+ * responsibility of handling preemption/interrupt issues. Arch code can still
  * override these instructions since the arch per cpu code may be more
  * efficient and may actually get race freeness for free (that is the
  * case for x86 for example).
@@ -802,156 +808,4 @@ do {									\
 	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
-/*
- * IRQ safe versions of the per cpu RMW operations. Note that these operations
- * are *not* safe against modification of the same variable from another
- * processors (which one gets when using regular atomic operations)
- * They are guaranteed to be atomic vs. local interrupts and
- * preemption only.
- */
-#define irqsafe_cpu_generic_to_op(pcp, val, op)				\
-do {									\
-	unsigned long flags;						\
-	local_irq_save(flags);						\
-	*__this_cpu_ptr(&(pcp)) op val;					\
-	local_irq_restore(flags);					\
-} while (0)
-
-#ifndef irqsafe_cpu_add
-# ifndef irqsafe_cpu_add_1
-#  define irqsafe_cpu_add_1(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef irqsafe_cpu_add_2
-#  define irqsafe_cpu_add_2(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef irqsafe_cpu_add_4
-#  define irqsafe_cpu_add_4(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef irqsafe_cpu_add_8
-#  define irqsafe_cpu_add_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# define irqsafe_cpu_add(pcp, val) __pcpu_size_call(irqsafe_cpu_add_, (pcp), (val))
-#endif
-
-#ifndef irqsafe_cpu_sub
-# define irqsafe_cpu_sub(pcp, val)	irqsafe_cpu_add((pcp), -(val))
-#endif
-
-#ifndef irqsafe_cpu_inc
-# define irqsafe_cpu_inc(pcp)	irqsafe_cpu_add((pcp), 1)
-#endif
-
-#ifndef irqsafe_cpu_dec
-# define irqsafe_cpu_dec(pcp)	irqsafe_cpu_sub((pcp), 1)
-#endif
-
-#ifndef irqsafe_cpu_and
-# ifndef irqsafe_cpu_and_1
-#  define irqsafe_cpu_and_1(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef irqsafe_cpu_and_2
-#  define irqsafe_cpu_and_2(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef irqsafe_cpu_and_4
-#  define irqsafe_cpu_and_4(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef irqsafe_cpu_and_8
-#  define irqsafe_cpu_and_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# define irqsafe_cpu_and(pcp, val) __pcpu_size_call(irqsafe_cpu_and_, (val))
-#endif
-
-#ifndef irqsafe_cpu_or
-# ifndef irqsafe_cpu_or_1
-#  define irqsafe_cpu_or_1(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef irqsafe_cpu_or_2
-#  define irqsafe_cpu_or_2(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef irqsafe_cpu_or_4
-#  define irqsafe_cpu_or_4(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef irqsafe_cpu_or_8
-#  define irqsafe_cpu_or_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# define irqsafe_cpu_or(pcp, val) __pcpu_size_call(irqsafe_cpu_or_, (val))
-#endif
-
-#ifndef irqsafe_cpu_xor
-# ifndef irqsafe_cpu_xor_1
-#  define irqsafe_cpu_xor_1(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef irqsafe_cpu_xor_2
-#  define irqsafe_cpu_xor_2(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef irqsafe_cpu_xor_4
-#  define irqsafe_cpu_xor_4(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# ifndef irqsafe_cpu_xor_8
-#  define irqsafe_cpu_xor_8(pcp, val) irqsafe_cpu_generic_to_op((pcp), (val), ^=)
-# endif
-# define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
-#endif
-
-#define irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	local_irq_save(flags);						\
-	ret__ = __this_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		__this_cpu_write(pcp, nval);				\
-	local_irq_restore(flags);					\
-	ret__;								\
-})
-
-#ifndef irqsafe_cpu_cmpxchg
-# ifndef irqsafe_cpu_cmpxchg_1
-#  define irqsafe_cpu_cmpxchg_1(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_2
-#  define irqsafe_cpu_cmpxchg_2(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_4
-#  define irqsafe_cpu_cmpxchg_4(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_8
-#  define irqsafe_cpu_cmpxchg_8(pcp, oval, nval)	irqsafe_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# define irqsafe_cpu_cmpxchg(pcp, oval, nval)		\
-	__pcpu_size_call_return2(irqsafe_cpu_cmpxchg_, (pcp), oval, nval)
-#endif
-
-#define irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-({									\
-	int ret__;							\
-	unsigned long flags;						\
-	local_irq_save(flags);						\
-	ret__ = __this_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
-			oval1, oval2, nval1, nval2);			\
-	local_irq_restore(flags);					\
-	ret__;								\
-})
-
-#ifndef irqsafe_cpu_cmpxchg_double
-# ifndef irqsafe_cpu_cmpxchg_double_1
-#  define irqsafe_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_double_2
-#  define irqsafe_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_double_4
-#  define irqsafe_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef irqsafe_cpu_cmpxchg_double_8
-#  define irqsafe_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	irqsafe_generic_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# define irqsafe_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(irqsafe_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
-#endif
-
 #endif /* __LINUX_PERCPU_H */
diff --git a/include/net/snmp.h b/include/net/snmp.h
index 8f0f9ac..e067aed 100644
--- a/include/net/snmp.h
+++ b/include/net/snmp.h
@@ -129,33 +129,33 @@ struct linux_xfrm_mib {
 			__this_cpu_inc(mib[0]->mibs[field])
 
 #define SNMP_INC_STATS_USER(mib, field)	\
-			irqsafe_cpu_inc(mib[0]->mibs[field])
+			this_cpu_inc(mib[0]->mibs[field])
 
 #define SNMP_INC_STATS_ATOMIC_LONG(mib, field)	\
 			atomic_long_inc(&mib->mibs[field])
 
 #define SNMP_INC_STATS(mib, field)	\
-			irqsafe_cpu_inc(mib[0]->mibs[field])
+			this_cpu_inc(mib[0]->mibs[field])
 
 #define SNMP_DEC_STATS(mib, field)	\
-			irqsafe_cpu_dec(mib[0]->mibs[field])
+			this_cpu_dec(mib[0]->mibs[field])
 
 #define SNMP_ADD_STATS_BH(mib, field, addend)	\
 			__this_cpu_add(mib[0]->mibs[field], addend)
 
 #define SNMP_ADD_STATS_USER(mib, field, addend)	\
-			irqsafe_cpu_add(mib[0]->mibs[field], addend)
+			this_cpu_add(mib[0]->mibs[field], addend)
 
 #define SNMP_ADD_STATS(mib, field, addend)	\
-			irqsafe_cpu_add(mib[0]->mibs[field], addend)
+			this_cpu_add(mib[0]->mibs[field], addend)
 /*
  * Use "__typeof__(*mib[0]) *ptr" instead of "__typeof__(mib[0]) ptr"
  * to make @ptr a non-percpu pointer.
  */
 #define SNMP_UPD_PO_STATS(mib, basefield, addend)	\
 	do { \
-		irqsafe_cpu_inc(mib[0]->mibs[basefield##PKTS]);		\
-		irqsafe_cpu_add(mib[0]->mibs[basefield##OCTETS], addend);	\
+		this_cpu_inc(mib[0]->mibs[basefield##PKTS]);		\
+		this_cpu_add(mib[0]->mibs[basefield##OCTETS], addend);	\
 	} while (0)
 #define SNMP_UPD_PO_STATS_BH(mib, basefield, addend)	\
 	do { \
diff --git a/mm/slub.c b/mm/slub.c
index ed3334d..0011489 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1978,7 +1978,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 		page->pobjects = pobjects;
 		page->next = oldpage;
 
-	} while (irqsafe_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
+	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
 	stat(s, CPU_PARTIAL_FREE);
 	return pobjects;
 }
@@ -2304,7 +2304,7 @@ redo:
 		 * Since this is without lock semantics the protection is only against
 		 * code executing on this cpu *not* from access by other cpus.
 		 */
-		if (unlikely(!irqsafe_cpu_cmpxchg_double(
+		if (unlikely(!this_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				object, tid,
 				get_freepointer_safe(s, object), next_tid(tid)))) {
@@ -2534,7 +2534,7 @@ redo:
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
 
-		if (unlikely(!irqsafe_cpu_cmpxchg_double(
+		if (unlikely(!this_cpu_cmpxchg_double(
 				s->cpu_slab->freelist, s->cpu_slab->tid,
 				c->freelist, tid,
 				object, next_tid(tid)))) {
diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index f1fa1f6..64930cc 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -69,12 +69,12 @@ static struct caif_device_entry_list *caif_device_list(struct net *net)
 
 static void caifd_put(struct caif_device_entry *e)
 {
-	irqsafe_cpu_dec(*e->pcpu_refcnt);
+	this_cpu_dec(*e->pcpu_refcnt);
 }
 
 static void caifd_hold(struct caif_device_entry *e)
 {
-	irqsafe_cpu_inc(*e->pcpu_refcnt);
+	this_cpu_inc(*e->pcpu_refcnt);
 }
 
 static int caifd_refcnt_read(struct caif_device_entry *e)
diff --git a/net/caif/cffrml.c b/net/caif/cffrml.c
index d3ca87b..0a7df7e 100644
--- a/net/caif/cffrml.c
+++ b/net/caif/cffrml.c
@@ -177,14 +177,14 @@ void cffrml_put(struct cflayer *layr)
 {
 	struct cffrml *this = container_obj(layr);
 	if (layr != NULL && this->pcpu_refcnt != NULL)
-		irqsafe_cpu_dec(*this->pcpu_refcnt);
+		this_cpu_dec(*this->pcpu_refcnt);
 }
 
 void cffrml_hold(struct cflayer *layr)
 {
 	struct cffrml *this = container_obj(layr);
 	if (layr != NULL && this->pcpu_refcnt != NULL)
-		irqsafe_cpu_inc(*this->pcpu_refcnt);
+		this_cpu_inc(*this->pcpu_refcnt);
 }
 
 int cffrml_refcnt_read(struct cflayer *layr)
