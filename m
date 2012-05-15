Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab2EOIkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:40:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54400 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab2EOIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:40:40 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-a8-4fb216846541
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 12/11] parse-events: Cleanup realloc use
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	<1335230984-7613-1-git-send-email-namhyung.kim@lge.com>
Date: Tue, 15 May 2012 17:39:00 +0900
In-Reply-To: <1335230984-7613-1-git-send-email-namhyung.kim@lge.com> (Namhyung
	Kim's message of "Tue, 24 Apr 2012 10:29:44 +0900")
Message-ID: <87r4ulzvmj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Tue, 24 Apr 2012 10:29:44 +0900, Namhyung Kim wrote:
> The if branch is completely unnecessary since 'realloc' can
> handle NULL pointers for the first parameter.
>
> This patch is just an adoption of Ulrich Drepper's recent
> patch on perf tools.
>
> Cc: Ulrich Drepper <drepper@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |    8 ++------
>  parse-filter.c |   24 ++++++++----------------
>  2 files changed, 10 insertions(+), 22 deletions(-)
>
> diff --git a/parse-events.c b/parse-events.c
> index 3ccedd9..9779298 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -627,12 +627,8 @@ static void add_event(struct pevent *pevent, struct event_format *event)
>  {
>  	int i;
>  
> -	if (!pevent->events)
> -		pevent->events = malloc_or_die(sizeof(event));
> -	else
> -		pevent->events =
> -			realloc(pevent->events, sizeof(event) *
> -				(pevent->nr_events + 1));
> +	pevent->events = realloc(pevent->events, sizeof(event) *
> +				 (pevent->nr_events + 1));
>  	if (!pevent->events)
>  		die("Can not allocate events");
>  
> diff --git a/parse-filter.c b/parse-filter.c
> index bc62f1f..79be550 100644
> --- a/parse-filter.c
> +++ b/parse-filter.c
> @@ -148,17 +148,11 @@ add_filter_type(struct event_filter *filter, int id)
>  	if (filter_type)
>  		return filter_type;
>  
> -	if (!filter->filters)
> -		filter->event_filters =
> -			malloc_or_die(sizeof(*filter->event_filters));
> -	else {
> -		filter->event_filters =
> -			realloc(filter->event_filters,
> -				sizeof(*filter->event_filters) *
> -				(filter->filters + 1));
> -		if (!filter->event_filters)
> -			die("Could not allocate filter");
> -	}
> +	filter->event_filters =	realloc(filter->event_filters,
> +					sizeof(*filter->event_filters) *
> +					(filter->filters + 1));
> +	if (!filter->event_filters)
> +		die("Could not allocate filter");
>  
>  	for (i = 0; i < filter->filters; i++) {
>  		if (filter->event_filters[i].event_id > id)
> @@ -1481,7 +1475,7 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
>  {
>  	struct filter_type *filter_type;
>  	int count = 0;
> -	int *ids;
> +	int *ids = NULL;
>  	int i;
>  
>  	if (!filter->filters)
> @@ -1505,10 +1499,8 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
>  		default:
>  			break;
>  		}
> -		if (count)
> -			ids = realloc(ids, sizeof(*ids) * (count + 1));
> -		else
> -			ids = malloc(sizeof(*ids));
> +
> +		ids = realloc(ids, sizeof(*ids) * (count + 1));
>  		if (!ids)
>  			die("Can't allocate ids");
>  		ids[count++] = filter_type->event_id;
