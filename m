Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2HPTyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:54:35 -0400
Received: from [216.32.180.14] ([216.32.180.14]:52371 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933238Ab2HPTyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:54:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8V5WR-02-ED2-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/8] perf report: Update event names from header description
Date: Thu, 16 Aug 2012 21:10:23 +0200
Message-ID: <1345144224-27280-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name events based on the event description in the perf.data header.

Example output:

 $ perf report | grep '^#.*event'
 # event : name = ibs_op/cnt_ctl=1/GH, type = 7, config = 0x80000, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 0, precise_ip = 0, id = { 49, 50, 51, 52, 53, 54, 55, 56 }
 # event : name = ibs_fetch/config=0/, type = 6, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0, id = { 57, 58, 59, 60, 61, 62, 63, 64 }
 # Samples: 20K of event 'ibs_op/cnt_ctl=1/GH'
 # Samples: 4K of event 'ibs_fetch/config=0/'

Note the new pmu event syntax of the names.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7454cf4..c0311b3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1556,6 +1556,56 @@ static int process_build_id(struct perf_file_section *section,
 	return 0;
 }
 
+static struct perf_evsel *
+perf_evlist_find_by_index(struct perf_evlist *evlist, int idx)
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
+	evsel = perf_evlist_find_by_index(evlist, event->idx);
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
1.7.8.6


