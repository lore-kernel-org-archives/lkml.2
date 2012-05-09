Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2EIO0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:26:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40940 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2EIO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:26:43 -0400
Date: Wed, 9 May 2012 07:26:31 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-v8zlrmgmkne3bkcy9dej1fvm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Let minimally loaded cpu balance the group
Git-Commit-ID: c22402a2f76e88b04b7a8b6c0597ad9ba6fd71de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:26:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c22402a2f76e88b04b7a8b6c0597ad9ba6fd71de
Gitweb:     http://git.kernel.org/tip/c22402a2f76e88b04b7a8b6c0597ad9ba6fd71de
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 20 Apr 2012 16:57:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:51 +0200

sched/fair: Let minimally loaded cpu balance the group

Currently we let the leftmost (or first idle) cpu ascend the
sched_domain tree and perform load-balancing. The result is that the
busiest cpu in the group might be performing this function and pull
more load to itself. The next load balance pass will then try to
equalize this again.

Change this to pick the least loaded cpu to perform higher domain
balancing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v8zlrmgmkne3bkcy9dej1fvm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 678966c..968ffee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3781,7 +3781,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 {
 	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned int balance_cpu = -1;
+	unsigned long balance_load = ~0UL;
 	unsigned long avg_load_per_task = 0;
 
 	if (local_group)
@@ -3797,12 +3798,11 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
-				first_idle_cpu = 1;
+			load = target_load(i, load_idx);
+			if (load < balance_load || idle_cpu(i)) {
+				balance_load = load;
 				balance_cpu = i;
 			}
-
-			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
 			if (load > max_cpu_load) {
