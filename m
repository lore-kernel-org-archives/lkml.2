Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475Ab2EWPcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:32:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2EWPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:32:44 -0400
Date: Wed, 23 May 2012 08:32:21 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-e1p9poez3nwrgycbmwqmhlsu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Show event attribute details
Git-Commit-ID: 26252ea675663d1bc6747125fcaa2b7cc4ed8a03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:32:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26252ea675663d1bc6747125fcaa2b7cc4ed8a03
Gitweb:     http://git.kernel.org/tip/26252ea675663d1bc6747125fcaa2b7cc4ed8a03
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 May 2012 14:30:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 14:30:11 -0300

perf evlist: Show event attribute details

There was no easy way to see the frequency used, and with the change of
default, we better provide one.

[root@sandy linux]# perf evlist -F
cycles: sample_freq=4000
[root@sandy linux]# perf evlist -v
cycles: sample_freq=4000, size: 80, sample_type: 391, read_format: 7, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_guest: 1
[root@sandy linux]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-e1p9poez3nwrgycbmwqmhlsu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-evlist.txt |    8 ++
 tools/perf/builtin-evlist.c              |  103 ++++++++++++++++++++++++++---
 2 files changed, 100 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-evlist.txt b/tools/perf/Documentation/perf-evlist.txt
index 0507ec7..1521734 100644
--- a/tools/perf/Documentation/perf-evlist.txt
+++ b/tools/perf/Documentation/perf-evlist.txt
@@ -20,6 +20,14 @@ OPTIONS
 --input=::
         Input file name. (default: perf.data unless stdin is a fifo)
 
+-F::
+--freq=::
+	Show just the sample frequency used for each event.
+
+-v::
+--verbose=::
+	Show all fields.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-list[1],
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 2676032..e52d77e 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -15,9 +15,40 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 
-static const char *input_name;
+struct perf_attr_details {
+	bool freq;
+	bool verbose;
+};
+
+static int comma_printf(bool *first, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	if (!*first) {
+		ret += printf(",");
+	} else {
+		ret += printf(":");
+		*first = false;
+	}
+
+	va_start(args, fmt);
+	ret += vprintf(fmt, args);
+	va_end(args);
+	return ret;
+}
+
+static int __if_print(bool *first, const char *field, u64 value)
+{
+	if (value == 0)
+		return 0;
+
+	return comma_printf(first, " %s: %" PRIu64, field, value);
+}
+
+#define if_print(field) __if_print(&first, #field, pos->attr.field)
 
-static int __cmd_evlist(void)
+static int __cmd_evlist(const char *input_name, struct perf_attr_details *details)
 {
 	struct perf_session *session;
 	struct perf_evsel *pos;
@@ -26,8 +57,52 @@ static int __cmd_evlist(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	list_for_each_entry(pos, &session->evlist->entries, node)
-		printf("%s\n", event_name(pos));
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		bool first = true;
+
+		printf("%s", event_name(pos));
+
+		if (details->verbose || details->freq) {
+			comma_printf(&first, " sample_freq=%" PRIu64,
+				     (u64)pos->attr.sample_freq);
+		}
+
+		if (details->verbose) {
+			if_print(type);
+			if_print(config);
+			if_print(config1);
+			if_print(config2);
+			if_print(size);
+			if_print(sample_type);
+			if_print(read_format);
+			if_print(disabled);
+			if_print(inherit);
+			if_print(pinned);
+			if_print(exclusive);
+			if_print(exclude_user);
+			if_print(exclude_kernel);
+			if_print(exclude_hv);
+			if_print(exclude_idle);
+			if_print(mmap);
+			if_print(comm);
+			if_print(freq);
+			if_print(inherit_stat);
+			if_print(enable_on_exec);
+			if_print(task);
+			if_print(watermark);
+			if_print(precise_ip);
+			if_print(mmap_data);
+			if_print(sample_id_all);
+			if_print(exclude_host);
+			if_print(exclude_guest);
+			if_print(__reserved_1);
+			if_print(wakeup_events);
+			if_print(bp_type);
+			if_print(branch_sample_type);
+		}
+
+		putchar('\n');
+	}
 
 	perf_session__delete(session);
 	return 0;
@@ -38,17 +113,23 @@ static const char * const evlist_usage[] = {
 	NULL
 };
 
-static const struct option options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_END()
-};
-
 int cmd_evlist(int argc, const char **argv, const char *prefix __used)
 {
+	struct perf_attr_details details = { .verbose = false, };
+	const char *input_name;
+	const struct option options[] = {
+		OPT_STRING('i', "input", &input_name, "file",
+			    "Input file name"),
+		OPT_BOOLEAN('F', "freq", &details.freq,
+			    "Show the sample frequency"),
+		OPT_BOOLEAN('v', "verbose", &details.verbose,
+			    "Show all event attr details"),
+		OPT_END()
+	};
+
 	argc = parse_options(argc, argv, options, evlist_usage, 0);
 	if (argc)
 		usage_with_options(evlist_usage, options);
 
-	return __cmd_evlist();
+	return __cmd_evlist(input_name, &details);
 }
