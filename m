Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab1COTfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:35:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab1COTfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:35:45 -0400
Date: Tue, 15 Mar 2011 20:35:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/futexes changes for v2.6.39
Message-ID: <20110315193528.GA30300@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-futexes-for-linus

 Thanks,

	Ingo

------------------>
Lai Jiangshan (4):
      futex,plist: Pass the real head of the priority list to plist_del()
      futex,plist: Remove debug lock assignment from plist_node
      plist: Shrink struct plist_head
      plist: Add priority list test

Michel Lespinasse (4):
      futex: Update futex_wait_setup comments about locking
      futex: Remove redundant pagefault_disable in futex_atomic_cmpxchg_inatomic()
      futex: Sanitize cmpxchg_futex_value_locked API
      futex: Sanitize futex ops argument types

Thomas Gleixner (3):
      futex: Avoid redudant evaluation of task_pid_vnr()
      futex: Deobfuscate handle_futex_death()
      arm: Remove bogus comment in futex_atomic_cmpxchg_inatomic()


 arch/alpha/include/asm/futex.h      |   29 ++++----
 arch/arm/include/asm/futex.h        |   29 ++++----
 arch/frv/include/asm/futex.h        |    5 +-
 arch/frv/kernel/futex.c             |   14 ++--
 arch/ia64/include/asm/futex.h       |   15 +++--
 arch/microblaze/include/asm/futex.h |   31 +++++----
 arch/mips/include/asm/futex.h       |   39 ++++++-----
 arch/parisc/include/asm/futex.h     |   24 +++---
 arch/powerpc/include/asm/futex.h    |   27 ++++---
 arch/s390/include/asm/futex.h       |   12 ++--
 arch/s390/include/asm/uaccess.h     |    4 +-
 arch/s390/lib/uaccess.h             |    8 +-
 arch/s390/lib/uaccess_pt.c          |   17 +++--
 arch/s390/lib/uaccess_std.c         |    8 ++-
 arch/sh/include/asm/futex-irq.h     |   24 +++---
 arch/sh/include/asm/futex.h         |   11 ++--
 arch/sparc/include/asm/futex_64.h   |   20 +++--
 arch/tile/include/asm/futex.h       |   27 ++++----
 arch/x86/include/asm/futex.h        |   22 +++---
 include/asm-generic/futex.h         |    7 +-
 include/linux/plist.h               |   47 ++++++------
 kernel/futex.c                      |  125 ++++++++++++++++----------------
 lib/plist.c                         |  135 +++++++++++++++++++++++++++++-----
 23 files changed, 404 insertions(+), 276 deletions(-)

diff --git a/arch/alpha/include/asm/futex.h b/arch/alpha/include/asm/futex.h
index 945de22..e8a761a 100644
--- a/arch/alpha/include/asm/futex.h
+++ b/arch/alpha/include/asm/futex.h
@@ -29,7 +29,7 @@
 	:	"r" (uaddr), "r"(oparg)				\
 	:	"memory")
 
-static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -39,7 +39,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -81,21 +81,23 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int prev, cmp;
+	int ret = 0, cmp;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	__asm__ __volatile__ (
 		__ASM_SMP_MB
-	"1:	ldl_l	%0,0(%2)\n"
-	"	cmpeq	%0,%3,%1\n"
-	"	beq	%1,3f\n"
-	"	mov	%4,%1\n"
-	"2:	stl_c	%1,0(%2)\n"
-	"	beq	%1,4f\n"
+	"1:	ldl_l	%1,0(%3)\n"
+	"	cmpeq	%1,%4,%2\n"
+	"	beq	%2,3f\n"
+	"	mov	%5,%2\n"
+	"2:	stl_c	%2,0(%3)\n"
+	"	beq	%2,4f\n"
 	"3:	.subsection 2\n"
 	"4:	br	1b\n"
 	"	.previous\n"
@@ -105,11 +107,12 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	"	.long	2b-.\n"
 	"	lda	$31,3b-2b(%0)\n"
 	"	.previous\n"
-	:	"=&r"(prev), "=&r"(cmp)
+	:	"+r"(ret), "=&r"(prev), "=&r"(cmp)
 	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
 	:	"memory");
 
-	return prev;
+	*uval = prev;
+	return ret;
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index b33fe70..199a6b6 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -35,7 +35,7 @@
 	: "cc", "memory")
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -46,7 +46,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();	/* implies preempt_disable() */
@@ -88,36 +88,35 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int val;
+	int ret = 0;
+	u32 val;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	pagefault_disable();	/* implies preempt_disable() */
-
 	__asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
-	"1:	" T(ldr) "	%0, [%3]\n"
-	"	teq	%0, %1\n"
+	"1:	" T(ldr) "	%1, [%4]\n"
+	"	teq	%1, %2\n"
 	"	it	eq	@ explicit IT needed for the 2b label\n"
-	"2:	" T(streq) "	%2, [%3]\n"
+	"2:	" T(streq) "	%3, [%4]\n"
 	"3:\n"
 	"	.pushsection __ex_table,\"a\"\n"
 	"	.align	3\n"
 	"	.long	1b, 4f, 2b, 4f\n"
 	"	.popsection\n"
 	"	.pushsection .fixup,\"ax\"\n"
-	"4:	mov	%0, %4\n"
+	"4:	mov	%0, %5\n"
 	"	b	3b\n"
 	"	.popsection"
-	: "=&r" (val)
+	: "+r" (ret), "=&r" (val)
 	: "r" (oldval), "r" (newval), "r" (uaddr), "Ir" (-EFAULT)
 	: "cc", "memory");
 
-	pagefault_enable();	/* subsumes preempt_enable() */
-
-	return val;
+	*uval = val;
+	return ret;
 }
 
 #endif /* !SMP */
diff --git a/arch/frv/include/asm/futex.h b/arch/frv/include/asm/futex.h
index 08b3d1d..4bea27f 100644
--- a/arch/frv/include/asm/futex.h
+++ b/arch/frv/include/asm/futex.h
@@ -7,10 +7,11 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
+extern int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr);
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
 	return -ENOSYS;
 }
