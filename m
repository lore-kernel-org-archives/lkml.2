Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0DNKEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:04:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:32932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab0DNKEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:04:36 -0400
Date: Wed, 14 Apr 2010 10:04:13 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf report: Introduce special handling for pipe input
Message-ID: <tip-46656ac7fb3252f8a3db29b18638e0e8067849ba@git.kernel.org>
Git-Commit-ID: 46656ac7fb3252f8a3db29b18638e0e8067849ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:04:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46656ac7fb3252f8a3db29b18638e0e8067849ba
Gitweb:     http://git.kernel.org/tip/46656ac7fb3252f8a3db29b18638e0e8067849ba
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:17 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:06 +0200

perf report: Introduce special handling for pipe input

Adds special treatment for stdin - if the user specifies '-i -'
to perf report, the intent is that the event stream be written
to stdin rather than from a disk file.

The actual handling of the '-' filename is done by the session;
this just adds a signal handler to stop reporting, and turns off
interference by the pager.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index daee082..00b358f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -269,6 +269,13 @@ static struct perf_event_ops event_ops = {
 	.read	= process_read_event,
 };
 
+extern volatile int session_done;
+
+static void sig_handler(int sig __attribute__((__unused__)))
+{
+	session_done = 1;
+}
+
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
@@ -276,6 +283,8 @@ static int __cmd_report(void)
 	struct rb_node *next;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
+	signal(SIGINT, sig_handler);
+
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
@@ -465,7 +474,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	setup_browser();
+	if (strcmp(input_name, "-") != 0)
+		setup_browser();
 
 	if (symbol__init() < 0)
 		return -1;
