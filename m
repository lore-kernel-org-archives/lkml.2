Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1BHWSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:18:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1BHWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:22 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=4hGn3b3E1SwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=kBrPct84e81W01QraqcA:9 a=2rdvcA2eUZfVcOYS-c0A:7 a=NA8jB0EYigEVkoUokUUlRu5e85QA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221719.564787820@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 03/10] tracing/syscalls: Make arch_syscall_addr weak
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-syscalls-Make-arch_syscall_addr-weak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Some architectures use non-trivial system call tables and will not work
with the generic arch_syscall_addr code. For example, PowerPC64 uses a
table of twin long longs.

This patch makes the generic arch_syscall_addr weak to allow
architectures with non-trivial system call tables to override it.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
LKML-Reference: <1296703645-18718-4-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace-design.txt |    3 +++
 kernel/trace/trace_syscalls.c         |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index dc52bd4..6fca17b 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -247,6 +247,9 @@ You need very few things to get the syscalls tracing in an arch.
 - Support the TIF_SYSCALL_TRACEPOINT thread flags.
 - Put the trace_sys_enter() and trace_sys_exit() tracepoints calls from ptrace
   in the ptrace syscalls tracing path.
+- If the system call table on this arch is more complicated than a simple array
+  of addresses of the system calls, implement an arch_syscall_addr to return
+  the address of a given system call.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4230942..af83154 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -446,7 +446,7 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return id;
 }
 
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init __weak arch_syscall_addr(int nr)
 {
 	return (unsigned long)sys_call_table[nr];
 }
-- 
1.7.2.3


