Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab1ADNip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:38:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADNio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wSMB/l8rcqo0tqMk8Yuxh15QIZx6Nng+9uc2fbpw0fahpswiHUx+8VaLkr8SSIqzv1
         M9bQxfFiG1doRSURMHFA==
MIME-Version: 1.0
In-Reply-To: <1294139419.2016.115.camel@laptop>
References: <1293464211.2695.104.camel@localhost>
	<AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	<1293526288.2457.4.camel@minggr.sh.intel.com>
	<1294052312.2016.50.camel@laptop>
	<4D222926.9010206@zytor.com>
	<1294139419.2016.115.camel@laptop>
Date: Tue, 4 Jan 2011 14:38:41 +0100
Message-ID: <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had to deal with this issue with perfmon back in 2.6.30 and earlier kernels.
I remember that I was surprised not to find any easy helper function to figure
this out back then. Being HT capable is different from having HT enabled.
Seems like the situation has not improved since then.

My solution at the time (2.6.30) was to do:
        ht_enabled = cpumask_weight(__get_cpu_var(cpu_sibling_map)) > 1;

Not too convinced the per-cpu variable is necessary because I don't
know of a BIOS that would allow you to turn on HT on only some of the
cores (AFAIK, this is an all or nothing feature).


On Tue, Jan 4, 2011 at 12:10 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-01-03 at 11:53 -0800, H. Peter Anvin wrote:
>> On 01/03/2011 02:58 AM, Peter Zijlstra wrote:
>> >>
>> >> This function can be simplified as below,
>> >>
>> >> static bool ht_enabled()
>> >> {
>> >>         if (!cpu_has(&boot_cpu_data, X86_FEATURE_HT))
>> >>                 return false;
>> >>
>> >>         return smp_num_siblings > 1;
>> >> }
>> >>
>> >> But this still can't detect if HT is on or off.
>> >> smp_num_siblings is always 2 even if HT is disabled in BIOS.
>> >>
>> >> Any idea how to detect if HT is on or not?
>> >
>> > Not quite sure, the intel docs aren't really clear on how the HW
>> > supports HT, has 2 siblings but BIOS disabled it thing works. I just
>> > tried reading the arch/x86 code but that only got me more confused.
>> >
>> > hpa, could you comment?
>> >
>>
>> Zeroeth of all: anyone who writes () in a function prototype in C needs
>> to get severely napalmed, maimed, hung and then really hurt.  It is
>> (void) in C, () means (...) which is literally NEVER what you want.
>>
>> Now, *first* of all: smp_num_siblings as it sits is obviously broken;
>> the whole notion of a global variable for what is inherently a per-cpu
>> property is just braindead.  At least theoretically there could be cores
>> with and without HT or with different thread count in the same system.
>>
>> Second, perf should get this from /proc/cpuinfo, not by grotting around
>> cpuid by itself.
>
> Its the kernel space bit that wants to know if HT is enabled on CPU
> bringup, /proc/cpuinfo is kinda useless in that context.
>
>> Third, the code in the kernel is indeed pretty confusing, and it also
>> has the global variable braindamage... but either it works (in which
>> case getting the data from /proc/cpuinfo works) or it needs fixing in
>> addition to the global variable issue.
>
> So you failed to address the primary question, how do we tell if HT is
> enabled for a particular CPU?
>
> X86_FEATURE_HT tells us the CPU supports telling us about HT,
> smp_num_siblings > 1 tells us the CPU is capable of HT. But Lin found
> that if you disable HT in the BIOS both those are true but we still
> don't have HT enabled.
>
> The problem we have to address is that Intel has some MSRs shared
> between threads and if HT is enabled we need to allocate some memory to
> manage this shared resource.
>
> The simple check outlined above X86_FEATURE_HT && smp_num_siblings > 1,
> will get us most of the way and will I think be good enough (false
> positives but no false negatives). But it did get us wondering about how
> all this works.
>
> So could you, irrespective of Linux implementation details tell us how
> to detect if HT is available and enabled from a HW and BIOS perspective?
>
