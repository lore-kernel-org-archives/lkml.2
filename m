Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2JPUF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:05:57 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:47217 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2JPUFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:05:54 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v7 1/5] tracing,x86: Add a TSC trace_clock
Date: Tue, 16 Oct 2012 13:05:45 -0700
Message-Id: <1350417945-32224-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350042118.24256.93.camel@gandalf.local.home>
References: <1350042118.24256.93.camel@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to promote interoperability between userspace tracers and ftrace,
add a trace_clock that reports raw TSC values which will then be recorded
in the ring buffer. Userspace tracers that also record TSCs are then on
exactly the same time base as the kernel and events can be unambiguously
interlaced.

Tested: Enabled a tracepoint and the "tsc" trace_clock and saw very large
timestamp values.

v2:
Move arch-specific bits out of generic code.
v3:
Rename "x86-tsc", cleanups
v7:
Generic arch bits in Kbuild.

Google-Bug-Id: 6980623
Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/Kbuild      |    1 +
 arch/arm/include/asm/Kbuild        |    1 +
 arch/arm64/include/asm/Kbuild      |    1 +
 arch/avr32/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/Kbuild   |    1 +
 arch/c6x/include/asm/Kbuild        |    1 +
 arch/cris/include/asm/Kbuild       |    1 +
 arch/frv/include/asm/Kbuild        |    1 +
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/hexagon/include/asm/Kbuild    |    1 +
 arch/ia64/include/asm/Kbuild       |    1 +
 arch/m32r/include/asm/Kbuild       |    1 +
 arch/m68k/include/asm/Kbuild       |    1 +
 arch/microblaze/include/asm/Kbuild |    1 +
 arch/mips/include/asm/Kbuild       |    1 +
 arch/mn10300/include/asm/Kbuild    |    1 +
 arch/openrisc/include/asm/Kbuild   |    1 +
 arch/parisc/include/asm/Kbuild     |    1 +
 arch/powerpc/include/asm/Kbuild    |    1 +
 arch/s390/include/asm/Kbuild       |    1 +
 arch/score/include/asm/Kbuild      |    1 +
 arch/sh/include/asm/Kbuild         |    1 +
 arch/sparc/include/asm/Kbuild      |    1 +
 arch/tile/include/asm/Kbuild       |    1 +
 arch/um/include/asm/Kbuild         |    1 +
 arch/unicore32/include/asm/Kbuild  |    1 +
 arch/x86/include/asm/trace_clock.h |   16 ++++++++++++++++
 arch/x86/kernel/Makefile           |    1 +
 arch/x86/kernel/trace_clock.c      |   21 +++++++++++++++++++++
 arch/xtensa/include/asm/Kbuild     |    1 +
 include/asm-generic/trace_clock.h  |   16 ++++++++++++++++
 include/linux/trace_clock.h        |    2 ++
 kernel/trace/trace.c               |    1 +
 33 files changed, 84 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/trace_clock.h
 create mode 100644 arch/x86/kernel/trace_clock.c
 create mode 100644 include/asm-generic/trace_clock.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 64ffc9e..dcfabb9 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -11,3 +11,4 @@ header-y += reg.h
 header-y += regdef.h
 header-y += sysinfo.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index f70ae17..514e398 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -31,5 +31,6 @@ generic-y += sockios.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += timex.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += unaligned.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index fe77e51..53a535a 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -44,6 +44,7 @@ generic-y += swab.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += unaligned.h
 generic-y += user.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 4807ded..4dd4f78 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 generic-y	+= clkdev.h
 generic-y	+= exec.h
+generic-y	+= trace_clock.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 5a0625a..27d7075 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -38,6 +38,7 @@ generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 112a496..eae7b59 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -49,6 +49,7 @@ generic-y += termbits.h
 generic-y += termios.h
 generic-y += tlbflush.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 6d43a95..15a122c 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -11,3 +11,4 @@ header-y += sync_serial.h
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += trace_clock.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 4a159da..c5d7670 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index 50bbf38..4bc8ae7 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += trace_clock.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 3364b696..c267595 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -51,6 +51,7 @@ generic-y += stat.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 4a159da..c5d7670 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 50bbf38..4bc8ae7 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += module.h
+generic-y += trace_clock.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index ecb5408..fc347b6 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -26,6 +26,7 @@ generic-y += sections.h
 generic-y += siginfo.h
 generic-y += statfs.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += word-at-a-time.h
 generic-y += xor.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 8653072..2957fcc 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y  += elf.h
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index e69de29..9596f39 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -0,0 +1 @@
+generic-y += trace_clock.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index 4a159da..c5d7670 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 78de680..8971026 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -60,6 +60,7 @@ generic-y += swab.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += user.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index 458371a..77f41b2 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,3 +4,4 @@ header-y += pdc.h
 generic-y += clkdev.h
 generic-y += word-at-a-time.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index a4fe15e..2d62b48 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -2,3 +2,4 @@
 
 generic-y += clkdev.h
 generic-y += rwsem.h
