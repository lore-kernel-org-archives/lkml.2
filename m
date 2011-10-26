Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1JZNPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:15:14 -0400
Received: from dns1.mips.com ([12.201.5.69]:39566 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1JZNPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:15:12 -0400
From: "Zhu, DengCheng" <dczhu@mips.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: RE: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
Thread-Topic: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its
 place in __perf_evsel__open()
Thread-Index: AQHMkju1Q0JBTx399kSCqVHBUY2iJpWL/EkAgAGomICAAYJhgP//y5cA//+ipys=
Date: Wed, 26 Oct 2011 13:14:53 +0000
Message-ID: <BD04AF0D5BE72443A0B69C1C0486AD3ECE8D9654@exchdb03.mips.com>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
 <1319453820-12992-3-git-send-email-dczhu@mips.com>
 <20111024140328.GA5770@ghostprotocols.net>
 <20111025152309.GA7623@ghostprotocols.net>
 <4EA7A7FB.40304@mips.com>,<20111026111828.GB9467@ghostprotocols.net>
In-Reply-To: <20111026111828.GB9467@ghostprotocols.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.36.79]
x-ems-proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
x-ems-stamp: 7fcZcbEsMJXiNYHaxY10vA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ________________________________________
> From: Arnaldo Carvalho de Melo [arnaldo.melo@gmail.com] on behalf of Arnaldo Carvalho de Melo [acme@ghostprotocols.net]
> Sent: Wednesday, October 26, 2011 7:18 PM
> To: Zhu, DengCheng
> Cc: linux-kernel@vger.kernel.org; Peter Zijlstra; Paul Mackerras; Ingo Molnar
> Subject: Re: [RFC PATCH 2/2] tools/perf: Make group_fd static and move its place in __perf_evsel__open()
>
> Em Wed, Oct 26, 2011 at 02:26:03PM +0800, Deng-Cheng Zhu escreveu:
>> On 10/25/2011 11:23 PM, Arnaldo Carvalho de Melo wrote:
>> >Em Mon, Oct 24, 2011 at 12:03:28PM -0200, Arnaldo Carvalho de Melo escreveu:
>> >>Em Mon, Oct 24, 2011 at 06:57:00PM +0800, Deng-Cheng Zhu escreveu:
>> >>>__perf_evsel__open() is called per event, it does not work for all the
>> >>>grouped events at one time. So, currently group_fd will alway be -1 for
>
> <SNIP>
>
>> >>>+                  static int group_fd = -1;
>> >>>                   if (!evsel->cgrp)
>> >>>                           pid = threads->map[thread];
>
>> >>Lets not do it that way, using statics for this is humm, ugly, IMHO.
>
>> >Can you try this patch?
>
>> >I tested it with:
>
>> >[root@emilia ~]# perf top -e cycles -e instructions --group
>
>> Your patch does fix the group fd issue. But to get event grouping
>> workable, the event state fix is still needed. Please see the discussion
>
> Can I have your "Reviewed-by:" or "Tested-by:" tag for this patch then?

Yes, you may add my:

Tested-by: Deng-Cheng Zhu <dczhu@mips.com>

>> here: http://www.spinics.net/lists/mips/msg42190.html
>
>> With _only_ your patch applied, I tested with the following commands on
>> MIPS 74K (4 counters available in total):
>>
>> perf stat -g -e
>> L1-dcache-load-misses,cycles,LLC-load-misses,iTLB-loads,instructions
>> find / >/dev/null
>>
>> I tried to group up to 5 events in the hope of seeing NOSPC error. But
>> the command didn't fail and output:
>>
>>  Performance counter stats for 'find /':
>>
>>            9300823 L1-dcache-load-misses
>>      <not counted> cycles
>>      <not counted> LLC-load-misses
>>      <not counted> iTLB-loads
>>      <not counted> instructions
>>
>>        8.463207591 seconds time elapsed
>>
>> This is due to the event state check in validate_group() filtering out
>> the grouped events in OFF state. They are in OFF state because we are
>> running the command with the perf tool as opposed to attaching to an
>> existing task:
>>
>> builtin-stat.c:create_perf_stat_counter():
>>
>>         if (target_pid == -1 && target_tid == -1) {
>>                 attr->disabled = 1;
>>                 attr->enable_on_exec = 1;
>>         }
>
> But they should be in OFF state only till the target program gets
> exec'ed, right?
>

Yes, or else event timestamps won't be updated on exec. That's why I came
to a new idea in one of my MIPS perf-events patches (link provided above). 

>> I suppose X86 has this issue too -- collect_events() in validate_group()
>> won't do real work in the bottom half of the function.
>
> I'm testing that now.

As you can see from the test results in your another post, I think we see
"not counted" because collect_events() in validate_group() does not do real
work on events in OFF state. On x86 a patch may be needed in event init,
but on MIPS (or ARM) I suppose the pmu and event state checks in
validate_event() perhaps could be deleted...


Deng-Cheng
