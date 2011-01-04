Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1ADI1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:27:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:49139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1ADI1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:27:50 -0500
Date: Tue, 4 Jan 2011 08:27:27 GMT
From: tip-bot for Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, j-pihet@ti.com, trenn@suse.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, j-pihet@ti.com, tglx@linutronix.de,
        trenn@suse.de, mingo@elte.hu
In-Reply-To: <1294073445-14812-4-git-send-email-trenn@suse.de>
References: <1294073445-14812-4-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Adjust perf timechart to the new power events
Message-ID: <tip-20c457b8587bee4644d998331d9e13be82e05b4c@git.kernel.org>
Git-Commit-ID: 20c457b8587bee4644d998331d9e13be82e05b4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:27:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20c457b8587bee4644d998331d9e13be82e05b4c
Gitweb:     http://git.kernel.org/tip/20c457b8587bee4644d998331d9e13be82e05b4c
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Mon, 3 Jan 2011 17:50:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Jan 2011 08:16:54 +0100

perf timechart: Adjust perf timechart to the new power events

builtin-timechart must only pass -e power:xy events if they are supported by
the running kernel, otherwise try to fetch the old power:power{start,end}
events.

For this I added the tiny helper function:

   int is_valid_tracepoint(const char *event_string)

to parse-events.[hc], which could be more generic as an interface and support
hardware/software/... events, not only tracepoints, but someone else could
extend that if needed...

Signed-off-by: Thomas Renninger <trenn@suse.de>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Jean Pihet <j-pihet@ti.com>
LKML-Reference: <1294073445-14812-4-git-send-email-trenn@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-timechart.c |   94 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/parse-events.c |   41 +++++++++++++++++
 tools/perf/util/parse-events.h |    1 +
 3 files changed, 118 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index d75084b..746cf03 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -32,6 +32,10 @@
 #include "util/session.h"
 #include "util/svghelper.h"
 
+#define SUPPORT_OLD_POWER_EVENTS 1
+#define PWR_EVENT_EXIT -1
+
+
 static char		const *input_name = "perf.data";
 static char		const *output_name = "output.svg";
 
@@ -301,12 +305,21 @@ struct trace_entry {
 	int			lock_depth;
 };
 
