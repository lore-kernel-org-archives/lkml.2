Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab0FJKZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:25:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0FJKZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:25:51 -0400
Date: Thu, 10 Jun 2010 12:25:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100610102524.GA15245@elte.hu>
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
      perf symbols: Set the DSO long name when using symbol_conf.vmlinux_name

Denis Kirjanov (1):
      powerpc/oprofile: fix potential buffer overrun in op_model_cell.c

Oleg Nesterov (1):
      tracing: Fix null pointer deref with SEND_SIG_FORCED

Peter Zijlstra (1):
      perf: Fix signed comparison in perf_adjust_period()


 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 include/trace/events/signal.h         |    3 ++-
 kernel/perf_event.c                   |    5 ++++-
 tools/perf/util/symbol.c              |    8 ++++++--
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 2c9e522..7fd90d0 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1077,7 +1077,7 @@ static int calculate_lfsr(int n)
 		index = ENTRIES-1;
 
 	/* make sure index is valid */
-	if ((index > ENTRIES) || (index < 0))
+	if ((index >= ENTRIES) || (index < 0))
 		index = ENTRIES-1;
 
 	return initial_lfsr[index];
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 814566c..17df434 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -10,7 +10,8 @@
 
 #define TP_STORE_SIGINFO(__entry, info)				\
 	do {							\
-		if (info == SEND_SIG_NOINFO) {			\
+		if (info == SEND_SIG_NOINFO ||			\
+		    info == SEND_SIG_FORCED) {			\
 			__entry->errno	= 0;			\
 			__entry->code	= SI_USER;		\
 		} else if (info == SEND_SIG_PRIV) {		\
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 31d6afe..ff86c55 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1507,6 +1507,9 @@ do {					\
 		divisor = nsec * frequency;
 	}
 
+	if (!divisor)
+		return dividend;
+
 	return div64_u64(dividend, divisor);
 }
 
@@ -1529,7 +1532,7 @@ static int perf_event_start(struct perf_event *event)
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	u64 period, sample_period;
+	s64 period, sample_period;
 	s64 delta;
 
 	period = perf_calculate_period(event, nsec, count);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7fd6b15..b63e571 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1745,7 +1745,12 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 	if (symbol_conf.vmlinux_name != NULL) {
 		err = dso__load_vmlinux(self, map,
 					symbol_conf.vmlinux_name, filter);
-		goto out_try_fixup;
+		if (err > 0) {
+			dso__set_long_name(self,
+					   strdup(symbol_conf.vmlinux_name));
+			goto out_fixup;
+		}
+		return err;
 	}
 
 	if (vmlinux_path != NULL) {
@@ -1806,7 +1811,6 @@ do_kallsyms:
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	free(kallsyms_allocated_filename);
 
-out_try_fixup:
 	if (err > 0) {
 out_fixup:
 		if (kallsyms_filename != NULL)
