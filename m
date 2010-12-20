Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab0LTPen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:34:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61104 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab0LTPel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:34:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cJ31oQigBKGigV5LecqQHwGqki7wtYKcMR2XxSRv0NE3I4BZSqt10b9czMo5ACdOwi
         ORMv6U+crsgWb/YPqW3TK8DN1gizXPiA2F+8K46Tp4A4qpyZ1Djwk0oDaMfuwZvEXFjG
         O8jy9eX/VVWwSYxX1WGfuvJjxjqLXu2GRWiIs=
MIME-Version: 1.0
In-Reply-To: <4D0EF817.6020602@cn.fujitsu.com>
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<1288381751.1988.13.camel@laptop>
	<20101030192131.GB26503@elte.hu>
	<4D0CE05C.1070600@dcl.info.waseda.ac.jp>
	<4D0EF817.6020602@cn.fujitsu.com>
Date: Tue, 21 Dec 2010 00:34:39 +0900
X-Google-Sender-Auth: nPYRXvnmt1n9haSOYpl8GZ-5axU
Message-ID: <AANLkTinPzg5cZ5qvS2FP=+urdua0qvT_pAqqwmtPmbXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, ling.ma@intel.com,
        Zhao Yakui <yakui.zhao@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 15:30, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On Sun, 19 Dec 2010 01:25:00 +0900, Hitoshi Mitake wrote:
>>
>> On 2010年10月31日 04:21, Ingo Molnar wrote:
>>>
>>> * Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>>>
>>>> On Sat, 2010-10-30 at 01:01 +0900, Hitoshi Mitake wrote:
>>>>>
>>>>> This patch ports arch/x86/lib/memcpy_64.S to "perf bench mem".
>>>>> When PERF_BENCH is defined at preprocessor level,
>>>>> memcpy_64.S is preprocessed to includable form from the sources
>>>>> under tools/perf for benchmarking programs.
>>>>>
>>>>> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
>>>>> Cc: Ma Ling:<ling.ma@intel.com>
>>>>> Cc: Zhao Yakui<yakui.zhao@intel.com>
>>>>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>>>>> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
>>>>> Cc: Paul Mackerras<paulus@samba.org>
>>>>> Cc: Frederic Weisbecker<fweisbec@gmail.com>
>>>>> Cc: Steven Rostedt<rostedt@goodmis.org>
>>>>> Cc: Thomas Gleixner<tglx@linutronix.de>
>>>>> Cc: H. Peter Anvin<hpa@zytor.com>
>>>>> ---
>>>>> arch/x86/lib/memcpy_64.S | 30 ++++++++++++++++++++++++++++++
>>>>> 1 files changed, 30 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
>>>>> index 75ef61e..72c6dfe 100644
>>>>> --- a/arch/x86/lib/memcpy_64.S
>>>>> +++ b/arch/x86/lib/memcpy_64.S
>>>>> @@ -1,10 +1,23 @@
>>>>> /* Copyright 2002 Andi Kleen */
>>>>>
>>>>> +/*
>>>>> + * perf bench adoption by Hitoshi Mitake
>>>>> + * PERF_BENCH means that this file is included from
>>>>> + * the source files under tools/perf/ for benchmark programs.
>>>>> + *
>>>>> + * You don't have to care about PERF_BENCH when
>>>>> + * you are working on the kernel.
>>>>> + */
>>>>> +
>>>>> +#ifndef PERF_BENCH
>>>>
>>>> I don't like littering the actual kernel code with tools/perf/
>>>> ifdeffery..
>>>
>>>
>>> Yeah - could we somehow accept that file into a perf build as-is?
>>>
>>> Thanks,
>>>
>>> Ingo
>>>
>>
>> Really sorry for my slow work...
>>
>> BTW, I have a question for Miao and Ingo.
>> We are planning to implement new memcpy() of Miao,
>> and the important point is not removing previous memcpy()
>> for future architectures and benchmarkings.
>>
>> I feel that adding new CPU feature flag (like X86_FEATURE_REP_GOOD)
>> and switching memcpy() with alternative mechanism is good way.
>> (So we will have three memcpy()s: rep based, unrolled, and new
>> unaligned oriented one)
>> But there is another way: #ifdef. Which do you prefer?
>
> I agree with your idea, but Ma Ling said this way may cause the i-cache
> miss problem.
>  http://marc.info/?l=linux-kernel&m=128746120107953&w=2
> (The size of the i-cache is 32K, the size of memcpy() in my patch is
> 560Byte,
> and the size of the last version in tip tree is 400Byte).
>
> But I have not tested it, so I don't know the real result. Maybe we should
> try to implement the new memcpy() first.

I compared memcpy()'s icache miss behaviour with my new
--wait-on patch ( https://patchwork.kernel.org/patch/408801/ ).
And the result is,

default of tip tree

% sudo ./perf stat -w /tmp/perf-stat-wait -e L1-icache-load-misses

 Performance counter stats for process id '12559':

            64,328 L1-icache-load-misses

        0.106513157  seconds time elapsed

Miao Xie's memcpy()

% sudo ./perf stat -w /tmp/perf-stat-wait -e L1-icache-misses

 Performance counter stats for process id '13159':

            64,559 L1-icache-load-misses

        0.107057925  seconds time elapsed

It seems that there is no fatal icache miss.
# I tested perf bench mem memcpy with Core i3 M 330 processor.

But I don't understand well about cache characteristics of intel processor.
I have to look at this problem more deeply.

>
>> And could you tell me the detail of CPU family information
>> you are targeting, Miao?
>
> They are  Core2 Duo E7300(Core name: Wolfdale) and Xeon X5260(Core name:
> Wolfdale-DP).
>
> The following is the detailed information of these two CPU:
> Core2 Duo E7300:
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     E7300  @ 2.66GHz
> stepping        : 6
> cpu MHz         : 1603.000
> cache size      : 3072 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor
> ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm dts
> bogomips        : 5319.70
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
>
> Xeon X5260:
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Xeon(R) CPU           X5260  @ 3.33GHz
> stepping        : 6
> cpu MHz         : 1999.000
> cache size      : 6144 KB
> physical id     : 3
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 7
> initial apicid  : 7
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm
> constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor
> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm dts tpr_shadow
> vnmi flexpriority
> bogomips        : 6649.07
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 38 bits physical, 48 bits virtual
> power management:
>

Thanks for your information!

Thanks,
        Hitoshi
