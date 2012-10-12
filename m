Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2JLVIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:08:11 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46562 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2JLVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <1347976585-3816541-1-git-send-email-avagin@openvz.org>
References: <1347976585-3816541-1-git-send-email-avagin@openvz.org>
Date: Sat, 13 Oct 2012 01:08:07 +0400
Message-ID: <CANaxB-w13T-uRHhnkOCfFrLiRk=Z8cXLGjS9JiW9Z=8sqN+JPw@mail.gmail.com>
Subject: Re: [PATCH] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v3)
From: Andrey Wagin <avagin@gmail.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Frederic,

Could you write your opinion about this patch? Here are fixed all
bugs, which you mentioned for the previous version.

Thanks.

2012/9/18 Andrew Vagin <avagin@openvz.org>:
> You may want to know where and how long a task is sleeping. A callchain
> may be found in sched_switch and a time slice in stat_iowait, so I add
> handler in perf inject for merging this events.
>
> My code saves sched_switch event for each process and when it meets
> stat_iowait, it reports the sched_switch event, because this event
> contains a correct callchain. By another words it replaces all
> stat_iowait events on proper sched_switch events.
>
> v2: - remove the global variable "session"
>     - hadle errors from malloc()
>
> v3: - use sample->tid instead of sample->pid for merging events.
>
>     Frederic Weisbecker noticed that this code works only in a root pidns.
>     It's true, because a pid from trace content is not pid-namespace safe
>     and currently no way to get this pid in a current pidns. This problem
>     is more general, so I don't think that it should be solved in this series.
>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>,
> Cc: Ingo Molnar <mingo@redhat.com
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  tools/perf/Documentation/perf-inject.txt |    4 ++
>  tools/perf/builtin-inject.c              |   86 ++++++++++++++++++++++++++++++
>  2 files changed, 90 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
> index 6be2101..c04e0c6 100644
> --- a/tools/perf/Documentation/perf-inject.txt
> +++ b/tools/perf/Documentation/perf-inject.txt
> @@ -35,6 +35,10 @@ OPTIONS
>  -o::
>  --output=::
>          Output file name. (default: stdout)
> +-s::
> +--sched-stat::
> +       Merge sched_stat and sched_switch for getting events where and how long
> +       tasks slept.
>
>  SEE ALSO
>  --------
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index ed12b19..1783f0a 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -8,11 +8,13 @@
>  #include "builtin.h"
>
>  #include "perf.h"
> +#include "util/evsel.h"
>  #include "util/session.h"
>  #include "util/tool.h"
>  #include "util/debug.h"
>
>  #include "util/parse-options.h"
> +#include "util/trace-event.h"
>
>  static const char      *input_name     = "-";
>  static const char      *output_name    = "-";
> @@ -21,6 +23,7 @@ static int            output;
>  static u64             bytes_written;
>
>  static bool            inject_build_ids;
> +static bool            inject_sched_stat;
>
>  static int perf_event__repipe_synth(struct perf_tool *tool __used,
>                                     union perf_event *event,
> @@ -213,6 +216,83 @@ repipe:
>         return 0;
>  }
>
> +struct event_entry {
> +       struct list_head node;
> +       u32              tid;
> +       union perf_event event[0];
> +};
> +
> +static LIST_HEAD(samples);
> +
> +static int perf_event__sched_stat(struct perf_tool *tool,
> +                                     union perf_event *event,
> +                                     struct perf_sample *sample,
> +                                     struct perf_evsel *evsel,
> +                                     struct machine *machine)
> +{
> +       const char *evname = NULL;
> +       uint32_t size;
> +       struct event_entry *ent;
> +       union perf_event *event_sw = NULL;
> +       struct perf_sample sample_sw;
> +       int sched_process_exit;
> +
> +       size = event->header.size;
> +
> +       evname = evsel->tp_format->name;
> +
> +       sched_process_exit = !strcmp(evname, "sched_process_exit");
> +
> +       if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
> +               list_for_each_entry(ent, &samples, node)
> +                       if (sample->tid == ent->tid)
> +                               break;
> +
> +               if (&ent->node != &samples) {
> +                       list_del(&ent->node);
> +                       free(ent);
> +               }
> +
> +               if (sched_process_exit)
> +                       return 0;
> +
> +               ent = malloc(size + sizeof(struct event_entry));
> +               if (ent == NULL)
> +                       die("malloc");
> +               ent->tid = sample->tid;
> +               memcpy(&ent->event, event, size);
> +               list_add(&ent->node, &samples);
> +               return 0;
> +
> +       } else if (!strncmp(evname, "sched_stat_", 11)) {
> +               u32 pid;
> +
> +               pid = raw_field_value(evsel->tp_format,
> +                                       "pid", sample->raw_data);
> +
> +               list_for_each_entry(ent, &samples, node) {
> +                       if (pid == ent->tid)
> +                               break;
> +               }
> +
> +               if (&ent->node == &samples)
> +                       return 0;
> +
> +               event_sw = &ent->event[0];
> +               perf_evsel__parse_sample(evsel, event_sw, &sample_sw, false);
> +
> +               sample_sw.period = sample->period;
> +               sample_sw.time = sample->time;
> +               perf_evsel__synthesize_sample(evsel, event_sw, &sample_sw, false);
> +
> +               perf_event__repipe(tool, event_sw, &sample_sw, machine);
> +               return 0;
> +       }
> +
> +       perf_event__repipe(tool, event, sample, machine);
> +
> +       return 0;
> +}
>  struct perf_tool perf_inject = {
>         .sample         = perf_event__repipe_sample,
>         .mmap           = perf_event__repipe,
> @@ -248,6 +328,9 @@ static int __cmd_inject(void)
>                 perf_inject.mmap         = perf_event__repipe_mmap;
>                 perf_inject.fork         = perf_event__repipe_task;
>                 perf_inject.tracing_data = perf_event__repipe_tracing_data;
> +       } else if (inject_sched_stat) {
> +               perf_inject.sample       = perf_event__sched_stat;
> +               perf_inject.ordered_samples = true;
>         }
>
>         session = perf_session__new(input_name, O_RDONLY, false, true, &perf_inject);
> @@ -275,6 +358,9 @@ static const char * const report_usage[] = {
>  static const struct option options[] = {
>         OPT_BOOLEAN('b', "build-ids", &inject_build_ids,
>                     "Inject build-ids into the output stream"),
> +       OPT_BOOLEAN('s', "sched-stat", &inject_sched_stat,
> +                   "Merge sched-stat and sched-switch for getting events "
> +                   "where and how long tasks slept"),
>         OPT_STRING('i', "input", &input_name, "file",
>                     "input file name"),
>         OPT_STRING('o', "output", &output_name, "file",
> --
> 1.7.1
>
