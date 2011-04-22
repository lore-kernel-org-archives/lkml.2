Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1DVNqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:46:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36578 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab1DVNqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rh3Y2RXDty6Wo2rZrxvzmrjvor97GIzieLCq9bEmYD/pII4/cN6U4zqHtBXumQ3tU7
         8BXpk8mcSK987NIvxYSw==
MIME-Version: 1.0
In-Reply-To: <1303478798.2461.11.camel@localhost>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	<1303478798.2461.11.camel@localhost>
Date: Fri, 22 Apr 2011 15:46:09 +0200
Message-ID: <BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 3:26 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Fri, 2011-04-22 at 20:59 +0800, Stephane Eranian wrote:
>> Lin,
>>
>> In arch/x86/include/asm/smp.h, you added:
>>
>> static inline bool cpu_has_ht_siblings(void)
>> {
>>        bool has_siblings = false;
>> #ifdef CONFIG_SMP
>>        has_siblings = cpu_has_ht && smp_num_siblings > 1;
>> #endif
>>        return has_siblings;
>> }
>>
>> I am wondering about the goal of this function.
>>
>> Is it supposed to return whether or not HT is enabled?
>>
>> Ht enabled != HT supported
>
> It's used to check if HT is supported.
>
Ok, that makes more sense.

> But unfortunately, we didn't find a way to check if HT is enabled.
> So I just check if HT is supported.
>
>>
>> +static inline int is_ht_enabled(void)
>> +{
>> +       bool has_ht = false;
>> +#ifdef CONFIG_SMP
>> +       int w;
>> +       w = cpumask_weight(cpu_sibling_mask(smp_processor_id()));
>> +       has_ht = cpu_has_ht && w > 1;
>> +#endif
>> +       return has_ht;
>> +}
>>
>> OTOH, you need some validation even in the case HT is off. No two events
>> scheduled together on the same PMU can have different values for the extra
>> reg. Thus, the fact that cpu_has_ht_siblings() is imune to HT state helps here,
>> but then what's the point of it?
>
> The points is to avoid the percore resource allocations(which are used
> to sync between HTs) if HT is not supported.
>
But if you check x86_pmu.extra_regs, that should do it as well.

Suppose HT is disabled and I do:

perf stat -e offcore_response_0:dmd_data_rd,offcore_response_0:dmnd_rfo ......

This should still not be allowed.

I think in this case, HT supported will cause your code to still allocate the
per-core struct. There will be no matching of per-core structs in starting().
So I suspect things work.
