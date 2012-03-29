Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936760Ab2C3XB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:01:28 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934789Ab2C3VFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:17 -0400
Message-Id: <201203302104.q2UL4w63006261@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 13:39:51 -0400
Subject: [PATCH] arch/tile: optimize get_user/put_user and friends
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:58.0538 (UTC) FILETIME=[C3CD10A0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use direct load/store for the get_user/put_user.

Previously, we would call out to a helper routine that would do the
appropriate thing and then return, handling the possible exception
internally.  Now we inline the load or store, along with a "we succeeded"
indication in a register; if the load or store faults, we write a
"we failed" indication into the same register and then return to the
following instruction.  This is more efficient and gives us more compact
code, as well as being more in line with what other architectures do.

The special futex assembly source file for TILE-Gx also disappears in
this change; we just use the same inlining idiom there as well, putting
the appropriate atomic operations directly into futex_atomic_op_inuser()
(and thus into the FUTEX_WAIT function).

The underlying atomic copy_from_user, copy_to_user functions were
renamed using the (cryptic) x86 convention as copy_from_user_ll and
copy_to_user_ll.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/atomic_32.h |   10 ++
 arch/tile/include/asm/futex.h     |  143 ++++++++++++++++--------
 arch/tile/include/asm/uaccess.h   |  222 ++++++++++++++++++++++---------------
 arch/tile/kernel/Makefile         |    1 -
 arch/tile/lib/atomic_32.c         |   47 +--------
 arch/tile/lib/exports.c           |    8 --
 arch/tile/lib/usercopy_32.S       |   76 -------------
 arch/tile/lib/usercopy_64.S       |   49 --------
 8 files changed, 241 insertions(+), 315 deletions(-)

diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 004d6d9..d2a45e0 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -302,7 +302,14 @@ void __init_atomic_per_cpu(void);
 void __atomic_fault_unlock(int *lock_ptr);
 #endif
 
+/* Return a pointer to the lock for the given address. */
+int *__atomic_hashed_lock(volatile void *v);
+
 /* Private helper routines in lib/atomic_asm_32.S */
+struct __get_user {
+	unsigned long val;
+	int err;
+};
 extern struct __get_user __atomic_cmpxchg(volatile int *p,
 					  int *lock, int o, int n);
 extern struct __get_user __atomic_xchg(volatile int *p, int *lock, int n);
@@ -318,6 +325,9 @@ extern u64 __atomic64_xchg_add(volatile u64 *p, int *lock, u64 n);
 extern u64 __atomic64_xchg_add_unless(volatile u64 *p,
 				      int *lock, u64 o, u64 n);
 
+/* Return failure from the atomic wrappers. */
+struct __get_user __atomic_bad_address(int __user *addr);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_ATOMIC_32_H */
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index d03ec12..5909ac3 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -28,29 +28,81 @@
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <linux/errno.h>
+#include <asm/atomic.h>
 
-extern struct __get_user futex_set(u32 __user *v, int i);
-extern struct __get_user futex_add(u32 __user *v, int n);
-extern struct __get_user futex_or(u32 __user *v, int n);
-extern struct __get_user futex_andn(u32 __user *v, int n);
-extern struct __get_user futex_cmpxchg(u32 __user *v, int o, int n);
+/*
+ * Support macros for futex operations.  Do not use these macros directly.
+ * They assume "ret", "val", "oparg", and "uaddr" in the lexical context.
+ * __futex_cmpxchg() additionally assumes "oldval".
+ */
+
+#ifdef __tilegx__
+
+#define __futex_asm(OP) \
+	asm("1: {" #OP " %1, %3, %4; movei %0, 0 }\n"		\
+	    ".pushsection .fixup,\"ax\"\n"			\
+	    "0: { movei %0, %5; j 9f }\n"			\
+	    ".section __ex_table,\"a\"\n"			\
+	    ".quad 1b, 0b\n"					\
+	    ".popsection\n"					\
+	    "9:"						\
+	    : "=r" (ret), "=r" (val), "+m" (*(uaddr))		\
+	    : "r" (uaddr), "r" (oparg), "i" (-EFAULT))
+
+#define __futex_set() __futex_asm(exch4)
+#define __futex_add() __futex_asm(fetchadd4)
+#define __futex_or() __futex_asm(fetchor4)
+#define __futex_andn() ({ oparg = ~oparg; __futex_asm(fetchand4); })
+#define __futex_cmpxchg() \
+	({ __insn_mtspr(SPR_CMPEXCH_VALUE, oldval); __futex_asm(cmpexch4); })
+
+#define __futex_xor()						\
+	({							\
+		u32 oldval, n = oparg;				\
+		if ((ret = __get_user(oldval, uaddr)) == 0) {	\
+			do {					\
+				oparg = oldval ^ n;		\
+				__futex_cmpxchg();		\
+			} while (ret == 0 && oldval != val);	\
+		}						\
+	})
+
+/* No need to prefetch, since the atomic ops go to the home cache anyway. */
+#define __futex_prolog()
 
-#ifndef __tilegx__
-extern struct __get_user futex_xor(u32 __user *v, int n);
 #else
-static inline struct __get_user futex_xor(u32 __user *uaddr, int n)
-{
-	struct __get_user asm_ret = __get_user_4(uaddr);
-	if (!asm_ret.err) {
-		int oldval, newval;
-		do {
-			oldval = asm_ret.val;
-			newval = oldval ^ n;
-			asm_ret = futex_cmpxchg(uaddr, oldval, newval);
-		} while (asm_ret.err == 0 && oldval != asm_ret.val);
+
+#define __futex_call(FN)						\
+	{								\
+		struct __get_user gu = FN((u32 __force *)uaddr, lock, oparg); \
+		val = gu.val;						\
+		ret = gu.err;						\
 	}
-	return asm_ret;
-}
+
+#define __futex_set() __futex_call(__atomic_xchg)
+#define __futex_add() __futex_call(__atomic_xchg_add)
+#define __futex_or() __futex_call(__atomic_or)
+#define __futex_andn() __futex_call(__atomic_andn)
+#define __futex_xor() __futex_call(__atomic_xor)
+
+#define __futex_cmpxchg()						\
+	{								\
+		struct __get_user gu = __atomic_cmpxchg((u32 __force *)uaddr, \
+							lock, oldval, oparg); \
+		val = gu.val;						\
+		ret = gu.err;						\
+	}
+
+/*
+ * Find the lock pointer for the atomic calls to use, and issue a
+ * prefetch to the user address to bring it into cache.  Similar to
+ * __atomic_setup(), but we can't do a read into the L1 since it might
+ * fault; instead we do a prefetch into the L2.
+ */
+#define __futex_prolog()					\
+	int *lock;						\
+	__insn_prefetch(uaddr);					\
+	lock = __atomic_hashed_lock((int __force *)uaddr)
 #endif
 
 static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
@@ -59,8 +111,12 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	int cmp = (encoded_op >> 24) & 15;
 	int oparg = (encoded_op << 8) >> 20;
 	int cmparg = (encoded_op << 20) >> 20;
-	int ret;
-	struct __get_user asm_ret;
+	int uninitialized_var(val), ret;
+
+	__futex_prolog();
+
+	/* The 32-bit futex code makes this assumption, so validate it here. */
+	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(int));
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
@@ -71,46 +127,45 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	pagefault_disable();
 	switch (op) {
 	case FUTEX_OP_SET:
-		asm_ret = futex_set(uaddr, oparg);
+		__futex_set();
 		break;
 	case FUTEX_OP_ADD:
-		asm_ret = futex_add(uaddr, oparg);
+		__futex_add();
 		break;
 	case FUTEX_OP_OR:
-		asm_ret = futex_or(uaddr, oparg);
+		__futex_or();
 		break;
 	case FUTEX_OP_ANDN:
-		asm_ret = futex_andn(uaddr, oparg);
+		__futex_andn();
 		break;
 	case FUTEX_OP_XOR:
-		asm_ret = futex_xor(uaddr, oparg);
+		__futex_xor();
 		break;
 	default:
-		asm_ret.err = -ENOSYS;
+		ret = -ENOSYS;
+		break;
 	}
 	pagefault_enable();
 
-	ret = asm_ret.err;
-
 	if (!ret) {
 		switch (cmp) {
 		case FUTEX_OP_CMP_EQ:
-			ret = (asm_ret.val == cmparg);
+			ret = (val == cmparg);
 			break;
 		case FUTEX_OP_CMP_NE:
-			ret = (asm_ret.val != cmparg);
+			ret = (val != cmparg);
 			break;
 		case FUTEX_OP_CMP_LT:
-			ret = (asm_ret.val < cmparg);
+			ret = (val < cmparg);
 			break;
 		case FUTEX_OP_CMP_GE:
-			ret = (asm_ret.val >= cmparg);
+			ret = (val >= cmparg);
 			break;
 		case FUTEX_OP_CMP_LE:
-			ret = (asm_ret.val <= cmparg);
+			ret = (val <= cmparg);
 			break;
 		case FUTEX_OP_CMP_GT:
-			ret = (asm_ret.val > cmparg);
+			ret = (val > cmparg);
 			break;
 		default:
 			ret = -ENOSYS;
@@ -120,22 +175,20 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 }
 
 static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
-						u32 oldval, u32 newval)
+						u32 oldval, u32 oparg)
 {
-	struct __get_user asm_ret;
+	int ret, val;
+
+	__futex_prolog();
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	asm_ret = futex_cmpxchg(uaddr, oldval, newval);
-	*uval = asm_ret.val;
-	return asm_ret.err;
-}
+	__futex_cmpxchg();
 
