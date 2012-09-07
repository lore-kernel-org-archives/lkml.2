Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab2IGGBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:01:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2IGGBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:01:16 -0400
Date: Thu, 6 Sep 2012 23:00:51 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d54b1a9e0eaca92cde678d19bd82b9594ed00450@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-7-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-7-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Remove use of die/exit
Git-Commit-ID: d54b1a9e0eaca92cde678d19bd82b9594ed00450
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:00:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d54b1a9e0eaca92cde678d19bd82b9594ed00450
Gitweb:     http://git.kernel.org/tip/d54b1a9e0eaca92cde678d19bd82b9594ed00450
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:46 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:21:39 -0300

perf script: Remove use of die/exit

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
