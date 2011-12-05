Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1LEPIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:08:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38028 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1LEPIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:08:51 -0500
Message-ID: <4EDCDE54.3030300@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 09:08:04 -0600
From: Mike wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Do not include throttled time as steal time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120515-7182-0000-0000-000000565BEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the linux kernel is running as the guest OS and is configured
for bandwidth control and steal time reporting, it can be confusing
to users to see the throttled time show up in the steal time stats.
The user will think they are not getting the cpu resources they have
been configured.

Signed-off-by: Mike Wolf <mjw@linux.vnet.ibm.com>
---
  kernel/sched_fair.c  |    4 ++--
  kernel/sched_stats.h |    7 ++++++-
  2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..a837e4e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -707,7 +707,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct 
sched_entity *se)

  #ifdef CONFIG_FAIR_GROUP_SCHED
  /* we need this in update_cfs_load and load-balance functions below */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
+inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
  # ifdef CONFIG_SMP
  static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
                          int global_update)
@@ -1420,7 +1420,7 @@ static inline int cfs_rq_throttled(struct cfs_rq 
*cfs_rq)
  }

  /* check whether cfs_rq, or any parent, is throttled */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
  {
      return cfs_rq->throttle_count;
  }
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 87f9e36..e30ff26 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -213,14 +213,19 @@ static inline void sched_info_queued(struct 
task_struct *t)
   * sched_info_queued() to mark that it has now again started waiting on
   * the runqueue.
   */
+extern inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
  static inline void sched_info_depart(struct task_struct *t)
  {
+    struct task_group *tg = task_group(t);
+    struct cfs_rq *cfs_rq;
      unsigned long long delta = task_rq(t)->clock -
                      t->sched_info.last_arrival;

+    cfs_rq = tg->cfs_rq[smp_processor_id()];
      rq_sched_info_depart(task_rq(t), delta);

-    if (t->state == TASK_RUNNING)
+
+    if (t->state == TASK_RUNNING && !throttled_hierarchy(cfs_rq))
          sched_info_queued(t);
  }

