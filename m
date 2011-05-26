Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1EZFES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:04:18 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:51301 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1EZFEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:04:15 -0400
X-AuditID: b753bd60-a46c9ba000003bac-fa-4ddddec99a6f
X-AuditID: b753bd60-a46c9ba000003bac-fa-4ddddec99a6f
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Subject: [PATCH -tip v4 2/7] perf branch: Introduce new sub command 'perf
 branch trace'
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        pp-manager@sdl.hitachi.co.jp,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Thu, 26 May 2011 14:03:09 +0900
Message-ID: <20110526050309.30011.50228.stgit@localhost6.localdomain6>
In-Reply-To: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
References: <20110526050246.30011.86048.stgit@localhost6.localdomain6>
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

Changes in V4:
 - Update to the latest -tip tree
 - Add output TSV mode

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

 tools/perf/Documentation/perf-branch.txt |   17 +++++-
 tools/perf/builtin-branch.c              |   92 +++++++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-branch.txt b/tools/perf/Documentation/perf-branch.txt
index 075cfce..15ee496 100644
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
@@ -20,6 +20,17 @@ at every branch instruction and interrupt.
 'perf branch record <command>' records branch-trace-store log while
 the specified command is executing. And, save to the file "perf.data".
 
+'perf branch trace' parses recorded branch-trace-store log and prints it.
+
+OPTIONS
+-------
+-i::
+--input=::
+        Specify input file name to analyze.
+-t::
+--tsv::
+	Output TSV format.
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-branch.c b/tools/perf/builtin-branch.c
index f338f3a..5b0297e 100644
--- a/tools/perf/builtin-branch.c
+++ b/tools/perf/builtin-branch.c
@@ -1,10 +1,33 @@
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
+static const char *input_name		= "perf.data";
+
+/* output tsv mode */
+static bool output_tsv;
+#define output_item_addr(addr)		printf(output_tsv ? FMT_ADDR "\t" : \
+							    FMT_ADDR " ", addr)
 
 static const char * const branch_usage[] = {
-	"perf branch record <command>",
-	NULL,
+	"perf branch [<options>] {record|trace}",
+	NULL
 };
 
 /* arguments to call 'perf record' */
@@ -16,11 +39,72 @@ static const char * const record_args[] = {
 	"-d",
 };
 
-/* dummy struct option to call parse_options() */
 static const struct option branch_options[] = {
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_BOOLEAN('t', "tsv", &output_tsv, "output tsv format"),
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
+		struct perf_sample *sample, struct perf_evsel *evsel __unused,
+		struct perf_session *session)
+{
+	if (!is_bts_sample(sample, session))
+		return 0;
+
+	/* sample->ip is 'from address', sample->addr is 'to address' */
+	output_item_addr(sample->ip);
+	if (!output_tsv)
+		printf("=> ");
+	output_item_addr(sample->addr);
+	printf("\n");
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
@@ -55,6 +139,8 @@ int cmd_branch(int argc, const char **argv, const char *prefix __used)
 
 	if (!strcmp(argv[0], "record"))
 		return __cmd_record(argc, argv);
+	else if (!strcmp(argv[0], "trace"))
+		return __cmd_trace();
 	else
 		usage_with_options(branch_usage, branch_options);
 

