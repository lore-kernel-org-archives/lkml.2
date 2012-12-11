Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2LKWyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53836
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755206Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 32/37] perf evsel: Adopt fprintf routine from 'perf evlist'
Date: Tue, 11 Dec 2012 19:48:18 -0300
Message-Id: <1355266103-17238-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can print all the details when debugging other tools,
when we have just evlists and evsels, not a perf.data file.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mktq5fy2h5z7jyeqvvf5mbc8@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c |   81 ++-----------------------------------------
 tools/perf/util/evsel.c     |   77 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h     |    8 +++++
 3 files changed, 87 insertions(+), 79 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index c20f1dc..1312a5e 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,39 +15,6 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 
-struct perf_attr_details {
-	bool freq;
-	bool verbose;
-};
-
-static int comma_printf(bool *first, const char *fmt, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (!*first) {
-		ret += printf(",");
-	} else {
-		ret += printf(":");
-		*first = false;
-	}
-
-	va_start(args, fmt);
-	ret += vprintf(fmt, args);
-	va_end(args);
-	return ret;
-}
-
-static int __if_print(bool *first, const char *field, u64 value)
-{
-	if (value == 0)
-		return 0;
-
-	return comma_printf(first, " %s: %" PRIu64, field, value);
-}
-
-#define if_print(field) __if_print(&first, #field, pos->attr.field)
-
 static int __cmd_evlist(const char *file_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
@@ -57,52 +24,8 @@ static int __cmd_evlist(const char *file_name, struct perf_attr_details *details
 	if (session == NULL)
 		return -ENOMEM;
 
-	list_for_each_entry(pos, &session->evlist->entries, node) {
-		bool first = true;
-
-		printf("%s", perf_evsel__name(pos));
-
-		if (details->verbose || details->freq) {
-			comma_printf(&first, " sample_freq=%" PRIu64,
-				     (u64)pos->attr.sample_freq);
-		}
-
-		if (details->verbose) {
-			if_print(type);
-			if_print(config);
-			if_print(config1);
-			if_print(config2);
-			if_print(size);
-			if_print(sample_type);
-			if_print(read_format);
-			if_print(disabled);
-			if_print(inherit);
-			if_print(pinned);
-			if_print(exclusive);
-			if_print(exclude_user);
-			if_print(exclude_kernel);
-			if_print(exclude_hv);
-			if_print(exclude_idle);
-			if_print(mmap);
-			if_print(comm);
-			if_print(freq);
-			if_print(inherit_stat);
-			if_print(enable_on_exec);
-			if_print(task);
-			if_print(watermark);
-			if_print(precise_ip);
-			if_print(mmap_data);
-			if_print(sample_id_all);
-			if_print(exclude_host);
-			if_print(exclude_guest);
-			if_print(__reserved_1);
-			if_print(wakeup_events);
-			if_print(bp_type);
-			if_print(branch_sample_type);
-		}
-
-		putchar('\n');
-	}
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		perf_evsel__fprintf(pos, details, stdout);
 
 	perf_session__delete(session);
 	return 0;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2492d32..643df4b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1228,3 +1228,80 @@ u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 
 	return 0;
 }
+
+static int comma_fprintf(FILE *fp, bool *first, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (!*first) {
+		ret += fprintf(fp, ",");
+	} else {
+		ret += fprintf(fp, ":");
+		*first = false;
+	}
+
+	va_start(args, fmt);
+	ret += vfprintf(fp, fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static int __if_fprintf(FILE *fp, bool *first, const char *field, u64 value)
+{
+	if (value == 0)
+		return 0;
+
+	return comma_fprintf(fp, first, " %s: %" PRIu64, field, value);
+}
+
+#define if_print(field) printed += __if_fprintf(fp, &first, #field, evsel->attr.field)
+
+int perf_evsel__fprintf(struct perf_evsel *evsel,
+			struct perf_attr_details *details, FILE *fp)
+{
+	bool first = true;
+	int printed = fprintf(fp, "%s", perf_evsel__name(evsel));
+
+	if (details->verbose || details->freq) {
+		printed += comma_fprintf(fp, &first, " sample_freq=%" PRIu64,
+					 (u64)evsel->attr.sample_freq);
+	}
+
+	if (details->verbose) {
+		if_print(type);
+		if_print(config);
+		if_print(config1);
+		if_print(config2);
+		if_print(size);
+		if_print(sample_type);
+		if_print(read_format);
+		if_print(disabled);
+		if_print(inherit);
+		if_print(pinned);
+		if_print(exclusive);
+		if_print(exclude_user);
+		if_print(exclude_kernel);
+		if_print(exclude_hv);
+		if_print(exclude_idle);
+		if_print(mmap);
+		if_print(comm);
+		if_print(freq);
+		if_print(inherit_stat);
+		if_print(enable_on_exec);
+		if_print(task);
+		if_print(watermark);
+		if_print(precise_ip);
+		if_print(mmap_data);
+		if_print(sample_id_all);
+		if_print(exclude_host);
+		if_print(exclude_guest);
+		if_print(__reserved_1);
+		if_print(wakeup_events);
+		if_print(bp_type);
+		if_print(branch_sample_type);
+	}
+
+	fputc('\n', fp);
+	return ++printed;
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5c08977..9cb8a02 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -243,4 +243,12 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 {
 	return evsel->leader == evsel;
 }
+
+struct perf_attr_details {
+	bool freq;
+	bool verbose;
+};
+
+int perf_evsel__fprintf(struct perf_evsel *evsel,
+			struct perf_attr_details *details, FILE *fp);
 #endif /* __PERF_EVSEL_H */
-- 
1.7.9.2.358.g22243

