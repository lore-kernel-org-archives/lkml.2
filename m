Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1BYKtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:49:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:39378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1BYKte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:49:34 -0500
Date: Fri, 25 Feb 2011 10:48:53 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, cpw@sgi.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, cpw@sgi.com, fweisbec@gmail.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists: Print number of samples, not the period sum
Message-ID: <tip-69cf0218d1f0d1d8f14687fec070126021502451@git.kernel.org>
Git-Commit-ID: 69cf0218d1f0d1d8f14687fec070126021502451
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Feb 2011 10:48:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69cf0218d1f0d1d8f14687fec070126021502451
Gitweb:     http://git.kernel.org/tip/69cf0218d1f0d1d8f14687fec070126021502451
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Feb 2011 10:37:23 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Feb 2011 10:55:03 +0100

perf hists: Print number of samples, not the period sum

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
Reported-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: <stable@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ cherry-picked it from perf/core, as it has been reported by others as well. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/hist.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

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
