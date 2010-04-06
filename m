Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0DFXEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:04:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:48655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab0DFXE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:04:29 -0400
Date: Tue, 6 Apr 2010 23:04:07 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20100318112015.GC11152@aftab>
References: <20100318112015.GC11152@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/hweight] x86: Add optimized popcnt variants
Message-ID: <tip-d61931d89be506372d01a90d1755f6d0a9fafe2d@git.kernel.org>
Git-Commit-ID: d61931d89be506372d01a90d1755f6d0a9fafe2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 23:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d61931d89be506372d01a90d1755f6d0a9fafe2d
Gitweb:     http://git.kernel.org/tip/d61931d89be506372d01a90d1755f6d0a9fafe2d
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 5 Mar 2010 17:34:46 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 6 Apr 2010 15:52:11 -0700

x86: Add optimized popcnt variants

Add support for the hardware version of the Hamming weight function,
popcnt, present in CPUs which advertize it under CPUID, Function
0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
default lib/hweight.c sw versions.

A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
a 3x speedup on a F10h machine.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100318112015.GC11152@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig                          |    5 ++
 arch/x86/include/asm/alternative.h        |    9 +++-
 arch/x86/include/asm/arch_hweight.h       |   59 +++++++++++++++++++++++++++++
 arch/x86/include/asm/bitops.h             |    4 +-
 include/asm-generic/bitops/arch_hweight.h |   22 +++++++++--
 lib/Makefile                              |    3 +
 lib/hweight.c                             |   20 +++++-----
 scripts/Makefile.lib                      |    4 ++
 8 files changed, 108 insertions(+), 18 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0eacb1f..89d8c54 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -238,6 +238,11 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config ARCH_HWEIGHT_CFLAGS
+	string
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
+	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index b09ec55..67dae51 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -39,9 +39,6 @@
 #define LOCK_PREFIX ""
 #endif
 
-/* This must be included *after* the definition of LOCK_PREFIX */
-#include <asm/cpufeature.h>
-
 struct alt_instr {
 	u8 *instr;		/* original instruction */
 	u8 *replacement;
@@ -96,6 +93,12 @@ static inline int alternatives_text_reserved(void *start, void *end)
       ".previous"
 
 /*
+ * This must be included *after* the definition of ALTERNATIVE due to
+ * <asm/arch_hweight.h>
+ */
+#include <asm/cpufeature.h>
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
new file mode 100644
index 0000000..d1fc3c2
--- /dev/null
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -0,0 +1,59 @@
+#ifndef _ASM_X86_HWEIGHT_H
+#define _ASM_X86_HWEIGHT_H
+
+#ifdef CONFIG_64BIT
+/* popcnt %rdi, %rax */
+#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
+#define REG_IN "D"
+#define REG_OUT "a"
+#else
+/* popcnt %eax, %eax */
+#define POPCNT ".byte 0xf3,0x0f,0xb8,0xc0"
+#define REG_IN "a"
+#define REG_OUT "a"
+#endif
+
+/*
+ * __sw_hweightXX are called from within the alternatives below
+ * and callee-clobbered registers need to be taken care of. See
+ * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
+ * compiler switches.
+ */
+static inline unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+
+	return res;
+}
+
+static inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __arch_hweight32(w & 0xffff);
+}
+
+static inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight32(w & 0xff);
+}
+
+static inline unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned long res = 0;
+
+#ifdef CONFIG_X86_32
+	return  __arch_hweight32((u32)w) +
+		__arch_hweight32((u32)(w >> 32));
+#else
+	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+#endif /* CONFIG_X86_32 */
+
+	return res;
+}
+
+#endif
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..545776e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,9 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm/arch_hweight.h>
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 3a7be84..9a81c1e 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,9 +3,23 @@
 
 #include <asm/types.h>
 
-extern unsigned int __arch_hweight32(unsigned int w);
-extern unsigned int __arch_hweight16(unsigned int w);
-extern unsigned int __arch_hweight8(unsigned int w);
-extern unsigned long __arch_hweight64(__u64 w);
+inline unsigned int __arch_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
 
+inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __sw_hweight16(w);
+}
+
+inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __sw_hweight8(w);
+}
+
+inline unsigned long __arch_hweight64(__u64 w)
+{
+	return __sw_hweight64(w);
+}
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/lib/Makefile b/lib/Makefile
index 2e152ae..abe63a8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,10 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
diff --git a/lib/hweight.c b/lib/hweight.c
index a6927e7..3c79d50 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int __arch_hweight32(unsigned int w)
+unsigned int __sw_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,30 +24,30 @@ unsigned int __arch_hweight32(unsigned int w)
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(__arch_hweight32);
+EXPORT_SYMBOL(__sw_hweight32);
 
-unsigned int __arch_hweight16(unsigned int w)
+unsigned int __sw_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(__arch_hweight16);
+EXPORT_SYMBOL(__sw_hweight16);
 
-unsigned int __arch_hweight8(unsigned int w)
+unsigned int __sw_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(__arch_hweight8);
+EXPORT_SYMBOL(__sw_hweight8);
 
-unsigned long __arch_hweight64(__u64 w)
+unsigned long __sw_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return __arch_hweight32((unsigned int)(w >> 32)) +
-	       __arch_hweight32((unsigned int)w);
+	return __sw_hweight32((unsigned int)(w >> 32)) +
+	       __sw_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -64,4 +64,4 @@ unsigned long __arch_hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(__arch_hweight64);
+EXPORT_SYMBOL(__sw_hweight64);
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index f9bdf26..cbcd654 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -245,3 +245,7 @@ quiet_cmd_lzo = LZO    $@
 cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+# misc stuff
+# ---------------------------------------------------------------------------
+quote:="
