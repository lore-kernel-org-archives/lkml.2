Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab1CXLbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 07:31:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56028 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1CXLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 07:31:34 -0400
X-AuditID: b753bd60-9d955ba000007e19-4d-4d8b2b94e22e
X-AuditID: b753bd60-9d955ba000007e19-4d-4d8b2b94e22e
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v3 2/6] perf branch: Introduce new sub command 'perf
 branch trace'
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 24 Mar 2011 20:32:03 +0900
Message-ID: <20110324113203.20235.64866.stgit@localhost6.localdomain6>
In-Reply-To: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
References: <20110324113137.20235.42265.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new sub command 'perf branch trace'.
This command parses and prints the bts log recorded by
'perf branch record'.

Usage:
 - First, record the bts log 'perf branch record <command>'
 - Second, parse and print bts log 'perf branch trace'

Output:
0xffffffff8146fe0e => 0x0000003806200b20
0x0000003806200b23 => 0x0000003806204910
0xffffffff8146fe0e => 0x0000003806204910
0xffffffff8146fe0e => 0x0000003806204936
0xffffffff8146fe0e => 0x000000380620493d
0x0000003806204981 => 0x00000038062049a3
0x00000038062049a7 => 0x0000003806204988
...

Changes in V3:
 - Update to the latest -tip tree
 - Rename to 'perf branch'
 - Process only BTS record
 - Fix return value of __cmd_trace

Changes in V2:
 - Update to the latest -tip tree

Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
---

 tools/perf/Documentation/perf-branch.txt |   14 ++++-
 tools/perf/builtin-branch.c              |   81 +++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index 075cfce..e223267 100644
--- a/tools/perf/Documentation/perf-branch.txt
+++ b/tools/perf/Documentation/perf-branch.txt
@@ -3,16 +3,16 @@ perf-branch(1)
 
 NAME
 ----
-perf-branch - Record branch-trace-store log
+perf-branch - Record and print branch-trace-store log
 
 SYNOPSIS
 --------
 [verse]
-'perf branch' record <command>
+'perf branch' [<options>] {record|trace}
 
 DESCRIPTION
 -----------
-This command records a branch-trace-store log.
+This command records and prints a branch-trace-store log.
 Branch-trace-store is a facility of processors. It can record
 addresses of from/to which the execution of a program branches,
 at every branch instruction and interrupt.
@@ -20,6 +20,14 @@ at every branch instruction and interrupt.
 'perf branch record <command>' records branch-trace-store log while
 the specified command is executing. And, save to the file "perf.data".
 
+'perf branch trace' parses recorded branch-trace-store log and prints it.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Specify input file name to analyze.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index f338f3a..7dbabf4 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -1,10 +1,28 @@
 #include "builtin.h"
 #include "perf.h"
 #include "util/parse-options.h"
+#include "util/session.h"
+#include "util/cache.h"
+#include "util/trace-event.h"
+#include "util/evlist.h"
+#include "util/evsel.h"
+#include <inttypes.h>
+
+/* format string of specifying min width to print address */
+#if __WORDSIZE == 32
+#define FMT_ADDR_WIDTH	"10"		/* length of "0x" + 32bit address */
+#else
+#define FMT_ADDR_WIDTH	"18"		/* length of "0x" + 64bit address */
+#endif
+/* format string to print address */
+#define FMT_ADDR	"%#0" FMT_ADDR_WIDTH "lx"
+
+/* default input file name to analyze */
+static const char *input_name = "perf.data";
 
 static const char * const branch_usage[] = {
-	"perf branch record <command>",
-	NULL,
+	"perf branch [<options>] {record|trace}",
+	NULL
 };
 
 /* arguments to call 'perf record' */
@@ -16,11 +34,66 @@ static const char * const record_args[] = {
 	"-d",
 };
 
-/* dummy struct option to call parse_options() */
 static const struct option branch_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_END()
 };
 
+static bool is_bts_event(struct perf_evsel *evsel)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
+	return (attr->config & PERF_COUNT_HW_BRANCH_INSTRUCTIONS &&
+		attr->type == PERF_TYPE_HARDWARE &&
+		attr->sample_period == 1);
+}
+
+static bool is_bts_sample(struct perf_sample *sample,
+						struct perf_session *session)
+{
+	struct perf_evsel *evsel;
+
+	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+	if (!evsel)
+		return false;
+
+	return is_bts_event(evsel);
+}
+
+static int process_sample_event(union perf_event *event __unused,
+		struct perf_sample *sample, struct perf_session *session)
+{
+	if (!is_bts_sample(sample, session))
+		return 0;
+
+	/* sample->ip is 'from address', sample->addr is 'to address' */
+	printf(FMT_ADDR " => " FMT_ADDR "\n", sample->ip, sample->addr);
+
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.sample			= process_sample_event,
+	.ordered_samples	= false,
+};
+
+static int __cmd_trace(void)
+{
+	struct perf_session *session;
+
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &event_ops);
+	if (!session) {
+		fprintf(stderr, "failed to create perf_session.\n");
+		return EXIT_FAILURE;
+	}
+
+	setup_pager();
+	perf_session__process_events(session, &event_ops);
+	perf_session__delete(session);
+
+	return EXIT_SUCCESS;
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
@@ -55,6 +128,8 @@ int cmd_branch(int argc, const char **argv, const char *prefix __used)
 
 	if (!strcmp(argv[0], "record"))
 		return __cmd_record(argc, argv);
+	else if (!strcmp(argv[0], "trace"))
+		return __cmd_trace();
 	else
 		usage_with_options(branch_usage, branch_options);
 

