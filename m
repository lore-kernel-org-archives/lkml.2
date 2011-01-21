Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1AUSHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:07:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab1AUSHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:07:04 -0500
Date: Fri, 21 Jan 2011 18:45:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        linux-tip-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] perf: perf_event_exit_task_context:
	s/rcu_dereference/rcu_dereference_raw/
Message-ID: <20110121174547.GA8796@redhat.com>
References: <20110119182207.GB12183@redhat.com> <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org> <20110121152939.GA28552@elte.hu> <20110121155323.GA2988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121155323.GA2988@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory, almost every user of task->child->perf_event_ctxp[]
is wrong. find_get_context() can install the new context at any
moment, we need read_barrier_depends().

dbe08d82ce3967ccdf459f7951d02589cf967300 "perf: Fix
find_get_context() vs perf_event_exit_task() race" added
rcu_dereference() into perf_event_exit_task_context() to make
the precedent, but this makes __rcu_dereference_check() unhappy.
Use rcu_dereference_raw() to shut up the warning.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- git/kernel/perf_event.c~6_rcu_check	2011-01-19 18:49:23.000000000 +0100
+++ git/kernel/perf_event.c	2011-01-21 18:41:02.000000000 +0100
@@ -6133,7 +6133,7 @@ static void perf_event_exit_task_context
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
+	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
 	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*

