Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2EBS1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:27:54 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:23581
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab2EBS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:53 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8K-01-6JR-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/7] perf tools: Add basic dynamic PMU support
Date: Wed, 2 May 2012 20:26:27 +0200
Message-ID: <1335983192-23731-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements support for dynamically allocated pmus. This
happens if a driver registers a pmu with the perf_pmu_register()
function. The pmu is then identified by a fixed string describing the
pmu, e.g. "ibs_op". The type value of those pmus is freely assigned by
the system and may vary. The pmus are listed in sysfs, e.g.:

 /sys/bus/event_source/devices/breakpoint/type: 5
 /sys/bus/event_source/devices/cpu/type: 4
 /sys/bus/event_source/devices/ibs_fetch/type: 6
 /sys/bus/event_source/devices/ibs_op/type: 7
 /sys/bus/event_source/devices/software/type: 1
 /sys/bus/event_source/devices/tracepoint/type: 2

The idea is, that dynamically added pmus are detected by the perf tool
by parsing sysfs. There are also pmu handlers registered in the perf
tool. Both are identified by its unique names.  If a pmu is supported
by the perf tool which means that a handler exists, the handler is
attached to a new detected pmu if both names match.

The handler may implement functions to print, parse and process
events, which are called if necessary, e.g. while printing a list of
events with perf-list, when parsing the event options or while
processing events.

This patch set first implements only printing of events, thus
perf-list provides a list of pmu events, e.g.:

 # perf list ibs_op | cat

 List of pre-defined events (to be used in -e):

   ibs_op:ALL                                         [PMU event: ibs_op]
   ibs_op:ALL_LOAD_STORE                              [PMU event: ibs_op]
   ibs_op:BANK_CONF_LOAD                              [PMU event: ibs_op]
   ibs_op:BANK_CONF_STORE                             [PMU event: ibs_op]
   ibs_op:BRANCH_RETIRED                              [PMU event: ibs_op]
   ibs_op:CANCELLED                                   [PMU event: ibs_op]
   ibs_op:COMP_TO_RET                                 [PMU event: ibs_op]
   ...

Code to parse such pmu events is added in the next patch.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Makefile            |    1 +
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/pmu-ibs.c      |   98 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.c          |   86 ++++++++++++++++++++++++++++++++++-
 tools/perf/util/pmu.h          |   15 ++++++
 5 files changed, 199 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/util/pmu-ibs.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c..8c372dc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -310,6 +310,7 @@ LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/sysfs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
+LIB_OBJS += $(OUTPUT)util/pmu-ibs.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b3a0ef..8962544 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -991,6 +991,7 @@ void print_events(const char *event_glob)
 		printf("\n");
 	}
 	print_hwcache_events(event_glob);
+	perf_pmu__print_events(event_glob);
 
 	if (event_glob != NULL)
 		return;
