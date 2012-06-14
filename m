Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2FNUjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab2FNUja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:39:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/6] perf, tool: Add events support for pmu
Date: Thu, 14 Jun 2012 22:38:39 +0200
Message-Id: <1339706321-8802-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pmu sysfs record expose events group attribute with
hardware events translations.

Adding support to read those and make it available throught:
__u64 perf_pmu__event(struct perf_pmu *pmu, unsigned id)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/pmu.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h |    2 +
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 1d73131..bf2a2a9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -88,6 +88,94 @@ static int pmu_format(char *name, struct list_head *format)
 	return 0;
 }
 
+const char *events_files[PERF_COUNT_HW_MAX] = {
+	[PERF_COUNT_HW_CPU_CYCLES]              = "cycles",
+	[PERF_COUNT_HW_INSTRUCTIONS]            = "instructions",
+	[PERF_COUNT_HW_CACHE_REFERENCES]        = "cache_references",
+	[PERF_COUNT_HW_CACHE_MISSES]            = "cache_misses",
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]     = "branch_instructions",
+	[PERF_COUNT_HW_BRANCH_MISSES]           = "branch_misses",
+	[PERF_COUNT_HW_BUS_CYCLES]              = "bus_cycles",
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = "stalled_cycles_frontend",
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND]  = "stalled_cycles_backend",
+	[PERF_COUNT_HW_REF_CPU_CYCLES]          = "ref_cycles",
+};
+
+static int read_events(char *dir, __u64 **_events)
+{
+	unsigned i;
+	int ret = 0;
+	__u64 *events;
+
+	events = malloc(PERF_COUNT_HW_MAX * sizeof(u64));
+	if (!events)
+		return -ENOMEM;
+
+	for (i = 0; (i < ARRAY_SIZE(events_files)) && (!ret); i++) {
+		FILE *file;
+		char path[PATH_MAX];
+
+		snprintf(path, PATH_MAX, "%s/%s", dir, events_files[i]);
+
+		file = fopen(path, "r");
+		if (file) {
+			__u64 val;
+
+			if (1 != fscanf(file, "0x%llx", &val))
+				ret = -EINVAL;
+
+			events[i] = val;
+			fclose(file);
+		} else
+			ret = -EINVAL;
+
+	}
+
+	if (ret)
+		free(events);
+	else
+		*_events = events;
+
+	return ret;
+}
+
+/*
+ * Reading/parsing the default pmu events definition, which should be
+ * located at:
+ * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
+ */
+static int pmu_events(char *name, __u64 **events)
+{
+	struct stat st;
+	char path[PATH_MAX];
+	const char *sysfs;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	snprintf(path, PATH_MAX,
+		 "%s/bus/event_source/devices/%s/events", sysfs, name);
+
+	if (stat(path, &st) < 0)
+		return 0;	/* no error if events does not exist */
+
+	return read_events(path, events);
+}
+
+static void pmu_events_release(__u64 *events)
+{
+	free(events);
+}
+
+__u64 perf_pmu__event(struct perf_pmu *pmu, unsigned id)
+{
+	if (pmu->events && (id < PERF_COUNT_HW_MAX))
+		return pmu->events[id];
+
+	return 0;
+}
+
 /*
  * Reading/parsing the default pmu type value, which should be
  * located at:
@@ -125,18 +213,22 @@ static int pmu_type(char *name, __u32 *type)
 static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
+	__u64 *events = NULL;
 	LIST_HEAD(format);
 	__u32 type;
 
 	do {
 		/*
 		 * The pmu data we store & need consists of the pmu
-		 * type value and format definitions. Load both right
-		 * now.
+		 * type value, format and events definitions. Load
+		 * all of them right now.
 		 */
 		if (pmu_format(name, &format))
 			break;
 
+		if (pmu_events(name, &events))
+			break;
+
 		if (pmu_type(name, &type))
 			break;
 
@@ -148,12 +240,14 @@ static struct perf_pmu *pmu_lookup(char *name)
 		list_splice(&format, &pmu->format);
 		pmu->name = strdup(name);
 		pmu->type = type;
+		pmu->events = events;
 		list_add_tail(&pmu->list, &pmus);
 		return pmu;
 
 	} while (0);
 
 	pmu_format_release(&format);
+	pmu_events_release(events);
 	return NULL;
 }
 
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 68c0db9..554dd6a 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -24,11 +24,13 @@ struct perf_pmu {
 	__u32 type;
 	struct list_head format;
 	struct list_head list;
+	__u64 *events;
 };
 
 struct perf_pmu *perf_pmu__find(char *name);
 int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 		     struct list_head *head_terms);
+__u64 perf_pmu__event(struct perf_pmu *pmu, unsigned id);
 
 int perf_pmu_wrap(void);
 void perf_pmu_error(struct list_head *list, char *name, char const *msg);
-- 
1.7.7.6

