Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0DNKEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:04:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:32952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab0DNKEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:04:52 -0400
Date: Wed, 14 Apr 2010 10:04:30 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-5-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-5-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf trace: Introduce special handling for pipe input
Message-ID: <tip-c239da3b4b55dbb8f30bcb8d1a0d63fc44a567c3@git.kernel.org>
Git-Commit-ID: c239da3b4b55dbb8f30bcb8d1a0d63fc44a567c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:04:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c239da3b4b55dbb8f30bcb8d1a0d63fc44a567c3
Gitweb:     http://git.kernel.org/tip/c239da3b4b55dbb8f30bcb8d1a0d63fc44a567c3
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:18 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:06 +0200

perf trace: Introduce special handling for pipe input

Adds special treatment for stdin - if the user specifies '-i -'
to perf trace, the intent is that the event stream be read from
stdin rather than from a disk file.

The actual handling of the '-' filename is done by the session;
this just adds a signal handler to stop reporting, and turns off
interference by the pager.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-5-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8fc50d8..c681e85 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -106,8 +106,17 @@ static struct perf_event_ops event_ops = {
 	.comm	= event__process_comm,
 };
 
+extern volatile int session_done;
+
+static void sig_handler(int sig __unused)
+{
+	session_done = 1;
+}
+
 static int __cmd_trace(struct perf_session *session)
 {
+	signal(SIGINT, sig_handler);
+
 	return perf_session__process_events(session, &event_ops);
 }
 
@@ -580,7 +589,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (!perf_session__has_traces(session, "record -R"))
+	if (strcmp(input_name, "-") &&
+	    !perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
 
 	if (generate_script_lang) {
