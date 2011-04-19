Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1DSMGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:06:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1DSMG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:06:29 -0400
Date: Tue, 19 Apr 2011 12:06:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-057f3fadb347e9c51b07e1b277bbdda79f976768@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1302882741.2388.241.camel@twins>
References: <1302882741.2388.241.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix sched_domain iterations vs. RCU
Git-Commit-ID: 057f3fadb347e9c51b07e1b277bbdda79f976768
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 12:06:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  057f3fadb347e9c51b07e1b277bbdda79f976768
Gitweb:     http://git.kernel.org/tip/057f3fadb347e9c51b07e1b277bbdda79f976768
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 18 Apr 2011 11:24:34 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 10:56:54 +0200

sched: Fix sched_domain iterations vs. RCU

Vladis Kletnieks reported a new RCU debug warning in the scheduler.

Since commit dce840a08702b ("sched: Dynamically allocate sched_domain/
sched_group data-structures") the sched_domain trees are protected by
RCU instead of RCU-sched.

This means that we need to include rcu_read_lock() protection when we
iterate them since disabling preemption doesn't suffice anymore.

Reported-by: Valdis.Kletnieks@vt.edu
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1302882741.2388.241.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0cfe031..27d3e73 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1208,11 +1208,17 @@ int get_nohz_timer_target(void)
 	int i;
 	struct sched_domain *sd;
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd))
-			if (!idle_cpu(i))
-				return i;
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (!idle_cpu(i)) {
+				cpu = i;
+				goto unlock;
+			}
+		}
 	}
+unlock:
+	rcu_read_unlock();
 	return cpu;
 }
 /*
@@ -2415,12 +2421,14 @@ ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 		struct sched_domain *sd;
 
 		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+		rcu_read_lock();
 		for_each_domain(this_cpu, sd) {
 			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 				schedstat_inc(sd, ttwu_wake_remote);
 				break;
 			}
 		}
+		rcu_read_unlock();
 	}
 #endif /* CONFIG_SMP */
 
