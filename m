Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2GIUiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab2GIUiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:38:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/6] perf, x86: Filter out undefined events from sysfs events attribute
Date: Mon,  9 Jul 2012 22:37:46 +0200
Message-Id: <1341866270-4915-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs events group attribute currently shows all hw events,
including also undefined ones.

This patch filters out all undefined events out of the sysfs events
group attribute, so they don't even show up.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 09452c2..9fb23dd 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1306,6 +1306,8 @@ static struct attribute_group x86_pmu_format_group = {
 	.attrs = NULL,
 };
 
+static void __init filter_events_group(void);
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1352,6 +1354,8 @@ static int __init init_hw_perf_events(void)
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
+	filter_events_group();
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
@@ -1718,6 +1722,26 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
+/*
+ * Remove all undefined events (x86_pmu.event_map(id) == 0)
+ * out of events_attr attributes.
+ */
+static void __init filter_events_group(void)
+{
+	int i, j;
+
+	for (i = 0; events_attr[i]; i++) {
+		if (x86_pmu.event_map(i))
+			continue;
+
+		for (j = i; events_attr[j]; j++)
+			events_attr[j] = events_attr[j + 1];
+
+		/* Check the shifted attr. */
+		i--;
+	}
+}
+
 static void x86_pmu_flush_branch_stack(void)
 {
 	if (x86_pmu.flush_branch_stack)
-- 
1.7.10.4

