Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2IUScb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:32:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36634 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2IUSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:26 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 01/10] sched: entity load-tracking load_avg_ratio
Date: Fri, 21 Sep 2012 19:32:16 +0100
Message-Id: <1348252345-5642-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:23.0491 (UTC) FILETIME=[71420130:01CD9827]
X-MC-Unique: 112092119322404401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIXBtG011340

From: Morten Rasmussen <morten.rasmussen@arm.com>

This patch adds load_avg_ratio to each task. The load_avg_ratio is a
variant of load_avg_contrib which is not scaled by the task priority. It
is calculated like this:

runnable_avg_sum * NICE_0_LOAD / (runnable_avg_period + 1).

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/fair.c   |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4dc4990..81e4e82 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1151,6 +1151,7 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+	unsigned long load_avg_ratio;
 	u32 usage_avg_sum;
 };
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 095d86c..3e17dd5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1192,6 +1192,9 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+	contrib = se->avg.runnable_avg_sum * scale_load_down(NICE_0_LOAD);
+	contrib /= (se->avg.runnable_avg_period + 1);
+	se->avg.load_avg_ratio = scale_load(contrib);
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
-- 
1.7.9.5


