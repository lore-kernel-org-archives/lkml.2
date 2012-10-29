Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab2J2PnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:43:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39089 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2J2PnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <1351525112.24721.36.camel@twins>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
	<1351523752-4215-5-git-send-email-eranian@google.com>
	<1351525112.24721.36.camel@twins>
Date: Mon, 29 Oct 2012 16:43:04 +0100
Message-ID: <CABPqkBT8_nXJhgr4MkbyHrg2wmXr+-DAf_FPBWWnK_GdkEFf_Q@mail.gmail.com>
Subject: Re: [Patch v1 04/10] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 4:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-10-29 at 16:15 +0100, Stephane Eranian wrote:
>> +       fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
>> +
>>         perf_sample_data_init(&data, 0, event->hw.last_period);
>>
>> +       data.period = event->hw.last_period;
>> +       sample_type = event->attr.sample_type;
>> +
>> +       /*
>> +        * if PEBS-LL or PreciseStore
>> +        */
>> +       if (fll) {
>> +               if (sample_type & PERF_SAMPLE_ADDR)
>> +                       data.addr = pebs->dla;
>> +
>> +               /*
>> +                * Use latency for cost (only avail with PEBS-LL)
>> +                */
>> +               if (fll && (sample_type & PERF_SAMPLE_COST))
>> +                       data.cost = pebs->lat;
>> +
>> +               /*
>> +                * data.dsrc encodes the data source
>> +                */
>> +               if (sample_type & PERF_SAMPLE_DSRC) {
>> +                       if (fll)
>> +                               data.dsrc.val = load_latency_data(pebs->dse);
>> +               }
>> +       }
>
>
> Why does fl1 exist? the above looks really convoluted, all fl1 checks
> inside are pointless. Also 'fl1' is a bizarre name, 'pebs_ll' would be a
> better name I guess.
>
You meant fll, instead I think.

> What's wrong with:
>
>         if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT) {
>                 if (sample_type & PERF_SAMPLE_ADDR)
>                         data.addr = pebs->dla;
>
>                 if (sample_type & PERF_SAMPLE_COST)
>                         data.cost = perf->lat;
>
>                 if (sample_type & PERF_SAMPLE_DSRC)
>                         data.dsrc.val = load_latency_data(pebs->dse);
>         }
>
Well, that would work too, but I am trying to factorize the code
with Precise Store which is a later patch. But we could clone
your proposal and do:

>         if (event->hw.flags & PERF_X86_EVENT_PEBS_ST) {
>                 if (sample_type & PERF_SAMPLE_ADDR)
>                         data.addr = pebs->dla;
>
>                 if (sample_type & PERF_SAMPLE_DSRC)
>                         data.dsrc.val = precise_store_data(pebs->dse);
>         }

I am fine with that too.
