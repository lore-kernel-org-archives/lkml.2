Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab2I0FqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:46:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54287 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab2I0FqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:46:11 -0400
Date: Wed, 26 Sep 2012 22:45:48 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6du8dl1hz0y5l4cybodye7hn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Provide a new constructor for tracepoints
Git-Commit-ID: efd2b924d3af0efd360cb5b7f29ddc9bc74fce4b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:45:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efd2b924d3af0efd360cb5b7f29ddc9bc74fce4b
Gitweb:     http://git.kernel.org/tip/efd2b924d3af0efd360cb5b7f29ddc9bc74fce4b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Sep 2012 11:21:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:26:59 -0300

perf evsel: Provide a new constructor for tracepoints

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
