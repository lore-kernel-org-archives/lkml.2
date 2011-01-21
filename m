Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1AUWNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:13:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:58409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab1AUWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:13:19 -0500
Date: Fri, 21 Jan 2011 22:12:43 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110121174547.GA8796@redhat.com>
References: <20110121174547.GA8796@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: perf_event_exit_task_context: s/rcu_dereference/rcu_dereference_raw/
Message-ID: <tip-806839b22cbda90176d7f8d421889bddd7826e93@git.kernel.org>
Git-Commit-ID: 806839b22cbda90176d7f8d421889bddd7826e93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 22:12:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  806839b22cbda90176d7f8d421889bddd7826e93
Gitweb:     http://git.kernel.org/tip/806839b22cbda90176d7f8d421889bddd7826e93
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 21 Jan 2011 18:45:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Jan 2011 22:08:16 +0100

perf: perf_event_exit_task_context: s/rcu_dereference/rcu_dereference_raw/

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
Cc: acme@redhat.com
Cc: paulus@samba.org
Cc: stern@rowland.harvard.edu
Cc: a.p.zijlstra@chello.nl
Cc: fweisbec@gmail.com
Cc: roland@redhat.com
Cc: prasad@linux.vnet.ibm.com
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <20110121174547.GA8796@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c5fa717..126a302 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6136,7 +6136,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
+	child_ctx = rcu_dereference_raw(child->perf_event_ctxp[ctxn]);
 	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
