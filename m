Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2GXOUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:20:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2GXOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:20:33 -0400
Date: Tue, 24 Jul 2012 07:20:06 -0700
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-bbf18b19495942cc730e8ff11fc3ffadf20cbfe1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        prashanth@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        prashanth@linux.vnet.ibm.com
In-Reply-To: <4FE06EEF.2090709@linux.vnet.ibm.com>
References: <4FE06EEF.2090709@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Reset loop counters if all tasks are pinned and we need to redo load balance
Git-Commit-ID: bbf18b19495942cc730e8ff11fc3ffadf20cbfe1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 24 Jul 2012 07:20:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bbf18b19495942cc730e8ff11fc3ffadf20cbfe1
Gitweb:     http://git.kernel.org/tip/bbf18b19495942cc730e8ff11fc3ffadf20cbfe1
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Tue, 19 Jun 2012 17:52:07 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Jul 2012 13:55:37 +0200

sched: Reset loop counters if all tasks are pinned and we need to redo load balance

While load balancing, if all tasks on the source runqueue are pinned,
we retry after excluding the corresponding source cpu. However, loop counters
env.loop and env.loop_break are not reset before retrying, which can lead
to failure in moving the tasks. In this patch we reset env.loop and
env.loop_break to their inital values before we retry.

Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FE06EEF.2090709@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9361669..f9f9aa0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4288,8 +4288,11 @@ more_balance:
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus))
+			if (!cpumask_empty(cpus)) {
+				env.loop = 0;
+				env.loop_break = sched_nr_migrate_break;
 				goto redo;
+			}
 			goto out_balanced;
 		}
 	}
