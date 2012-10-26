Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2JZOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:34:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2JZOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf inject: Work with files
Date: Fri, 26 Oct 2012 12:31:50 -0200
Message-Id: <1351261913-28250-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Vagin <avagin@openvz.org>

Before this patch "perf inject" can only handle data from pipe.

I want to use "perf inject" for reworking events. Look at my following patch.

v2: add information about new options in tools/perf/Documentation/

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344344165-369636-2-git-send-email-avagin@openvz.org
[ committer note: fixed it up to cope with 5852a44, 5ded57a, 002439e & f62d3f0 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-inject.txt |    6 +++++
 tools/perf/builtin-inject.c              |   38 +++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index 025630d..673ef97 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -29,6 +29,12 @@ OPTIONS
 -v::
 --verbose::
 	Be more verbose.
+-i::
+--input=::
+	Input file name. (default: stdin)
+-o::
+--output=::
+	Output file name. (default: stdout)
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 386a5c0..a706ed5 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -17,24 +17,30 @@
 struct perf_inject {
 	struct perf_tool tool;
 	bool		 build_ids;
+	const char	 *input_name;
+	int		 pipe_output,
+			 output;
+	u64		 bytes_written;
 };
 
-static int perf_event__repipe_synth(struct perf_tool *tool __maybe_unused,
+static int perf_event__repipe_synth(struct perf_tool *tool,
 				    union perf_event *event,
 				    struct machine *machine __maybe_unused)
 {
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
 	uint32_t size;
 	void *buf = event;
 
 	size = event->header.size;
 
 	while (size) {
-		int ret = write(STDOUT_FILENO, buf, size);
+		int ret = write(inject->output, buf, size);
 		if (ret < 0)
 			return -errno;
 
 		size -= ret;
 		buf += ret;
+		inject->bytes_written += ret;
 	}
 
 	return 0;
@@ -231,12 +237,20 @@ static int __cmd_inject(struct perf_inject *inject)
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
-	session = perf_session__new("-", O_RDONLY, false, true, &inject->tool);
+	session = perf_session__new(inject->input_name, O_RDONLY, false, true, &inject->tool);
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!inject->pipe_output)
+		lseek(inject->output, session->header.data_offset, SEEK_SET);
+
 	ret = perf_session__process_events(session, &inject->tool);
 
+	if (!inject->pipe_output) {
+		session->header.data_size = inject->bytes_written;
+		perf_session__write_header(session, session->evlist, inject->output, true);
+	}
+
 	perf_session__delete(session);
 
 	return ret;
@@ -260,10 +274,16 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.tracing_data	= perf_event__repipe_tracing_data_synth,
 			.build_id	= perf_event__repipe_op2_synth,
 		},
+		.input_name  = "-",
 	};
+	const char *output_name = "-";
 	const struct option options[] = {
 		OPT_BOOLEAN('b', "build-ids", &inject.build_ids,
 			    "Inject build-ids into the output stream"),
+		OPT_STRING('i', "input", &inject.input_name, "file",
+			   "input file name"),
+		OPT_STRING('o', "output", &output_name, "file",
+			   "output file name"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
 		OPT_END()
@@ -281,6 +301,18 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(inject_usage, options);
 
+	if (!strcmp(output_name, "-")) {
+		inject.pipe_output = 1;
+		inject.output = STDOUT_FILENO;
+	} else {
+		inject.output = open(output_name, O_CREAT | O_WRONLY | O_TRUNC,
+						  S_IRUSR | S_IWUSR);
+		if (inject.output < 0) {
+			perror("failed to create output file");
+			return -1;
+		}
+	}
+
 	if (symbol__init() < 0)
 		return -1;
 
-- 
1.7.9.2.358.g22243

