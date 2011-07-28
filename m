Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1G1Pv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:51:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab1G1PvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:51:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/40] UAPI: Split trivial #if defined(__KERNEL__) && X
 conditionals [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:51:16 +0100
Message-ID: <20110728155116.16618.54457.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split trivial #if defined(__KERNEL__) && X conditionals to make automated
disintegration easier.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/arm/include/asm/hwcap.h       |    4 +++-
 arch/arm/include/asm/swab.h        |    7 +++++--
 arch/arm/include/asm/unistd.h      |    4 +++-
 arch/ia64/include/asm/intrinsics.h |   21 +++++++++++++--------
 arch/mips/include/asm/types.h      |   10 +++++++---
 arch/s390/include/asm/mman.h       |    4 +++-
 arch/tile/include/asm/signal.h     |    4 +++-
 include/linux/mroute6.h            |    4 +++-
 8 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/arch/arm/include/asm/hwcap.h b/arch/arm/include/asm/hwcap.h
index c93a22a..9176261 100644
--- a/arch/arm/include/asm/hwcap.h
+++ b/arch/arm/include/asm/hwcap.h
@@ -25,7 +25,8 @@
 #define HWCAP_IDIVT	(1 << 18)
 #define HWCAP_IDIV	(HWCAP_IDIVA | HWCAP_IDIVT)
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#if defined(__KERNEL__)
+#if !defined(__ASSEMBLY__)
 /*
  * This yields a mask that user programs can use to figure out what
  * instruction set this cpu supports.
@@ -33,5 +34,6 @@
 #define ELF_HWCAP	(elf_hwcap)
 extern unsigned int elf_hwcap;
 #endif
+#endif
 
 #endif
diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index 9997ad2..e82adf6 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -22,7 +22,8 @@
 #  define __SWAB_64_THRU_32__
 #endif
 
-#if defined(__KERNEL__) && __LINUX_ARM_ARCH__ >= 6
+#if defined(__KERNEL__)
+#if __LINUX_ARM_ARCH__ >= 6
 
 static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
@@ -38,8 +39,10 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 }
 #define __arch_swab32 __arch_swab32
 
-#else
+#endif
+#endif
 
+#if !defined(__KERNEL__) || __LINUX_ARM_ARCH__ < 6
 static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 t;
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 2c04ed5..59d0f02 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -425,7 +425,8 @@
 /*
  * The following syscalls are obsolete and no longer available for EABI.
  */
-#if defined(__ARM_EABI__) && !defined(__KERNEL__)
+#if !defined(__KERNEL__)
+#if defined(__ARM_EABI__)
 #undef __NR_time
 #undef __NR_umount
 #undef __NR_stime
@@ -439,6 +440,7 @@
 #undef __NR_syscall
 #undef __NR_ipc
 #endif
+#endif
 
 #ifdef __KERNEL__
 
diff --git a/arch/ia64/include/asm/intrinsics.h b/arch/ia64/include/asm/intrinsics.h
index 111ed52..e4076b5 100644
--- a/arch/ia64/include/asm/intrinsics.h
+++ b/arch/ia64/include/asm/intrinsics.h
@@ -201,16 +201,21 @@ extern long ia64_cmpxchg_called_with_bad_pointer (void);
 #endif
 
 #ifndef __ASSEMBLY__
-#if defined(CONFIG_PARAVIRT) && defined(__KERNEL__)
-#ifdef ASM_SUPPORTED
-# define IA64_INTRINSIC_API(name)	paravirt_ ## name
-#else
-# define IA64_INTRINSIC_API(name)	pv_cpu_ops.name
-#endif
-#define IA64_INTRINSIC_MACRO(name)	paravirt_ ## name
-#else
+
 #define IA64_INTRINSIC_API(name)	ia64_native_ ## name
 #define IA64_INTRINSIC_MACRO(name)	ia64_native_ ## name
+
+#if defined(__KERNEL__)
+#if defined(CONFIG_PARAVIRT)
+# undef IA64_INTRINSIC_API
+# undef IA64_INTRINSIC_MACRO
+# ifdef ASM_SUPPORTED
+#  define IA64_INTRINSIC_API(name)	paravirt_ ## name
+# else
+#  define IA64_INTRINSIC_API(name)	pv_cpu_ops.name
+# endif
+#define IA64_INTRINSIC_MACRO(name)	paravirt_ ## name
+#endif
 #endif
 
 /************************************************/
diff --git a/arch/mips/include/asm/types.h b/arch/mips/include/asm/types.h
index 533812b..9b96461 100644
--- a/arch/mips/include/asm/types.h
+++ b/arch/mips/include/asm/types.h
@@ -15,10 +15,14 @@
  * We don't use int-l64.h for the kernel anymore but still use it for
  * userspace to avoid code changes.
  */
-#if (_MIPS_SZLONG == 64) && !defined(__KERNEL__)
-# include <asm-generic/int-l64.h>
-#else
+#ifdef __KERNEL__
 # include <asm-generic/int-ll64.h>
+#else
+# if _MIPS_SZLONG == 64
+#  include <asm-generic/int-l64.h>
+# else
+#  include <asm-generic/int-ll64.h>
+# endif
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/s390/include/asm/mman.h b/arch/s390/include/asm/mman.h
index 4e9c8ae..d49760e 100644
--- a/arch/s390/include/asm/mman.h
+++ b/arch/s390/include/asm/mman.h
@@ -11,9 +11,11 @@
 
 #include <asm-generic/mman.h>
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__) && defined(CONFIG_64BIT)
+#if defined(__KERNEL__)
+#if !defined(__ASSEMBLY__) && defined(CONFIG_64BIT)
 int s390_mmap_check(unsigned long addr, unsigned long len);
 #define arch_mmap_check(addr,len,flags)	s390_mmap_check(addr,len)
 #endif
+#endif
 
 #endif /* __S390_MMAN_H__ */
diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
index 1e1e616..1e5e49a 100644
--- a/arch/tile/include/asm/signal.h
+++ b/arch/tile/include/asm/signal.h
@@ -23,7 +23,8 @@
 
 #include <asm-generic/signal.h>
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#if defined(__KERNEL__)
+#if !defined(__ASSEMBLY__)
 struct pt_regs;
 int restore_sigcontext(struct pt_regs *, struct sigcontext __user *);
 int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
@@ -33,5 +34,6 @@ void signal_fault(const char *type, struct pt_regs *,
 void trace_unhandled_signal(const char *type, struct pt_regs *regs,
 			    unsigned long address, int signo);
 #endif
+#endif
 
 #endif /* _ASM_TILE_SIGNAL_H */
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index a3759cb..6d8c725 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -43,9 +43,11 @@ typedef unsigned short mifi_t;
 typedef	__u32		if_mask;
 #define NIFBITS (sizeof(if_mask) * 8)        /* bits per mask */
 
-#if !defined(__KERNEL__) && !defined(DIV_ROUND_UP)
+#if !defined(__KERNEL__)
+#if !defined(DIV_ROUND_UP)
 #define	DIV_ROUND_UP(x,y)	(((x) + ((y) - 1)) / (y))
 #endif
+#endif
 
 typedef struct if_set {
 	if_mask ifs_bits[DIV_ROUND_UP(IF_SETSIZE, NIFBITS)];

