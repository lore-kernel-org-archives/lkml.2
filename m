Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab0FRKTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:19:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0FRKTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:19:09 -0400
Date: Fri, 18 Jun 2010 10:18:32 GMT
From: "tip-bot for Alex,Shi" <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin.zhang@intel.com, alex.shi@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, yanmin.zhang@intel.com, tglx@linutronix.de,
       alex.shi@intel.com, mingo@elte.hu
In-Reply-To: <1276754893.9452.5442.camel@debian>
References: <1276754893.9452.5442.camel@debian>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix over-scheduling bug
Message-ID: <tip-3c93717cfa51316e4dbb471e7c0f9d243359d5f8@git.kernel.org>
Git-Commit-ID: 3c93717cfa51316e4dbb471e7c0f9d243359d5f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:18:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c93717cfa51316e4dbb471e7c0f9d243359d5f8
Gitweb:     http://git.kernel.org/tip/3c93717cfa51316e4dbb471e7c0f9d243359d5f8
Author:     Alex,Shi <alex.shi@intel.com>
AuthorDate: Thu, 17 Jun 2010 14:08:13 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:45:25 +0200

sched: Fix over-scheduling bug

Commit e70971591 ("sched: Optimize unused cgroup configuration") introduced
an imbalanced scheduling bug.

If we do not use CGROUP, function update_h_load won't update h_load. When the
system has a large number of tasks far more than logical CPU number, the
incorrect cfs_rq[cpu]->h_load value will cause load_balance() to pull too
many tasks to the local CPU from the busiest CPU. So the busiest CPU keeps
going in a round robin. That will hurt performance.

The issue was found originally by a scientific calculation workload that
developed by Yanmin. With that commit, the workload performance drops
about 40%.

 CPU  before    after

 00   : 2       : 7
 01   : 1       : 7
 02   : 11      : 6
 03   : 12      : 7
 04   : 6       : 6
 05   : 11      : 7
 06   : 10      : 6
 07   : 12      : 7
 08   : 11      : 6
 09   : 12      : 6
 10   : 1       : 6
 11   : 1       : 6
 12   : 6       : 6
 13   : 2       : 6
 14   : 2       : 6
 15   : 1       : 6

Reviewed-by: Yanmin zhang <yanmin.zhang@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1276754893.9452.5442.camel@debian>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2aaceeb..6c9e7c8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1657,9 +1657,6 @@ static void update_shares(struct sched_domain *sd)
 
 static void update_h_load(long cpu)
 {
-	if (root_task_group_empty())
-		return;
-
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
