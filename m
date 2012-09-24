Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2IXQDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:03:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2IXQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/30] perf header: Use pre-processed session env when printing
Date: Mon, 24 Sep 2012 12:59:27 -0300
Message-Id: <1348502384-14442-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

>From now on each feature information is processed and saved in perf
header so that it can be used for printing.  The event desc and branch
stack features are not touched since they're not saved.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1348474503-15070-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |  207 +++++++++++++++-------------------------------
 1 files changed, 66 insertions(+), 141 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d74b58d..b2929d7 100644
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
+	fprintf(fp, "# hostname : %s\n", ph->env.hostname);
 }
 
-static void print_osrelease(struct perf_header *ph, int fd, FILE *fp)
+static void print_osrelease(struct perf_header *ph, int fd __maybe_unused,
+			    FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# os release : %s\n", str);
-	free(str);
+	fprintf(fp, "# os release : %s\n", ph->env.os_release);
 }
 
-static void print_arch(struct perf_header *ph, int fd, FILE *fp)
+static void print_arch(struct perf_header *ph, int fd __maybe_unused, FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# arch : %s\n", str);
-	free(str);
+	fprintf(fp, "# arch : %s\n", ph->env.arch);
 }
 
-static void print_cpudesc(struct perf_header *ph, int fd, FILE *fp)
+static void print_cpudesc(struct perf_header *ph, int fd __maybe_unused,
+			  FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# cpudesc : %s\n", str);
-	free(str);
+	fprintf(fp, "# cpudesc : %s\n", ph->env.cpu_desc);
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
+	fprintf(fp, "# nrcpus online : %u\n", ph->env.nr_cpus_online);
+	fprintf(fp, "# nrcpus avail : %u\n", ph->env.nr_cpus_avail);
 }
 
-static void print_version(struct perf_header *ph, int fd, FILE *fp)
+static void print_version(struct perf_header *ph, int fd __maybe_unused,
+			  FILE *fp)
 {
-	char *str = do_read_string(fd, ph);
-	fprintf(fp, "# perf version : %s\n", str);
-	free(str);
+	fprintf(fp, "# perf version : %s\n", ph->env.version);
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
+	nr = ph->env.nr_cmdline;
+	str = ph->env.cmdline;
 
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
+	nr = ph->env.nr_sibling_cores;
+	str = ph->env.sibling_cores;
 
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
+	nr = ph->env.nr_sibling_threads;
+	str = ph->env.sibling_threads;
 
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
+	fprintf(fp, "# total memory : %Lu kB\n", ph->env.total_mem);
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
+	nr = ph->env.nr_numa_nodes;
+	str = ph->env.numa_nodes;
 
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
+	fprintf(fp, "# cpuid : %s\n", ph->env.cpuid);
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
+	pmu_num = ph->env.nr_pmu_mappings;
 	if (!pmu_num) {
 		fprintf(fp, "# pmu mappings: not available\n");
 		return;
 	}
 
+	str = ph->env.pmu_mappings;
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
1.7.1

