Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1EWNlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:41:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57757 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1EWNlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:41:44 -0400
Date: Mon, 23 May 2011 15:41:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110523134125.GA23518@elte.hu>
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

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (8):
      perf tools: Check we are able to read the event size on mmap
      perf tools: Remove junk code in mmap size handling
      perf tools: Move evlist sample helpers to evlist area
      perf tools: Pre-check sample size before parsing
      perf tools: Robustify dynamic sample content fetch
      perf tools: Propagate event parse error handling
      perf tools: Fix ommitted mmap data update on remap
      perf tools: Fix sample size bit operations

Mandeep Singh Baines (4):
      watchdog: Fix rounding bug in get_sample_period()
      watchdog: Only disable/enable watchdog if neccessary
      watchdog: Disable watchdog when thresh is zero
      watchdog: Change the default timeout and configure nmi watchdog period based on watchdog_thresh


 arch/x86/kernel/apic/hw_nmi.c        |    4 +-
 include/linux/nmi.h                  |    7 ++--
 include/linux/sched.h                |    1 -
 kernel/sysctl.c                      |   12 +++++--
 kernel/watchdog.c                    |   52 +++++++++++++++++++--------------
 tools/perf/builtin-test.c            |    9 +++++-
 tools/perf/builtin-top.c             |    7 ++++-
 tools/perf/util/event.c              |   46 ++++++++++++++++++++----------
 tools/perf/util/event.h              |   12 +++++++-
 tools/perf/util/evlist.c             |   31 ++++++++++++++++++++
 tools/perf/util/evlist.h             |    3 ++
 tools/perf/util/evsel.c              |   32 ++++++++++++++++++++-
 tools/perf/util/header.c             |   31 --------------------
 tools/perf/util/header.h             |    2 -
 tools/perf/util/include/linux/list.h |    2 +
 tools/perf/util/python.c             |   13 ++++++--
 tools/perf/util/session.c            |   50 ++++++++++++++++++++++++--------
 tools/perf/util/session.h            |    2 +
 18 files changed, 216 insertions(+), 100 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 5260fe9..d5e57db0 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -19,9 +19,9 @@
 #include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
-u64 hw_nmi_get_sample_period(void)
+u64 hw_nmi_get_sample_period(int watchdog_thresh)
 {
-	return (u64)(cpu_khz) * 1000 * 60;
+	return (u64)(cpu_khz) * 1000 * watchdog_thresh;
 }
 #endif
 
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index c536f85..2d304ef 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -45,11 +45,12 @@ static inline bool trigger_all_cpu_backtrace(void)
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
-u64 hw_nmi_get_sample_period(void);
+u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_enabled;
+extern int watchdog_thresh;
 struct ctl_table;
-extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
-			void __user *, size_t *, loff_t *);
+extern int proc_dowatchdog(struct ctl_table *, int ,
+			   void __user *, size_t *, loff_t *);
 #endif
 
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 12211e1..d8b2d0b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -315,7 +315,6 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
-extern int softlockup_thresh;
 void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..3dd0c46 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -730,14 +730,16 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog_enabled,
