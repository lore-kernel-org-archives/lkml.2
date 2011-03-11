Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1CKCvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:51:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1CKCvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dYKLsYIBakTEWNyyMKoedTn86wGRUpYaWrEEqJguLPcNFDZn6ORR6BqoirlN87Spjn
         InnXWd51n7GZqYdGCOHg==
Date: Thu, 10 Mar 2011 18:50:58 -0800
From: Michel Lespinasse <walken@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
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
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] futex: fix futex operation types
Message-ID: <20110311025058.GD26122@google.com>
References: <20110307021127.GB31188@google.com>
 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
 <20110309112550.GA3050@google.com>
 <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
 <20110311021654.GA26122@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311021654.GA26122@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
prototypes to use u32 types for the futex.
    
Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/arch/alpha/include/asm/futex.h b/arch/alpha/include/asm/futex.h
index c4e5c28..e8a761a 100644
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
@@ -81,12 +81,13 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int ret = 0, prev, cmp;
+	int ret = 0, cmp;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	__asm__ __volatile__ (
diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index d20b78f..0e29d8e 100644
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
@@ -88,12 +88,13 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int ret = 0, val;
+	int ret = 0;
+	u32 val;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
diff --git a/arch/frv/include/asm/futex.h b/arch/frv/include/asm/futex.h
index 0548f8e..4bea27f 100644
--- a/arch/frv/include/asm/futex.h
+++ b/arch/frv/include/asm/futex.h
@@ -7,11 +7,11 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
+extern int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr);
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
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
index b072840..8428525 100644
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
@@ -100,10 +100,10 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	{
diff --git a/arch/microblaze/include/asm/futex.h b/arch/microblaze/include/asm/futex.h
index fa019ed..b0526d2 100644
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
@@ -94,12 +94,13 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int ret = 0, prev, cmp;
+	int ret = 0, cmp;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	__asm__ __volatile__ ("1:	lwx	%1, %3, r0;		\
diff --git a/arch/mips/include/asm/futex.h b/arch/mips/include/asm/futex.h
index 692a24b..6ebf173 100644
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
@@ -132,12 +132,13 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int ret = 0, val;
+	int ret = 0;
+	u32 val;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	if (cpu_has_llsc && R10000_LLSC_WAR) {
diff --git a/arch/parisc/include/asm/futex.h b/arch/parisc/include/asm/futex.h
index 4c6d867..67a33cc 100644
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
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int val;
+	u32 val;
 
 	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
 	 * our gateway page, and causes no end of trouble...
@@ -62,7 +62,7 @@ futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
 	if (segment_eq(KERNEL_DS, get_fs()) && !uaddr)
 		return -EFAULT;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	if (get_user(val, uaddr))
diff --git a/arch/powerpc/include/asm/futex.h b/arch/powerpc/include/asm/futex.h
index 631e8da..c94e4a3 100644
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
@@ -82,12 +82,13 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	int ret = 0, prev;
+	int ret = 0;
+	u32 prev;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
         __asm__ __volatile__ (
diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 27ac515..81cf36b 100644
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
@@ -39,10 +39,10 @@ static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-						int oldval, int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(int)))
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 549adf6..2d9ea11f 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -83,8 +83,8 @@ struct uaccess_ops {
 	size_t (*clear_user)(size_t, void __user *);
 	size_t (*strnlen_user)(size_t, const char __user *);
 	size_t (*strncpy_from_user)(size_t, const char __user *, char *);
-	int (*futex_atomic_op)(int op, int __user *, int oparg, int *old);
-	int (*futex_atomic_cmpxchg)(int *, int __user *, int old, int new);
+	int (*futex_atomic_op)(int op, u32 __user *, int oparg, int *old);
+	int (*futex_atomic_cmpxchg)(u32 *, u32 __user *, u32 old, u32 new);
 };
 
 extern struct uaccess_ops uaccess;
diff --git a/arch/s390/lib/uaccess.h b/arch/s390/lib/uaccess.h
index 89a8067..1d2536c 100644
--- a/arch/s390/lib/uaccess.h
+++ b/arch/s390/lib/uaccess.h
@@ -12,12 +12,12 @@ extern size_t copy_from_user_std(size_t, const void __user *, void *);
 extern size_t copy_to_user_std(size_t, void __user *, const void *);
 extern size_t strnlen_user_std(size_t, const char __user *);
 extern size_t strncpy_from_user_std(size_t, const char __user *, char *);
-extern int futex_atomic_cmpxchg_std(int *, int __user *, int, int);
-extern int futex_atomic_op_std(int, int __user *, int, int *);
+extern int futex_atomic_cmpxchg_std(u32 *, u32 __user *, u32, u32);
+extern int futex_atomic_op_std(int, u32 __user *, int, int *);
 
 extern size_t copy_from_user_pt(size_t, const void __user *, void *);
 extern size_t copy_to_user_pt(size_t, void __user *, const void *);
-extern int futex_atomic_op_pt(int, int __user *, int, int *);
-extern int futex_atomic_cmpxchg_pt(int *, int __user *, int, int);
+extern int futex_atomic_op_pt(int, u32 __user *, int, int *);
+extern int futex_atomic_cmpxchg_pt(u32 *, u32 __user *, u32, u32);
 
 #endif /* __ARCH_S390_LIB_UACCESS_H */
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index b3cebcd..7483383 100644
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
 
@@ -354,8 +354,8 @@ int futex_atomic_op_pt(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-static int __futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
-				     int oldval, int newval)
+static int __futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
+				     u32 oldval, u32 newval)
 {
 	int ret;
 
@@ -370,8 +370,8 @@ static int __futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
 	return ret;
 }
 
-int futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
-			    int oldval, int newval)
+int futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
+			    u32 oldval, u32 newval)
 {
 	int ret;
 
diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
index 1d6643c..bb1a7ee 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -255,7 +255,7 @@ size_t strncpy_from_user_std(size_t size, const char __user *src, char *dst)
 		: "0" (-EFAULT), "d" (oparg), "a" (uaddr),		\
 		  "m" (*uaddr) : "cc");
 
