Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1B0NNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 08:13:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:62581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1B0NNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 08:13:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,234,1297065600"; 
   d="scan'208";a="394695473"
Subject: perf: fix the missing event initialization when pmu is found in idr
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 21:13:31 +0800
Message-Id: <1298812411.2699.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the event is not initialized if pmu is found in idr.
This never causes bug just because now no pmu is associated with the idr
id.
This patch fixes the potential bug.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64a018e..821ce82 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -6098,17 +6098,22 @@ struct pmu *perf_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
 	int idx;
+	int ret;
 
 	idx = srcu_read_lock(&pmus_srcu);
 
 	rcu_read_lock();
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
-	if (pmu)
+	if (pmu) {
+		ret = pmu->event_init(event);
+		if (ret)
+			pmu = ERR_PTR(ret);
 		goto unlock;
+	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		int ret = pmu->event_init(event);
+		ret = pmu->event_init(event);
 		if (!ret)
 			goto unlock;
 


