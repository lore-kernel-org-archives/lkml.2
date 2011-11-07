Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1KGMyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:54:22 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29235 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab1KGMyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:54:18 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 5/7] perf: teach "perf inject" to work with files
Date: Mon,  7 Nov 2011 15:54:15 +0300
Message-Id: <1320670457-2633428-6-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch "perf inject" can only handle data from pipe.

I want to use "perf inject" for reworking events. Look at my following patch.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/builtin-inject.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8dfc12b..8df8b71 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -13,7 +13,12 @@
 
 #include "util/parse-options.h"
 
-static char		const *input_name = "-";
+static char		const *input_name	= "-";
+static const char	*output_name		= "-";
+static int		pipe_output		= 0;
+static int		output;
+static u64		bytes_written		= 0;
+
 static bool		inject_build_ids;
 
 static int perf_event__repipe_synth(union perf_event *event,
@@ -25,12 +30,14 @@ static int perf_event__repipe_synth(union perf_event *event,
 	size = event->header.size;
 
 	while (size) {
-		int ret = write(STDOUT_FILENO, buf, size);
+		int ret = write(output, buf, size);
 		if (ret < 0)
 			return -errno;
 
 		size -= ret;
 		buf += ret;
+
+		bytes_written += ret;
 	}
 
 	return 0;
@@ -213,8 +220,14 @@ static int __cmd_inject(void)
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (!pipe_output)
+		lseek(output, session->header.data_offset, SEEK_SET);
 	ret = perf_session__process_events(session, &inject_ops);
 
+	if (!pipe_output) {
+		session->header.data_size += bytes_written;
+		perf_session__write_header(session, session->evlist, output, true);
+	}
 	perf_session__delete(session);
 
 	return ret;
@@ -228,6 +241,10 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
 		    "Inject build-ids into the output stream"),
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose (show build ids, etc)"),
 	OPT_END()
@@ -243,6 +260,18 @@ int cmd_inject(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(report_usage, options);
 
+	if (!strcmp(output_name, "-")) {
+		pipe_output = 1;
+		output = STDOUT_FILENO;
+	} else {
+		output = open(output_name, O_CREAT| O_WRONLY | O_TRUNC,
+							S_IRUSR | S_IWUSR);
+		if (output < 0) {
+			perror("failed to create output file");
+			exit(-1);
+		}
+	}
+
 	if (symbol__init() < 0)
 		return -1;
 
-- 
1.7.1