diff --git a/arch/frv/kernel/futex.c b/arch/frv/kernel/futex.c
index 14f64b0..d155ca9 100644
--- a/arch/frv/kernel/futex.c
+++ b/arch/frv/kernel/futex.c
@@ -18,7 +18,7 @@
  * the various futex operations; MMU fault checking is ignored under no-MMU
  * conditions
  */
-static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr, int *_oldval)
+static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr, int *_oldval)
 {
 	int oldval, ret;
 
@@ -50,7 +50,7 @@ static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr, int *_o
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr, int *_oldval)
+static inline int atomic_futex_op_xchg_add(int oparg, u32 __user *uaddr, int *_oldval)
 {
 	int oldval, ret;
 
@@ -83,7 +83,7 @@ static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr, int *_o
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr, int *_oldval)
+static inline int atomic_futex_op_xchg_or(int oparg, u32 __user *uaddr, int *_oldval)
 {
 	int oldval, ret;
 
@@ -116,7 +116,7 @@ static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr, int *_ol
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr, int *_oldval)
+static inline int atomic_futex_op_xchg_and(int oparg, u32 __user *uaddr, int *_oldval)
 {
 	int oldval, ret;
 
@@ -149,7 +149,7 @@ static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr, int *_o
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr, int *_oldval)
+static inline int atomic_futex_op_xchg_xor(int oparg, u32 __user *uaddr, int *_oldval)
 {
 	int oldval, ret;
 
@@ -186,7 +186,7 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr, int *_o
 /*
  * do the futex operations
  */
-int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -197,7 +197,7 @@ int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
index c7f0f06..8428525 100644
--- a/arch/ia64/include/asm/futex.h
+++ b/arch/ia64/include/asm/futex.h
@@ -46,7 +46,7 @@ do {									\
 } while (0)
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -56,7 +56,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -100,23 +100,26 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	{
-		register unsigned long r8 __asm ("r8");
+		register unsigned long r8 __asm ("r8") = 0;
+		unsigned long prev;
 		__asm__ __volatile__(
 			"	mf;;					\n"
 			"	mov ar.ccv=%3;;				\n"
 			"[1:]	cmpxchg4.acq %0=[%1],%2,ar.ccv		\n"
 			"	.xdata4 \"__ex_table\", 1b-., 2f-.	\n"
 			"[2:]"
-			: "=r" (r8)
+			: "=r" (prev)
 			: "r" (uaddr), "r" (newval),
 			  "rO" ((long) (unsigned) oldval)
 			: "memory");
+		*uval = prev;
 		return r8;
 	}
 }
diff --git a/arch/microblaze/include/asm/futex.h b/arch/microblaze/include/asm/futex.h
index ad3fd61..b0526d2 100644
--- a/arch/microblaze/include/asm/futex.h
+++ b/arch/microblaze/include/asm/futex.h
@@ -29,7 +29,7 @@
 })
 
 static inline int
-futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -39,7 +39,7 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -94,31 +94,34 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int prev, cmp;
+	int ret = 0, cmp;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	__asm__ __volatile__ ("1:	lwx	%0, %2, r0;		\
-					cmp	%1, %0, %3;		\
-					beqi	%1, 3f;			\
-				2:	swx	%4, %2, r0;		\
-					addic	%1, r0, 0;		\
-					bnei	%1, 1b;			\
+	__asm__ __volatile__ ("1:	lwx	%1, %3, r0;		\
+					cmp	%2, %1, %4;		\
+					beqi	%2, 3f;			\
+				2:	swx	%5, %3, r0;		\
+					addic	%2, r0, 0;		\
+					bnei	%2, 1b;			\
 				3:					\
 				.section .fixup,\"ax\";			\
 				4:	brid	3b;			\
-					addik	%0, r0, %5;		\
+					addik	%0, r0, %6;		\
 				.previous;				\
 				.section __ex_table,\"a\";		\
 				.word	1b,4b,2b,4b;			\
 				.previous;"				\
-		: "=&r" (prev), "=&r"(cmp)				\
+		: "+r" (ret), "=&r" (prev), "=&r"(cmp)	\
 		: "r" (uaddr), "r" (oldval), "r" (newval), "i" (-EFAULT));
 
-	return prev;
+	*uval = prev;
+	return ret;
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
index b9cce90..6ebf173 100644
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -75,7 +75,7 @@
 }
 
 static inline int
-futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -85,7 +85,7 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -132,11 +132,13 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int retval;
+	int ret = 0;
+	u32 val;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	if (cpu_has_llsc && R10000_LLSC_WAR) {
@@ -145,25 +147,25 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 		"	.set	push					\n"
 		"	.set	noat					\n"
 		"	.set	mips3					\n"
-		"1:	ll	%0, %2					\n"
-		"	bne	%0, %z3, 3f				\n"
+		"1:	ll	%1, %3					\n"
+		"	bne	%1, %z4, 3f				\n"
 		"	.set	mips0					\n"
-		"	move	$1, %z4					\n"
+		"	move	$1, %z5					\n"
 		"	.set	mips3					\n"
-		"2:	sc	$1, %1					\n"
+		"2:	sc	$1, %2					\n"
 		"	beqzl	$1, 1b					\n"
 		__WEAK_LLSC_MB
 		"3:							\n"
 		"	.set	pop					\n"
 		"	.section .fixup,\"ax\"				\n"
-		"4:	li	%0, %5					\n"
+		"4:	li	%0, %6					\n"
 		"	j	3b					\n"
 		"	.previous					\n"
 		"	.section __ex_table,\"a\"			\n"
 		"	"__UA_ADDR "\t1b, 4b				\n"
 		"	"__UA_ADDR "\t2b, 4b				\n"
 		"	.previous					\n"
-		: "=&r" (retval), "=R" (*uaddr)
+		: "+r" (ret), "=&r" (val), "=R" (*uaddr)
 		: "R" (*uaddr), "Jr" (oldval), "Jr" (newval), "i" (-EFAULT)
 		: "memory");
 	} else if (cpu_has_llsc) {
@@ -172,31 +174,32 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 		"	.set	push					\n"
 		"	.set	noat					\n"
 		"	.set	mips3					\n"
-		"1:	ll	%0, %2					\n"
-		"	bne	%0, %z3, 3f				\n"
+		"1:	ll	%1, %3					\n"
+		"	bne	%1, %z4, 3f				\n"
 		"	.set	mips0					\n"
-		"	move	$1, %z4					\n"
+		"	move	$1, %z5					\n"
 		"	.set	mips3					\n"
-		"2:	sc	$1, %1					\n"
+		"2:	sc	$1, %2					\n"
 		"	beqz	$1, 1b					\n"
 		__WEAK_LLSC_MB
 		"3:							\n"
 		"	.set	pop					\n"
 		"	.section .fixup,\"ax\"				\n"
-		"4:	li	%0, %5					\n"
+		"4:	li	%0, %6					\n"
 		"	j	3b					\n"
 		"	.previous					\n"
 		"	.section __ex_table,\"a\"			\n"
 		"	"__UA_ADDR "\t1b, 4b				\n"
 		"	"__UA_ADDR "\t2b, 4b				\n"
 		"	.previous					\n"
-		: "=&r" (retval), "=R" (*uaddr)
+		: "+r" (ret), "=&r" (val), "=R" (*uaddr)
 		: "R" (*uaddr), "Jr" (oldval), "Jr" (newval), "i" (-EFAULT)
 		: "memory");
 	} else
 		return -ENOSYS;
 
