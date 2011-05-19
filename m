Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757Ab1ESUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:50:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52429 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab1ESUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:50:10 -0400
Date: Thu, 19 May 2011 22:49:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v2.6.40
Message-ID: <20110519204955.GA1395@elte.hu>
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

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86, AMD, cacheinfo: Fix fallout caused by max3 conversion
      Documentation, ABI: Update L3 cache index disable text

Frank Arnold (1):
      x86, AMD, cacheinfo: Fix L3 cache index disable checks

H. Peter Anvin (3):
      x86, percpu: Use ASM_NOP4 instead of hardcoding P6_NOP4
      x86, cpu: Clean up and unify the NOP selection infrastructure
      x86, cpu: Change NOP selection for certain Intel CPUs

Ian Campbell (1):
      x86, cpu: Move AMD Elan Kconfig under "Processor family"

Ondrej Zary (1):
      x86, cpu: Fix detection of Celeron Covington stepping A1 and B0


 Documentation/ABI/testing/sysfs-devices-system-cpu |   34 ++--
 arch/x86/Kconfig                                   |   11 -
 arch/x86/Kconfig.cpu                               |   16 +-
 arch/x86/Makefile_32.cpu                           |    2 +-
 arch/x86/include/asm/alternative.h                 |    8 -
 arch/x86/include/asm/module.h                      |    2 +-
 arch/x86/include/asm/nops.h                        |  146 +++++++++-------
 arch/x86/include/asm/percpu.h                      |    2 +-
 arch/x86/kernel/alternative.c                      |  194 +++++++++++--------
 arch/x86/kernel/cpu/cpufreq/Kconfig                |    4 +-
 arch/x86/kernel/cpu/intel.c                        |   10 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |   20 +--
 arch/x86/kernel/ftrace.c                           |    4 +-
 arch/x86/kernel/jump_label.c                       |    5 +-
 arch/x86/kernel/setup.c                            |    6 +-
 15 files changed, 242 insertions(+), 222 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 7564e88..e7be75b 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -183,21 +183,21 @@ Description:	Discover and change clock speed of CPUs
 		to learn how to control the knobs.
 
 
-What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
-Date:      August 2008
+What:		/sys/devices/system/cpu/cpu*/cache/index3/cache_disable_{0,1}
+Date:		August 2008
 KernelVersion:	2.6.27
-Contact:	mark.langsdorf@amd.com
-Description:	These files exist in every cpu's cache index directories.
-		There are currently 2 cache_disable_# files in each
-		directory.  Reading from these files on a supported
-		processor will return that cache disable index value
-		for that processor and node.  Writing to one of these
-		files will cause the specificed cache index to be disabled.
-
-		Currently, only AMD Family 10h Processors support cache index
-		disable, and only for their L3 caches.  See the BIOS and
-		Kernel Developer's Guide at
-		http://support.amd.com/us/Embedded_TechDocs/31116-Public-GH-BKDG_3-28_5-28-09.pdf	
-		for formatting information and other details on the
-		cache index disable.
-Users:    joachim.deguara@amd.com
+Contact:	discuss@x86-64.org
+Description:	Disable L3 cache indices
+
+		These files exist in every CPU's cache/index3 directory. Each
+		cache_disable_{0,1} file corresponds to one disable slot which
+		can be used to disable a cache index. Reading from these files
+		on a processor with this functionality will return the currently
+		disabled index for that node. There is one L3 structure per
+		node, or per internal node on MCM machines. Writing a valid
+		index to one of these files will cause the specificed cache
+		index to be disabled.
+
+		All AMD processors with L3 caches provide this functionality.
+		For details, see BKDGs at
+		http://developer.amd.com/documentation/guides/Pages/default.aspx
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..f00a3f3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -365,17 +365,6 @@ config X86_UV
 # Following is an alphabetically sorted list of 32 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
-config X86_ELAN
-	bool "AMD Elan"
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select this for an AMD Elan processor.
-
-	  Do not use this option for K6/Athlon/Opteron processors!
-
-	  If unsure, choose "PC-compatible" instead.
-
 config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d161e93..6a7cfdf 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -1,6 +1,4 @@
 # Put here option for CPU selection and depending optimization
-if !X86_ELAN
-
 choice
 	prompt "Processor family"
 	default M686 if X86_32
@@ -203,6 +201,14 @@ config MWINCHIP3D
 	  stores for this CPU, which can increase performance of some
 	  operations.
 
