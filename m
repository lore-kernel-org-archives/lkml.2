Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2ITFpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 01:45:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58964 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2ITFpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 01:45:36 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-8b-505aad7d1ed6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/4] perf header: Use pre-processed header info when printing
Date: Thu, 20 Sep 2012 14:36:46 +0900
Message-Id: <1348119407-12528-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
References: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From now on each feature information is processed and saved in perf
header so that it can be used for printing.  The event desc and branch
stack features are not touched since they're not saved.

Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 279 +++++++++++++++++------------------------------
 1 file changed, 102 insertions(+), 177 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fd29d42dedbe..ab5ebe8afbc6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1103,118 +1103,80 @@ static int write_branch_stack(int fd __maybe_unused,
 	return 0;
 }
 
-static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
+static void print_hostname(struct perf_header *ph, int fd __maybe_unused,
+			   FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# hostname : %s\n", str);
-	free(str);
+	fprintf(fp, "# hostname : %s\n", ph->info.hostname);
 }
 
-static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+static void print_osrelease(struct perf_header *ph, int fd __maybe_unused,
+			    FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# os release : %s\n", str);
-	free(str);
+	fprintf(fp, "# os release : %s\n", ph->info.os_release);
 }
 
-static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+static void print_arch(struct perf_header *ph, int fd __maybe_unused, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# arch : %s\n", str);
-	free(str);
+	fprintf(fp, "# arch : %s\n", ph->info.arch);
 }
 
-static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpudesc(struct perf_header *ph, int fd __maybe_unused,
+			  FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# cpudesc : %s\n", str);
-	free(str);
+	fprintf(fp, "# cpudesc : %s\n", ph->info.cpu_desc);
 }
 
-static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
+static void print_nrcpus(struct perf_header *ph, int fd __maybe_unused,
+			 FILE *fp)
 {
-	ssize_t ret;
-	u32 nr;
-
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		nr = -1; /* interpreted as error */
-
-	if (ph->needs_swap)
-		nr = bswap_32(nr);
-
-	fprintf(fp, "# nrcpus online : %u\n", nr);
-
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		nr = -1; /* interpreted as error */
-
-	if (ph->needs_swap)
-		nr = bswap_32(nr);
-
-	fprintf(fp, "# nrcpus avail : %u\n", nr);
+	fprintf(fp, "# nrcpus online : %u\n", ph->info.nr_cpus_online);
+	fprintf(fp, "# nrcpus avail : %u\n", ph->info.nr_cpus_avail);
 }
 
-static void print_version(struct perf_header *ph, int fd, FILE *fp)
+static void print_version(struct perf_header *ph, int fd __maybe_unused,
+			  FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# perf version : %s\n", str);
-	free(str);
+	fprintf(fp, "# perf version : %s\n", ph->info.version);
 }
 
-static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
+static void print_cmdline(struct perf_header *ph, int fd __maybe_unused,
+			  FILE *fp)
 {
-	ssize_t ret;
+	int nr, i;
 	char *str;
-	u32 nr, i;
-
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		return;
 
-	if (ph->needs_swap)
-		nr = bswap_32(nr);
+	nr = ph->info.nr_cmdline;
+	str = ph->info.cmdline;
 
 	fprintf(fp, "# cmdline : ");
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
 		fprintf(fp, "%s ", str);
-		free(str);
+		str += strlen(str) + 1;
 	}
 	fputc('\n', fp);
 }
 
-static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpu_topology(struct perf_header *ph, int fd __maybe_unused,
+			       FILE *fp)
 {
-	ssize_t ret;
-	u32 nr, i;
+	int nr, i;
 	char *str;
 
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		return;
-
-	if (ph->needs_swap)
-		nr = bswap_32(nr);
+	nr = ph->info.nr_sibling_cores;
+	str = ph->info.sibling_cores;
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
 		fprintf(fp, "# sibling cores   : %s\n", str);
-		free(str);
+		str += strlen(str) + 1;
 	}
 
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		return;
-
-	if (ph->needs_swap)
-		nr = bswap_32(nr);
+	nr = ph->info.nr_sibling_threads;
+	str = ph->info.sibling_threads;
 
 	for (i = 0; i < nr; i++) {
-		str = do_read_string(fd, ph);
 		fprintf(fp, "# sibling threads : %s\n", str);
-		free(str);
+		str += strlen(str) + 1;
 	}
 }
 
@@ -1375,126 +1337,89 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	free_event_desc(events);
 }
 
