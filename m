Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2JPK0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:26:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:50796 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2JPK0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:26:02 -0400
Date: Tue, 16 Oct 2012 14:25:29 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v3)
Message-ID: <20121016102529.GA6175@paralelels.com>
References: <1347976585-3816541-1-git-send-email-avagin@openvz.org>
 <CAFTL4hyE4t8iR_aZZmg_wUxmPkTSBZLOWVj7+HNZNUSCgg9ZRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <CAFTL4hyE4t8iR_aZZmg_wUxmPkTSBZLOWVj7+HNZNUSCgg9ZRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline

On Tue, Oct 16, 2012 at 01:27:13AM +0V400, Frederic Weisbecker wrote:
> 2012/9/18 Andrew Vagin <avagin@openvz.org>:
> > You may want to know where and how long a task is sleeping. A callchain
> > may be found in sched_switch and a time slice in stat_iowait, so I add
> > handler in perf inject for merging this events.
> >
...
> 
> I'm ok with it, so Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I just have some suggestions below.

Hello Arnaldo,

The fixed version of this patch is attached to this message.
All other patches of the series are in the branch "sleep" of your tree.

Could you move this series in a main branch for including to the
mainstream kernel?

Thanks.

> 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>,
> > Cc: Ingo Molnar <mingo@redhat.com
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: David Ahern <dsahern@gmail.com>
> > Signed-off-by: Andrew Vagin <avagin@openvz.org>
> > ---
> >  tools/perf/Documentation/perf-inject.txt |    4 ++
> >  tools/perf/builtin-inject.c              |   86 ++++++++++++++++++++++++++++++
> >  2 files changed, 90 insertions(+), 0 deletions(-)
> >
> > diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
> > index 6be2101..c04e0c6 100644
> > --- a/tools/perf/Documentation/perf-inject.txt
> > +++ b/tools/perf/Documentation/perf-inject.txt
> > @@ -35,6 +35,10 @@ OPTIONS
> >  -o::
> >  --output=::
> >          Output file name. (default: stdout)
> > +-s::
> > +--sched-stat::
> > +       Merge sched_stat and sched_switch for getting events where and how long
> > +       tasks slept.
> 
> Please provide some more explanations here. I fear it's not very clear
> for the user. May be tell about the fact it results in sched_switch
> events weighted with the time slept.
> 
> [...]
> > +static int perf_event__sched_stat(struct perf_tool *tool,
> > +                                     union perf_event *event,
> > +                                     struct perf_sample *sample,
> > +                                     struct perf_evsel *evsel,
> > +                                     struct machine *machine)
> > +{
> > +       const char *evname = NULL;
> > +       uint32_t size;
> > +       struct event_entry *ent;
> > +       union perf_event *event_sw = NULL;
> > +       struct perf_sample sample_sw;
> > +       int sched_process_exit;
> > +
> > +       size = event->header.size;
> > +
> > +       evname = evsel->tp_format->name;
> > +
> > +       sched_process_exit = !strcmp(evname, "sched_process_exit");
> > +
> > +       if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
> > +               list_for_each_entry(ent, &samples, node)
> > +                       if (sample->tid == ent->tid)
> 
> Make sure you have PERF_SAMPLE_TID.
> 
> Thanks.

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: attachment;
	filename="0001-perf-teach-perf-inject-to-merge-sched_stat_-and-sche.patch"

>From aaffaec115b6fc733aab00be27dab3ee63dcb01f Mon Sep 17 00:00:00 2001
From: Andrew Vagin <avagin@openvz.org>
Date: Tue, 26 Jun 2012 16:13:21 +0400
Subject: [PATCH] perf: teach perf inject to merge sched_stat_* and sched_switch events (v4)

You may want to know where and how long a task is sleeping. A callchain
may be found in sched_switch and a time slice in stat_iowait, so I add
handler in perf inject for merging this events.

My code saves sched_switch event for each process and when it meets
stat_iowait, it reports the sched_switch event, because this event
contains a correct callchain. By another words it replaces all
stat_iowait events on proper sched_switch events.

v2: - remove the global variable "session"
    - hadle errors from malloc()

v3: - use sample->tid instead of sample->pid for merging events.

    Frederic Weisbecker noticed that this code works only in a root pidns.
    It's true, because a pid from trace content is used. This problem
    is more general, so I don't think that it should be solved in this
    series.
v4: - expand description of --sched-stat in Documentation/perf-inject.txt
      perf inject --help can show only one line per option, so it contains
      a short description.
    - check that samples have PERF_SAMPLE_TID

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
Cc: Ingo Molnar <mingo@redhat.com
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/Documentation/perf-inject.txt |    5 ++
 tools/perf/builtin-inject.c              |   92 ++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index 6be2101..733678a 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -35,6 +35,11 @@ OPTIONS
 -o::
 --output=::
         Output file name. (default: stdout)
+-s::
+--sched-stat::
+	Merge sched_stat and sched_switch for getting events where and how long
+	tasks slept. sched_switch contains a callchain where a task slept and
+	sched_stat contains a timeslice how long a task slept.
 
 SEE ALSO
 --------
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ed12b19..01560c6 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -8,11 +8,13 @@
 #include "builtin.h"
 
 #include "perf.h"
+#include "util/evsel.h"
 #include "util/session.h"
 #include "util/tool.h"
 #include "util/debug.h"
 
 #include "util/parse-options.h"
+#include "util/trace-event.h"
 
 static const char	*input_name	= "-";
 static const char	*output_name	= "-";
@@ -21,6 +23,7 @@ static int		output;
 static u64		bytes_written;
 
 static bool		inject_build_ids;
+static bool		inject_sched_stat;
 
 static int perf_event__repipe_synth(struct perf_tool *tool __used,
 				    union perf_event *event,
@@ -213,6 +216,89 @@ repipe:
 	return 0;
 }
 
+struct event_entry {
+	struct list_head node;
+	u32		 tid;
+	union perf_event event[0];
+};
+
+static LIST_HEAD(samples);
+
+static int perf_event__sched_stat(struct perf_tool *tool,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_evsel *evsel,
+				      struct machine *machine)
+{
+	const char *evname = NULL;
+	uint32_t size;
+	struct event_entry *ent;
+	union perf_event *event_sw = NULL;
+	struct perf_sample sample_sw;
+	int sched_process_exit;
+
+	size = event->header.size;
+
+	evname = evsel->tp_format->name;
+
+	sched_process_exit = !strcmp(evname, "sched_process_exit");
+
+	if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
+		if (!(evsel->attr.sample_type & PERF_SAMPLE_TID)) {
+			pr_err("Samples for '%s' event do not"
+				" have the attribute TID\n", evname);
+			return -1;
+		}
+
+		list_for_each_entry(ent, &samples, node)
+			if (sample->tid == ent->tid)
+				break;
+
+		if (&ent->node != &samples) {
+			list_del(&ent->node);
+			free(ent);
+		}
+
+		if (sched_process_exit)
+			return 0;
+
+		ent = malloc(size + sizeof(struct event_entry));
+		if (ent == NULL)
+			die("malloc");
+		ent->tid = sample->tid;
+		memcpy(&ent->event, event, size);
+		list_add(&ent->node, &samples);
+		return 0;
+
+	} else if (!strncmp(evname, "sched_stat_", 11)) {
+		u32 pid;
+
+		pid = raw_field_value(evsel->tp_format,
+					"pid", sample->raw_data);
+
+		list_for_each_entry(ent, &samples, node) {
+			if (pid == ent->tid)
+				break;
+		}
+
+		if (&ent->node == &samples)
+			return 0;
+
+		event_sw = &ent->event[0];
+		perf_evsel__parse_sample(evsel, event_sw, &sample_sw, false);
+
+		sample_sw.period = sample->period;
+		sample_sw.time = sample->time;
+		perf_evsel__synthesize_sample(evsel, event_sw, &sample_sw, false);
+
+		perf_event__repipe(tool, event_sw, &sample_sw, machine);
+		return 0;
+	}
+
+	perf_event__repipe(tool, event, sample, machine);
+
+	return 0;
+}
 struct perf_tool perf_inject = {
 	.sample		= perf_event__repipe_sample,
 	.mmap		= perf_event__repipe,
@@ -248,6 +334,9 @@ static int __cmd_inject(void)
 		perf_inject.mmap	 = perf_event__repipe_mmap;
 		perf_inject.fork	 = perf_event__repipe_task;
 		perf_inject.tracing_data = perf_event__repipe_tracing_data;
+	} else if (inject_sched_stat) {
+		perf_inject.sample	 = perf_event__sched_stat;
+		perf_inject.ordered_samples = true;
 	}
 
 	session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
@@ -275,6 +364,9 @@ static const char * const report_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
 		    "Inject build-ids into the output stream"),
+	OPT_BOOLEAN('s', "sched-stat", &inject_sched_stat,
+		    "Merge sched-stat and sched-switch for getting events "
+		    "where and how long tasks slept"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
 	OPT_STRING('o', "output", &output_name, "file",
-- 
1.7.1


--IJpNTDwzlM2Ie8A6--
