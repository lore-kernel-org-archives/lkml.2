Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2HTIZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:25:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59674 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2HTIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <1341866270-4915-2-git-send-email-jolsa@redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
	<1341866270-4915-2-git-send-email-jolsa@redhat.com>
Date: Mon, 20 Aug 2012 10:25:42 +0200
Message-ID: <CABPqkBQ7ZFw2c706JwvMVq1i1LCGo4108MCvynMqpXkPCbk39g@mail.gmail.com>
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events translations
 available in sysfs
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 10:37 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> Making hardware events translations available through the sysfs.
> Adding 'events' group attribute under the sysfs x86 PMU record
> with attribute/file for each hardware event:
>
>   # ls  /sys/devices/cpu/events/
>   branch-instructions
>   branch-misses
>   bus-cycles
>   cache-misses
>   cache-references
>   cpu-cycles
>   instructions
>   ref-cycles
>   stalled-cycles-backend
>   stalled-cycles-frontend
>
> The file - hw event ID mappings is:
>
>   file                      hw event ID
>   ---------------------------------------------------------------
>   cpu-cycles                PERF_COUNT_HW_CPU_CYCLES
>   instructions              PERF_COUNT_HW_INSTRUCTIONS
>   cache-references          PERF_COUNT_HW_CACHE_REFERENCES
>   cache-misses              PERF_COUNT_HW_CACHE_MISSES
>   branch-instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
>   branch-misses             PERF_COUNT_HW_BRANCH_MISSES
>   bus-cycles                PERF_COUNT_HW_BUS_CYCLES
>   stalled-cycles-frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
>   stalled-cycles-backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
>   ref-cycles                PERF_COUNT_HW_REF_CPU_CYCLES
>
> Each file in 'events' directory contains term translation for the
> symbolic hw event for the currently running cpu model.
>
>   # cat /sys/devices/cpu/events/stalled-cycles-backend
>   event=0xb1,umask=0x01,inv,cmask=0x01
>
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   74 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 29557aa..09452c2 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1638,9 +1638,83 @@ static struct attribute_group x86_pmu_attr_group = {
>         .attrs = x86_pmu_attrs,
>  };
>
> +static ssize_t event_sysfs_data(char *page, u64 config)
> +{
> +       u64 event  = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
> +                    (config & AMD64_EVENTSEL_EVENT) >> 24;
> +       u64 umask  = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> +       u64 inv    = (config & ARCH_PERFMON_EVENTSEL_INV) >> 23;
> +       u64 cmask  = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
> +       ssize_t ret;
> +
> +       /*
> +        * We have whole page size to spend and just little data
> +        * to write, so we can safely use sprintf.
> +        */
> +       ret = sprintf(page, "event=0x%02llx", event);
> +
> +       if (umask)
> +               ret += sprintf(page + ret, ",umask=0x%02llx", umask);
> +
> +       if (inv)
> +               ret += sprintf(page + ret, ",inv");
> +
> +       if (cmask)
> +               ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
> +

You are not handling the model specific modifiers such as any_thread on Intel.
It's not used right now. But you should handle the case now. That will avoid
problems in the future.

> +       ret += sprintf(page + ret, "\n");
> +
> +       return ret;
> +}
> +
> +#define PMU_EVENTS_ATTR(_name, _id)                    \
> +static ssize_t                                         \
> +_id##_show(struct device *dev,                         \
> +          struct device_attribute *attr,               \
> +          char *page)                                  \
> +{                                                      \
> +       u64 config = x86_pmu.event_map(_id);            \
> +       BUILD_BUG_ON(_id >= PERF_COUNT_HW_MAX);         \
> +       return event_sysfs_data(page, config);          \
> +}                                                      \
> +                                                       \
> +static struct device_attribute event_attr_##_id =      \
> +       __ATTR(_name, 0444, _id##_show, NULL)
> +
> +PMU_EVENTS_ATTR(cpu-cycles, PERF_COUNT_HW_CPU_CYCLES);
> +PMU_EVENTS_ATTR(instructions, PERF_COUNT_HW_INSTRUCTIONS);
> +PMU_EVENTS_ATTR(cache-references, PERF_COUNT_HW_CACHE_REFERENCES);
> +PMU_EVENTS_ATTR(cache-misses, PERF_COUNT_HW_CACHE_MISSES);
> +PMU_EVENTS_ATTR(branch-instructions, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
> +PMU_EVENTS_ATTR(branch-misses, PERF_COUNT_HW_BRANCH_MISSES);
> +PMU_EVENTS_ATTR(bus-cycles, PERF_COUNT_HW_BUS_CYCLES);
> +PMU_EVENTS_ATTR(stalled-cycles-frontend, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND);
> +PMU_EVENTS_ATTR(stalled-cycles-backend, PERF_COUNT_HW_STALLED_CYCLES_BACKEND);
> +PMU_EVENTS_ATTR(ref-cycles, PERF_COUNT_HW_REF_CPU_CYCLES);
> +
> +static struct attribute *events_attr[] = {
> +       &event_attr_PERF_COUNT_HW_CPU_CYCLES.attr,
> +       &event_attr_PERF_COUNT_HW_INSTRUCTIONS.attr,
> +       &event_attr_PERF_COUNT_HW_CACHE_REFERENCES.attr,
> +       &event_attr_PERF_COUNT_HW_CACHE_MISSES.attr,
> +       &event_attr_PERF_COUNT_HW_BRANCH_INSTRUCTIONS.attr,
> +       &event_attr_PERF_COUNT_HW_BRANCH_MISSES.attr,
> +       &event_attr_PERF_COUNT_HW_BUS_CYCLES.attr,
> +       &event_attr_PERF_COUNT_HW_STALLED_CYCLES_FRONTEND.attr,
> +       &event_attr_PERF_COUNT_HW_STALLED_CYCLES_BACKEND.attr,
> +       &event_attr_PERF_COUNT_HW_REF_CPU_CYCLES.attr,
> +       NULL,
> +};
> +
> +static struct attribute_group x86_pmu_events_group = {
> +       .name = "events",
> +       .attrs = events_attr,
> +};
> +
>  static const struct attribute_group *x86_pmu_attr_groups[] = {
>         &x86_pmu_attr_group,
>         &x86_pmu_format_group,
> +       &x86_pmu_events_group,
>         NULL,
>  };
>
You are not checking whether or not the generic event is even available on the
host core PMU. You don't want to expose generic events which are not available.

And if you do this, then you need to take care of the other arch as well. They
also deserve the extended syntax.
