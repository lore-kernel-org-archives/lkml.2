Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1BHWRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:17:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab1BHWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:21 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=TjJJSEx2jpcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=GJuSPc5km73eeXFD_cAA:9 a=WOytl70XN9zWN97C32eT2q1A1F8A:4 a=jeBq3FmKZ4MA:10 a=EcPgJPn3AtsYiayE:21 a=xSpcNySbYN4rM6Fz:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221718.996649974@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 01/10] tracing/syscalls: Dont add events for unmapped syscalls
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-syscalls-Don-t-add-events-for-unmapped-sysca.patch
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
-- 
1.7.2.3


