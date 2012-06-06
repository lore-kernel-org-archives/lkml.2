Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2FFPxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:53:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40224 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2FFPxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:53:40 -0400
Date: Wed, 6 Jun 2012 08:53:25 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-10717dcde10d09f9fcee53a12a4236af1a82b484@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
References: <1338965571-9812-1-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa: Load balance between remote nodes
Git-Commit-ID: 10717dcde10d09f9fcee53a12a4236af1a82b484
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:53:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10717dcde10d09f9fcee53a12a4236af1a82b484
Gitweb:     http://git.kernel.org/tip/10717dcde10d09f9fcee53a12a4236af1a82b484
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Wed, 6 Jun 2012 14:52:51 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 16:52:25 +0200

sched/numa: Load balance between remote nodes

Commit cb83b629b ("sched/numa: Rewrite the CONFIG_NUMA sched
domain support") removed the NODE sched domain and started checking
if the node distance in SLIT table is farther than REMOTE_DISTANCE,
if so, it will lose the load balance chance at exec/fork/wake_affine
points.

But actually, even the node distance is farther than REMOTE_DISTANCE.

Modern CPUs also has QPI like connections, which ensures that memory
access is not too slow between nodes. So the above change in behavior
on NUMA machine causes a performance regression on various benchmarks:
hackbench, tbench, netperf, oltp, etc.

This patch will recover the scheduler behavior to old mode on all my
Intel platforms: NHM EP/EX, WSM EP, SNB EP/EP4S, and thus fixes the
perfromance regressions. (all of them just have 2 kinds distance, 10, 21)

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338965571-9812-1-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c46958e..6546083 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6321,7 +6321,7 @@ static int sched_domains_curr_level;
 
 static inline int sd_local_flags(int level)
 {
-	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
+	if (sched_domains_numa_distance[level] > RECLAIM_DISTANCE)
 		return 0;
 
 	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
