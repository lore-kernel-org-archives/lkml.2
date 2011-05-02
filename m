Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1EBBVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:21:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1EBBT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:19:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=XRlkQnoKJRHq4cKpxM2Ad0AyqoSL41Y0kxqeDQ8q6i8/uxtPJqUuECklu9CpI4NdH
	lIBURAntJ1K1D33j0N7gg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 10/19] sched: update wake_affine path to use u64, s64 for weights
Date: Sun,  1 May 2011 18:19:08 -0700
Message-Id: <1304299157-25769-11-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the s64/u64 math in wake_affine() and effective_load() to handle
increased resolution.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 49e1eeb..1e011b1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1388,7 +1388,7 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
  * of group shares between cpus. Assuming the shares were perfectly aligned one
  * can calculate the shift in shares.
  */
-static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
+static s64 effective_load(struct task_group *tg, int cpu, s64 wl, s64 wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
@@ -1396,7 +1396,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		return wl;
 
 	for_each_sched_entity(se) {
-		long lw, w;
+		s64 lw, w;
 
 		tg = se->my_q->tg;
 		w = se->my_q->load.weight;
@@ -1409,7 +1409,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		wl += w;
 
 		if (lw > 0 && wl < lw)
-			wl = (wl * tg->shares) / lw;
+			wl = div64_s64(wl * tg->shares, lw);
 		else
 			wl = tg->shares;
 
@@ -1504,7 +1504,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 	if (balanced ||
 	    (this_load <= load &&
-	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
+	     this_load + target_load(prev_cpu, idx) <= (u64)tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
-- 
1.7.3.1

