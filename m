Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0DBE7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 00:59:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39523 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0DBE7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mi5jb/Ty2ceOvKtk9J0ebXQqa4KE8Fzi1SUmM9pm7dd+HfOqPE3MYyhqs8/joQt20G
         uwKJO3g2ur8TFTpPfBW3iZskadlNRCnD/wfqX0y44fBfqn86EnSFbOhmy9T/TxZSxIrp
         ral5Hwq1kbNEr6DLXWP5EyFVn8/dLxUZWr/CI=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 02/11] perf record: introduce special handling for pipe output
Date: Thu,  1 Apr 2010 23:59:16 -0500
Message-Id: <1270184365-8281-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds special treatment for stdout - if the user specifies '-o -' to
perf record, the intent is that the event stream be written to stdout
rather than to a disk file.

Also, redirect stdout of forked child to stderr - in pipe mode, stdout
of the forked child interferes with the stdout perf stream, so
redirect it to stderr where it can still be seen but won't be mixed in
with the perf output.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2654b61..0723fa1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -36,6 +36,7 @@ static unsigned int		page_size;
 static unsigned int		mmap_pages			=    128;
 static int			freq				=   1000;
 static int			output;
+static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static unsigned int		realtime_prio			=      0;
@@ -450,7 +451,9 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!stat(output_name, &st) && st.st_size) {
+	if (!strcmp(output_name, "-"))
+		pipe_output = 1;
+	else if (!stat(output_name, &st) && st.st_size) {
 		if (!force) {
 			if (!append_file) {
 				pr_err("Error, output file %s exists, use -A "
@@ -475,7 +478,10 @@ static int __cmd_record(int argc, const char **argv)
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
@@ -514,6 +520,8 @@ static int __cmd_record(int argc, const char **argv)
 		}
 
 		if (!child_pid) {
+			if (pipe_output)
+				dup2(2, 1);
 			close(child_ready_pipe[0]);
 			close(go_pipe[1]);
 			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
@@ -565,7 +573,11 @@ static int __cmd_record(int argc, const char **argv)
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
-- 
1.6.4.GIT

