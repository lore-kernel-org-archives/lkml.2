Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0ERRsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:48:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:10168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab0ERRse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="622724371"
Subject: [RFC][PATCH v2 07/11] perf: x86, implements pmu::register_events
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
Date: Wed, 19 May 2010 01:48:27 +0000
Message-Id: <1274233707.3036.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pmu::register_events register events to sysfs.
The structure as below,

$ tree /sys/devices/system/cpu/event_source/
/sys/devices/system/cpu/event_source/
`-- id

$ tree /sys/devices/system/cpu/events/
/sys/devices/system/cpu/events/
|-- L1-dcache-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- LLC-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- branch-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- branches
|   |-- event_source -> ../../event_source
|   `-- id
|-- bus-cycles
|   |-- event_source -> ../../event_source
|   `-- id
|-- cache-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- cache-references
|   |-- event_source -> ../../event_source
|   `-- id
|-- cycles
|   |-- event_source -> ../../event_source
|   `-- id
|-- dTLB-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- dTLB-store-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- iTLB-load-misses
|   |-- event_source -> ../../event_source
|   `-- id
|-- iTLB-load-refs
|   |-- event_source -> ../../event_source
|   `-- id
`-- instructions
    |-- event_source -> ../../event_source
    `-- id 

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   70 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8a3aea6..148eee6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1529,6 +1529,75 @@ static int x86_pmu_init_event(struct perf_event *event)
 	return err;
 }
 
+static int register_event(struct pmu *pmu,
+		struct kobject *parent_kobj, char *name, u64 id)
+{
+	struct perf_event_kobject *event_kobj;
+	struct attribute *attr;
+	int err;
+
+	event_kobj = kzalloc(sizeof(*event_kobj), GFP_KERNEL);
+	if (!event_kobj) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	event_kobj->id = id;
+
+	err = kobject_init_and_add(&event_kobj->kobj,
+		&event_ktype, parent_kobj, name);
+	if (err)
+		goto exit;
+
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		err = -ENOMEM;
+		goto exit;
+	}
+	attr->name = "id";
+	attr->mode = 0444;
+
+	err = sysfs_create_file(&event_kobj->kobj, attr);
+	if (err)
+		goto exit;
+
+	err = sysfs_create_link(&event_kobj->kobj, &pmu->kobj, kobject_name(&pmu->kobj));
+
+exit:
+	return err;
+}
+
+static int x86_pmu_register_events(struct pmu *pmu, struct kobject *events_kobj)
+{
+	int type, op, i;
+	int cache_id;
+	int err = 0;
+
+	for (i = PERF_COUNT_HW_CPU_CYCLES; i < PERF_COUNT_HW_MAX; i++) {
+		err = register_event(pmu, events_kobj,
+			perf_hw_event_name(i), x86_pmu.event_map(i));
+		if (err)
+			break;
+	}
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+
+				cache_id = hw_cache_event_ids[type][op][i];
+				if (cache_id <= 0)
+					continue;
+
+				err = register_event(pmu, events_kobj,
+					perf_hw_cache_event_name(type, op, i), cache_id);
+				if (err)
+					break;
+			}
+		}
+	}
+
+	return err;
+}
+
 static struct pmu pmu = {
 	.id		= PMU_TYPE_CPU,
 	.enable		= x86_pmu_enable,
@@ -1541,6 +1610,7 @@ static struct pmu pmu = {
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
 	.init_event	= x86_pmu_init_event,
+	.register_events = x86_pmu_register_events,
 };
 
 /*




