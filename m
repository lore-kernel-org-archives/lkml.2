Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2HWPKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:10:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:57449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab2HWPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:10:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf report: Update event names from header description
Date: Thu, 23 Aug 2012 12:09:49 -0300
Message-Id: <1345734596-7601-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345734596-7601-1-git-send-email-acme@infradead.org>
References: <1345734596-7601-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Name events based on the event description in the perf.data header.

Example output:

 $ perf report | grep '^#.*event'
 # event : name = ibs_op/cnt_ctl=1/GH, type = 7, config = 0x80000, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 0, id = { 49, 50, 51, 52, 53, 54, 55, 56 }
 # event : name = ibs_fetch/config=0/, type = 6, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, id = { 57, 58, 59, 60, 61, 62, 63, 64 }
 # Samples: 20K of event 'ibs_op/cnt_ctl=1/GH'
 # Samples: 4K of event 'ibs_fetch/config=0/'

Note the new pmu event syntax of the names.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345144224-27280-8-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7454cf4..69374de 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1556,6 +1556,56 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
+static struct perf_evsel *
+perf_evlist__find_by_index(struct perf_evlist *evlist, int idx)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->idx == idx)
+			return evsel;
+	}
+
+	return NULL;
+}
+
+static void
+perf_evlist__set_event_name(struct perf_evlist *evlist, struct perf_evsel *event)
+{
+	struct perf_evsel *evsel;
+
+	if (!event->name)
+		return;
+
+	evsel = perf_evlist__find_by_index(evlist, event->idx);
+	if (!evsel)
+		return;
+
+	if (evsel->name)
+		return;
+
+	evsel->name = strdup(event->name);
+}
+
+static int
+process_event_desc(struct perf_file_section *section __unused,
+		   struct perf_header *header, int feat __unused, int fd,
+		   void *data __used)
+{
+	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct perf_evsel *evsel, *events = read_event_desc(header, fd);
+
+	if (!events)
+		return 0;
+
+	for (evsel = events; evsel->attr.size; evsel++)
+		perf_evlist__set_event_name(session->evlist, evsel);
+
+	free_event_desc(events);
+
+	return 0;
+}
+
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
@@ -1589,7 +1639,7 @@ static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
 	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
 	FEAT_OPA(HEADER_CPUID,		cpuid),
 	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
-	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
+	FEAT_OPP(HEADER_EVENT_DESC,	event_desc),
 	FEAT_OPA(HEADER_CMDLINE,	cmdline),
 	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
 	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
-- 
1.7.1

