Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2H0Q4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:56:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2H0Q41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:56:27 -0400
Date: Mon, 27 Aug 2012 09:56:07 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-7c2f7afd36cc111dd08eb8eb8ef74fb6564fd131@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1345144224-27280-8-git-send-email-robert.richter@amd.com>
References: <1345144224-27280-8-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Update event names from header description
Git-Commit-ID: 7c2f7afd36cc111dd08eb8eb8ef74fb6564fd131
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:56:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c2f7afd36cc111dd08eb8eb8ef74fb6564fd131
Gitweb:     http://git.kernel.org/tip/7c2f7afd36cc111dd08eb8eb8ef74fb6564fd131
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 16 Aug 2012 21:10:23 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 13:47:17 -0300

perf report: Update event names from header description

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
