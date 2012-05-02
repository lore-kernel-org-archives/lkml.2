Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2EBS1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:27:31 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:41925
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab2EBS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:26:55 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3ER8L-02-FJE-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] perf tools: Add pmu mappings to header information
Date: Wed, 2 May 2012 20:26:31 +0200
Message-ID: <1335983192-23731-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
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
in perf.data. Using the header for this. The header information
created with perf report would contain an additional section looking
like this:

 # pmu mappings: ibs_op = 7, ibs_fetch = 6, cpu = 4, breakpoint = 5, tracepoint = 2, software = 1

V2:
* improve error handling in print_pmu_mappings()
* use perf_pmu__scan() to iterate over pmus

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |    1 +
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c7c2d7..c139da7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -20,6 +20,7 @@
 #include "symbol.h"
 #include "debug.h"
 #include "cpumap.h"
+#include "pmu.h"
 
 static bool no_buildid_cache = false;
 
@@ -1000,6 +1001,45 @@ done:
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
@@ -1327,6 +1367,43 @@ static void print_branch_stack(struct perf_header *ph __used, int fd __used,
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
@@ -1532,6 +1609,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
+	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 21a6be0..166dba6 100644
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
-- 
1.7.8.4


