Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0EMHoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:44:10 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38629 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0EMHoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:44:05 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 1/4] ftrace syscalls: don't add events for unmapped syscalls
Date: Thu, 13 May 2010 17:43:11 +1000
Message-Id: <1273736594-19320-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
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
index 057929b..a970c24 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -186,6 +186,7 @@ struct perf_event_attr;
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
@@ -201,6 +202,7 @@ struct perf_event_attr;
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d6d711..732f021 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -381,6 +381,14 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
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

