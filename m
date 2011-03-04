Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab1CDLvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:51:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:41852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1CDLvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:51:01 -0500
Date: Fri, 4 Mar 2011 11:50:35 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1298812411.2699.9.camel@localhost>
References: <1298812411.2699.9.camel@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix the missing event initialization when pmu is found in idr
Message-ID: <tip-940c5b2971de443df22eed0441bc74fb0116e9f5@git.kernel.org>
Git-Commit-ID: 940c5b2971de443df22eed0441bc74fb0116e9f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 11:50:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  940c5b2971de443df22eed0441bc74fb0116e9f5
Gitweb:     http://git.kernel.org/tip/940c5b2971de443df22eed0441bc74fb0116e9f5
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Sun, 27 Feb 2011 21:13:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 11:32:50 +0100

perf: Fix the missing event initialization when pmu is found in idr

Currently, the event is not initialized if pmu is found in idr. This
never causes bug just because now no pmu is associated with the idr
id.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1298812411.2699.9.camel@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
