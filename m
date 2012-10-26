Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab2JZPJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:09:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:09:41 -0400
Date: Fri, 26 Oct 2012 08:09:23 -0700
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-e558a5bd8b74aff4690a8c55b08a1dc91ef50d7c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, avagin@openvz.org, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org
In-Reply-To: <1344344165-369636-2-git-send-email-avagin@openvz.org>
References: <1344344165-369636-2-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf inject: Work with files
Git-Commit-ID: e558a5bd8b74aff4690a8c55b08a1dc91ef50d7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:09:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e558a5bd8b74aff4690a8c55b08a1dc91ef50d7c
Gitweb:     http://git.kernel.org/tip/e558a5bd8b74aff4690a8c55b08a1dc91ef50d7c
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Tue, 7 Aug 2012 16:56:02 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:24 -0200

perf inject: Work with files

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
 tools/perf/Documentation/perf-inject.txt |    6 ++++
 tools/perf/builtin-inject.c              |   38 +++++++++++++++++++++++++++--
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
 
