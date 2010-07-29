Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0G2UNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:40577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab0G2UNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:13:36 -0400
Date: Thu, 29 Jul 2010 20:13:18 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
References: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Merge cmpxchg_486_u64() and cmpxchg8b_emu()
Message-ID: <tip-a378d9338e8dde78314b3a6ae003de351936c729@git.kernel.org>
Git-Commit-ID: a378d9338e8dde78314b3a6ae003de351936c729
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 20:13:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a378d9338e8dde78314b3a6ae003de351936c729
Gitweb:     http://git.kernel.org/tip/a378d9338e8dde78314b3a6ae003de351936c729
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Jul 2010 17:05:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 28 Jul 2010 17:05:11 -0700

x86, asm: Merge cmpxchg_486_u64() and cmpxchg8b_emu()

We have two functions for doing exactly the same thing -- emulating
cmpxchg8b on 486 and older hardware -- with different calling
conventions, and yet doing the same thing.  Drop the C version and use
the assembly version, via alternatives, for both the local and
non-local versions of cmpxchg8b.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
---
 arch/x86/include/asm/cmpxchg_32.h |   30 ++++++++++++++----------------
 arch/x86/lib/cmpxchg.c            |   18 ------------------
 2 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index f5bd1fd..284a6e8 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -246,8 +246,6 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
  * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
  */
 
-extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
-
 #define cmpxchg64(ptr, o, n)					\
 ({								\
 	__typeof__(*(ptr)) __ret;				\
@@ -265,20 +263,20 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 	__ret; })
 
 
-
-#define cmpxchg64_local(ptr, o, n)					\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg64_local((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	__ret;								\
-})
+#define cmpxchg64_local(ptr, o, n)				\
+({								\
+	__typeof__(*(ptr)) __ret;				\
+	__typeof__(*(ptr)) __old = (o);				\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io("call cmpxchg8b_emu",			\
+		       "cmpxchg8b (%%esi)" ,			\
+		       X86_FEATURE_CX8,				\
+		       "=A" (__ret),				\
+		       "S" ((ptr)), "0" (__old),		\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		       : "memory");				\
+	__ret; })
 
 #endif
 
diff --git a/arch/x86/lib/cmpxchg.c b/arch/x86/lib/cmpxchg.c
index 2056ccf..5d619f6 100644
--- a/arch/x86/lib/cmpxchg.c
+++ b/arch/x86/lib/cmpxchg.c
@@ -52,21 +52,3 @@ unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
 }
 EXPORT_SYMBOL(cmpxchg_386_u32);
 #endif
-
-#ifndef CONFIG_X86_CMPXCHG64
-unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
-{
-	u64 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u64 *)ptr;
-	if (prev == old)
-		*(u64 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_486_u64);
-#endif
-
