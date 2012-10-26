Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2JZJki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:40:38 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50717 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2JZJkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:40:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] rcu: Fix unrecovered RCU user mode in syscall_trace_leave()
Date: Fri, 26 Oct 2012 11:40:28 +0200
Message-Id: <1351244428-2277-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20121025074147.GA2240@swordfish>
References: <20121025074147.GA2240@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64 syscall exit, 3 non exclusive events may happen
looping in the following order:

1) Check if we need resched for user preemption, if so call
schedule_user()

2) Check if we have pending signals, if so call do_notify_resume()

3) Check if we do syscall tracing, if so call syscall_trace_leave()

However syscall_trace_leave() has been written assuming it directly
follows the syscall and forget about the above possible 1st and 2nd
steps.

Now schedule_user() and do_notify_resume() exit in RCU user mode
because they have most chances to resume userspace immediately and
this avoids an rcu_user_enter() call in the syscall fast path.

So by the time we call syscall_trace_leave(), we may well be in RCU
user mode. To fix this up, simply call rcu_user_exit() in the beginning
of this function.

This fixes some reported RCU uses in extended quiescent state.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b00b33a..eff5b8c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1511,6 +1511,13 @@ void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
+	/*
+	 * We may come here right after calling schedule_user()
+	 * or do_notify_resume(), in which case we can be in RCU
+	 * user mode.
+	 */
+	rcu_user_exit();
+
 	audit_syscall_exit(regs);
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
-- 
1.7.5.4

