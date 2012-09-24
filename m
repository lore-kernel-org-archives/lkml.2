Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2IXIXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:23:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56615 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab2IXIXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:23:36 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-ed-506018861dd3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/6] perf header: Add ->process callbacks to most of features
Date: Mon, 24 Sep 2012 17:14:59 +0900
Message-Id: <1348474503-15070-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From now on each feature information is processed and saved in perf
header so that it can be used wherever needed.  The BRANCH_STACK
feature is an exception since it needs nothing to be done.

Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 319 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 308 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ad72b2814ba8..d74b58d4105d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -22,6 +22,7 @@
 #include "cpumap.h"
 #include "pmu.h"
 #include "vdso.h"
+#include "strbuf.h"
 
 static bool no_buildid_cache = false;
 
@@ -1673,6 +1674,99 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
+static int process_hostname(struct perf_file_section *section __maybe_unused,
+			    struct perf_header *ph, int feat __maybe_unused,
+			    int fd, void *data __maybe_unused)
+{
+	ph->env.hostname = do_read_string(fd, ph);
+	return ph->env.hostname ? 0 : -ENOMEM;
+}
+
+static int process_osrelease(struct perf_file_section *section __maybe_unused,
+			     struct perf_header *ph, int feat __maybe_unused,
+			     int fd, void *data __maybe_unused)
+{
+	ph->env.os_release = do_read_string(fd, ph);
+	return ph->env.os_release ? 0 : -ENOMEM;
+}
+
+static int process_version(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
+{
+	ph->env.version = do_read_string(fd, ph);
+	return ph->env.version ? 0 : -ENOMEM;
+}
+
+static int process_arch(struct perf_file_section *section __maybe_unused,
+			struct perf_header *ph, int feat __maybe_unused,
+			int fd, void *data __maybe_unused)
+{
+	ph->env.arch = do_read_string(fd, ph);
+	return ph->env.arch ? 0 : -ENOMEM;
+}
+
+static int process_nrcpus(struct perf_file_section *section __maybe_unused,
+			  struct perf_header *ph, int feat __maybe_unused,
+			  int fd, void *data __maybe_unused)
+{
+	size_t ret;
+	u32 nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_cpus_online = nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_cpus_avail = nr;
+	return 0;
+}
+
+static int process_cpudesc(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
+{
+	ph->env.cpu_desc = do_read_string(fd, ph);
+	return ph->env.cpu_desc ? 0 : -ENOMEM;
+}
+
+static int process_cpuid(struct perf_file_section *section __maybe_unused,
+			 struct perf_header *ph, int feat __maybe_unused,
+			 int fd, void *data __maybe_unused)
+{
+	ph->env.cpuid = do_read_string(fd, ph);
+	return ph->env.cpuid ? 0 : -ENOMEM;
+}
+
+static int process_total_mem(struct perf_file_section *section __maybe_unused,
+			     struct perf_header *ph, int feat __maybe_unused,
+			     int fd, void *data __maybe_unused)
+{
+	uint64_t mem;
+	size_t ret;
+
+	ret = read(fd, &mem, sizeof(mem));
+	if (ret != sizeof(mem))
+		return -1;
+
+	if (ph->needs_swap)
+		mem = bswap_64(mem);
+
+	ph->env.total_mem = mem;
+	return 0;
+}
+
 static char *read_cpuid(struct perf_header *ph, int fd)
 {
 	return do_read_string(fd, ph);
@@ -1728,6 +1822,208 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 	return 0;
 }
 
+static int process_cmdline(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
+{
+	size_t ret;
+	char *str;
+	u32 nr, i;
+	struct strbuf sb;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_cmdline = nr;
+	strbuf_init(&sb, 128);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		/* include a NULL character at the end */
+		strbuf_add(&sb, str, strlen(str) + 1);
+		free(str);
+	}
+	ph->env.cmdline = strbuf_detach(&sb, NULL);
+	return 0;
+
+error:
+	strbuf_release(&sb);
+	return -1;
+}
+
+static int process_cpu_topology(struct perf_file_section *section __maybe_unused,
+				struct perf_header *ph, int feat __maybe_unused,
+				int fd, void *data __maybe_unused)
+{
+	size_t ret;
+	u32 nr, i;
+	char *str;
+	struct strbuf sb;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_sibling_cores = nr;
+	strbuf_init(&sb, 128);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		/* include a NULL character at the end */
+		strbuf_add(&sb, str, strlen(str) + 1);
+		free(str);
+	}
+	ph->env.sibling_cores = strbuf_detach(&sb, NULL);
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_sibling_threads = nr;
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		/* include a NULL character at the end */
+		strbuf_add(&sb, str, strlen(str) + 1);
+		free(str);
+	}
+	ph->env.sibling_threads = strbuf_detach(&sb, NULL);
+	return 0;
+
+error:
+	strbuf_release(&sb);
+	return -1;
+}
+
+static int process_numa_topology(struct perf_file_section *section __maybe_unused,
+				 struct perf_header *ph, int feat __maybe_unused,
+				 int fd, void *data __maybe_unused)
+{
+	size_t ret;
+	u32 nr, node, i;
+	char *str;
+	uint64_t mem_total, mem_free;
+	struct strbuf sb;
+
+	/* nr nodes */
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != sizeof(nr))
+		goto error;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->env.nr_numa_nodes = nr;
+	strbuf_init(&sb, 256);
+
+	for (i = 0; i < nr; i++) {
+		/* node number */
+		ret = read(fd, &node, sizeof(node));
+		if (ret != sizeof(node))
+			goto error;
+
+		ret = read(fd, &mem_total, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		ret = read(fd, &mem_free, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		if (ph->needs_swap) {
+			node = bswap_32(node);
+			mem_total = bswap_64(mem_total);
+			mem_free = bswap_64(mem_free);
+		}
+
+		strbuf_addf(&sb, "%u:%"PRIu64":%"PRIu64":",
+			    node, mem_total, mem_free);
+
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		/* include a NULL character at the end */
+		strbuf_add(&sb, str, strlen(str) + 1);
+		free(str);
+	}
+	ph->env.numa_nodes = strbuf_detach(&sb, NULL);
+	return 0;
+
+error:
+	strbuf_release(&sb);
+	return -1;
+}
+
+static int process_pmu_mappings(struct perf_file_section *section __maybe_unused,
+				struct perf_header *ph, int feat __maybe_unused,
+				int fd, void *data __maybe_unused)
+{
+	size_t ret;
+	char *name;
+	u32 pmu_num;
+	u32 type;
+	struct strbuf sb;
+
+	ret = read(fd, &pmu_num, sizeof(pmu_num));
+	if (ret != sizeof(pmu_num))
+		return -1;
+
+	if (ph->needs_swap)
+		pmu_num = bswap_32(pmu_num);
+
+	if (!pmu_num) {
+		pr_debug("pmu mappings not available\n");
+		return 0;
+	}
+
+	ph->env.nr_pmu_mappings = pmu_num;
+	strbuf_init(&sb, 128);
+
+	while (pmu_num) {
+		if (read(fd, &type, sizeof(type)) != sizeof(type))
+			goto error;
+		if (ph->needs_swap)
+			type = bswap_32(type);
+
+		name = do_read_string(fd, ph);
+		if (!name)
+			goto error;
+
+		strbuf_addf(&sb, "%u:%s", type, name);
+		/* include a NULL character at the end */
+		strbuf_add(&sb, "", 1);
+
+		free(name);
+		pmu_num--;
+	}
+	ph->env.pmu_mappings = strbuf_detach(&sb, NULL);
+	return 0;
+
+error:
+	strbuf_release(&sb);
+	return -1;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1745,10 +2041,11 @@ struct feature_ops {
 		.process = process_##func }
 #define FEAT_OPF(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.full_only = true }
+		.process = process_##func, .full_only = true }
 #define FEAT_OPA_R(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.read  = read_##func }
+		.read  = read_##func, .process = process_##func, \
+		.full_only = true }
 
 /* feature_ops not implemented: */
 #define print_tracing_data	NULL
@@ -1757,20 +2054,20 @@ struct feature_ops {
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPP(HEADER_TRACING_DATA,	tracing_data),
 	FEAT_OPP(HEADER_BUILD_ID,	build_id),
-	FEAT_OPA(HEADER_HOSTNAME,	hostname),
-	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
-	FEAT_OPA(HEADER_VERSION,	version),
-	FEAT_OPA(HEADER_ARCH,		arch),
-	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
-	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
+	FEAT_OPP(HEADER_HOSTNAME,	hostname),
+	FEAT_OPP(HEADER_OSRELEASE,	osrelease),
+	FEAT_OPP(HEADER_VERSION,	version),
+	FEAT_OPP(HEADER_ARCH,		arch),
+	FEAT_OPP(HEADER_NRCPUS,		nrcpus),
+	FEAT_OPP(HEADER_CPUDESC,	cpudesc),
 	FEAT_OPA_R(HEADER_CPUID,	cpuid),
-	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
+	FEAT_OPP(HEADER_TOTAL_MEM,	total_mem),
 	FEAT_OPP(HEADER_EVENT_DESC,	event_desc),
-	FEAT_OPA(HEADER_CMDLINE,	cmdline),
+	FEAT_OPP(HEADER_CMDLINE,	cmdline),
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
-	FEAT_OPA(HEADER_PMU_MAPPINGS,	pmu_mappings),
+	FEAT_OPP(HEADER_PMU_MAPPINGS,	pmu_mappings),
 };
 
 struct header_print_data {
-- 
1.7.11.4

