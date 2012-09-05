Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2IEFKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48142 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2IEFKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:24 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-49-5046debd19f3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 6/7] perf header: Use pre-processed header info when printing
Date: Wed,  5 Sep 2012 14:02:52 +0900
Message-Id: <1346821373-31621-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/header.c | 196 ++++++++++++++---------------------------------
 1 file changed, 57 insertions(+), 139 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9c6ab1b52a07..2cc0954d984c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1073,118 +1073,73 @@ static int write_branch_stack(int fd __used, struct perf_header *h __used,
 	return 0;
 }
 
-static void print_hostname(struct perf_header *ph, int fd, FILE *fp)
+static void print_hostname(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# hostname : %s\n", str);
-	free(str);
+	fprintf(fp, "# hostname : %s\n", ph->info.hostname);
 }
 
-static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+static void print_osrelease(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# os release : %s\n", str);
-	free(str);
+	fprintf(fp, "# os release : %s\n", ph->info.os_release);
 }
 
-static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+static void print_arch(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# arch : %s\n", str);
-	free(str);
+	fprintf(fp, "# arch : %s\n", ph->info.arch);
 }
 
-static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpudesc(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# cpudesc : %s\n", str);
-	free(str);
+	fprintf(fp, "# cpudesc : %s\n", ph->info.cpu_desc);
 }
 
-static void print_nrcpus(struct perf_header *ph, int fd, FILE *fp)
+static void print_nrcpus(struct perf_header *ph, int fd __used, FILE *fp)
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
+static void print_version(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# perf version : %s\n", str);
-	free(str);
+	fprintf(fp, "# perf version : %s\n", ph->info.version);
 }
 
-static void print_cmdline(struct perf_header *ph, int fd, FILE *fp)
+static void print_cmdline(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	ssize_t ret;
+	int nr, i;
 	char *str;
-	u32 nr, i;
 
-	ret = read(fd, &nr, sizeof(nr));
-	if (ret != (ssize_t)sizeof(nr))
-		return;
-
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
+static void print_cpu_topology(struct perf_header *ph, int fd __used, FILE *fp)
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
 
@@ -1345,82 +1300,52 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	free_event_desc(events);
 }
 
-static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
+static void print_total_mem(struct perf_header *ph, int fd __used, FILE *fp)
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
 
-static void print_numa_topology(struct perf_header *h __used, int fd, FILE *fp)
+static void print_numa_topology(struct perf_header *ph, int fd __used, FILE *fp)
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
+static void print_cpuid(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# cpuid : %s\n", str);
-	free(str);
+	fprintf(fp, "# cpuid : %s\n", ph->info.cpuid);
 }
 
 static void print_branch_stack(struct perf_header *ph __used, int fd __used,
@@ -1429,39 +1354,32 @@ static void print_branch_stack(struct perf_header *ph __used, int fd __used,
 	fprintf(fp, "# contains samples with branch stack\n");
 }
 
-static void print_pmu_mappings(struct perf_header *ph, int fd, FILE *fp)
+static void print_pmu_mappings(struct perf_header *ph, int fd __used, FILE *fp)
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
-- 
1.7.11.4

