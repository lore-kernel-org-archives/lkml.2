Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2GUQqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:46:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2GUQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:46:44 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/5] perf header: Do not write event_desc feature
Date: Sun, 22 Jul 2012 01:45:31 +0900
Message-Id: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the event descriptions are saved already in the header, do not
write them to the feature section.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c |  154 +++++++---------------------------------------
 1 file changed, 21 insertions(+), 133 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5a47aba46759..193aa089f9a6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -596,61 +596,9 @@ static int write_nrcpus(int fd, struct perf_header *h __used,
 	return do_write(fd, &nra, sizeof(nra));
 }
 
-static int write_event_desc(int fd, struct perf_header *h __used,
-			    struct perf_evlist *evlist)
+static int write_event_desc(int fd __used, struct perf_header *h __used,
+			    struct perf_evlist *evlist __used)
 {
-	struct perf_evsel *attr;
-	u32 nre = 0, nri, sz;
-	int ret;
-
-	list_for_each_entry(attr, &evlist->entries, node)
-		nre++;
-
-	/*
-	 * write number of events
-	 */
-	ret = do_write(fd, &nre, sizeof(nre));
-	if (ret < 0)
-		return ret;
-
-	/*
-	 * size of perf_event_attr struct
-	 */
-	sz = (u32)sizeof(attr->attr);
-	ret = do_write(fd, &sz, sizeof(sz));
-	if (ret < 0)
-		return ret;
-
-	list_for_each_entry(attr, &evlist->entries, node) {
-
-		ret = do_write(fd, &attr->attr, sz);
-		if (ret < 0)
-			return ret;
-		/*
-		 * write number of unique id per event
-		 * there is one id per instance of an event
-		 *
-		 * copy into an nri to be independent of the
-		 * type of ids,
-		 */
-		nri = attr->ids;
-		ret = do_write(fd, &nri, sizeof(nri));
-		if (ret < 0)
-			return ret;
-
-		/*
-		 * write event string as passed on cmdline
-		 */
-		ret = do_write_string(fd, perf_evsel__name(attr));
-		if (ret < 0)
-			return ret;
-		/*
-		 * write unique ids for this event
-		 */
-		ret = do_write(fd, attr->id, attr->ids * sizeof(u64));
-		if (ret < 0)
-			return ret;
-	}
 	return 0;
 }
 
@@ -1139,103 +1087,43 @@ static void print_cpu_topology(struct perf_header *ph, int fd, FILE *fp)
 	}
 }
 
-static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
+static void print_event_desc(struct perf_header *ph, int fd __used, FILE *fp)
 {
-	struct perf_event_attr attr;
-	uint64_t id;
-	void *buf = NULL;
-	char *str;
-	u32 nre, sz, nr, i, j;
-	ssize_t ret;
-	size_t msz;
-
-	/* number of events */
-	ret = read(fd, &nre, sizeof(nre));
-	if (ret != (ssize_t)sizeof(nre))
-		goto error;
-
-	if (ph->needs_swap)
-		nre = bswap_32(nre);
-
-	ret = read(fd, &sz, sizeof(sz));
-	if (ret != (ssize_t)sizeof(sz))
-		goto error;
-
-	if (ph->needs_swap)
-		sz = bswap_32(sz);
-
-	memset(&attr, 0, sizeof(attr));
-
-	/* buffer to hold on file attr struct */
-	buf = malloc(sz);
-	if (!buf)
-		goto error;
-
-	msz = sizeof(attr);
-	if (sz < msz)
-		msz = sz;
-
-	for (i = 0 ; i < nre; i++) {
-
-		/*
-		 * must read entire on-file attr struct to
-		 * sync up with layout.
-		 */
-		ret = read(fd, buf, sz);
-		if (ret != (ssize_t)sz)
-			goto error;
-
-		if (ph->needs_swap)
-			perf_event__attr_swap(buf);
+	struct perf_session *session;
+	struct perf_evsel *evsel;
+	int i;
 
-		memcpy(&attr, buf, msz);
+	session = container_of(ph, struct perf_session, header);
 
-		ret = read(fd, &nr, sizeof(nr));
-		if (ret != (ssize_t)sizeof(nr))
-			goto error;
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		struct perf_event_attr *attr = &evsel->attr;
 
-		if (ph->needs_swap)
-			nr = bswap_32(nr);
-
-		str = do_read_string(fd, ph);
-		fprintf(fp, "# event : name = %s, ", str);
-		free(str);
+		fprintf(fp, "# event : name = %s, ", perf_evsel__name(evsel));
 
 		fprintf(fp, "type = %d, config = 0x%"PRIx64
 			    ", config1 = 0x%"PRIx64", config2 = 0x%"PRIx64,
-				attr.type,
-				(u64)attr.config,
-				(u64)attr.config1,
-				(u64)attr.config2);
+				attr->type,
+				(u64)attr->config,
+				(u64)attr->config1,
+				(u64)attr->config2);
 
 		fprintf(fp, ", excl_usr = %d, excl_kern = %d",
-				attr.exclude_user,
-				attr.exclude_kernel);
+				attr->exclude_user,
+				attr->exclude_kernel);
 
-		if (nr)
+		if (evsel->ids)
 			fprintf(fp, ", id = {");
 
-		for (j = 0 ; j < nr; j++) {
-			ret = read(fd, &id, sizeof(id));
-			if (ret != (ssize_t)sizeof(id))
-				goto error;
-
-			if (ph->needs_swap)
-				id = bswap_64(id);
-
-			if (j)
+		for (i = 0 ; i < evsel->ids; i++) {
+			if (i)
 				fputc(',', fp);
 
-			fprintf(fp, " %"PRIu64, id);
+			fprintf(fp, " %"PRIu64, evsel->id[i]);
 		}
-		if (nr && j == nr)
+		if (evsel->ids && i == evsel->ids)
 			fprintf(fp, " }");
 		fputc('\n', fp);
 	}
-	free(buf);
-	return;
-error:
-	fprintf(fp, "# event desc: not available or unable to read\n");
 }
 
 static void print_total_mem(struct perf_header *h __used, int fd, FILE *fp)
-- 
1.7.9.2

