Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032008Ab2CORfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:35:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab2CORe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:34:57 -0400
Date: Thu, 15 Mar 2012 14:34:52 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf hists: Add hists__filter_by_symbol
Message-ID: <20120315173452.GH9528@infradead.org>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 13, 2012 at 03:14:51PM +0900, Namhyung Kim escreveu:
> This function will be used for simple (sub-)string matching
> filter based on user input.

Can you check if these apply as well? I fear they wont.

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  tools/perf/util/hist.c |   35 +++++++++++++++++++++++++++++++++++
>  tools/perf/util/hist.h |    2 ++
>  2 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 6f505d1abac7..021b49c498d5 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -10,11 +10,14 @@ static bool hists__filter_entry_by_dso(struct hists *hists,
>  				       struct hist_entry *he);
>  static bool hists__filter_entry_by_thread(struct hists *hists,
>  					  struct hist_entry *he);
> +static bool hists__filter_entry_by_symbol(struct hists *hists,
> +					  struct hist_entry *he);
>  
>  enum hist_filter {
>  	HIST_FILTER__DSO,
>  	HIST_FILTER__THREAD,
>  	HIST_FILTER__PARENT,
> +	HIST_FILTER__SYMBOL,
>  };
>  
>  struct callchain_param	callchain_param = {
> @@ -352,6 +355,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
>  {
>  	hists__filter_entry_by_dso(hists, he);
>  	hists__filter_entry_by_thread(hists, he);
> +	hists__filter_entry_by_symbol(hists, he);
>  }
>  
>  static void __hists__collapse_resort(struct hists *hists, bool threaded)
> @@ -1179,6 +1183,37 @@ void hists__filter_by_thread(struct hists *hists)
>  	}
>  }
>  
> +static bool hists__filter_entry_by_symbol(struct hists *hists,
> +					  struct hist_entry *he)
> +{
> +	if (hists->symbol_filter_str != NULL &&
> +	    (!he->ms.sym || strstr(he->ms.sym->name,
> +				   hists->symbol_filter_str) == NULL)) {
> +		he->filtered |= (1 << HIST_FILTER__SYMBOL);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +void hists__filter_by_symbol(struct hists *hists)
> +{
> +	struct rb_node *nd;
> +
> +	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists__reset_col_len(hists);
> +
> +	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> +		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> +
> +		if (hists__filter_entry_by_symbol(hists, h))
> +			continue;
> +
> +		hists__remove_entry_filter(hists, h, HIST_FILTER__SYMBOL);
> +	}
> +}
> +
>  int hist_entry__inc_addr_samples(struct hist_entry *he, int evidx, u64 ip)
>  {
>  	return symbol__inc_addr_samples(he->ms.sym, he->ms.map, evidx, ip);
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 48e5acd1e862..020d3477cabc 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -57,6 +57,7 @@ struct hists {
>  	const struct thread	*thread_filter;
>  	const struct dso	*dso_filter;
>  	const char		*uid_filter_str;
> +	const char		*symbol_filter_str;
>  	pthread_mutex_t		lock;
>  	struct events_stats	stats;
>  	u64			event_stream;
> @@ -96,6 +97,7 @@ int hist_entry__annotate(struct hist_entry *self, size_t privsize);
>  
>  void hists__filter_by_dso(struct hists *hists);
>  void hists__filter_by_thread(struct hists *hists);
> +void hists__filter_by_symbol(struct hists *hists);
>  
>  u16 hists__col_len(struct hists *self, enum hist_column col);
>  void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
> -- 
> 1.7.9
