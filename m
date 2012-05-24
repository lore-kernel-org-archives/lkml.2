Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2EXJGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:06:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41120 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab2EXJGf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <87sjeqq7i7.fsf@sejong.aot.lge.com>
References: <1337828525-1789-1-git-send-email-namhyung.kim@lge.com>
	<1337844471.9783.48.camel@laptop>
	<CABPqkBRcz1a738M7g484B0p-dJrKqP6GSLE7gpPN0H1w-72oWw@mail.gmail.com>
	<87sjeqq7i7.fsf@sejong.aot.lge.com>
Date: Thu, 24 May 2012 11:06:33 +0200
Message-ID: <CABPqkBQYrZ9V3avxhJ1Qid=QKkbYcpc0cTeJXE8wJyVOoEZuaQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Make cycles:p working on SNB
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:59 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Hi, Stephane
>
> On Thu, 24 May 2012 09:41:45 +0200, Stephane Eranian wrote:
>> On Thu, May 24, 2012 at 9:27 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>> On Thu, 2012-05-24 at 12:02 +0900, Namhyung Kim wrote:
>>>
>>>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>>>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>>>> @@ -1329,6 +1329,12 @@ static int intel_pmu_hw_config(struct perf_event *event)
>>>>                */
>>>>               u64 alt_config = X86_CONFIG(.event=0xc0, .inv=1, .cmask=16);
>>>>
>>>> +             /*
>>>> +              * SNB introduced INST_RETIRED.PREC_DIST for this purpose.
>>>> +              */
>>>> +             if (x86_pmu.pebs_constraints == intel_snb_pebs_event_constraints)
>>>> +                     alt_config = X86_CONFIG(.event=0xc0, .umask=0x01,
>>>> +                                             .inv=1, .cmask=16);
>>>>
>>>>               alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
>>>>               event->hw.config = alt_config;
>>>
>>> That's rather ugly.. but that's okay, I've actually got the patch for
>>> this still laying around, it needs a bit of an update though.
>>>
>> You cannot simply use PREC_DIST. This umask has some severe
>> restriction. When you measure it, NO other event on the the entire PMU
>> can be measured at the same time. It needs exclusive mode on SNB.
>>
>
> Yeah, I read something like above on the SDM. But just got confused with
> this:
>
> $ ./perf stat -e cycles:p,instructions,cache-references,cache-misses noploop 1
>
Passing :p in counting mode is useless, it does not do anything.
The :p  suffix is only meaningful is sampling mode where it enables PEBS.

>  Performance counter stats for 'noploop 1':
>
>     3,741,658,837 cycles                    #    0.000 GHz
>     3,618,983,116 instructions              #    0.97  insns per cycle
>            51,126 cache-references
>             7,357 cache-misses              #   14.390 % of all cache refs
>
>       1.000692634 seconds time elapsed
>
>
> Thanks,
> Namhyung