-	return retval;
+	*uval = val;
+	return ret;
 }
 
 #endif
diff --git a/arch/parisc/include/asm/futex.h b/arch/parisc/include/asm/futex.h
index 0c705c3..67a33cc 100644
--- a/arch/parisc/include/asm/futex.h
+++ b/arch/parisc/include/asm/futex.h
@@ -8,7 +8,7 @@
 #include <asm/errno.h>
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -18,7 +18,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -51,10 +51,10 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 
 /* Non-atomic version */
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int err = 0;
-	int uval;
+	u32 val;
 
 	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
 	 * our gateway page, and causes no end of trouble...
@@ -62,15 +62,15 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	if (segment_eq(KERNEL_DS, get_fs()) && !uaddr)
 		return -EFAULT;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	err = get_user(uval, uaddr);
-	if (err) return -EFAULT;
-	if (uval == oldval)
-		err = put_user(newval, uaddr);
-	if (err) return -EFAULT;
-	return uval;
+	if (get_user(val, uaddr))
+		return -EFAULT;
+	if (val == oldval && put_user(newval, uaddr))
+		return -EFAULT;
+	*uval = val;
+	return 0;
 }
 
 #endif /*__KERNEL__*/
diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index 7c589ef..c94e4a3 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -30,7 +30,7 @@
 	: "b" (uaddr), "i" (-EFAULT), "r" (oparg) \
 	: "cr0", "memory")
 
-static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -40,7 +40,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -82,35 +82,38 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int prev;
+	int ret = 0;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
         __asm__ __volatile__ (
         PPC_RELEASE_BARRIER
-"1:     lwarx   %0,0,%2         # futex_atomic_cmpxchg_inatomic\n\
-        cmpw    0,%0,%3\n\
+"1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
+        cmpw    0,%1,%4\n\
         bne-    3f\n"
-        PPC405_ERR77(0,%2)
-"2:     stwcx.  %4,0,%2\n\
+        PPC405_ERR77(0,%3)
+"2:     stwcx.  %5,0,%3\n\
         bne-    1b\n"
         PPC_ACQUIRE_BARRIER
 "3:	.section .fixup,\"ax\"\n\
-4:	li	%0,%5\n\
+4:	li	%0,%6\n\
 	b	3b\n\
 	.previous\n\
 	.section __ex_table,\"a\"\n\
 	.align 3\n\
 	" PPC_LONG "1b,4b,2b,4b\n\
 	.previous" \
-        : "=&r" (prev), "+m" (*uaddr)
+        : "+r" (ret), "=&r" (prev), "+m" (*uaddr)
         : "r" (uaddr), "r" (oldval), "r" (newval), "i" (-EFAULT)
         : "cc", "memory");
 
-        return prev;
+	*uval = prev;
+        return ret;
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 5c5d02d..81cf36b 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -7,7 +7,7 @@
 #include <linux/uaccess.h>
 #include <asm/errno.h>
 
-static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -18,7 +18,7 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -39,13 +39,13 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr,
-						int oldval, int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	return uaccess.futex_atomic_cmpxchg(uaddr, oldval, newval);
+	return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index d6b1ed0..2d9ea11f 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -83,8 +83,8 @@ struct uaccess_ops {
 	size_t (*clear_user)(size_t, void __user *);
 	size_t (*strnlen_user)(size_t, const char __user *);
 	size_t (*strncpy_from_user)(size_t, const char __user *, char *);
-	int (*futex_atomic_op)(int op, int __user *, int oparg, int *old);
-	int (*futex_atomic_cmpxchg)(int __user *, int old, int new);
+	int (*futex_atomic_op)(int op, u32 __user *, int oparg, int *old);
+	int (*futex_atomic_cmpxchg)(u32 *, u32 __user *, u32 old, u32 new);
 };
 
 extern struct uaccess_ops uaccess;
diff --git a/arch/s390/lib/uaccess.h b/arch/s390/lib/uaccess.h
index 126011d..1d2536c 100644
--- a/arch/s390/lib/uaccess.h
+++ b/arch/s390/lib/uaccess.h
@@ -12,12 +12,12 @@ extern size_t copy_from_user_std(size_t, const void __user *, void *);
 extern size_t copy_to_user_std(size_t, void __user *, const void *);
 extern size_t strnlen_user_std(size_t, const char __user *);
 extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
-extern int futex_atomic_cmpxchg_std(int __user *, int, int);
-extern int futex_atomic_op_std(int, int __user *, int, int *);
+extern int futex_atomic_cmpxchg_std(u32 *, u32 __user *, u32, u32);
+extern int futex_atomic_op_std(int, u32 __user *, int, int *);
 
 extern size_t copy_from_user_pt(size_t, const void __user *, void *);
 extern size_t copy_to_user_pt(size_t, void __user *, const void *);
