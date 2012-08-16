Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab2HPTyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:12 -0400
Received: from [213.199.154.206] ([213.199.154.206]:21501 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab2HPTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:09 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah1155h)
X-WSS-ID: 0M8V5WR-01-68C-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 8/8] perf tools: Add pmu mappings to header information
Date: Thu, 16 Aug 2012 21:10:24 +0200
Message-ID: <1345144224-27280-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With dynamic pmu allocation there are also dynamically assigned pmu
ids. These ids are used in event->attr.type to describe the pmu to be
used for that event. The information is available in sysfs, e.g:

 /sys/bus/event_source/devices/breakpoint/type: 5
 /sys/bus/event_source/devices/cpu/type: 4
 /sys/bus/event_source/devices/ibs_fetch/type: 6
 /sys/bus/event_source/devices/ibs_op/type: 7
 /sys/bus/event_source/devices/software/type: 1
 /sys/bus/event_source/devices/tracepoint/type: 2

These mappings are needed to know which samples belong to which pmu.
If a pmu is added dynamically like for ibs_fetch or ibs_op the type
value may vary.

Now, when decoding samples from perf.data this information in sysfs
might be no longer available or may have changed. We need to store it
in perf.data. Using the header for this. Now the header information
created with perf report contains an additional section looking like
this:

 # pmu mappings: ibs_op = 7, ibs_fetch = 6, cpu = 4, breakpoint = 5, tracepoint = 2, software = 1

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |    1 +
 tools/perf/util/pmu.c    |   50 ++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h    |    2 +
 4 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c0311b3..26262d5 100644
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
1.7.8.6


