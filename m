Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2IXQEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:04:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:41455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2IXQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 28/30] perf evsel: Provide a new constructor for tracepoints
Date: Mon, 24 Sep 2012 12:59:42 -0300
Message-Id: <1348502384-14442-29-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The existing constructor receives a perf_event_attr filled with the
event type and the config.

To reduce the boilerplate for tracepoints, provide a new constructor,
perf_evsel__newtp() that receives the tracepoint name and will open
the debugfs file, call into libtraceevent new pevent_parse_format file
to fill its ->tp_format member, so that users can then just call
perf_evsel__field() to access its fields.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-6du8dl1hz0y5l4cybodye7hn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   88 +++++++++++++++++++++++++++++++++++++++++++---
 tools/perf/util/evsel.h |    5 +++
 2 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1506ba0..00936ad 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -10,6 +10,7 @@
 #include <byteswap.h>
 #include <linux/bitops.h>
 #include "asm/bug.h"
+#include "debugfs.h"
 #include "event-parse.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -69,6 +70,72 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
+static struct event_format *event_format__new(const char *sys, const char *name)
+{
+	int fd, n;
+	char *filename;
+	void *bf = NULL, *nbf;
+	size_t size = 0, alloc_size = 0;
+	struct event_format *format = NULL;
+
+	if (asprintf(&filename, "%s/%s/%s/format", tracing_events_path, sys, name) < 0)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out_free_filename;
+
+	do {
+		if (size == alloc_size) {
+			alloc_size += BUFSIZ;
+			nbf = realloc(bf, alloc_size);
+			if (nbf == NULL)
+				goto out_free_bf;
+			bf = nbf;
+		}
+
+		n = read(fd, bf + size, BUFSIZ);
+		if (n < 0)
+			goto out_free_bf;
+		size += n;
+	} while (n > 0);
+
+	pevent_parse_format(&format, bf, size, sys);
+
+out_free_bf:
+	free(bf);
+	close(fd);
+out_free_filename:
+	free(filename);
+out:
+	return format;
+}
+
+struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx)
+{
+	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+
+	if (evsel != NULL) {
+		struct perf_event_attr attr = {
+			.type = PERF_TYPE_TRACEPOINT,
+		};
+
+		evsel->tp_format = event_format__new(sys, name);
+		if (evsel->tp_format == NULL)
+			goto out_free;
+
+		attr.config = evsel->tp_format->id;
+		perf_evsel__init(evsel, &attr, idx);
+		evsel->name = evsel->tp_format->name;
+	}
+
+	return evsel;
+
+out_free:
+	free(evsel);
+	return NULL;
+}
+
 const char *perf_evsel__hw_names[PERF_COUNT_HW_MAX] = {
 	"cycles",
 	"instructions",
@@ -495,6 +562,10 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
 	free(evsel->group_name);
+	if (evsel->tp_format && evsel->name == evsel->tp_format->name) {
+		evsel->name = NULL;
+		pevent_free_format(evsel->tp_format);
+	}
 	free(evsel->name);
 	free(evsel);
 }
@@ -1002,14 +1073,19 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	return 0;
 }
 
+struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name)
+{
+	return pevent_find_field(evsel->tp_format, name);
+}
+
 char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
 			 const char *name)
 {
-	struct format_field *field = pevent_find_field(evsel->tp_format, name);
+	struct format_field *field = perf_evsel__field(evsel, name);
 	int offset;
 
-        if (!field)
-                return NULL;
+	if (!field)
+		return NULL;
 
 	offset = field->offset;
 
@@ -1024,11 +1100,11 @@ char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
 u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 		       const char *name)
 {
-	struct format_field *field = pevent_find_field(evsel->tp_format, name);
+	struct format_field *field = perf_evsel__field(evsel, name);
 	u64 val;
 
-        if (!field)
-                return 0;
+	if (!field)
+		return 0;
 
 	val = pevent_read_number(evsel->tp_format->pevent,
 				 sample->raw_data + field->offset, field->size);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 93876ba..bb445d1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -81,6 +81,7 @@ struct perf_evlist;
 struct perf_record_opts;
 
 struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
+struct perf_evsel *perf_evsel__newtp(const char *sys, const char *name, int idx);
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx);
 void perf_evsel__exit(struct perf_evsel *evsel);
@@ -128,6 +129,10 @@ char *perf_evsel__strval(struct perf_evsel *evsel, struct perf_sample *sample,
 u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 		       const char *name);
 
+struct format_field;
+
+struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name);
+
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
 	 evsel->attr.config == PERF_COUNT_##c)
-- 
1.7.1