-extern int futex_atomic_op_pt(int, int __user *, int, int *);
-extern int futex_atomic_cmpxchg_pt(int __user *, int, int);
+extern int futex_atomic_op_pt(int, u32 __user *, int, int *);
+extern int futex_atomic_cmpxchg_pt(u32 *, u32 __user *, u32, u32);
 
 #endif /* __ARCH_S390_LIB_UACCESS_H */
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 404f2de..7483383 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -302,7 +302,7 @@ fault:
 		     : "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
 		       "m" (*uaddr) : "cc" );
 
-static int __futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
+static int __futex_atomic_op_pt(int op, u32 __user *uaddr, int oparg, int *old)
 {
 	int oldval = 0, newval, ret;
 
@@ -335,7 +335,7 @@ static int __futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
+int futex_atomic_op_pt(int op, u32 __user *uaddr, int oparg, int *old)
 {
 	int ret;
 
@@ -354,26 +354,29 @@ int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-static int __futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
+static int __futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
+				     u32 oldval, u32 newval)
 {
 	int ret;
 
 	asm volatile("0: cs   %1,%4,0(%5)\n"
-		     "1: lr   %0,%1\n"
+		     "1: la   %0,0\n"
 		     "2:\n"
 		     EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		     : "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		     : "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		     : "cc", "memory" );
+	*uval = oldval;
 	return ret;
 }
 
-int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
+			    u32 oldval, u32 newval)
 {
 	int ret;
 
 	if (segment_eq(get_fs(), KERNEL_DS))
-		return __futex_atomic_cmpxchg_pt(uaddr, oldval, newval);
+		return __futex_atomic_cmpxchg_pt(uval, uaddr, oldval, newval);
 	spin_lock(&current->mm->page_table_lock);
 	uaddr = (int __user *) __dat_user_addr((unsigned long) uaddr);
 	if (!uaddr) {
@@ -382,7 +385,7 @@ int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
 	}
 	get_page(virt_to_page(uaddr));
 	spin_unlock(&current->mm->page_table_lock);
-	ret = __futex_atomic_cmpxchg_pt(uaddr, oldval, newval);
+	ret = __futex_atomic_cmpxchg_pt(uval, uaddr, oldval, newval);
 	put_page(virt_to_page(uaddr));
 	return ret;
 }
diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
index a6c4f7e..bb1a7ee 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -255,7 +255,7 @@ size_t strncpy_from_user_std(size_t size, const char __user *src, char *dst)
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
 		  "m" (*uaddr) : "cc");
 
