Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab1EMX0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:26:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:26532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684Ab1EMXY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:24:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="435890994"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] Hook up sysconf syscall for all architectures
Date: Fri, 13 May 2011 16:24:19 -0700
Message-Id: <1305329059-2017-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/arm/include/asm/unistd.h          |    1 +
 arch/arm/kernel/calls.S                |    1 +
 arch/blackfin/include/asm/unistd.h     |    3 ++-
 arch/blackfin/mach-common/entry.S      |    1 +
 arch/ia64/include/asm/unistd.h         |    3 ++-
 arch/ia64/kernel/entry.S               |    1 +
 arch/m68k/include/asm/unistd.h         |    3 ++-
 arch/m68k/kernel/entry_mm.S            |    1 +
 arch/m68k/kernel/syscalltable.S        |    1 +
 arch/microblaze/include/asm/unistd.h   |    3 ++-
 arch/microblaze/kernel/syscall_table.S |    1 +
 arch/mips/include/asm/unistd.h         |    9 ++++++---
 arch/mips/kernel/scall32-o32.S         |    1 +
 arch/mips/kernel/scall64-64.S          |    1 +
 arch/mips/kernel/scall64-n32.S         |    1 +
 arch/mips/kernel/scall64-o32.S         |    1 +
 arch/powerpc/include/asm/systbl.h      |    1 +
 arch/powerpc/include/asm/unistd.h      |    3 ++-
 arch/s390/include/asm/unistd.h         |    3 ++-
 arch/s390/kernel/compat_wrapper.S      |    5 +++++
 arch/s390/kernel/syscalls.S            |    1 +
 arch/sh/include/asm/unistd_32.h        |    3 ++-
 arch/sh/include/asm/unistd_64.h        |    3 ++-
 arch/sh/kernel/syscalls_32.S           |    1 +
 arch/sh/kernel/syscalls_64.S           |    1 +
 arch/sparc/include/asm/unistd.h        |    3 ++-
 arch/sparc/kernel/systbls_32.S         |    2 +-
 arch/sparc/kernel/systbls_64.S         |    4 ++--
 arch/x86/ia32/ia32entry.S              |    1 +
 arch/x86/include/asm/unistd_32.h       |    3 ++-
 arch/x86/include/asm/unistd_64.h       |    2 ++
 arch/x86/kernel/syscall_table_32.S     |    1 +
 include/asm-generic/unistd.h           |    5 ++++-
 33 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 87dbe3e..d9b693b 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -400,6 +400,7 @@
 #define __NR_open_by_handle_at		(__NR_SYSCALL_BASE+371)
 #define __NR_clock_adjtime		(__NR_SYSCALL_BASE+372)
 #define __NR_syncfs			(__NR_SYSCALL_BASE+373)
+#define __NR_sysconf			(__NR_SYSCALL_BASE+374)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 7fbf28c..46c6a1b 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -383,6 +383,7 @@
 		CALL(sys_open_by_handle_at)
 		CALL(sys_clock_adjtime)
 		CALL(sys_syncfs)
+		CALL(sys_sysconf)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index ff9a9f3..6e29297 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -397,8 +397,9 @@
 #define __NR_open_by_handle_at	376
 #define __NR_clock_adjtime	377
 #define __NR_syncfs		378
+#define __NR_sysconf		379
 
-#define __NR_syscall		379
+#define __NR_syscall		380
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index f96933f..49daa46 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1753,6 +1753,7 @@ ENTRY(_sys_call_table)
 	.long _sys_open_by_handle_at
 	.long _sys_clock_adjtime
 	.long _sys_syncfs
+	.long _sys_sysconf
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 404d037..9d73923 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -319,11 +319,12 @@
 #define __NR_open_by_handle_at  	1327
 #define __NR_clock_adjtime		1328
 #define __NR_syncfs			1329
+#define __NR_sysconf			1330
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			306 /* length of syscall table */
+#define NR_syscalls			307 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 6de2e23..dee434f 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1775,6 +1775,7 @@ sys_call_table:
 	data8 sys_open_by_handle_at
 	data8 sys_clock_adjtime
 	data8 sys_syncfs
+	data8 sys_sysconf
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 29e1790..acc8f01 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -347,10 +347,11 @@
 #define __NR_open_by_handle_at	341
 #define __NR_clock_adjtime	342
 #define __NR_syncfs		343
