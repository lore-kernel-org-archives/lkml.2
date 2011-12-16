Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab1LPQMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:12:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:4977 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1LPQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:12:41 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB110-01-6GW-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>,
        Benjamin Block <benjamin.block@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 3/5] perf: adds a new pmu-initialization-call
Date: Fri, 16 Dec 2011 17:12:21 +0100
Message-ID: <1324051943-21112-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <benjamin.block@amd.com>

Adds a new call to the PMU-functions, which can be used by PMUs who
need information about the task and/or CPU for which the event shall
be initialized.

Signed-off-by: Benjamin Block <benjamin.block@amd.com>
Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 include/linux/perf_event.h |    2 ++
 kernel/events/core.c       |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 81807bd..0c6fae6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -630,6 +630,8 @@ struct pmu {
 	 * Should return -ENOENT when the @event doesn't match this PMU.
 	 */
 	int (*event_init)		(struct perf_event *event);
+	int (*event_init_for)		(struct perf_event *event, int cpu,
+					 struct task_struct *task);
 
 #define PERF_EF_START	0x01		/* start the counter when adding    */
 #define PERF_EF_RELOAD	0x02		/* reload the counter when starting */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index faf52f7..fd18d70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5746,7 +5746,8 @@ void perf_pmu_unregister(struct pmu *pmu)
 	free_pmu_context(pmu);
 }
 
-struct pmu *perf_init_event(struct perf_event *event)
+struct pmu *perf_init_event(struct perf_event *event, int cpu,
+			    struct task_struct *task)
 {
 	struct pmu *pmu = NULL;
 	int idx;
@@ -5758,14 +5759,22 @@ struct pmu *perf_init_event(struct perf_event *event)
 	pmu = idr_find(&pmu_idr, event->attr.type);
 	rcu_read_unlock();
 	if (pmu) {
-		ret = pmu->event_init(event);
+		if (pmu->event_init_for)
+			ret = pmu->event_init_for(event, cpu, task);
+		else
+			ret = pmu->event_init(event);
+
 		if (ret)
 			pmu = ERR_PTR(ret);
 		goto unlock;
 	}
 
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		ret = pmu->event_init(event);
+		if (pmu->event_init_for)
+			ret = pmu->event_init_for(event, cpu, task);
+		else
+			ret = pmu->event_init(event);
+
 		if (!ret)
 			goto unlock;
 
@@ -5875,7 +5884,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto done;
 
-	pmu = perf_init_event(event);
+	pmu = perf_init_event(event, cpu, task);
 
 done:
 	err = 0;
-- 
1.7.7


