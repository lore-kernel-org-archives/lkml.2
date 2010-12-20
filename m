Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0LTG3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 01:29:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0LTG3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 01:29:07 -0500
Message-ID: <4D0EF817.6020602@cn.fujitsu.com>
Date: Mon, 20 Dec 2010 14:30:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma@dcl.info.waseda.ac.jp,
        "\"Ling@dcl.info.waseda.ac.jp\":" <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] perf bench: port memcpy_64.S to perf bench
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1288381751.1988.13.camel@laptop> <20101030192131.GB26503@elte.hu> <4D0CE05C.1070600@dcl.info.waseda.ac.jp>
In-Reply-To: <4D0CE05C.1070600@dcl.info.waseda.ac.jp>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-20 14:28:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-20 14:28:57
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Dec 2010 01:25:00 +0900, Hitoshi Mitake wrote:
> On 2010年10月31日 04:21, Ingo Molnar wrote:
>>
>> * Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>>
>>> On Sat, 2010-10-30 at 01:01 +0900, Hitoshi Mitake wrote:
>>>> This patch ports arch/x86/lib/memcpy_64.S to "perf bench mem".
>>>> When PERF_BENCH is defined at preprocessor level,
>>>> memcpy_64.S is preprocessed to includable form from the sources
>>>> under tools/perf for benchmarking programs.
>>>>
>>>> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
>>>> Cc: Ma Ling:<ling.ma@intel.com>
>>>> Cc: Zhao Yakui<yakui.zhao@intel.com>
>>>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>>>> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
>>>> Cc: Paul Mackerras<paulus@samba.org>
>>>> Cc: Frederic Weisbecker<fweisbec@gmail.com>
>>>> Cc: Steven Rostedt<rostedt@goodmis.org>
>>>> Cc: Thomas Gleixner<tglx@linutronix.de>
>>>> Cc: H. Peter Anvin<hpa@zytor.com>
>>>> ---
>>>> arch/x86/lib/memcpy_64.S | 30 ++++++++++++++++++++++++++++++
>>>> 1 files changed, 30 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
>>>> index 75ef61e..72c6dfe 100644
>>>> --- a/arch/x86/lib/memcpy_64.S
>>>> +++ b/arch/x86/lib/memcpy_64.S
>>>> @@ -1,10 +1,23 @@
>>>> /* Copyright 2002 Andi Kleen */
>>>>
>>>> +/*
>>>> + * perf bench adoption by Hitoshi Mitake
>>>> + * PERF_BENCH means that this file is included from
>>>> + * the source files under tools/perf/ for benchmark programs.
>>>> + *
>>>> + * You don't have to care about PERF_BENCH when
>>>> + * you are working on the kernel.
>>>> + */
>>>> +
>>>> +#ifndef PERF_BENCH
>>>
>>> I don't like littering the actual kernel code with tools/perf/
>>> ifdeffery..
>>
>>
>> Yeah - could we somehow accept that file into a perf build as-is?
>>
>> Thanks,
>>
>> Ingo
>>
>
> Really sorry for my slow work...
>
> BTW, I have a question for Miao and Ingo.
> We are planning to implement new memcpy() of Miao,
> and the important point is not removing previous memcpy()
> for future architectures and benchmarkings.
>
> I feel that adding new CPU feature flag (like X86_FEATURE_REP_GOOD)
> and switching memcpy() with alternative mechanism is good way.
> (So we will have three memcpy()s: rep based, unrolled, and new
> unaligned oriented one)
> But there is another way: #ifdef. Which do you prefer?

I agree with your idea, but Ma Ling said this way may cause the i-cache
miss problem.
   http://marc.info/?l=linux-kernel&m=128746120107953&w=2
(The size of the i-cache is 32K, the size of memcpy() in my patch is 560Byte,
and the size of the last version in tip tree is 400Byte).

But I have not tested it, so I don't know the real result. Maybe we should
try to implement the new memcpy() first.

> And could you tell me the detail of CPU family information
> you are targeting, Miao?

They are  Core2 Duo E7300(Core name: Wolfdale) and Xeon X5260(Core name: Wolfdale-DP).

The following is the detailed information of these two CPU:
Core2 Duo E7300:
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E7300  @ 2.66GHz
stepping	: 6
cpu MHz		: 1603.000
cache size	: 3072 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm sse4_1 lahf_lm dts
bogomips	: 5319.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

Xeon X5260:
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           X5260  @ 3.33GHz
stepping	: 6
cpu MHz		: 1999.000
cache size	: 6144 KB
physical id	: 3
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm dts tpr_shadow vnmi flexpriority
bogomips	: 6649.07
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

Thanks
Miao
