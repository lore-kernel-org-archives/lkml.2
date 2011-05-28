Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab1E1C2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 22:28:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53180 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab1E1C2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 22:28:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Date: Fri, 27 May 2011 19:28:27 -0700
Message-ID: <m1lixr4kz8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/qhstz0v0thppXvwJLsyoEpgnyS6liscY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4480]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH] ns: Wire up the setns system call for 2.6.40-rc1 or whatever
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


32bit and 64bit on x86 are tested and working.  The rest I have looked
at closely and I can't find any problems.

setns is an easy system call to wire up.  It just takes two ints so I
don't expect any weird architecture porting problems.

While doing this I have noticed that we have some architectures that are
very slow to get new system calls.  cris seems to be the slowest where
the last system calls wired up were preadv and pwritev.  avr32 is weird
in that recvmmsg was wired up but never declared in unistd.h.  frv is
behind with perf_event_open being the last syscall wired up.  On h8300
the last system call wired up was epoll_wait.  On m32r the last system
call wired up was fallocate.  mn10300 has recvmmsg as the last system
call wired up.  The rest seem to at least have syncfs wired up which was
new in the 2.6.39.

v2: Most of the architecture support added by Daniel Lezcano <dlezcano@fr.ibm.com>
v3: ported to v2.6.36-rc4 by: Eric W. Biederman <ebiederm@xmission.com>
v4: Moved wiring up of the system call to another patch
v5: ported to v2.6.39-rc6
v6: rebased onto parisc-next and net-next to avoid syscall  conflicts.
v7: ported to Linus's latest post 2.6.39 tree.

>  arch/blackfin/include/asm/unistd.h     |    3 ++-
>  arch/blackfin/mach-common/entry.S      |    1 +
Acked-by: Mike Frysinger <vapier@gentoo.org>

Oh - ia64 wiring looks good.
Acked-by: Tony Luck <tony.luck@intel.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/alpha/include/asm/unistd.h        |    3 ++-
 arch/alpha/kernel/systbls.S            |    1 +
 arch/arm/include/asm/unistd.h          |    1 +
 arch/arm/kernel/calls.S                |    1 +
 arch/avr32/include/asm/unistd.h        |    3 ++-
 arch/avr32/kernel/syscall_table.S      |    1 +
 arch/blackfin/include/asm/unistd.h     |    3 ++-
 arch/blackfin/mach-common/entry.S      |    1 +
 arch/cris/arch-v10/kernel/entry.S      |    1 +
 arch/cris/arch-v32/kernel/entry.S      |    1 +
 arch/cris/include/asm/unistd.h         |    3 ++-
 arch/frv/include/asm/unistd.h          |    3 ++-
 arch/frv/kernel/entry.S                |    1 +
 arch/h8300/include/asm/unistd.h        |    3 ++-
 arch/h8300/kernel/syscalls.S           |    1 +
 arch/ia64/include/asm/unistd.h         |    3 ++-
 arch/ia64/kernel/entry.S               |    1 +
 arch/m32r/include/asm/unistd.h         |    3 ++-
 arch/m32r/kernel/syscall_table.S       |    1 +
 arch/m68k/include/asm/unistd.h         |    3 ++-
 arch/m68k/kernel/syscalltable.S        |    1 +
 arch/microblaze/include/asm/unistd.h   |    3 ++-
 arch/microblaze/kernel/syscall_table.S |    1 +
 arch/mips/include/asm/unistd.h         |   15 +++++++++------
 arch/mips/kernel/scall32-o32.S         |    1 +
 arch/mips/kernel/scall64-64.S          |    1 +
 arch/mips/kernel/scall64-n32.S         |    1 +
 arch/mips/kernel/scall64-o32.S         |    1 +
 arch/mn10300/include/asm/unistd.h      |    3 ++-
 arch/mn10300/kernel/entry.S            |    1 +
 arch/parisc/include/asm/unistd.h       |    3 ++-
 arch/parisc/kernel/syscall_table.S     |    1 +
 arch/powerpc/include/asm/systbl.h      |    1 +
 arch/powerpc/include/asm/unistd.h      |    3 ++-
 arch/s390/include/asm/unistd.h         |    3 ++-
 arch/s390/kernel/compat_wrapper.S      |    6 ++++++
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
 arch/xtensa/include/asm/unistd.h       |    4 +++-
 include/asm-generic/unistd.h           |    4 +++-
 50 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index b183416..4ac48a0 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -456,10 +456,11 @@
 #define __NR_open_by_handle_at		498
 #define __NR_clock_adjtime		499
 #define __NR_syncfs			500
