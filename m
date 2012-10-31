Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2JaGbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:31:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39956 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2JaGbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:31:05 -0400
Date: Tue, 30 Oct 2012 23:31:33 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: peterz@infradead.org, robert.richter@amd.org, acme@redhat.com
Cc: linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com
Subject: [PATCH] perf: x86 filter_events() - use hw event id ?
Message-ID: <20121031063133.GA12037@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103106-5518-0000-0000-000008DAAC0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From c3b53a5733fdea35807f4513255bca05e3aee5c5 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 30 Oct 2012 23:05:05 -0700
Subject: [PATCH] perf: x86 filter_events() - use hw event id ?

The ->event_map() operation expects to index through the _hardware event id_.
But filter_events() function is calling ->event_map() with a loop index i.

Suppose a processor does not implement say PERF_COUNT_HW_BUS_CYCLES (6),
but implements, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND (7).

->event_map() for "bus cycles" returns 0, we push the "stalled-cycles-frontend"
event up by one in the events_attr[].

The index of "stalled-cycles-frontend" in the events_attr[] is 6 which
is different from its hardware event id 7.

The next and subsequent calls to ->event_map() will use this index in the
modified events_attr[] table. All subsequent event ids appear unimplemented
because they continue to check the same index (6 in this case).

Should'nt we be checking the hardware event id instead ?

I have not tested this on x86 - only on my port of the sysfs events to Power.
---
 arch/x86/kernel/cpu/perf_event.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0a55ab2..ae88512 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1325,12 +1325,21 @@ struct perf_pmu_events_attr {
  * Remove all undefined events (x86_pmu.event_map(id) == 0)
  * out of events_attr attributes.
  */
+#define PMU_ATTR(a) container_of((a), struct perf_pmu_events_attr, attr)
+#define DEV_ATTR(a) container_of((a), struct device_attribute, attr)
+
 static void __init filter_events(struct attribute **attrs)
 {
 	int i, j;
+	struct perf_pmu_events_attr *pmu_attr;
+	struct device_attribute *dev_attr;
+	
 
 	for (i = 0; attrs[i]; i++) {
-		if (x86_pmu.event_map(i))
+		dev_attr = DEV_ATTR(attrs[i]);
+		pmu_attr = PMU_ATTR(dev_attr);
+
+		if (x86_pmu.event_map(pmu_attr->id))
 			continue;
 
 		for (j = i; attrs[j]; j++)
-- 
1.7.1

