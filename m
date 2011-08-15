Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1HOEGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:06:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33283 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1HOEGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:06:12 -0400
Message-ID: <4E489B30.6080502@gmail.com>
Date: Sun, 14 Aug 2011 22:06:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490946-24673-1-git-send-email-dsahern@gmail.com> <20110617133230.GC25197@somewhere.redhat.com> <4DFB5F0B.4020903@gmail.com> <20110617141707.GE25197@somewhere.redhat.com> <4E1A7A0D.8000806@gmail.com> <20110712143024.GA9201@somewhere> <4E3AB66E.7070201@gmail.com> <20110808193033.GA2744@ghostprotocols.net>
In-Reply-To: <20110808193033.GA2744@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo:

On 08/08/2011 01:30 PM, Arnaldo Carvalho de Melo wrote:
>>>> The answer to the 'why' is that putting a reference timestamp in the
>>>> header field does not work for file appends across reboots. ie., the case:
>>>> perf record --tod ...
>>>> reboot
>>>> perf record -A --tod ...
>>>
>>> Damn append mode. I doubt that thing is really used. And it just complexifies
>>> everything. It might be wise to get rid of it?
>>>
>>> Ingo, Peter, Arnaldo?
>>>  
>>>> perf_clock timestamps change across reboots so the reference time
>>>> created by the first invocation is not valid for the append case. The
>>>> discussion then drifted towards having a kernel side event which per
>>>> past patch sets has its own issues.
>>>>
>>>> So to summarize the options proposed to date and issues with the proposals:
>>>> 1. reference timestamp in header
>>>>    - does not work for appends across reboots
>>>>
>>>> 2. synthesized events
>>>>    - preference against them
>>>>
>>>> 3. kernel side event
>>>>    - cannot generate an initial sample (with counter value and
>>>> perf_clock timestamp) on demand - e.g., start of session; a proposal to
>>>> use an ioctl to add one to the event stream was shot down
>>>>
>>>> At this point the only idea that comes to mind is to use a combination
>>>> of 2 and 3: add the kernel side clock event
>>>> (https://lkml.org/lkml/2011/2/18/11), read the realtime clock counter,
>>>> read the monotonic clock timestamp (ie., perf_clock value), and
>>>> synthesize a perf sample that is written to the file. The append case
>>>> (with mismatch in --tod options between record invocations) would be
>>>> handled by having the kernel side clock event in the event list
>>>> (perf_evlist__equal would fail if --tod was not used for all invocations).
>>>
>>> Actually you first have to face a deeper problem. events are not stored
>>> in order in the flow, but they are sorted from perf_session__process_events().
>>>
>>> The bunch of sorted events is flushed periodically and sent to the consumer.
>>>
>>> See flush_sample_queue().
>>>
>>> And this sorting is made on top of the sample->time timestamps. So events
>>> are first sorted on sample->time and only afterward you have access to your
>>> gtod tracepoint samples. But if that gtod sample has been taken after a reboot
>>> then its sample->time is not consistant with the rest. It is not well sorted
>>> and thus the reftime won't be updated at the right moment.
>>>
>>> So the problem is that reftime update already depends on a consistant cpu
>>> timestamp.
>>>
>>> I can't think about a sane way to work around that. Sorting on gtod + cpu timestamp
>>> is not a solution because gtod can change.
>>>
>>> I'd rather propose to refuse append mode as long as we have any timestamp. That includes
>>> gtod but also sample timestamps. They are buggy if we reboot.
>>
>> Arnaldo's sending patches, so I take it he's dug out from backlog. ;-)
>>
>> Any objections to not allowing append mode for perf-record if samples
>> contain timestamps?
> 
> I never used append mode, but having these restrictions on append mode
> seems to be counter intuitive, either we make timestamps work with
> append mode or we remove append mode completely.
> 
> Ingo?
> 
> - Arnaldo

Any opinion on prohibiting append mode if samples contain timestamps? To
summarize perf_clock is reset on reboots which affects sample ordering
for the append case. We can either remove the append option or not allow
it if samples have timestamps.

Thanks,
David
