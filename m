Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1CTSy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:54:59 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:27121 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1CTSyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:49 -0400
X-IronPort-AV: E=Sophos;i="4.63,215,1299456000"; 
   d="scan'208";a="278221363"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 4/5] perf script: add support for time-of-day strings in output
Date: Sun, 20 Mar 2011 12:54:36 -0600
Message-Id: <1300647277-8431-5-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300647277-8431-1-git-send-email-daahern@cisco.com>
References: <1300647277-8431-1-git-send-email-daahern@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Format of time-of-day strings handled through strftime. Any format
recognized by it can be used. Default format is %H:%M:%S with
microseconds appended.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/Documentation/perf-script.txt |    8 +++-
 tools/perf/builtin-script.c              |   84 +++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 66f040b..9f04caa 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, sym. Field
+        tod, comm, tid, pid, time, cpu, event, trace, sym. Field
         list must be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,sym  and -f trace:time,cpu,trace
@@ -134,6 +134,12 @@ OPTIONS
 --hide-call-graph::
         When printing symbols do not display call chain.
 
+--tod::
+        Format for time-of-day strings. Format string is passed to
+        strftime, so any format recognized by it can be used (see
+        man strftime). Default format is "%H:%M:%S". Microseocnds
+        are appended to the time string.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9f5fc54..72c9a34 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -22,6 +22,8 @@ static u64			last_timestamp;
 static u64			nr_unordered;
 extern const struct option	record_options[];
 static bool			no_callchain;
+static char default_tod_fmt[] = "%H:%M:%S";
+static char *tod_fmt = default_tod_fmt;
 
 enum perf_output_field {
 	PERF_OUTPUT_COMM            = 1U << 0,
@@ -32,6 +34,7 @@ enum perf_output_field {
 	PERF_OUTPUT_EVNAME          = 1U << 5,
 	PERF_OUTPUT_TRACE           = 1U << 6,
 	PERF_OUTPUT_SYM             = 1U << 7,
+	PERF_OUTPUT_TIMEOFDAY       = 1U << 8,
 };
 
 struct output_option {
@@ -46,6 +49,7 @@ struct output_option {
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
 	{.str = "trace", .field = PERF_OUTPUT_TRACE},
 	{.str = "sym",   .field = PERF_OUTPUT_SYM},
+	{.str = "tod",   .field = PERF_OUTPUT_TIMEOFDAY},
 };
 
 /* default set to maintain compatibility with current format */
@@ -102,9 +106,35 @@ static int perf_session__check_attr(struct perf_session *session,
 		return -EINVAL;
 	}
 
+	if (PRINT_FIELD(TIMEOFDAY) &&
+		!(session->sample_type & PERF_SAMPLE_REALTIME)) {
+		pr_err("Samples do not contain realtime attribute.\n");
+		pr_err("Was --tod used with perf-record?\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
+static const char *timeofday_str(u64 realtime)
+{
+	static char buf[64];
+	struct tm ltime;
+	struct timeval tv;
+
+	buf[0] = '\0';
+
+	tv.tv_sec = realtime / NSEC_PER_SEC;
+	tv.tv_usec = (realtime - tv.tv_sec * NSEC_PER_SEC) / 1000;
+	if (localtime_r(&tv.tv_sec, &ltime) != NULL) {
+		char date[128];
+		strftime(date, sizeof(date), tod_fmt, &ltime);
+		snprintf(buf, sizeof(buf), "%s.%06ld", date, tv.tv_usec);
+	}
+
+	return buf;
+}
+
 static void print_sample_start(struct perf_sample *sample,
 			       struct thread *thread,
 			       struct perf_event_attr *attr)
@@ -116,6 +146,9 @@ static void print_sample_start(struct perf_sample *sample,
 	unsigned long usecs;
 	unsigned long long nsecs;
 
+	if (PRINT_FIELD(TIMEOFDAY))
+		printf("%s ", timeofday_str(sample->realtime));
+
 	if (PRINT_FIELD(COMM)) {
 		if (latency_format)
 			printf("%8.8s ", thread->comm);
@@ -515,6 +548,49 @@ static int parse_output_fields(const struct option *opt __used,
 	return rc;
 }
 
+static int parse_tod_format(const struct option *opt __used,
+			    const char *arg, int unset __used)
+{
+	int i;
+	char date[128];
+	size_t rc;
+	struct tm ltime;
+
+	if (strlen(arg) == 0) {
+		pr_debug("Time-of-day strings will be suppressed\n");
+		goto out;
+	}
+
+	/* test input string for validity and length of output */
+	localtime_r(0, &ltime);
+	rc = strftime(date, sizeof(date), arg, &ltime);
+	if (rc == 0) {
+		fprintf(stderr, "Invalid format string for time-of-day\n");
+		return -EINVAL;
+	}
+
+out:
+	for (i = 0; i < PERF_TYPE_MAX; ++i) {
+		if (output_fields[i] == 0)
+			continue;
+		if (strlen(arg))
+			output_fields[i] |= PERF_OUTPUT_TIMEOFDAY;
+		else
+			output_fields[i] &= ~PERF_OUTPUT_TIMEOFDAY;
+	}
+
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
+
+	tod_fmt = strdup(arg);
+	if (!tod_fmt) {
+		fprintf(stderr, "Failed to copy time-of-day format string\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 /* Helper function for filesystems that return a dent->d_type DT_UNKNOWN */
 static int is_directory(const char *base_path, const struct dirent *dent)
 {
@@ -836,8 +912,11 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_CALLBACK('f', "fields", NULL, "str",
-		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: comm,tid,pid,time,cpu,event,trace,sym",
+		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace. Fields: tod,comm,tid,pid,time,cpu,event,trace,sym",
 		     parse_output_fields),
+	OPT_CALLBACK(0, "tod", NULL, "str",
+		     "Format for time-of-day strings. Option is passed to strftime; microseconds are appended. Default is %H:%M:%S.",
+		     parse_tod_format),
 
 	OPT_END()
 };
@@ -1071,6 +1150,9 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 
 	perf_session__delete(session);
 	cleanup_scripting();
+
+	if (tod_fmt != default_tod_fmt)
+		free(tod_fmt);
 out:
 	return err;
 }
-- 
1.7.4

