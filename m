Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0JSRBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:01:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0JSRBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gp/MC1eb5174S1RTDcGVFNZVkjRSGexRhbttuehpIgnJ1N6cecOcWoGEqLOwTbuSJh
         EX+hxQhiORsdeiL3W0CA==
MIME-Version: 1.0
In-Reply-To: <1287507178.1998.3440.camel@laptop>
References: <4cbdcbea.8491d80a.25b0.ffffece8@mx.google.com>
	<1287507178.1998.3440.camel@laptop>
Date: Tue, 19 Oct 2010 19:01:40 +0200
Message-ID: <AANLkTik5_h1hVfX=1chezE6z25r4KV6GfzQZ+JvD8J_p@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix time tracking in samples
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 6:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-10-19 at 18:47 +0200, Stephane Eranian wrote:
>> This patch corrects time tracking in samples. Without this patch
>> both time_enabled and time_running may be reported as zero when
>> user asks for PERF_SAMPLE_READ.
>>
>> You use PERF_SAMPLE_READ when you want to sample the values of
>> other counters in each sample. Because of multiplexing, it is
>> necessary to know both time_enable, time_running to be able
>> to scale counts correctly.
>>
>> We defer updating timing until we know it is really needed, i.e.,
>> only when we have PERF_SAMPLE_READ.
>>
>> With this patch, the libpfm4 example task_smpl now reports
>> correct counts (shown on 2.4GHz Core 2):
>>
>> $ task_smpl -p 2400000000 -e unhalted_core_cycles:u,instructions_retired:u,baclears  noploop 5
>> noploop for 5 seconds
>> IIP:0x000000004006d6 PID:5596 TID:5596 TIME:466,210,211,430 STREAM_ID:33 PERIOD:2,400,000,000 ENA=1,010,157,814 RUN=1,010,157,814 NR=3
>>       2,400,000,254 unhalted_core_cycles:u (33)
>>       2,399,273,744 instructions_retired:u (34)
>>       53,340 baclears (35)
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> ---
>>
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index f309e80..04611dd 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -3494,6 +3494,9 @@ static void perf_output_read_group(struct perf_output_handle *handle,
>>  static void perf_output_read(struct perf_output_handle *handle,
>>                            struct perf_event *event)
>>  {
>> +     update_context_time(event->ctx);
>> +     update_event_times(event);
>> +
>>       if (event->attr.read_format & PERF_FORMAT_GROUP)
>>               perf_output_read_group(handle, event);
>>       else
>
>
> Right, except that this can actually corrupt the time measurements... :/
>
> Usually context times are updated under ctx->lock, and this is called
> from NMI context, which can interrupt ctx->lock..
>
Ok, I missed that. But I don't understand why you need the lock to
udpate the time. The lower-level clock is lockless if I recall. Can't you
use an atomic ops in update_context_time()?

> I was thinking about updating a local copy of the times, in that case
> you can only get funny times from samples, but it won't corrupt the
> actual running data.
>
You want time to be correct in every sample How would you detect
bogus timing?
