Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0FWKKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:00 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47758 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab0FWKE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:27 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 19/40] trace syscalls: Remove redundant syscall_nr checks
Date: Wed, 23 Jun 2010 20:03:00 +1000
Message-Id: <1277287401-28571-20-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

With the ftrace events now checking if the syscall_nr is valid upon
initialisation, there is no need to verify it when registering and
unregistering the events, so remove the check.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 6acba20..9010405 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -391,11 +391,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, NULL);
@@ -409,11 +405,6 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 
 void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_enter--;
 	((struct syscall_metadata *)call->data)->ftrace_enter = 0;
@@ -425,11 +416,7 @@ void unreg_event_syscall_enter(struct ftrace_event_call *call)
 int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
-	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, NULL);
@@ -443,11 +430,6 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 
 void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls)
-		return;
 	mutex_lock(&syscall_trace_lock);
 	sys_refcount_exit--;
 	((struct syscall_metadata *)call->data)->ftrace_exit = 0;
-- 
1.7.1

