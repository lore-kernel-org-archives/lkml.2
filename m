Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab2JXKEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:04:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2JXKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:04:12 -0400
Date: Wed, 24 Oct 2012 03:02:36 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-a47473939db20e3961b200eb00acf5fcf084d755@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1349873598-12583-2-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Make hardware event translations available in sysfs
Git-Commit-ID: a47473939db20e3961b200eb00acf5fcf084d755
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:02:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a47473939db20e3961b200eb00acf5fcf084d755
Gitweb:     http://git.kernel.org/tip/a47473939db20e3961b200eb00acf5fcf084d755
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:23 +0200

perf/x86: Make hardware event translations available in sysfs

Add support to display hardware events translations available
through the sysfs. Add 'events' group attribute under the sysfs
x86 PMU record with attribute/file for each hardware event.

This patch adds only backbone for PMUs to display config under
'events' directory. The specific PMU support itself will come
in next patches, however this is how the sysfs group will look
like:

  # ls  /sys/devices/cpu/events/
  branch-instructions
  branch-misses
  bus-cycles
  cache-misses
  cache-references
  cpu-cycles
  instructions
  ref-cycles
  stalled-cycles-backend
  stalled-cycles-frontend

The file - hw event ID mapping is:

  file                      hw event ID
  ---------------------------------------------------------------
  cpu-cycles                PERF_COUNT_HW_CPU_CYCLES
  instructions              PERF_COUNT_HW_INSTRUCTIONS
  cache-references          PERF_COUNT_HW_CACHE_REFERENCES
  cache-misses              PERF_COUNT_HW_CACHE_MISSES
  branch-instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
  branch-misses             PERF_COUNT_HW_BRANCH_MISSES
  bus-cycles                PERF_COUNT_HW_BUS_CYCLES
  stalled-cycles-frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
  stalled-cycles-backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
  ref-cycles                PERF_COUNT_HW_REF_CPU_CYCLES

Each file in the 'events' directory contains the term translation
for the symbolic hw event for the currently running cpu model.

  # cat /sys/devices/cpu/events/stalled-cycles-backend
  event=0xb1,umask=0x01,inv,cmask=0x01

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-2-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   60 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h |    2 +
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a3374e..9fa4c45 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1316,6 +1316,62 @@ static struct attribute_group x86_pmu_format_group = {
 	.attrs = NULL,
 };
 
+struct perf_pmu_events_attr {
+	struct device_attribute attr;
+	u64 id;
+};
+
+ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
+			  char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr = \
+		container_of(attr, struct perf_pmu_events_attr, attr);
+
+	u64 config = x86_pmu.event_map(pmu_attr->id);
+	return x86_pmu.events_sysfs_show(page, config);
+}
+
+#define EVENT_VAR(_id)  event_attr_##_id
+#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
+
+#define EVENT_ATTR(_name, _id)					\
+static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
+	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
+	.id   =  PERF_COUNT_HW_##_id,				\
+};
+
+EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
+EVENT_ATTR(instructions,		INSTRUCTIONS		);
+EVENT_ATTR(cache-references,		CACHE_REFERENCES	);
+EVENT_ATTR(cache-misses, 		CACHE_MISSES		);
+EVENT_ATTR(branch-instructions,		BRANCH_INSTRUCTIONS	);
+EVENT_ATTR(branch-misses,		BRANCH_MISSES		);
+EVENT_ATTR(bus-cycles,			BUS_CYCLES		);
+EVENT_ATTR(stalled-cycles-frontend,	STALLED_CYCLES_FRONTEND	);
+EVENT_ATTR(stalled-cycles-backend,	STALLED_CYCLES_BACKEND	);
+EVENT_ATTR(ref-cycles,			REF_CPU_CYCLES		);
+
+static struct attribute *empty_attrs;
+
+struct attribute *events_attr[] = {
+	EVENT_PTR(CPU_CYCLES),
+	EVENT_PTR(INSTRUCTIONS),
+	EVENT_PTR(CACHE_REFERENCES),
+	EVENT_PTR(CACHE_MISSES),
+	EVENT_PTR(BRANCH_INSTRUCTIONS),
+	EVENT_PTR(BRANCH_MISSES),
+	EVENT_PTR(BUS_CYCLES),
+	EVENT_PTR(STALLED_CYCLES_FRONTEND),
+	EVENT_PTR(STALLED_CYCLES_BACKEND),
+	EVENT_PTR(REF_CPU_CYCLES),
+	NULL,
+};
+
+static struct attribute_group x86_pmu_events_group = {
+	.name = "events",
+	.attrs = events_attr,
+};
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -1362,6 +1418,9 @@ static int __init init_hw_perf_events(void)
 	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
+	if (!x86_pmu.events_sysfs_show)
+		x86_pmu_events_group.attrs = &empty_attrs;
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
@@ -1651,6 +1710,7 @@ static struct attribute_group x86_pmu_attr_group = {
 static const struct attribute_group *x86_pmu_attr_groups[] = {
 	&x86_pmu_attr_group,
 	&x86_pmu_format_group,
+	&x86_pmu_events_group,
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 271d257..6f75b6a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -354,6 +354,8 @@ struct x86_pmu {
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
 
+	ssize_t		(*events_sysfs_show)(char *page, u64 config);
+
 	/*
 	 * CPU Hotplug hooks
 	 */
