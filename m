Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2KMCW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:22:27 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62174 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2KMCW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:22:26 -0500
X-AuditID: 9c930179-b7c9dae000000e53-6f-50a1aee06e51
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/5] perf tool: Add basic event modifier sanity check
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
	<1352741644-16809-6-git-send-email-jolsa@redhat.com>
Date: Tue, 13 Nov 2012 11:22:24 +0900
In-Reply-To: <1352741644-16809-6-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 12 Nov 2012 18:34:04 +0100")
Message-ID: <87haoumecf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 12 Nov 2012 18:34:04 +0100, Jiri Olsa wrote:
> Updating event parser to allow any non zero string containing
> [ukhpGH] characters for event modifier.
>
> The modifier sanity is checked later in parse-event object logic.
> The check validates modifier to contain only one instance of any
> modifier (apart from 'p') present.
[snip]
> +/*
> + * Basic modifier sanity check to validate it contains only one
> + * instance of any modifier (apart from 'p') present.
> + */
> +static int check_modifier(char *str)
> +{
> +	char *p = str;
> +
> +	while (*p) {
> +		if (*p != 'p' && strchr(p + 1, *p))
> +			return -1;
> +		p++;
> +	}

How about adding a length check too?  i.e. something like:

	if ((p - str) > strlen("ukhGHppp"))
        	return -1;

Thanks,
Namhyung

> +
> +	return 0;
> +}
> +
>  int parse_events__modifier_event(struct list_head *list, char *str, bool add)
>  {
>  	struct perf_evsel *evsel;
> @@ -730,6 +747,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
>  	if (str == NULL)
>  		return 0;
>  
> +	if (check_modifier(str))
> +		return -EINVAL;
> +
>  	if (!add && get_event_modifier(&mod, str, NULL))
>  		return -EINVAL;
>  
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 66959fa..e9d1134 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -82,7 +82,7 @@ num_hex		0x[a-fA-F0-9]+
>  num_raw_hex	[a-fA-F0-9]+
>  name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
>  name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
> -modifier_event	[ukhpGH]{1,8}
> +modifier_event	[ukhpGH]+
>  modifier_bp	[rwx]{1,3}
>  
>  %%
