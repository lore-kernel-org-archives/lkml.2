Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2KIK0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:26:30 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64079 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2KIK02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20121108011035.GA20670@us.ibm.com>
References: <20121108011035.GA20670@us.ibm.com>
Date: Fri, 9 Nov 2012 11:26:26 +0100
Message-ID: <CABPqkBQrUVTY9rfeaO+pdaNwZcAgXF45SHnAYJfTvi4HAsPPeQ@mail.gmail.com>
Subject: Re: perf: POWER-event translation questions
From: Stephane Eranian <eranian@google.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>,
        Robert Richter <robert.richter@amd.com>, linuxppc-dev@ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 2:10 AM, Sukadev Bhattiprolu
<sukadev@linux.vnet.ibm.com> wrote:
>
>
> Looking for feedback on this prototype for making POWER-specific event
> translations available in sysfs. It is based on the patchset:
>
>         https://lkml.org/lkml/2012/11/7/402
>
> which makes the translations for _generic_ events in POWER available in sysfs:
>
> Since this is in POWER7 specific code I am assigning the names given in the
> POWER7 CPU spec for now.
>
> I had earlier tried mapping these events to generic names outside sysfs:
>
>         Power7 name             Generic name
>
>         cmpl-stall-fxu          stalled-cycles-fixed-point
>         cmpl-stall-lsu          stalled-cycles-load-store
>         cmpl-stall-ifu          stalled-cycles-instruction-fetch
>         cmpl-stall-bru          stalled-cycles-branch-unit
>
> But like Stephane Eranian pointed out mapping such events across architectures
> can be confusing.
>
> Another challenge I suspect we will have is the extremely long generic names
> we could end up with as the events get more specific.
>
> 1. Can we have more than one name for an event ? i.e two sysfs entries,
>    eg: 'cmpl-stall-fxu' and 'stalled-cycles-fixed-point' for an event ?
>
Yes, you can. What is really used is the content of the file and two files
can have the same content.

> 2. Can we allow hyphens in the {name} token  (please see my change to
>    util/parse-events.l below). With this change, I can run:
>
The current code does not support this but Andi fixed that in his HSW patch
and I use it for the PEBS-LL patch series as well.

>           perf stat -e cpu/cmplu-stall-bru /tmp/nop
>
>    without any changes to the user level tool (parse-events.l) I have
>    tested some common cases, not sure if it will break something :-)
>
>    If we are going to create generic or arch specific sysfs entries in
>    /sys/bus/event_source/devices/cpu/events, do we need to add corresponding
>    entry in tools/perf/util/parse-events.l ?
>
Shouldn't be necessary. perf should grab those events automatically from sysfs.
As per Jiri, the hardcoded tables are only used to support backward
compatibility
for kernels without sysfs event entries.

> Sukadev
>
> ---
>  arch/powerpc/perf/power7-pmu.c |   13 +++++++++++++
>  tools/perf/util/parse-events.l |    2 +-
>  2 files changed, 14 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
> index aa9f588..9f46abc 100644
> --- a/arch/powerpc/perf/power7-pmu.c
> +++ b/arch/powerpc/perf/power7-pmu.c
> @@ -303,6 +303,10 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
>  #define        PM_LD_MISS_L1                   0x400f0
>  #define        PM_BRU_FIN                      0x10068
>  #define        PM_BRU_MPRED                    0x400f6
> +#define        PM_CMPLU_STALL_FXU              0x20014
> +#define        PM_CMPLU_STALL_LSU              0x20012
> +#define        PM_CMPLU_STALL_IFU              0x4004c
> +#define        PM_CMPLU_STALL_BRU              0x4004e
>
>  static int power7_generic_events[] = {
>         [PERF_COUNT_HW_CPU_CYCLES] =                    PM_CYC,
> @@ -369,6 +373,11 @@ EVENT_ATTR(cache-misses,               LD_MISS_L1);
>  EVENT_ATTR(branch-instructions,        BRU_FIN);
>  EVENT_ATTR(branch-misses,              BRU_MPRED);
>
> +EVENT_ATTR(cmplu-stall-fxu,            CMPLU_STALL_FXU);
> +EVENT_ATTR(cmplu-stall-lsu,            CMPLU_STALL_LSU);
> +EVENT_ATTR(cmplu-stall-ifu,            CMPLU_STALL_IFU);
> +EVENT_ATTR(cmplu-stall-bru,            CMPLU_STALL_BRU);
> +
>  static struct attribute *power7_events_attr[] = {
>         EVENT_PTR(CYC),
>         EVENT_PTR(GCT_NOSLOT_CYC),
> @@ -378,6 +387,10 @@ static struct attribute *power7_events_attr[] = {
>         EVENT_PTR(LD_MISS_L1),
>         EVENT_PTR(BRU_FIN),
>         EVENT_PTR(BRU_MPRED),
> +       EVENT_PTR(CMPLU_STALL_FXU),
> +       EVENT_PTR(CMPLU_STALL_LSU),
> +       EVENT_PTR(CMPLU_STALL_IFU),
> +       EVENT_PTR(CMPLU_STALL_BRU),
>         NULL,
>  };
>
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index c87efc1..1967bb2 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -80,7 +80,7 @@ event         [^,{}/]+
>  num_dec                [0-9]+
>  num_hex                0x[a-fA-F0-9]+
>  num_raw_hex    [a-fA-F0-9]+
> -name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
> +name           [-a-zA-Z_*?][-a-zA-Z0-9_*?]*
>  modifier_event [ukhpGH]{1,8}
>  modifier_bp    [rwx]{1,3}
>
> --
> 1.7.1
>
