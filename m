Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0DBFFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:05:10 -0400
Received: from mail-yx0-f195.google.com ([209.85.210.195]:57519 "EHLO
	mail-yx0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab0DBFFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:05:01 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 01:05:01 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BeMdkZqsZgtBCwk0PBYatvMJ8ez/wX2dTSK8MQ+WbzIbmQTMwyfaPYPeFMIUrEsNSy
         EWqxIN9S+/lnn4TiD9HhaBTDRjf0Nhn5tHAlRTvpSmE+WZyjoNVg99jOpQu2dIPTSAwt
         o0doC/9gJWywaFEFhEHYd9MwDvBInDGVMqU6M=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 04/11] perf trace: introduce special handling for pipe input
Date: Thu,  1 Apr 2010 23:59:18 -0500
Message-Id: <1270184365-8281-5-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds special treatment for stdin - if the user specifies '-i -' to
perf trace, the intent is that the event stream be read from stdin
rather than from a disk file.

The actual handling of the '-' filename is done by the session; this
just adds a signal handler to stop reporting, and turns off
interference by the pager.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 407041d..718fddd 100644
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
-- 
1.6.4.GIT

