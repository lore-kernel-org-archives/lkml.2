Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1CYNLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:11:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1CYNLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:11:43 -0400
Date: Fri, 25 Mar 2011 14:11:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110325131105.GA12357@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
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
Akihiro Nagai (1):
      perf top: Fix uninitialized 'counter' variable

Arnaldo Carvalho de Melo (3):
      perf session: Pass evsel in event_ops->sample()
      perf build-id: Add quirk to deal with perf.data file format breakage
      perf symbols: Look at .dynsym again if .symtab not found

Don Zickus (1):
      perf, x86: P4 PMU - Read proper MSR register to catch unflagged overflows

Frederic Weisbecker (1):
      perf: Better fit max unprivileged mlock pages for tools needs

Ingo Molnar (1):
      perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue

Jiri Olsa (1):
      tracing: Fix set_ftrace_filter probe function display

Stephane Eranian (2):
      perf, x86: Fix Intel fixed counters base initialization
      perf_events: Fix stale ->cgrp pointer in update_cgrp_time_from_cpuctx()


 arch/x86/kernel/cpu/perf_event.c                   |   11 +++-
 arch/x86/kernel/cpu/perf_event_p4.c                |    1 +
 include/linux/perf_event.h                         |    2 -
 kernel/perf_event.c                                |   15 +++++-
 kernel/trace/ftrace.c                              |    3 +-
 tools/perf/builtin-annotate.c                      |   18 ++-----
 tools/perf/builtin-diff.c                          |    1 +
 tools/perf/builtin-inject.c                        |   11 ++++-
 tools/perf/builtin-kmem.c                          |    1 +
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-report.c                        |   19 ++-----
 tools/perf/builtin-sched.c                         |    1 +
 tools/perf/builtin-script.c                        |   15 ++----
 tools/perf/builtin-timechart.c                     |   11 ++++
 tools/perf/builtin-top.c                           |    4 +-
 tools/perf/util/build-id.c                         |    1 +
 tools/perf/util/header.c                           |   57 +++++++++++++++++++-
 tools/perf/util/hist.h                             |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |    1 +
 .../util/scripting-engines/trace-event-python.c    |    1 +
 tools/perf/util/session.c                          |   25 ++++++++-
 tools/perf/util/session.h                          |    7 ++-
 tools/perf/util/symbol.c                           |   25 +++++----
 tools/perf/util/trace-event-scripting.c            |    1 +
 tools/perf/util/trace-event.h                      |    1 +
 25 files changed, 168 insertions(+), 69 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e8dbe17..eb00677 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -500,12 +500,17 @@ static bool check_hw_exists(void)
 	return true;
 
 bios_fail:
-	printk(KERN_CONT "Broken BIOS detected, using software events only.\n");
+	/*
+	 * We still allow the PMU driver to operate:
+	 */
+	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
 	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
-	return false;
+
+	return true;
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
+
 	return false;
 }
 