-int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
+int futex_atomic_op_std(int op, u32 __user *uaddr, int oparg, int *old)
 {
 	int oldval = 0, newval, ret;
 
@@ -287,19 +287,21 @@ int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-int futex_atomic_cmpxchg_std(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_std(u32 *uval, u32 __user *uaddr,
+			     u32 oldval, u32 newval)
 {
 	int ret;
 
 	asm volatile(
 		"   sacf 256\n"
 		"0: cs   %1,%4,0(%5)\n"
-		"1: lr   %0,%1\n"
+		"1: la   %0,0\n"
 		"2: sacf 0\n"
 		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		: "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		: "cc", "memory" );
+	*uval = oldval;
 	return ret;
 }
 
diff --git a/arch/sh/include/asm/futex-irq.h b/arch/sh/include/asm/futex-irq.h
index a9f16a7..6cb9f19 100644
--- a/arch/sh/include/asm/futex-irq.h
+++ b/arch/sh/include/asm/futex-irq.h
@@ -3,7 +3,7 @@
 
 #include <asm/system.h>
 
-static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr,
+static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
 					   int *oldval)
 {
 	unsigned long flags;
@@ -20,7 +20,7 @@ static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr,
+static inline int atomic_futex_op_xchg_add(int oparg, u32 __user *uaddr,
 					   int *oldval)
 {
 	unsigned long flags;
@@ -37,7 +37,7 @@ static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr,
+static inline int atomic_futex_op_xchg_or(int oparg, u32 __user *uaddr,
 					  int *oldval)
 {
 	unsigned long flags;
@@ -54,7 +54,7 @@ static inline int atomic_futex_op_xchg_or(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr,
+static inline int atomic_futex_op_xchg_and(int oparg, u32 __user *uaddr,
 					   int *oldval)
 {
 	unsigned long flags;
@@ -71,7 +71,7 @@ static inline int atomic_futex_op_xchg_and(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
+static inline int atomic_futex_op_xchg_xor(int oparg, u32 __user *uaddr,
 					   int *oldval)
 {
 	unsigned long flags;
@@ -88,11 +88,13 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
-						   int oldval, int newval)
+static inline int atomic_futex_op_cmpxchg_inatomic(u32 *uval,
+						   u32 __user *uaddr,
+						   u32 oldval, u32 newval)
 {
 	unsigned long flags;
-	int ret, prev = 0;
+	int ret;
+	u32 prev = 0;
 
 	local_irq_save(flags);
 
@@ -102,10 +104,8 @@ static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
 
 	local_irq_restore(flags);
 
-	if (ret)
-		return ret;
-
-	return prev;
+	*uval = prev;
+	return ret;
 }
 
 #endif /* __ASM_SH_FUTEX_IRQ_H */
diff --git a/arch/sh/include/asm/futex.h b/arch/sh/include/asm/futex.h
index 68256ec..7be39a6 100644
--- a/arch/sh/include/asm/futex.h
+++ b/arch/sh/include/asm/futex.h
@@ -10,7 +10,7 @@
 /* XXX: UP variants, fix for SH-4A and SMP.. */
 #include <asm/futex-irq.h>
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -21,7 +21,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -65,12 +65,13 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	return atomic_futex_op_cmpxchg_inatomic(uaddr, oldval, newval);
+	return atomic_futex_op_cmpxchg_inatomic(uval, uaddr, oldval, newval);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
index 47f9583..444e7be 100644
--- a/arch/sparc/include/asm/futex_64.h
+++ b/arch/sparc/include/asm/futex_64.h
@@ -30,7 +30,7 @@
 	: "r" (uaddr), "r" (oparg), "i" (-EFAULT)	\
 	: "memory")
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -38,7 +38,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	int cmparg = (encoded_op << 20) >> 20;
 	int oldval = 0, ret, tem;
 
-	if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(int))))
+	if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
 		return -EFAULT;
 	if (unlikely((((unsigned long) uaddr) & 0x3UL)))
 		return -EINVAL;
@@ -85,26 +85,30 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
+	int ret = 0;
+
 	__asm__ __volatile__(
-	"\n1:	casa	[%3] %%asi, %2, %0\n"
+	"\n1:	casa	[%4] %%asi, %3, %1\n"
 	"2:\n"
 	"	.section .fixup,#alloc,#execinstr\n"
 	"	.align	4\n"
 	"3:	sethi	%%hi(2b), %0\n"
 	"	jmpl	%0 + %%lo(2b), %%g0\n"
-	"	 mov	%4, %0\n"
+	"	mov	%5, %0\n"
 	"	.previous\n"
 	"	.section __ex_table,\"a\"\n"
 	"	.align	4\n"
 	"	.word	1b, 3b\n"
 	"	.previous\n"
-	: "=r" (newval)
-	: "0" (newval), "r" (oldval), "r" (uaddr), "i" (-EFAULT)
+	: "+r" (ret), "=r" (newval)
+	: "1" (newval), "r" (oldval), "r" (uaddr), "i" (-EFAULT)
 	: "memory");
 
-	return newval;
+	*uval = newval;
+	return ret;
 }
 
 #endif /* !(_SPARC64_FUTEX_H) */
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index fe0d10d..d03ec12 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -29,16 +29,16 @@
 #include <linux/uaccess.h>
 #include <linux/errno.h>
 
-extern struct __get_user futex_set(int __user *v, int i);
-extern struct __get_user futex_add(int __user *v, int n);
-extern struct __get_user futex_or(int __user *v, int n);
-extern struct __get_user futex_andn(int __user *v, int n);
-extern struct __get_user futex_cmpxchg(int __user *v, int o, int n);
+extern struct __get_user futex_set(u32 __user *v, int i);
+extern struct __get_user futex_add(u32 __user *v, int n);
+extern struct __get_user futex_or(u32 __user *v, int n);
+extern struct __get_user futex_andn(u32 __user *v, int n);
+extern struct __get_user futex_cmpxchg(u32 __user *v, int o, int n);
 
 #ifndef __tilegx__
-extern struct __get_user futex_xor(int __user *v, int n);
+extern struct __get_user futex_xor(u32 __user *v, int n);
 #else
-static inline struct __get_user futex_xor(int __user *uaddr, int n)
+static inline struct __get_user futex_xor(u32 __user *uaddr, int n)
 {
 	struct __get_user asm_ret = __get_user_4(uaddr);
 	if (!asm_ret.err) {
@@ -53,7 +53,7 @@ static inline struct __get_user futex_xor(int __user *uaddr, int n)
 }
 #endif
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -65,7 +65,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -119,16 +119,17 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
-						int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
 	struct __get_user asm_ret;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	asm_ret = futex_cmpxchg(uaddr, oldval, newval);
-	return asm_ret.err ? asm_ret.err : asm_ret.val;
+	*uval = asm_ret.val;
+	return asm_ret.err;
 }
 
 #ifndef __tilegx__
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index 1f11ce4..d09bb03 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -37,7 +37,7 @@
 		       "+m" (*uaddr), "=&r" (tem)		\
 		     : "r" (oparg), "i" (-EFAULT), "1" (0))
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -48,7 +48,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
@@ -109,9 +109,10 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
-						int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
+	int ret = 0;
 
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
 	/* Real i386 machines have no cmpxchg instruction */
@@ -119,21 +120,22 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
 		return -ENOSYS;
 #endif
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %3, %1\n"
+	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
 		     "2:\t.section .fixup, \"ax\"\n"
-		     "3:\tmov     %2, %0\n"
+		     "3:\tmov     %3, %0\n"
 		     "\tjmp     2b\n"
 		     "\t.previous\n"
 		     _ASM_EXTABLE(1b, 3b)
-		     : "=a" (oldval), "+m" (*uaddr)
-		     : "i" (-EFAULT), "r" (newval), "0" (oldval)
+		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
+		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
 		     : "memory"
 	);
 
-	return oldval;
+	*uval = oldval;
+	return ret;
 }
 
 #endif
diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index 3c2344f..01f227e 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -6,7 +6,7 @@
 #include <asm/errno.h>
 
 static inline int
-futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
@@ -16,7 +16,7 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -48,7 +48,8 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
 	return -ENOSYS;
 }
diff --git a/include/linux/plist.h b/include/linux/plist.h
index 7254eda..c9b9f32 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -31,15 +31,17 @@
  *
  * Simple ASCII art explanation:
  *
- * |HEAD          |
- * |              |
- * |prio_list.prev|<------------------------------------|
- * |prio_list.next|<->|pl|<->|pl|<--------------->|pl|<-|
- * |10            |   |10|   |21|   |21|   |21|   |40|   (prio)
- * |              |   |  |   |  |   |  |   |  |   |  |
- * |              |   |  |   |  |   |  |   |  |   |  |
- * |node_list.next|<->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<-|
- * |node_list.prev|<------------------------------------|
+ * pl:prio_list (only for plist_node)
+ * nl:node_list
+ *   HEAD|             NODE(S)
+ *       |
+ *       ||------------------------------------|
+ *       ||->|pl|<->|pl|<--------------->|pl|<-|
+ *       |   |10|   |21|   |21|   |21|   |40|   (prio)
+ *       |   |  |   |  |   |  |   |  |   |  |
+ *       |   |  |   |  |   |  |   |  |   |  |
+ * |->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<->|nl|<-|
+ * |-------------------------------------------|
  *
  * The nodes on the prio_list list are sorted by priority to simplify
  * the insertion of new nodes. There are no nodes with duplicate