-#ifndef __tilegx__
-/* Return failure from the atomic wrappers. */
-struct __get_user __atomic_bad_address(int __user *addr);
-#endif
+	*uval = val;
+	return ret;
+}
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index ef34d2c..c3dd275 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -114,45 +114,75 @@ struct exception_table_entry {
 extern int fixup_exception(struct pt_regs *regs);
 
 /*
- * We return the __get_user_N function results in a structure,
- * thus in r0 and r1.  If "err" is zero, "val" is the result
- * of the read; otherwise, "err" is -EFAULT.
- *
- * We rarely need 8-byte values on a 32-bit architecture, but
- * we size the structure to accommodate.  In practice, for the
- * the smaller reads, we can zero the high word for free, and
- * the caller will ignore it by virtue of casting anyway.
+ * Support macros for __get_user().
+ *
+ * Implementation note: The "case 8" logic of casting to the type of
+ * the result of subtracting the value from itself is basically a way
+ * of keeping all integer types the same, but casting any pointers to
+ * ptrdiff_t, i.e. also an integer type.  This way there are no
+ * questionable casts seen by the compiler on an ILP32 platform.
+ *
+ * Note that __get_user() and __put_user() assume proper alignment.
  */
-struct __get_user {
-	unsigned long long val;
-	int err;
-};
 
-/*
- * FIXME: we should express these as inline extended assembler, since
- * they're fundamentally just a variable dereference and some
- * supporting exception_table gunk.  Note that (a la i386) we can
- * extend the copy_to_user and copy_from_user routines to call into
- * such extended assembler routines, though we will have to use a
- * different return code in that case (1, 2, or 4, rather than -EFAULT).
- */
-extern struct __get_user __get_user_1(const void __user *);
-extern struct __get_user __get_user_2(const void __user *);
-extern struct __get_user __get_user_4(const void __user *);
-extern struct __get_user __get_user_8(const void __user *);
-extern int __put_user_1(long, void __user *);
-extern int __put_user_2(long, void __user *);
-extern int __put_user_4(long, void __user *);
-extern int __put_user_8(long long, void __user *);
-
-/* Unimplemented routines to cause linker failures */
-extern struct __get_user __get_user_bad(void);
-extern int __put_user_bad(void);
+#ifdef __LP64__
+#define _ASM_PTR	".quad"
+#else
+#define _ASM_PTR	".long"
+#endif
+
+#define __get_user_asm(OP, x, ptr, ret)					\
+	asm volatile("1: {" #OP " %1, %2; movei %0, 0 }\n"		\
+		     ".pushsection .fixup,\"ax\"\n"			\
+		     "0: { movei %1, 0; movei %0, %3 }\n"		\
+		     "j 9f\n"						\
+		     ".section __ex_table,\"a\"\n"			\
+		     _ASM_PTR " 1b, 0b\n"				\
+		     ".popsection\n"					\
+		     "9:"						\
+		     : "=r" (ret), "=r" (x)				\
+		     : "r" (ptr), "i" (-EFAULT))
+
+#ifdef __tilegx__
+#define __get_user_1(x, ptr, ret) __get_user_asm(ld1u, x, ptr, ret)
+#define __get_user_2(x, ptr, ret) __get_user_asm(ld2u, x, ptr, ret)
+#define __get_user_4(x, ptr, ret) __get_user_asm(ld4u, x, ptr, ret)
+#define __get_user_8(x, ptr, ret) __get_user_asm(ld, x, ptr, ret)
+#else
+#define __get_user_1(x, ptr, ret) __get_user_asm(lb_u, x, ptr, ret)
+#define __get_user_2(x, ptr, ret) __get_user_asm(lh_u, x, ptr, ret)
+#define __get_user_4(x, ptr, ret) __get_user_asm(lw, x, ptr, ret)
+#ifdef __LITTLE_ENDIAN
+#define __lo32(a, b) a
+#define __hi32(a, b) b
+#else
+#define __lo32(a, b) b
+#define __hi32(a, b) a
+#endif
+#define __get_user_8(x, ptr, ret)					\
+	({								\
+		unsigned int __a, __b;					\
+		asm volatile("1: { lw %1, %3; addi %2, %3, 4 }\n"	\
+			     "2: { lw %2, %2; movei %0, 0 }\n"		\
+			     ".pushsection .fixup,\"ax\"\n"		\
+			     "0: { movei %1, 0; movei %2, 0 }\n"	\
+			     "{ movei %0, %4; j 9f }\n"			\
+			     ".section __ex_table,\"a\"\n"		\
+			     ".word 1b, 0b\n"				\
+			     ".word 2b, 0b\n"				\
+			     ".popsection\n"				\
+			     "9:"					\
+			     : "=r" (ret), "=r" (__a), "=&r" (__b)	\
+			     : "r" (ptr), "i" (-EFAULT));		\
+		(x) = (__typeof(x))(__typeof((x)-(x)))			\
+			(((u64)__hi32(__a, __b) << 32) |		\
+			 __lo32(__a, __b));				\
+	})
+#endif
+
+extern int __get_user_bad(void)
+  __attribute__((warning("sizeof __get_user argument not 1, 2, 4 or 8")));
 
-/*
- * Careful: we have to cast the result to the type of the pointer
- * for sign reasons.
- */
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
@@ -174,30 +204,62 @@ extern int __put_user_bad(void);
  * function.
  */
 #define __get_user(x, ptr)						\
-({	struct __get_user __ret;					\
-	__typeof__(*(ptr)) const __user *__gu_addr = (ptr);		\
-	__chk_user_ptr(__gu_addr);					\
-	switch (sizeof(*(__gu_addr))) {					\
-	case 1:								\
-		__ret = __get_user_1(__gu_addr);			\
-		break;							\
-	case 2:								\
-		__ret = __get_user_2(__gu_addr);			\
-		break;							\
-	case 4:								\
-		__ret = __get_user_4(__gu_addr);			\
-		break;							\
-	case 8:								\
-		__ret = __get_user_8(__gu_addr);			\
-		break;							\
-	default:							\
-		__ret = __get_user_bad();				\
-		break;							\
-	}								\
-	(x) = (__typeof__(*__gu_addr)) (__typeof__(*__gu_addr - *__gu_addr)) \
-	  __ret.val;			                                \
-	__ret.err;							\
-})
+	({								\
+		int __ret;						\
+		__chk_user_ptr(ptr);					\
+		switch (sizeof(*(ptr))) {				\
+		case 1: __get_user_1(x, ptr, __ret); break;		\
+		case 2: __get_user_2(x, ptr, __ret); break;		\
+		case 4: __get_user_4(x, ptr, __ret); break;		\
+		case 8: __get_user_8(x, ptr, __ret); break;		\
+		default: __ret = __get_user_bad(); break;		\
+		}							\
+		__ret;							\
+	})
+
+/* Support macros for __put_user(). */
+
+#define __put_user_asm(OP, x, ptr, ret)			\
+	asm volatile("1: {" #OP " %1, %2; movei %0, 0 }\n"		\
+		     ".pushsection .fixup,\"ax\"\n"			\
+		     "0: { movei %0, %3; j 9f }\n"			\
+		     ".section __ex_table,\"a\"\n"			\
+		     _ASM_PTR " 1b, 0b\n"				\
+		     ".popsection\n"					\
+		     "9:"						\
+		     : "=r" (ret)					\
+		     : "r" (ptr), "r" (x), "i" (-EFAULT))
+
+#ifdef __tilegx__
+#define __put_user_1(x, ptr, ret) __put_user_asm(st1, x, ptr, ret)
+#define __put_user_2(x, ptr, ret) __put_user_asm(st2, x, ptr, ret)
+#define __put_user_4(x, ptr, ret) __put_user_asm(st4, x, ptr, ret)
+#define __put_user_8(x, ptr, ret) __put_user_asm(st, x, ptr, ret)
+#else
+#define __put_user_1(x, ptr, ret) __put_user_asm(sb, x, ptr, ret)
+#define __put_user_2(x, ptr, ret) __put_user_asm(sh, x, ptr, ret)
+#define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
+#define __put_user_8(x, ptr, ret)					\
+	({								\
+		u64 __x = (__typeof((x)-(x)))(x);			\
+		int __lo = (int) __x, __hi = (int) (__x >> 32);		\
+		asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"	\
+			     "2: { sw %0, %3; movei %0, 0 }\n"		\
+			     ".pushsection .fixup,\"ax\"\n"		\
+			     "0: { movei %0, %4; j 9f }\n"		\
+			     ".section __ex_table,\"a\"\n"		\
+			     ".word 1b, 0b\n"				\
+			     ".word 2b, 0b\n"				\
+			     ".popsection\n"				\
+			     "9:"					\
+			     : "=&r" (ret)				\
+			     : "r" (ptr), "r" (__lo32(__lo, __hi)),	\
+			     "r" (__hi32(__lo, __hi)), "i" (-EFAULT));	\
+	})
+#endif
+
+extern int __put_user_bad(void)
+  __attribute__((warning("sizeof __put_user argument not 1, 2, 4 or 8")));
 
 /**
  * __put_user: - Write a simple value into user space, with less checking.
@@ -217,39 +279,19 @@ extern int __put_user_bad(void);
  * function.
  *
  * Returns zero on success, or -EFAULT on error.
- *
- * Implementation note: The "case 8" logic of casting to the type of
- * the result of subtracting the value from itself is basically a way
- * of keeping all integer types the same, but casting any pointers to
- * ptrdiff_t, i.e. also an integer type.  This way there are no
- * questionable casts seen by the compiler on an ILP32 platform.
  */
 #define __put_user(x, ptr)						\
 ({									\
-	int __pu_err = 0;						\
-	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
-	typeof(*__pu_addr) __pu_val = (x);				\
-	__chk_user_ptr(__pu_addr);					\
-	switch (sizeof(__pu_val)) {					\
-	case 1:								\
-		__pu_err = __put_user_1((long)__pu_val, __pu_addr);	\
-		break;							\
-	case 2:								\
-		__pu_err = __put_user_2((long)__pu_val, __pu_addr);	\
-		break;							\
-	case 4:								\
-		__pu_err = __put_user_4((long)__pu_val, __pu_addr);	\
-		break;							\
-	case 8:								\
-		__pu_err =						\
-		  __put_user_8((__typeof__(__pu_val - __pu_val))__pu_val,\
-			__pu_addr);					\
-		break;							\
-	default:							\
-		__pu_err = __put_user_bad();				\
-		break;							\
+	int __ret;							\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1: __put_user_1(x, ptr, __ret); break;			\
+	case 2: __put_user_2(x, ptr, __ret); break;			\
+	case 4: __put_user_4(x, ptr, __ret); break;			\
+	case 8: __put_user_8(x, ptr, __ret); break;			\
+	default: __ret = __put_user_bad(); break;			\
 	}								\
-	__pu_err;							\
+	__ret;								\
 })
 
 /*
@@ -378,7 +420,7 @@ static inline unsigned long __must_check copy_from_user(void *to,
 /**
  * __copy_in_user() - copy data within user space, with less checking.
  * @to:   Destination address, in user space.
- * @from: Source address, in kernel space.
+ * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
  * Context: User context only.  This function may sleep.
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index b4dbc05..d6261e4 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -9,7 +9,6 @@ obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
 obj-$(CONFIG_HARDWALL)		+= hardwall.o
-obj-$(CONFIG_TILEGX)		+= futex_64.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_signal.o
 obj-$(CONFIG_SMP)		+= smpboot.o smp.o tlb.o
 obj-$(CONFIG_MODULES)		+= module.o
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index 771b251..f5cada7 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/atomic.h>
-#include <asm/futex.h>
 #include <arch/chip.h>
 
 /* See <asm/atomic_32.h> */