+#define __NR_setns			501
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			501
+#define NR_SYSCALLS			502
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index 15f999d..b9c28f3 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -519,6 +519,7 @@ sys_call_table:
 	.quad sys_open_by_handle_at
 	.quad sys_clock_adjtime
 	.quad sys_syncfs			/* 500 */
+	.quad sys_setns
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 87dbe3e..0c5fc55 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -400,6 +400,7 @@
 #define __NR_open_by_handle_at		(__NR_SYSCALL_BASE+371)
 #define __NR_clock_adjtime		(__NR_SYSCALL_BASE+372)
 #define __NR_syncfs			(__NR_SYSCALL_BASE+373)
+#define __NR_setns			(__NR_SYSCALL_BASE+374)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 7fbf28c..a05f759 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -383,6 +383,7 @@
 		CALL(sys_open_by_handle_at)
 		CALL(sys_clock_adjtime)
 		CALL(sys_syncfs)
+		CALL(sys_setns)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/avr32/include/asm/unistd.h b/arch/avr32/include/asm/unistd.h
index 89861a2..f714544 100644
--- a/arch/avr32/include/asm/unistd.h
+++ b/arch/avr32/include/asm/unistd.h
@@ -299,9 +299,10 @@
 #define __NR_signalfd		279
 /* 280 was __NR_timerfd */
 #define __NR_eventfd		281
+#define __NR_setns		283
 
 #ifdef __KERNEL__
-#define NR_syscalls		282
+#define NR_syscalls		284
 
 /* Old stuff */
 #define __IGNORE_uselib
diff --git a/arch/avr32/kernel/syscall_table.S b/arch/avr32/kernel/syscall_table.S
index e76bad1..c7fd394 100644
--- a/arch/avr32/kernel/syscall_table.S
+++ b/arch/avr32/kernel/syscall_table.S
@@ -296,4 +296,5 @@ sys_call_table:
 	.long	sys_ni_syscall		/* 280, was sys_timerfd */
 	.long	sys_eventfd
 	.long	sys_recvmmsg
+	.long	sys_setns
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index ff9a9f3..6ff9c41 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -397,8 +397,9 @@
 #define __NR_open_by_handle_at	376
 #define __NR_clock_adjtime	377
 #define __NR_syncfs		378
+#define __NR_setns		379
 
-#define __NR_syscall		379
+#define __NR_syscall		380
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index f96933f..dda11ef 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1753,6 +1753,7 @@ ENTRY(_sys_call_table)
 	.long _sys_open_by_handle_at
 	.long _sys_clock_adjtime
 	.long _sys_syncfs
