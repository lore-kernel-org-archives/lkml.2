Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1AYR0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:26:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:46998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1AYRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 26/29] perf tools: Pass the struct opt to the wildcard parsing routine
Date: Tue, 25 Jan 2011 15:21:49 -0200
Message-Id: <1295976112-2796-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It is needed because it will call parse_event for each tracepoint
name that matches, and we pass the perf_evlist via opt->value.

Problem introduced in 4503fdd where my assumption about opt being
always non NULL made me not look at callers of parse_events outside
builtin-*.c.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d3086ce..cf082da 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -446,8 +446,8 @@ parse_single_tracepoint_event(char *sys_name,
 /* sys + ':' + event + ':' + flags*/
 #define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
 static enum event_result
-parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
-				char *flags)
+parse_multiple_tracepoint_event(const struct option *opt, char *sys_name,
+				const char *evt_exp, char *flags)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
@@ -480,15 +480,16 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 		if (len < 0)
 			return EVT_FAILED;
 
-		if (parse_events(NULL, event_opt, 0))
+		if (parse_events(opt, event_opt, 0))
 			return EVT_FAILED;
 	}
 
 	return EVT_HANDLED_ALL;
 }
 
-static enum event_result parse_tracepoint_event(const char **strp,
-				    struct perf_event_attr *attr)
+static enum event_result
+parse_tracepoint_event(const struct option *opt, const char **strp,
+		       struct perf_event_attr *attr)
 {
 	const char *evt_name;
 	char *flags = NULL, *comma_loc;
@@ -527,7 +528,7 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		return EVT_FAILED;
 	if (strpbrk(evt_name, "*?")) {
 		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
-		return parse_multiple_tracepoint_event(sys_name, evt_name,
+		return parse_multiple_tracepoint_event(opt, sys_name, evt_name,
 						       flags);
 	} else {
 		return parse_single_tracepoint_event(sys_name, evt_name,
@@ -737,11 +738,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
  * Symbolic names are (almost) exactly matched.
  */
 static enum event_result
-parse_event_symbols(const char **str, struct perf_event_attr *attr)
+parse_event_symbols(const struct option *opt, const char **str,
+		    struct perf_event_attr *attr)
 {
 	enum event_result ret;
 
-	ret = parse_tracepoint_event(str, attr);
+	ret = parse_tracepoint_event(opt, str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
 
@@ -783,7 +785,7 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 
 	for (;;) {
 		memset(&attr, 0, sizeof(attr));
-		ret = parse_event_symbols(&str, &attr);
+		ret = parse_event_symbols(opt, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
 
-- 
1.6.2.5