@@ -50,7 +49,7 @@ int atomic_locks[PAGE_SIZE / sizeof(int)] __page_aligned_bss;
 
 #endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 
-static inline int *__atomic_hashed_lock(volatile void *v)
+int *__atomic_hashed_lock(volatile void *v)
 {
 	/* NOTE: this code must match "sys_cmpxchg" in kernel/intvec_32.S */
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
@@ -191,47 +190,6 @@ u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
 EXPORT_SYMBOL(_atomic64_cmpxchg);
 
 
-static inline int *__futex_setup(int __user *v)
-{
-	/*
-	 * Issue a prefetch to the counter to bring it into cache.
-	 * As for __atomic_setup, but we can't do a read into the L1
-	 * since it might fault; instead we do a prefetch into the L2.
-	 */
-	__insn_prefetch(v);
-	return __atomic_hashed_lock((int __force *)v);
-}
-
-struct __get_user futex_set(u32 __user *v, int i)
-{
-	return __atomic_xchg((int __force *)v, __futex_setup(v), i);
-}
-
-struct __get_user futex_add(u32 __user *v, int n)
-{
-	return __atomic_xchg_add((int __force *)v, __futex_setup(v), n);
-}
-
-struct __get_user futex_or(u32 __user *v, int n)
-{
-	return __atomic_or((int __force *)v, __futex_setup(v), n);
-}
-
-struct __get_user futex_andn(u32 __user *v, int n)
-{
-	return __atomic_andn((int __force *)v, __futex_setup(v), n);
-}
-
-struct __get_user futex_xor(u32 __user *v, int n)
-{
-	return __atomic_xor((int __force *)v, __futex_setup(v), n);
-}
-
-struct __get_user futex_cmpxchg(u32 __user *v, int o, int n)
-{
-	return __atomic_cmpxchg((int __force *)v, __futex_setup(v), o, n);
-}
-
 /*
  * If any of the atomic or futex routines hit a bad address (not in
  * the page tables at kernel PL) this routine is called.  The futex
@@ -323,7 +281,4 @@ void __init __init_atomic_per_cpu(void)
 	BUILD_BUG_ON((PAGE_SIZE >> 3) > ATOMIC_HASH_SIZE);
 
 #endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
-
-	/* The futex code makes this assumption, so we validate it here. */
-	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(int));
 }
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 2a81d32..dd5f0a3 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -18,14 +18,6 @@
 
 /* arch/tile/lib/usercopy.S */
 #include <linux/uaccess.h>
