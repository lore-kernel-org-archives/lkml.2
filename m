Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1LVR67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:58:59 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20275 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753080Ab1LVR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:58:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wUnCeo8VM1kDAFzWlV_s1MpSFt3BbN_z8592rQGpWBmLEor
 hlo68AyzKhBRk46Tb7jrVURV6_sIX8vgfrIRoCzRHdTWmpqNurXjOq7qQ91i
 a45Q8iZT79mXYdZbewi4YeBGdC2kH6z2ytZoZWMXM.mP8N_9FcEK8cvtDOlY
 Tmi_wlbsHTFXSSElBzNERE2puy5HKrAoVYDra51wxFtlV_PUNErU2U.2ie7a
 SJIzIkPB4Do6vMCS1WFcZJ66Yy_zDGk61xERJ0r5lRNl18M3J4S0qHFKwzlO
 2ITMZamXfZdDXMqY8qBEK7_tk07jrAPIOXOzIIrc4xeOrIb.L17HWKAKr5eZ
 lktDYY2llUwZViiu81CRtNPiSog7rEjCr_AvUr7IWCRxx6DG09GddOesoTMi
 ouQfAhsQnMFDmOAc2thtuew--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Dec 2011 11:58:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <20111222160822.GE17084@google.com>
Message-ID: <alpine.DEB.2.00.1112221154380.11787@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com> <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home> <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, Tejun Heo wrote:

> Yeap, and that one too.  Maybe we can finally kill the duplicate
> confusing static/dynamic accessors too.  I'm planning to get to it in
> several weeks but if anyone can beat me to it, please go ahead.

That would be great. I looked at _and and _or and they both still have one
use case (_xor has none though). But its easy to get rid of the irqsafe
variants once we are willing to take the additional overhead that comes
with disabling interrupts for the fallback cases.


Subject: [percpu] Remove irqsafe_cpu_xxx variants

We simply say that regular this_cpu use must be safe regardless of preemption
and interrupt state. That has no material change for x86 and s390 implementations
of this_cpu operations. However, arches that do not provide their own implementation
for this_cpu operations will now get code generated that disables interrupts
instead of preemption.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/s390/include/asm/percpu.h     |   50 ++++-----
 arch/x86/include/asm/percpu.h      |   28 -----
 include/linux/netdevice.h          |    4
 include/linux/netfilter/x_tables.h |    4
 include/linux/percpu.h             |  190 ++++---------------------------------
 include/net/snmp.h                 |   14 +-
 mm/slub.c                          |    6 -
 net/caif/caif_dev.c                |    4
 net/caif/cffrml.c                  |    4
 9 files changed, 65 insertions(+), 239 deletions(-)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2011-12-22 11:48:28.000000000 -0600
@@ -172,10 +172,10 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
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
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-12-22 11:48:28.000000000 -0600
@@ -1978,7 +1978,7 @@ int put_cpu_partial(struct kmem_cache *s
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
Index: linux-2.6/net/caif/caif_dev.c
===================================================================
--- linux-2.6.orig/net/caif/caif_dev.c	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/net/caif/caif_dev.c	2011-12-22 11:48:28.000000000 -0600
@@ -69,12 +69,12 @@ static struct caif_device_entry_list *ca

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
Index: linux-2.6/net/caif/cffrml.c
===================================================================
--- linux-2.6.orig/net/caif/cffrml.c	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/net/caif/cffrml.c	2011-12-22 11:48:28.000000000 -0600
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
Index: linux-2.6/include/linux/netdevice.h
===================================================================
--- linux-2.6.orig/include/linux/netdevice.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/include/linux/netdevice.h	2011-12-22 11:48:28.000000000 -0600
@@ -2115,7 +2115,7 @@ extern void netdev_run_todo(void);
  */
 static inline void dev_put(struct net_device *dev)
 {
-	irqsafe_cpu_dec(*dev->pcpu_refcnt);
+	this_cpu_dec(*dev->pcpu_refcnt);
 }

 /**
@@ -2126,7 +2126,7 @@ static inline void dev_put(struct net_de
  */
 static inline void dev_hold(struct net_device *dev)
 {
-	irqsafe_cpu_inc(*dev->pcpu_refcnt);
+	this_cpu_inc(*dev->pcpu_refcnt);
 }

 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
Index: linux-2.6/include/linux/netfilter/x_tables.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter/x_tables.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/include/linux/netfilter/x_tables.h	2011-12-22 11:48:28.000000000 -0600
@@ -471,7 +471,7 @@ DECLARE_PER_CPU(seqcount_t, xt_recseq);
  *
  * Begin packet processing : all readers must wait the end
  * 1) Must be called with preemption disabled
- * 2) softirqs must be disabled too (or we should use irqsafe_cpu_add())
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
  * Returns :
  *  1 if no recursion on this cpu
  *  0 if recursion detected
@@ -503,7 +503,7 @@ static inline unsigned int xt_write_recs
  *
  * End packet processing : all readers can proceed
  * 1) Must be called with preemption disabled
- * 2) softirqs must be disabled too (or we should use irqsafe_cpu_add())
+ * 2) softirqs must be disabled too (or we should use this_cpu_add())
  */
 static inline void xt_write_recseq_end(unsigned int addend)
 {
Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/include/net/snmp.h	2011-12-22 11:48:28.000000000 -0600
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
Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-12-22 11:48:28.000000000 -0600
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

Index: linux-2.6/arch/s390/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/percpu.h	2011-12-22 11:48:21.000000000 -0600
+++ linux-2.6/arch/s390/include/asm/percpu.h	2011-12-22 11:50:22.000000000 -0600
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
-
-#define irqsafe_cpu_and_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-#define irqsafe_cpu_and_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, &)
-
-#define irqsafe_cpu_or_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-#define irqsafe_cpu_or_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, |)
-
-#define irqsafe_cpu_xor_1(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_2(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_4(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
-#define irqsafe_cpu_xor_8(pcp, val) arch_irqsafe_cpu_to_op(pcp, val, ^)
+#define this_cpu_add_1(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_2(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_4(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+#define this_cpu_add_8(pcp, val) arch_this_cpu_to_op(pcp, val, +)
+
+#define this_cpu_and_1(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_2(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_4(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+#define this_cpu_and_8(pcp, val) arch_this_cpu_to_op(pcp, val, &)
+
+#define this_cpu_or_1(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_2(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_4(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+#define this_cpu_or_8(pcp, val) arch_this_cpu_to_op(pcp, val, |)
+
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