+config MELAN
+	bool "AMD Elan"
+	depends on X86_32
+	---help---
+	  Select this for an AMD Elan processor.
+
+	  Do not use this option for K6/Athlon/Opteron processors!
+
 config MGEODEGX1
 	bool "GeodeGX1"
 	depends on X86_32
@@ -292,8 +298,6 @@ config X86_GENERIC
 	  This is really intended for distributors who need more
 	  generic optimizations.
 
-endif
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT
@@ -312,7 +316,7 @@ config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
-	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
+	default "4" if MELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
 config X86_XADD
@@ -358,7 +362,7 @@ config X86_POPAD_OK
 
 config X86_ALIGNMENT_16
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
 
 config X86_INTEL_USERCOPY
 	def_bool y
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index f2ee1ab..86cee7b 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -37,7 +37,7 @@ cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=
 	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
 
 # AMD Elan support
-cflags-$(CONFIG_X86_ELAN)	+= -march=i486
+cflags-$(CONFIG_MELAN)		+= -march=i486
 
 # Geode GX1 support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 13009d1..7da1682 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -191,12 +191,4 @@ extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 extern void text_poke_smp_batch(struct text_poke_param *params, int n);
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-#define IDEAL_NOP_SIZE_5 5
-extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-extern void arch_init_ideal_nop5(void);
-#else
-static inline void arch_init_ideal_nop5(void) {}
-#endif
-
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 67763c5..9eae775 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -35,7 +35,7 @@
 #define MODULE_PROC_FAMILY "K7 "
 #elif defined CONFIG_MK8
 #define MODULE_PROC_FAMILY "K8 "
-#elif defined CONFIG_X86_ELAN
+#elif defined CONFIG_MELAN
 #define MODULE_PROC_FAMILY "ELAN "
 #elif defined CONFIG_MCRUSOE
 #define MODULE_PROC_FAMILY "CRUSOE "
diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index af78849..405b403 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -1,7 +1,13 @@
 #ifndef _ASM_X86_NOPS_H
 #define _ASM_X86_NOPS_H
 
-/* Define nops for use with alternative() */
+/*
+ * Define nops for use with alternative() and for tracing.
+ *
+ * *_NOP5_ATOMIC must be a single instruction.
+ */
+
+#define NOP_DS_PREFIX 0x3e
 
 /* generic versions from gas
    1: nop
@@ -13,14 +19,15 @@
    6: leal 0x00000000(%esi),%esi
    7: leal 0x00000000(,%esi,1),%esi
 */
-#define GENERIC_NOP1 ".byte 0x90\n"
-#define GENERIC_NOP2 ".byte 0x89,0xf6\n"
-#define GENERIC_NOP3 ".byte 0x8d,0x76,0x00\n"
-#define GENERIC_NOP4 ".byte 0x8d,0x74,0x26,0x00\n"
-#define GENERIC_NOP5 GENERIC_NOP1 GENERIC_NOP4
-#define GENERIC_NOP6 ".byte 0x8d,0xb6,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP7 ".byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00\n"
-#define GENERIC_NOP8 GENERIC_NOP1 GENERIC_NOP7
+#define GENERIC_NOP1 0x90
+#define GENERIC_NOP2 0x89,0xf6
+#define GENERIC_NOP3 0x8d,0x76,0x00
+#define GENERIC_NOP4 0x8d,0x74,0x26,0x00
+#define GENERIC_NOP5 GENERIC_NOP1,GENERIC_NOP4
+#define GENERIC_NOP6 0x8d,0xb6,0x00,0x00,0x00,0x00
+#define GENERIC_NOP7 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
+#define GENERIC_NOP8 GENERIC_NOP1,GENERIC_NOP7
+#define GENERIC_NOP5_ATOMIC NOP_DS_PREFIX,GENERIC_NOP4
 
 /* Opteron 64bit nops
    1: nop
@@ -29,13 +36,14 @@
    4: osp osp osp nop
 */
 #define K8_NOP1 GENERIC_NOP1
