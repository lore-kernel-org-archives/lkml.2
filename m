Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab2CVPEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671Ab2CVPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:04:34 -0400
Date: Thu, 22 Mar 2012 12:04:09 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] perf, tool: Fix diff command to work with new hists
 design
Message-ID: <20120322150409.GG21163@infradead.org>
References: <1332422814-4965-1-git-send-email-jolsa@redhat.com>
 <20120322133726.GB1601@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322133726.GB1601@m.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 22, 2012 at 02:37:26PM +0100, Jiri Olsa escreveu:
> aaargh... I was too fast and did not send the last version..
> please take v2 ;)

Thanks,

As we discussed on IRC when perf diff was written we had just one hists
instance per perf_session.

Later I added support for multiple hists trees, one per event but didn't
update perf diff, that remained working for perf.data files with just
one event.

So for multi event perf.data files we need to iterate over both
perf.data and perf.data.old (or whatever name users gave to the
perf.data files being diffed) and do what it does now for each pair.

If we have cycles in the old file, find the right "cycles" hists rb_tree
in the new file and do the diff dance rinse repeat for each event in the
old perf.data file.

Warn the user if some event is present only in one of the files and also
allow the user to specify an event list for diffing i.e.:

perf diff -e cycles

would, by default, use perf.data.old and perf.data and would do the diff
just for the "cycles" hists rb_tree.

When I added support for threaded addition and sorting of entries I
updated it only halfway, making the events be added to the per event
hists tree, b00m.

Your fix makes it work again for files with just one event, so I'm
applying it as a short term fix, thanks,

- Arnaldo
 