+	.long _sys_setns
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 0d6420d..1161883 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -937,6 +937,7 @@ sys_call_table:
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_setns			/* 335 */
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index 3abf12c..84fed7e 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -880,6 +880,7 @@ sys_call_table:
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_setns			/* 335 */
 
         /*
          * NOTE!! This doesn't have to be exact - we just have
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index f6fad83..f921b8b 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -339,10 +339,11 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_setns		335
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 335
+#define NR_syscalls 336
 
 #include <arch/unistd.h>
 
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index b28da49..a569dff 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -343,10 +343,11 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_setns		337
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 337
+#define NR_syscalls 338
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 63d579b..017d6d7 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1526,5 +1526,6 @@ sys_call_table:
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long sys_setns
 
 syscall_table_size = (. - sys_call_table)
diff --git a/arch/h8300/include/asm/unistd.h b/arch/h8300/include/asm/unistd.h
index 50f2c5a..2c3f8e6 100644
--- a/arch/h8300/include/asm/unistd.h
+++ b/arch/h8300/include/asm/unistd.h
@@ -325,10 +325,11 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_setns		320
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 321
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/h8300/kernel/syscalls.S b/arch/h8300/kernel/syscalls.S
index faefaff..f4b2e67 100644
--- a/arch/h8300/kernel/syscalls.S
+++ b/arch/h8300/kernel/syscalls.S
@@ -333,6 +333,7 @@ SYMBOL_NAME_LABEL(sys_call_table)
 	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_move_pages */
 	.long SYMBOL_NAME(sys_getcpu)
 	.long SYMBOL_NAME(sys_ni_syscall)	/* sys_epoll_pwait */
+	.long SYMBOL_NAME(sys_setns)		/* 320 */
 
 	.macro	call_sp addr
 	mov.l	#SYMBOL_NAME(\addr),er6
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 404d037..1cf0f49 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -319,11 +319,12 @@
 #define __NR_open_by_handle_at  	1327
 #define __NR_clock_adjtime		1328
 #define __NR_syncfs			1329
+#define __NR_setns			1330
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			306 /* length of syscall table */
+#define NR_syscalls			307 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index 6de2e23..9ca8019 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1775,6 +1775,7 @@ sys_call_table:
 	data8 sys_open_by_handle_at
 	data8 sys_clock_adjtime
 	data8 sys_syncfs
+	data8 sys_setns				// 1330
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/arch/m32r/include/asm/unistd.h b/arch/m32r/include/asm/unistd.h
index c705456..3e1db56 100644
--- a/arch/m32r/include/asm/unistd.h
+++ b/arch/m32r/include/asm/unistd.h
@@ -330,10 +330,11 @@
 /* #define __NR_timerfd		322 removed */
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_setns		325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
diff --git a/arch/m32r/kernel/syscall_table.S b/arch/m32r/kernel/syscall_table.S
index 60536e2..528f2e6 100644
--- a/arch/m32r/kernel/syscall_table.S
+++ b/arch/m32r/kernel/syscall_table.S
@@ -324,3 +324,4 @@ ENTRY(sys_call_table)
 	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_setns			/* 325 */
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index f3b649d..43f984e 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -349,10 +349,11 @@
 #define __NR_open_by_handle_at	341
 #define __NR_clock_adjtime	342
 #define __NR_syncfs		343
+#define __NR_setns		344
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		344
+#define NR_syscalls		345
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 6f7b091..00d1452 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -364,4 +364,5 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_setns
 
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index 30edd61..7d7092b 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -390,8 +390,9 @@
 #define __NR_open_by_handle_at	372
 #define __NR_clock_adjtime	373
 #define __NR_syncfs		374
+#define __NR_setns		375
 
-#define __NR_syscalls		375
+#define __NR_syscalls		376
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/microblaze/kernel/syscall_table.S b/arch/microblaze/kernel/syscall_table.S
index 85cea81..d915a12 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -379,3 +379,4 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_setns			/* 375 */
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index fa2e37e..6fcfc48 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -363,16 +363,17 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 340)
 #define __NR_clock_adjtime		(__NR_Linux + 341)
 #define __NR_syncfs			(__NR_Linux + 342)
+#define __NR_setns			(__NR_Linux + 343)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		342
+#define __NR_Linux_syscalls		343
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		342
+#define __NR_O32_Linux_syscalls		343
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -682,16 +683,17 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 299)
 #define __NR_clock_adjtime		(__NR_Linux + 300)
 #define __NR_syncfs			(__NR_Linux + 301)
