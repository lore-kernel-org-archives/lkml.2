Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1CGCLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:11:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1CGCLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:11:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MEFZvpxj3rCTDfK8tVKma9v5/O6kK59fISSb5nBojEE6M1pqG8CzzANM28MdeikymL
         lBaLNa37HgVmgIjyB+UQ==
Date: Sun, 6 Mar 2011 18:11:27 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] futex: cmpxchg_futex_value_locked API change
Message-ID: <20110307021127.GB31188@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aplogies for the long CC list - as this proposal involves asm changes
in many architectures, and I have only been able to test on x86,
I have tried to include one maintainer from every arch so they can
hopefully double check me. I do think I got all architectures right,
but you can never be 100% sure...

------------------------------------8<---------------------------------

The cmpxchg_futex_value_locked API was funny in that it returned either
the original, user-exposed futex value OR an error code such as -EFAULT.
This was confusing at best, and could be a source of livelocks in places
that retry the cmpxchg_futex_value_locked after trying to fix the issue
by running fault_in_user_writeable().

This change makes the cmpxchg_futex_value_locked API more similar to the
get_futex_value_locked one, returning an error code and updating the
original value through a reference argument.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/alpha/include/asm/futex.h      |   22 +++++++++-------
 arch/arm/include/asm/futex.h        |   23 +++++++++--------
 arch/frv/include/asm/futex.h        |    3 +-
 arch/ia64/include/asm/futex.h       |    9 ++++--
 arch/microblaze/include/asm/futex.h |   24 ++++++++++--------
 arch/mips/include/asm/futex.h       |   32 +++++++++++++-----------
 arch/parisc/include/asm/futex.h     |   18 +++++++-------
 arch/powerpc/include/asm/futex.h    |   20 ++++++++-------
 arch/s390/include/asm/futex.h       |    4 +-
 arch/s390/include/asm/uaccess.h     |    2 +-
 arch/s390/lib/uaccess.h             |    4 +-
 arch/s390/lib/uaccess_pt.c          |   13 ++++++----
 arch/s390/lib/uaccess_std.c         |    6 +++-
 arch/sh/include/asm/futex-irq.h     |    9 +++----
 arch/sh/include/asm/futex.h         |    5 ++-
 arch/sparc/include/asm/futex_64.h   |   16 +++++++----
 arch/tile/include/asm/futex.h       |    7 +++--
 arch/x86/include/asm/futex.h        |   16 +++++++-----
 include/asm-generic/futex.h         |    3 +-
 kernel/futex.c                      |   46 ++++++++++++----------------------
 20 files changed, 147 insertions(+), 135 deletions(-)

diff --git a/arch/alpha/include/asm/futex.h b/arch/alpha/include/asm/futex.h
index 945de22..c4e5c28 100644
--- a/arch/alpha/include/asm/futex.h
+++ b/arch/alpha/include/asm/futex.h
@@ -81,21 +81,22 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int prev, cmp;
+	int ret = 0, prev, cmp;
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
@@ -105,11 +106,12 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
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
index b33fe70..d20b78f 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -88,36 +88,37 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int val;
+	int ret = 0, val;
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	pagefault_disable();	/* implies preempt_disable() */
+	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
+	 * call sites. */
 
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
index 08b3d1d..0548f8e 100644
--- a/arch/frv/include/asm/futex.h
+++ b/arch/frv/include/asm/futex.h
@@ -10,7 +10,8 @@
 extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
 	return -ENOSYS;
 }
diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
index c7f0f06..b072840 100644
--- a/arch/ia64/include/asm/futex.h
+++ b/arch/ia64/include/asm/futex.h
@@ -100,23 +100,26 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
index ad3fd61..fa019ed 100644
--- a/arch/microblaze/include/asm/futex.h
+++ b/arch/microblaze/include/asm/futex.h
@@ -94,31 +94,33 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int prev, cmp;
+	int ret = 0, prev, cmp;
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
index b9cce90..692a24b 100644
--- a/arch/mips/include/asm/futex.h
+++ b/arch/mips/include/asm/futex.h
@@ -132,9 +132,10 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int retval;
+	int ret = 0, val;
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
@@ -145,25 +146,25 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
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
@@ -172,31 +173,32 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
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
index 0c705c3..4c6d867 100644
--- a/arch/parisc/include/asm/futex.h
+++ b/arch/parisc/include/asm/futex.h
@@ -51,10 +51,10 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 
 /* Non-atomic version */
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int err = 0;
-	int uval;
+	int val;
 
 	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
 	 * our gateway page, and causes no end of trouble...
