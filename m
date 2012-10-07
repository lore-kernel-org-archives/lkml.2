Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2JGHpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 03:45:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61716 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2JGHon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 03:44:43 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 5/6] sched: pack the idle load balance
Date: Sun,  7 Oct 2012 09:43:57 +0200
Message-Id: <1349595838-31274-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Look for an idle CPU close the pack buddy CPU whenever possible.
The goal is to prevent the wake up of a CPU which doesn't share the power
line of the pack CPU

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6df53b5..f76acdc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5158,7 +5158,25 @@ static struct {
 
 static inline int find_new_ilb(int call_cpu)
 {
+	struct sched_domain *sd;
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int buddy = per_cpu(sd_pack_buddy, call_cpu);
+
+	/*
+	 * If we have a pack buddy CPU, we try to run load balance on a CPU
+	 * that is close to the buddy.
+	 */
+	if (buddy != -1)
+		for_each_domain(buddy, sd) {
+			if (sd->flags & SD_SHARE_CPUPOWER)
+				continue;
+
+			ilb = cpumask_first_and(sched_domain_span(sd),
+					nohz.idle_cpus_mask);
+
+			if (ilb < nr_cpu_ids)
+				break;
+		}
 
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
-- 
1.7.9.5

