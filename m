Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423160Ab2KNS0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:26:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42956 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423116Ab2KNS0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:26:47 -0500
Date: Wed, 14 Nov 2012 10:20:45 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] perf/POWER7: Make event translations available in
 sysfs
Message-ID: <20121114182045.GA2240@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
 <20121107191927.GC16211@us.ibm.com>
 <20121114102534.GA2220@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114102534.GA2220@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111418-9360-0000-0000-00000CCF2138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Wed, Nov 07, 2012 at 11:19:28AM -0800, Sukadev Bhattiprolu wrote:
| 
| SNIP
| 
| > +struct perf_pmu_events_attr {
| > +	struct device_attribute attr;
| > +	u64 id;
| > +};
| > +
| > +extern ssize_t power_events_sysfs_show(struct device *dev,
| > +				struct device_attribute *attr, char *page);
| > +
| > +#define EVENT_VAR(_id)	event_attr_##_id
| > +#define EVENT_PTR(_id) &event_attr_##_id.attr.attr
| > +
| > +#define EVENT_ATTR(_name, _id)                                             \
| > +	static struct perf_pmu_events_attr EVENT_VAR(_id) = {              \
| > +		.attr = __ATTR(_name, 0444, power_events_sysfs_show, NULL),\
| > +		.id   = PM_##_id,                                               \
| > +	};
| 
| this is duplicating the x86 code, perhaps it could be moved
| to include/linux/perf_event.h and shared globaly

Ok.

Can we remove the assumption that the event id is a generic event that
has PERF_COUNT_HW_ prefix and also let the architectures pass in a "show"
function ? This would allow architectures to display any arch specific
events that don't yet have a generic counterpart.

IOW, can we do something like this (untested) and make PERF_EVENT_ATTR global:



diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..25298f7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1354,12 +1354,15 @@ static ssize_t events_sysfs_show(struct device *dev, struct device_attribute *at
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr

-#define EVENT_ATTR(_name, _id)                                 \
+#define PERF_EVENT_ATTR(_name, _id, _show)                     \
 static struct perf_pmu_events_attr EVENT_VAR(_id) = {          \
-       .attr = __ATTR(_name, 0444, events_sysfs_show, NULL),   \
-       .id   =  PERF_COUNT_HW_##_id,                           \
+       .attr = __ATTR(_name, 0444, _show, NULL),               \
+       .id   =  _id,                                           \
 };

+#define EVENT_ATTR(_name, _id)                                         \
+       PERF_EVENT_ATTR(_name, PERF_COUNT_HW_##_id, events_sysfs_show)
+
 EVENT_ATTR(cpu-cycles,                 CPU_CYCLES              );
 EVENT_ATTR(instructions,               INSTRUCTIONS            );
 EVENT_ATTR(cache-references,           CACHE_REFERENCES        );

| 
| 
| > diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
| > index aa2465e..19b23bd 100644
| > --- a/arch/powerpc/perf/core-book3s.c
| > +++ b/arch/powerpc/perf/core-book3s.c
| > @@ -1305,6 +1305,16 @@ static int power_pmu_event_idx(struct perf_event *event)
| >  	return event->hw.idx;
| >  }
| >  
| > +ssize_t power_events_sysfs_show(struct device *dev,
| > +				struct device_attribute *attr, char *page)
| > +{
| > +       struct perf_pmu_events_attr *pmu_attr;
| > +       
| > +       pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
| > +        
| > +       return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
| 
| whitespace issues

Will fix. Thanks for the review.

Sukadev