@@ -78,7 +80,6 @@
 #include <linux/spinlock_types.h>
 
 struct plist_head {
-	struct list_head prio_list;
 	struct list_head node_list;
 #ifdef CONFIG_DEBUG_PI_LIST
 	raw_spinlock_t *rawlock;
@@ -88,7 +89,8 @@ struct plist_head {
 
 struct plist_node {
 	int			prio;
-	struct plist_head	plist;
+	struct list_head	prio_list;
+	struct list_head	node_list;
 };
 
 #ifdef CONFIG_DEBUG_PI_LIST
@@ -100,7 +102,6 @@ struct plist_node {
 #endif
 
 #define _PLIST_HEAD_INIT(head)				\
-	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
 	.node_list = LIST_HEAD_INIT((head).node_list)
 
 /**
@@ -133,7 +134,8 @@ struct plist_node {
 #define PLIST_NODE_INIT(node, __prio)			\
 {							\
 	.prio  = (__prio),				\
-	.plist = { _PLIST_HEAD_INIT((node).plist) },	\
+	.prio_list = LIST_HEAD_INIT((node).prio_list),	\
+	.node_list = LIST_HEAD_INIT((node).node_list),	\
 }
 
 /**
@@ -144,7 +146,6 @@ struct plist_node {
 static inline void
 plist_head_init(struct plist_head *head, spinlock_t *lock)
 {
-	INIT_LIST_HEAD(&head->prio_list);
 	INIT_LIST_HEAD(&head->node_list);
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->spinlock = lock;
@@ -160,7 +161,6 @@ plist_head_init(struct plist_head *head, spinlock_t *lock)
 static inline void
 plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
 {
-	INIT_LIST_HEAD(&head->prio_list);
 	INIT_LIST_HEAD(&head->node_list);
 #ifdef CONFIG_DEBUG_PI_LIST
 	head->rawlock = lock;
@@ -176,7 +176,8 @@ plist_head_init_raw(struct plist_head *head, raw_spinlock_t *lock)
 static inline void plist_node_init(struct plist_node *node, int prio)
 {
 	node->prio = prio;
-	plist_head_init(&node->plist, NULL);
+	INIT_LIST_HEAD(&node->prio_list);
+	INIT_LIST_HEAD(&node->node_list);
 }
 
 extern void plist_add(struct plist_node *node, struct plist_head *head);
@@ -188,7 +189,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * @head:	the head for your list
  */
 #define plist_for_each(pos, head)	\
-	 list_for_each_entry(pos, &(head)->node_list, plist.node_list)
+	 list_for_each_entry(pos, &(head)->node_list, node_list)
 
 /**
  * plist_for_each_safe - iterate safely over a plist of given type
@@ -199,7 +200,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * Iterate over a plist of given type, safe against removal of list entry.
  */
 #define plist_for_each_safe(pos, n, head)	\
-	 list_for_each_entry_safe(pos, n, &(head)->node_list, plist.node_list)
+	 list_for_each_entry_safe(pos, n, &(head)->node_list, node_list)
 
 /**
  * plist_for_each_entry	- iterate over list of given type
@@ -208,7 +209,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * @mem:	the name of the list_struct within the struct
  */
 #define plist_for_each_entry(pos, head, mem)	\
-	 list_for_each_entry(pos, &(head)->node_list, mem.plist.node_list)
+	 list_for_each_entry(pos, &(head)->node_list, mem.node_list)
 
 /**
  * plist_for_each_entry_safe - iterate safely over list of given type
@@ -220,7 +221,7 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
  * Iterate over list of given type, safe against removal of list entry.
  */
 #define plist_for_each_entry_safe(pos, n, head, m)	\
-	list_for_each_entry_safe(pos, n, &(head)->node_list, m.plist.node_list)
+	list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
 
 /**
  * plist_head_empty - return !0 if a plist_head is empty
@@ -237,7 +238,7 @@ static inline int plist_head_empty(const struct plist_head *head)
  */
 static inline int plist_node_empty(const struct plist_node *node)
 {
-	return plist_head_empty(&node->plist);
+	return list_empty(&node->node_list);
 }
 
 /* All functions below assume the plist_head is not empty. */
@@ -285,7 +286,7 @@ static inline int plist_node_empty(const struct plist_node *node)
 static inline struct plist_node *plist_first(const struct plist_head *head)
 {
 	return list_entry(head->node_list.next,
-			  struct plist_node, plist.node_list);
+			  struct plist_node, node_list);
 }
 
 /**
@@ -297,7 +298,7 @@ static inline struct plist_node *plist_first(const struct plist_head *head)
 static inline struct plist_node *plist_last(const struct plist_head *head)
 {
 	return list_entry(head->node_list.prev,
-			  struct plist_node, plist.node_list);
+			  struct plist_node, node_list);
 }
 
 #endif
diff --git a/kernel/futex.c b/kernel/futex.c
index b766d28..e9251d9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -381,15 +381,16 @@ static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
 	return NULL;
 }
 
-static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
+static int cmpxchg_futex_value_locked(u32 *curval, u32 __user *uaddr,
+				      u32 uval, u32 newval)
 {
-	u32 curval;
+	int ret;
 
 	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
+	ret = futex_atomic_cmpxchg_inatomic(curval, uaddr, uval, newval);
 	pagefault_enable();
 
-	return curval;
+	return ret;
 }
 
 static int get_futex_value_locked(u32 *dest, u32 __user *from)
@@ -674,7 +675,7 @@ static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				struct task_struct *task, int set_waiters)
 {
 	int lock_taken, ret, ownerdied = 0;
-	u32 uval, newval, curval;
+	u32 uval, newval, curval, vpid = task_pid_vnr(task);
 
 retry:
 	ret = lock_taken = 0;
@@ -684,19 +685,17 @@ retry:
 	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
 	 * the locks. It will most likely not succeed.
 	 */
-	newval = task_pid_vnr(task);
+	newval = vpid;
 	if (set_waiters)
 		newval |= FUTEX_WAITERS;
 
-	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
-
-	if (unlikely(curval == -EFAULT))
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
 		return -EFAULT;
 
 	/*
 	 * Detect deadlocks.
 	 */
-	if ((unlikely((curval & FUTEX_TID_MASK) == task_pid_vnr(task))))
+	if ((unlikely((curval & FUTEX_TID_MASK) == vpid)))
 		return -EDEADLK;
 
 	/*
@@ -723,14 +722,12 @@ retry:
 	 */
 	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
 		/* Keep the OWNER_DIED bit */
-		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
+		newval = (curval & ~FUTEX_TID_MASK) | vpid;
 		ownerdied = 0;
 		lock_taken = 1;
 	}
 
-	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-	if (unlikely(curval == -EFAULT))
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
 		return -EFAULT;
 	if (unlikely(curval != uval))
 		goto retry;
@@ -775,6 +772,24 @@ retry:
 	return ret;
 }
 