@@ -65,12 +65,12 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
index 7c589ef..631e8da 100644
--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -82,35 +82,37 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
-	int prev;
+	int ret = 0, prev;
 
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
index 5c5d02d..27ac515 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -39,13 +39,13 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr,
+static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
 						int oldval, int newval)
 {
 	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	return uaccess.futex_atomic_cmpxchg(uaddr, oldval, newval);
+	return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index d6b1ed0..549adf6 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -84,7 +84,7 @@ struct uaccess_ops {
 	size_t (*strnlen_user)(size_t, const char __user *);
 	size_t (*strncpy_from_user)(size_t, const char __user *, char *);
 	int (*futex_atomic_op)(int op, int __user *, int oparg, int *old);
-	int (*futex_atomic_cmpxchg)(int __user *, int old, int new);
+	int (*futex_atomic_cmpxchg)(int *, int __user *, int old, int new);
 };
 
 extern struct uaccess_ops uaccess;
diff --git a/arch/s390/lib/uaccess.h b/arch/s390/lib/uaccess.h
index 126011d..89a8067 100644
--- a/arch/s390/lib/uaccess.h
+++ b/arch/s390/lib/uaccess.h
@@ -12,12 +12,12 @@ extern size_t copy_from_user_std(size_t, const void __user *, void *);
 extern size_t copy_to_user_std(size_t, void __user *, const void *);
 extern size_t strnlen_user_std(size_t, const char __user *);
 extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
-extern int futex_atomic_cmpxchg_std(int __user *, int, int);
+extern int futex_atomic_cmpxchg_std(int *, int __user *, int, int);
 extern int futex_atomic_op_std(int, int __user *, int, int *);
 
 extern size_t copy_from_user_pt(size_t, const void __user *, void *);
 extern size_t copy_to_user_pt(size_t, void __user *, const void *);
 extern int futex_atomic_op_pt(int, int __user *, int, int *);
-extern int futex_atomic_cmpxchg_pt(int __user *, int, int);
+extern int futex_atomic_cmpxchg_pt(int *, int __user *, int, int);
 
 #endif /* __ARCH_S390_LIB_UACCESS_H */
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 404f2de..e4f9ad8 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -354,26 +354,29 @@ int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-static int __futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
+static int __futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
+				     int oldval, int newval)
 {
 	int ret;
 
 	asm volatile("0: cs   %1,%4,0(%5)\n"
-		     "1: lr   %0,%1\n"
+		     "1: l    %0,0\n"
 		     "2:\n"
 		     EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		     : "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		     : "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		     : "cc", "memory" );
+	*uval = oldval;
 	return ret;
 }
 
