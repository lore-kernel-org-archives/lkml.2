Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0FWKEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:04:08 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59715 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0FWKEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:05 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 01/40] ftrace syscalls: don't add events for unmapped syscalls
Date: Wed, 23 Jun 2010 20:02:42 +1000
Message-Id: <1277287401-28571-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

FTRACE_SYSCALLS would create events for each and every system call, even
if it had failed to map the system call's name with it's number. This
resulted in a number of events being created that would not behave as
expected.

This could happen, for example, on architectures who's symbol names are
unusual and will not match the system call name. It could also happen
with system calls which were mapped to sys_ni_syscall.

This patch changes the default system call number in the metadata to -1.
If the system call name from the metadata is not successfully mapped to
a system call number during boot, than the event initialisation routine
will now return an error, preventing the event from being created.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 include/linux/syscalls.h      |    2 ++
 kernel/trace/trace_syscalls.c |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 7f614ce..86f082b 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -159,6 +159,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
@@ -176,6 +177,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 34e3580..82246ce 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -431,6 +431,14 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
+	int num;
+
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	if (num < 0 || num >= NR_syscalls) {
+		pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
+				((struct syscall_metadata *)call->data)->name);
+		return -ENOSYS;
+	}
 
 	if (set_syscall_print_fmt(call) < 0)
 		return -ENOMEM;
-- 
1.7.1

