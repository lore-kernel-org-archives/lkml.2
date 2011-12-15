Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab1LOR0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:26:55 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35501 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238Ab1LOR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:26:53 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW99NY-01-A8O-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/4] perf tools: Add pmu mappings to header information
Date: Thu, 15 Dec 2011 18:23:42 +0100
Message-ID: <1323969824-9711-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
References: <1323969824-9711-1-git-send-email-robert.richter@amd.com>
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

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h |    1 +
 2 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1e38c10..52dd7b4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -988,6 +988,73 @@ done:
 	return ret;
 }
 
+#define EVENT_SOURCE_DEVICE_PATH "/sys/bus/event_source/devices/"
+
+/*
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
+	char path[MAXPATHLEN];
+	DIR *dir;
+	struct dirent *dent;
+	FILE *fp;
+	char *line = NULL;
+	off_t offset = lseek(fd, 0, SEEK_CUR);
+	size_t ignore;
+	u32 pmu_num = 0;
+	u32 type;
+
+	dir = opendir(EVENT_SOURCE_DEVICE_PATH);
+	if (!dir)
+		return -1;
+
+	/* write real pmu_num later */
+	do_write(fd, &pmu_num, sizeof(pmu_num));
+
+	while ((dent = readdir(dir))) {
+		if (!strcmp(dent->d_name, ".") || !strcmp(dent->d_name, ".."))
+			continue;
+		snprintf(path, sizeof(path), "%s%s/type",
+			 EVENT_SOURCE_DEVICE_PATH, dent->d_name);
+		fp = fopen(path, "r");
+		if (!fp)
+			continue;
+		if (getline(&line, &ignore, fp) < 0) {
+			fclose(fp);
+			continue;
+		}
+		fclose(fp);
+		type = atoi(line);
+		if (!type)
+			continue;
+		pmu_num++;
+		do_write(fd, &type, sizeof(type));
+		do_write_string(fd, dent->d_name);
+	}
+
+	free(line);
+	closedir(dir);
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
 /*
  * default get_cpuid(): nothing gets recorded
  * actual implementation must be in arch/$(ARCH)/util/header.c
@@ -1305,6 +1372,37 @@ static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
 	free(str);
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
+	if (!pmu_num)
+		goto error;
+
+	while (pmu_num--) {
+		if (read(fd, &type, sizeof(type)) != sizeof(type))
+			goto error;
+		name = do_read_string(fd, ph);
+		fprintf(fp, "%s%s = %" PRIu32, delimiter, name, type);
+		free(name);
+		delimiter = ", ";
+	}
+
+	fprintf(fp, "\n");
+
+	return;
+error:
+	fprintf(fp, "# pmu mappings: not available\n");
+}
+
 static int __event_process_build_id(struct build_id_event *bev,
 				    char *filename,
 				    struct perf_session *session)
@@ -1509,6 +1607,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_CMDLINE,	cmdline),
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
+	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
 };
 
 struct header_print_data {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index e68f617..9b4d407 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -27,6 +27,7 @@ enum {
 	HEADER_EVENT_DESC,
 	HEADER_CPU_TOPOLOGY,
 	HEADER_NUMA_TOPOLOGY,
+	HEADER_PMU_MAPPINGS,
 
 	HEADER_LAST_FEATURE,
 	HEADER_FEAT_BITS	= 256,
-- 
1.7.7


