Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1EBBUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:20:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1EBBTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=SSV3AAnTeZ/t6WIDRkTCGjPL9PARlG8A3GGXszxKCcQhVeo6jDHSnpEGk2Qu1ak1e
	C7lFLALRP1zMYvV3ZiACA==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 15/19] sched: update h_load to use u64
Date: Sun,  1 May 2011 18:19:13 -0700
Message-Id: <1304299157-25769-16-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate tg->h_load using u64 to handle u64 load weights.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 08dcd24..6b9b02a 100644
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
@@ -1540,15 +1540,17 @@ static unsigned long cpu_avg_load_per_task(int cpu)
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

