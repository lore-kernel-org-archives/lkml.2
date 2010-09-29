Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0I2Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:39:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61872 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943Ab0I2Pj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:39:57 -0400
Subject: Re: [PATCH] oprofile, arm: proper release resources on failure
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100929145225.GJ13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 16:39:44 +0100
Message-ID: <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 15:39:47.0700 (UTC) FILETIME=[8C107340:01CB5FEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 15:52 +0100, Robert Richter wrote:
> Will,
> 

Hi Robert,


> the patch below fixes a resource leak I found during code review. Can
> you please review and test it (I don't have an ARM environment for
> this available). If you are fine with the change, please ack. I want
> to send it upstream via tip/perf/urgent.
> 

I have a few minor clarifications:
> 

> diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> index 0691176..72e09eb 100644
> --- a/arch/arm/oprofile/common.c
> +++ b/arch/arm/oprofile/common.c
> @@ -102,6 +102,7 @@ static int op_create_counter(int cpu, int event)
>         if (IS_ERR(pevent)) {
>                 ret = PTR_ERR(pevent);
>         } else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
> +               perf_event_release_kernel(pevent);
>                 pr_warning("oprofile: failed to enable event %d "
>                                 "on CPU %d\n", event, cpu);
>                 ret = -EBUSY;


Yup, this is needed. Thanks! It would be nice to do away with the
else statement altogether but I think adding a pinned event and
then failing to activate it still succeeds in
perf_event_create_kernel_counter.


> @@ -365,6 +366,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
>         ret = init_driverfs();
>         if (ret) {
>                 kfree(counter_config);
> +               counter_config = NULL;
>                 return ret;
>         }
> 
> @@ -402,7 +404,6 @@ void oprofile_arch_exit(void)
>         struct perf_event *event;
> 
>         if (*perf_events) {
> -               exit_driverfs();
>                 for_each_possible_cpu(cpu) {
>                         for (id = 0; id < perf_num_counters; ++id) {
>                                 event = perf_events[cpu][id];
> @@ -413,8 +414,10 @@ void oprofile_arch_exit(void)
>                 }
>         }
> 
> -       if (counter_config)
> +       if (counter_config) {
>                 kfree(counter_config);
> +               exit_driverfs();
> +       }
>  }
>  #else
>  int __init oprofile_arch_init(struct oprofile_operations *ops)
> --
> 1.7.2.2
> 

Hmm, these three hunks conflict with the patches I posted last
month to fix the resource allocation and freeing. Can't we
merge those patches instead? I have versions against -rc6 here:

git://linux-arm.org/linux-2.6-wd.git oprofile-mm

Cheers,

Will

