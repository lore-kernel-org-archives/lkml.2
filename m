Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0DNKGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:06:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:33088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab0DNKGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:06:45 -0400
Date: Wed, 14 Apr 2010 10:06:28 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-12-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-12-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf trace: Invoke live mode automatically if record/report not specified
Message-ID: <tip-a0cccc2e8e9fb16cbed3a117b30e3fbac3092ee3@git.kernel.org>
Git-Commit-ID: a0cccc2e8e9fb16cbed3a117b30e3fbac3092ee3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:06:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0cccc2e8e9fb16cbed3a117b30e3fbac3092ee3
Gitweb:     http://git.kernel.org/tip/a0cccc2e8e9fb16cbed3a117b30e3fbac3092ee3
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:25 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:09 +0200

perf trace: Invoke live mode automatically if record/report not specified

Currently, live mode is invoked by explicitly invoking the
record and report sides and connecting them with a pipe e.g.

 $ perf trace record rwtop -o - | perf trace report rwtop 5 -i -

In terms of usability, it's not that bad, but it does require
the user to type and remember more than necessary.

This patch allows the user to accomplish the same thing without
specifying the separate record/report steps or the pipe.  So the
same command as above can be accomplished more simply as:

 $ perf trace rwtop 5

Notice that the '-i -' and '-o -' aren't required in this case -
they're added internally, and that any extra arguments are
passed along to the report script (but not to the record
script).

The overall effect is that any of the scripts listed in 'perf
trace -l' can now be used directly in live mode, with the
expected arguments, by simply specifying the script and args to
'perf trace'.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-12-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1ee1e30..2eefb33 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -561,6 +561,65 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		suffix = REPORT_SUFFIX;
 	}
 
+	if (!suffix && argc >= 2 && strncmp(argv[1], "-", strlen("-")) != 0) {
+		char *record_script_path, *report_script_path;
+		int live_pipe[2];
+		pid_t pid;
+
+		record_script_path = get_script_path(argv[1], RECORD_SUFFIX);
+		if (!record_script_path) {
+			fprintf(stderr, "record script not found\n");
+			return -1;
+		}
+
+		report_script_path = get_script_path(argv[1], REPORT_SUFFIX);
+		if (!report_script_path) {
+			fprintf(stderr, "report script not found\n");
+			return -1;
+		}
+
+		if (pipe(live_pipe) < 0) {
+			perror("failed to create pipe");
+			exit(-1);
+		}
+
+		pid = fork();
+		if (pid < 0) {
+			perror("failed to fork");
+			exit(-1);
+		}
+
+		if (!pid) {
+			dup2(live_pipe[1], 1);
+			close(live_pipe[0]);
+
+			__argv = malloc(5 * sizeof(const char *));
+			__argv[0] = "/bin/sh";
+			__argv[1] = record_script_path;
+			__argv[2] = "-o";
+			__argv[3] = "-";
+			__argv[4] = NULL;
+
+			execvp("/bin/sh", (char **)__argv);
+			exit(-1);
+		}
+
+		dup2(live_pipe[0], 0);
+		close(live_pipe[1]);
+
+		__argv = malloc((argc + 3) * sizeof(const char *));
+		__argv[0] = "/bin/sh";
+		__argv[1] = report_script_path;
+		for (i = 2; i < argc; i++)
+			__argv[i] = argv[i];
+		__argv[i++] = "-i";
+		__argv[i++] = "-";
+		__argv[i++] = NULL;
+
+		execvp("/bin/sh", (char **)__argv);
+		exit(-1);
+	}
+
 	if (suffix) {
 		script_path = get_script_path(argv[2], suffix);
 		if (!script_path) {