+		.proc_handler   = proc_dowatchdog,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 	{
 		.procname	= "watchdog_thresh",
-		.data		= &softlockup_thresh,
+		.data		= &watchdog_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dowatchdog_thresh,
+		.proc_handler	= proc_dowatchdog,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
@@ -755,7 +757,9 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog_enabled,
+		.proc_handler   = proc_dowatchdog,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 14733d4..6e63097 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -28,7 +28,7 @@
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
-int __read_mostly softlockup_thresh = 60;
+int __read_mostly watchdog_thresh = 10;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -91,6 +91,17 @@ static int __init nosoftlockup_setup(char *str)
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
 
+/*
+ * Hard-lockup warnings should be triggered after just a few seconds. Soft-
+ * lockups can have false positives under extreme conditions. So we generally
+ * want a higher threshold for soft lockups than for hard lockups. So we couple
+ * the thresholds with a factor: we make the soft threshold twice the amount of
+ * time the hard threshold is.
+ */
+static int get_softlockup_thresh()
+{
+	return watchdog_thresh * 2;
+}
 
 /*
  * Returns seconds, approximately.  We don't need nanosecond
@@ -105,12 +116,12 @@ static unsigned long get_timestamp(int this_cpu)
 static unsigned long get_sample_period(void)
 {
 	/*
-	 * convert softlockup_thresh from seconds to ns
+	 * convert watchdog_thresh from seconds to ns
 	 * the divide by 5 is to give hrtimer 5 chances to
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return softlockup_thresh / 5 * NSEC_PER_SEC;
+	return get_softlockup_thresh() * (NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -182,7 +193,7 @@ static int is_softlockup(unsigned long touch_ts)
 	unsigned long now = get_timestamp(smp_processor_id());
 
 	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + softlockup_thresh))
+	if (time_after(now, touch_ts + get_softlockup_thresh()))
 		return now - touch_ts;
 
 	return 0;
@@ -359,7 +370,7 @@ static int watchdog_nmi_enable(int cpu)
 
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
-	wd_attr->sample_period = hw_nmi_get_sample_period();
+	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
@@ -501,28 +512,25 @@ static void watchdog_disable_all_cpus(void)
 /* sysctl functions */
 #ifdef CONFIG_SYSCTL
 /*
- * proc handler for /proc/sys/kernel/nmi_watchdog
+ * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-int proc_dowatchdog_enabled(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *length, loff_t *ppos)
+int proc_dowatchdog(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	proc_dointvec(table, write, buffer, length, ppos);
+	int ret;
 
-	if (write) {
-		if (watchdog_enabled)
-			watchdog_enable_all_cpus();
-		else
-			watchdog_disable_all_cpus();
-	}
-	return 0;
-}
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		goto out;
 
-int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (watchdog_enabled && watchdog_thresh)
+		watchdog_enable_all_cpus();
+	else
+		watchdog_disable_all_cpus();
+
+out:
+	return ret;
 }
 #endif /* CONFIG_SYSCTL */
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2f9a337..b671862 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -474,6 +474,7 @@ static int test__basic_mmap(void)
 	unsigned int nr_events[nsyscalls],
 		     expected_nr_events[nsyscalls], i, j;
 	struct perf_evsel *evsels[nsyscalls], *evsel;
+	int sample_size = perf_sample_size(attr.sample_type);
 
 	for (i = 0; i < nsyscalls; ++i) {
 		char name[64];
@@ -558,7 +559,13 @@ static int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
-		perf_event__parse_sample(event, attr.sample_type, false, &sample);
+		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
+					       false, &sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto out_munmap;
+		}
+
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ebfc7cf..2d7934e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -805,9 +805,14 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 {
 	struct perf_sample sample;
 	union perf_event *event;
+	int ret;
 
 	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
-		perf_session__parse_sample(self, event, &sample);
+		ret = perf_session__parse_sample(self, event, &sample);
+		if (ret) {
+			pr_err("Can't parse sample, err = %d\n", ret);
+			continue;
+		}
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			perf_event__process_sample(event, &sample, self);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1023f67..252b72a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -9,21 +9,21 @@
 #include "thread_map.h"
 
 static const char *perf_event__names[] = {
-	[0]			 = "TOTAL",
-	[PERF_RECORD_MMAP]	 = "MMAP",
-	[PERF_RECORD_LOST]	 = "LOST",
-	[PERF_RECORD_COMM]	 = "COMM",
-	[PERF_RECORD_EXIT]	 = "EXIT",
-	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
-	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
-	[PERF_RECORD_FORK]	 = "FORK",
-	[PERF_RECORD_READ]	 = "READ",
-	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
-	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
-	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
-	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
-	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
-	[PERF_RECORD_FINISHED_ROUND]	 = "FINISHED_ROUND",
+	[0]					= "TOTAL",
+	[PERF_RECORD_MMAP]			= "MMAP",
+	[PERF_RECORD_LOST]			= "LOST",
+	[PERF_RECORD_COMM]			= "COMM",
+	[PERF_RECORD_EXIT]			= "EXIT",
+	[PERF_RECORD_THROTTLE]			= "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE]		= "UNTHROTTLE",
+	[PERF_RECORD_FORK]			= "FORK",
+	[PERF_RECORD_READ]			= "READ",
+	[PERF_RECORD_SAMPLE]			= "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]		= "ATTR",
+	[PERF_RECORD_HEADER_EVENT_TYPE]		= "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
+	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
+	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
 };
 
 const char *perf_event__name(unsigned int id)
@@ -35,6 +35,22 @@ const char *perf_event__name(unsigned int id)
 	return perf_event__names[id];
 }
 
+int perf_sample_size(u64 sample_type)
+{
+	u64 mask = sample_type & PERF_SAMPLE_MASK;
+	int size = 0;
+	int i;
+
+	for (i = 0; i < 64; i++) {
+		if (mask & (1UL << i))
+			size++;
+	}
+
+	size *= sizeof(u64);
+
+	return size;
+}
+
 static struct perf_sample synth_sample = {
 	.pid	   = -1,
 	.tid	   = -1,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 9c35170..c083328 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,6 +56,13 @@ struct read_event {
 	u64 id;
 };
 
+
+#define PERF_SAMPLE_MASK				\
+	(PERF_SAMPLE_IP | PERF_SAMPLE_TID |		\
+	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |		\
+	PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |	\
+	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD)
+
 struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
@@ -75,6 +82,8 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 };
 
+int perf_sample_size(u64 sample_type);
+
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
@@ -178,6 +187,7 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *sample);
+			     int sample_size, bool sample_id_all,
+			     struct perf_sample *sample);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 23eb22b..50aa348 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -459,3 +459,34 @@ int perf_evlist__set_filters(struct perf_evlist *evlist)
 
 	return 0;
 }