@@ -912,7 +917,7 @@ static inline void x86_assign_hw_event(struct perf_event *event,
 		hwc->event_base	= 0;
 	} else if (hwc->idx >= X86_PMC_IDX_FIXED) {
 		hwc->config_base = MSR_ARCH_PERFMON_FIXED_CTR_CTRL;
-		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0;
+		hwc->event_base = MSR_ARCH_PERFMON_FIXED_CTR0 + (hwc->idx - X86_PMC_IDX_FIXED);
 	} else {
 		hwc->config_base = x86_pmu_config_addr(hwc->idx);
 		hwc->event_base  = x86_pmu_event_addr(hwc->idx);
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3769ac8..d3d7b59 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f495c01..311b4dc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -938,9 +938,7 @@ struct perf_cpu_context {
 	struct list_head		rotation_list;
 	int				jiffies_interval;
 	struct pmu			*active_pmu;
-#ifdef CONFIG_CGROUP_PERF
 	struct perf_cgroup		*cgrp;
-#endif
 };
 
 struct perf_output_handle {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3472bb1..c75925c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,7 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-int sysctl_perf_event_mlock __read_mostly = 512; /* 'free' kb per user */
+/* Minimum for 128 pages + 1 for the user control page */
+int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
@@ -941,6 +942,7 @@ static void perf_group_attach(struct perf_event *event)
 static void
 list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 {
+	struct perf_cpu_context *cpuctx;
 	/*
 	 * We can have double detach due to exit/hot-unplug + close.
 	 */
@@ -949,8 +951,17 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 
 	event->attach_state &= ~PERF_ATTACH_CONTEXT;
 
-	if (is_cgroup_event(event))
+	if (is_cgroup_event(event)) {
 		ctx->nr_cgroups--;
+		cpuctx = __get_cpu_context(ctx);
+		/*
+		 * if there are no more cgroup events
+		 * then cler cgrp to avoid stale pointer
+		 * in update_cgrp_time_from_cpuctx()
+		 */
+		if (!ctx->nr_cgroups)
+			cpuctx->cgrp = NULL;
+	}
 
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 888b611..c075f4e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1467,7 +1467,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		return t_hash_next(m, pos);
 
 	(*pos)++;
-	iter->pos = *pos;
+	iter->pos = iter->func_pos = *pos;
 
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return t_hash_start(m, pos);
@@ -1502,7 +1502,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	if (!rec)
 		return t_hash_start(m, pos);
 
-	iter->func_pos = *pos;
 	iter->func = rec;
 
 	return iter;
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 695de4b..e18eb7e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -42,9 +42,9 @@ static const char *sym_hist_filter;
 
 static int perf_evlist__add_sample(struct perf_evlist *evlist,
 				   struct perf_sample *sample,
+				   struct perf_evsel *evsel,
 				   struct addr_location *al)
 {
-	struct perf_evsel *evsel;
 	struct hist_entry *he;
 	int ret;
 
@@ -59,18 +59,6 @@ static int perf_evlist__add_sample(struct perf_evlist *evlist,
 		return 0;
 	}
 
-	evsel = perf_evlist__id2evsel(evlist, sample->id);
-	if (evsel == NULL) {
-		/*
-		 * FIXME: Propagate this back, but at least we're in a builtin,
-		 * where exit() is allowed. ;-)
-		 */
-		ui__warning("Invalid %s file, contains samples with id not in "
-			    "its header!\n", input_name);
-		exit_browser(0);
-		exit(1);
-	}
-
 	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
@@ -92,6 +80,7 @@ static int perf_evlist__add_sample(struct perf_evlist *evlist,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct addr_location al;
@@ -103,7 +92,8 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (!al.filtered && perf_evlist__add_sample(session->evlist, sample, &al)) {
+	if (!al.filtered &&
+	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6b7d911..e821999 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -32,6 +32,7 @@ static int hists__add_entry(struct hists *self,
 
 static int diff__process_sample_event(union perf_event *event,
 				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index e29f04e..8dfc12b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -43,6 +43,14 @@ static int perf_event__repipe(union perf_event *event,
 	return perf_event__repipe_synth(event, session);
 }
 
+static int perf_event__repipe_sample(union perf_event *event,
+			      struct perf_sample *sample __used,
+			      struct perf_evsel *evsel __used,
+			      struct perf_session *session)
+{
+	return perf_event__repipe_synth(event, session);
+}
+
 static int perf_event__repipe_mmap(union perf_event *event,
 				   struct perf_sample *sample,
 				   struct perf_session *session)
@@ -124,6 +132,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 
 static int perf_event__inject_buildid(union perf_event *event,
 				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
 {
 	struct addr_location al;
@@ -164,7 +173,7 @@ repipe:
 }
 
 struct perf_event_ops inject_ops = {
-	.sample		= perf_event__repipe,
+	.sample		= perf_event__repipe_sample,
 	.mmap		= perf_event__repipe,
 	.comm		= perf_event__repipe,
 	.fork		= perf_event__repipe,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7f618f4..225e963 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,6 +305,7 @@ static void process_raw_event(union perf_event *raw_event __used, void *data,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 7a2a79d..9ac05aa 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -845,7 +845,9 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(union perf_event *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *s)
 {
 	struct thread *thread = perf_session__findnew(s, sample->tid);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b1b8200..498c6f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -50,12 +50,12 @@ static symbol_filter_t	annotate_init;
 
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
-					struct perf_sample *sample)
+					struct perf_sample *sample,
+					struct perf_evsel *evsel)
 {
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
-	struct perf_evsel *evsel;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = perf_session__resolve_callchain(session, al->thread,
@@ -64,18 +64,6 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 			return err;
 	}
 
-	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel == NULL) {
-		/*
-		 * FIXME: Propagate this back, but at least we're in a builtin,
-		 * where exit() is allowed. ;-)
-		 */
-		ui__warning("Invalid %s file, contains samples with id %" PRIu64 " not in "
-			    "its header!\n", input_name, sample->id);
-		exit_browser(0);
-		exit(1);
-	}
-
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
@@ -113,6 +101,7 @@ out:
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct addr_location al;
@@ -127,7 +116,7 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, sample)) {
+	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a32f411..dcfe887 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1603,6 +1603,7 @@ static void process_raw_event(union perf_event *raw_event __used,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct thread *thread;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9f5fc54..ac574ea 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -162,19 +162,11 @@ static void print_sample_start(struct perf_sample *sample,
 
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
+			  struct perf_evsel *evsel,
 			  struct perf_session *session,
 			  struct thread *thread)
 {
-	struct perf_event_attr *attr;
-	struct perf_evsel *evsel;
-
-	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel == NULL) {
-		pr_err("Invalid data. Contains samples with id not in "
-		       "its header!\n");
-		return;
-	}
-	attr = &evsel->attr;
+	struct perf_event_attr *attr = &evsel->attr;
 
 	if (output_fields[attr->type] == 0)
 		return;
@@ -244,6 +236,7 @@ static char const		*input_name = "perf.data";
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
@@ -264,7 +257,7 @@ static int process_sample_event(union perf_event *event,
 		last_timestamp = sample->time;
 		return 0;
 	}
-	scripting_ops->process_event(event, sample, session, thread);
+	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 67c0459..aa26f4d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -488,6 +488,7 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 
 static int process_sample_event(union perf_event *event __used,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct trace_entry *te;
@@ -506,6 +507,16 @@ static int process_sample_event(union perf_event *event __used,
 		struct power_entry_old *peo;
 		peo = (void *)te;
 #endif
+		/*
+		 * FIXME: use evsel, its already mapped from id to perf_evsel,
+		 * remove perf_header__find_event infrastructure bits.
+		 * Mapping all these "power:cpu_idle" strings to the tracepoint
+		 * ID and then just comparing against evsel->attr.config.
+		 *
+		 * e.g.:
+		 *
+		 * if (evsel->attr.config == power_cpu_idle_id)
+		 */
 		event_str = perf_header__find_event(te->type);
 
 		if (!event_str)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 70f1075..676b4fb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -515,7 +515,9 @@ static void handle_keypress(struct perf_session *session, int c)
 			break;
 		case 'E':
 			if (top.evlist->nr_entries > 1) {
-				int counter;
+				/* Select 0 as the default event: */
+				int counter = 0;
+
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top.sym_evsel, &top.evlist->entries, node)
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 31f934a..a91cd99 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,6 +16,7 @@
 
 static int build_id__mark_dso_hit(union perf_event *event,
 				  struct perf_sample *sample __used,
+				  struct perf_evsel *evsel __used,
 				  struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e5230c0..93862a8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -695,13 +695,50 @@ out:
 	return err;
 }
 
+static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
+						 int input, u64 offset, u64 size)
+{
+	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct {
+		struct perf_event_header   header;
+		u8			   build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+		char			   filename[0];
+	} old_bev;
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	u64 limit = offset + size;
+
+	while (offset < limit) {
+		ssize_t len;
+
+		if (read(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
+			return -1;
+
+		if (header->needs_swap)
+			perf_event_header__bswap(&old_bev.header);
+
+		len = old_bev.header.size - sizeof(old_bev);
+		if (read(input, filename, len) != len)
+			return -1;
+
+		bev.header = old_bev.header;
+		bev.pid	   = 0;
+		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
+		__event_process_build_id(&bev, filename, session);
+
+		offset += bev.header.size;
+	}
+
+	return 0;
+}
+
 static int perf_header__read_build_ids(struct perf_header *header,
 				       int input, u64 offset, u64 size)
 {
 	struct perf_session *session = container_of(header, struct perf_session, header);
 	struct build_id_event bev;
 	char filename[PATH_MAX];
-	u64 limit = offset + size;
+	u64 limit = offset + size, orig_offset = offset;
 	int err = -1;
 
 	while (offset < limit) {
@@ -716,6 +753,24 @@ static int perf_header__read_build_ids(struct perf_header *header,
 		len = bev.header.size - sizeof(bev);
 		if (read(input, filename, len) != len)
 			goto out;
+		/*
+		 * The a1645ce1 changeset:
+		 *
+		 * "perf: 'perf kvm' tool for monitoring guest performance from host"
+		 *
+		 * Added a field to struct build_id_event that broke the file
+		 * format.
+		 *
+		 * Since the kernel build-id is the first entry, process the
+		 * table using the old format if the well known
+		 * '[kernel.kallsyms]' string for the kernel build-id has the
+		 * first 4 characters chopped off (where the pid_t sits).
+		 */
+		if (memcmp(filename, "nel.kallsyms]", 13) == 0) {
+			if (lseek(input, orig_offset, SEEK_SET) == (off_t)-1)
+				return -1;
+			return perf_header__read_build_ids_abi_quirk(header, input, offset, size);
+		}
 
 		__event_process_build_id(&bev, filename, session);
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cb6858a..3beb97c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -29,6 +29,7 @@ struct events_stats {
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
+	u32 nr_unknown_id;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 6214272..74350ff 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -247,6 +247,7 @@ static inline struct event *find_cache_event(int type)
 
 static void perl_process_event(union perf_event *pevent __unused,
 			       struct perf_sample *sample,
+			       struct perf_evsel *evsel,
 			       struct perf_session *session __unused,
 			       struct thread *thread)
 {
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 1b85d60..6ccf70e 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -206,6 +206,7 @@ static inline struct event *find_cache_event(int type)
 
 static void python_process_event(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
+				 struct perf_evsel *evsel __unused,
 				 struct perf_session *session __unused,
 				 struct thread *thread)
 {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c68cf40..caa2245 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -280,6 +280,15 @@ static int process_event_synth_stub(union perf_event *event __used,
 	return 0;
 }
 
+static int process_event_sample_stub(union perf_event *event __used,
+				     struct perf_sample *sample __used,
+				     struct perf_evsel *evsel __used,
+				     struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_event_stub(union perf_event *event __used,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
@@ -303,7 +312,7 @@ static int process_finished_round(union perf_event *event,
 static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
 	if (handler->sample == NULL)
-		handler->sample = process_event_stub;
+		handler->sample = process_event_sample_stub;
 	if (handler->mmap == NULL)
 		handler->mmap = process_event_stub;
 	if (handler->comm == NULL)
@@ -698,12 +707,19 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_event_ops *ops,
 				      u64 file_offset)
 {
+	struct perf_evsel *evsel;
+
 	dump_event(session, event, file_offset, sample);
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		dump_sample(session, event, sample);
-		return ops->sample(event, sample, session);
+		evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+		if (evsel == NULL) {
+			++session->hists.stats.nr_unknown_id;
+			return -1;
+		}
+		return ops->sample(event, sample, evsel, session);
 	case PERF_RECORD_MMAP:
 		return ops->mmap(event, sample, session);
 	case PERF_RECORD_COMM:
@@ -845,6 +861,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    session->hists.stats.nr_unknown_events);
 	}
 
+	if (session->hists.stats.nr_unknown_id != 0) {
+		ui__warning("%u samples with id not present in the header\n",
+			    session->hists.stats.nr_unknown_id);
+	}
+
  	if (session->hists.stats.nr_invalid_chains != 0) {
  		ui__warning("Found invalid callchains!\n\n"
  			    "%u out of %u events were discarded for this reason.\n\n"
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0b3c9af..1ac481f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -55,8 +55,11 @@ struct perf_session {
 	char			filename[0];
 };
 
+struct perf_evsel;
 struct perf_event_ops;
 
+typedef int (*event_sample)(union perf_event *event, struct perf_sample *sample,
+			    struct perf_evsel *evsel, struct perf_session *session);
 typedef int (*event_op)(union perf_event *self, struct perf_sample *sample,
 			struct perf_session *session);
 typedef int (*event_synth_op)(union perf_event *self,
@@ -65,8 +68,8 @@ typedef int (*event_op2)(union perf_event *self, struct perf_session *session,
 			 struct perf_event_ops *ops);
 
 struct perf_event_ops {
-	event_op	sample,
-			mmap,
+	event_sample	sample;
+	event_op	mmap,
 			comm,
 			fork,
 			exit,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 651dbfe..17df793 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1486,7 +1486,9 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE, want_symtab = 1;
+	want_symtab = 1;
+restart:
+	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE;
 	     self->symtab_type != SYMTAB__NOT_FOUND;
 	     self->symtab_type++) {
 		switch (self->symtab_type) {
@@ -1536,17 +1538,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
 				 self->long_name);
 			break;
-
-		default:
-			/*
-			 * If we wanted a full symtab but no image had one,
-			 * relax our requirements and repeat the search.
-			 */
-			if (want_symtab) {
-				want_symtab = 0;
-				self->symtab_type = SYMTAB__BUILD_ID_CACHE;
-			} else
-				continue;
+		default:;
 		}
 
 		/* Name is now the name of the next image to try */
@@ -1573,6 +1565,15 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		}
 	}
 
+	/*
+	 * If we wanted a full symtab but no image had one,
+	 * relax our requirements and repeat the search.
+	 */
+	if (ret <= 0 && want_symtab) {
+		want_symtab = 0;
+		goto restart;
+	}
+
 	free(name);
 	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
 		return 0;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 66f4b78..c9dcbec 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -38,6 +38,7 @@ static int stop_script_unsupported(void)
 
 static void process_event_unsupported(union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
+				      struct perf_evsel *evsel __unused,
 				      struct perf_session *session __unused,
 				      struct thread *thread __unused)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b04da57..f674dda 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -280,6 +280,7 @@ struct scripting_ops {
 	int (*stop_script) (void);
 	void (*process_event) (union perf_event *event,
 			       struct perf_sample *sample,
+			       struct perf_evsel *evsel,
 			       struct perf_session *session,
 			       struct thread *thread);
 	int (*generate_script) (const char *outfile);
