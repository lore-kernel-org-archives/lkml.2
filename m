Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2FKOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:14:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46968 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2FKOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:14:22 -0400
Date: Mon, 11 Jun 2012 11:14:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf report: fix event name reporting
Message-ID: <20120611141416.GC2202@infradead.org>
References: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339158207-20575-1-git-send-email-dmitry.antipov@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 08, 2012 at 04:23:27PM +0400, Dmitry Antipov escreveu:
> Use trace_find_event to find event name before looking through
> /sys files. This helps 'perf report' to show real event names
> instead of 'unknown:unknown' when processing perf.data recorded
> on another machine.

We have to somehow tell perf_evlist__tty_browse_hists that it should try
to figure out the name of the event by looking at _either_ /sys (local
events) or what came in the perf.data file.

That is because 'perf top' and 'perf report' uses
perf_evlist__tty_browse_hists. One is for local events (top) and the
other for perf.data files, that may or not be for local (in the sense of
running the same kernel for record + report) or for "remote" (running on
the same machine but with a different kernel at record than the one used
at report) or from a different machine altogether, perhaps even
different arch.

So I think that what needs to be done is to cache the right event name
before getting to the hists browser. I.e. when setting up the events
locally or when reading the events from the perf.data header, this way
perf_evsel__name() can be used everywhere and will just return
event->name, BUG_ON if event->name is NULL, i.e. wasn't resolved
already.

- Arnaldo
 
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
> -- 
> 1.7.7.6
