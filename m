Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2JJM7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab2JJM7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:59:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf x86: Filter out undefined events from sysfs events attribute
Date: Wed, 10 Oct 2012 14:53:12 +0200
Message-Id: <1349873598-12583-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs events group attribute currently shows all hw events,
including also undefined ones.

This patch filters out all undefined events out of the sysfs events
group attribute, so they don't even show up.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bff2eaa..9b6f83c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1313,6 +1313,26 @@ struct perf_pmu_events_attr {
 	u64 id;
 };
 
+/*
+ * Remove all undefined events (x86_pmu.event_map(id) == 0)
+ * out of events_attr attributes.
+ */
+static void __init filter_events(struct attribute **attrs)
+{
+	int i, j;
+
+	for (i = 0; attrs[i]; i++) {
+		if (x86_pmu.event_map(i))
+			continue;
+
+		for (j = i; attrs[j]; j++)
+			attrs[j] = attrs[j + 1];
+
+		/* Check the shifted attr. */
+		i--;
+	}
+}
+
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
@@ -1412,6 +1432,8 @@ static int __init init_hw_perf_events(void)
 
 	if (!x86_pmu.events_sysfs_show)
 		x86_pmu_events_group.attrs = &empty_attrs;
+	else
+		filter_events(x86_pmu_events_group.attrs);
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
-- 
1.7.11.4

