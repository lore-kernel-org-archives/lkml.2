Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3AFUh3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:37:29 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45957 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3AFUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130105184329.GB995@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<1356018108-6081-9-git-send-email-eranian@google.com>
	<20130105184329.GB995@krava.brq.redhat.com>
Date: Sun, 6 Jan 2013 21:37:25 +0100
Message-ID: <CABPqkBRkJtB+5C=gq=ngJE9hYxVkxE7s2-4UN+Ub+Y8_pf9x2A@mail.gmail.com>
Subject: Re: [PATCH v4 08/18] perf/x86: add memory profiling via PEBS Load Latency
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 5, 2013 at 7:43 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 04:41:38PM +0100, Stephane Eranian wrote:
>> This patch adds support for memory profiling using the
>> PEBS Load Latency facility.
>>
>> Load accesses are sampled by HW and the instruction
>> address, data address, load latency, data source, tlb,
>> locked information can be saved in the sampling buffer
>> if using the PERF_SAMPLE_COST (for latency),
>
> PERF_SAMPLE_WEIGHT ?
>
No I switched to using Andi's PERF_SAMPLE_WEIGHT patch for this.
So it's PERF_SAMPLE_COST now.

>> PERF_SAMPLE_ADDR, PERF_SAMPLE_DSRC types.
>>
>> To enable PEBS Load Latency, users have to use the
>> model specific event:
>> - on NHM/WSM: MEM_INST_RETIRED:LATENCY_ABOVE_THRESHOLD
>> - on SNB/IVB: MEM_TRANS_RETIRED:LATENCY_ABOVE_THRESHOLD
>>
>> To make things easier, this patch also exports a generic
>> alias via sysfs: mem-loads. It export the right event
>> encoding based on the host CPU and can be used directly
>> by the perf tool.
>>
>> Loosely based on Intel's Lin Ming patch posted on LKML
>> in July 2011.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> SNIP
>
>> +/*
>> + * Map PEBS Load Latency Data Source encodings to generic
>> + * memory data source information
>> + */
>> +#define P(a, b) PERF_MEM_S(a, b)
>> +#define OP_LH (P(OP, LOAD) | P(LVL, HIT))
>> +#define SNOOP_NONE_MISS (P(SNOOP, NONE) | P(SNOOP, MISS))
>> +
>
> I checked Intel SDM 'Table 18-13. Data Source Encoding for Load Latency Record'
> and it seems to be different (below) at some points.. did you use another source?
>
Yeah, and the table is wrong in the SDM. What I have is correct and approved by
Intel.

>> +static const u64 pebs_data_source[] = {
>> +     P(OP, LOAD) | P(LVL, MISS) | P(LVL, L3) | P(SNOOP, NA),/* 0x00:ukn L3 */
>> +     OP_LH | P(LVL, L1) | P(SNOOP, NONE),    /* 0x01: L1 local */
>> +     OP_LH | P(LVL, LFB)| P(SNOOP, NONE),    /* 0x02: LFB hit */
>> +     OP_LH | P(LVL, L2) | P(SNOOP, NONE),    /* 0x03: L2 hit */
>> +     OP_LH | P(LVL, L3) | P(SNOOP, NONE),    /* 0x04: L3 hit */
>> +     OP_LH | P(LVL, L3) | P(SNOOP, MISS),    /* 0x05: L3 hit, snoop miss */
>> +     OP_LH | P(LVL, L3) | P(SNOOP, HIT),     /* 0x06: L3 hit, snoop hit */
>
> 0x6:
> L3 HIT. Local or Remote home requests that hit the L3 cache and was serviced by
> another processor core with a cross core snoop where modified copies were found.
> (HITM).
>
>
>> +     OP_LH | P(LVL, L3) | P(SNOOP, HITM),    /* 0x07: L3 hit, snoop hitm */
>
> 0x7:
> Reserved
>
>> +     OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HIT),  /* 0x08: L3 miss snoop hit */
>> +     OP_LH | P(LVL, REM_CCE1) | P(SNOOP, HITM), /* 0x09: L3 miss snoop hitm*/
>
> 0x9:
> Reserved
>
>> +     OP_LH | P(LVL, LOC_RAM)  | P(SNOOP, HIT),  /* 0x0a: L3 miss, shared */
>> +     OP_LH | P(LVL, REM_RAM1) | P(SNOOP, HIT),  /* 0x0b: L3 miss, shared */
>> +     OP_LH | P(LVL, LOC_RAM)  | SNOOP_NONE_MISS,/* 0x0c: L3 miss, excl */
>> +     OP_LH | P(LVL, REM_RAM1) | SNOOP_NONE_MISS,/* 0x0d: L3 miss, excl */
>> +     OP_LH | P(LVL, IO) | P(SNOOP, NONE), /* 0x0e: I/O */
>> +     OP_LH | P(LVL,UNC) | P(SNOOP, NONE), /* 0x0f: uncached */
>> +};
>
> thanks,
> jirka
