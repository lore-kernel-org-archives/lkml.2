Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0ERRqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:46:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:2439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560Ab0ERRqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:46:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="622723657"
Subject: [RFC][PATCH v2 04/11] perf: core, use new api to lookup pmu and
 init event
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
Date: Wed, 19 May 2010 01:45:56 +0000
Message-Id: <1274233556.3036.82.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the weak function hw_perf_event_init
    
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/perf_event.h |    2 --
 kernel/perf_event.c        |   12 ++++--------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 40809f5..ad2aea3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -825,8 +825,6 @@ struct perf_output_handle {
  */
 extern int perf_max_events;
 
-extern struct pmu *hw_perf_event_init(struct perf_event *event);
-
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
 extern void perf_event_task_tick(struct task_struct *task);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 31b032b..17eff7b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -81,11 +81,6 @@ static DEFINE_SPINLOCK(perf_resource_lock);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
-{
-	return NULL;
-}
-
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
@@ -4727,7 +4722,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 	struct pmu *pmu;
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	long err;
+	long err = 0;
 
 	event = kzalloc(sizeof(*event), gfpflags);
 	if (!event)
@@ -4792,7 +4787,9 @@ perf_event_alloc(struct perf_event_attr *attr,
 	case PERF_TYPE_RAW:
 	case PERF_TYPE_HARDWARE:
 	case PERF_TYPE_HW_CACHE:
-		pmu = hw_perf_event_init(event);
+		pmu = perf_event_lookup_pmu(event);
+		if (pmu && pmu->init_event)
+			err = pmu->init_event(event);
 		break;
 
 	case PERF_TYPE_SOFTWARE:
@@ -4812,7 +4809,6 @@ perf_event_alloc(struct perf_event_attr *attr,
 		break;
 	}
 done:
-	err = 0;
 	if (!pmu)
 		err = -EINVAL;
 	else if (IS_ERR(pmu))




