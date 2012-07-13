Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352Ab2GMKkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:40:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42162 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932653Ab2GMKkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:40:03 -0400
Date: Fri, 13 Jul 2012 11:39:51 +0100
From: Will Deacon <will.deacon@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chris@zankel.net" <chris@zankel.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>
Subject: Re: [PATCH 2/3] ipc: allow compat IPC version field parsing if
 !ARCH_WANT_OLD_COMPAT_IPC
Message-ID: <20120713103951.GF18079@mudshark.cambridge.arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
 <1342020741-12758-3-git-send-email-will.deacon@arm.com>
 <20120711144001.b1f7c21d.akpm@linux-foundation.org>
 <20120712084756.GB2816@mudshark.cambridge.arm.com>
 <20120712015949.88692ecf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712015949.88692ecf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 09:59:49AM +0100, Andrew Morton wrote:
> > > 
> > > Could we do this purely in Kconfig?  Add a new
> > > CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION and always set it true if
> > > CONFIG_ARCH_WANT_OLD_COMPAT_IPC?

[...]

> It would be best to change both as a separate patch.

Ok, here's the patch. It's messier than I originally anticipated since more
architectures were defining __ARCH_WANT_IPC_PARSE_VERSION than I thought.
The only conditional define that I spotted was for x86 (#if CONFIG_X86_32)
but I've not been able to test on architectures other than ARM.

Cheers,

Will

---8<---

>From a34cd86747ed2992974984bcfe1fe939ba31e1b2 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Thu, 12 Jul 2012 17:56:40 +0100
Subject: [PATCH] ipc: use Kconfig options for __ARCH_WANT_[COMPAT_]IPC_PARSE_VERSION

Rather than #define the options manually in the architecture code,
add Kconfig options for them and select them there instead. This also
allows us to select the compat IPC version parsing automatically for
platforms using the old compat IPC interface.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/Kconfig                         |    7 +++++++
 arch/alpha/Kconfig                   |    1 +
 arch/alpha/include/asm/unistd.h      |    1 -
 arch/arm/Kconfig                     |    1 +
 arch/arm/include/asm/unistd.h        |    1 -
 arch/avr32/Kconfig                   |    1 +
 arch/avr32/include/asm/unistd.h      |    1 -
 arch/blackfin/Kconfig                |    1 +
 arch/blackfin/include/asm/unistd.h   |    1 -
 arch/cris/Kconfig                    |    1 +
 arch/cris/include/asm/unistd.h       |    1 -
 arch/frv/Kconfig                     |    1 +
 arch/frv/include/asm/unistd.h        |    1 -
 arch/h8300/Kconfig                   |    1 +
 arch/h8300/include/asm/unistd.h      |    1 -
 arch/m32r/Kconfig                    |    1 +
 arch/m32r/include/asm/unistd.h       |    1 -
 arch/m68k/Kconfig                    |    1 +
 arch/m68k/include/asm/unistd.h       |    1 -
 arch/microblaze/Kconfig              |    1 +
 arch/microblaze/include/asm/unistd.h |    1 -
 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/unistd.h       |    1 -
 arch/mn10300/Kconfig                 |    1 +
 arch/mn10300/include/asm/unistd.h    |    1 -
 arch/powerpc/Kconfig                 |    1 +
 arch/powerpc/include/asm/unistd.h    |    1 -
 arch/s390/Kconfig                    |    1 +
 arch/s390/include/asm/unistd.h       |    1 -
 arch/sh/Kconfig                      |    1 +
 arch/sh/include/asm/unistd.h         |    1 -
 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/unistd.h      |    1 -
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/unistd.h        |    1 -
 include/linux/compat.h               |    1 -
 ipc/compat.c                         |    2 +-
 ipc/util.c                           |    4 ++--
 ipc/util.h                           |    2 +-
 39 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8c3d957..72f2fa1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -248,7 +248,14 @@ config HAVE_CMPXCHG_LOCAL
 config HAVE_CMPXCHG_DOUBLE
 	bool
 
+config ARCH_WANT_IPC_PARSE_VERSION
+	bool
+
+config ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+	bool
+
 config ARCH_WANT_OLD_COMPAT_IPC
+	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
 config HAVE_ARCH_SECCOMP_FILTER
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 3de74c9..1c2172b 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -17,6 +17,7 @@ config ALPHA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index d1f23b7..633b23b 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -470,7 +470,6 @@
 
 #define NR_SYSCALLS			504
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a91009c..66812bb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -45,6 +45,7 @@ config ARM
 	select GENERIC_SMP_IDLE_THREAD
 	select KTIME_SCALAR
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 512cd14..0cab47d 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -446,7 +446,6 @@
 
 #ifdef __KERNEL__
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 71d38c7..5602831 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -14,6 +14,7 @@ config AVR32
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/avr32/include/asm/unistd.h b/arch/avr32/include/asm/unistd.h
index f714544..1358e36 100644
--- a/arch/avr32/include/asm/unistd.h
+++ b/arch/avr32/include/asm/unistd.h
@@ -318,7 +318,6 @@
 /* SMP stuff */
 #define __IGNORE_getcpu
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index fef96f4..abe8f3f 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -40,6 +40,7 @@ config BLACKFIN
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 3287222..5b2a074 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -434,7 +434,6 @@
 #define __IGNORE_getcpu
 
 #ifdef __KERNEL__
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index bb34465..ea877a0 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -46,6 +46,7 @@ config CRIS
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config HZ
 	int
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index f921b8b..51873a4 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -347,7 +347,6 @@
 
 #include <arch/unistd.h>
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index a685910..971c0a1 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -9,6 +9,7 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config ZONE_DMA
 	bool
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index a569dff..67f23a3 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -349,7 +349,6 @@
 
 #define NR_syscalls 338
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 56e890d..82379089 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -5,6 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/h8300/include/asm/unistd.h b/arch/h8300/include/asm/unistd.h
index 7185113..5cd8828 100644
--- a/arch/h8300/include/asm/unistd.h
+++ b/arch/h8300/include/asm/unistd.h
@@ -331,7 +331,6 @@
 
 #define NR_syscalls 321
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b638d5b..828e5af 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -12,6 +12,7 @@ config M32R
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SBUS
 	bool
diff --git a/arch/m32r/include/asm/unistd.h b/arch/m32r/include/asm/unistd.h
index 3e1db56..d5e66a4 100644
--- a/arch/m32r/include/asm/unistd.h
+++ b/arch/m32r/include/asm/unistd.h
@@ -336,7 +336,6 @@
 
 #define NR_syscalls 326
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 1471201..baecf8b 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -11,6 +11,7 @@ config M68K
 	select GENERIC_STRNLEN_USER if MMU
 	select FPU if MMU
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index ea0b502..045cfd6 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -357,7 +357,6 @@
 
 #define NR_syscalls		347
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 0bf4423..b5ebd9f 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -23,6 +23,7 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SWAP
 	def_bool n
diff --git a/arch/microblaze/include/asm/unistd.h b/arch/microblaze/include/asm/unistd.h
index d20ffbc..6985e6e 100644
--- a/arch/microblaze/include/asm/unistd.h
+++ b/arch/microblaze/include/asm/unistd.h
@@ -400,7 +400,6 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
 /* #define __ARCH_WANT_OLD_STAT */
 #define __ARCH_WANT_STAT64
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 09ab87e..e6da9cb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -34,6 +34,7 @@ config MIPS
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 menu "Machine selection"
 
diff --git a/arch/mips/include/asm/unistd.h b/arch/mips/include/asm/unistd.h
index d8dad53..bebbde0 100644
--- a/arch/mips/include/asm/unistd.h
+++ b/arch/mips/include/asm/unistd.h
@@ -1034,7 +1034,6 @@
 #ifndef __ASSEMBLY__
 
 #define __ARCH_OMIT_COMPAT_SYS_GETDENTS64
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 687f9b4..17f0ada 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -7,6 +7,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config AM33_2
 	def_bool n
diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index 9051f92..866eb14 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -358,7 +358,6 @@
 /*
  * specify the deprecated syscalls we want to support on this arch
  */
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 050cb37..e5491e3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -137,6 +137,7 @@ config PPC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index d3d1b5e..bd377a3 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -389,7 +389,6 @@
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a39b469..3c6e6b2 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -121,6 +121,7 @@ config S390
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index 8a8008f..7c89143 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -390,7 +390,6 @@
 #define __IGNORE_recvmmsg
 #define __IGNORE_sendmmsg
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 31d9db7..fbe39e1 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -34,6 +34,7 @@ config SUPERH
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/include/asm/unistd.h b/arch/sh/include/asm/unistd.h
index e800a38..7bc6707 100644
--- a/arch/sh/include/asm/unistd.h
+++ b/arch/sh/include/asm/unistd.h
@@ -6,7 +6,6 @@
 # endif
 
 # define __ARCH_WANT_SYS_RT_SIGSUSPEND
-# define __ARCH_WANT_IPC_PARSE_VERSION
 # define __ARCH_WANT_OLD_READDIR
 # define __ARCH_WANT_OLD_STAT
 # define __ARCH_WANT_STAT64
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e74ff13..9245798 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -36,6 +36,7 @@ config SPARC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
index c7cb0af..fb26934 100644
--- a/arch/sparc/include/asm/unistd.h
+++ b/arch/sparc/include/asm/unistd.h
@@ -423,7 +423,6 @@
 #endif
 
 #ifdef __KERNEL__
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c70684f..e906467 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -95,6 +95,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 4437001..0d9776e 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -15,7 +15,6 @@
 # ifdef CONFIG_X86_32
 
 #  include <asm/unistd_32.h>
-#  define __ARCH_WANT_IPC_PARSE_VERSION
 #  define __ARCH_WANT_STAT64
 #  define __ARCH_WANT_SYS_IPC
 #  define __ARCH_WANT_SYS_OLD_MMAP
diff --git a/include/linux/compat.h b/include/linux/compat.h
index f2b8fe2..09b28b7 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -256,7 +256,6 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr);
 
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
-#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
diff --git a/ipc/compat.c b/ipc/compat.c
index 20f92b2..ad9518e 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -118,7 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
-#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+#ifdef	CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
diff --git a/ipc/util.c b/ipc/util.c
index 75261a3..eb07fd3 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -804,7 +804,7 @@ out_up:
 	return ERR_PTR(err);
 }
 
-#ifdef __ARCH_WANT_IPC_PARSE_VERSION
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
 
 
 /**
@@ -826,7 +826,7 @@ int ipc_parse_version (int *cmd)
 	}
 }
 
-#endif /* __ARCH_WANT_IPC_PARSE_VERSION */
+#endif /* CONFIG_ARCH_WANT_IPC_PARSE_VERSION */
 
 #ifdef CONFIG_PROC_FS
 struct ipc_proc_iter {
diff --git a/ipc/util.h b/ipc/util.h
index 6f5c20b..850ef3e 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -130,7 +130,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
 				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
-#ifndef __ARCH_WANT_IPC_PARSE_VERSION
+#ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else
-- 
1.7.4.1

