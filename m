Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2ECK5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2ECK5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:57:14 -0400
Date: Thu, 3 May 2012 12:56:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
Message-ID: <20120503105655.GB1671@m.brq.redhat.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
 <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 10:07:20AM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> The definition of pmu event alias is located at:
>   ${sysfs_mount}/bus/event_source/devices/${pmu}/events/
> 
> Each file in the 'events' directory defines a event alias. Its contents
> is like:
>   config=1,config1=2
> 
> Using pmu event alias, event could be now specified like:
>   uncore/CLOCKTICKS/
> 
> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> ---
>  tools/perf/util/parse-events.c |   24 ++++++++-
>  tools/perf/util/parse-events.y |    2 +-
>  tools/perf/util/pmu.c          |  117 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/pmu.h          |   10 +++-
>  4 files changed, 149 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index c587ae8..764b2c31 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -653,8 +653,12 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
>  int parse_events_add_pmu(struct list_head *list, int *idx,
>  			 char *name, struct list_head *head_config)
>  {
> +	LIST_HEAD(event);
>  	struct perf_event_attr attr;
>  	struct perf_pmu *pmu;
> +	const char *config;
> +	char *str;
> +	int ret;
>  
>  	pmu = perf_pmu__find(name);
>  	if (!pmu)
> @@ -668,10 +672,26 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
>  	 */
>  	config_attr(&attr, head_config, 0);
>  
> -	if (perf_pmu__config(pmu, &attr, head_config))
> +	ret = perf_pmu__config(pmu, &attr, head_config);
> +	if (!ret)
> +		return add_event(list, idx, &attr, (char *) "pmu");
> +
> +	config = perf_pmu__alias(pmu, head_config);
> +	if (!config)
>  		return -EINVAL;
hi,
could we have the interface with string only:
	config = perf_pmu__alias(pmu, alias);

and AFAICS check if there's only single term and it's string,
then check for alias


I've got an idea for another approach, that would not need reentrant
parser and might be more gentle to the sysfs file rule

- in sysfs you would have directory with aliases (now called 'events')
- each alias is sysfs dir, with file attrs:
	file name = term name, file value = term value
  eg.:
	events/
		CAS_COUNT_RD/
			# files:
			config  - value 1
			config1 - value 2
			mask	- value ...

- on init you read all aliases and load its terms
  so each alias is defined by list of terms
- in parse_events_add_pmu before you run perf_pmu__config,
  you check if any term matches any defined alias
  and replace that term with all the terms defined for the alias
- run perf_pmu__config with new set of terms..

this way it's also possible to add extra terms to existing alias
in command line if needed... might be handy

thoughts?
jirka
