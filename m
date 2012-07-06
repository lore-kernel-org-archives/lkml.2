Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2GFGWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:22:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab2GFGWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:22:42 -0400
Date: Thu, 5 Jul 2012 23:22:27 -0700
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-4d44f7090f8233f6994e7397679a32c81187506d@git.kernel.org>
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
Git-Commit-ID: 4d44f7090f8233f6994e7397679a32c81187506d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 05 Jul 2012 23:22:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d44f7090f8233f6994e7397679a32c81187506d
Gitweb:     http://git.kernel.org/tip/4d44f7090f8233f6994e7397679a32c81187506d
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Tue, 19 Jun 2012 17:52:07 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jul 2012 21:09:10 +0200

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
index 39b5771..3f94840 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4497,8 +4497,11 @@ more_balance:
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
