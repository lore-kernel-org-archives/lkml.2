Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2I0REi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:04:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab2I0REh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:04:37 -0400
Date: Thu, 27 Sep 2012 19:03:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 05/16] perf tools: Keep group information
Message-ID: <20120927170351.GH1872@krava.brq.redhat.com>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
 <1348645663-25303-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348645663-25303-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNIP

> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index bf5d033ee1b4..3c52d0ab9270 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -830,6 +830,7 @@ int parse_events(struct perf_evlist *evlist, const char *str,
>  	if (!ret) {
>  		int entries = data.idx - evlist->nr_entries;
>  		perf_evlist__splice_list_tail(evlist, &data.list, entries);
> +		evlist->nr_groups += data.nr_groups;
>  		return 0;
>  	}
>  
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index c356e443448d..f6b0254afe17 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -65,6 +65,7 @@ struct parse_events__term {
>  struct parse_events_data__events {
>  	struct list_head list;
>  	int idx;
> +	int nr_groups;
>  };
>  
>  struct parse_events_data__terms {
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> index cd88209e3c58..d14bb507594b 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -122,7 +122,9 @@ group_def:
>  PE_NAME '{' events '}'
>  {
>  	struct list_head *list = $3;
> +	struct parse_events_data__events *data = _data;
>  
> +	data->nr_groups++;

perhaps if you inc nr_groups only if there's more than 1 event,
you would not need your next patch:
  perf evlist: Add perf_evlist__recalc_nr_groups

something like:

if (!list_is_last(list))
	data->nr_groups++;


jirka
