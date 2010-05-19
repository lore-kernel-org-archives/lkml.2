Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab0ERRto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:49:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:4227 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758557Ab0ERRtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="799594710"
Subject: [RFC][PATCH v2 10/11] perf: core, lookup pmu via sysfs
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
Date: Wed, 19 May 2010 01:49:38 +0000
Message-Id: <1274233778.3036.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another pmu lookup method via sysfs.
Now we have 2 methods: type->pmu and sys_fd->pmu

Changes log,
Lookup pmu via sysfs (Ingo Molnar)

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/perf_event.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8640610..0ab4a8b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4680,7 +4680,7 @@ static struct pmu *sw_perf_event_init(struct perf_event *event)
 	return pmu;
 }
 
-static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
+static struct pmu *perf_event_lookup_pmu_by_type(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
 	int pmu_id = PERF_EVENT_ATTR_TYPE(&event->attr);
@@ -4708,6 +4708,37 @@ static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
 	return pmu;
 }
 
+static struct pmu *perf_event_lookup_pmu_by_fd(struct perf_event *event)
+{
+	struct pmu *pmu = NULL;
+	struct kobject *kobj;
+	int sys_fd = PERF_EVENT_ATTR_FD(&event->attr);
+	struct file *file;
+	int fput_needed;
+
+	file = fget_light(sys_fd, &fput_needed);
+	if (!file)
+		return NULL;
+
+	kobj = sysfs_get_kobject(file);
+	if (kobj)
+		pmu = container_of(kobj, struct pmu, kobj);
+
+	fput_light(file, fput_needed);
+
+	return pmu;
+}
+
+static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
+{
+	u32 type = event->attr.type;
+
+	if (type & PERF_EVENT_FD)
+		return perf_event_lookup_pmu_by_fd(event);
+	else
+		return perf_event_lookup_pmu_by_type(event);
+}
+
 /*
  * Allocate and initialize a event structure
  */




