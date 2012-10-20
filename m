Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2JTOd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:33:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab2JTOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/11] perf tool: Add PERF_SAMPLE_READ sample related processing
Date: Sat, 20 Oct 2012 16:33:15 +0200
Message-Id: <1350743599-4805-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sample with sample type PERF_SAMPLE_READ the period value is
stored in the 'struct sample_read'.

Moreover if the read format has PERF_FORMAT_GROUP, the 'struct
sample_read' contains period values for all events in the group
(for which the sample's event is a leader).

We deliver separated samples for all the values contained
within the 'struct sample_read'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.h   |  3 ++
 tools/perf/util/session.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8d5937d..351b48e 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -36,6 +36,9 @@ struct perf_sample_id {
 	struct hlist_node 	node;
 	u64		 	id;
 	struct perf_evsel	*evsel;
+
+	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
+	u64			period;
 };
 
 /** struct perf_evsel - event selector
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ceb3fe2..34e226c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1068,6 +1068,75 @@ static struct machine *
 	return perf_session__find_host_machine(session);
 }
 
+static int deliver_sample_value(struct perf_session *session,
+				struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct sample_read_value *v,
+				struct machine *machine)
+{
+	struct perf_sample_id *sid;
+
+	sid = perf_evlist__id2sid(session->evlist, v->id);
+	if (sid) {
+		sample->id     = v->id;
+		sample->period = v->value - sid->period;
+		sid->period    = v->value;
+	}
+
+	if (!sid || sid->evsel == NULL) {
+		++session->hists.stats.nr_unknown_id;
+		return 0;
+	}
+
+	return tool->sample(tool, event, sample, sid->evsel, machine);
+}
+
+static int deliver_sample_group(struct perf_session *session,
+				struct perf_tool *tool,
+				union  perf_event *event,
+				struct perf_sample *sample,
+				struct machine *machine)
+{
+	int ret = -EINVAL;
+	u64 i;
+
+	for (i = 0; i < sample->read.group.nr; i++) {
+		ret = deliver_sample_value(session, tool, event, sample,
+					   &sample->read.group.values[i],
+					   machine);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int
+perf_session__deliver_sample(struct perf_session *session,
+			     struct perf_tool *tool,
+			     union  perf_event *event,
+			     struct perf_sample *sample,
+			     struct perf_evsel *evsel,
+			     struct machine *machine)
+{
+	/* We know evsel != NULL. */
+	u64 sample_type = evsel->attr.sample_type;
+	u64 read_format = evsel->attr.read_format;
+
+	/* Standard sample delievery. */
+	if (!(sample_type & PERF_SAMPLE_READ))
+		return tool->sample(tool, event, sample, evsel, machine);
+
+	/* For PERF_SAMPLE_READ we have either single or group mode. */
+	if (read_format & PERF_FORMAT_GROUP)
+		return deliver_sample_group(session, tool, event, sample,
+					    machine);
+	else
+		return deliver_sample_value(session, tool, event, sample,
+					    &sample->read.one, machine);
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
@@ -1110,7 +1179,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unprocessable_samples;
 			return 0;
 		}
-		return tool->sample(tool, event, sample, evsel, machine);
+		return perf_session__deliver_sample(session, tool, event,
+						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
-- 
1.7.11.4

