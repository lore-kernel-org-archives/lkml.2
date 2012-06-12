Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2FLOnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:43:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62168 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FLOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:43:17 -0400
Date: Tue, 12 Jun 2012 11:43:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf report: fix event name reporting
Message-ID: <20120612144308.GA5816@infradead.org>
References: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
 <20120611141416.GC2202@infradead.org>
 <87y5nt598x.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <87y5nt598x.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Tue, Jun 12, 2012 at 03:34:22PM +0900, Namhyung Kim escreveu:
> On Mon, 11 Jun 2012 11:14:16 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jun 08, 2012 at 04:23:27PM +0400, Dmitry Antipov escreveu:
> >> Use trace_find_event to find event name before looking through
> >> /sys files. This helps 'perf report' to show real event names
> >> instead of 'unknown:unknown' when processing perf.data recorded
> >> on another machine.
> >
> > We have to somehow tell perf_evlist__tty_browse_hists that it should try
> > to figure out the name of the event by looking at _either_ /sys (local
> > events) or what came in the perf.data file.
> >
> > That is because 'perf top' and 'perf report' uses
> > perf_evlist__tty_browse_hists. One is for local events (top) and the
> > other for perf.data files, that may or not be for local (in the sense of
> > running the same kernel for record + report) or for "remote" (running on
> > the same machine but with a different kernel at record than the one used
> > at report) or from a different machine altogether, perhaps even
> > different arch.
> 
> I just thought that we should always consider the remote case first and
> falls back to local case because if we looked for local events, the
> remote events (perf.data) would not exist so that it can falls to the
> local case safely.
> 
> Now I think that we need a session method to check whether the current
> session is local or remote, and acts something based on that info.

We just need to get the data from the perf.data file as early as
possible, i.e. just after processing the perf.data headers, like in the
attached patch.

Dmitry, can you please try it?

- Arnaldo

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-tools-Fix-synthesizing-tracepoint-names-from-th.patch"

>From cb9dd49e11f83d548c822d7022ac180b0518b25c Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 11 Jun 2012 19:03:32 -0300
Subject: [PATCH 1/1] perf tools: Fix synthesizing tracepoint names from the perf.data headers
Content-Type: text/plain; charset="UTF-8"

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


--ZPt4rx8FFjLCG7dd--
