Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2LAAh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:37:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2LAAh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:37:57 -0500
Date: Fri, 30 Nov 2012 16:37:46 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-e5bb8ad862a97a0facc83f3b81731de919fec6ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354132230-21854-5-git-send-email-hpa@linux.intel.com>
References: <1354132230-21854-5-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal: Remove CONFIG_BSWAP
Git-Commit-ID: e5bb8ad862a97a0facc83f3b81731de919fec6ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:37:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5bb8ad862a97a0facc83f3b81731de919fec6ad
Gitweb:     http://git.kernel.org/tip/e5bb8ad862a97a0facc83f3b81731de919fec6ad
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Nov 2012 11:50:26 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:23:02 -0800

x86, 386 removal: Remove CONFIG_BSWAP

All 486+ CPUs support BSWAP, so remove the fallback 386 support
code.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1354132230-21854-5-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig.cpu         |  4 ----
 arch/x86/include/asm/futex.h | 12 ------------
 arch/x86/include/asm/swab.h  | 29 ++---------------------------
 arch/x86/kernel/cpu/bugs.c   | 13 ++-----------
 4 files changed, 4 insertions(+), 54 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 52955ee..8e5867c 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -332,10 +332,6 @@ config X86_INVLPG
 	def_bool y
 	depends on X86_32
 
-config X86_BSWAP
-	def_bool y
-	depends on X86_32
-
 config X86_POPAD_OK
 	def_bool y
 	depends on X86_32
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index f373046..be27ba1 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -55,12 +55,6 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
-	/* Real i386 machines can only support FUTEX_OP_SET */
-	if (op != FUTEX_OP_SET && boot_cpu_data.x86 == 3)
-		return -ENOSYS;
-#endif
-
 	pagefault_disable();
 
 	switch (op) {
@@ -118,12 +112,6 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 {
 	int ret = 0;
 
-#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
-	/* Real i386 machines have no cmpxchg instruction */
-	if (boot_cpu_data.x86 == 3)
-		return -ENOSYS;
-#endif
-
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 557cd9f..7f235c7 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -6,22 +6,7 @@
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (val) : "0" (val));
-# else
-	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-	    "rorl $16,%0\n\t"	/* swap words		*/
-	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (val)
-	    : "0" (val));
-# endif
-
-#else /* __i386__ */
-	asm("bswapl %0"
-	    : "=r" (val)
-	    : "0" (val));
-#endif
+	asm("bswapl %0" : "=r" (val) : "0" (val));
 	return val;
 }
 #define __arch_swab32 __arch_swab32
@@ -37,22 +22,12 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-# else
-	v.s.a = __arch_swab32(v.s.a);
-	v.s.b = __arch_swab32(v.s.b);
-	asm("xchgl %0,%1"
-	    : "=r" (v.s.a), "=r" (v.s.b)
-	    : "0" (v.s.a), "1" (v.s.b));
-# endif
 	return v.u;
 #else /* __i386__ */
-	asm("bswapq %0"
-	    : "=r" (val)
-	    : "0" (val));
+	asm("bswapq %0" : "=r" (val) : "0" (val));
 	return val;
 #endif
 }
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d0e910d..0cd07cc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -136,24 +136,15 @@ static void __init check_popad(void)
 /*
  * Check whether we are able to run this kernel safely on SMP.
  *
- * - In order to run on a i386, we need to be compiled for i386
- *   (for due to lack of "invlpg" and working WP on a i386)
+ * - i386 is no longer supported.
  * - In order to run on anything without a TSC, we need to be
  *   compiled for a i486.
  */
 
 static void __init check_config(void)
 {
-/*
- * We'd better not be a i386 if we're configured to use some
- * i486+ only features! (WP works in supervisor mode and the
- * new "invlpg" and "bswap" instructions)
- */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || \
-	defined(CONFIG_X86_BSWAP)
-	if (boot_cpu_data.x86 == 3)
+	if (boot_cpu_data.x86 < 4)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
-#endif
 }
 
 