-static void print_total_mem(struct perf_header *h __maybe_unused, int fd,
+static void print_total_mem(struct perf_header *ph, int fd __maybe_unused,
 			    FILE *fp)
 {
-	uint64_t mem;
-	ssize_t ret;
-
-	ret = read(fd, &mem, sizeof(mem));
-	if (ret != sizeof(mem))
-		goto error;
-
-	if (h->needs_swap)
-		mem = bswap_64(mem);
-
-	fprintf(fp, "# total memory : %"PRIu64" kB\n", mem);
-	return;
-error:
-	fprintf(fp, "# total memory : unknown\n");
+	fprintf(fp, "# total memory : %Lu kB\n", ph->info.total_mem);
 }
 
-static void print_numa_topology(struct perf_header *h __maybe_unused, int fd,
+static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
 				FILE *fp)
 {
-	ssize_t ret;
 	u32 nr, c, i;
-	char *str;
+	char *str, *tmp;
 	uint64_t mem_total, mem_free;
 
 	/* nr nodes */
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		goto error;
-
-	if (h->needs_swap)
-		nr = bswap_32(nr);
+	nr = ph->info.nr_numa_nodes;
+	str = ph->info.numa_nodes;
 
 	for (i = 0; i < nr; i++) {
-
 		/* node number */
-		ret = read(fd, &c, sizeof(c));
-		if (ret != (ssize_t)sizeof(c))
+		c = strtoul(str, &tmp, 0);
+		if (*tmp != ':')
 			goto error;
 
-		if (h->needs_swap)
-			c = bswap_32(c);
-
-		ret = read(fd, &mem_total, sizeof(u64));
-		if (ret != sizeof(u64))
+		str = tmp + 1;
+		mem_total = strtoull(str, &tmp, 0);
+		if (*tmp != ':')
 			goto error;
 
-		ret = read(fd, &mem_free, sizeof(u64));
-		if (ret != sizeof(u64))
+		str = tmp + 1;
+		mem_free = strtoull(str, &tmp, 0);
+		if (*tmp != ':')
 			goto error;
 
-		if (h->needs_swap) {
-			mem_total = bswap_64(mem_total);
-			mem_free = bswap_64(mem_free);
-		}
-
 		fprintf(fp, "# node%u meminfo  : total = %"PRIu64" kB,"
 			    " free = %"PRIu64" kB\n",
-			c,
-			mem_total,
-			mem_free);
+			c, mem_total, mem_free);
 
-		str = do_read_string(fd, h);
+		str = tmp + 1;
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
-		free(str);
 	}
 	return;
 error:
 	fprintf(fp, "# numa topology : not available\n");
 }
 
