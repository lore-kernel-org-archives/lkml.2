Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3AGNKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:10:22 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42714 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3AGNKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:10:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130102140752.GC931@krava.brq.redhat.com>
References: <1356018108-6081-1-git-send-email-eranian@google.com>
	<1356018108-6081-6-git-send-email-eranian@google.com>
	<20130102140752.GC931@krava.brq.redhat.com>
Date: Mon, 7 Jan 2013 14:10:20 +0100
Message-ID: <CABPqkBQW0zKZoFoFZrTAV2f7vDeB8-CeMtQWcbA+K_aZatGrEA@mail.gmail.com>
Subject: Re: [PATCH v4 05/18] perf: add minimal support for PERF_SAMPLE_WEIGHT
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

On Wed, Jan 2, 2013 at 3:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Dec 20, 2012 at 04:41:35PM +0100, Stephane Eranian wrote:
>> Ensure we grab the weight from  raw sample struct
>> and that we can dump it via perf report -D.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  tools/perf/util/event.h   |    1 +
>>  tools/perf/util/evsel.c   |    5 +++++
>>  tools/perf/util/session.c |    3 +++
>>  3 files changed, 9 insertions(+)
>>
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 0d573ff..cf52977 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -90,6 +90,7 @@ struct perf_sample {
>>       u64 period;
>>       u32 cpu;
>>       u32 raw_size;
>> +     u64 weight;
>>       void *raw_data;
>>       struct ip_callchain *callchain;
>>       struct branch_stack *branch_stack;
>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> index 1b16dd1..4374c07 100644
>> --- a/tools/perf/util/evsel.c
>> +++ b/tools/perf/util/evsel.c
>> @@ -1058,6 +1058,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
>>               }
>>       }
>>
>> +     if (type & PERF_SAMPLE_WEIGHT) {
>> +             data->weight= *array;
>> +             array++;
>> +     }
>> +
>
> this bit should be placed right after PERF_SAMPLE_PERIOD (where
> you placed it in kernel path), otherwise you get wrong data
>

Thought some more about this. I think this new WEIGHT sample type is
in the wrong place in Andi's patch.
It's new, it should be put at the end of perf_output_sample(). That's
necessary to ensure older versions
of perf (without the knowledge about WEIGHT) can still decode
PERF_SAMPLE_READ in case
PERF_SAMPLE_WEIGHT is present in the perf.data file.

I will update his patch to reflect this change.
