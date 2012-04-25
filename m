Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2DYNCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2DYNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:02:08 -0400
Date: Wed, 25 Apr 2012 15:01:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Subject: Re: [PATCH 4/6] perf tool: Parse general events from sysfs
Message-ID: <20120425130142.GB3378@m.brq.redhat.com>
References: <1333244495-1020-1-git-send-email-zheng.z.yan@intel.com>
 <1333244495-1020-5-git-send-email-zheng.z.yan@intel.com>
 <20120424090427.GA2125@m.brq.redhat.com>
 <4F979002.9090906@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F979002.9090906@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 01:47:46PM +0800, Yan, Zheng wrote:
> On 04/24/2012 05:04 PM, Jiri Olsa wrote:
> > hi,
> > so the point is to have an alias support for pmu event definition.
> > Seems like good idea to improve usability/readability, I have some
> > general comments though..
> > 
> Thank you very much for reviewing this.
> > - you suggest to have sysfs files having contents like:
> >     event=0x2c,umask=0xf
> >   when we were adding the formats stuff into sysfs, we had to cut off
> >   the sysfs file contents to bare minimum to obey the sysfs rule:
> >     single file = single value
> >   so you might have some troubles pushing that through.. not sure ;)
> > 
> > - I haven't read the whole patchset, but seems like the "events"
> >   directory is now specific to a 'Intel uncore pmu'. If thats the
> >   case I think there should be generic way for each pmu to define
> >   this stuff.
> > 
> > - as for the tools/pmu.c change I'd like to see more consistent
> >   way of parsing this, than via 'newcfg' variable.. but none
> >   is comming to me so far ;) I'll think about that..
> > 
> For this point, how about making the parser re-entrantable like the patch
> attached below does.

yep, looks cleaner ;) some comments below

> 
> Regards
> Yan, Zheng
> 
> ---
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index e98e14c..a8b47d2 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -728,11 +728,13 @@ $(OUTPUT)perf.o perf.spec \
>  # These two need to be here so that when O= is not used they take precedence

SNIP

> +static int __parse_events(const char *str, int *idx, struct list_head *list);
>  
>  #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
>  #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
> @@ -651,8 +653,11 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
>  int parse_events_add_pmu(struct list_head *list, int *idx,
>  			 char *name, struct list_head *head_config)
>  {
> +	LIST_HEAD(event);

Are there all available events under ...event_source/devices/%s/events or
just some of them ?

In case of the latter, maybe the 'aliases/alias' would be better name for
that.. ending up with rename in this source ;)


>  	struct perf_event_attr attr;
>  	struct perf_pmu *pmu;
> +	char *config;
> +	int ret;
>  
>  	pmu = perf_pmu__find(name);
>  	if (!pmu)
> @@ -666,10 +671,21 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
>  	 */
>  	config_attr(&attr, head_config, 0);
>  
> -	if (perf_pmu__config(pmu, &attr, head_config))
> -		return -EINVAL;
> +	ret = perf_pmu__config(pmu, &attr, head_config);
> +	if (!ret)
> +		return add_event(list, idx, &attr, (char *) "pmu");
> +
> +	ret = perf_pmu__alias(pmu, &config, head_config);
> +	if (ret)
> +		return ret;


I think it's ok for pmu object to contain list of aliases loaded
from sysfs (if that change will go throught ;) ), but I'd rather
see the pmu alias interface to be more generic like:

        config = perf_pmu__alias(pmu, alias);

The function would just return the event config string if the record
is found for the alias.

...and the parse_events_add_pmu function would then take care of
the rest.. the final 'pmu/config' string and have it parsed...


thanks,
jirka