+#define __NR_setns			(__NR_Linux + 302)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		301
+#define __NR_Linux_syscalls		302
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		301
+#define __NR_64_Linux_syscalls		302
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1006,16 +1008,17 @@
 #define __NR_open_by_handle_at		(__NR_Linux + 304)
 #define __NR_clock_adjtime		(__NR_Linux + 305)
 #define __NR_syncfs			(__NR_Linux + 306)
+#define __NR_setns			(__NR_Linux + 307)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		306
+#define __NR_Linux_syscalls		307
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		306
+#define __NR_N32_Linux_syscalls		307
 
 #ifdef __KERNEL__
 
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 7a8e1dd..99e656e 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -589,6 +589,7 @@ einval:	li	v0, -ENOSYS
 	sys	sys_open_by_handle_at	3	/* 4340 */
 	sys	sys_clock_adjtime	2
 	sys	sys_syncfs		1
+	sys	sys_setns		2
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index 2d31c83..fb0575f 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -428,4 +428,5 @@ sys_call_table:
 	PTR	sys_open_by_handle_at
 	PTR	sys_clock_adjtime		/* 5300 */
 	PTR	sys_syncfs
+	PTR	sys_setns
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 38a0503..4de0c55 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -428,4 +428,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_open_by_handle_at
 	PTR	compat_sys_clock_adjtime	/* 6305 */
 	PTR	sys_syncfs
+	PTR	sys_setns
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 91ea5e4..4a387de 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -546,4 +546,5 @@ sys_call_table:
 	PTR	compat_sys_open_by_handle_at	/* 4340 */
 	PTR	compat_sys_clock_adjtime
 	PTR	sys_syncfs
+	PTR	sys_setns
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index 9d056f5..9051f92 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -349,10 +349,11 @@
 #define __NR_rt_tgsigqueueinfo	336
 #define __NR_perf_event_open	337
 #define __NR_recvmmsg		338
+#define __NR_setns		339
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 339
+#define NR_syscalls 340
 
 /*
  * specify the deprecated syscalls we want to support on this arch
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index fb93ad7..ae435e1 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -759,6 +759,7 @@ ENTRY(sys_call_table)
 	.long sys_rt_tgsigqueueinfo
 	.long sys_perf_event_open
 	.long sys_recvmmsg
+	.long sys_setns
 
 
 nr_syscalls=(.-sys_call_table)/4
diff --git a/arch/parisc/include/asm/unistd.h b/arch/parisc/include/asm/unistd.h
index 9cbc2c3..3392de3 100644
--- a/arch/parisc/include/asm/unistd.h
+++ b/arch/parisc/include/asm/unistd.h
@@ -820,8 +820,9 @@
 #define __NR_name_to_handle_at	(__NR_Linux + 325)
 #define __NR_open_by_handle_at	(__NR_Linux + 326)
 #define __NR_syncfs		(__NR_Linux + 327)
+#define __NR_setns		(__NR_Linux + 328)
 
-#define __NR_Linux_syscalls	(__NR_syncfs + 1)
+#define __NR_Linux_syscalls	(__NR_setns + 1)
 
 
 #define __IGNORE_select		/* newselect */
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index a5b02ce..34a4f5a 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -426,6 +426,7 @@
 	ENTRY_SAME(name_to_handle_at)	/* 325 */
 	ENTRY_COMP(open_by_handle_at)
 	ENTRY_SAME(syncfs)
+	ENTRY_SAME(setns)
 
 	/* Nothing yet */
 
diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 8489d37..f6736b7 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -353,3 +353,4 @@ COMPAT_SYS_SPU(open_by_handle_at)
 COMPAT_SYS_SPU(clock_adjtime)
 SYSCALL_SPU(syncfs)
 COMPAT_SYS_SPU(sendmmsg)