-EXPORT_SYMBOL(__get_user_1);
-EXPORT_SYMBOL(__get_user_2);
-EXPORT_SYMBOL(__get_user_4);
-EXPORT_SYMBOL(__get_user_8);
-EXPORT_SYMBOL(__put_user_1);
-EXPORT_SYMBOL(__put_user_2);
-EXPORT_SYMBOL(__put_user_4);
-EXPORT_SYMBOL(__put_user_8);
 EXPORT_SYMBOL(strnlen_user_asm);
 EXPORT_SYMBOL(strncpy_from_user_asm);
 EXPORT_SYMBOL(clear_user_asm);
diff --git a/arch/tile/lib/usercopy_32.S b/arch/tile/lib/usercopy_32.S
index 979f76d..b62d002 100644
--- a/arch/tile/lib/usercopy_32.S
+++ b/arch/tile/lib/usercopy_32.S
@@ -19,82 +19,6 @@
 
 /* Access user memory, but use MMU to avoid propagating kernel exceptions. */
 
-	.pushsection .fixup,"ax"
-
-get_user_fault:
-	{ move r0, zero; move r1, zero }
-	{ movei r2, -EFAULT; jrp lr }
-	ENDPROC(get_user_fault)
-
-put_user_fault:
-	{ movei r0, -EFAULT; jrp lr }
-	ENDPROC(put_user_fault)
-
-	.popsection
-
-/*
- * __get_user_N functions take a pointer in r0, and return 0 in r2
- * on success, with the value in r0; or else -EFAULT in r2.
- */
-#define __get_user_N(bytes, LOAD) \
-	STD_ENTRY(__get_user_##bytes); \
-1:	{ LOAD r0, r0; move r1, zero; move r2, zero }; \
-	jrp lr; \
-	STD_ENDPROC(__get_user_##bytes); \
-	.pushsection __ex_table,"a"; \
-	.word 1b, get_user_fault; \
-	.popsection
-
-__get_user_N(1, lb_u)
-__get_user_N(2, lh_u)
-__get_user_N(4, lw)
-
-/*
- * __get_user_8 takes a pointer in r0, and returns 0 in r2
- * on success, with the value in r0/r1; or else -EFAULT in r2.
- */
-	STD_ENTRY(__get_user_8);
-1:	{ lw r0, r0; addi r1, r0, 4 };
-2:	{ lw r1, r1; move r2, zero };
-	jrp lr;
-	STD_ENDPROC(__get_user_8);
-	.pushsection __ex_table,"a";
-	.word 1b, get_user_fault;
-	.word 2b, get_user_fault;
-	.popsection
-
-/*
- * __put_user_N functions take a value in r0 and a pointer in r1,
- * and return 0 in r0 on success or -EFAULT on failure.
- */
-#define __put_user_N(bytes, STORE) \
-	STD_ENTRY(__put_user_##bytes); \
-1:	{ STORE r1, r0; move r0, zero }; \
-	jrp lr; \
-	STD_ENDPROC(__put_user_##bytes); \
-	.pushsection __ex_table,"a"; \
-	.word 1b, put_user_fault; \
-	.popsection
-
-__put_user_N(1, sb)
-__put_user_N(2, sh)
-__put_user_N(4, sw)
-
-/*
- * __put_user_8 takes a value in r0/r1 and a pointer in r2,
- * and returns 0 in r0 on success or -EFAULT on failure.
- */
-STD_ENTRY(__put_user_8)
-1:      { sw r2, r0; addi r2, r2, 4 }
-2:      { sw r2, r1; move r0, zero }
-	jrp lr
-	STD_ENDPROC(__put_user_8)
-	.pushsection __ex_table,"a"
-	.word 1b, put_user_fault
-	.word 2b, put_user_fault
-	.popsection
-
-
 /*
  * strnlen_user_asm takes the pointer in r0, and the length bound in r1.
  * It returns the length, including the terminating NUL, or zero on exception.
diff --git a/arch/tile/lib/usercopy_64.S b/arch/tile/lib/usercopy_64.S
index 2ff44f8..adb2dbb 100644
--- a/arch/tile/lib/usercopy_64.S
+++ b/arch/tile/lib/usercopy_64.S
@@ -19,55 +19,6 @@
 
 /* Access user memory, but use MMU to avoid propagating kernel exceptions. */
 
-	.pushsection .fixup,"ax"
-
-get_user_fault:
-	{ movei r1, -EFAULT; move r0, zero }
-	jrp lr
-	ENDPROC(get_user_fault)
-
-put_user_fault:
-	{ movei r0, -EFAULT; jrp lr }
-	ENDPROC(put_user_fault)
-
-	.popsection
-
-/*
- * __get_user_N functions take a pointer in r0, and return 0 in r1
- * on success, with the value in r0; or else -EFAULT in r1.
- */
-#define __get_user_N(bytes, LOAD) \
-	STD_ENTRY(__get_user_##bytes); \
-1:	{ LOAD r0, r0; move r1, zero }; \
-	jrp lr; \
-	STD_ENDPROC(__get_user_##bytes); \
-	.pushsection __ex_table,"a"; \
-	.quad 1b, get_user_fault; \
-	.popsection
-
-__get_user_N(1, ld1u)
-__get_user_N(2, ld2u)
-__get_user_N(4, ld4u)
-__get_user_N(8, ld)
-
-/*
- * __put_user_N functions take a value in r0 and a pointer in r1,
- * and return 0 in r0 on success or -EFAULT on failure.
- */
-#define __put_user_N(bytes, STORE) \
-	STD_ENTRY(__put_user_##bytes); \
-1:	{ STORE r1, r0; move r0, zero }; \
-	jrp lr; \
-	STD_ENDPROC(__put_user_##bytes); \
-	.pushsection __ex_table,"a"; \
-	.quad 1b, put_user_fault; \
-	.popsection
-
-__put_user_N(1, st1)
-__put_user_N(2, st2)
-__put_user_N(4, st4)
-__put_user_N(8, st)
-
 /*
  * strnlen_user_asm takes the pointer in r0, and the length bound in r1.
  * It returns the length, including the terminating NUL, or zero on exception.
-- 
1.6.5.2