+#define __NR_sysconf		344
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		344
+#define NR_syscalls		345
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index 1359ee6..0280b58 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -754,4 +754,5 @@ sys_call_table:
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
 
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 9b8393d..e8ea4cc 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -362,6 +362,7 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index 30edd61..cfc0c7b 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -390,8 +390,9 @@
 #define __NR_open_by_handle_at	372
 #define __NR_clock_adjtime	373
 #define __NR_syncfs		374
+#define __NR_sysconf		375
 
-#define __NR_syscalls		375
+#define __NR_syscalls		376
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 85cea81..4350241 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -379,3 +379,4 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index fa2e37e..590290c 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -363,11 +363,12 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 340)
 #define __NR_clock_adjtime		(__NR_Linux + 341)
 #define __NR_syncfs			(__NR_Linux + 342)
+#define __NR_sysconf			(__NR_Linux + 343)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		342
+#define __NR_Linux_syscalls		343
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
@@ -682,11 +683,12 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 299)
 #define __NR_clock_adjtime		(__NR_Linux + 300)
 #define __NR_syncfs			(__NR_Linux + 301)
+#define __NR_sysconf			(__NR_Linux + 302)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		301
+#define __NR_Linux_syscalls		302
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
@@ -1006,11 +1008,12 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 304)
 #define __NR_clock_adjtime		(__NR_Linux + 305)
 #define __NR_syncfs			(__NR_Linux + 306)
+#define __NR_sysconf			(__NR_Linux + 307)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		306
+#define __NR_Linux_syscalls		307
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 7f5468b..f5b5ccc 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -590,6 +590,7 @@ einval:	li	v0, -ENOSYS
 	sys	sys_open_by_handle_at	3	/* 4340 */
 	sys	sys_clock_adjtime	2
 	sys	sys_syncfs		1
+	sys	sys_sysconf		1
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index a2e1fcb..16b40f5 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -429,4 +429,5 @@ sys_call_table:
 	PTR	sys_open_by_handle_at
 	PTR	sys_clock_adjtime		/* 5300 */
 	PTR	sys_syncfs
+	PTR	sys_sysconf
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index b2c7624..32c7ba2 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -429,4 +429,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_open_by_handle_at
 	PTR	compat_sys_clock_adjtime	/* 6305 */
 	PTR	sys_syncfs
+	PTR	sys_sysconf
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 049a9c8..b9e751c 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -547,4 +547,5 @@ sys_call_table:
 	PTR	compat_sys_open_by_handle_at	/* 4340 */
 	PTR	compat_sys_clock_adjtime
 	PTR	sys_syncfs
+	PTR	sys_sysconf
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 60f64b1..6889207 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -352,3 +352,4 @@ SYSCALL_SPU(name_to_handle_at)
 COMPAT_SYS_SPU(open_by_handle_at)
 COMPAT_SYS_SPU(clock_adjtime)
 SYSCALL_SPU(syncfs)
+SYSCALL_SPU(sysconf)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 3c21564..e6c9a73 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -371,10 +371,11 @@
 #define __NR_open_by_handle_at	346
 #define __NR_clock_adjtime	347
 #define __NR_syncfs		348
+#define __NR_sysconf		349
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		349
+#define __NR_syscalls		350
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index e821525..442cc13 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -276,7 +276,8 @@
 #define __NR_open_by_handle_at	336
 #define __NR_clock_adjtime	337
 #define __NR_syncfs		338
-#define NR_syscalls 339
+#define __NR_sysconf		339
+#define NR_syscalls 340
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 1dc96ea..988f859 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1904,3 +1904,8 @@ compat_sys_clock_adjtime_wrapper:
 sys_syncfs_wrapper:
 	lgfr	%r2,%r2			# int
 	jg	sys_syncfs
