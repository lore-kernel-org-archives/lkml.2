Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab1FWMbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:31:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58390 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1FWMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:31:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ndmpGxa3jVAX5o9UF/c+HR+e7Tpr8+2LtIO+O1UkCaDXQZaYovoLoUZxp9iWDzyLQH
         tqCdgPbmgNJSdg0Bdyaw==
MIME-Version: 1.0
In-Reply-To: <20110623122648.GI10238@sun>
References: <20110622092134.GO21641@sun>
	<20110623064835.GB10238@sun>
	<BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
	<20110623095439.GC10238@sun>
	<20110623110706.GE10238@sun>
	<20110623114055.GV3765@redhat.com>
	<BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
	<20110623115327.GG10238@sun>
	<BANLkTin5sN2FZaQYsnsEkH10OF-GES9MGw@mail.gmail.com>
	<20110623120732.GH10238@sun>
	<20110623122648.GI10238@sun>
Date: Thu, 23 Jun 2011 14:31:14 +0200
Message-ID: <BANLkTimKpnbus2rStk7V4-2sbv5cUbz8NA@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5NCVS2n027396

Yes.


On Thu, Jun 23, 2011 at 2:26 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Jun 23, 2011 at 04:07:32PM +0400, Cyrill Gorcunov wrote:
>> On Thu, Jun 23, 2011 at 02:03:50PM +0200, Stephane Eranian wrote:
>> ...
>> > >
>> > No, first level in watchdog.c, the other callback has to be implemented
>> > from x86_pmu as you had it.
>> >
> Something like below I suppose
>
>        Cyrill
> ---
>  arch/x86/kernel/cpu/perf_event.c    |    7 +++++++
>  arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
>  kernel/watchdog.c                   |    6 +++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
> @@ -233,6 +233,7 @@ struct x86_pmu {
>        void            (*enable_all)(int added);
>        void            (*enable)(struct perf_event *);
>        void            (*disable)(struct perf_event *);
> +       void            (*hw_watchdog_set_attr)(struct perf_event_attr *attr);
>        int             (*hw_config)(struct perf_event *event);
>        int             (*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
>        unsigned        eventsel;
> @@ -315,6 +316,12 @@ static u64 __read_mostly hw_cache_extra_
>                                [PERF_COUNT_HW_CACHE_OP_MAX]
>                                [PERF_COUNT_HW_CACHE_RESULT_MAX];
>
> +void hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr)
> +{
> +       if (x86_pmu.hw_watchdog_set_attr)
> +               x86_pmu.hw_watchdog_set_attr(wd_attr);
> +}
> +
>  /*
>  * Propagate event elapsed time into the generic event.
>  * Can only be executed on the CPU where the event is active.
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -705,6 +705,31 @@ static int p4_validate_raw_event(struct
>        return 0;
>  }
>
> +static void p4_hw_watchdog_set_attr(struct perf_event_attr *wd_attr)
> +{
> +       /*
> +        * Watchdog ticks are special on Netburst, we use
> +        * that named "non-sleeping" ticks as recommended
> +        * by Intel SDM Vol3b.
> +        */
> +       WARN_ON_ONCE(wd_attr->type      != PERF_TYPE_HARDWARE ||
> +                    wd_attr->config    != PERF_COUNT_HW_CPU_CYCLES);
> +
> +       wd_attr->type   = PERF_TYPE_RAW;
> +       wd_attr->config =
> +               p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)             |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)            |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)            |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)            |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)            |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)             |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)             |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)             |
> +                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))            |
> +               p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT          |
> +                       P4_CCCR_COMPARE);
> +}
> +
>  static int p4_hw_config(struct perf_event *event)
>  {
>        int cpu = get_cpu();
> @@ -1179,6 +1204,7 @@ static __initconst const struct x86_pmu
>        .cntval_bits            = ARCH_P4_CNTRVAL_BITS,
>        .cntval_mask            = ARCH_P4_CNTRVAL_MASK,
>        .max_period             = (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
> +       .hw_watchdog_set_attr   = p4_hw_watchdog_set_attr,
>        .hw_config              = p4_hw_config,
>        .schedule_events        = p4_pmu_schedule_events,
>        /*
> Index: linux-2.6.git/kernel/watchdog.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/watchdog.c
> +++ linux-2.6.git/kernel/watchdog.c
> @@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
>  }
>
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> +
>  static struct perf_event_attr wd_hw_attr = {
>        .type           = PERF_TYPE_HARDWARE,
>        .config         = PERF_COUNT_HW_CPU_CYCLES,
> @@ -368,9 +370,11 @@ static int watchdog_nmi_enable(int cpu)
>        if (event != NULL)
>                goto out_enable;
>
> -       /* Try to register using hardware perf events */
>        wd_attr = &wd_hw_attr;
>        wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
> +       hw_nmi_watchdog_set_attr(wd_attr);
> +
> +       /* Try to register using hardware perf events */
>        event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
>        if (!IS_ERR(event)) {
>                printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
