Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1ARItq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 03:49:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:54279 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1ARIto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 03:49:44 -0500
Date: Tue, 18 Jan 2011 08:49:17 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, vagabon.xyz@gmail.com,
        fweisbec@gmail.com, phan@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, vagabon.xyz@gmail.com,
        phan@redhat.com, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110117202801.GG2085@ghostprotocols.net>
References: <20110117202801.GG2085@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix tracepoint id to string perf.data header table
Message-ID: <tip-ad7f4e3f7b966ac09c8f98dbc5024813a1685775@git.kernel.org>
Git-Commit-ID: ad7f4e3f7b966ac09c8f98dbc5024813a1685775
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 08:49:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad7f4e3f7b966ac09c8f98dbc5024813a1685775
Gitweb:     http://git.kernel.org/tip/ad7f4e3f7b966ac09c8f98dbc5024813a1685775
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 17 Jan 2011 18:28:13 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Jan 2011 18:28:13 -0200

perf tools: Fix tracepoint id to string perf.data header table

It was broken by f006d25 that passed just the event name, not the complete
sys:event that it expected to open the /sys/.../sys/sys:event/id file to get
the id.

Fix it by moving it to after parse_events in cmd_record, as at that point
we can just traverse the evsel_list and use evsel->attr.config +
event_name(evsel) instead of re-opening the /id file.

Reported-by: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20110117202801.GG2085@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    2 ++
 tools/perf/util/parse-events.c |   29 -----------------------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index df6064a..fcd29e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -936,6 +936,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	list_for_each_entry(pos, &evsel_list, node) {
 		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
+		if (perf_header__push_event(pos->attr.config, event_name(pos)))
+			goto out_free_fd;
 	}
 	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
 			      MAX_COUNTERS * threads->nr));
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1f4cfe5..bc2732e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,32 +490,6 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
@@ -559,9 +533,6 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else {
-		if (store_event_type(evt_name) < 0)
-			return EVT_FAILED;
-
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
 	}
