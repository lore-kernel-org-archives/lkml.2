Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2H0Qzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2H0Qza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:55:30 -0400
Date: Mon, 27 Aug 2012 09:55:12 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-4e1b9c679fcb208275b55eb8fc46c2d58ef6a2ee@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-7-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-7-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Refactor print_event_desc()
Git-Commit-ID: 4e1b9c679fcb208275b55eb8fc46c2d58ef6a2ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:55:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e1b9c679fcb208275b55eb8fc46c2d58ef6a2ee
Gitweb:     http://git.kernel.org/tip/4e1b9c679fcb208275b55eb8fc46c2d58ef6a2ee
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:22 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 13:45:59 -0300

perf tools: Refactor print_event_desc()

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
