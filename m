Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2KGOlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:41:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52039 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2KGOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:41:28 -0500
MIME-Version: 1.0
In-Reply-To: <1351643663-23828-28-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
	<1351643663-23828-28-git-send-email-andi@firstfloor.org>
Date: Wed, 7 Nov 2012 15:41:26 +0100
Message-ID: <CABPqkBQ=aeDzhM3a5yWXtG7E2JDOQ+1v7tbPStC_VBuup12HmA@mail.gmail.com>
Subject: Re: [PATCH 27/32] perf, x86: Support CPU specific sysfs events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 1:34 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add a way for the CPU initialization code to register additional events,
> and merge them into the events attribute directory. Used in the next
> patch.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  arch/x86/kernel/cpu/perf_event.c |   29 +++++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/perf_event.h |    1 +
>  2 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index af38635..e247423 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1344,6 +1344,30 @@ static void __init filter_events(struct attribute **attrs)
>         }
>  }
>
> +/* Merge two pointer arrays */
> +static __init struct attribute **merge_attr(struct attribute **a,
> +                                           struct attribute **b)
> +{
> +       struct attribute **new;
> +       int j, i;
> +
> +       for (j = 0; a[j]; j++)
> +               ;
> +       for (i = 0; b[i]; i++)
> +               j++;
> +       j++;
> +       new = kmalloc(sizeof(struct attribute *) * j, GFP_KERNEL);
> +       if (!new)
> +               return a;
> +       j = 0;
> +       for (i = 0; a[i]; i++)
> +               new[j++] = a[i];
> +       for (i = 0; b[i]; i++)
> +               new[j++] = b[i];
> +       new[j] = NULL;
> +       return new;
> +}
> +
>  ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
>                           char *page)
>  {
> @@ -1481,6 +1505,11 @@ static int __init init_hw_perf_events(void)
>         else
>                 filter_events(x86_pmu_events_group.attrs);
>
> +       if (x86_pmu.cpu_events)
> +               x86_pmu_events_group.attrs =
> +                       merge_attr(x86_pmu_events_group.attrs,
> +                                  x86_pmu.cpu_events);
> +
>         pr_info("... version:                %d\n",     x86_pmu.version);
>         pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
>         pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 12ae625..22f8003 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -360,6 +360,7 @@ struct x86_pmu {
>         struct attribute **format_attrs;
>
>         ssize_t         (*events_sysfs_show)(char *page, u64 config);
> +       struct attribute **cpu_events;
>
>         /*
>          * CPU Hotplug hooks
> --
> 1.7.7.6
>
