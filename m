Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2JOV1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:27:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34456 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab2JOV1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <1347976585-3816541-1-git-send-email-avagin@openvz.org>
References: <1347976585-3816541-1-git-send-email-avagin@openvz.org>
Date: Mon, 15 Oct 2012 23:27:13 +0200
Message-ID: <CAFTL4hyE4t8iR_aZZmg_wUxmPkTSBZLOWVj7+HNZNUSCgg9ZRQ@mail.gmail.com>
Subject: Re: [PATCH] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v3)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I'm ok with it, so Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

I just have some suggestions below.

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

Please provide some more explanations here. I fear it's not very clear
for the user. May be tell about the fact it results in sched_switch
events weighted with the time slept.

[...]
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

Make sure you have PERF_SAMPLE_TID.

Thanks.