-#define K8_NOP2	".byte 0x66,0x90\n"
-#define K8_NOP3	".byte 0x66,0x66,0x90\n"
-#define K8_NOP4	".byte 0x66,0x66,0x66,0x90\n"
-#define K8_NOP5	K8_NOP3 K8_NOP2
-#define K8_NOP6	K8_NOP3 K8_NOP3
-#define K8_NOP7	K8_NOP4 K8_NOP3
-#define K8_NOP8	K8_NOP4 K8_NOP4
+#define K8_NOP2	0x66,K8_NOP1
+#define K8_NOP3	0x66,K8_NOP2
+#define K8_NOP4	0x66,K8_NOP3
+#define K8_NOP5	K8_NOP3,K8_NOP2
+#define K8_NOP6	K8_NOP3,K8_NOP3
+#define K8_NOP7	K8_NOP4,K8_NOP3
+#define K8_NOP8	K8_NOP4,K8_NOP4
+#define K8_NOP5_ATOMIC 0x66,K8_NOP4
 
 /* K7 nops
    uses eax dependencies (arbitrary choice)
@@ -47,13 +55,14 @@
    7: leal 0x00000000(,%eax,1),%eax
 */
 #define K7_NOP1	GENERIC_NOP1
-#define K7_NOP2	".byte 0x8b,0xc0\n"
-#define K7_NOP3	".byte 0x8d,0x04,0x20\n"
-#define K7_NOP4	".byte 0x8d,0x44,0x20,0x00\n"
-#define K7_NOP5	K7_NOP4 ASM_NOP1
-#define K7_NOP6	".byte 0x8d,0x80,0,0,0,0\n"
-#define K7_NOP7	".byte 0x8D,0x04,0x05,0,0,0,0\n"
-#define K7_NOP8	K7_NOP7 ASM_NOP1
+#define K7_NOP2	0x8b,0xc0
+#define K7_NOP3	0x8d,0x04,0x20
+#define K7_NOP4	0x8d,0x44,0x20,0x00
+#define K7_NOP5	K7_NOP4,K7_NOP1
+#define K7_NOP6	0x8d,0x80,0,0,0,0
+#define K7_NOP7	0x8D,0x04,0x05,0,0,0,0
+#define K7_NOP8	K7_NOP7,K7_NOP1
+#define K7_NOP5_ATOMIC NOP_DS_PREFIX,K7_NOP4
 
 /* P6 nops
    uses eax dependencies (Intel-recommended choice)
@@ -69,52 +78,65 @@
 	There is kernel code that depends on this.
 */
 #define P6_NOP1	GENERIC_NOP1
-#define P6_NOP2	".byte 0x66,0x90\n"
-#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
-#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
-#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
-#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
-#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+#define P6_NOP2	0x66,0x90
+#define P6_NOP3	0x0f,0x1f,0x00
+#define P6_NOP4	0x0f,0x1f,0x40,0
+#define P6_NOP5	0x0f,0x1f,0x44,0x00,0
+#define P6_NOP6	0x66,0x0f,0x1f,0x44,0x00,0
+#define P6_NOP7	0x0f,0x1f,0x80,0,0,0,0
+#define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
+#define P6_NOP5_ATOMIC P6_NOP5
+
+#define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
 
 #if defined(CONFIG_MK7)
-#define ASM_NOP1 K7_NOP1
-#define ASM_NOP2 K7_NOP2
-#define ASM_NOP3 K7_NOP3
-#define ASM_NOP4 K7_NOP4
-#define ASM_NOP5 K7_NOP5
-#define ASM_NOP6 K7_NOP6
-#define ASM_NOP7 K7_NOP7
-#define ASM_NOP8 K7_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(K7_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(K7_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(K7_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(K7_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(K7_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(K7_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(K7_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(K7_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(K7_NOP5_ATOMIC)
 #elif defined(CONFIG_X86_P6_NOP)
-#define ASM_NOP1 P6_NOP1
-#define ASM_NOP2 P6_NOP2
-#define ASM_NOP3 P6_NOP3
-#define ASM_NOP4 P6_NOP4
-#define ASM_NOP5 P6_NOP5
-#define ASM_NOP6 P6_NOP6
-#define ASM_NOP7 P6_NOP7
-#define ASM_NOP8 P6_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(P6_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(P6_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(P6_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(P6_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(P6_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(P6_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(P6_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(P6_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(P6_NOP5_ATOMIC)
 #elif defined(CONFIG_X86_64)
-#define ASM_NOP1 K8_NOP1
-#define ASM_NOP2 K8_NOP2
-#define ASM_NOP3 K8_NOP3
-#define ASM_NOP4 K8_NOP4
-#define ASM_NOP5 K8_NOP5
-#define ASM_NOP6 K8_NOP6
-#define ASM_NOP7 K8_NOP7
-#define ASM_NOP8 K8_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(K8_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(K8_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(K8_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(K8_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(K8_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(K8_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(K8_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(K8_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(K8_NOP5_ATOMIC)
 #else