+/**
+ * __unqueue_futex() - Remove the futex_q from its futex_hash_bucket
+ * @q:	The futex_q to unqueue
+ *
+ * The q->lock_ptr must not be NULL and must be held by the caller.
+ */
+static void __unqueue_futex(struct futex_q *q)
+{
+	struct futex_hash_bucket *hb;
+
+	if (WARN_ON(!q->lock_ptr || !spin_is_locked(q->lock_ptr)
+			|| plist_node_empty(&q->list)))
+		return;
+
+	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
+	plist_del(&q->list, &hb->chain);
+}
+
 /*
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
@@ -792,7 +807,7 @@ static void wake_futex(struct futex_q *q)
 	 */
 	get_task_struct(p);
 
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 	/*
 	 * The waiting task can free the futex_q as soon as
 	 * q->lock_ptr = NULL is written, without taking any locks. A
@@ -843,9 +858,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 
 		newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-		if (curval == -EFAULT)
+		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
 			ret = -EFAULT;
 		else if (curval != uval)
 			ret = -EINVAL;
@@ -880,10 +893,8 @@ static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
 	 * There is no waiter, so we unlock the futex. The owner died
 	 * bit has not to be preserved here. We are the owner:
 	 */
-	oldval = cmpxchg_futex_value_locked(uaddr, uval, 0);
-
-	if (oldval == -EFAULT)
-		return oldval;
+	if (cmpxchg_futex_value_locked(&oldval, uaddr, uval, 0))
+		return -EFAULT;
 	if (oldval != uval)
 		return -EAGAIN;
 
@@ -1071,9 +1082,6 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 		plist_del(&q->list, &hb1->chain);
 		plist_add(&q->list, &hb2->chain);
 		q->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-		q->list.plist.spinlock = &hb2->lock;
-#endif
 	}
 	get_futex_key_refs(key2);
 	q->key = *key2;
@@ -1100,16 +1108,12 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key,
 	get_futex_key_refs(key);
 	q->key = *key;
 
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	WARN_ON(!q->rt_waiter);
 	q->rt_waiter = NULL;
 
 	q->lock_ptr = &hb->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 
 	wake_up_state(q->task, TASK_NORMAL);
 }
@@ -1457,9 +1461,6 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 	prio = min(current->normal_prio, MAX_RT_PRIO);
 
 	plist_node_init(&q->list, prio);
-#ifdef CONFIG_DEBUG_PI_LIST
-	q->list.plist.spinlock = &hb->lock;
-#endif
 	plist_add(&q->list, &hb->chain);
 	q->task = current;
 	spin_unlock(&hb->lock);
@@ -1504,8 +1505,7 @@ retry:
 			spin_unlock(lock_ptr);
 			goto retry;
 		}
-		WARN_ON(plist_node_empty(&q->list));
-		plist_del(&q->list, &q->list.plist);
+		__unqueue_futex(q);
 
 		BUG_ON(q->pi_state);
 
