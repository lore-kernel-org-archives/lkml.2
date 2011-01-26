Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1AZMKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:10:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:39678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1AZMKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:10:37 -0500
Date: Wed, 26 Jan 2011 12:10:13 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110122044851.825284940@google.com>
References: <20110122044851.825284940@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix/remove redundant cfs_rq checks
Message-ID: <tip-b815f1963e47b9b69bb17e0588bd5af5b1114ae0@git.kernel.org>
Git-Commit-ID: b815f1963e47b9b69bb17e0588bd5af5b1114ae0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 12:10:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b815f1963e47b9b69bb17e0588bd5af5b1114ae0
Gitweb:     http://git.kernel.org/tip/b815f1963e47b9b69bb17e0588bd5af5b1114ae0
Author:     Paul Turner <pjt@google.com>
AuthorDate: Fri, 21 Jan 2011 20:45:00 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 12:31:02 +0100

sched: Fix/remove redundant cfs_rq checks

Since updates are against an entity's queuing cfs_rq it's not possible to
enter update_cfs_{shares,load} with a NULL cfs_rq.  (Indeed, update_cfs_load
would crash prior to the check if we did anyway since we load is examined
during the initializers).

Also, in the update_cfs_load case there's no point
in maintaining averages for rq->cfs_rq since we don't perform shares
distribution at that level -- NULL check is replaced accordingly.

Thanks to Dan Carpenter for pointing out the deference before NULL check.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110122044851.825284940@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ccecfec..1997383 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -722,7 +722,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 	u64 now, delta;
 	unsigned long load = cfs_rq->load.weight;
 
-	if (!cfs_rq)
+	if (cfs_rq->tg == &root_task_group)
 		return;
 
 	now = rq_of(cfs_rq)->clock;
@@ -830,9 +830,6 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 	struct sched_entity *se;
 	long shares;
 
-	if (!cfs_rq)
-		return;
-
 	tg = cfs_rq->tg;
 	se = tg->se[cpu_of(rq_of(cfs_rq))];
 	if (!se)