-#define ASM_NOP1 GENERIC_NOP1
-#define ASM_NOP2 GENERIC_NOP2
-#define ASM_NOP3 GENERIC_NOP3
-#define ASM_NOP4 GENERIC_NOP4
-#define ASM_NOP5 GENERIC_NOP5
-#define ASM_NOP6 GENERIC_NOP6
-#define ASM_NOP7 GENERIC_NOP7
-#define ASM_NOP8 GENERIC_NOP8
+#define ASM_NOP1 _ASM_MK_NOP(GENERIC_NOP1)
+#define ASM_NOP2 _ASM_MK_NOP(GENERIC_NOP2)
+#define ASM_NOP3 _ASM_MK_NOP(GENERIC_NOP3)
+#define ASM_NOP4 _ASM_MK_NOP(GENERIC_NOP4)
+#define ASM_NOP5 _ASM_MK_NOP(GENERIC_NOP5)
+#define ASM_NOP6 _ASM_MK_NOP(GENERIC_NOP6)
+#define ASM_NOP7 _ASM_MK_NOP(GENERIC_NOP7)
+#define ASM_NOP8 _ASM_MK_NOP(GENERIC_NOP8)
+#define ASM_NOP5_ATOMIC _ASM_MK_NOP(GENERIC_NOP5_ATOMIC)
 #endif
 
 #define ASM_NOP_MAX 8
