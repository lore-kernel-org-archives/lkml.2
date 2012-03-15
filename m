Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2COOOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:14:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46530 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2COOOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:14:14 -0400
Date: Thu, 15 Mar 2012 15:14:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v4)
Message-ID: <20120315141402.GA550@somewhere.redhat.com>
References: <1331746607-6706-1-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331746607-6706-1-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:36:47AM -0700, Arun Sharma wrote:
> Each entry that used to get added once to the histogram, now is added
> chain->nr times, each time with one less entry in the
> callchain.
> 
> This will result in a non-leaf function that appears in a lot of
> samples to get a histogram entry with lots of hits.
> 
> The user can then drill down into the callchains of functions that
> have high inclusive times.
> 
> Sample command lines:
> 
> $ perf record -ag -- sleep 1
> $ perf report -g graph,0.5,callee -n -s inclusive
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-perf-users@vger.kernel.org
> ---
>  tools/perf/builtin-annotate.c |    2 +-
>  tools/perf/builtin-diff.c     |    2 +-
>  tools/perf/builtin-report.c   |   13 +++----
>  tools/perf/builtin-top.c      |    2 +-
>  tools/perf/util/callchain.c   |   15 ++++++++
>  tools/perf/util/callchain.h   |    4 ++
>  tools/perf/util/hist.c        |   80 +++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/hist.h        |    4 ++-
>  tools/perf/util/sort.c        |   14 +++++++
>  tools/perf/util/sort.h        |    4 ++
>  10 files changed, 126 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 806e0a2..5651b7b 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -62,7 +62,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
>  		return 0;
>  	}
>  
> -	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
> +	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, 1);
>  	if (he == NULL)
>  		return -ENOMEM;
>  
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 4f19513..4a30856 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -27,7 +27,7 @@ static bool show_displacement;
>  static int hists__add_entry(struct hists *self,
>  			    struct addr_location *al, u64 period)
>  {
> -	if (__hists__add_entry(self, al, NULL, period) != NULL)
> +	if (__hists__add_entry(self, al, NULL, NULL, period) != NULL)
>  		return 0;
>  	return -ENOMEM;
>  }
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 25d34d4..f20587f 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -61,6 +61,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>  	struct symbol *parent = NULL;
>  	int err = 0;
>  	struct hist_entry *he;
> +	struct callchain_cursor *cursor;
>  
>  	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
>  		err = machine__resolve_callchain(machine, evsel, al->thread,
> @@ -69,17 +70,12 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>  			return err;
>  	}
>  
> -	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
> +	cursor = &evsel->hists.callchain_cursor;
> +	he = __hists__add_entry(&evsel->hists, al, parent,
> +			        cursor, sample->period);
>  	if (he == NULL)
>  		return -ENOMEM;
>  
> -	if (symbol_conf.use_callchain) {
> -		err = callchain_append(he->callchain,
> -				       &evsel->hists.callchain_cursor,
> -				       sample->period);
> -		if (err)
> -			return err;
> -	}
>  	/*
>  	 * Only in the newt browser we are doing integrated annotation,
>  	 * so we don't allocated the extra space needed because the stdio
> @@ -595,6 +591,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>  	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
>  	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
>  	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
> +	sort_entry__setup_elide(&sort_sym_inclusive, symbol_conf.sym_list, "inclusive", stdout);
>  
>  	return __cmd_report(&report);
>  }
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e3c63ae..41e7153 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -235,7 +235,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
>  {
>  	struct hist_entry *he;
>  
> -	he = __hists__add_entry(&evsel->hists, al, NULL, sample->period);
> +	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, sample->period);
>  	if (he == NULL)
>  		return NULL;
>  
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 9f7106a..2b824a5 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -459,3 +459,18 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
>  
>  	return 0;
>  }
> +
> +int callchain_get(struct callchain_cursor *cursor,
> +		  struct addr_location *al)
> +{
> +	struct callchain_cursor_node *node = cursor->curr;
> +
> +	if (node == NULL)
> +		return -1;
> +
> +	al->map = node->map;
> +	al->sym = node->sym;
> +	al->addr = node->ip;
> +
> +	return 0;
> +}
> diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
> index 7f9c0f1..dcff6ec 100644
> --- a/tools/perf/util/callchain.h
> +++ b/tools/perf/util/callchain.h
> @@ -103,9 +103,13 @@ int callchain_merge(struct callchain_cursor *cursor,
>  
>  struct ip_callchain;
>  union perf_event;
> +struct addr_location;
>  
>  bool ip_callchain__valid(struct ip_callchain *chain,
>  			 const union perf_event *event);
> +
> +int callchain_get(struct callchain_cursor *cursor, struct addr_location *al);
> +
>  /*
>   * Initialize a cursor before adding entries inside, but keep
>   * the previously allocated entries as a cache.
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 6f505d1..f3200ea 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -184,7 +184,7 @@ static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>  	if (!h->filtered) {
>  		hists__calc_col_len(hists, h);
>  		++hists->nr_entries;
> -		hists->stats.total_period += h->period;
> +		hists->stats.total_period += h->period_self;

I still feel concerned about this.

If I have only one event with a period of 1 and with that callchain:

	a -> b -> c

Then I produce three hists

	1) a -> b -> c
	2) a -> b
	3) a

Each hist have a period of 1, but the total period is 1.
So the end result should be (IIUC):

100%    foo     a
100%    foo     b
                |
                --- a
100%    foo     c
                |
                --- b
                    |
                    --- c
		
And the percentages on callchain branches will have the same kind
of weird things.

So I'm not sure this is a good direction. I'd rather advocate to create
true hists for each callers, all having the same real period as the leaf.

Also this feature reminds me a lot the -b option in perf report.
Branch sorting and callchain inclusive sorting are a bit different in
the way they handle the things but the core idea is the same. Callchains
are branches as well.

Branch sorting (-b) adds a hist for every branch taken, and the period
is always 1. I wonder if this makes more sense than using the original
period of the event for all branches of the event. Not sure.

Anyway I wonder if both features can be better integrated. After all
they are about the same thing. The difference is that the source of
the branches is not the same and that callchains can be depicted into
trees.

So perhaps we can have -b specifying the desired source, in case both
are present: -b callchain and -b branch. Both at the same time wouldn't
make much sense I think.

And the source could default to either if we don't have callchain and
branch at the same time in the events.

Just an idea...
