Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab1FWLlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947Ab1FWLlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:41:13 -0400
Date: Thu, 23 Jun 2011 07:40:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623114055.GV3765@redhat.com>
References: <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
 <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
 <20110623064835.GB10238@sun>
 <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
 <20110623095439.GC10238@sun>
 <20110623110706.GE10238@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623110706.GE10238@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 03:07:06PM +0400, Cyrill Gorcunov wrote:
> On Thu, Jun 23, 2011 at 01:54:39PM +0400, Cyrill Gorcunov wrote:
> ...
> > > 
> > > No new hidden event, just a x86_pmu + a per-arch callbacks.
> > 
> > Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).
> > 
> > 	Cyrill
> 
> Since we are going to make __weak linking anyway maybe something like below
> fit even beter? (untested)

I don't think the compiler knows what platform you are running on and may
just blindly link your new p4 function for all x86s, which is probably not
what you want.

Cheers,
Don

> 
> 	Cyrill
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |   26 ++++++++++++++++++++++++++
>  kernel/watchdog.c                   |    3 +++
>  2 files changed, 29 insertions(+)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -705,6 +705,32 @@ static int p4_validate_raw_event(struct 
>  	return 0;
>  }
>  
> +void hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr)
> +{
> +	/*
> +	 * Watchdog ticks are special on Netburst, we use
> +	 * that named "non-sleeping" ticks as recommended
> +	 * by Intel SDM Vol3b.
> +	 */
> +	if (wd_attr->type	!= PERF_TYPE_HARDWARE ||
> +	   wd_attr->attr.config	!= PERF_COUNT_HW_CPU_CYCLES)
> +		return;
> +
> +	wd_attr->type	= PERF_TYPE_RAW;
> +	wd_attr->config	=
> +		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
> +			P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
> +		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
> +			P4_CCCR_COMPARE);
> +}
> +
>  static int p4_hw_config(struct perf_event *event)
>  {
>  	int cpu = get_cpu();
> Index: linux-2.6.git/kernel/watchdog.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/watchdog.c
> +++ linux-2.6.git/kernel/watchdog.c
> @@ -355,6 +355,8 @@ static int watchdog(void *unused)
>  
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> +
>  static int watchdog_nmi_enable(int cpu)
>  {
>  	struct perf_event_attr *wd_attr;
> @@ -371,6 +373,7 @@ static int watchdog_nmi_enable(int cpu)
>  	/* Try to register using hardware perf events */
>  	wd_attr = &wd_hw_attr;
>  	wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);
> +	hw_nmi_watchdog_set_attr(wd_attr);
>  	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
>  	if (!IS_ERR(event)) {
>  		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