+SYSCALL_SPU(setns)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 6d23c81..b8b3f59 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -372,10 +372,11 @@
 #define __NR_clock_adjtime	347
 #define __NR_syncfs		348
 #define __NR_sendmmsg		349
+#define __NR_setns		350
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		350
+#define __NR_syscalls		351
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 9208e69..404bdb9 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -276,7 +276,8 @@
 #define __NR_open_by_handle_at	336
 #define __NR_clock_adjtime	337
 #define __NR_syncfs		338
-#define NR_syscalls 339
+#define __NR_setns		339
+#define NR_syscalls 340
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 1dc96ea..1f5eb78 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1904,3 +1904,9 @@ compat_sys_clock_adjtime_wrapper:
 sys_syncfs_wrapper:
 	lgfr	%r2,%r2			# int
 	jg	sys_syncfs
+
+	.globl	sys_setns_wrapper
+sys_setns_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	jg	sys_setns
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 9c65fd4..6ee39ef 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -347,3 +347,4 @@ SYSCALL(sys_name_to_handle_at,sys_name_to_handle_at,sys_name_to_handle_at_wrappe
 SYSCALL(sys_open_by_handle_at,sys_open_by_handle_at,compat_sys_open_by_handle_at_wrapper)
 SYSCALL(sys_clock_adjtime,sys_clock_adjtime,compat_sys_clock_adjtime_wrapper)
 SYSCALL(sys_syncfs,sys_syncfs,sys_syncfs_wrapper)
+SYSCALL(sys_setns,sys_setns,sys_setns_wrapper)
diff --git a/arch/sh/include/asm/unistd_32.h b/arch/sh/include/asm/unistd_32.h
index bb7d270..3432008 100644
--- a/arch/sh/include/asm/unistd_32.h
+++ b/arch/sh/include/asm/unistd_32.h
@@ -374,8 +374,9 @@
 #define __NR_clock_adjtime	361
 #define __NR_syncfs		362
 #define __NR_sendmmsg		363
+#define __NR_setns		364
 
-#define NR_syscalls 364
+#define NR_syscalls 365
 
 #ifdef __KERNEL__
 
diff --git a/arch/sh/include/asm/unistd_64.h b/arch/sh/include/asm/unistd_64.h
index 46327ce..ec98986 100644
--- a/arch/sh/include/asm/unistd_64.h
+++ b/arch/sh/include/asm/unistd_64.h
@@ -395,10 +395,11 @@
 #define __NR_clock_adjtime	372
 #define __NR_syncfs		373
 #define __NR_sendmmsg		374
+#define __NR_setns		375
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 375
+#define NR_syscalls 376
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/sh/kernel/syscalls_32.S b/arch/sh/kernel/syscalls_32.S
index 7c486f3..39b051d 100644
--- a/arch/sh/kernel/syscalls_32.S
+++ b/arch/sh/kernel/syscalls_32.S
@@ -381,3 +381,4 @@ ENTRY(sys_call_table)
 	.long sys_clock_adjtime
 	.long sys_syncfs
 	.long sys_sendmmsg
+	.long sys_setns
diff --git a/arch/sh/kernel/syscalls_64.S b/arch/sh/kernel/syscalls_64.S
index ba1a737..089c4d8 100644
--- a/arch/sh/kernel/syscalls_64.S
+++ b/arch/sh/kernel/syscalls_64.S
@@ -401,3 +401,4 @@ sys_call_table:
 	.long sys_clock_adjtime
 	.long sys_syncfs
 	.long sys_sendmmsg
+	.long sys_setns			/* 375 */
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index c5387ed..6260d5d 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -405,8 +405,9 @@
 #define __NR_clock_adjtime	334
 #define __NR_syncfs		335
 #define __NR_sendmmsg		336
+#define __NR_setns		337
 
-#define NR_syscalls		337
+#define NR_syscalls		338
 
 #ifdef __32bit_syscall_numbers__
 /* Sparc 32-bit only has the "setresuid32", "getresuid32" variants,
diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
index 332c83f..6e492d5 100644
--- a/arch/sparc/kernel/systbls_32.S
+++ b/arch/sparc/kernel/systbls_32.S
@@ -84,4 +84,4 @@ sys_call_table:
 /*320*/	.long sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
 /*325*/	.long sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_event_open, sys_recvmmsg, sys_fanotify_init
 /*330*/	.long sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
-/*335*/	.long sys_syncfs, sys_sendmmsg
+/*335*/	.long sys_syncfs, sys_sendmmsg, sys_setns
diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
index 43887ca..f566518 100644
--- a/arch/sparc/kernel/systbls_64.S
+++ b/arch/sparc/kernel/systbls_64.S
@@ -85,7 +85,7 @@ sys_call_table32:
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, compat_sys_preadv
 	.word compat_sys_pwritev, compat_sys_rt_tgsigqueueinfo, sys_perf_event_open, compat_sys_recvmmsg, sys_fanotify_init
 /*330*/	.word sys32_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, compat_sys_open_by_handle_at, compat_sys_clock_adjtime
-	.word sys_syncfs, compat_sys_sendmmsg
+	.word sys_syncfs, compat_sys_sendmmsg, sys_setns
 
 #endif /* CONFIG_COMPAT */
 
@@ -162,4 +162,4 @@ sys_call_table:
 /*320*/	.word sys_dup3, sys_pipe2, sys_inotify_init1, sys_accept4, sys_preadv
 	.word sys_pwritev, sys_rt_tgsigqueueinfo, sys_perf_event_open, sys_recvmmsg, sys_fanotify_init
 /*330*/	.word sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
-	.word sys_syncfs, sys_sendmmsg
+	.word sys_syncfs, sys_sendmmsg, sys_setns
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 95f5826..c1870dd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -849,4 +849,5 @@ ia32_sys_call_table:
 	.quad compat_sys_clock_adjtime
 	.quad sys_syncfs
 	.quad compat_sys_sendmmsg	/* 345 */
+	.quad sys_setns
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index fb6a625..593485b 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -351,10 +351,11 @@
 #define __NR_clock_adjtime	343
 #define __NR_syncfs             344
 #define __NR_sendmmsg		345
+#define __NR_setns		346
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 346
+#define NR_syscalls 347
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 79f90eb..705bf13 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -679,6 +679,8 @@ __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 __SYSCALL(__NR_syncfs, sys_syncfs)
 #define __NR_sendmmsg				307
 __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
+#define __NR_setns				308
+__SYSCALL(__NR_setns, sys_setns)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 32cbffb..fbb0a04 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -345,3 +345,4 @@ ENTRY(sys_call_table)
 	.long sys_clock_adjtime
 	.long sys_syncfs
 	.long sys_sendmmsg		/* 345 */
+	.long sys_setns
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
index 528042c..a6f934f 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -683,8 +683,10 @@ __SYSCALL(305, sys_ni_syscall, 0)
 __SYSCALL(306, sys_eventfd, 1)
 #define __NR_recvmmsg				307
 __SYSCALL(307, sys_recvmmsg, 5)
+#define __NR_setns				308
+__SYSCALL(308, sys_setns, 2)
 
-#define __NR_syscall_count			308
+#define __NR_syscall_count			309
 
 /*
  * sysxtensa syscall handler
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 33d52470..ae90e0f 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -681,9 +681,11 @@ __SC_COMP(__NR_open_by_handle_at, sys_open_by_handle_at, \
 __SC_COMP(__NR_clock_adjtime, sys_clock_adjtime, compat_sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_setns 268
+__SYSCALL(__NR_setns, sys_setns)
 
 #undef __NR_syscalls
-#define __NR_syscalls 268
+#define __NR_syscalls 269
 
 /*
  * All syscalls below here should go away really,
-- 
1.7.5.1.217.g4e3aa