-int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
+int futex_atomic_op_std(int op, u32 __user *uaddr, int oparg, int *old)
 {
 	int oldval = 0, newval, ret;
 
@@ -287,8 +287,8 @@ int futex_atomic_op_std(int op, int __user *uaddr, int oparg, int *old)
 	return ret;
 }
 
-int futex_atomic_cmpxchg_std(int *uval, int __user *uaddr,
-			     int oldval, int newval)
+int futex_atomic_cmpxchg_std(u32 *uval, u32 __user *uaddr,
+			     u32 oldval, u32 newval)
 {
 	int ret;
 
diff --git a/arch/sh/include/asm/futex-irq.h b/arch/sh/include/asm/futex-irq.h
index 7b701cb..6cb9f19 100644
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
@@ -88,12 +88,13 @@ static inline int atomic_futex_op_xchg_xor(int oparg, int __user *uaddr,
 	return ret;
 }
 
-static inline int atomic_futex_op_cmpxchg_inatomic(int *uval,
-						   int __user *uaddr,
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
 
diff --git a/arch/sh/include/asm/futex.h b/arch/sh/include/asm/futex.h
index a8a5125..7be39a6 100644
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
@@ -65,10 +65,10 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	return atomic_futex_op_cmpxchg_inatomic(uval, uaddr, oldval, newval);
diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
index e086220..444e7be 100644
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
@@ -85,8 +85,8 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
 	int ret = 0;
 
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index 664b20a..d03ec12 100644
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
@@ -119,12 +119,12 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-						int oldval, int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
 	struct __get_user asm_ret;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	asm_ret = futex_cmpxchg(uaddr, oldval, newval);
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index 884c0b5..d09bb03 100644
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
@@ -109,8 +109,8 @@ static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 	return ret;
 }
 
-static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-						int oldval, int newval)
+static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+						u32 oldval, u32 newval)
 {
 	int ret = 0;
 
@@ -120,7 +120,7 @@ static inline int futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
 		return -ENOSYS;
 #endif
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
 	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
index 132bf52..01f227e 100644
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
@@ -48,8 +48,8 @@ futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 }
 
 static inline int
-futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
-			      int oldval, int newval)
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
+			      u32 oldval, u32 newval)
 {
 	return -ENOSYS;
 }
-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