@@ -1525,8 +1525,7 @@ retry:
 static void unqueue_me_pi(struct futex_q *q)
 	__releases(q->lock_ptr)
 {
-	WARN_ON(plist_node_empty(&q->list));
-	plist_del(&q->list, &q->list.plist);
+	__unqueue_futex(q);
 
 	BUG_ON(!q->pi_state);
 	free_pi_state(q->pi_state);
@@ -1578,9 +1577,7 @@ retry:
 	while (1) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-		if (curval == -EFAULT)
+		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
 			goto handle_fault;
 		if (curval == uval)
 			break;
@@ -1781,13 +1778,14 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
 	 *
 	 * The basic logical guarantee of a futex is that it blocks ONLY
 	 * if cond(var) is known to be true at the time of blocking, for
-	 * any cond.  If we queued after testing *uaddr, that would open
-	 * a race condition where we could block indefinitely with
+	 * any cond.  If we locked the hash-bucket after testing *uaddr, that
+	 * would open a race condition where we could block indefinitely with
 	 * cond(var) false, which would violate the guarantee.
 	 *
-	 * A consequence is that futex_wait() can return zero and absorb
-	 * a wakeup when *uaddr != val on entry to the syscall.  This is
-	 * rare, but normal.
+	 * On the other hand, we insert q and release the hash-bucket only
+	 * after testing *uaddr.  This guarantees that futex_wait() will NOT
+	 * absorb a wakeup if *uaddr does not match the desired values
+	 * while the syscall executes.
 	 */
 retry:
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
@@ -2046,9 +2044,9 @@ static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	u32 uval;
 	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
+	u32 uval, vpid = task_pid_vnr(current);
 	int ret;
 
 retry:
@@ -2057,7 +2055,7 @@ retry:
 	/*
 	 * We release only a lock we actually own:
 	 */
-	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
+	if ((uval & FUTEX_TID_MASK) != vpid)
 		return -EPERM;
 
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
@@ -2072,17 +2070,14 @@ retry:
 	 * again. If it succeeds then we can return without waking
 	 * anyone else up:
 	 */
-	if (!(uval & FUTEX_OWNER_DIED))
-		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
-
-
-	if (unlikely(uval == -EFAULT))
+	if (!(uval & FUTEX_OWNER_DIED) &&
+	    cmpxchg_futex_value_locked(&uval, uaddr, vpid, 0))
 		goto pi_faulted;
 	/*
 	 * Rare case: we managed to release the lock atomically,
 	 * no need to wake anyone else up:
 	 */
-	if (unlikely(uval == task_pid_vnr(current)))
+	if (unlikely(uval == vpid))
 		goto out_unlock;
 
 	/*
@@ -2167,7 +2162,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &q->list.plist);
+		plist_del(&q->list, &hb->chain);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
@@ -2463,11 +2458,20 @@ retry:
 		 * userspace.
 		 */
 		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
-
-		if (nval == -EFAULT)
-			return -1;
-
+		/*
+		 * We are not holding a lock here, but we want to have
+		 * the pagefault_disable/enable() protection because
+		 * we want to handle the fault gracefully. If the
+		 * access fails we try to fault in the futex with R/W
+		 * verification via get_user_pages. get_user() above
+		 * does not guarantee R/W access. If that fails we
+		 * give up and leave the futex locked.
+		 */
+		if (cmpxchg_futex_value_locked(&nval, uaddr, uval, mval)) {
+			if (fault_in_user_writeable(uaddr))
+				return -1;
+			goto retry;
+		}
 		if (nval != uval)
 			goto retry;
 
@@ -2678,8 +2682,7 @@ static int __init futex_init(void)
 	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
-	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
-	if (curval == -EFAULT)
+	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
diff --git a/lib/plist.c b/lib/plist.c
index 1471988..0ae7e64 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -28,6 +28,8 @@
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
+static struct plist_head test_head;
+
 static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
@@ -54,12 +56,13 @@ static void plist_check_list(struct list_head *top)
 
 static void plist_check_head(struct plist_head *head)
 {
-	WARN_ON(!head->rawlock && !head->spinlock);
+	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
 	if (head->rawlock)
 		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
 	if (head->spinlock)
 		WARN_ON_SMP(!spin_is_locked(head->spinlock));
-	plist_check_list(&head->prio_list);
+	if (!plist_head_empty(head))
+		plist_check_list(&plist_first(head)->prio_list);
 	plist_check_list(&head->node_list);
 }
 
@@ -75,25 +78,33 @@ static void plist_check_head(struct plist_head *head)
  */
 void plist_add(struct plist_node *node, struct plist_head *head)
 {
-	struct plist_node *iter;
+	struct plist_node *first, *iter, *prev = NULL;
+	struct list_head *node_next = &head->node_list;
 
 	plist_check_head(head);
 	WARN_ON(!plist_node_empty(node));
+	WARN_ON(!list_empty(&node->prio_list));
+
+	if (plist_head_empty(head))
+		goto ins_node;
 
-	list_for_each_entry(iter, &head->prio_list, plist.prio_list) {
-		if (node->prio < iter->prio)
-			goto lt_prio;
-		else if (node->prio == iter->prio) {
-			iter = list_entry(iter->plist.prio_list.next,
-					struct plist_node, plist.prio_list);
-			goto eq_prio;
+	first = iter = plist_first(head);
+
+	do {
+		if (node->prio < iter->prio) {
+			node_next = &iter->node_list;
+			break;
 		}
-	}
 
-lt_prio:
-	list_add_tail(&node->plist.prio_list, &iter->plist.prio_list);
-eq_prio:
-	list_add_tail(&node->plist.node_list, &iter->plist.node_list);
+		prev = iter;
+		iter = list_entry(iter->prio_list.next,
+				struct plist_node, prio_list);
+	} while (iter != first);
+
+	if (!prev || prev->prio != node->prio)
+		list_add_tail(&node->prio_list, &iter->prio_list);
+ins_node:
+	list_add_tail(&node->node_list, node_next);
 
 	plist_check_head(head);
 }
@@ -108,14 +119,98 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 {
 	plist_check_head(head);
 
-	if (!list_empty(&node->plist.prio_list)) {
-		struct plist_node *next = plist_first(&node->plist);
+	if (!list_empty(&node->prio_list)) {
+		if (node->node_list.next != &head->node_list) {
+			struct plist_node *next;
+
+			next = list_entry(node->node_list.next,
+					struct plist_node, node_list);
 
-		list_move_tail(&next->plist.prio_list, &node->plist.prio_list);
-		list_del_init(&node->plist.prio_list);
+			/* add the next plist_node into prio_list */
+			if (list_empty(&next->prio_list))
+				list_add(&next->prio_list, &node->prio_list);
+		}
+		list_del_init(&node->prio_list);
 	}
 
-	list_del_init(&node->plist.node_list);
+	list_del_init(&node->node_list);
 
 	plist_check_head(head);
 }
+
+#ifdef CONFIG_DEBUG_PI_LIST
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+static struct plist_node __initdata test_node[241];
+
+static void __init plist_test_check(int nr_expect)
+{
+	struct plist_node *first, *prio_pos, *node_pos;
+
+	if (plist_head_empty(&test_head)) {
+		BUG_ON(nr_expect != 0);
+		return;
+	}
+
+	prio_pos = first = plist_first(&test_head);
+	plist_for_each(node_pos, &test_head) {
+		if (nr_expect-- < 0)
+			break;
+		if (node_pos == first)
+			continue;
+		if (node_pos->prio == prio_pos->prio) {
+			BUG_ON(!list_empty(&node_pos->prio_list));
+			continue;
+		}
+
+		BUG_ON(prio_pos->prio > node_pos->prio);
+		BUG_ON(prio_pos->prio_list.next != &node_pos->prio_list);
+		prio_pos = node_pos;
+	}
+
+	BUG_ON(nr_expect != 0);
+	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
+}
+
+static int  __init plist_test(void)
+{
+	int nr_expect = 0, i, loop;
+	unsigned int r = local_clock();
+
+	printk(KERN_INFO "start plist test\n");
+	plist_head_init(&test_head, NULL);
+	for (i = 0; i < ARRAY_SIZE(test_node); i++)
+		plist_node_init(test_node + i, 0);
+
+	for (loop = 0; loop < 1000; loop++) {
+		r = r * 193939 % 47629;
+		i = r % ARRAY_SIZE(test_node);
+		if (plist_node_empty(test_node + i)) {
+			r = r * 193939 % 47629;
+			test_node[i].prio = r % 99;
+			plist_add(test_node + i, &test_head);
+			nr_expect++;
+		} else {
+			plist_del(test_node + i, &test_head);
+			nr_expect--;
+		}
+		plist_test_check(nr_expect);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
+		if (plist_node_empty(test_node + i))
+			continue;
+		plist_del(test_node + i, &test_head);
+		nr_expect--;
+		plist_test_check(nr_expect);
+	}
+
+	printk(KERN_INFO "end plist test\n");
+	return 0;
+}
+
+module_init(plist_test);
+
+#endif
