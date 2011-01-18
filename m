Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1ARJnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:43:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab1ARJnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:43:13 -0500
Date: Tue, 18 Jan 2011 10:42:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110118094247.GA25075@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      powerpc: perf: Fix frequency calculation for overflowing counters

Arnaldo Carvalho de Melo (2):
      perf tools: Fix handling of wildcards in tracepoint event selectors
      perf tools: Fix tracepoint id to string perf.data header table


 arch/powerpc/kernel/perf_event.c |    1 +
 tools/perf/builtin-record.c      |    2 ++
 tools/perf/util/parse-events.c   |   31 +------------------------------
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 5674807..ab6f6be 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1212,6 +1212,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			if (left <= 0)
 				left = period;
 			record = 1;
+			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
 			val = 0x80000000LL - left;
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
index 5cb6f4b..bc2732e 100644
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
@@ -555,13 +529,10 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return EVT_FAILED;
 	if (strpbrk(evt_name, "*?")) {
-		*strp += strlen(sys_name) + evt_length;
+		*strp += strlen(sys_name) + evt_length + 1; /* 1 == the ':' */
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else {
-		if (store_event_type(evt_name) < 0)
-			return EVT_FAILED;
-
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
 	}
