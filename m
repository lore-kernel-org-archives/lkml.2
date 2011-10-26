Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1JZG02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:26:28 -0400
Received: from dns1.mips.com ([12.201.5.69]:32928 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1JZG01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:26:27 -0400
Message-ID: <4EA7A7FB.40304@mips.com>
Date: Wed, 26 Oct 2011 14:26:03 +0800
From: Deng-Cheng Zhu <dczhu@mips.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
References: <1319453820-12992-1-git-send-email-dczhu@mips.com> <1319453820-12992-3-git-send-email-dczhu@mips.com> <20111024140328.GA5770@ghostprotocols.net> <20111025152309.GA7623@ghostprotocols.net>
In-Reply-To: <20111025152309.GA7623@ghostprotocols.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: xkOxesOMUwnMNvlMgMbWsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 11:23 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 24, 2011 at 12:03:28PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Oct 24, 2011 at 06:57:00PM +0800, Deng-Cheng Zhu escreveu:
>>> __perf_evsel__open() is called per event, it does not work for all the
>>> grouped events at one time. So, currently group_fd will alway be -1 for
>>> the events in a group. This patch fixes it.
>>>
>>> Signed-off-by: Deng-Cheng Zhu<dczhu@mips.com>
>>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>>> Cc: Paul Mackerras<paulus@samba.org>
>>> Cc: Ingo Molnar<mingo@elte.hu>
>>> Cc: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
>>> ---
>>>   tools/perf/util/evsel.c |    3 +--
>>>   1 files changed, 1 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>>> index e389815..7bd0d9d 100644
>>> --- a/tools/perf/util/evsel.c
>>> +++ b/tools/perf/util/evsel.c
>>> @@ -219,9 +219,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
>>>   	}
>>>
>>>   	for (cpu = 0; cpu<  cpus->nr; cpu++) {
>>> -		int group_fd = -1;
>>> -
>>>   		for (thread = 0; thread<  threads->nr; thread++) {
>>> +			static int group_fd = -1;
>>>
>>>   			if (!evsel->cgrp)
>>>   				pid = threads->map[thread];
>>
>> Lets not do it that way, using statics for this is humm, ugly, IMHO.
>>
>> Just pass an integer pointer that is a member of perf_evlist, I'll work
>> on a patch now.
>>
>> Thanks for reporting the bug tho!
>
> Can you try this patch?
>
> I tested it with:
>
> [root@emilia ~]# perf top -e cycles -e instructions --group
>
> and
>
> [root@emilia ~]# perf record -e cycles -e instructions --group -a sleep 2
>

Your patch does fix the group fd issue. But to get event grouping
workable, the event state fix is still needed. Please see the discussion
here: http://www.spinics.net/lists/mips/msg42190.html

With _only_ your patch applied, I tested with the following commands on
MIPS 74K (4 counters available in total):

perf stat -g -e 
L1-dcache-load-misses,cycles,LLC-load-misses,iTLB-loads,instructions 
find / >/dev/null

I tried to group up to 5 events in the hope of seeing NOSPC error. But
the command didn't fail and output:

  Performance counter stats for 'find /':

            9300823 L1-dcache-load-misses
      <not counted> cycles
      <not counted> LLC-load-misses
      <not counted> iTLB-loads
      <not counted> instructions

        8.463207591 seconds time elapsed

This is due to the event state check in validate_group() filtering out
the grouped events in OFF state. They are in OFF state because we are
running the command with the perf tool as opposed to attaching to an
existing task:

builtin-stat.c:create_perf_stat_counter():

         if (target_pid == -1 && target_tid == -1) {
                 attr->disabled = 1;
                 attr->enable_on_exec = 1;
         }

I suppose X86 has this issue too -- collect_events() in validate_group()
won't do real work in the bottom half of the function.


Deng-Cheng
