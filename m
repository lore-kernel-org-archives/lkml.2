Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0IQI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:59344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0IQI3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:29:18 -0400
Date: Fri, 17 Sep 2010 08:28:20 GMT
From: tip-bot for Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, will.deacon@arm.com, a.p.zijlstra@chello.nl,
        matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com, fweisbec@gmail.com,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, greenrd@greenrd.org, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com,
        fweisbec@gmail.com, rostedt@goodmis.org, stable@kernel.org,
        tglx@linutronix.de, prasad@linux.vnet.ibm.com, greenrd@greenrd.org,
        mingo@elte.hu
In-Reply-To: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
References: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw breakpoints: Fix pid namespace bug
Message-ID: <tip-068e35eee9ef98eb4cab55181977e24995d273be@git.kernel.org>
Git-Commit-ID: 068e35eee9ef98eb4cab55181977e24995d273be
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 08:28:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  068e35eee9ef98eb4cab55181977e24995d273be
Gitweb:     http://git.kernel.org/tip/068e35eee9ef98eb4cab55181977e24995d273be
Author:     Matt Helsley <matthltc@us.ibm.com>
AuthorDate: Mon, 13 Sep 2010 13:01:18 -0700
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Fri, 17 Sep 2010 04:42:59 +0200

hw breakpoints: Fix pid namespace bug

Hardware breakpoints can't be registered within pid namespaces
because tsk->pid is passed rather than the pid in the current
namespace.

(See https://bugzilla.kernel.org/show_bug.cgi?id=17281 )

This is a quick fix demonstrating the problem but is not the
best method of solving the problem since passing pids internally
is not the best way to avoid pid namespace bugs. Subsequent patches
will show a better solution.

Much thanks to Frederic Weisbecker <fweisbec@gmail.com> for doing
the bulk of the work finding this bug.

Reported-by: Robin Green <greenrd@greenrd.org>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: 2.6.33-2.6.35 <stable@kernel.org>
LKML-Reference: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hw_breakpoint.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index d71a987..c7c2aed 100644
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
 
