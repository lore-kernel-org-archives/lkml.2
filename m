Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab2HWPKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49955 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2HWPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/12] perf tools: Refactor print_event_desc()
Date: Thu, 23 Aug 2012 12:09:48 -0300
Message-Id: <1345734596-7601-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

For later use we need a function read_event_desc() for processing the
event_desc feature. Split it from print_event_desc().

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-7-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |  134 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 93 insertions(+), 41 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1e5b6aa..7454cf4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1148,12 +1148,29 @@ static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
 	}
 }
 
-static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+static void free_event_desc(struct perf_evsel *events)
 {
-	struct perf_event_attr attr;
-	uint64_t id;
+	struct perf_evsel *evsel;
+
+	if (!events)
+		return;
+
+	for (evsel = events; evsel->attr.size; evsel++) {
+		if (evsel->name)
+			free(evsel->name);
+		if (evsel->id)
+			free(evsel->id);
+	}
+
+	free(events);
+}
+
+static struct perf_evsel *
+read_event_desc(struct perf_header *ph, int fd)
+{
+	struct perf_evsel *evsel, *events = NULL;
+	u64 *id;
 	void *buf = NULL;
-	char *str;
 	u32 nre, sz, nr, i, j;
 	ssize_t ret;
 	size_t msz;
@@ -1173,18 +1190,22 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 	if (ph->needs_swap)
 		sz = bswap_32(sz);
 
-	memset(&attr, 0, sizeof(attr));
-
 	/* buffer to hold on file attr struct */
 	buf = malloc(sz);
 	if (!buf)
 		goto error;
 
-	msz = sizeof(attr);
+	/* the last event terminates with evsel->attr.size == 0: */
+	events = calloc(nre + 1, sizeof(*events));
+	if (!events)
+		goto error;
+
+	msz = sizeof(evsel->attr);
 	if (sz < msz)
 		msz = sz;
 
-	for (i = 0 ; i < nre; i++) {
+	for (i = 0, evsel = events; i < nre; evsel++, i++) {
+		evsel->idx = i;
 
 		/*
 		 * must read entire on-file attr struct to
@@ -1197,7 +1218,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		if (ph->needs_swap)
 			perf_event__attr_swap(buf);
 
-		memcpy(&attr, buf, msz);
+		memcpy(&evsel->attr, buf, msz);
 
 		ret = read(fd, &nr, sizeof(nr));
 		if (ret != (ssize_t)sizeof(nr))
@@ -1206,51 +1227,82 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		if (ph->needs_swap)
 			nr = bswap_32(nr);
 
-		str = do_read_string(fd, ph);
-		fprintf(fp, "# event : name = %s, ", str);
-		free(str);
+		evsel->name = do_read_string(fd, ph);
+
+		if (!nr)
+			continue;
+
+		id = calloc(nr, sizeof(*id));
+		if (!id)
+			goto error;
+		evsel->ids = nr;
+		evsel->id = id;
+
+		for (j = 0 ; j < nr; j++) {
+			ret = read(fd, id, sizeof(*id));
+			if (ret != (ssize_t)sizeof(*id))
+				goto error;
+			if (ph->needs_swap)
+				*id = bswap_64(*id);
+			id++;
+		}
+	}
+out:
+	if (buf)
+		free(buf);
+	return events;
+error:
+	if (events)
+		free_event_desc(events);
+	events = NULL;
+	goto out;
+}
+
+static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+{
+	struct perf_evsel *evsel, *events = read_event_desc(ph, fd);
+	u32 j;
+	u64 *id;
+
+	if (!events) {
+		fprintf(fp, "# event desc: not available or unable to read\n");
+		return;
+	}
+
+	for (evsel = events; evsel->attr.size; evsel++) {
+		fprintf(fp, "# event : name = %s, ", evsel->name);
 
 		fprintf(fp, "type = %d, config = 0x%"PRIx64
 			    ", config1 = 0x%"PRIx64", config2 = 0x%"PRIx64,
-				attr.type,
-				(u64)attr.config,
-				(u64)attr.config1,
-				(u64)attr.config2);
+				evsel->attr.type,
+				(u64)evsel->attr.config,
+				(u64)evsel->attr.config1,
+				(u64)evsel->attr.config2);
 
 		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
-				attr.exclude_user,
-				attr.exclude_kernel);
+				evsel->attr.exclude_user,
+				evsel->attr.exclude_kernel);
 
 		fprintf(fp, ", excl_host = %d, excl_guest = %d",
-				attr.exclude_host,
-				attr.exclude_guest);
+				evsel->attr.exclude_host,
+				evsel->attr.exclude_guest);
 
-		fprintf(fp, ", precise_ip = %d", attr.precise_ip);
+		fprintf(fp, ", precise_ip = %d", evsel->attr.precise_ip);
 
-		if (nr)
+		if (evsel->ids) {
 			fprintf(fp, ", id = {");
-
-		for (j = 0 ; j < nr; j++) {
-			ret = read(fd, &id, sizeof(id));
-			if (ret != (ssize_t)sizeof(id))
-				goto error;
-
-			if (ph->needs_swap)
-				id = bswap_64(id);
-
-			if (j)
-				fputc(',', fp);
-
-			fprintf(fp, " %"PRIu64, id);
-		}
-		if (nr && j == nr)
+			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
+				if (j)
+					fputc(',', fp);
+				fprintf(fp, " %"PRIu64, *id);
+			}
 			fprintf(fp, " }");
+		}
+
 		fputc('\n', fp);
 	}
-	free(buf);
-	return;
-error:
-	fprintf(fp, "# event desc: not available or unable to read\n");
+
+	free_event_desc(events);
 }
 
 static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
-- 
1.7.1

