Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1CHUQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:16:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:53577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1CHUQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:16:33 -0500
Date: Tue, 8 Mar 2011 20:15:50 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, npiggin@kernel.dk, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jolsa@redhat.com, fweisbec@gmail.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110307181039.GB15197@jolsa.redhat.com>
References: <20110307181039.GB15197@jolsa.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Separate out entry text section
Message-ID: <tip-ea7145477a461e09d8d194cac4b996dc4f449107@git.kernel.org>
Git-Commit-ID: ea7145477a461e09d8d194cac4b996dc4f449107
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 08 Mar 2011 20:15:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea7145477a461e09d8d194cac4b996dc4f449107
Gitweb:     http://git.kernel.org/tip/ea7145477a461e09d8d194cac4b996dc4f449107
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 7 Mar 2011 19:10:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Mar 2011 17:22:11 +0100

x86: Separate out entry text section

Put x86 entry code into a separate link section: .entry.text.

Separating the entry text section seems to have performance
benefits - caused by more efficient instruction cache usage.

Running hackbench with perf stat --repeat showed that the change
compresses the icache footprint. The icache load miss rate went
down by about 15%:

 before patch:
         19417627  L1-icache-load-misses      ( +-   0.147% )

 after patch:
         16490788  L1-icache-load-misses      ( +-   0.180% )

The motivation of the patch was to fix a particular kprobes
bug that relates to the entry text section, the performance
advantage was discovered accidentally.

Whole perf output follows:

 - results for current tip tree:

  Performance counter stats for './hackbench/hackbench 10' (500 runs):

         19417627  L1-icache-load-misses      ( +-   0.147% )
       2676914223  instructions             #      0.497 IPC     ( +- 0.079% )
       5389516026  cycles                     ( +-   0.144% )

      0.206267711  seconds time elapsed   ( +-   0.138% )

 - results for current tip tree with the patch applied:

  Performance counter stats for './hackbench/hackbench 10' (500 runs):

         16490788  L1-icache-load-misses      ( +-   0.180% )
       2717734941  instructions             #      0.502 IPC     ( +- 0.079% )
       5414756975  cycles                     ( +-   0.148% )

      0.206747566  seconds time elapsed   ( +-   0.137% )

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: masami.hiramatsu.pt@hitachi.com
Cc: ananth@in.ibm.com
Cc: davem@davemloft.net
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20110307181039.GB15197@jolsa.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/ia32/ia32entry.S         |    2 ++
 arch/x86/kernel/entry_32.S        |    6 ++++--
 arch/x86/kernel/entry_64.S        |    6 ++++--
 arch/x86/kernel/vmlinux.lds.S     |    1 +
 include/asm-generic/sections.h    |    1 +
 include/asm-generic/vmlinux.lds.h |    6 ++++++
 6 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..f729b2e 100644
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
index c8b4efa..f5accf8 100644
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
+.section .entry.text, "ax"
 	.p2align 5
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 ENTRY(irq_entries_start)
@@ -807,7 +809,7 @@ vector=FIRST_EXTERNAL_VECTOR
       .endif
       .previous
 	.long 1b
-      .text
+      .section .entry.text, "ax"
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
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index bf47007..6d4341d 100644
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
