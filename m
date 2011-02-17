Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1BQO7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:59:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:46716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1BQO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:59:06 -0500
Date: Thu, 17 Feb 2011 14:58:40 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1296703645-18718-2-git-send-email-imunsie@au1.ibm.com>
References: <1296703645-18718-2-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/syscalls: Don't add events for unmapped syscalls
Message-ID: <tip-ba976970c79fd2fbfe1a4b3b6766a318f4eb9d4c@git.kernel.org>
Git-Commit-ID: ba976970c79fd2fbfe1a4b3b6766a318f4eb9d4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Feb 2011 14:58:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba976970c79fd2fbfe1a4b3b6766a318f4eb9d4c
Gitweb:     http://git.kernel.org/tip/ba976970c79fd2fbfe1a4b3b6766a318f4eb9d4c
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Thu, 3 Feb 2011 14:27:20 +1100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Feb 2011 21:24:44 -0500

tracing/syscalls: Don't add events for unmapped syscalls

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
LKML-Reference: <1296703645-18718-2-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/syscalls.h      |    2 ++
 kernel/trace/trace_syscalls.c |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 98664db..8e8968e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -158,6 +158,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
@@ -175,6 +176,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
+		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5c9fe08..a9ceabd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -424,6 +424,14 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
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
