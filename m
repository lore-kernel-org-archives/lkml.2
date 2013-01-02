Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3ABO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:59:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3ABO7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:59:13 -0500
Date: Wed, 2 Jan 2013 15:58:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf: Make EVENT_ATTR and EVENT_PTR global
Message-ID: <20130102145850.GE931@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219072802.GA30790@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:28:02PM -0800, Sukadev Bhattiprolu wrote:
> 
> Rename EVENT_ATTR() and EVENT_PTR() PMU_EVENT_ATTR() and PMU_EVENT_PTR().
> Make them global so they are available to all architectures.
> 
> Further to allow architectures flexibility, have PMU_EVENT_PTR() pass in the
> variable name as a parameter.
> 
hi,
the change looks ok apart from some nits below.

There' another version of the x86 event attributes change
I mentioned earlier:

http://marc.info/?l=linux-kernel&m=135601815224373&w=2

I'm not sure which one will make it in first, but you
guys need to sync ;-) CC-ing Andi and Stephane.

thanks,
jirka

> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   17 +++++------------
>  include/linux/perf_event.h       |   13 +++++++++++++
>  2 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 4428fd1..24bc505 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1316,11 +1316,6 @@ static struct attribute_group x86_pmu_format_group = {
>  	.attrs = NULL,
>  };
>  
> -struct perf_pmu_events_attr {
> -	struct device_attribute attr;
> -	u64 id;
> -};
> -
>  /*
>   * Remove all undefined events (x86_pmu.event_map(id) == 0)
>   * out of events_attr attributes.
> @@ -1351,14 +1346,12 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
>  	return x86_pmu.events_sysfs_show(page, config);
>  }
>  
> -#define EVENT_VAR(_id)  event_attr_##_id
> -#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
> +#define EVENT_VAR(_id)	event_attr_##_id
> +#define EVENT_ID(_id)	PERF_COUNT_HW_##_id
> +#define EVENT_PTR(_id)	PMU_EVENT_PTR(EVENT_VAR(_id))
>  
> -#define EVENT_ATTR(_name, _id)					\
> -static struct perf_pmu_events_attr EVENT_VAR(_id) = {		\
> -	.attr = __ATTR(_name, 0444, events_sysfs_show, NULL),	\
> -	.id   =  PERF_COUNT_HW_##_id,				\
> -};
> +#define EVENT_ATTR(_name, _id)						\
> +	PMU_EVENT_ATTR(_name, EVENT_VAR(_id), EVENT_ID(_id), events_sysfs_show)

probably no need to define EVENT_ID macro if it's used on just one place

>  
>  EVENT_ATTR(cpu-cycles,			CPU_CYCLES		);
>  EVENT_ATTR(instructions,		INSTRUCTIONS		);
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 6bfb2fa..31692cb 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -817,6 +817,19 @@ do {									\
>  } while (0)
>  
>  
> +struct perf_pmu_events_attr {
> +	struct device_attribute attr;
> +	u64 id;
> +};
> +
> +#define PMU_EVENT_PTR(_var)	&_var.attr.attr

this one seems superfluous as well, could be replaced by '&'
