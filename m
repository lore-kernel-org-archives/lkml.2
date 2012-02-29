Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041Ab2B1Klw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:41:52 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:59642 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964941Ab2B1Klv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:41:51 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 1/2] sched: entity load-tracking re-work - Fix for ARM
Date: Wed, 29 Feb 2012 10:37:38 +0000
Message-Id: <1330511859-22032-2-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
References: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------1.7.1
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


u64/u64 divisions caused undefined reference to `__aeabi_uldivmod'
Convert them to div_u64 calls.
---
 kernel/sched/fair.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


--------------1.7.1
Content-Type: text/x-patch; name="0001-sched-entity-load-tracking-re-work-Fix-for-ARM.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0001-sched-entity-load-tracking-re-work-Fix-for-ARM.patch"

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8b7f7a6..0cea5e4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1089,10 +1089,10 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 	struct task_group *tg = cfs_rq->tg;
 	long contrib, usage_contrib;
 
-	contrib = (sa->runnable_avg_sum << 12) / (sa->runnable_avg_period + 1);
+	contrib = div_u64(sa->runnable_avg_sum << 12, sa->runnable_avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
-	usage_contrib = (sa->usage_avg_sum << 12) / (sa->runnable_avg_period + 1);
+	usage_contrib = div_u64(sa->usage_avg_sum << 12, sa->runnable_avg_period + 1);
 	usage_contrib -= cfs_rq->tg_usage_contrib;
 
 	if ((abs(contrib) > cfs_rq->tg_runnable_contrib/64) ||
@@ -1110,9 +1110,9 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	struct cfs_rq *cfs_rq = group_cfs_rq(se);
 	struct task_group *tg = cfs_rq->tg;
 	int runnable_avg;
+	u64 contrib;
 
-	se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
-	se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
+	se->avg.load_avg_contrib = div_u64(contrib, atomic64_read(&tg->load_avg) + 1);
 
 	/*
 	 * Unlike a task-entity, a group entity may be using >=1 cpu globally.

--------------1.7.1--