-struct power_entry {
+#ifdef SUPPORT_OLD_POWER_EVENTS
+static int use_old_power_events;
+struct power_entry_old {
 	struct trace_entry te;
 	u64	type;
 	u64	value;
 	u64	cpu_id;
 };
+#endif
+
+struct power_processor_entry {
+	struct trace_entry te;
+	u32	state;
+	u32	cpu_id;
+};
 
 #define TASK_COMM_LEN 16
 struct wakeup_entry {
@@ -489,29 +502,49 @@ static int process_sample_event(event_t *event __used,
 	te = (void *)sample->raw_data;
 	if (session->sample_type & PERF_SAMPLE_RAW && sample->raw_size > 0) {
 		char *event_str;
-		struct power_entry *pe;
-
-		pe = (void *)te;
-
+#ifdef SUPPORT_OLD_POWER_EVENTS
+		struct power_entry_old *peo;
+		peo = (void *)te;
+#endif
 		event_str = perf_header__find_event(te->type);
 
 		if (!event_str)
 			return 0;
 
-		if (strcmp(event_str, "power:power_start") == 0)
-			c_state_start(pe->cpu_id, sample->time, pe->value);
-
-		if (strcmp(event_str, "power:power_end") == 0)
-			c_state_end(pe->cpu_id, sample->time);
-
-		if (strcmp(event_str, "power:power_frequency") == 0)
-			p_state_change(pe->cpu_id, sample->time, pe->value);
+		if (strcmp(event_str, "power:cpu_idle") == 0) {
+			struct power_processor_entry *ppe = (void *)te;
+			if (ppe->state == (u32)PWR_EVENT_EXIT)
+				c_state_end(ppe->cpu_id, sample->time);
+			else
+				c_state_start(ppe->cpu_id, sample->time,
+					      ppe->state);
+		}
+		else if (strcmp(event_str, "power:cpu_frequency") == 0) {
+			struct power_processor_entry *ppe = (void *)te;
+			p_state_change(ppe->cpu_id, sample->time, ppe->state);
+		}
 
-		if (strcmp(event_str, "sched:sched_wakeup") == 0)
+		else if (strcmp(event_str, "sched:sched_wakeup") == 0)
 			sched_wakeup(sample->cpu, sample->time, sample->pid, te);
 
-		if (strcmp(event_str, "sched:sched_switch") == 0)
+		else if (strcmp(event_str, "sched:sched_switch") == 0)
 			sched_switch(sample->cpu, sample->time, te);
+
+#ifdef SUPPORT_OLD_POWER_EVENTS
+		if (use_old_power_events) {
+			if (strcmp(event_str, "power:power_start") == 0)
+				c_state_start(peo->cpu_id, sample->time,
+					      peo->value);
+
+			else if (strcmp(event_str, "power:power_end") == 0)
+				c_state_end(sample->cpu, sample->time);
+
+			else if (strcmp(event_str,
+					"power:power_frequency") == 0)
+				p_state_change(peo->cpu_id, sample->time,
+					       peo->value);
+		}
+#endif
 	}
 	return 0;
 }
@@ -969,7 +1002,8 @@ static const char * const timechart_usage[] = {
 	NULL
 };
 
-static const char *record_args[] = {
+#ifdef SUPPORT_OLD_POWER_EVENTS
+static const char * const record_old_args[] = {
 	"record",
 	"-a",
 	"-R",
@@ -981,19 +1015,43 @@ static const char *record_args[] = {
 	"-e", "sched:sched_wakeup",
 	"-e", "sched:sched_switch",
 };
+#endif
+
+static const char * const record_new_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-f",
+	"-c", "1",
+	"-e", "power:cpu_frequency",
+	"-e", "power:cpu_idle",
+	"-e", "sched:sched_wakeup",
+	"-e", "sched:sched_switch",
+};
 
 static int __cmd_record(int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
+	const char * const *record_args = record_new_args;
+	unsigned int record_elems = ARRAY_SIZE(record_new_args);
+
+#ifdef SUPPORT_OLD_POWER_EVENTS
+	if (!is_valid_tracepoint("power:cpu_idle") &&
+	    is_valid_tracepoint("power:power_start")) {
+		use_old_power_events = 1;
+		record_args = record_old_args;
+		record_elems = ARRAY_SIZE(record_old_args);
+	}
+#endif
 
-	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argc = record_elems + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+	for (i = 0; i < record_elems; i++)
 		rec_argv[i] = strdup(record_args[i]);
 
 	for (j = 1; j < (unsigned int)argc; j++, i++)
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3a142e9..649083f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -913,6 +913,47 @@ static void print_tracepoint_events(void)
 }
 
 /*
+ * Check whether event is in <debugfs_mount_point>/tracing/events
+ */
+
+int is_valid_tracepoint(const char *event_string)
+{
+	DIR *sys_dir, *evt_dir;
+	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
+	char evt_path[MAXPATHLEN];
+	char dir_path[MAXPATHLEN];
+
+	if (debugfs_valid_mountpoint(debugfs_path))
+		return 0;
+
+	sys_dir = opendir(debugfs_path);
+	if (!sys_dir)
+		return 0;
+
+	for_each_subsystem(sys_dir, sys_dirent, sys_next) {
+
+		snprintf(dir_path, MAXPATHLEN, "%s/%s", debugfs_path,
+			 sys_dirent.d_name);
+		evt_dir = opendir(dir_path);
+		if (!evt_dir)
+			continue;
+
+		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next) {
+			snprintf(evt_path, MAXPATHLEN, "%s:%s",
+				 sys_dirent.d_name, evt_dirent.d_name);
+			if (!strcmp(evt_path, event_string)) {
+				closedir(evt_dir);
+				closedir(sys_dir);
+				return 1;
+			}
+		}
+		closedir(evt_dir);
+	}
+	closedir(sys_dir);
+	return 0;
+}
+
+/*
  * Print the help text for the event symbols:
  */
 void print_events(void)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 0a0abc1..1c9043c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -36,6 +36,7 @@ extern int parse_filter(const struct option *opt, const char *str, int unset);
 #define EVENTS_HELP_MAX (128*1024)
 
 extern void print_events(void);
+extern int is_valid_tracepoint(const char *event_string);
 
 extern char debugfs_path[];
 extern int valid_debugfs_mount(const char *debugfs);
