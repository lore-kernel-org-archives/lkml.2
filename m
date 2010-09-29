Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0I2M0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:26:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab0I2M0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K0ybHHFt88E0MBfp45cGm5ngStf5DUqWKux4ZJ1j1popQJmERpEidVqdavaQqnsaDS
         cH5VrkiFaXKym6rVw0sA==
MIME-Version: 1.0
In-Reply-To: <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
References: <20100915162034.GO13563@erda.amd.com>
	<tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
Date: Wed, 29 Sep 2010 14:26:41 +0200
Message-ID: <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
From: Stephane Eranian <eranian@google.com>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, gorcunov@gmail.com, ying.huang@intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

You've applied the fix only to the generic X86 interrupt handler
which is currently used by AMD64 processors.

It seems to me that this "in-flight interrupt after disable" problem
may also happen on Intel and should therefore also be added
to intel_pmu_handle_irq(). Don't you think so?


On Fri, Sep 24, 2010 at 12:41 PM, tip-bot for Robert Richter
<robert.richter@amd.com> wrote:
>
> Commit-ID:  63e6be6d98e1a2bcdca86872b67052e51ab6afa1
> Gitweb:     http://git.kernel.org/tip/63e6be6d98e1a2bcdca86872b67052e51ab6afa1
> Author:     Robert Richter <robert.richter@amd.com>
> AuthorDate: Wed, 15 Sep 2010 18:20:34 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 24 Sep 2010 12:21:41 +0200
>
> perf, x86: Catch spurious interrupts after disabling counters
>
> Some cpus still deliver spurious interrupts after disabling a
> counter. This caused 'undelivered NMI' messages. This patch
> fixes this. Introduced by:
>
>  4177c42: perf, x86: Try to handle unknown nmis with an enabled PMU
>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: gorcunov@gmail.com <gorcunov@gmail.com>
> Cc: fweisbec@gmail.com <fweisbec@gmail.com>
> Cc: ying.huang@intel.com <ying.huang@intel.com>
> Cc: ming.m.lin@intel.com <ming.m.lin@intel.com>
> Cc: yinghai@kernel.org <yinghai@kernel.org>
> Cc: andi@firstfloor.org <andi@firstfloor.org>
> Cc: eranian@google.com <eranian@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> LKML-Reference: <20100915162034.GO13563@erda.amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 3efdf28..03a5b03 100644
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
> @@ -1141,8 +1143,16 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>        cpuc = &__get_cpu_var(cpu_hw_events);
>
>        for (idx = 0; idx < x86_pmu.num_counters; idx++) {
> -               if (!test_bit(idx, cpuc->active_mask))
> +               if (!test_bit(idx, cpuc->active_mask)) {
> +                       /*
> +                        * Though we deactivated the counter some cpus
> +                        * might still deliver spurious interrupts still
> +                        * in flight. Catch them:
> +                        */
> +                       if (__test_and_clear_bit(idx, cpuc->running))
> +                               handled++;
>                        continue;
> +               }
>
>                event = cpuc->events[idx];
>                hwc = &event->hw;
