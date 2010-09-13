Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0IMUBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:01:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45673 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0IMUBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:01:35 -0400
From: Matt Helsley <matthltc@us.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: containers@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>,
        Robin Green <greenrd@greenrd.org>, linux-kernel@vger.kernel.org,
        Prasad <prasad@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: [PATCH 1/3] hw breakpoints: Fix pid namespace bug
Date: Mon, 13 Sep 2010 13:01:18 -0700
Message-Id: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
References: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware breakpoints can't be registered within pid namespaces
because tsk->pid is passed rather than the pid in the current
namespace.

(See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )

This is a quick fix demonstrating the problem but is not the
best method of solving the problem since passing pids internally
is not the best way to avoid pid namespace bugs. Subsequent patches
will show a better solution.

Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing the
bulk of the work finding this bug.

Cc: Robin Green <greenrd@greenrd.org>
Cc: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/hw_breakpoint.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 3b2aaff..6122f02 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -433,7 +433,8 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, tsk->pid, triggered);
+	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
+						triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
-- 
1.6.3.3

