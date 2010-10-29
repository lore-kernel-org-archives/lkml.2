Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675Ab0J2TCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:02:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59617 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761125Ab0J2TBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:01:38 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=N3eiN3exGEgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=mDV3o1hIAAAA:8 a=oGMlB6cnAAAA:8 a=enOvQawGAAAA:8 a=7d_E57ReAAAA:8 a=3nbZYyFuAAAA:8 a=J1Y8HTJGAAAA:8 a=meVymXHHAAAA:8 a=wPzXFYsA6dGGu-fy9fEA:9 a=eKelk5N8o4ai1l-oFS8A:7 a=yQ6hjWSKeS6uv9HU_ua-rJPyEDoA:4 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=bkT6KWdcy0IA:10 a=D6-X0JM3zdQA:10 a=EvKJbDF4Ut8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029190136.494851966@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 15:00:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Miller <davem@davemloft.net>, Richard Henderson <rth@redhat.com>
Subject: [PATCH 7/7] jump label: Add work around to i386 gcc asm goto bug
References: <20101029190050.674141729@goodmis.org>
Content-Disposition: inline; filename=0007-jump-label-Add-work-around-to-i386-gcc-asm-goto-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

On i386 (not x86_64) early implementations of gcc would have a bug
with asm goto causing it to produce code like the following:

(This was noticed by Peter Zijlstra)

   56 pushl 0
   67 nopl         jmp 0x6f
      popl
      jmp 0x8c

   6f              mov
                   test
                   je 0x8c

   8c mov
      call *(%esp)

The jump added in the asm goto skipped over the popl that matched
the pushl 0, which lead up to a quick crash of the system when
the jump was enabled. The nopl is defined in the asm goto () statement
and when tracepoints are enabled, the nop changes to a jump to the label
that was specified by the asm goto. asm goto is suppose to tell gcc that
the code in the asm might jump to an external label. Here gcc obviously
fails to make that work.

The bug report for gcc is here:

  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=46226

The bug only appears on x86 when not compiled with
-maccumulate-outgoing-args. This option is always set on x86_64 and it
is also the work around for a function graph tracer i386 bug.
(See commit: 746357d6a526d6da9d89a2ec645b28406e959c2e)
This explains why the bug only showed up on i386 when function graph
tracer was not enabled.

This patch now adds a CONFIG_JUMP_LABEL option that is default
off instead of using jump labels by default. When jump labels are
enabled, the -maccumulate-outgoing-args will be used (causing a
slightly larger kernel image on i386). This option will exist
until we have a way to detect if the gcc compiler in use is safe
to use on all configurations without the work around.

Note, there exists such a test, but for now we will keep the enabling
of jump label as a manual option.

Archs that know the compiler is safe with asm goto, may choose to
select JUMP_LABEL and enable it by default.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cause-discovered-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Baron <jbaron@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Miller <davem@davemloft.net>
Cc: Richard Henderson <rth@redhat.com>
LKML-Reference: <1288028746.3673.11.camel@laptop>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/Kconfig               |   14 ++++++++++++++
 arch/x86/Makefile_32.cpu   |   13 ++++++++++++-
 include/linux/jump_label.h |    2 +-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 53d7f61..8bf0fa6 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -42,6 +42,20 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config JUMP_LABEL
+       bool "Optimize trace point call sites"
+       depends on HAVE_ARCH_JUMP_LABEL
+       help
+         If it is detected that the compiler has support for "asm goto",
+	 the kernel will compile trace point locations with just a
+	 nop instruction. When trace points are enabled, the nop will
+	 be converted to a jump to the trace function. This technique
+	 lowers overhead and stress on the branch prediction of the
+	 processor.
+
+	 On i386, options added to the compiler flags may increase
+	 the size of the kernel slightly.
+
 config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 1255d95..f2ee1ab 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -51,7 +51,18 @@ cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 # prologue (push %ebp, mov %esp, %ebp) which breaks the function graph
 # tracer assumptions. For i686, generic, core2 this is set by the
 # compiler anyway
-cflags-$(CONFIG_FUNCTION_GRAPH_TRACER) += $(call cc-option,-maccumulate-outgoing-args)
+ifeq ($(CONFIG_FUNCTION_GRAPH_TRACER), y)
+ADD_ACCUMULATE_OUTGOING_ARGS := y
+endif
+
+# Work around to a bug with asm goto with first implementations of it
+# in gcc causing gcc to mess up the push and pop of the stack in some
+# uses of asm goto.
+ifeq ($(CONFIG_JUMP_LABEL), y)
+ADD_ACCUMULATE_OUTGOING_ARGS := y
+endif
+
+cflags-$(ADD_ACCUMULATE_OUTGOING_ARGS) += $(call cc-option,-maccumulate-outgoing-args)
 
 # Bug fix for binutils: this option is required in order to keep
 # binutils from generating NOPL instructions against our will.
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 1947a12..7880f18 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_JUMP_LABEL_H
 #define _LINUX_JUMP_LABEL_H
 
-#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
 # include <asm/jump_label.h>
 # define HAVE_JUMP_LABEL
 #endif
-- 
1.7.1