> jirka
> 
> 
> ---
> The perf diff command is broken since:
>   perf hists: Threaded addition and sorting of entries
>   commit 1980c2ebd7020d82c024b8c4046849b38e78e7da
> 
> Several places were broken:
>   - hists data need to be collected into opened sessions instead
>     of into events
>   - session's hists data need to be initialized properly when the
>     session is created
>   - hist_entry__pcnt_snprintf: the percentage and displacement
>     buffer preparation must not use 'ret' because it's used
>     as a pointer to the final buffer
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/builtin-diff.c |   60 ++++++++++++++++++++++++++------------------
>  tools/perf/util/evsel.c   |    2 +-
>  tools/perf/util/evsel.h   |    2 +
>  tools/perf/util/hist.c    |    8 +++---
>  tools/perf/util/session.c |    1 +
>  5 files changed, 43 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 4f19513..d29d350 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -24,6 +24,11 @@ static char	  diff__default_sort_order[] = "dso,symbol";
>  static bool  force;
>  static bool show_displacement;
>  
> +struct perf_diff {
> +	struct perf_tool tool;
> +	struct perf_session *session;
> +};
> +
>  static int hists__add_entry(struct hists *self,
>  			    struct addr_location *al, u64 period)
>  {
> @@ -32,12 +37,14 @@ static int hists__add_entry(struct hists *self,
>  	return -ENOMEM;
>  }
>  
> -static int diff__process_sample_event(struct perf_tool *tool __used,
> +static int diff__process_sample_event(struct perf_tool *tool,
>  				      union perf_event *event,
>  				      struct perf_sample *sample,
>  				      struct perf_evsel *evsel __used,
>  				      struct machine *machine)
>  {
> +	struct perf_diff *_diff = container_of(tool, struct perf_diff, tool);
> +	struct perf_session *session = _diff->session;
>  	struct addr_location al;
>  
>  	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
> @@ -49,24 +56,26 @@ static int diff__process_sample_event(struct perf_tool *tool __used,
>  	if (al.filtered || al.sym == NULL)
>  		return 0;
>  
> -	if (hists__add_entry(&evsel->hists, &al, sample->period)) {
> +	if (hists__add_entry(&session->hists, &al, sample->period)) {
>  		pr_warning("problem incrementing symbol period, skipping event\n");
>  		return -1;
>  	}
>  
> -	evsel->hists.stats.total_period += sample->period;
> +	session->hists.stats.total_period += sample->period;
>  	return 0;
>  }
>  
> -static struct perf_tool perf_diff = {
> -	.sample	= diff__process_sample_event,
> -	.mmap	= perf_event__process_mmap,
> -	.comm	= perf_event__process_comm,
> -	.exit	= perf_event__process_task,
> -	.fork	= perf_event__process_task,
> -	.lost	= perf_event__process_lost,
> -	.ordered_samples = true,
> -	.ordering_requires_timestamps = true,
> +static struct perf_diff diff = {
> +	.tool = {
> +		.sample	= diff__process_sample_event,
> +		.mmap	= perf_event__process_mmap,
> +		.comm	= perf_event__process_comm,
> +		.exit	= perf_event__process_task,
> +		.fork	= perf_event__process_task,
> +		.lost	= perf_event__process_lost,
> +		.ordered_samples = true,
> +		.ordering_requires_timestamps = true,
> +	},
>  };
>  
>  static void perf_session__insert_hist_entry_by_name(struct rb_root *root,
> @@ -107,12 +116,6 @@ static void hists__resort_entries(struct hists *self)
>  	self->entries = tmp;
>  }
>  
> -static void hists__set_positions(struct hists *self)
> -{
> -	hists__output_resort(self);
> -	hists__resort_entries(self);
> -}
> -
>  static struct hist_entry *hists__find_entry(struct hists *self,
>  					    struct hist_entry *he)
>  {
> @@ -146,30 +149,37 @@ static void hists__match(struct hists *older, struct hists *newer)
>  static int __cmd_diff(void)
>  {
>  	int ret, i;
> +#define older (session[0])
> +#define newer (session[1])
>  	struct perf_session *session[2];
>  
> -	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &perf_diff);
> -	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &perf_diff);
> +	older = perf_session__new(input_old, O_RDONLY, force, false,
> +				  &diff.tool);
> +	newer = perf_session__new(input_new, O_RDONLY, force, false,
> +				  &diff.tool);
>  	if (session[0] == NULL || session[1] == NULL)
>  		return -ENOMEM;
>  
>  	for (i = 0; i < 2; ++i) {
> -		ret = perf_session__process_events(session[i], &perf_diff);
> +		diff.session = session[i];
> +		ret = perf_session__process_events(session[i], &diff.tool);
>  		if (ret)
>  			goto out_delete;
> +		hists__output_resort(&session[i]->hists);
>  	}
>  
> -	hists__output_resort(&session[1]->hists);
>  	if (show_displacement)
> -		hists__set_positions(&session[0]->hists);
> +		hists__resort_entries(&older->hists);
>  
> -	hists__match(&session[0]->hists, &session[1]->hists);
> -	hists__fprintf(&session[1]->hists, &session[0]->hists,
> +	hists__match(&older->hists, &newer->hists);
> +	hists__fprintf(&newer->hists, &older->hists,
>  		       show_displacement, true, 0, 0, stdout);
>  out_delete:
>  	for (i = 0; i < 2; ++i)
>  		perf_session__delete(session[i]);
>  	return ret;
> +#undef older
> +#undef newer
>  }
>  
>  static const char * const diff_usage[] = {
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 0221700..d9da62a 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -34,7 +34,7 @@ int __perf_evsel__sample_size(u64 sample_type)
>  	return size;
>  }
>  
> -static void hists__init(struct hists *hists)
> +void hists__init(struct hists *hists)
>  {
>  	memset(hists, 0, sizeof(*hists));
>  	hists->entries_in_array[0] = hists->entries_in_array[1] = RB_ROOT;
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 3158ca3..3d6b3e4 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -170,4 +170,6 @@ static inline int perf_evsel__sample_size(struct perf_evsel *evsel)
>  	return __perf_evsel__sample_size(evsel->attr.sample_type);
>  }
>  
> +void hists__init(struct hists *hists);
> +
>  #endif /* __PERF_EVSEL_H */
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 5fb1901..c61235f 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -891,9 +891,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
>  		diff = new_percent - old_percent;
>  
>  		if (fabs(diff) >= 0.01)
> -			ret += scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
> +			scnprintf(bf, sizeof(bf), "%+4.2F%%", diff);
>  		else
> -			ret += scnprintf(bf, sizeof(bf), " ");
> +			scnprintf(bf, sizeof(bf), " ");
>  
>  		if (sep)
>  			ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
> @@ -902,9 +902,9 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
>  
>  		if (show_displacement) {
>  			if (displacement)
> -				ret += scnprintf(bf, sizeof(bf), "%+4ld", displacement);
> +				scnprintf(bf, sizeof(bf), "%+4ld", displacement);
>  			else
> -				ret += scnprintf(bf, sizeof(bf), " ");
> +				scnprintf(bf, sizeof(bf), " ");
>  
>  			if (sep)
>  				ret += scnprintf(s + ret, size - ret, "%c%s", *sep, bf);
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 002ebbf..9412e3b 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -140,6 +140,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
>  	INIT_LIST_HEAD(&self->ordered_samples.sample_cache);
>  	INIT_LIST_HEAD(&self->ordered_samples.to_free);
>  	machine__init(&self->host_machine, "", HOST_KERNEL_ID);
> +	hists__init(&self->hists);
>  
>  	if (mode == O_RDONLY) {
>  		if (perf_session__open(self, force) < 0)
> -- 
> 1.7.7.6
