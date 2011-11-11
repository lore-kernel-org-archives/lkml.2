Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab1KKJy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:54:59 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23949 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab1KKJy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:54:56 -0500
Message-ID: <4EBCF0EB.8080304@gmail.com>
Date: Fri, 11 Nov 2011 13:54:51 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Arun Sharma <asharma@fb.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, devel@openvz.org
Subject: Re: [PATCH 2/7] event: don't divide events if it has field period
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>	 <1320670457-2633428-3-git-send-email-avagin@openvz.org> <1320839740.13360.11.camel@twins>
In-Reply-To: <1320839740.13360.11.camel@twins>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 03:55 PM, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 15:54 +0300, Andrew Vagin wrote:
>> This patch solves the following problem:
>>
>> Now some samples may be lost due to throttling. The number of samples is
>> restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is
>> divided on some samples according to event's period.  I don't sure, that
>> we should generate more than one sample on each trace event. I think the
>> better way to use SAMPLE_PERIOD.
> It would be yes, but this code predates that, also it needs to work even
> if the user doesn't provide SAMPLE_PERIOD.

Actually it's another task. Your task requires more time to think over. 
It would be good, if someone will suggest me a good use case for this 
scenario.
My code works well and I think we should have this functional in the kernel.

When I think how to fix working without SAMPLE_PERIOD, only one idea is 
appeared, it's adjusting of a sample period. In this case we will have 
many other questions. E.g.:
1. When a sample period should be adjusted. Do we need a warm up load?
2. If we adjust a sample period during measuring load, how will we 
compare samples before and after adjustments. We can send an event, that 
a sample period has been adjusted.

>> E.g.: I want to trace when a process sleeps. I created a process, which
>> sleeps for 1ms and for 4ms.  perf got 100 events in both cases.
>>
>> swapper     0 [000]  1141.371830: sched_stat_sleep: comm=foo pid=1801 delay=1386750 [ns]
>> swapper     0 [000]  1141.369444: sched_stat_sleep: comm=foo pid=1801 delay=4499585 [ns]
>>
>> In the first case a kernel want to send 4499585 events and
>> in the second case it wants to send 1386750 events.
>> perf-reports shows that process sleeps in both places equal time. It's
>> bug.
>>
>> With this patch kernel generates one event on each "sleep" and the time
>> slice is saved in the field "period". Perf know how handle it.
> Yeah, looks about right, would be awesome if we could strip some
> branches out, but nothing obvious comes to mind.
>
>> Signed-off-by: Andrew Vagin<avagin@openvz.org>
>> ---
>>   kernel/events/core.c |    7 ++++++-
>>   1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 12a0287..298702d 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -4737,7 +4737,6 @@ static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
>>   	struct hw_perf_event *hwc =&event->hw;
>>   	int throttle = 0;
>>
>> -	data->period = event->hw.last_period;
>>   	if (!overflow)
>>   		overflow = perf_swevent_set_period(event);
>>
>> @@ -4771,6 +4770,12 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
>>   	if (!is_sampling_event(event))
>>   		return;
>>
>> +	if (event->attr.sample_type&  PERF_SAMPLE_PERIOD&&  !event->attr.freq) {
>> +		data->period = nr;
>> +		return perf_swevent_overflow(event, 1, data, regs);
>> +	} else
>> +		data->period = event->hw.last_period;
>> +
>>   	if (nr == 1&&  hwc->sample_period == 1&&  !event->attr.freq)
>>   		return perf_swevent_overflow(event, 1, data, regs);
>>

