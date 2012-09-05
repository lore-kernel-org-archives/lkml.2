Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab2IEXJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:34305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab2IEXJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/17] perf script: Remove use of die/exit
Date: Wed,  5 Sep 2012 20:08:47 -0300
Message-Id: <1346886537-11621-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows perf to clean up properly on exit. Only exits left are exec
failures which are appropriate and usage callbacks that list available
options.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-7-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   60 +++++++++++++++++++++++++++++-------------
 1 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2d6e3b2..c350cfe 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1153,18 +1153,23 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-static bool have_cmd(int argc, const char **argv)
+static int have_cmd(int argc, const char **argv)
 {
 	char **__argv = malloc(sizeof(const char *) * argc);
 
-	if (!__argv)
-		die("malloc");
+	if (!__argv) {
+		pr_err("malloc failed\n");
+		return -1;
+	}
+
 	memcpy(__argv, argv, sizeof(const char *) * argc);
 	argc = parse_options(argc, (const char **)__argv, record_options,
 			     NULL, PARSE_OPT_STOP_AT_NON_OPTION);
 	free(__argv);
 
-	return argc != 0;
+	system_wide = (argc == 0);
+
+	return 0;
 }
 
 int cmd_script(int argc, const char **argv, const char *prefix __used)
@@ -1231,13 +1236,13 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 		if (pipe(live_pipe) < 0) {
 			perror("failed to create pipe");
-			exit(-1);
+			return -1;
 		}
 
 		pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
-			exit(-1);
+			return -1;
 		}
 
 		if (!pid) {
@@ -1249,13 +1254,18 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 			if (is_top_script(argv[0])) {
 				system_wide = true;
 			} else if (!system_wide) {
-				system_wide = !have_cmd(argc - rep_args,
-							&argv[rep_args]);
+				if (have_cmd(argc - rep_args, &argv[rep_args]) != 0) {
+					err = -1;
+					goto out;
+				}
 			}
 
 			__argv = malloc((argc + 6) * sizeof(const char *));
-			if (!__argv)
-				die("malloc");
+			if (!__argv) {
+				pr_err("malloc failed\n");
+				err = -ENOMEM;
+				goto out;
+			}
 
 			__argv[j++] = "/bin/sh";
 			__argv[j++] = rec_script_path;
@@ -1277,8 +1287,12 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		close(live_pipe[1]);
 
 		__argv = malloc((argc + 4) * sizeof(const char *));
-		if (!__argv)
-			die("malloc");
+		if (!__argv) {
+			pr_err("malloc failed\n");
+			err = -ENOMEM;
+			goto out;
+		}
+
 		j = 0;
 		__argv[j++] = "/bin/sh";
 		__argv[j++] = rep_script_path;
@@ -1303,12 +1317,20 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 		if (!rec_script_path)
 			system_wide = false;
-		else if (!system_wide)
-			system_wide = !have_cmd(argc - 1, &argv[1]);
+		else if (!system_wide) {
+			if (have_cmd(argc - 1, &argv[1]) != 0) {
+				err = -1;
+				goto out;
+			}
+		}
 
 		__argv = malloc((argc + 2) * sizeof(const char *));
-		if (!__argv)
-			die("malloc");
+		if (!__argv) {
+			pr_err("malloc failed\n");
+			err = -ENOMEM;
+			goto out;
+		}
+
 		__argv[j++] = "/bin/sh";
 		__argv[j++] = script_path;
 		if (system_wide)
@@ -1357,18 +1379,18 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		input = open(session->filename, O_RDONLY);	/* input_name */
 		if (input < 0) {
 			perror("failed to open file");
-			exit(-1);
+			return -1;
 		}
 
 		err = fstat(input, &perf_stat);
 		if (err < 0) {
 			perror("failed to stat file");
-			exit(-1);
+			return -1;
 		}
 
 		if (!perf_stat.st_size) {
 			fprintf(stderr, "zero-sized file, nothing to do!\n");
-			exit(0);
+			return 0;
 		}
 
 		scripting_ops = script_spec__lookup(generate_script_lang);
-- 
1.7.1

