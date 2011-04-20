Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1DTUzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:55:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab1DTUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=UnKHDLoqta4KKidEge/d1eT+FCIuIKSBpi/F7UhPaG5ltCFlUb2c7+ds9hv6YOCLX
	kHIOymgXr05KD51wHNDWg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 17/18] sched: update f_b_q() to use u64 for weighted cpuload
Date: Wed, 20 Apr 2011 13:51:36 -0700
Message-Id: <1303332697-16426-18-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update f_b_q() to use u64 when comparing loads.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 386d832..33c36f1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3203,14 +3203,14 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		   const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	u64 max_load = 0;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long power = power_of(i);
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
-		unsigned long wl;
+		u64 wl;
 
 		if (!capacity)
 			capacity = fix_small_capacity(sd, group);
@@ -3234,7 +3234,7 @@ find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
+		wl = div_u64(wl * SCHED_POWER_SCALE, power);
 
 		if (wl > max_load) {
 			max_load = wl;
-- 
1.7.3.1

