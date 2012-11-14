Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2KNKZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:25:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2KNKZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:25:53 -0500
Date: Wed, 14 Nov 2012 11:25:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf/POWER7: Make event translations available in
 sysfs
Message-ID: <20121114102534.GA2220@krava.brq.redhat.com>
References: <20121107191818.GA16211@us.ibm.com>
 <20121107191927.GC16211@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107191927.GC16211@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 11:19:28AM -0800, Sukadev Bhattiprolu wrote:

SNIP

> +struct perf_pmu_events_attr {
> +	struct device_attribute attr;
> +	u64 id;
> +};
> +
> +extern ssize_t power_events_sysfs_show(struct device *dev,
> +				struct device_attribute *attr, char *page);
> +
> +#define EVENT_VAR(_id)	event_attr_##_id
> +#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
> +
> +#define EVENT_ATTR(_name, _id)                                             \
> +	static struct perf_pmu_events_attr EVENT_VAR(_id) = {              \
> +		.attr = __ATTR(_name, 0444, power_events_sysfs_show, NULL),\
> +		.id   = PM_##_id,                                               \
> +	};

this is duplicating the x86 code, perhaps it could be moved
to include/linux/perf_event.h and shared globaly


> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index aa2465e..19b23bd 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1305,6 +1305,16 @@ static int power_pmu_event_idx(struct perf_event *event)
>  	return event->hw.idx;
>  }
>  
> +ssize_t power_events_sysfs_show(struct device *dev,
> +				struct device_attribute *attr, char *page)
> +{
> +       struct perf_pmu_events_attr *pmu_attr;
> +       
> +       pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
> +        
> +       return sprintf(page, "event=0x%02llx\n", pmu_attr->id);

whitespace issues


jirka
