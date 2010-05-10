Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0EJJ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:29:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:56283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0EJJ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:29:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="516521039"
Subject: [RFC][PATCH 7/9] perf: sh, convert to new API pmu->init_event
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:28:29 +0800
Message-Id: <1273483709.15998.61.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: sh, convert to new API pmu->init_event

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/sh/kernel/perf_event.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 6e3a95f..1892f94 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -257,24 +257,24 @@ static void sh_pmu_read(struct perf_event *event)
 	sh_perf_event_update(event, &event->hw, event->hw.idx);
 }
 
-static struct pmu pmu = {
-	.enable		= sh_pmu_enable,
-	.disable	= sh_pmu_disable,
-	.read		= sh_pmu_read,
-};
-
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int *sh_pmu_init_event(struct perf_event *event)
 {
 	int err = __hw_perf_event_init(event);
 	if (unlikely(err)) {
 		if (event->destroy)
 			event->destroy(event);
-		return ERR_PTR(err);
 	}
 
-	return &pmu;
+	return err;
 }
 
+static struct pmu sh_pmu = {
+	.enable		= sh_pmu_enable,
+	.disable	= sh_pmu_disable,
+	.read		= sh_pmu_read,
+	.init_event	= sh_pmu_init_event,
+};
+
 static void sh_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
@@ -326,5 +326,8 @@ int __cpuinit register_sh_pmu(struct sh_pmu *pmu)
 	WARN_ON(pmu->num_events > MAX_HWEVENTS);
 
 	perf_cpu_notifier(sh_pmu_notifier);
+
+	perf_event_register_pmu(&sh_pmu);
+
 	return 0;
 }


