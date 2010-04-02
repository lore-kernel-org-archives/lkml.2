Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0DBFAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:00:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0DBE7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fwrq+JJ+Y2WnEwqCe0kaHJd302lMGasUW+ro8szhYetPQlxQwofUNX3dFoBvB7VEbc
         rpx3x2iqjpB3iY804PtB2ZpuQ+n+8Dk/hfKuokso4BWDU0O/YjCkfVefTXpiQ+4ORVkR
         3JxAWurWxG1mBVZC8hG1dK1E/wFR23YzDxvbI=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 11/11] perf trace: invoke live mode automatically if record/report not specified
Date: Thu,  1 Apr 2010 23:59:25 -0500
Message-Id: <1270184365-8281-12-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, live mode is invoked by explicitly invoking the record and
report sides and connecting them with a pipe e.g.

$ perf trace record rwtop -o - | perf trace report rwtop 5 -i -

In terms of usability, it's not that bad, but it does require the user
to type and remember more than necessary.

This patch allows the user to accomplish the same thing without
specifying the separate record/report steps or the pipe.  So the same
command as above can be accomplished more simply as:

$ perf trace rwtop 5

Notice that the '-i -' and '-o -' aren't required in this case -
they're added internally, and that any extra arguments are passed
along to the report script (but not to the record script).

The overall effect is that any of the scripts listed in 'perf trace
-l' can now be used directly in live mode, with the expected
arguments, by simply specifying the script and args to 'perf trace'.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |   59 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4a6ffb2..1e6ad0c 100644
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
-- 
1.6.4.GIT

