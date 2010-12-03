Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0LCCrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:47:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:40652 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab0LCCrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:47:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,291,1288594800"; 
   d="scan'208";a="632630251"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Richard Henderson <rth@twiddle.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mikael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: [PATCH -v7 1/3] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
Date: Fri,  3 Dec 2010 10:46:56 +0800
Message-Id: <1291344418-25206-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291344418-25206-1-git-send-email-ying.huang@intel.com>
References: <1291344418-25206-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmpxchg() is widely used by lockless code, including NMI-safe lockless
code.  But on some architectures, the cmpxchg() implementation is not
NMI-safe, on these architectures the lockless code may need to a
spin_trylock_irqsave() based implementation.

This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
NMI-safe lockless code can depend on it or provide different
implementation according to it.

On many architectures, cmpxchg is only NMI-safe for several specific
operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
CC: Richard Henderson <rth@twiddle.net>
CC: Russell King <linux@arm.linux.org.uk>
CC: Mikael Starvik <starvik@axis.com>
CC: David Howells <dhowells@redhat.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Tony Luck <tony.luck@intel.com>
CC: Hirokazu Takata <takata@linux-m32r.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <monstr@monstr.eu>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Kyle McMartin <kyle@mcmartin.ca>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Chen Liqin <liqin.chen@sunplusct.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Ingo Molnar <mingo@redhat.com>
CC: Chris Zankel <chris@zankel.net>
---
 arch/Kconfig         |    3 +++
 arch/alpha/Kconfig   |    1 +
 arch/avr32/Kconfig   |    1 +
 arch/frv/Kconfig     |    1 +
 arch/ia64/Kconfig    |    1 +
 arch/m68k/Kconfig    |    1 +
 arch/parisc/Kconfig  |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/sh/Kconfig      |    1 +
 arch/sparc/Kconfig   |    1 +
 arch/tile/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 13 files changed, 15 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_PERF_EVENTS_NMI
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
+config ARCH_HAVE_NMI_SAFE_CMPXCHG
+	bool
+
 source "kernel/gcov/Kconfig"
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DMA_ATTRS
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -6,6 +6,7 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -5,6 +5,7 @@ config FRV
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 config ZONE_DMA
 	bool
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -22,6 +22,7 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -4,6 +4,7 @@ config M68K
 	select HAVE_AOUT
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 
 config MMU
 	bool
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -11,6 +11,7 @@ config PARISC
 	select BUG
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_ATOMIC64 if !64BIT
 	select GENERIC_HARDIRQS_NO__DO_IRQ
 	help
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,6 +138,7 @@ config PPC
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -94,6 +94,7 @@ config S390
 	select INIT_ALL_POSSIBLE
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -11,6 +11,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -22,6 +22,7 @@ config SPARC
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_IRQ_WORK
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -104,6 +104,7 @@ config TILE
 	select GENERIC_FIND_NEXT_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -23,6 +23,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
