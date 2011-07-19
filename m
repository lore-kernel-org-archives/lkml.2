Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1GSWY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:24:56 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53377 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:24:55 -0400
Message-ID: <4E260400.4060401@candelatech.com>
Date: Tue, 19 Jul 2011 15:24:00 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG spinlock lockup, rtc related, 3.0-rc7+
References: <4E1DD5DF.2040408@candelatech.com> <CANcMJZBHMKXbDqgvKnZ-iiCbFm0a_5zyP179ReXF+cmRyM=O7w@mail.gmail.com>
In-Reply-To: <CANcMJZBHMKXbDqgvKnZ-iiCbFm0a_5zyP179ReXF+cmRyM=O7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 03:17 PM, john stultz wrote:
> On Wed, Jul 13, 2011 at 10:29 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> This is on the same nfs testing machine I've been posting about.  This
>> has some additional nfs patches included, running tests to mount, do io,
>> unmount
>> over and over again.  Seems that the NFS bugs might be finally fixed, but
>> system is still un-stable in general when under load.
>>
>> This info was printed after several other warnings that I previously posted
>> to lkml.
>>
>> This one appears to lock up the machine pretty badly though...can't ssh into
>> it anymore, and similar messages keep spewing every few minutes.
>>
>> I *think* the BUG at the end of this email is the important part, but
>> maybe it's just a symptom of something else...
>
> Huh. So does this trigger frequently, or was this just a one time
> thing? I suspect the latter.

It seems I have been hitting a lot of rcu-boost locking issues
on this system with my nfs mount/unmount testing.

The system was having various lockups and bugs, but I don't think
I saw this particular one more than once or perhaps twice.

I plan to run some more tests with the rcu-boost locking fixes
applied to the kernel shortly.

At the time I reported this, I wasn't aware of the rcu boost bugs,
but perhaps that is root cause here as well...I don't know enough
about the code in question to make an educated guess.

>> From the looks of it, there's the btserver process (on cpu4) which
> during exit is caught up spinning trying to get the hrtimer base lock
> from hrtimer_cancel() in rtc_irq_set_state() when cleaning up from
> rtc_device_release().
>
> Meanwhile, On cpu0, a rtc periodic timer has fired and we're stuck in
> rtc_handle_legacy_irq(), likely waiting for the irq_task_lock held by
> cpu4 in rtc_irq_set_state().
>
> The rest of the cpus are idle, with the exception of the one that
> detected the stall from the normal timer tick.
>
> Hrmm.. It sounds like a circular lock between the rtc->irq_task_lock
> and the hrtimer base lock.
>
> rtc_irq_set_state: Grab irq_task_lock ->  call hrtimer_cancel ->  grab
> hrtimer_base_lock
>
> IRQ:  grab hrtimer_base_lock ->  run timers ->  rtc_handle_legacy_irq ->
> grab irq_task_lock
>
> But looking at __run_hrtimer(), the base lock should be released
> before the timer is run.
>
> So I'm not really sure what would be gumming up things here.
>
> Thomas: Any thoughts? There shouldn't be an issue calling
> hrtimer_cancel or other hrtimer operations from an  hrtimer handler
> right?
>
> thanks
> -john


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

