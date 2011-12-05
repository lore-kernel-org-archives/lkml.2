Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1LEMr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:47:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab1LEMr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:47:27 -0500
Date: Mon, 5 Dec 2011 04:46:14 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0ylj4wrg54791u0baqb9swbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Introduce add_tracepoints method
Git-Commit-ID: a8c9ae18d810e1ae12b6ec960907e9af63171d3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:46:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8c9ae18d810e1ae12b6ec960907e9af63171d3a
Gitweb:     http://git.kernel.org/tip/a8c9ae18d810e1ae12b6ec960907e9af63171d3a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 5 Nov 2011 08:41:51 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:25:11 -0200

perf evlist: Introduce add_tracepoints method

Convenient way of asking for tracepoint events to be added to an
existing evlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0ylj4wrg54791u0baqb9swbb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   57 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.h |    5 ++++
 tools/perf/util/setup.py |    3 +-
 3 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 58aa1e0..3bc5a28 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -6,12 +6,13 @@
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
+#include "util.h"
+#include "debugfs.h"
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
 
 #include "parse-events.h"
 
@@ -134,6 +135,60 @@ out_delete_partial_list:
 	return -1;
 }
 
+static int trace_event__id(const char *evname)
+{
+	char *filename, *colon;
+	int err = -1, fd;
+
+	if (asprintf(&filename, "%s/%s/id", tracing_events_path, evname) < 0)
+		return -1;
+
+	colon = strrchr(filename, ':');
+	if (colon != NULL)
+		*colon = '/';
+
+	fd = open(filename, O_RDONLY);
+	if (fd >= 0) {
+		char id[16];
+		if (read(fd, id, sizeof(id)) > 0)
+			err = atoi(id);
+		close(fd);
+	}
+
+	free(filename);
+	return err;
+}
+
+int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
+				 const char *tracepoints[],
+				 size_t nr_tracepoints)
+{
+	int err;
+	size_t i;
+	struct perf_event_attr *attrs = zalloc(nr_tracepoints * sizeof(*attrs));
+
+	if (attrs == NULL)
+		return -1;
+
+	for (i = 0; i < nr_tracepoints; i++) {
+		err = trace_event__id(tracepoints[i]);
+
+		if (err < 0)
+			goto out_free_attrs;
+
+		attrs[i].type	       = PERF_TYPE_TRACEPOINT;
+		attrs[i].config	       = err;
+	        attrs[i].sample_type   = (PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
+					  PERF_SAMPLE_CPU);
+		attrs[i].sample_period = 1;
+	}
+
+	err = perf_evlist__add_attrs(evlist, attrs, nr_tracepoints);
+out_free_attrs:
+	free(attrs);
+	return err;
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 57d91ff..ec71c82 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -43,10 +43,15 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int perf_evlist__add_attrs(struct perf_evlist *evlist,
 			   struct perf_event_attr *attrs, size_t nr_attrs);
+int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
+				 const char *tracepoints[], size_t nr_tracepoints);
 
 #define perf_evlist__add_attrs_array(evlist, array) \
 	perf_evlist__add_attrs(evlist, array, ARRAY_SIZE(array))
 
+#define perf_evlist__add_tracepoints_array(evlist, array) \
+	perf_evlist__add_tracepoints(evlist, array, ARRAY_SIZE(array))
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 95d3700..36d4c56 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -27,7 +27,8 @@ build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
-			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
+			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
+			     'util/debugfs.c'],
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
                  )
