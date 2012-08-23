Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab2HWPNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:13:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:57443 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab2HWPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/12] perf tools: Add pmu mappings to header information
Date: Thu, 23 Aug 2012 12:09:50 -0300
Message-Id: <1345734596-7601-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

With dynamic pmu allocation there are also dynamically assigned pmu ids.
These ids are used in event->attr.type to describe the pmu to be used
for that event. The information is available in sysfs, e.g:

 /sys/bus/event_source/devices/breakpoint/type: 5
 /sys/bus/event_source/devices/cpu/type: 4
 /sys/bus/event_source/devices/ibs_fetch/type: 6
 /sys/bus/event_source/devices/ibs_op/type: 7
 /sys/bus/event_source/devices/software/type: 1
 /sys/bus/event_source/devices/tracepoint/type: 2

These mappings are needed to know which samples belong to which pmu.  If
a pmu is added dynamically like for ibs_fetch or ibs_op the type value
may vary.

Now, when decoding samples from perf.data this information in sysfs
might be no longer available or may have changed. We need to store it in
perf.data. Using the header for this. Now the header information created
with perf report contains an additional section looking like this:

 # pmu mappings: ibs_op = 7, ibs_fetch = 6, cpu = 4, breakpoint = 5, tracepoint = 2, software = 1

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-9-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |    1 +
 tools/perf/util/pmu.c    |   50 ++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h    |    2 +
 4 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 69374de..63aad31 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -20,6 +20,7 @@
 #include "symbol.h"
 #include "debug.h"
 #include "cpumap.h"
+#include "pmu.h"
 
 static bool no_buildid_cache = false;
 
@@ -1004,6 +1005,45 @@ done:
 }
 
 /*
+ * File format:
+ *
+ * struct pmu_mappings {
+ *	u32	pmu_num;
+ *	struct pmu_map {
+ *		u32	type;
+ *		char	name[];
+ *	}[pmu_num];
+ * };
+ */
+
+static int write_pmu_mappings(int fd, struct perf_header *h __used,
+			      struct perf_evlist *evlist __used)
+{
+	struct perf_pmu *pmu = NULL;
+	off_t offset = lseek(fd, 0, SEEK_CUR);
+	__u32 pmu_num = 0;
+
+	/* write real pmu_num later */
+	do_write(fd, &pmu_num, sizeof(pmu_num));
+
+	while ((pmu = perf_pmu__scan(pmu))) {
+		if (!pmu->name)
+			continue;
+		pmu_num++;
+		do_write(fd, &pmu->type, sizeof(pmu->type));
+		do_write_string(fd, pmu->name);
+	}
+
+	if (pwrite(fd, &pmu_num, sizeof(pmu_num), offset) != sizeof(pmu_num)) {
+		/* discard all */
+		lseek(fd, offset, SEEK_SET);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
  * default get_cpuid(): nothing gets recorded
  * actual implementation must be in arch/$(ARCH)/util/header.c
  */
@@ -1389,6 +1429,43 @@ static void print_branch_stack(struct perf_header *ph __used, int fd __used,
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
+static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
+{
+	const char *delimiter = "# pmu mappings: ";
+	char *name;
+	int ret;
+	u32 pmu_num;
+	u32 type;
+
+	ret = read(fd, &pmu_num, sizeof(pmu_num));
+	if (ret != sizeof(pmu_num))
+		goto error;
+
+	if (!pmu_num) {
+		fprintf(fp, "# pmu mappings: not available\n");
+		return;
+	}
+
+	while (pmu_num) {
+		if (read(fd, &type, sizeof(type)) != sizeof(type))
+			break;
+		name = do_read_string(fd, ph);
+		if (!name)
+			break;
+		pmu_num--;
+		fprintf(fp, "%s%s = %" PRIu32, delimiter, name, type);
+		free(name);
+		delimiter = ", ";
+	}
+
+	fprintf(fp, "\n");
+
+	if (!pmu_num)
+		return;
+error:
+	fprintf(fp, "# pmu mappings: unable to read\n");
+}
+
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
@@ -1644,6 +1721,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
+	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 24962e7..9d5eedc 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -28,6 +28,7 @@ enum {
 	HEADER_CPU_TOPOLOGY,
 	HEADER_NUMA_TOPOLOGY,
 	HEADER_BRANCH_STACK,
+	HEADER_PMU_MAPPINGS,
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
 };
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 67715a4..6631d82 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -10,6 +10,8 @@
 #include "pmu.h"
 #include "parse-events.h"
 
+#define EVENT_SOURCE_DEVICE_PATH "/bus/event_source/devices/"
+
 int perf_pmu_parse(struct list_head *list, char *name);
 extern FILE *perf_pmu_in;
 
@@ -69,7 +71,7 @@ static int pmu_format(char *name, struct list_head *format)
 		return -1;
 
 	snprintf(path, PATH_MAX,
-		 "%s/bus/event_source/devices/%s/format", sysfs, name);
+		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/format", sysfs, name);
 
 	if (stat(path, &st) < 0)
 		return 0;	/* no error if format does not exist */
@@ -206,7 +208,7 @@ static int pmu_type(char *name, __u32 *type)
 		return -1;
 
 	snprintf(path, PATH_MAX,
-		 "%s/bus/event_source/devices/%s/type", sysfs, name);
+		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/type", sysfs, name);
 
 	if (stat(path, &st) < 0)
 		return -1;
@@ -222,6 +224,35 @@ static int pmu_type(char *name, __u32 *type)
 	return ret;
 }
 
+/* Add all pmus in sysfs to pmu list: */
+static void pmu_read_sysfs(void)
+{
+	char path[PATH_MAX];
+	const char *sysfs;
+	DIR *dir;
+	struct dirent *dent;
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return;
+
+	snprintf(path, PATH_MAX,
+		 "%s" EVENT_SOURCE_DEVICE_PATH, sysfs);
+
+	dir = opendir(path);
+	if (!dir)
+		return;
+
+	while ((dent = readdir(dir))) {
+		if (!strcmp(dent->d_name, ".") || !strcmp(dent->d_name, ".."))
+			continue;
+		/* add to static LIST_HEAD(pmus): */
+		perf_pmu__find(dent->d_name);
+	}
+
+	closedir(dir);
+}
+
 static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
@@ -267,6 +298,21 @@ static struct perf_pmu *pmu_find(char *name)
 	return NULL;
 }
 
+struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu)
+{
+	/*
+	 * pmu iterator: If pmu is NULL, we start at the begin,
+	 * otherwise return the next pmu. Returns NULL on end.
+	 */
+	if (!pmu) {
+		pmu_read_sysfs();
+		pmu = list_prepare_entry(pmu, &pmus, list);
+	}
+	list_for_each_entry_continue(pmu, &pmus, list)
+		return pmu;
+	return NULL;
+}
+
 struct perf_pmu *perf_pmu__find(char *name)
 {
 	struct perf_pmu *pmu;
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index 535f2c5..47f68d3 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -46,5 +46,7 @@ int perf_pmu__new_format(struct list_head *list, char *name,
 			 int config, unsigned long *bits);
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
 
+struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.1

