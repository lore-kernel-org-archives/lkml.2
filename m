Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2GUQqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:46:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2GUQqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:46:47 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf header: add ->process callbacks to most of features
Date: Sun, 22 Jul 2012 01:45:32 +0900
Message-Id: <1342889135-14825-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
References: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From now for each feature information is processed and saved in perf
header so that it can be used wherever needed. The EVENT_DESC and
BRANCH_STACK features are exceptions since they need nothing to be done.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c |  360 ++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/header.h |   13 ++
 2 files changed, 363 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 193aa089f9a6..1a30f2831616 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1377,6 +1377,346 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
+static int process_hostname(struct perf_file_section *section __used,
+			    struct perf_header *ph, int feat __used, int fd,
+			    void *data __used)
+{
+	ph->hostname = do_read_string(fd, ph);
+	return ph->hostname ? 0 : -ENOMEM;
+}
+
+static int process_osrelease(struct perf_file_section *section __used,
+			     struct perf_header *ph, int feat __used, int fd,
+			     void *data __used)
+{
+
+	ph->os_release = do_read_string(fd, ph);
+	return ph->os_release ? 0 : -ENOMEM;
+}
+
+static int process_arch(struct perf_file_section *section __used,
+			struct perf_header *ph, int feat __used, int fd,
+			void *data __used)
+{
+	ph->arch = do_read_string(fd, ph);
+	return ph->arch ? 0 : -ENOMEM;
+}
+
+static int process_cpudesc(struct perf_file_section *section __used,
+			   struct perf_header *ph, int feat __used, int fd,
+			   void *data __used)
+{
+	ph->cpu_desc = do_read_string(fd, ph);
+	return ph->cpu_desc ? 0 : -ENOMEM;
+}
+
+static int process_nrcpus(struct perf_file_section *section __used,
+			  struct perf_header *ph, int feat __used, int fd,
+			  void *data __used)
+{
+	ssize_t ret;
+	u32 nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->nr_cpus_online = nr;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		nr = -1; /* interpreted as error */
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->nr_cpus_avail = nr;
+
+	return 0;
+}
+
+static int process_version(struct perf_file_section *section __used,
+			   struct perf_header *ph, int feat __used, int fd,
+			   void *data __used)
+{
+	ph->version = do_read_string(fd, ph);
+	return ph->version ? 0 : -ENOMEM;
+}
+
+/* Each argv would be separated by a NULL character */
+static int process_cmdline(struct perf_file_section *section __used,
+			   struct perf_header *ph, int feat __used, int fd,
+			   void *data __used)
+{
+	ssize_t ret;
+	char *str, *tmp;
+	u32 nr, i;
+	char *cmdline = NULL;
+	size_t len = 0;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	ph->cmdline_argc = nr;
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		tmp = realloc(cmdline, len + strlen(str) + 1);
+		if (!tmp)
+			goto error;
+		cmdline = tmp;
+
+		/* include null character at the end */
+		strcpy(cmdline + len, str);
+
+		len += strlen(str) + 1;
+		free(str);
+	}
+	ph->cmdline = cmdline;
+	return 0;
+
+error:
+	free(cmdline);
+	free(str);
+	return -1;
+}
+
+#define TOPO_STR_LEN  ((size_t) 256)
+#define TOPO_STR_DELIM ':'
+
+#define check_topo_len(topo, allocated, used, len)			\
+({									\
+	if (len > allocated - used) {					\
+		char *tmp = realloc(topo, allocated + TOPO_STR_LEN);	\
+		if (!tmp)						\
+			goto error;					\
+		topo = tmp;						\
+		allocated += TOPO_STR_LEN;				\
+	}								\
+})
+
+/*
+ * The topology string looks like below (':' is used for delimiter):
+ *
+ * 	"NR_CORE_SIBLINGS(N):SIBLING[0]:SIBLING[1]:...:SIBLING[N-1]\n"
+ *	"NR_THREAD_SIBLINGS(M):SIBLING[0]:SIBLING[1]:...:SIBLING[M-1]\n"
+ */
+static int process_cpu_topology(struct perf_file_section *section __used,
+				struct perf_header *ph, int feat __used,
+				int fd,	void *data __used)
+{
+	ssize_t ret;
+	u32 nr, i;
+	char *str;
+	char buf[128];
+	char *topo = NULL;
+	size_t allocated = 0, used, len;
+
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		return -1;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	allocated = TOPO_STR_LEN;
+	topo = malloc(TOPO_STR_LEN);
+	if (!topo)
+		return -ENOMEM;
+
+	/* core siblings */
+	used = scnprintf(topo, allocated, "%u", nr);
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		len = strlen(str) + 1;
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%c%s",
+			  TOPO_STR_DELIM, str);
+		used += len;
+		free(str);
+	}
+	check_topo_len(topo, allocated, used, 1);
+	scnprintf(topo + used, allocated - used, "\n");
+	used++;
+
+	/* thread siblings */
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		goto error;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	len = scnprintf(buf, sizeof(buf), "%u", nr);
+	check_topo_len(topo, allocated, used, len);
+
+	strcat(topo, buf);
+	used += len;
+
+	for (i = 0; i < nr; i++) {
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		len = strlen(str) + 1;
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%c%s",
+			  TOPO_STR_DELIM, str);
+		used += len;
+		free(str);
+	}
+	check_topo_len(topo, allocated, used, 1);
+	scnprintf(topo + used, allocated - used, "\n");
+
+	ph->cpu_topology = topo;
+	return 0;
+
+error:
+	free(topo);
+	return -1;
+}
+
+/*
+ * The topology string looks like below (':' is used for delimiter):
+ *
+ *	"NR_NODES(N)\n
+ *	"NODE_NUM(0):MEM_TOTAL:MEM_FREE:CPULIST\n"
+ *	"NODE_NUM(1):MEM_TOTAL:MEM_FREE:CPULIST\n"
+ *	...
+ *	"NODE_NUM(N-1):MEM_TOTAL:MEM_FREE:CPULIST\n"
+ */
+static int process_numa_topology(struct perf_file_section *section __used,
+				 struct perf_header *ph, int feat __used,
+				 int fd, void *data __used)
+{
+	ssize_t ret;
+	u32 nr, node, i;
+	char *str;
+	uint64_t mem_total, mem_free;
+	char *topo = NULL;
+	size_t allocated = 0, used, len;
+
+	/* nr nodes */
+	ret = read(fd, &nr, sizeof(nr));
+	if (ret != (ssize_t)sizeof(nr))
+		goto error;
+
+	if (ph->needs_swap)
+		nr = bswap_32(nr);
+
+	allocated = TOPO_STR_LEN;
+	topo = malloc(TOPO_STR_LEN);
+	if (!topo)
+		return -ENOMEM;
+
+	used = scnprintf(topo, allocated, "%u\n", nr);
+
+	for (i = 0; i < nr; i++) {
+		char buf[128];
+
+		/* node number */
+		ret = read(fd, &node, sizeof(node));
+		if (ret != (ssize_t)sizeof(node))
+			goto error;
+
+		if (ph->needs_swap)
+			node = bswap_32(node);
+
+		len = scnprintf(buf, sizeof(buf), "%u%c", node, TOPO_STR_DELIM);
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%s", buf);
+		used += len;
+
+		ret = read(fd, &mem_total, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		if (ph->needs_swap)
+			mem_total = bswap_64(mem_total);
+
+		len = scnprintf(buf, sizeof(buf), "%"PRIu64"%c",
+				mem_total, TOPO_STR_DELIM);
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%s", buf);
+		used += len;
+
+		ret = read(fd, &mem_free, sizeof(u64));
+		if (ret != sizeof(u64))
+			goto error;
+
+		if (ph->needs_swap)
+			mem_free = bswap_64(mem_free);
+
+		len = scnprintf(buf, sizeof(buf), "%"PRIu64"%c",
+				mem_total, TOPO_STR_DELIM);
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%s", buf);
+		used += len;
+
+		str = do_read_string(fd, ph);
+		if (!str)
+			goto error;
+
+		len = strlen(str) + 1;
+		check_topo_len(topo, allocated, used, len);
+
+		scnprintf(topo + used, allocated - used, "%s\n", str);
+		used += len;
+		free(str);
+	}
+
+	ph->numa_topology = topo;
+	return 0;
+error:
+	free(topo);
+	return -1;
+}
+
+static int process_cpuid(struct perf_file_section *section __used,
+			 struct perf_header *ph, int feat __used, int fd,
+			 void *data __used)
+{
+	ph->cpuid = do_read_string(fd, ph);
+	return ph->cpuid ? 0 : -ENOMEM;
+}
+
+static int process_total_mem(struct perf_file_section *section __used,
+			     struct perf_header *ph, int feat __used, int fd,
+			     void *data __used)
+{
+	uint64_t mem;
+	ssize_t ret;
+
+	ret = read(fd, &mem, sizeof(mem));
+	if (ret != sizeof(mem))
+		return -1;
+
+	if (ph->needs_swap)
+		mem = bswap_64(mem);
+
+	ph->total_mem = mem;
+	return 0;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1393,7 +1733,7 @@ struct feature_ops {
 		.process = process_##func }
 #define FEAT_OPF(n, func) \
 	[n] = { .name = #n, .write = write_##func, .print = print_##func, \
-		.full_only = true }
+		.process = process_##func, .full_only = true }
 
 /* feature_ops not implemented: */
 #define print_tracing_data	NULL
@@ -1402,16 +1742,16 @@ struct feature_ops {
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPP(HEADER_TRACING_DATA,	tracing_data),
 	FEAT_OPP(HEADER_BUILD_ID,	build_id),
-	FEAT_OPA(HEADER_HOSTNAME,	hostname),
-	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
-	FEAT_OPA(HEADER_VERSION,	version),
-	FEAT_OPA(HEADER_ARCH,		arch),
-	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
-	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
-	FEAT_OPA(HEADER_CPUID,		cpuid),
-	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
+	FEAT_OPP(HEADER_HOSTNAME,	hostname),
+	FEAT_OPP(HEADER_OSRELEASE,	osrelease),
+	FEAT_OPP(HEADER_VERSION,	version),
+	FEAT_OPP(HEADER_ARCH,		arch),
+	FEAT_OPP(HEADER_NRCPUS,		nrcpus),
+	FEAT_OPP(HEADER_CPUDESC,	cpudesc),
+	FEAT_OPP(HEADER_CPUID,		cpuid),
+	FEAT_OPP(HEADER_TOTAL_MEM,	total_mem),
 	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
-	FEAT_OPA(HEADER_CMDLINE,	cmdline),
+	FEAT_OPP(HEADER_CMDLINE,	cmdline),
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 	FEAT_OPA(HEADER_BRANCH_STACK,	branch_stack),
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2d42b3e1826f..6e4f14eb3c95 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -66,6 +66,19 @@ struct perf_header {
 	u64			event_offset;
 	u64			event_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+	char			*hostname;
+	char			*os_release;
+	char			*version;
+	char			*arch;
+	u32			nr_cpus_online;
+	u32			nr_cpus_avail;
+	char			*cpu_desc;
+	char			*cpuid;
+	u64			total_mem;
+	int			cmdline_argc;
+	char			*cmdline;
+	char			*cpu_topology;
+	char			*numa_topology;
 };
 
 struct perf_evlist;
-- 
1.7.9.2

