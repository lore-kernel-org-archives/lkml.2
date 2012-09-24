Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab2IXQDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab2IXQDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:03:30 -0400
Date: Mon, 24 Sep 2012 13:02:39 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] perf hists: Move hists_init() from util/evsel.c
 to util/hist.c
Message-ID: <20120924160239.GD9977@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348500251-9937-2-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 24, 2012 at 11:24:03PM +0800, Feng Tang escreveu:
> Which looks more natural

It is there to avoid dragging the hist code into the python binding :-\

- Arnaldo
 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/util/evsel.c |   10 ----------
>  tools/perf/util/evsel.h |    2 --
>  tools/perf/util/hist.c  |   10 ++++++++++
>  tools/perf/util/hist.h  |    1 +
>  4 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1506ba0..4c7328d 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -39,16 +39,6 @@ static int __perf_evsel__sample_size(u64 sample_type)
>  	return size;
>  }
>  
> -void hists__init(struct hists *hists)
> -{
> -	memset(hists, 0, sizeof(*hists));
> -	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
> -	hists->entries_in = &hists->entries_in_array[0];
> -	hists->entries_collapsed = RB_ROOT;
> -	hists->entries = RB_ROOT;
> -	pthread_mutex_init(&hists->lock, NULL);
> -}
> -
>  void perf_evsel__init(struct perf_evsel *evsel,
>  		      struct perf_event_attr *attr, int idx)
>  {
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 93876ba..af0bc97 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -197,8 +197,6 @@ static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
>  	return __perf_evsel__read(evsel, ncpus, nthreads, true);
>  }
>  
> -void hists__init(struct hists *hists);
> -
>  int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>  			     struct perf_sample *sample, bool swapped);
>  
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 6ec5398..d3689e5 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -690,3 +690,13 @@ void hists__inc_nr_events(struct hists *hists, u32 type)
>  	++hists->stats.nr_events[0];
>  	++hists->stats.nr_events[type];
>  }
> +
> +void hists__init(struct hists *hists)
> +{
> +	memset(hists, 0, sizeof(*hists));
> +	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
> +	hists->entries_in = &hists->entries_in_array[0];
> +	hists->entries_collapsed = RB_ROOT;
> +	hists->entries = RB_ROOT;
> +	pthread_mutex_init(&hists->lock, NULL);
> +}
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index f011ad4..4edfb74 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -70,6 +70,7 @@ struct hists {
>  	u16			col_len[HISTC_NR_COLS];
>  };
>  
> +void hists__init(struct hists *hists);
>  struct hist_entry *__hists__add_entry(struct hists *self,
>  				      struct addr_location *al,
>  				      struct symbol *parent, u64 period);
> -- 
> 1.7.1
