Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab0DBFGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:06:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40846 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0DBFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kW9d6xVhCRKMiIBe5D/+xxOOhF+lKQoKfTixj6KVmV+Lq5KPXB42nyWnZfKMZ+F8cU
         4Irjr6v80wf10zlGRaId9kqaTbB1qhzA6JFhz42iRiyb5jkdBSprZFo6AuBbGc/oTTdc
         ybXyuUpFn9pg29y9GOvRaoXgI/i0wJY+uhunU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 03/11] perf report: introduce special handling for pipe input
Date: Thu,  1 Apr 2010 23:59:17 -0500
Message-Id: <1270184365-8281-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds special treatment for stdin - if the user specifies '-i -' to
perf report, the intent is that the event stream be written to stdin
rather than from a disk file.

The actual handling of the '-' filename is done by the session; this
just adds a signal handler to stop reporting, and turns off
interference by the pager.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-report.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6ab1698..a104121 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -267,6 +267,13 @@ static struct perf_event_ops event_ops = {
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
@@ -274,6 +281,8 @@ static int __cmd_report(void)
 	struct rb_node *next;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 
+	signal(SIGINT, sig_handler);
+
 	session = perf_session__new(input_name, O_RDONLY, force);
 	if (session == NULL)
 		return -ENOMEM;
@@ -461,7 +470,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
-	setup_browser();
+	if (strcmp(input_name, "-") != 0)
+		setup_browser();
 
 	if (symbol__init() < 0)
 		return -1;
-- 
1.6.4.GIT

