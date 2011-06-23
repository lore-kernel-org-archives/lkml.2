Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab1FWJkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:40:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab1FWJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OOo/r5bbq4NW7QtpMzPRP/q2891jGq8lfGDyNiG13j1YA27MRal7QTTniDL+qOgkFs
         mT9DGY7twLkxS2qCIltQ==
MIME-Version: 1.0
In-Reply-To: <20110623064835.GB10238@sun>
References: <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
	<20110621164820.GC21641@sun>
	<BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
	<20110621172319.GE21641@sun>
	<BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
	<20110621175421.GF21641@sun>
	<BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
	<20110621183227.GG21641@sun>
	<20110622082756.GK21641@sun>
	<20110622092134.GO21641@sun>
	<20110623064835.GB10238@sun>
Date: Thu, 23 Jun 2011 11:40:39 +0200
Message-ID: <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
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

On Thu, Jun 23, 2011 at 8:48 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Wed, Jun 22, 2011 at 01:21:34PM +0400, Cyrill Gorcunov wrote:
> ...
>> Note that I've not tested it but rather need approval/rejecting
>> on idea in general.
>
> The final version is below. Stephane, note that it's almost the
> same idea as you proposed except it uses explicit namings to
> mark out that watchdog cycles are special.
>
This looks okay.

The only alternative I see (This is wha I had in mind at the
beginning) that would
not require this new hidden generic event would be to have watchdog.c invoke an
arch-specific callback to fill out the attr.type, attr->config fields directly:

static int watchdog_nmi_enable(int cpu)
{
        struct perf_event_attr *wd_attr;
        struct perf_event *event = per_cpu(watchdog_ev, cpu);

        /* is it already setup and enabled? */
        if (event && event->state > PERF_EVENT_STATE_OFF)
                goto out;

        /* it is setup but not enabled */
        if (event != NULL)
                goto out_enable;

        /* Try to register using hardware perf events */
        wd_attr = &wd_hw_attr;
        wd_attr->sample_period = hw_nmi_get_sample_period(watchdog_thresh);

-->    hw_nmi_get_event(wd_attr);

        event = perf_event_create_kernel_counter(wd_attr, cpu, NULL,
watchdog_overflow_callback);
        ...
}

wd_attr would still be hardcoded with CPU_CYCLES, but could be overriden.
A default and empty hw_nmi_get_event() would be defined as __weak in watchdog.c.

Then for x86(), it would do what you have in your patch:

hw_nmi_get_event(struct perf_event *event)
{
       if (x86_pmu.hw_watchdog_config)
               x86_pmu.hw_watchdog_config(event);
}

For P4, hw_watchdog_config(), would be defined as in your patch:

+static void p4_hw_watchdog_config(struct perf_event *event)
+{
+       /*
+        * Watchdog ticks are special on Netburst, we use
+        * that named "non-sleeping" ticks as recommended
+        * by Intel SDM Vol3b.
+        */
+       event->attr.type        = PERF_TYPE_RAW;
+       event->attr.config      =
+
p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)
 |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
NBOGUS0)            |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
NBOGUS1)            |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
NBOGUS2)            |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
NBOGUS3)            |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
BOGUS0)             |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
BOGUS1)             |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
BOGUS2)             |
+                       P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT,
BOGUS3))            |
+               p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) |
P4_CCCR_COMPLEMENT          |
+                       P4_CCCR_COMPARE);
+}
+

No new hidden event, just a x86_pmu + a per-arch callbacks.
