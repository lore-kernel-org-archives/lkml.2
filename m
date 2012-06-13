Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2FMP3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:29:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2FMP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:29:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf tools: Fix synthesizing tracepoint names from the perf.data headers
Date: Wed, 13 Jun 2012 12:29:27 -0300
Message-Id: <1339601367-17834-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1339601367-17834-1-git-send-email-acme@infradead.org>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We need to use the per event info snapshoted at record time to
synthesize the events name, so do it just after reading the perf.data
headers, when we already processed the /sys events data, otherwise we'll
end up using the local /sys that only by sheer luck will have the same
tracepoint ID -> real event association.

Example:

  # uname -a
  Linux felicio.ghostprotocols.net 3.4.0-rc5+ #1 SMP Sat May 19 15:27:11 BRT 2012 x86_64 x86_64 x86_64 GNU/Linux
  # perf record -e sched:sched_switch usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.015 MB perf.data (~648 samples) ]
  # cat /t/events/sched/sched_switch/id
  279
  # perf evlist -v
  sched:sched_switch: sample_freq=1, type: 2, config: 279, size: 80, sample_type: 1159, read_format: 7, disabled: 1, inherit: 1, mmap: 1, comm: 1, enable_on_exec: 1, sample_id_all: 1, exclude_guest: 1
  #

So on the above machine the sched:sched_switch has tracepoint id 279, but on
the machine were we'll analyse it it has a different id:

  $ cat /t/events/sched/sched_switch/id
  56
  $ perf evlist -i /tmp/perf.data
  kmem:mm_balancedirty_writeout
  $ cat /t/events/kmem/mm_balancedirty_writeout/id
  279

With this fix:

  $ perf evlist -i /tmp/perf.data
  sched:sched_switch

Reported-by: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-auwks8fpuhmrdpiefs55o5oz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4f9b247..e909d43 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2093,6 +2093,35 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
+static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel)
+{
+	struct event_format *event = trace_find_event(evsel->attr.config);
+	char bf[128];
+
+	if (event == NULL)
+		return -1;
+
+	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+	evsel->name = strdup(bf);
+	if (event->name == NULL)
+		return -1;
+
+	return 0;
+}
+
+static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__set_tracepoint_name(pos))
+			return -1;
+	}
+
+	return 0;
+}
+
 int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *header = &session->header;
@@ -2174,6 +2203,9 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
+	if (perf_evlist__set_tracepoint_names(session->evlist))
+		goto out_delete_evlist;
+
 	header->frozen = 1;
 	return 0;
 out_errno:
-- 
1.7.1

