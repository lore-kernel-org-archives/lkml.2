Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1B1RfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 12:35:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1B1RfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 12:35:13 -0500
Date: Mon, 28 Feb 2011 18:34:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110228173447.GA4083@elte.hu>
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
Arnaldo Carvalho de Melo (1):
      perf hists: Print number of samples, not the period sum

Thomas Renninger (2):
      perf timechart: Fix black idle boxes in the title
      perf timechart: Fix max number of cpus


 tools/perf/builtin-timechart.c |    6 +++---
 tools/perf/util/hist.c         |    7 +++++--
 tools/perf/util/svghelper.c    |    6 +++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 746cf03..0ace786 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -264,9 +264,6 @@ pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
 		c->start_time = start;
 	if (p->start_time == 0 || p->start_time > start)
 		p->start_time = start;
-
-	if (cpu > numcpus)
-		numcpus = cpu;
 }
 
 #define MAX_CPUS 4096
@@ -511,6 +508,9 @@ static int process_sample_event(event_t *event __used,
 		if (!event_str)
 			return 0;
 
+		if (sample->cpu > numcpus)
+			numcpus = sample->cpu;
+
 		if (strcmp(event_str, "power:cpu_idle") == 0) {
 			struct power_processor_entry *ppe = (void *)te;
 			if (ppe->state == (u32)PWR_EVENT_EXIT)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 32f4f1f..df51560 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -585,6 +585,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 {
 	struct sort_entry *se;
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
+	u64 nr_events;
 	const char *sep = symbol_conf.field_sep;
 	int ret;
 
@@ -593,6 +594,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 	if (pair_hists) {
 		period = self->pair ? self->pair->period : 0;
+		nr_events = self->pair ? self->pair->nr_events : 0;
 		total = pair_hists->stats.total_period;
 		period_sys = self->pair ? self->pair->period_sys : 0;
 		period_us = self->pair ? self->pair->period_us : 0;
@@ -600,6 +602,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
 	} else {
 		period = self->period;
+		nr_events = self->nr_events;
 		total = session_total;
 		period_sys = self->period_sys;
 		period_us = self->period_us;
@@ -640,9 +643,9 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
+			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
 		else
-			ret += snprintf(s + ret, size - ret, "%11" PRIu64, period);
+			ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
 	}
 
 	if (pair_hists) {
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index fb737fe..96c8660 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -456,9 +456,9 @@ void svg_legenda(void)
 		return;
 
 	svg_legenda_box(0,	"Running", "sample");
-	svg_legenda_box(100,	"Idle","rect.c1");
-	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
-	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
+	svg_legenda_box(100,	"Idle","c1");
+	svg_legenda_box(200,	"Deeper Idle", "c3");
+	svg_legenda_box(350,	"Deepest Idle", "c6");
 	svg_legenda_box(550,	"Sleeping", "process2");
 	svg_legenda_box(650,	"Waiting for cpu", "waiting");
 	svg_legenda_box(800,	"Blocked on IO", "blocked");
