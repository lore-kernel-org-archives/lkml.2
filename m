Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2FKFVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:21:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60791 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2FKFVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:21:07 -0400
X-AuditID: 9c930197-b7b5dae000004b23-d4-4fd580413bf3
From: Namhyung Kim <namhyung@kernel.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf report: fix event name reporting
References: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
Date: Mon, 11 Jun 2012 14:18:02 +0900
In-Reply-To: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
	(Dmitry Antipov's message of "Fri, 8 Jun 2012 16:23:27 +0400")
Message-ID: <87txyipgtx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri,  8 Jun 2012 16:23:27 +0400, Dmitry Antipov wrote:
> Use trace_find_event to find event name before looking through
> /sys files. This helps 'perf report' to show real event names
> instead of 'unknown:unknown' when processing perf.data recorded
> on another machine.
>

Right, it should be a default action for a tracepoint event IMHO. (But
this patch doesn't check it's a tracepoint) There are a lot of places
call event_name() to be converted like this, so I suggest changing
event_name itself (or recent perf_evsel__name() ?) instead of just a
call-site. It might require checking whether the pevent is initialized
and if not, falls back to the sysfs walking.

Thanks,
Namhyung


> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  tools/perf/builtin-report.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 8c767c6..a6fd309 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -24,6 +24,7 @@
>  #include "util/evlist.h"
>  #include "util/evsel.h"
>  #include "util/header.h"
> +#include "util/trace-event.h"
>  #include "util/session.h"
>  #include "util/tool.h"
>  
> @@ -314,7 +315,8 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
>  
>  	list_for_each_entry(pos, &evlist->entries, node) {
>  		struct hists *hists = &pos->hists;
> -		const char *evname = event_name(pos);
> +		struct event_format *event = trace_find_event(pos->attr.config);
> +		const char *evname = event ? event->name : event_name(pos);
>  
>  		hists__fprintf_nr_sample_events(hists, evname, stdout);
>  		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