+
+u64 perf_evlist__sample_type(struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos;
+	u64 type = 0;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (!type)
+			type = pos->attr.sample_type;
+		else if (type != pos->attr.sample_type)
+			die("non matching sample_type");
+	}
+
+	return type;
+}
+
+bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
+{
+	bool value = false, first = true;
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (first) {
+			value = pos->attr.sample_id_all;
+			first = false;
+		} else if (value != pos->attr.sample_id_all)
+			die("non matching sample_id_all");
+	}
+
+	return value;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7109d7a..0a1ef1f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -66,4 +66,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist, pid_t target_pid,
 void perf_evlist__delete_maps(struct perf_evlist *evlist);
 int perf_evlist__set_filters(struct perf_evlist *evlist);
 
+u64 perf_evlist__sample_type(struct perf_evlist *evlist);
+bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d6fd59b..ee0fe0d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -303,8 +303,20 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	return 0;
 }
 
+static bool sample_overlap(const union perf_event *event,
+			   const void *offset, u64 size)
+{
+	const void *base = event;
+
+	if (offset + size > base + event->header.size)
+		return true;
+
+	return false;
+}
+
 int perf_event__parse_sample(const union perf_event *event, u64 type,
-			     bool sample_id_all, struct perf_sample *data)
+			     int sample_size, bool sample_id_all,
+			     struct perf_sample *data)
 {
 	const u64 *array;
 
@@ -319,6 +331,9 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 
 	array = event->sample.array;
 
+	if (sample_size + sizeof(event->header) > event->header.size)
+		return -EFAULT;
+
 	if (type & PERF_SAMPLE_IP) {
 		data->ip = event->ip.ip;
 		array++;
@@ -369,14 +384,29 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
+		if (sample_overlap(event, array, sizeof(data->callchain->nr)))
+			return -EFAULT;
+
 		data->callchain = (struct ip_callchain *)array;
+
+		if (sample_overlap(event, array, data->callchain->nr))
+			return -EFAULT;
+
 		array += 1 + data->callchain->nr;
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
 		u32 *p = (u32 *)array;
+
+		if (sample_overlap(event, array, sizeof(u32)))
+			return -EFAULT;
+
 		data->raw_size = *p;
 		p++;
+
+		if (sample_overlap(event, p, data->raw_size))
+			return -EFAULT;
+
 		data->raw_data = p;
 	}
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 93862a8..0717beb 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -934,37 +934,6 @@ out_delete_evlist:
 	return -ENOMEM;
 }
 
-u64 perf_evlist__sample_type(struct perf_evlist *evlist)
-{
-	struct perf_evsel *pos;
-	u64 type = 0;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (!type)
-			type = pos->attr.sample_type;
-		else if (type != pos->attr.sample_type)
-			die("non matching sample_type");
-	}
-
-	return type;
-}
-
-bool perf_evlist__sample_id_all(const struct perf_evlist *evlist)
-{
-	bool value = false, first = true;
-	struct perf_evsel *pos;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (first) {
-			value = pos->attr.sample_id_all;
-			first = false;
-		} else if (value != pos->attr.sample_id_all)
-			die("non matching sample_id_all");
-	}
-
-	return value;
-}
-
 int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process,
 				struct perf_session *session)
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 456661d..1886256 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -64,8 +64,6 @@ int perf_header__write_pipe(int fd);
 int perf_header__push_event(u64 id, const char *name);
 char *perf_header__find_event(u64 id);
 
