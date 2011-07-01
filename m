Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1GAKty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:49:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1GAKtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:49:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CKjd1Jw4R934Vrjy3LPqn8SrOXzzzUsrrik0fREChw6EcRP4eZQ2zSbj+8NmmyoMU
	G1ZasYkxtCHVjLSYln9iw==
MIME-Version: 1.0
In-Reply-To: <1309490230.24590.93.camel@minggr.sh.intel.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	<CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
	<CABPqkBRZf41wbJKq2PCdMzDhgNMn0VYkVsaZToS34AXpRzTGLw@mail.gmail.com>
	<1309490230.24590.93.camel@minggr.sh.intel.com>
Date: Fri, 1 Jul 2011 12:49:49 +0200
Message-ID: <CABPqkBSy4BxZRnWP2CUPRaazaEukJSaWe0USRt9XBBTePaJS7g@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 5:17 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Fri, 2011-07-01 at 00:27 +0800, Stephane Eranian wrote:
>> On Thu, Jun 30, 2011 at 2:10 PM, Stephane Eranian <eranian@google.com> wrote:
>> > On Thu, Jun 30, 2011 at 10:09 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> >> Hi, all
>> >>
>> >> I posted uncore patches months ago, but it was pended due to an uncore
>> >> interrupt problem.
>> >>
>> >> This series are cut to support uncore pmu counting only.
>> >> So uncore interrupt handling is not needed.
>> >>
>> > You're making the assumption that when counting, you can never construct
>> > a measurement that will cause a counter to overflow the 39 bits. If not, then
>> > you need interrupt handling even when counting.
>> >
>> The actual counter width is 48. But wrmsrl() can only write the bottom 32 bits
>> of a register. I think Intel fixed that only with SandyBridge (see Vol3b). Thus,
>> the risk of 'silent' wrap around is much higher now as you have only 31 bits
>> to play with.
>
> I just tested wrmsrl on uncore counters and it's surprised to me that it
> supports full write.
>
>        val64.low  = 0xFFFFEEEE;
>        val64.high = 0x12345678;
>
> On Nehalem/Westmere:
>
>        msr = 0x3b0; //NHM_MSR_UNCORE_PMC0
>        wrmsrl(msr, val64.full & 0xfffffffffff); //48 bits counter
>        rdmsrl(msr, val64.full);
>        printfk("counter value: 0x%llx\n", val64.full);
>
> I got:
>        counter value: 0x5678ffffeeee
>
> On SandyBridge:
>
>        msr = 0x716; //SNB_MSR_UNC_CBO_1_PER_CTR0
>        wrmsrl(msr, val64.full & 0xfffffffffff); //44 bits counter
>        rdmsrl(msr, val64.full);
>        printfk("counter value: 0x%llx\n", val64.full);
>
> I got:
>        counter value: 0x678ffffeeee
>
I tried on my Nehalem and SandyBridge (model 42) and I get the same results.
The restriction applies only to core PMU counters then.

But what's so weird is that on SandyBridge the counter counters are still
limited:

uncore counter value: 0x678ffffeeee
   core counter value: 0xffffffffeeee

Yet, IA32_PERF_CAPABILITIES.FW_WIDTH (bit13) is set, thus wrmsrl()
should write the full 48-bit width (see Vol3b 30.2.2.3).

Further testing revealed that you get full width ONLY with the fixed counter
counters:

FW_WIDTH=1
uncore counter value: 0x678ffffeeee
core counter value: 0xffffffffeeee
fixed counter value: 0x678ffffeeee

I suspect there is a bug in the HW or a bogus description in the SDM.
I will check on that with Intel.


>> But if I read your patch correctly, it seems you are avoiding wrmsrl() on the
>> counter. Instead, you are reading it when you start (prev_count) and using
>> that value to compute the delta on stop.
>>
>> Am I understanding your workaround correctly?
>
> Yes, but I didn't realize that it's a workaround.
>
> Lin Ming
>
>>
>>
>> >
>> >> The uncore pmu type is allocated dynamically and exported via sysfs.
>> >> $ cat /sys/bus/event_source/devices/uncore/type
>> >> 6
>> >>
>> >> You can count uncore raw events as below,
>> >> $ perf stat -e uncore:r0101 ls
>> >>
>> >> It reads uncore pmu type id from sysfs to setup perf_event_attr::type.
>> >>
>> >> Comments are appreciated.
>> >>
>> >> Thanks,
>> >> Lin Ming
>> >>
>> >>
>> >
>
>
>
