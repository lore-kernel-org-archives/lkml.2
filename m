Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1DUJY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:24:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:40927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab1DUJY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:24:56 -0400
Date: Thu, 21 Apr 2011 09:24:35 GMT
From: tip-bot for David Ahern <daahern@cisco.com>
Message-ID: <tip-9cbdb702092a2d82f909312f4ec3eeded77bb82e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <1302148460-570-1-git-send-email-daahern@cisco.com>
References: <1302148460-570-1-git-send-email-daahern@cisco.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: improve validation of sample attributes for output fields
Git-Commit-ID: 9cbdb702092a2d82f909312f4ec3eeded77bb82e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9cbdb702092a2d82f909312f4ec3eeded77bb82e
Gitweb:     http://git.kernel.org/tip/9cbdb702092a2d82f909312f4ec3eeded77bb82e
Author:     David Ahern <daahern@cisco.com>
AuthorDate: Wed, 6 Apr 2011 21:54:20 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 20 Apr 2011 07:27:52 -0300

perf script: improve validation of sample attributes for output fields

Check for required sample attributes using evsel rather than sample_type
in the session header. If the attribute for a default field is not
present for the event type (e.g., new command operating on file from
older kernel) the field is removed from the output list.

Expected event types must exist. For example, if a user specifies

  -f trace:time,trace -f sw:time,cpu,sym

the perf.data file must contain both tracepoints and software events
(ie., it is an error if either does not exist in the file).

Attribute checking is done once at the beginning of perf-script rather
than for each sample.

