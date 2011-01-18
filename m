Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1ARP2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 10:28:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1ARP2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:28:33 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tracing: remove superfluous sub instructions
Date: Tue, 18 Jan 2011 16:28:18 +0100
Message-Id: <1295364498-9288-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I think there's no need for substracting MCOUNT_INSN_SIZE from the
IP parameter before calling the function trace (/graph) handler.

Maybe I overlooked something, but all the IP usage I saw ended
up in the kallsyms_lookup function, which does the lookup using the
functions' start/end boundaries to find the correct symbol for pointer.

Thus it seems to me there's no point in substracting the
MCOUNT_INSN_SIZE value from the IP parameter.

I tested for x86_64 and got proper results, I believe it's
the same case for x86_32.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/entry_32.S |    3 ---
 arch/x86/kernel/entry_64.S |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 591e601..92cdb47 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1122,7 +1122,6 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
-	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
 ftrace_call:
@@ -1168,7 +1167,6 @@ trace:
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
-	subl $MCOUNT_INSN_SIZE, %eax
 
 	call *ftrace_trace_function
 
@@ -1191,7 +1189,6 @@ ENTRY(ftrace_graph_caller)
 	movl 0xc(%esp), %edx
 	lea 0x4(%ebp), %eax
 	movl (%ebp), %ecx
-	subl $MCOUNT_INSN_SIZE, %edx
 	call prepare_ftrace_return
 	popl %edx
 	popl %ecx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index d3b895f..662f8f6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -75,7 +75,6 @@ ENTRY(ftrace_caller)
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rdi
 
 GLOBAL(ftrace_call)
 	call ftrace_stub
@@ -115,7 +114,6 @@ trace:
 
 	movq 0x38(%rsp), %rdi
 	movq 8(%rbp), %rsi
-	subq $MCOUNT_INSN_SIZE, %rdi
 
 	call   *ftrace_trace_function
 
@@ -136,7 +134,6 @@ ENTRY(ftrace_graph_caller)
 	leaq 8(%rbp), %rdi
 	movq 0x38(%rsp), %rsi
 	movq (%rbp), %rdx
-	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
 
