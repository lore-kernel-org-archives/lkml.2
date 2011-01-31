Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1AaD0I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:26:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1AaD0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SjBY5OJhKcubqSLKJZz7oOBgGPKS0kY58qHJyI8pN7HFpgrhVEBifk/9jajE2qJ3Y5
         b+DMXZlbXhFZcnCqbR9Dz+IvxFShn0wyIH4AGBnQ/Wx+HQ0sXfkr0fem5lDAvl4OAwuV
         EDRbJqt8QUvugS4uAvtQ3jG+GuLufAW5qxxnI=
MIME-Version: 1.0
In-Reply-To: <1296405366.2274.60.camel@twins>
References: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
	<1295894492.28776.470.camel@laptop>
	<AANLkTimq3jmza-t5iL10wgLLycwdDkJ3mznLQsKHM_Kf@mail.gmail.com>
	<1295946736.28776.479.camel@laptop>
	<AANLkTikQs1UcfBGf_6shNVtdDSzR+8XzUKcx0amFZXey@mail.gmail.com>
	<1296210619.15234.263.camel@laptop>
	<AANLkTikagMAGssG09D+SCKTsu9T+==R2fsSM3tgHctdv@mail.gmail.com>
	<1296405366.2274.60.camel@twins>
Date: Sun, 30 Jan 2011 22:26:04 -0500
Message-ID: <AANLkTinxHXqndfP79W0=zer70psi6Dmkcv7rZc4ew7ZF@mail.gmail.com>
Subject: Re: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, 2011-01-29 at 13:44 +0800, Luming Yu wrote:
>> On Fri, Jan 28, 2011 at 6:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> We have seen an extremely slow system under the CPU-OFFLINE-ONLIE test
>> >> on a 4-sockets NHM-EX system.
>> >
>> > Slow is OK, cpu-hotplug isn't performance critical by any means.
>>
>> Here is one example that the "slow" is not acceptable. Maybe I should
>> not use "slow" in the first place. It happnes after I resolved a
>> similar NMI watchdog warnning in calibrate_delay_direct..
>>
>> Please note, I got the BUG in a 2.6.32-based kernel. Upstream  behaves
>> similar I guess.
>
> Guessing is totally the wrong thing when you're sending stuff upstream,
> esp ugly patches such as this. .32 is more than a year old, anything
> could have happened.

Ok. the default upstream kernel seems to have NMI watchdog disabled?
since there is 0 NMI.

# cat /proc/interrupts | grep -i nmi
 NMI:          0          0          0          0          0
0          0          0          0          0          0          0
      0          0          0          0          0          0
 0          0          0          0          0          0          0
       0          0          0          0          0          0
  0          0          0          0          0          0          0
        0          0          0          0          0          0
   0          0          0          0          0          0          0
         0          0          0          0          0          0
    0          0          0          0          0          0
Non-maskable interrupts
[root@intel-s3e36-02 ~]# uptime
 21:43:27 up 34 min,  2 users,  load average: 0.40, 1.27, 2.32

But there is a problem like this:

Booting Node 3 Processor 59 APIC 0x75
Clocksource tsc unstable (delta = -77316000544 ns)
Switching to clocksource hpet


>
>> BUG: soft lockup - CPU#63 stuck for 61s! [migration/63:256]
>
>> > If its slow but working, the test is broken, I don't see a reason to do
>> > anything to the kernel, let alone the below.
>>
>> It not working sometimes, so I think it's not a solid feature right now.
>
> But you didn't say anything about not working, you merely said slow. If
> its not working, you need to very carefully explain what is not working,
> where its deadlocked and how your patch solves this and how you avoid
> wrecking stuff for everybody else.

It's not working because of NMI watchdog. If you ignore NMI watchdog,
then I guess it works but just slow..

>
>> >>  since it currently unnecessarily implicitly interact with
>> >> CPU power management.
>> >
>> > daft statement at best, because if not for some misguided power
>> > management purpose, what are you actually unplugging cpus for?
>> > (misguided because unplug doesn't actually safe more power than simply
>> > idling the cpu).
>> It's a RAS feature and Suspend Resume also hits same code path I think.
>
> That still doesn't say anything, also who in his right mind suspends a
> nhm-ex system?

But we need to have a solid code in place. We can't blame user who
could find something useful with trying that. Let hotplug code to
implicitly interact with CPU PM will complicate things unnecessarily.

>
>> > So you flip the pm_idle pointer protected unter hotplug mutex, but
>> > that's not serialized against module loading, so what happens if you
>> > concurrently load a module that sets another idle policy?
>> >
>> > Your changelog is vague at best, so what exactly is the purpose here? We
>> > flip to default_idle(), which uses HLT, which is C1. Then you run
>> > cpu_idle_wait(), which will IPI all cpus, all these CPUs (except one)
>> > could have been in deep C states (C3+) so you get your slow wakeup
>> > anyway.
>> >
>> > There-after you do the normal stop-machine hot-plug dance, which again
>> > will IPI all cpus once, then you flip it back to the saved pm_idle
>> > handler and again IPI all cpus.
>>
>> https://lkml.org/lkml/2009/6/29/60
>> it needs 50-100us latency to send one IPI, you could get an idea on a
>> large NHM-EX system which contains 64 logical processors. With
>> Tickless and APIC timer stopped in C3 on NHM-EX, you could also have
>> an idea about the problem I have.
>
> Ok, so one IPI costs 50-100 us, even with 64 cpu, that's at most 6.4ms
> nowhere near enough to trigger the NMI watchdog. So what does go wrong?

Good question!
But we also can't forget there were large latency from C3.
And I guess some reschedule ticks get lost to kick some CPUs out of
idle due to the side effects of the CPU PM feature. if use nohz=off,
everything seems to just work.
Yes, I agree we need to dig it out either.
But it's kind of combination problem between the special stop_machine
context and CPU power management...

>
> Why does your patch solve things, like said, it doesn't avoid the slow
> IPI at all, you still IPI each cpu right after changing the pm_idle
> function. Those IPIs will still hit C3+ states.
>
>> Let me know if there are still questions .
>
> Yeah, what are you smoking? Why do you wreck perfectly fine code for one
> backward ass piece of hardware.

Just make things less complex...

Thanks
Luming
