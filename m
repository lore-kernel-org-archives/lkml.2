Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1BNPMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:12:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab1BNPMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:12:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC,PATCH] kprobes - optimized kprobes might crash before setting kernel stack
Date: Mon, 14 Feb 2011 16:12:34 +0100
Message-Id: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

you can crash the kernel using kprobe tracer via:

echo "p system_call_after_swapgs" > ./kprobe_events
echo 1 > ./events/kprobes/enable

The reason is that at the system_call_after_swapgs label,
the kernel stack is not set up. If optimized kprobes are
enabled, the user space stack is being used in this case
(see optimized kprobe template) and this might result in a crash.

Looks like there are several places like this over the entry_$(BIT)
code. First I thought it'd be ok to localize those places, but
I haven't found any reasonable/maintainable way to disable only those
places.

So I switched off the whole entry code from optimizing, but this
also switch many safe places (attached patch - tested on x86_64).

Also not sure this crash falls in to the area of that once such
probe is used, user should know consequences..

any ideas?

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/ia32/ia32entry.S         |    2 ++
 arch/x86/kernel/entry_32.S        |    6 ++++--
 arch/x86/kernel/entry_64.S        |    6 ++++--
 arch/x86/kernel/kprobes.c         |    8 ++++++++
 arch/x86/kernel/vmlinux.lds.S     |    1 +
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |    6 ++++++
 7 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 0ed7896..50f1630 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -25,6 +25,8 @@
 #define sysretl_audit ia32_ret_from_sys_call
 #endif
 
+	.section .entry.text, "ax"
+
 #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
 
 	.macro IA32_ARG_FIXUP noebp=0
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..051b4e2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -65,6 +65,8 @@
 #define sysexit_audit	syscall_exit_work
 #endif
 
+	.section .entry.text, "ax"
+
 /*
  * We use macros for low-level operations which need to be overridden
  * for paravirtualization.  The following will never clobber any registers:
@@ -788,7 +790,7 @@ ENDPROC(ptregs_clone)
  */
 .section .init.rodata,"a"
 ENTRY(interrupt)
-.text
+.entry.text
 	.p2align 5
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 ENTRY(irq_entries_start)
@@ -807,7 +809,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .endif
       .previous
 	.long 1b
-      .text
+      .entry.text
 vector=vector+1
     .endif
   .endr
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..0a0ed79 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -61,6 +61,8 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 	.code64
+	.section .entry.text, "ax"
+
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
@@ -744,7 +746,7 @@ END(stub_rt_sigreturn)
  */
 	.section .init.rodata,"a"
 ENTRY(interrupt)
-	.text
+	.section .entry.text
 	.p2align 5
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 ENTRY(irq_entries_start)
@@ -763,7 +765,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .endif
       .previous
 	.quad 1b
-      .text
+      .section .entry.text
 vector=vector+1
     .endif
   .endr
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index d91c477..d03bc1e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1276,6 +1276,14 @@ static int __kprobes can_optimize(unsigned long paddr)
 	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
 		return 0;
 
+	/*
+	 * Do not optimize in the entry code due to the unstable
+	 * stack handling.
+	 */
+	if ((paddr >= (unsigned long ) __entry_text_start) &&
+	    (paddr <  (unsigned long ) __entry_text_end))
+		return 0;
+
 	/* Check there is enough space for a relative jump. */
 	if (size - offset < RELATIVEJUMP_SIZE)
 		return 0;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e9f7a3c..0381e1f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -105,6 +105,7 @@ SECTIONS
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		ENTRY_TEXT
 		IRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index b3bfabc..c1a1216 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -11,6 +11,7 @@ extern char _sinittext[], _einittext[];
 extern char _end[];
 extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
+extern char __entry_text_start[], __entry_text_end[];
 extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index fe77e33..906c3ce 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -424,6 +424,12 @@
 		*(.kprobes.text)					\
 		VMLINUX_SYMBOL(__kprobes_text_end) = .;
 
+#define ENTRY_TEXT							\
+		ALIGN_FUNCTION();					\
+		VMLINUX_SYMBOL(__entry_text_start) = .;			\
+		*(.entry.text)						\
+		VMLINUX_SYMBOL(__entry_text_end) = .;
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #define IRQENTRY_TEXT							\
 		ALIGN_FUNCTION();					\
-- 
1.7.1

