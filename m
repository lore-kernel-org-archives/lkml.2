Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IQNGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:06:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab0IQNGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iSEqlI8Zb8ATMlPb68pv0oPNuNNelqZqhci0Zja/MDmcEiHhx4vOfPL/vdXVQsosd6
         TzFpjosNNJfSyjNJs3Pw==
MIME-Version: 1.0
In-Reply-To: <20100915162034.GO13563@erda.amd.com>
References: <1284118900.402.35.camel@laptop>
	<20100910132741.GB4879@redhat.com>
	<20100910144634.GA1060@elte.hu>
	<20100910155659.GD13563@erda.amd.com>
	<20100911094157.GA11521@elte.hu>
	<20100911114404.GE13563@erda.amd.com>
	<20100911124537.GA22850@elte.hu>
	<20100912095202.GF13563@erda.amd.com>
	<20100913143713.GK13563@erda.amd.com>
	<20100914174132.GN13563@erda.amd.com>
	<20100915162034.GO13563@erda.amd.com>
Date: Fri, 17 Sep 2010 15:06:09 +0200
Message-ID: <AANLkTikdRh48rf19d3vsd8pEJO0Tvqbnw9_Yd7FaQ3yB@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling counters
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert.

Does it mean that with this patch, we don't need Don's back-to-back NMI patch
anymore?


On Wed, Sep 15, 2010 at 6:20 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 14.09.10 19:41:32, Robert Richter wrote:
>> I found the reason why we get the unknown nmi. For some reason
>> cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
>> are handled when we get an nmi. It seems there is somewhere a race
>> accessing the active_mask. So far I don't have a fix available.
>> Changing x86_pmu_stop() did not help:
>
> The patch below for tip/perf/urgent fixes this.
>
> -Robert
>
> From 4206a086f5b37efc1b4d94f1d90b55802b299ca0 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Wed, 15 Sep 2010 16:12:59 +0200
> Subject: [PATCH] perf, x86: catch spurious interrupts after disabling counters
>
> Some cpus still deliver spurious interrupts after disabling a counter.
> This caused 'undelivered NMI' messages. This patch fixes this.
>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 3efdf28..df7aabd 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -102,6 +102,7 @@ struct cpu_hw_events {
>         */
>        struct perf_event       *events[X86_PMC_IDX_MAX]; /* in counter order */
>        unsigned long           active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +       unsigned long           running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>        int                     enabled;
>
>        int                     n_events;
> @@ -1010,6 +1011,7 @@ static int x86_pmu_start(struct perf_event *event)
>        x86_perf_event_set_period(event);
>        cpuc->events[idx] = event;
>        __set_bit(idx, cpuc->active_mask);
> +       __set_bit(idx, cpuc->running);
>        x86_pmu.enable(event);
>        perf_event_update_userpage(event);
>
> @@ -1141,8 +1143,17 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>        cpuc = &__get_cpu_var(cpu_hw_events);
>
>        for (idx = 0; idx < x86_pmu.num_counters; idx++) {
> -               if (!test_bit(idx, cpuc->active_mask))
> +               if (!test_bit(idx, cpuc->active_mask)) {
> +                       if (__test_and_clear_bit(idx, cpuc->running))
> +                               /*
> +                                * Though we deactivated the counter
> +                                * some cpus might still deliver
> +                                * spurious interrupts. Catching them
> +                                * here.
> +                                */
> +                               handled++;
>                        continue;
> +               }
>
>                event = cpuc->events[idx];
>                hwc = &event->hw;
> --
> 1.7.2.2
>
>
>
>
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
>
