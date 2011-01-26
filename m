Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1AZHYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:24:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:53430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab1AZHYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:24:15 -0500
Date: Wed, 26 Jan 2011 07:23:51 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Pass the struct opt to the wildcard parsing routine
Message-ID: <tip-17ea1b70a87e28457821318341bead2b45563092@git.kernel.org>
Git-Commit-ID: 17ea1b70a87e28457821318341bead2b45563092
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:23:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17ea1b70a87e28457821318341bead2b45563092
Gitweb:     http://git.kernel.org/tip/17ea1b70a87e28457821318341bead2b45563092
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 17 Jan 2011 14:40:46 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Jan 2011 10:58:39 -0200

perf tools: Pass the struct opt to the wildcard parsing routine

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
 
