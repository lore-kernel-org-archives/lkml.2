Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1DTUwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1DTUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=AY7pkSna8Xv3mpeDJ7sj3ouTnMANwLf536ZLOOBppg/Rtfc3NhBq2B3vJznrrS7/X
	uOdJ9YOSNoYCjMVgZLdyw==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 15/18] sched: update h_load to use u64
Date: Wed, 20 Apr 2011 13:51:34 -0700
Message-Id: <1303332697-16426-16-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate tg->h_load using u64 to handle u64 load weights.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8047f10..7c1f3fc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -354,7 +354,7 @@ struct cfs_rq {
 	 * Where f(tg) is the recursive weight fraction assigned to
 	 * this group.
 	 */
-	unsigned long h_load;
+	u64 h_load;
 
 	/*
 	 * Maintaining per-cpu shares distribution for group scheduling
@@ -1541,15 +1541,17 @@ static unsigned long cpu_avg_load_per_task(int cpu)
  */
 static int tg_load_down(struct task_group *tg, void *data)
 {
-	unsigned long load;
+	u64 load;
 	long cpu = (long)data;
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
 	} else {
-		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		u64 parent_h_load = tg->parent->cfs_rq[cpu]->h_load;
+		u64 parent_weight = tg->parent->cfs_rq[cpu]->load.weight;
+
+		load = div64_u64(parent_h_load * tg->se[cpu]->load.weight,
+				 parent_weight + 1);
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
-- 
1.7.3.1

