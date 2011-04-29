Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab1D2VB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:39282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab1D2VB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:01:26 -0400
Date: Fri, 29 Apr 2011 21:01:00 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n009io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf list: Fix max event string size
Git-Commit-ID: 947b4ad1d198b7303ecc961f4939a331be0c48f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 21:01:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  947b4ad1d198b7303ecc961f4939a331be0c48f0
Gitweb:     http://git.kernel.org/tip/947b4ad1d198b7303ecc961f4939a331be0c48f0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 22:52:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 22:52:54 +0200

perf list: Fix max event string size

Recent stalled-cycles event names were larger than the 40 chars printout
used by perf list.

Extend that, make it robust for future extensions and also adjust alignments
in face of wider event names.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n009io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8a407f3..ffa493a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -929,7 +929,7 @@ void print_tracepoint_events(const char *subsys_glob, const char *event_glob)
 
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
-			printf("  %-42s [%s]\n", evt_path,
+			printf("  %-50s [%s]\n", evt_path,
 				event_type_descriptors[PERF_TYPE_TRACEPOINT]);
 		}
 		closedir(evt_dir);
@@ -994,7 +994,7 @@ void print_events_type(u8 type)
 		else
 			snprintf(name, sizeof(name), "%s", syms->symbol);
 
-		printf("  %-42s [%s]\n", name,
+		printf("  %-50s [%s]\n", name,
 			event_type_descriptors[type]);
 	}
 }
@@ -1012,11 +1012,10 @@ int print_hwcache_events(const char *event_glob)
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
 				char *name = event_cache_name(type, op, i);
 
-				if (event_glob != NULL && 
-				    !strglobmatch(name, event_glob))
+				if (event_glob != NULL && !strglobmatch(name, event_glob))
 					continue;
 
-				printf("  %-42s [%s]\n", name,
+				printf("  %-50s [%s]\n", name,
 					event_type_descriptors[PERF_TYPE_HW_CACHE]);
 				++printed;
 			}
@@ -1026,14 +1025,16 @@ int print_hwcache_events(const char *event_glob)
 	return printed;
 }
 
+#define MAX_NAME_LEN 100
+
 /*
  * Print the help text for the event symbols:
  */
 void print_events(const char *event_glob)
 {
-	struct event_symbol *syms = event_symbols;
 	unsigned int i, type, prev_type = -1, printed = 0, ntypes_printed = 0;
-	char name[40];
+	struct event_symbol *syms = event_symbols;
+	char name[MAX_NAME_LEN];
 
 	printf("\n");
 	printf("List of pre-defined events (to be used in -e):\n");
@@ -1053,10 +1054,10 @@ void print_events(const char *event_glob)
 			continue;
 
 		if (strlen(syms->alias))
-			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
 		else
-			strcpy(name, syms->symbol);
-		printf("  %-42s [%s]\n", name,
+			strncpy(name, syms->symbol, MAX_NAME_LEN);
+		printf("  %-50s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
@@ -1073,12 +1074,12 @@ void print_events(const char *event_glob)
 		return;
 
 	printf("\n");
-	printf("  %-42s [%s]\n",
+	printf("  %-50s [%s]\n",
 		"rNNN (see 'perf list --help' on how to encode it)",
 	       event_type_descriptors[PERF_TYPE_RAW]);
 	printf("\n");
 
-	printf("  %-42s [%s]\n",
+	printf("  %-50s [%s]\n",
 			"mem:<addr>[:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 	printf("\n");