+#define NOP_ATOMIC5 (ASM_NOP_MAX+1)	/* Entry for the 5-byte atomic NOP */
+
+#ifndef __ASSEMBLY__
+extern const unsigned char * const *ideal_nops;
+extern void arch_init_ideal_nops(void);
+#endif
 
 #endif /* _ASM_X86_NOPS_H */
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d475b43..751e7f3 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -517,7 +517,7 @@ do {									\
 	typeof(o2) __o2 = o2;						\
 	typeof(o2) __n2 = n2;						\
 	typeof(o2) __dummy;						\
-	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
+	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP4,	\
 		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
 		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4a23467..c0501ea 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -67,17 +67,30 @@ __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
+/*
+ * Each GENERIC_NOPX is of X bytes, and defined as an array of bytes
+ * that correspond to that nop. Getting from one nop to the next, we
+ * add to the array the offset that is equal to the sum of all sizes of
+ * nops preceding the one we are after.
+ *
+ * Note: The GENERIC_NOP5_ATOMIC is at the end, as it breaks the
+ * nice symmetry of sizes of the previous nops.
+ */
 #if defined(GENERIC_NOP1) && !defined(CONFIG_X86_64)
-/* Use inline assembly to define this because the nops are defined
-   as inline assembly strings in the include files and we cannot
-   get them easily into strings. */
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nintelnops: "
-	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
-	GENERIC_NOP7 GENERIC_NOP8
-    "\t.previous");
-extern const unsigned char intelnops[];
-static const unsigned char *const __initconst_or_module
-intel_nops[ASM_NOP_MAX+1] = {
+static const unsigned char intelnops[] =
+{
+	GENERIC_NOP1,
+	GENERIC_NOP2,
+	GENERIC_NOP3,
+	GENERIC_NOP4,
+	GENERIC_NOP5,
+	GENERIC_NOP6,
+	GENERIC_NOP7,
+	GENERIC_NOP8,
+	GENERIC_NOP5_ATOMIC
+};
+static const unsigned char * const intel_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -87,17 +100,25 @@ intel_nops[ASM_NOP_MAX+1] = {
 	intelnops + 1 + 2 + 3 + 4 + 5,
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6,
 	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	intelnops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #ifdef K8_NOP1
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk8nops: "
-	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
-	K8_NOP7 K8_NOP8
-    "\t.previous");
-extern const unsigned char k8nops[];
-static const unsigned char *const __initconst_or_module
-k8_nops[ASM_NOP_MAX+1] = {
+static const unsigned char k8nops[] =
+{
+	K8_NOP1,
+	K8_NOP2,
+	K8_NOP3,
+	K8_NOP4,
+	K8_NOP5,
+	K8_NOP6,
+	K8_NOP7,
+	K8_NOP8,
+	K8_NOP5_ATOMIC
+};
+static const unsigned char * const k8_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -107,17 +128,25 @@ k8_nops[ASM_NOP_MAX+1] = {
 	k8nops + 1 + 2 + 3 + 4 + 5,
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k8nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	k8nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #if defined(K7_NOP1) && !defined(CONFIG_X86_64)
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk7nops: "
-	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
-	K7_NOP7 K7_NOP8
-    "\t.previous");
-extern const unsigned char k7nops[];
-static const unsigned char *const __initconst_or_module
-k7_nops[ASM_NOP_MAX+1] = {
+static const unsigned char k7nops[] =
+{
+	K7_NOP1,
+	K7_NOP2,
+	K7_NOP3,
+	K7_NOP4,
+	K7_NOP5,
+	K7_NOP6,
+	K7_NOP7,
+	K7_NOP8,
+	K7_NOP5_ATOMIC
+};
+static const unsigned char * const k7_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -127,17 +156,25 @@ k7_nops[ASM_NOP_MAX+1] = {
 	k7nops + 1 + 2 + 3 + 4 + 5,
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6,
 	k7nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	k7nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
 #ifdef P6_NOP1
-asm("\t" __stringify(__INITRODATA_OR_MODULE) "\np6nops: "
-	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
-	P6_NOP7 P6_NOP8
-    "\t.previous");
-extern const unsigned char p6nops[];
-static const unsigned char *const __initconst_or_module
-p6_nops[ASM_NOP_MAX+1] = {
+static const unsigned char  __initconst_or_module p6nops[] =
+{
+	P6_NOP1,
+	P6_NOP2,
+	P6_NOP3,
+	P6_NOP4,
+	P6_NOP5,
+	P6_NOP6,
+	P6_NOP7,
+	P6_NOP8,
+	P6_NOP5_ATOMIC
+};
+static const unsigned char * const p6_nops[ASM_NOP_MAX+2] =
+{
 	NULL,
 	p6nops,
 	p6nops + 1,
@@ -147,47 +184,65 @@ p6_nops[ASM_NOP_MAX+1] = {
 	p6nops + 1 + 2 + 3 + 4 + 5,
 	p6nops + 1 + 2 + 3 + 4 + 5 + 6,
 	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8,
 };
 #endif
 
+/* Initialize these to a safe default */
 #ifdef CONFIG_X86_64
+const unsigned char * const *ideal_nops = p6_nops;
+#else
+const unsigned char * const *ideal_nops = intel_nops;
+#endif
 
-extern char __vsyscall_0;
-static const unsigned char *const *__init_or_module find_nop_table(void)
+void __init arch_init_ideal_nops(void)
 {
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-	    boot_cpu_has(X86_FEATURE_NOPL))
-		return p6_nops;
-	else
-		return k8_nops;
-}
-
-#else /* CONFIG_X86_64 */
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		/*
+		 * Due to a decoder implementation quirk, some
+		 * specific Intel CPUs actually perform better with
+		 * the "k8_nops" than with the SDM-recommended NOPs.
+		 */
+		if (boot_cpu_data.x86 == 6 &&
+		    boot_cpu_data.x86_model >= 0x0f &&
+		    boot_cpu_data.x86_model != 0x1c &&
+		    boot_cpu_data.x86_model != 0x26 &&
+		    boot_cpu_data.x86_model != 0x27 &&
+		    boot_cpu_data.x86_model < 0x30) {
+			ideal_nops = k8_nops;
+		} else if (boot_cpu_has(X86_FEATURE_NOPL)) {
+			   ideal_nops = p6_nops;
+		} else {
+#ifdef CONFIG_X86_64
+			ideal_nops = k8_nops;
+#else
+			ideal_nops = intel_nops;
+#endif
+		}
 
-static const unsigned char *const *__init_or_module find_nop_table(void)
-{
-	if (boot_cpu_has(X86_FEATURE_K8))
-		return k8_nops;
-	else if (boot_cpu_has(X86_FEATURE_K7))
-		return k7_nops;
-	else if (boot_cpu_has(X86_FEATURE_NOPL))
-		return p6_nops;
-	else
-		return intel_nops;
+	default:
+#ifdef CONFIG_X86_64
+		ideal_nops = k8_nops;
+#else
+		if (boot_cpu_has(X86_FEATURE_K8))
+			ideal_nops = k8_nops;
+		else if (boot_cpu_has(X86_FEATURE_K7))
+			ideal_nops = k7_nops;
+		else
+			ideal_nops = intel_nops;
+#endif
+	}
 }
 
-#endif /* CONFIG_X86_64 */
-
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
 static void __init_or_module add_nops(void *insns, unsigned int len)
 {
-	const unsigned char *const *noptable = find_nop_table();
-
 	while (len > 0) {
 		unsigned int noplen = len;
 		if (noplen > ASM_NOP_MAX)
 			noplen = ASM_NOP_MAX;
-		memcpy(insns, noptable[noplen], noplen);
+		memcpy(insns, ideal_nops[noplen], noplen);
 		insns += noplen;
 		len -= noplen;
 	}
@@ -195,6 +250,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
+extern char __vsyscall_0;
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
@@ -678,29 +734,3 @@ void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
 	wrote_text = 0;
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 }
-
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-
-#ifdef CONFIG_X86_64
-unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
-#else
-unsigned char ideal_nop5[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
-#endif
-
-void __init arch_init_ideal_nop5(void)
-{
-	/*
-	 * There is no good nop for all x86 archs.  This selection
-	 * algorithm should be unified with the one in find_nop_table(),
-	 * but this should be good enough for now.
-	 *
-	 * For cases other than the ones below, use the safe (as in
-	 * always functional) defaults above.
-	 */
-#ifdef CONFIG_X86_64
-	/* Don't use these on 32 bits due to broken virtualizers */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		memcpy(ideal_nop5, p6_nops[5], 5);
-#endif
-}
-#endif
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index 870e6cc..0ab9b22 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -43,7 +43,7 @@ config X86_ACPI_CPUFREQ
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC400 and SC410
 	  processors.
@@ -59,7 +59,7 @@ config ELAN_CPUFREQ
 config SC520_CPUFREQ
 	tristate "AMD Elan SC520"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC520 processor.
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index df86bc8..32e86aa 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -400,12 +400,10 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 		switch (c->x86_model) {
 		case 5:
-			if (c->x86_mask == 0) {
-				if (l2 == 0)
-					p = "Celeron (Covington)";
-				else if (l2 == 256)
-					p = "Mobile Pentium II (Dixon)";
-			}
+			if (l2 == 0)
+				p = "Celeron (Covington)";
+			else if (l2 == 256)
+				p = "Mobile Pentium II (Dixon)";
 			break;
 
 		case 6:
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1ce1af2..c105c53 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -327,7 +327,6 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
 	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
 
-	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
@@ -454,27 +453,16 @@ int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
 {
 	int ret = 0;
 
-#define SUBCACHE_MASK	(3UL << 20)
-#define SUBCACHE_INDEX	0xfff
-
-	/*
-	 * check whether this slot is already used or
-	 * the index is already disabled
-	 */
+	/*  check if @slot is already used or the index is already disabled */
 	ret = amd_get_l3_disable_slot(l3, slot);
 	if (ret >= 0)
 		return -EINVAL;
 
-	/*
-	 * check whether the other slot has disabled the
-	 * same index already
-	 */
-	if (index == amd_get_l3_disable_slot(l3, !slot))
+	if (index > l3->indices)
 		return -EINVAL;
 
-	/* do not allow writes outside of allowed bits */
-	if ((index & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((index & SUBCACHE_INDEX) > l3->indices))
+	/* check whether the other slot has disabled the same index already */
+	if (index == amd_get_l3_disable_slot(l3, !slot))
 		return -EINVAL;
 
 	amd_l3_disable_index(l3, cpu, slot, index);
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index a93742a..0ba15a6 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -260,9 +260,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	return mod_code_status;
 }
 
-static unsigned char *ftrace_nop_replace(void)
+static const unsigned char *ftrace_nop_replace(void)
 {
-	return ideal_nop5;
+	return ideal_nops[NOP_ATOMIC5];
 }
 
 static int
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 961b6b3..3fee346 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -34,7 +34,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
-		memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
 	get_online_cpus();
 	mutex_lock(&text_mutex);
 	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
@@ -44,7 +44,8 @@ void arch_jump_label_transform(struct jump_entry *entry,
 
 void arch_jump_label_text_poke_early(jump_label_t addr)
 {
-	text_poke_early((void *)addr, ideal_nop5, JUMP_LABEL_NOP_SIZE);
+	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
+			JUMP_LABEL_NOP_SIZE);
 }
 
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5a0484a..390a663 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -691,8 +691,6 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
-	unsigned long flags;
-
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -1036,9 +1034,7 @@ void __init setup_arch(char **cmdline_p)
 
 	mcheck_init();
 
-	local_irq_save(flags);
-	arch_init_ideal_nop5();
-	local_irq_restore(flags);
+	arch_init_ideal_nops();
 }
 
 #ifdef CONFIG_X86_32