v1 -> v2:
- addressed comments from acme

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1302148460-570-1-git-send-email-daahern@cisco.com
Signed-off-by: David Ahern <daahern@cisco.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |  111 ++++++++++++++++++++++++++++++++++++-------
 tools/perf/util/session.c   |   12 +++++
 tools/perf/util/session.h   |    3 +
 3 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b3012c4..974f6d3 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -51,6 +51,7 @@ struct output_option {
 /* default set to maintain compatibility with current format */
 static struct {
 	bool user_set;
+	bool wildcard_set;
 	u64 fields;
 	u64 invalid_fields;
 } output[PERF_TYPE_MAX] = {
@@ -104,41 +105,113 @@ static bool output_set_by_user(void)
 	return false;
 }
 
+static const char *output_field2str(enum perf_output_field field)
+{
+	int i, imax = ARRAY_SIZE(all_output_options);
+	const char *str = "";
+
+	for (i = 0; i < imax; ++i) {
+		if (all_output_options[i].field == field) {
+			str = all_output_options[i].str;
+			break;
+		}
+	}
+	return str;
+}
+
 #define PRINT_FIELD(x)  (output[attr->type].fields & PERF_OUTPUT_##x)
 
-static int perf_session__check_attr(struct perf_session *session,
-				    struct perf_event_attr *attr)
+static int perf_event_attr__check_stype(struct perf_event_attr *attr,
+				  u64 sample_type, const char *sample_msg,
+				  enum perf_output_field field)
 {
+	int type = attr->type;
+	const char *evname;
+
+	if (attr->sample_type & sample_type)
+		return 0;
+
+	if (output[type].user_set) {
+		evname = __event_name(attr->type, attr->config);
+		pr_err("Samples for '%s' event do not have %s attribute set. "
+		       "Cannot print '%s' field.\n",
+		       evname, sample_msg, output_field2str(field));
+		return -1;
+	}
+
+	/* user did not ask for it explicitly so remove from the default list */
+	output[type].fields &= ~field;
+	evname = __event_name(attr->type, attr->config);
+	pr_debug("Samples for '%s' event do not have %s attribute set. "
+		 "Skipping '%s' field.\n",
+		 evname, sample_msg, output_field2str(field));
+
+	return 0;
+}
+
+static int perf_evsel__check_attr(struct perf_evsel *evsel,
+				  struct perf_session *session)
+{
+	struct perf_event_attr *attr = &evsel->attr;
+
 	if (PRINT_FIELD(TRACE) &&
 		!perf_session__has_traces(session, "record -R"))
 		return -EINVAL;
 
 	if (PRINT_FIELD(SYM)) {
-		if (!(session->sample_type & PERF_SAMPLE_IP)) {
-			pr_err("Samples do not contain IP data.\n");
+		if (perf_event_attr__check_stype(attr, PERF_SAMPLE_IP, "IP",
+					   PERF_OUTPUT_SYM))
 			return -EINVAL;
-		}
+
 		if (!no_callchain &&
-		    !(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
 			symbol_conf.use_callchain = false;
 	}
 
 	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
-		!(session->sample_type & PERF_SAMPLE_TID)) {
-		pr_err("Samples do not contain TID/PID data.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_TID, "TID",
+				       PERF_OUTPUT_TID|PERF_OUTPUT_PID))
 		return -EINVAL;
-	}
 
 	if (PRINT_FIELD(TIME) &&
-		!(session->sample_type & PERF_SAMPLE_TIME)) {
-		pr_err("Samples do not contain timestamps.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "TIME",
+				       PERF_OUTPUT_TIME))
 		return -EINVAL;
-	}
 
 	if (PRINT_FIELD(CPU) &&
-		!(session->sample_type & PERF_SAMPLE_CPU)) {
-		pr_err("Samples do not contain cpu.\n");
+		perf_event_attr__check_stype(attr, PERF_SAMPLE_CPU, "CPU",
+				       PERF_OUTPUT_CPU))
 		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * verify all user requested events exist and the samples
+ * have the expected data
+ */
+static int perf_session__check_output_opt(struct perf_session *session)
+{
+	int j;
+	struct perf_evsel *evsel;
+
+	for (j = 0; j < PERF_TYPE_MAX; ++j) {
+		evsel = perf_session__find_first_evtype(session, j);
+
+		/*
+		 * even if fields is set to 0 (ie., show nothing) event must
+		 * exist if user explicitly includes it on the command line
+		 */
+		if (!evsel && output[j].user_set && !output[j].wildcard_set) {
+			pr_err("%s events do not exist. "
+			       "Remove corresponding -f option to proceed.\n",
+			       event_type(j));
+			return -1;
+		}
+
+		if (evsel && output[j].fields &&
+			perf_evsel__check_attr(evsel, session))
+			return -1;
 	}
 
 	return 0;
@@ -210,9 +283,6 @@ static void process_event(union perf_event *event __unused,
 	if (output[attr->type].fields == 0)
 		return;
 
-	if (perf_session__check_attr(session, attr) < 0)
-		return;
-
 	print_sample_start(sample, thread, attr);
 
 	if (PRINT_FIELD(TRACE))
@@ -525,6 +595,7 @@ static int parse_output_fields(const struct option *opt __used,
 
 		output[type].fields = 0;
 		output[type].user_set = true;
+		output[type].wildcard_set = false;
 
 	} else {
 		tok = str;
@@ -541,6 +612,7 @@ static int parse_output_fields(const struct option *opt __used,
 		for (j = 0; j < PERF_TYPE_MAX; ++j) {
 			output[j].fields = 0;
 			output[j].user_set = true;
+			output[j].wildcard_set = true;
 		}
 	}
 
@@ -1145,6 +1217,11 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 		pr_debug("perf script started with script %s\n\n", script_name);
 	}
 
+
+	err = perf_session__check_output_opt(session);
+	if (err < 0)
+		goto out;
+
 	err = __cmd_script(session);
 
 	perf_session__delete(session);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index caa2245..fff6674 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1156,6 +1156,18 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	return ret;
 }
 
+struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
+					      unsigned int type)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		if (pos->attr.type == type)
+			return pos;
+	}
+	return NULL;
+}
+
 void perf_session__print_symbols(union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_session *session)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 1ac481f..8daaa2d 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -162,6 +162,9 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					session->sample_id_all, sample);
 }
 
+struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
+					    unsigned int type);
+
 void perf_session__print_symbols(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_session *session);
