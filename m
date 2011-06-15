Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1FOJv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:51:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:55139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1FOJvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:51:25 -0400
Date: Wed, 15 Jun 2011 09:50:50 GMT
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-0da938c44921cfb690283d3b0c9c48a10375db2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, rostedt@goodmis.org,
        habanero@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, habanero@linux.vnet.ibm.com,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110614223657.824872966@goodmis.org>
References: <20110614223657.824872966@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Check if lowest_mask is initialized in find_lowest_rq()
Git-Commit-ID: 0da938c44921cfb690283d3b0c9c48a10375db2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Jun 2011 09:50:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0da938c44921cfb690283d3b0c9c48a10375db2c
Gitweb:     http://git.kernel.org/tip/0da938c44921cfb690283d3b0c9c48a10375db2c
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Tue, 14 Jun 2011 18:36:25 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Jun 2011 11:44:48 +0200

sched: Check if lowest_mask is initialized in find_lowest_rq()

On system boot up, the lowest_mask is initialized with an
early_initcall(). But RT tasks may wake up on other
early_initcall() callers before the lowest_mask is initialized,
causing a system crash.

Commit "d72bce0e67 rcu: Cure load woes" was the first commit
to wake up RT tasks in early init. Before this commit this bug
should not happen.

Reported-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
Tested-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110614223657.824872966@goodmis.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9b8d5dc..10d0182 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
+	/* Make sure the mask is initialized first */
+	if (unlikely(!lowest_mask))
+		return -1;
+
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