diff --git a/tools/perf/util/pmu-ibs.c b/tools/perf/util/pmu-ibs.c
new file mode 100644
index 0000000..5cf8601
--- /dev/null
+++ b/tools/perf/util/pmu-ibs.c
@@ -0,0 +1,98 @@
+/*
+ * Performance events - AMD IBS
+ *
+ *  Copyright (C) 2012 Advanced Micro Devices, Inc., Robert Richter
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <linux/compiler.h>
+#include "pmu.h"
+
+static const char *events[] = {
+	"ibs_fetch:2M_PAGE",
+	"ibs_fetch:4K_PAGE",
+	"ibs_fetch:ABORTED",
+	"ibs_fetch:ALL",
+	"ibs_fetch:ATTEMPTED",
+	"ibs_fetch:COMPLETED",
+	"ibs_fetch:ICACHE_HITS",
+	"ibs_fetch:ICACHE_MISSES",
+	"ibs_fetch:ITLB_HITS",
+	"ibs_fetch:KILLED",
+	"ibs_fetch:L1_ITLB_MISSES_L2_ITLB_HITS",
+	"ibs_fetch:L1_ITLB_MISSES_L2_ITLB_MISSES",
+	"ibs_fetch:LATENCY",
+	"ibs_op:ALL",
+	"ibs_op:ALL_LOAD_STORE",
+	"ibs_op:BANK_CONF_LOAD",
+	"ibs_op:BANK_CONF_STORE",
+	"ibs_op:BRANCH_RETIRED",
+	"ibs_op:CANCELLED",
+	"ibs_op:COMP_TO_RET",
+	"ibs_op:DATA_CACHE_MISS",
+	"ibs_op:DATA_HITS",
+	"ibs_op:DC_LOAD_LAT",
+	"ibs_op:DCUC_MEM_ACC",
+	"ibs_op:DCWC_MEM_ACC",
+	"ibs_op:FORWARD",
+	"ibs_op:L1_DTLB_1G",
+	"ibs_op:L1_DTLB_2M",
+	"ibs_op:L1_DTLB_4K",
+	"ibs_op:L1_DTLB_HITS",
+	"ibs_op:L1_DTLB_MISS_L2_DTLB_HIT",
+	"ibs_op:L1_L2_DTLB_MISS",
+	"ibs_op:L2_DTLB_1G",
+	"ibs_op:L2_DTLB_2M",
+	"ibs_op:L2_DTLB_4K",
+	"ibs_op:LOAD",
+	"ibs_op:LOCKED",
+	"ibs_op:MAB_HIT",
+	"ibs_op:MISALIGNED_DATA_ACC",
+	"ibs_op:MISPREDICTED_BRANCH",
+	"ibs_op:MISPREDICTED_BRANCH_TAKEN",
+	"ibs_op:MISPREDICTED_RETURNS",
+	"ibs_op:NB_CACHE_MODIFIED",
+	"ibs_op:NB_CACHE_OWNED",
+	"ibs_op:NB_LOCAL_CACHE",
+	"ibs_op:NB_LOCAL_CACHE_LAT",
+	"ibs_op:NB_LOCAL_DRAM",
+	"ibs_op:NB_LOCAL_L3",
+	"ibs_op:NB_LOCAL_ONLY",
+	"ibs_op:NB_LOCAL_OTHER",
+	"ibs_op:NB_REMOTE_CACHE",
+	"ibs_op:NB_REMOTE_CACHE_LAT",
+	"ibs_op:NB_REMOTE_DRAM",
+	"ibs_op:NB_REMOTE_ONLY",
+	"ibs_op:NB_REMOTE_OTHER",
+	"ibs_op:RESYNC",
+	"ibs_op:RETURNS",
+	"ibs_op:STORE",
+	"ibs_op:TAG_TO_RETIRE",
+	"ibs_op:TAKEN_BRANCH",
+	NULL
+};
+
+static void ibs_print_events(const char *sys)
+{
+	const char **event;
+
+	printf("\n");
+
+	for (event = events; *event; event++) {
+		if (!strncmp(sys, *event, strlen(sys)))
+			printf("  %-50s [PMU event: %s]\n", *event, sys);
+	}
+}
+
+struct pmu_handler pmu_ibs_fetch = {
+	.name		= "ibs_fetch",
+	.print_events	= ibs_print_events,
+};
+
+struct pmu_handler pmu_ibs_op = {
+	.name		= "ibs_op",
+	.print_events	= ibs_print_events,
+};
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 480c448..7bfaba1 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -5,17 +5,44 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
+#include <stddef.h>
 #include "sysfs.h"
 #include "util.h"
 #include "pmu.h"
 #include "parse-events.h"
 
+#define EVENT_SOURCE_DEVICE_PATH "/bus/event_source/devices/"
+
 int perf_pmu_parse(struct list_head *list, char *name);
 extern FILE *perf_pmu_in;
 
 static LIST_HEAD(pmus);
 
 /*
+ * Dynamic PMU support
+ *
+ */
+
+static struct pmu_handler *pmu_handlers[] = {
+	&pmu_ibs_fetch,
+	&pmu_ibs_op,
+	NULL		/* terminator */
+};
+
+void perf_pmu__print_events(const char *sys)
+{
+	struct perf_pmu *pmu = NULL;
+
+	while ((pmu = perf_pmu__scan(pmu))) {
+		if (!pmu->handler)
+			continue;
+		if (sys && strncmp(pmu->name, sys, strlen(sys)))
+			continue;
+		pmu->handler->print_events(pmu->name);
+	}
+}
+
+/*
  * Parse & process all the sysfs attributes located under
  * the directory specified in 'dir' parameter.
  */
@@ -69,7 +96,7 @@ static int pmu_format(char *name, struct list_head *format)
 		return -1;
 
 	snprintf(path, PATH_MAX,
-		 "%s/bus/event_source/devices/%s/format", sysfs, name);
+		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/format", sysfs, name);
 
 	if (stat(path, &st) < 0)
 		return 0;	/* no error if format does not exist */
@@ -98,7 +125,7 @@ static int pmu_type(char *name, __u32 *type)
 		return -1;
 
 	snprintf(path, PATH_MAX,
-		 "%s/bus/event_source/devices/%s/type", sysfs, name);
+		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/type", sysfs, name);
 
 	if (stat(path, &st) < 0)
 		return -1;
@@ -114,6 +141,45 @@ static int pmu_type(char *name, __u32 *type)
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
+		perf_pmu__find(dent->d_name);
+	}
+
+	closedir(dir);
+}
+
+static struct pmu_handler *get_pmu_handler(char *name)
+{
+	struct pmu_handler **handler;
+
+	for (handler = pmu_handlers; *handler; handler++)
+		if (!strcmp((*handler)->name, name))
+			return *handler;
+
+	return NULL;
+}
+
 static struct perf_pmu *pmu_lookup(char *name)
 {
 	struct perf_pmu *pmu;
@@ -139,6 +205,7 @@ static struct perf_pmu *pmu_lookup(char *name)
 	list_splice(&format, &pmu->format);
 	pmu->name = strdup(name);
 	pmu->type = type;
+	pmu->handler = get_pmu_handler(name);
 	list_add_tail(&pmu->list, &pmus);
 	return pmu;
 }
@@ -154,6 +221,21 @@ static struct perf_pmu *pmu_find(char *name)
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
index 68c0db9..e5788aa 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -19,11 +19,18 @@ struct perf_pmu__format {
 	struct list_head list;
 };
 
+struct pmu_handler {
+	const char *name;
+
+	void(*print_events)(const char *sys);
+};
+
 struct perf_pmu {
 	char *name;
 	__u32 type;
 	struct list_head format;
 	struct list_head list;
+	struct pmu_handler *handler;
 };
 
 struct perf_pmu *perf_pmu__find(char *name);
@@ -38,4 +45,12 @@ int perf_pmu__new_format(struct list_head *list, char *name,
 void perf_pmu__set_format(unsigned long *bits, long from, long to);
 
 int perf_pmu__test(void);
+
+struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
+void perf_pmu__print_events(const char *sys);
+
+/* supported pmus: */
+struct pmu_handler pmu_ibs_fetch;
+struct pmu_handler pmu_ibs_op;
+
 #endif /* __PMU_H */
-- 
1.7.8.4