+
+	.globl	sys_sysconf_wrapper
+sys_sysconf_wrapper:
+	lgfr	%r2,%r2			# int
+	jg	sys_sysconf
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 9c65fd4..b97c80d 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -347,3 +347,4 @@ SYSCALL(sys_name_to_handle_at,sys_name_to_handle_at,sys_name_to_handle_at_wrappe
 SYSCALL(sys_open_by_handle_at,sys_open_by_handle_at,compat_sys_open_by_handle_at_wrapper)
 SYSCALL(sys_clock_adjtime,sys_clock_adjtime,compat_sys_clock_adjtime_wrapper)
 SYSCALL(sys_syncfs,sys_syncfs,sys_syncfs_wrapper)
+SYSCALL(sys_sysconf,sys_sysconf,sys_sysconf_wrapper)
diff --git a/arch/sh/include/asm/unistd_32.h b/arch/sh/include/asm/unistd_32.h
index ca7765e..ccf2de4 100644
--- a/arch/sh/include/asm/unistd_32.h
+++ b/arch/sh/include/asm/unistd_32.h
@@ -373,8 +373,9 @@
 #define __NR_open_by_handle_at	360
 #define __NR_clock_adjtime	361
 #define __NR_syncfs		362
+#define __NR_sysconf		363
 
-#define NR_syscalls 363
+#define NR_syscalls 364
 
 #ifdef __KERNEL__
 
diff --git a/arch/sh/include/asm/unistd_64.h b/arch/sh/include/asm/unistd_64.h
index a694009..b0ff4d9 100644
--- a/arch/sh/include/asm/unistd_64.h
+++ b/arch/sh/include/asm/unistd_64.h
@@ -394,10 +394,11 @@
 #define __NR_open_by_handle_at	371
 #define __NR_clock_adjtime	372
 #define __NR_syncfs		373
+#define __NR_sysconf		374
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 374
+#define NR_syscalls 375
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/sh/kernel/syscalls_32.S b/arch/sh/kernel/syscalls_32.S
index 030966a..705d2de 100644
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@ -380,3 +380,4 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at	/* 360 */
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
diff --git a/arch/sh/kernel/syscalls_64.S b/arch/sh/kernel/syscalls_64.S
index ca0a614..c288875 100644
--- a/arch/sh/kernel/syscalls_64.S
+++ b/arch/sh/kernel/syscalls_64.S
@@ -400,3 +400,4 @@ sys_call_table:
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index 9d897b6..0b0b362 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -404,8 +404,9 @@
 #define __NR_open_by_handle_at	333
 #define __NR_clock_adjtime	334
 #define __NR_syncfs		335
+#define __NR_sysconf		336
 
-#define NR_syscalls		336
+#define NR_syscalls		337
 
 #ifdef __32bit_syscall_numbers__
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 47ac73c..1eeae1f 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -84,4 +84,4 @@ sys_call_table:
 /*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
 /*325*/	.long sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_event_open, sys_recvmmsg, sys_fanotify_init
 /*330*/	.long sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
-/*335*/	.long sys_syncfs
+/*335*/	.long sys_syncfs, sys_sysconf
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 4f3170c..1dc8e34 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -85,7 +85,7 @@ sys_call_table32:
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, compat_sys_preadv
 	.word compat_sys_pwritev, compat_sys_rt_tgsigqueueinfo, sys_perf_event_open, compat_sys_recvmmsg, sys_fanotify_init
 /*330*/	.word sys32_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, compat_sys_open_by_handle_at, compat_sys_clock_adjtime
-	.word sys_syncfs
+	.word sys_syncfs, sys_sysconf
 
 #endif /* CONFIG_COMPAT */
 
@@ -162,4 +162,4 @@ sys_call_table:
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
 	.word sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_event_open, sys_recvmmsg, sys_fanotify_init
 /*330*/	.word sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
-	.word sys_syncfs
+	.word sys_syncfs, sys_sysconf
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 849a9d2..493fb4f 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -848,4 +848,5 @@ ia32_sys_call_table:
 	.quad compat_sys_open_by_handle_at
 	.quad compat_sys_clock_adjtime
 	.quad sys_syncfs
+	.quad sys_sysconf
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index a755ef5..da83485 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -350,10 +350,11 @@
 #define __NR_open_by_handle_at  342
 #define __NR_clock_adjtime	343
 #define __NR_syncfs             344
+#define __NR_sysconf		345
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 345
+#define NR_syscalls 346
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 160fa76..2948044 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -677,6 +677,8 @@ __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 #define __NR_syncfs                             306
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_sysconf				307
+__SYSCALL(__NR_sysconf, sys_sysconf)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index abce34d..e926eb3 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -344,3 +344,4 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_sysconf
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 07c40d5..1092b02 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -654,9 +654,12 @@ __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_sysconf 268
+__SYSCALL(__NR_sysconf, sys_sysconf)
+
 
 #undef __NR_syscalls
-#define __NR_syscalls 268
+#define __NR_syscalls 269
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.4.4

