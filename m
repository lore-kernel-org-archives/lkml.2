Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0J3Kmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 06:42:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0J3Kmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 06:42:49 -0400
Date: Sat, 30 Oct 2010 10:42:10 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srostedt@redhat.com, ddaney@caviumnetworks.com,
        tglx@linutronix.de, jbaron@redhat.com, rth@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        davem@davemloft.net, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, srostedt@redhat.com, ddaney@caviumnetworks.com,
        jbaron@redhat.com, tglx@linutronix.de, mingo@elte.hu, rth@redhat.com
In-Reply-To: <1288028746.3673.11.camel@laptop>
References: <1288028746.3673.11.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump label: Add work around to i386 gcc asm goto bug
Message-ID: <tip-45f81b1c96d9793e47ce925d257ea693ce0b193e@git.kernel.org>
Git-Commit-ID: 45f81b1c96d9793e47ce925d257ea693ce0b193e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Oct 2010 10:42:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45f81b1c96d9793e47ce925d257ea693ce0b193e
Gitweb:     http://git.kernel.org/tip/45f81b1c96d9793e47ce925d257ea693ce0b193e
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Fri, 29 Oct 2010 12:33:43 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 29 Oct 2010 14:45:29 -0400

jump label: Add work around to i386 gcc asm goto bug

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
index 53d7f61..8bf0fa65 100644
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
