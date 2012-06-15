Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2FOTNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:13:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2FOTNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:13:02 -0400
Date: Fri, 15 Jun 2012 12:12:39 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-auwks8fpuhmrdpiefs55o5oz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dmitry.antipov@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, dmitry.antipov@linaro.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix synthesizing tracepoint names from the perf.data headers
Git-Commit-ID: cb9dd49e11f83d548c822d7022ac180b0518b25c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 15 Jun 2012 12:12:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb9dd49e11f83d548c822d7022ac180b0518b25c
Gitweb:     http://git.kernel.org/tip/cb9dd49e11f83d548c822d7022ac180b0518b25c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Jun 2012 19:03:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Jun 2012 11:28:09 -0300

perf tools: Fix synthesizing tracepoint names from the perf.data headers

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
