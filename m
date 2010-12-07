Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0LGE32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:29:28 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38317 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab0LGE30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:29:26 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] ftrace syscalls: Make arch_syscall_addr weak
Date: Tue,  7 Dec 2010 15:29:08 +1100
Message-Id: <1291696151-4336-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
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
index 5e34b49..b31ea2d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -447,7 +447,7 @@ int init_syscall_trace(struct ftrace_event_call *call)
 	return id;
 }
 
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init __weak arch_syscall_addr(int nr)
 {
 	return (unsigned long)sys_call_table[nr];
 }
-- 
1.7.2.3

