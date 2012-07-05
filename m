Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2GEO3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903Ab2GEO3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:29:44 -0400
Date: Thu, 5 Jul 2012 11:28:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] perf, tool: Fix pmu object initialization
Message-ID: <20120705142836.GC7533@infradead.org>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
 <1341352848-11833-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341352848-11833-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 04, 2012 at 12:00:40AM +0200, Jiri Olsa escreveu:
> The internal pmu list was never used. With each perf_pmu__find() call
> the pmu structure was created new by parsing sysfs. Beside this it
> caused memory leaks. We now keep all pmus by adding them to the list.
> 
> Also, pmu_lookup() should return pmus that do not expose the format
> specifier in sysfs.
> 
> We need a valid internal pmu list in a later patch to iterate over all
> pmus that exist in the system.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> [ added same treatment for 'event' sysfs group attribute ]

The original patch from Robert is already in my perf/core branch, please
resubmit with just your additional code.

- Arnaldo

> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/pmu.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 74d0948e..f1f83e6 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -72,7 +72,7 @@ static int pmu_format(char *name, struct list_head *format)
>  		 "%s/bus/event_source/devices/%s/format", sysfs, name);
>  
>  	if (stat(path, &st) < 0)
> -		return -1;
> +		return 0;	/* no error if 'format' does not exist */
>  
>  	if (pmu_format_parse(path, format))
>  		return -1;
> @@ -161,7 +161,7 @@ static int pmu_aliases(char *name, struct list_head *head)
>  		 "%s/bus/event_source/devices/%s/events", sysfs, name);
>  
>  	if (stat(path, &st) < 0)
> -		return -1;
> +		return 0;	/* no error if 'events' does not exist */
>  
>  	if (pmu_aliases_parse(path, head))
>  		return -1;
> @@ -237,6 +237,9 @@ static struct perf_pmu *pmu_lookup(char *name)
>  	if (pmu_format(name, &format))
>  		return NULL;
>  
> +	if (pmu_aliases(name, &aliases))
> +		return NULL;
> +
>  	if (pmu_type(name, &type))
>  		return NULL;
>  
> @@ -244,14 +247,13 @@ static struct perf_pmu *pmu_lookup(char *name)
>  	if (!pmu)
>  		return NULL;
>  
> -	pmu_aliases(name, &aliases);
> -
>  	INIT_LIST_HEAD(&pmu->format);
>  	INIT_LIST_HEAD(&pmu->aliases);
>  	list_splice(&format, &pmu->format);
>  	list_splice(&aliases, &pmu->aliases);
>  	pmu->name = strdup(name);
>  	pmu->type = type;
> +	list_add_tail(&pmu->list, &pmus);
>  	return pmu;
>  }
>  
> -- 
> 1.7.10.4
