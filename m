Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1BQUlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:41:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1BQUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:41:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/5] perf hists: Print number of samples, not the period sum
Date: Thu, 17 Feb 2011 18:41:29 -0200
Message-Id: <1297975291-12792-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297975291-12792-1-git-send-email-acme@infradead.org>
References: <1297975291-12792-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we match the header where we state the number of events with the
"Samples" column when using 'perf report -n/--show-nr-samples':

 [root@emilia ~]# perf record -a sleep 1
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.111 MB perf.data (~4860 samples) ]
 [root@emilia ~]# perf report --stdio --show-nr-samples
 # Events: 11  cycles
 #
 # Overhead  Samples        Command       Shared Object                        Symbol
 # ........ ..........  ...........  ..................  ............................
 #
     16.65%          1        sleep  [kernel.kallsyms]   [k] unmap_vmas
     16.10%          1         perf  libpthread-2.12.so  [.] __pthread_cleanup_push_defer
     15.79%          2         perf  [kernel.kallsyms]   [k] format_decode
     12.88%          1  kworker/1:2  [kernel.kallsyms]   [k] cache_reap
     10.69%          1      swapper  [kernel.kallsyms]   [k] _raw_spin_lock
      7.55%          1        sleep  [kernel.kallsyms]   [k] prepare_exec_creds
      6.00%          1         perf  [jbd2]              [k] start_this_handle
      5.29%          1         perf  [kernel.kallsyms]   [k] seq_read
      4.75%          1         perf  [kernel.kallsyms]   [k] get_pid_task
      4.30%          1         perf  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrestore

 #
 # (For a higher level overview, try: perf report --sort comm,dso)
 #
 [root@emilia ~]#

Reported-by: Stephane Eranian <eranian@google.com>
Acked-by: Stephane Eranian <eranian@google.com>
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
 tools/perf/util/hist.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3f43723..da2899e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -591,6 +591,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 {
 	struct sort_entry *se;
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
+	u64 nr_events;
 	const char *sep = symbol_conf.field_sep;
 	int ret;
 
@@ -599,6 +600,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 	if (pair_hists) {
 		period = self->pair ? self->pair->period : 0;
+		nr_events = self->pair ? self->pair->nr_events : 0;
 		total = pair_hists->stats.total_period;
 		period_sys = self->pair ? self->pair->period_sys : 0;
 		period_us = self->pair ? self->pair->period_us : 0;
@@ -606,6 +608,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
 	} else {
 		period = self->period;
+		nr_events = self->nr_events;
 		total = session_total;
 		period_sys = self->period_sys;
 		period_us = self->period_us;
@@ -646,9 +649,9 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, period);
+			ret += snprintf(s + ret, size - ret, "%c%" PRIu64, *sep, nr_events);
 		else
-			ret += snprintf(s + ret, size - ret, "%11" PRIu64, period);
+			ret += snprintf(s + ret, size - ret, "%11" PRIu64, nr_events);
 	}
 
 	if (pair_hists) {
-- 
1.6.2.5

