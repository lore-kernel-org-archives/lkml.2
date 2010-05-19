Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab0ERRpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:45:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:15268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab0ERRph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:45:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="519031445"
Subject: [RFC][PATCH v2 03/11] perf: x86, implement pmu::init_event
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:45:27 +0000
Message-Id: <1274233527.3036.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly copy hw_perf_event_init to implement it.
Backup hw_perf_event_init to the end of file and it will be removed later.

Changes log
v2: Backup hw_perf_event_init for smooth transition(Peter Zijlstra)
v1: x86, implement api pmu::init_event

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   65 +++++++++++++++++++++++++++++---------
 1 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5c6a0d9..aad4221 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1362,6 +1362,9 @@ void __init init_hw_perf_events(void)
 	pr_info("... event mask:             %016Lx\n", x86_pmu.intel_ctrl);
 
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	if (!perf_event_register_pmu(&pmu))
+		pr_info("Register pmu fails\n");
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
@@ -1422,18 +1425,6 @@ static int x86_pmu_commit_txn(struct pmu *pmu)
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
@@ -1508,7 +1499,7 @@ out:
 	return ret;
 }
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
+static int x86_pmu_init_event(struct perf_event *event)
 {
 	struct pmu *tmp;
 	int err;
@@ -1533,12 +1524,25 @@ struct pmu *hw_perf_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
-		return ERR_PTR(err);
 	}
 
-	return &pmu;
+	return err;
 }
 
+static struct pmu pmu = {
+	.id		= PMU_TYPE_CPU,
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
@@ -1753,3 +1757,34 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	return misc;
 }
+
+struct pmu *hw_perf_event_init(struct perf_event *event)
+{
+	struct pmu *tmp;
+	int err;
+
+	err = __hw_perf_event_init(event);
+	if (!err) {
+		/*
+		 * we temporarily connect event to its pmu
+		 * such that validate_group() can classify
+		 * it as an x86 event using is_x86_event()
+		 */
+		tmp = event->pmu;
+		event->pmu = &pmu;
+
+		if (event->group_leader != event)
+			err = validate_group(event);
+		else
+			err = validate_event(event);
+
+		event->pmu = tmp;
+	}
+	if (err) {
+		if (event->destroy)
+			event->destroy(event);
+		return ERR_PTR(err);
+	}
+
+	return &pmu;
+}