-static void print_cpuid(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpuid(struct perf_header *ph, int fd __maybe_unused, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# cpuid : %s\n", str);
-	free(str);
+	fprintf(fp, "# cpuid : %s\n", ph->info.cpuid);
 }
 
 static void print_branch_stack(struct perf_header *ph __maybe_unused,
-			       int fd __maybe_unused,
-			       FILE *fp)
+			       int fd __maybe_unused, FILE *fp)
 {
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
-static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
+static void print_pmu_mappings(struct perf_header *ph, int fd __maybe_unused,
+			       FILE *fp)
 {
 	const char *delimiter = "# pmu mappings: ";
-	char *name;
-	int ret;
+	char *str, *tmp;
 	u32 pmu_num;
 	u32 type;
 
-	ret = read(fd, &pmu_num, sizeof(pmu_num));
-	if (ret != sizeof(pmu_num))
-		goto error;
-
-	if (ph->needs_swap)
-		pmu_num = bswap_32(pmu_num);
-
+	pmu_num = ph->info.nr_pmu_mappings;
 	if (!pmu_num) {
 		fprintf(fp, "# pmu mappings: not available\n");
 		return;
 	}
 
+	str = ph->info.pmu_mappings;
+
 	while (pmu_num) {
-		if (read(fd, &type, sizeof(type)) != sizeof(type))
-			break;
-		if (ph->needs_swap)
-			type = bswap_32(type);
+		type = strtoul(str, &tmp, 0);
+		if (*tmp != ':')
+			goto error;
+
+		str = tmp + 1;
+		fprintf(fp, "%s%s = %" PRIu32, delimiter, str, type);
 
-		name = do_read_string(fd, ph);
-		if (!name)
-			break;
-		pmu_num--;
-		fprintf(fp, "%s%s = %" PRIu32, delimiter, name, type);
-		free(name);
 		delimiter = ", ";
+		str += strlen(str) + 1;
+		pmu_num--;
 	}
 
 	fprintf(fp, "\n");
@@ -1674,41 +1599,41 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
-static int process_hostname(struct perf_file_section *section __unused,
-			    struct perf_header *ph,
-			    int feat __unused, int fd, void *data __used)
+static int process_hostname(struct perf_file_section *section __maybe_unused,
+			    struct perf_header *ph, int feat __maybe_unused,
+			    int fd, void *data __maybe_unused)
 {
 	ph->info.hostname = do_read_string(fd, ph);
 	return ph->info.hostname ? 0 : -ENOMEM;
 }
 
-static int process_osrelease(struct perf_file_section *section __unused,
-			     struct perf_header *ph,
-			     int feat __unused, int fd, void *data __used)
+static int process_osrelease(struct perf_file_section *section __maybe_unused,
+			     struct perf_header *ph, int feat __maybe_unused,
+			     int fd, void *data __maybe_unused)
 {
 	ph->info.os_release = do_read_string(fd, ph);
 	return ph->info.os_release ? 0 : -ENOMEM;
 }
 
-static int process_version(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+static int process_version(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
 {
 	ph->info.version = do_read_string(fd, ph);
 	return ph->info.version ? 0 : -ENOMEM;
 }
 
-static int process_arch(struct perf_file_section *section __unused,
-			struct perf_header *ph,
-			int feat __unused, int fd, void *data __used)
+static int process_arch(struct perf_file_section *section __maybe_unused,
+			struct perf_header *ph, int feat __maybe_unused,
+			int fd, void *data __maybe_unused)
 {
 	ph->info.arch = do_read_string(fd, ph);
 	return ph->info.arch ? 0 : -ENOMEM;
 }
 
-static int process_nrcpus(struct perf_file_section *section __unused,
-			  struct perf_header *ph,
-			  int feat __unused, int fd, void *data __used)
+static int process_nrcpus(struct perf_file_section *section __maybe_unused,
+			  struct perf_header *ph, int feat __maybe_unused,
+			  int fd, void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr;
@@ -1733,25 +1658,25 @@ static int process_nrcpus(struct perf_file_section *section __unused,
 	return 0;
 }
 
-static int process_cpudesc(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+static int process_cpudesc(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
 {
 	ph->info.cpu_desc = do_read_string(fd, ph);
 	return ph->info.cpu_desc ? 0 : -ENOMEM;
 }
 
-static int process_cpuid(struct perf_file_section *section __unused,
-			 struct perf_header *ph,
-			 int feat __unused, int fd, void *data __used)
+static int process_cpuid(struct perf_file_section *section __maybe_unused,
+			 struct perf_header *ph, int feat __maybe_unused,
+			 int fd, void *data __maybe_unused)
 {
 	ph->info.cpuid = do_read_string(fd, ph);
 	return ph->info.cpuid ? 0 : -ENOMEM;
 }
 
-static int process_total_mem(struct perf_file_section *section __unused,
-			     struct perf_header *ph,
-			     int feat __unused, int fd, void *data __used)
+static int process_total_mem(struct perf_file_section *section __maybe_unused,
+			     struct perf_header *ph, int feat __maybe_unused,
+			     int fd, void *data __maybe_unused)
 {
 	uint64_t mem;
 	size_t ret;
@@ -1817,9 +1742,9 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 	return 0;
 }
 
-static int process_cmdline(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+static int process_cmdline(struct perf_file_section *section __maybe_unused,
+			   struct perf_header *ph, int feat __maybe_unused,
+			   int fd, void *data __maybe_unused)
 {
 	size_t ret;
 	char *str;
@@ -1853,9 +1778,9 @@ error:
 	return -1;
 }
 
-static int process_cpu_topology(struct perf_file_section *section __unused,
-				struct perf_header *ph,
-				int feat __unused, int fd, void *data __used)
+static int process_cpu_topology(struct perf_file_section *section __maybe_unused,
+				struct perf_header *ph, int feat __maybe_unused,
+				int fd, void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr, i;
@@ -1909,9 +1834,9 @@ error:
 	return -1;
 }
 
-static int process_numa_topology(struct perf_file_section *section __unused,
-				 struct perf_header *ph,
-				 int feat __unused, int fd, void *data __used)
+static int process_numa_topology(struct perf_file_section *section __maybe_unused,
+				 struct perf_header *ph, int feat __maybe_unused,
+				 int fd, void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr, node, i;
@@ -1969,9 +1894,9 @@ error:
 	return -1;
 }
 
-static int process_pmu_mappings(struct perf_file_section *section __unused,
-				struct perf_header *ph,
-				int feat __unused, int fd, void *data __used)
+static int process_pmu_mappings(struct perf_file_section *section __maybe_unused,
+				struct perf_header *ph, int feat __maybe_unused,
+				int fd, void *data __maybe_unused)
 {
 	size_t ret;
 	char *name;
-- 
1.7.11.4

