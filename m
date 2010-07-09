Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0GID0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab0GID0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:26:51 -0400
Message-ID: <4C36964A.2050104@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:23:54 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 11/11] blkiocg async: Workload timeslice adjustment for
 async queues
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now async queues are not system-wide.  Workload timeslice was
calculated based on the assumption that async queues are system
wide.  This patch modifies it.

This is the only one modification for queue scheduling algorithm
by this patch series.

ToDo:
To investigate if more tuning is needed for non-system-wide
async queues.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/cfq-iosched.c |   56 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4186c30..f930dfd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2165,6 +2165,41 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
+#ifdef CONFIG_GROUP_IOSCHED_ASYNC
+static unsigned int adjust_async_slice(struct cfq_data *cfqd,
+				struct cfq_group *cfqg, unsigned int slice)
+{
+	/* Just scaling down according to the sync/async slice ratio
+	 * if async queues are not system wide. */
+	return slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
+}
+
+#else /* CONFIG_GROUP_IOSCHED_ASYNC */
+
+static unsigned int adjust_async_slice(struct cfq_data *cfqd,
+				struct cfq_group *cfqg, unsigned int slice)
+{
+	unsigned int new_slice;
+
+	/*
+	 * If async queues are system wide, just taking
+	 * proportion of queues with-in same group will lead to higher
+	 * async ratio system wide as generally root group is going
+	 * to have higher weight. A more accurate thing would be to
+	 * calculate system wide asnc/sync ratio.
+	 */
+	new_slice = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
+	new_slice = new_slic/cfqd->busy_queues;
+	new_slice = min_t(unsigned, slice, new_slice);
+
+	/* async workload slice is scaled down according to
+	 * the sync/async slice ratio. */
+	new_slice = new_slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
+
+	return new_slice;
+}
+#endif /* CONFIG_GROUP_IOSCHED_ASYNC */
+
 static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
@@ -2220,24 +2255,9 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
 		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
 
-	if (cfqd->serving_type == ASYNC_WORKLOAD) {
-		unsigned int tmp;
-
-		/*
-		 * Async queues are currently system wide. Just taking
-		 * proportion of queues with-in same group will lead to higher
-		 * async ratio system wide as generally root group is going
-		 * to have higher weight. A more accurate thing would be to
-		 * calculate system wide asnc/sync ratio.
-		 */
-		tmp = cfq_target_latency * cfqg_busy_async_queues(cfqd, cfqg);
-		tmp = tmp/cfqd->busy_queues;
-		slice = min_t(unsigned, slice, tmp);
-
-		/* async workload slice is scaled down according to
-		 * the sync/async slice ratio. */
-		slice = slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
-	} else
+	if (cfqd->serving_type == ASYNC_WORKLOAD)
+		slice = adjust_async_slice(cfqd, cfqg, slice);
+	else
 		/* sync workload slice is at least 2 * cfq_slice_idle */
 		slice = max(slice, 2 * cfqd->cfq_slice_idle);
 
-- 
1.6.2.5

