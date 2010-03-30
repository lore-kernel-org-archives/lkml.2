Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0C3NxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 09:53:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0C3NxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 09:53:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=I4UlizR/ltCzGuaI7LR5cA/qvMh/c5hFE6iKiFOCQ6xJpFul03deaDR5kL9wdNyrK
	LpLN/pnygjLZV20xD1wPg==
MIME-Version: 1.0
In-Reply-To: <20100330134145.GI11907@erda.amd.com>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
Date: Tue, 30 Mar 2010 15:53:10 +0200
Message-ID: <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 3:41 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 30.03.10 12:11:46, Stephane Eranian wrote:
>> On Mon, Mar 29, 2010 at 6:36 PM, Robert Richter <robert.richter@amd.com> wrote:
>> > This patch set unifies performance counter bit masks for x86. All mask
>> > are almost the same for all x86 models and thus can use the same macro
>> > definitions in arch/x86/include/asm/perf_event.h. It removes duplicate
>> > code. There is also a patch that reverts some changes of the big
>> > perf_counter -> perf_event rename.
>> >
>>
>> But there are still fields which are unique to each vendor:
>> - GUEST vs. HOST on AMD
>> - ANY_THREAD on Intel.
>>
>> For instance, I noticed that in
>>
>> arch/x86/kernel/cpu/perf_event.c:__hw_perf_event_init():
>>
>>       if (attr->type == PERF_TYPE_RAW) {
>>                 hwc->config |= x86_pmu.raw_event(attr->config);
>>                 if ((hwc->config & ARCH_PERFMON_EVENTSEL_ANY) &&
>>                     perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
>>                         return -EACCES;
>>                 return 0;
>>         }
>>
>> Assumes ANY also exists on AMD processors. That is not the case.
>> This check needs to be moved into an Intel specific function.
>
> Generally, ARCH_PERFMON_EVENTSEL_* refers to:
>
>  Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume
>  3B: System Programming Guide, Part 2
>  30.2 ARCHITECTURAL PERFORMANCE MONITORING
>  Appendix A: Performance-Monitoring Events
>  Appendix B: Model-Specific Registers (MSRs)
>
> and AMD64_EVENTSEL_* to:
>
>  AMD64 Architecture Programmer's Manual Volume 2: System Programming
>  13.3.1 Performance Counters
>
> X86_* is generic.
>
> If a feature is available from both vendors, the names shouln't be
> changed. Instead the first introduced mask should be used (at least
> this is my suggestion).
>
> So, there are some ARCH_PERFMON_EVENTSEL_* masks that are Intel only,
> which is true for ARCH_PERFMON_EVENTSEL_ANY. And indead, the code
> should be checked for this. ARCH_PERFMON_EVENTSEL_ANY is always
> cleared on AMD cpus, so this code is ok. Actually the bit is cleared

Until AMD uses that bit too and you won't notice this test. This is a security
check specific to Intel and it should be in an Intel-specific function.

> for *all* cpus in x86_pmu_raw_event(), the code was and is broken for
> this.
>
Yes, needs to be authorized for any perfmon v3 and later revisions.

> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com
>
>
