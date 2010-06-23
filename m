Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0FWKJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:09:49 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37750 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0FWKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:04:28 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Jason Baron <jbaron@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Ian Munsie <imunsie@au1.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 20/40] trace syscalls: Considder compat_syscall_nr when verifying syscall_nr
Date: Wed, 23 Jun 2010 20:03:01 +1000
Message-Id: <1277287401-28571-21-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

With the new compat syscall tracing, either syscall_nr or
compat_syscall_nr may be set, so test both before assuming that the
initialisation failed.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/trace/trace_syscalls.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9010405..264441e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -441,10 +441,12 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
-	int num;
+	int num, compat_num;
 
 	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls) {
+	compat_num = ((struct syscall_metadata *)call->data)->compat_syscall_nr;
+	if ((       num < 0 ||        num >= NR_syscalls) &&
+	    (compat_num < 0 || compat_num >= NR_syscalls)) {
 		pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
 				((struct syscall_metadata *)call->data)->name);
 		return -ENOSYS;
-- 
1.7.1