-int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
+			    int oldval, int newval)
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
index a6c4f7e..5c568b3 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -287,19 +287,21 @@ int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-int futex_atomic_cmpxchg_std(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_std(int *uval, int __user *uaddr,
+			     int oldval, int newval)
 {
 	int ret;
 
 	asm volatile(
 		"   sacf 256\n"
 		"0: cs   %1,%4,0(%5)\n"
-		"1: lr   %0,%1\n"
+		"1: l    %0,0\n"
 		"2: sacf 0\n"
 		EX_TABLE(0b,2b) EX_TABLE(1b,2b)
 		: "=d" (ret), "+d" (oldval), "=m" (*uaddr)
 		: "0" (-EFAULT), "d" (newval), "a" (uaddr), "m" (*uaddr)
 		: "cc", "memory" );
+	*uval = oldval;
 	return ret;
 }
 
diff --git a/arch/sh/include/asm/futex-irq.h b/arch/sh/include/asm/futex-irq.h
index a9f16a7..7b701cb 100644
--- a/arch/sh/include/asm/futex-irq.h
+++ b/arch/sh/include/asm/futex-irq.h
@@ -88,7 +88,8 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
+static inline int atomic_futex_op_cmpxchg_inatomic(int *uval,
+						   int __user *uaddr,
 						   int oldval, int newval)
 {
 	unsigned long flags;
@@ -102,10 +103,8 @@ static inline int atomic_futex_op_cmpxchg_inatomic(int __user *uaddr,
 
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
index 68256ec..a8a5125 100644
--- a/arch/sh/include/asm/futex.h
+++ b/arch/sh/include/asm/futex.h
@@ -65,12 +65,13 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	return atomic_futex_op_cmpxchg_inatomic(uaddr, oldval, newval);
+	return atomic_futex_op_cmpxchg_inatomic(uval, uaddr, oldval, newval);
 }
 
 #endif /* __KERNEL__ */
diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
index 47f9583..e086220 100644
--- a/arch/sparc/include/asm/futex_64.h
+++ b/arch/sparc/include/asm/futex_64.h
@@ -85,26 +85,30 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
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
index fe0d10d..664b20a 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -119,8 +119,8 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
-						int newval)
+static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+						int oldval, int newval)
 {
 	struct __get_user asm_ret;
 
@@ -128,7 +128,8 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
 		return -EFAULT;
 
 	asm_ret = futex_cmpxchg(uaddr, oldval, newval);
-	return asm_ret.err ? asm_ret.err : asm_ret.val;
+	*uval = asm_ret.val;
+	return asm_ret.err;
 }
 
 #ifndef __tilegx__
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index 1f11ce4..884c0b5 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -109,9 +109,10 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
-						int newval)
+static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+						int oldval, int newval)
 {
+	int ret = 0;
 
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
 	/* Real i386 machines have no cmpxchg instruction */
@@ -122,18 +123,19 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
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
index 3c2344f..132bf52 100644
--- a/include/asm-generic/futex.h
+++ b/include/asm-generic/futex.h
@@ -48,7 +48,8 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
+			      int oldval, int newval)
 {
 	return -ENOSYS;
 }
diff --git a/kernel/futex.c b/kernel/futex.c
index 3184d3b..53b783f 100644
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
@@ -688,9 +689,7 @@ retry:
 	if (set_waiters)
 		newval |= FUTEX_WAITERS;
 
-	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
-
-	if (unlikely(curval == -EFAULT))
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, 0, newval)))
 		return -EFAULT;
 
 	/*
@@ -728,9 +727,7 @@ retry:
 		lock_taken = 1;
 	}
 
-	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-	if (unlikely(curval == -EFAULT))
+	if (unlikely(cmpxchg_futex_value_locked(&curval, uaddr, uval, newval)))
 		return -EFAULT;
 	if (unlikely(curval != uval))
 		goto retry;
@@ -843,9 +840,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 
 		newval = FUTEX_WAITERS | task_pid_vnr(new_owner);
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-		if (curval == -EFAULT)
+		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
 			ret = -EFAULT;
 		else if (curval != uval)
 			ret = -EINVAL;
@@ -880,10 +875,8 @@ static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
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
 
@@ -1578,9 +1571,7 @@ retry:
 	while (1) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-		if (curval == -EFAULT)
+		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
 			goto handle_fault;
 		if (curval == uval)
 			break;
@@ -2073,11 +2064,9 @@ retry:
 	 * again. If it succeeds then we can return without waking
 	 * anyone else up:
 	 */
-	if (!(uval & FUTEX_OWNER_DIED))
-		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
-
-
-	if (unlikely(uval == -EFAULT))
+	if (!(uval & FUTEX_OWNER_DIED) &&
+	    unlikely(cmpxchg_futex_value_locked(&uval, uaddr,
+						task_pid_vnr(current), 0)))
 		goto pi_faulted;
 	/*
 	 * Rare case: we managed to release the lock atomically,
@@ -2464,9 +2453,7 @@ retry:
 		 * userspace.
 		 */
 		mval = (uval & FUTEX_WAITERS) | FUTEX_OWNER_DIED;
-		nval = futex_atomic_cmpxchg_inatomic(uaddr, uval, mval);
-
-		if (nval == -EFAULT)
+		if (futex_atomic_cmpxchg_inatomic(&nval, uaddr, uval, mval))
 			return -1;
 
 		if (nval != uval)
@@ -2679,8 +2666,7 @@ static int __init futex_init(void)
 	 * implementation, the non-functional ones will return
 	 * -ENOSYS.
 	 */
-	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
-	if (curval == -EFAULT)
+	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
 	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-- 
1.7.3.1



-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