-u64 perf_evlist__sample_type(struct perf_evlist *evlist);
-bool perf_evlist__sample_id_all(const struct perf_evlist *evlist);
 void perf_header__set_feat(struct perf_header *header, int feat);
 void perf_header__clear_feat(struct perf_header *header, int feat);
 bool perf_header__has_feat(const struct perf_header *header, int feat);
diff --git a/tools/perf/util/include/linux/list.h b/tools/perf/util/include/linux/list.h
index 356c7e4..ed33609 100644
--- a/tools/perf/util/include/linux/list.h
+++ b/tools/perf/util/include/linux/list.h
@@ -1,4 +1,6 @@
 #include <linux/kernel.h>
+#include <linux/prefetch.h>
+
 #include "../../../../include/linux/list.h"
 
 #ifndef PERF_LIST_H
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index b5c7d81..69436b3 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -675,6 +675,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
 	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
 					 &cpu, &sample_id_all))
@@ -690,11 +691,17 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 			return PyErr_NoMemory();
 
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
-		perf_event__parse_sample(event, first->attr.sample_type, sample_id_all,
-					 &pevent->sample);
+		err = perf_event__parse_sample(event, first->attr.sample_type,
+					       perf_sample_size(first->attr.sample_type),
+					       sample_id_all, &pevent->sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto end;
+		}
+
 		return pyevent;
 	}
-
+end:
 	Py_INCREF(Py_None);
 	return Py_None;
 }
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index fff6674..64500fc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -97,6 +97,7 @@ out:
 void perf_session__update_sample_type(struct perf_session *self)
 {
 	self->sample_type = perf_evlist__sample_type(self->evlist);
+	self->sample_size = perf_sample_size(self->sample_type);
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	perf_session__id_header_size(self);
 }
@@ -479,6 +480,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	int ret;
 
 	if (!ops->ordered_samples || !limit)
 		return;
@@ -487,9 +489,12 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		perf_session__parse_sample(s, iter->event, &sample);
-		perf_session_deliver_event(s, iter->event, &sample, ops,
-					   iter->file_offset);
+		ret = perf_session__parse_sample(s, iter->event, &sample);
+		if (ret)
+			pr_err("Can't parse sample, err = %d\n", ret);
+		else
+			perf_session_deliver_event(s, iter->event, &sample, ops,
+						   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -805,7 +810,9 @@ static int perf_session__process_event(struct perf_session *session,
 	/*
 	 * For all kernel events we get the sample data
 	 */
-	perf_session__parse_sample(session, event, &sample);
+	ret = perf_session__parse_sample(session, event, &sample);
+	if (ret)
+		return ret;
 
 	/* Preprocess sample records - precheck callchains */
 	if (perf_session__preprocess_sample(session, event, &sample))
@@ -953,6 +960,30 @@ out_err:
 	return err;
 }
 
+static union perf_event *
+fetch_mmaped_event(struct perf_session *session,
+		   u64 head, size_t mmap_size, char *buf)
+{
+	union perf_event *event;
+
+	/*
+	 * Ensure we have enough space remaining to read
+	 * the size of the event in the headers.
+	 */
+	if (head + sizeof(event->header) > mmap_size)
+		return NULL;
+
+	event = (union perf_event *)(buf + head);
+
+	if (session->header.needs_swap)
+		perf_event_header__bswap(&event->header);
+
+	if (head + event->header.size > mmap_size)
+		return NULL;
+
+	return event;
+}
+
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_event_ops *ops)
@@ -1007,15 +1038,8 @@ remap:
 	file_pos = file_offset + head;
 
 more:
-	event = (union perf_event *)(buf + head);
-
-	if (session->header.needs_swap)
-		perf_event_header__bswap(&event->header);
-	size = event->header.size;
-	if (size == 0)
-		size = 8;
-
-	if (head + event->header.size > mmap_size) {
+	event = fetch_mmaped_event(session, head, mmap_size, buf);
+	if (!event) {
 		if (mmaps[map_idx]) {
 			munmap(mmaps[map_idx], mmap_size);
 			mmaps[map_idx] = NULL;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8daaa2d..66d4e14 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -43,6 +43,7 @@ struct perf_session {
 	 */
 	struct hists		hists;
 	u64			sample_type;
+	int			sample_size;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -159,6 +160,7 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     struct perf_sample *sample)
 {
 	return perf_event__parse_sample(event, session->sample_type,
+					session->sample_size,
 					session->sample_id_all, sample);
 }
 
