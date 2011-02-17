Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1BQO7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:59:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:37925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1BQO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:59:49 -0500
Date: Thu, 17 Feb 2011 14:59:28 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1296703645-18718-4-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-4-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Make arch_syscall_addr weak
Message-ID: <tip-c763ba06bd9b5db2c46c36276c89103d92d2c604@git.kernel.org>
Git-Commit-ID: c763ba06bd9b5db2c46c36276c89103d92d2c604
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 14:59:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c763ba06bd9b5db2c46c36276c89103d92d2c604
Gitweb:     http://git.kernel.org/tip/c763ba06bd9b5db2c46c36276c89103d92d2c604
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 3 Feb 2011 14:27:22 +1100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Feb 2011 21:26:22 -0500

tracing/syscalls: Make arch_syscall_addr weak

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
