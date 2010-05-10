Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0EJJ2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:28:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:13788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab0EJJ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="620310303"
Subject: [RFC][PATCH 4/9] perf: x86, convert to new API pmu->init_event
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
Date: Mon, 10 May 2010 17:27:27 +0800
Message-Id: <1273483647.15998.58.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: x86, convert to new API pmu->init_event

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5c6a0d9..2c3cc46 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1362,6 +1362,8 @@ void __init init_hw_perf_events(void)
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	perf_event_register_pmu(&pmu);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
@@ -1422,18 +1424,6 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
 	return 0;
 }
 
-static struct pmu pmu = {
-	.enable		= x86_pmu_enable,
-	.disable	= x86_pmu_disable,
-	.start		= x86_pmu_start,
-	.stop		= x86_pmu_stop,
-	.read		= x86_pmu_read,
-	.unthrottle	= x86_pmu_unthrottle,
-	.start_txn	= x86_pmu_start_txn,
-	.cancel_txn	= x86_pmu_cancel_txn,
-	.commit_txn	= x86_pmu_commit_txn,
-};
-
 /*
  * validate that we can schedule this event
  */
@@ -1508,7 +1498,7 @@ out:
 	return ret;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int x86_pmu_init_event(struct perf_event *event)
 {
 	struct pmu *tmp;
 	int err;
@@ -1533,12 +1523,24 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
-		return ERR_PTR(err);
 	}
 
-	return &pmu;
+	return err;
 }
 
+static struct pmu pmu = {
+	.enable		= x86_pmu_enable,
+	.disable	= x86_pmu_disable,
+	.start		= x86_pmu_start,
+	.stop		= x86_pmu_stop,
+	.read		= x86_pmu_read,
+	.unthrottle	= x86_pmu_unthrottle,
+	.start_txn	= x86_pmu_start_txn,
+	.cancel_txn	= x86_pmu_cancel_txn,
+	.commit_txn	= x86_pmu_commit_txn,
+	.init_event	= x86_pmu_init_event,
+};
+
 /*
  * callchain support
  */


