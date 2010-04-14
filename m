Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0DNKEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:32923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab0DNKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:04:18 -0400
Date: Wed, 14 Apr 2010 10:03:56 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-3-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-3-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf record: Introduce special handling for pipe output
Message-ID: <tip-529870e37473a9fc609078f03cc5b4148cf06a87@git.kernel.org>
Git-Commit-ID: 529870e37473a9fc609078f03cc5b4148cf06a87
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  529870e37473a9fc609078f03cc5b4148cf06a87
Gitweb:     http://git.kernel.org/tip/529870e37473a9fc609078f03cc5b4148cf06a87
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:16 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:06 +0200

perf record: Introduce special handling for pipe output

Adds special treatment for stdout - if the user specifies '-o -'
to perf record, the intent is that the event stream be written
to stdout rather than to a disk file.

Also, redirect stdout of forked child to stderr - in pipe mode,
stdout of the forked child interferes with the stdout perf
stream, so redirect it to stderr where it can still be seen but
won't be mixed in with the perf output.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-3-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d060fc5..d4464f7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,6 +35,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 static int			freq				=   1000;
 static int			output;
+static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static unsigned int		realtime_prio			=      0;
@@ -449,7 +450,9 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!stat(output_name, &st) && st.st_size) {
+	if (!strcmp(output_name, "-"))
+		pipe_output = 1;
+	else if (!stat(output_name, &st) && st.st_size) {
 		if (!force) {
 			if (!append_file) {
 				pr_err("Error, output file %s exists, use -A "
@@ -474,7 +477,10 @@ static int __cmd_record(int argc, const char **argv)
 	else
 		flags |= O_TRUNC;
 
-	output = open(output_name, flags, S_IRUSR|S_IWUSR);
+	if (pipe_output)
+		output = STDOUT_FILENO;
+	else
+		output = open(output_name, flags, S_IRUSR | S_IWUSR);
 	if (output < 0) {
 		perror("failed to create output file");
 		exit(-1);
@@ -513,6 +519,8 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (!child_pid) {
+			if (pipe_output)
+				dup2(2, 1);
 			close(child_ready_pipe[0]);
 			close(go_pipe[1]);
 			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
@@ -564,7 +572,11 @@ static int __cmd_record(int argc, const char **argv)
 			open_counters(cpumap[i]);
 	}
 
-	if (file_new) {
+	if (pipe_output) {
+		err = perf_header__write_pipe(output);
+		if (err < 0)
+			return err;
+	} else if (file_new) {
 		err = perf_header__write(&session->header, output, false);
 		if (err < 0)
 			return err;
