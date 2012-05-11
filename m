Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2EKICC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:02:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:6295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2EKIB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:01:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139414117"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, tj@kernel.org,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        davem@davemloft.net
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, sfr@canb.auug.org.au,
        alex.shi@intel.com, luto@mit.edu, glommer@parallels.com,
        fernando@oss.ntt.co.jp, vapier@gentoo.org, eric.dumazet@gmail.com,
        dzickus@redhat.com, dhowells@redhat.com, cbouatmailru@gmail.com,
        fenghua.yu@intel.com, jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] percpu: remove percpu_xxx() functions
Date: Fri, 11 May 2012 16:00:15 +0800
Message-Id: <1336723215-16660-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
References: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove percpu_xxx serial functions, all of them were replaced by
this_cpu_xxx or __this_cpu_xxx serial functions

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/percpu.h |   16 ++++-------
 include/linux/percpu.h        |   54 -----------------------------------------
 2 files changed, 6 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 967ee3b..d9b8e3f 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -351,7 +351,7 @@ do {									\
 })
 
 /*
- * percpu_read() makes gcc load the percpu variable every time it is
+ * this_cpu_read() makes gcc load the percpu variable every time it is
  * accessed while this_cpu_read_stable() allows the value to be cached.
  * this_cpu_read_stable() is more efficient and can be used if its value
  * is guaranteed to be valid across cpus.  The current users include
@@ -359,15 +359,7 @@ do {									\
  * per-thread variables implemented as per-cpu variables and thus
  * stable for the duration of the respective task.
  */
-#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
 #define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
-#define percpu_write(var, val)		percpu_to_op("mov", var, val)
-#define percpu_add(var, val)		percpu_add_op(var, val)
-#define percpu_sub(var, val)		percpu_add_op(var, -(val))
-#define percpu_and(var, val)		percpu_to_op("and", var, val)
-#define percpu_or(var, val)		percpu_to_op("or", var, val)
-#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
-#define percpu_inc(var)		percpu_unary_op("inc", var)
 
 #define __this_cpu_read_1(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_read_2(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
@@ -512,7 +504,11 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
 {
 	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
 
-	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+#ifdef CONFIG_X86_64
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_8(*a)) != 0;
+#else
+	return ((1UL << (nr % BITS_PER_LONG)) & __this_cpu_read_4(*a)) != 0;
+#endif
 }
 
 static inline int x86_this_cpu_variable_test_bit(int nr,
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 21638ae..2b9f82c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -166,60 +166,6 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
 /*
- * Optional methods for optimized non-lvalue per-cpu variable access.
- *
- * @var can be a percpu variable or a field of it and its size should
- * equal char, int or long.  percpu_read() evaluates to a lvalue and
- * all others to void.
- *
- * These operations are guaranteed to be atomic.
- * The generic versions disable interrupts.  Archs are
- * encouraged to implement single-instruction alternatives which don't
- * require protection.
- */
-#ifndef percpu_read
-# define percpu_read(var)						\
-  ({									\
-	typeof(var) *pr_ptr__ = &(var);					\
-	typeof(var) pr_ret__;						\
-	pr_ret__ = get_cpu_var(*pr_ptr__);				\
-	put_cpu_var(*pr_ptr__);						\
-	pr_ret__;							\
-  })
-#endif
-
-#define __percpu_generic_to_op(var, val, op)				\
-do {									\
-	typeof(var) *pgto_ptr__ = &(var);				\
-	get_cpu_var(*pgto_ptr__) op val;				\
-	put_cpu_var(*pgto_ptr__);					\
-} while (0)
-
-#ifndef percpu_write
-# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
-#endif
-
-#ifndef percpu_add
-# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
-#endif
-
-#ifndef percpu_sub
-# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
-#endif
-
-#ifndef percpu_and
-# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
-#endif
-
-#ifndef percpu_or
-# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
-#endif
-
-#ifndef percpu_xor
-# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
-#endif
-
-/*
  * Branching function to split up a function into a set of functions that
  * are called for different scalar sizes of the objects handled.
  */
-- 
1.7.5.4