+generic-y += trace_clock.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 0633dc6..f313f9c 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,3 +1,4 @@
 
 
 generic-y += clkdev.h
+generic-y += trace_clock.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index ec697ae..16e41fe 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y +=
 
 generic-y += clkdev.h
+generic-y += trace_clock.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index 86eadce..a054a00 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -32,6 +32,7 @@ generic-y += socket.h
 generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += trace_clock.h
 generic-y += ucontext.h
 generic-y += xor.h
 
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 645a58d..e26d430 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -8,4 +8,5 @@ generic-y += local64.h
 generic-y += irq_regs.h
 generic-y += local.h
 generic-y += module.h
+generic-y += trace_clock.h
 generic-y += word-at-a-time.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index c68808a..568a4ab 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -36,6 +36,7 @@ generic-y += sockios.h
 generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += xor.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 0f6e7b3..b30f34a 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -2,3 +2,4 @@ generic-y += bug.h cputime.h device.h emergency-restart.h futex.h hardirq.h
 generic-y += hw_irq.h irq_regs.h kdebug.h percpu.h sections.h topology.h xor.h
 generic-y += ftrace.h pci.h io.h param.h delay.h mutex.h current.h exec.h
 generic-y += switch_to.h clkdev.h
+generic-y += trace_clock.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index c910c98..7be503e 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -54,6 +54,7 @@ generic-y += syscalls.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trace_clock.h
new file mode 100644
index 0000000..7ee0d8c
--- /dev/null
+++ b/arch/x86/include/asm/trace_clock.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_X86_TRACE_CLOCK_H
+#define _ASM_X86_TRACE_CLOCK_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_X86_TSC
+
+extern u64 notrace trace_clock_x86_tsc(void);
+
+# define ARCH_TRACE_CLOCKS \
+	{ trace_clock_x86_tsc,	"x86-tsc" },
+
+#endif
+
+#endif  /* _ASM_X86_TRACE_CLOCK_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 91ce48f..b2bb37f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
+obj-$(CONFIG_X86_TSC)		+= trace_clock.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/trace_clock.c b/arch/x86/kernel/trace_clock.c
new file mode 100644
index 0000000..25b9937
--- /dev/null
+++ b/arch/x86/kernel/trace_clock.c
@@ -0,0 +1,21 @@
+/*
+ * X86 trace clocks
+ */
+#include <asm/trace_clock.h>
+#include <asm/barrier.h>
+#include <asm/msr.h>
+
+/*
+ * trace_clock_x86_tsc(): A clock that is just the cycle counter.
+ *
+ * Unlike the other clocks, this is not in nanoseconds.
+ */
+u64 notrace trace_clock_x86_tsc(void)
+{
+	u64 ret;
+
+	rdtsc_barrier();
+	rdtscll(ret);
+
+	return ret;
+}
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index fccd81e..446ad46 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -2,3 +2,4 @@ include include/asm-generic/Kbuild.asm
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += trace_clock.h
diff --git a/include/asm-generic/trace_clock.h b/include/asm-generic/trace_clock.h
new file mode 100644
index 0000000..6726f1b
--- /dev/null
+++ b/include/asm-generic/trace_clock.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_GENERIC_TRACE_CLOCK_H
+#define _ASM_GENERIC_TRACE_CLOCK_H
+/*
+ * Arch-specific trace clocks.
+ */
+
+/*
+ * Additional trace clocks added to the trace_clocks
+ * array in kernel/trace/trace.c
+ * None if the architecture has not defined it.
+ */
+#ifndef ARCH_TRACE_CLOCKS
+# define ARCH_TRACE_CLOCKS
+#endif
+
+#endif  /* _ASM_GENERIC_TRACE_CLOCK_H */
diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 4eb4902..d563f37 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -12,6 +12,8 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+#include <asm/trace_clock.h>
+
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..9aed7f5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -481,6 +481,7 @@ static struct {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
 	{ trace_clock_counter,	"counter" },
+	ARCH_TRACE_CLOCKS
 };
 
 int trace_clock_id;
-- 
1.7.7.3

