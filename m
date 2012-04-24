Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2DXOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:08:35 -0400
Received: from relay.parallels.com ([195.214.232.42]:41475 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2DXOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:08:34 -0400
Message-ID: <4F96B3DD.3070909@parallels.com>
Date: Tue, 24 Apr 2012 18:08:29 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120314 Thunderbird/10.0.3
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@mit.edu>,
        Jan Beulich <jbeulich@suse.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: x86: take precautions against spurious timer interrupts
References: <1335183494-19645-1-git-send-email-vdavydov@parallels.com> <4F96B0EB.1010601@windriver.com>
In-Reply-To: <4F96B0EB.1010601@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 05:55 PM, Paul Gortmaker wrote:
> On 12-04-23 08:18 AM, Vladimir Davydov wrote:
>> If hpet is enabled by hpet_late_init() - this usually occurs on systems
>> with buggy BIOS, which does not report about hpet presence through ACPI,
>> hpet_clockevent's event_handler can be left uninitialized by
>> clockevents_register_device() because of hpet_clockevent low rating (by
>> the time hpet_late_init() is called, high prio apic timers have already
>> been setup). The event_handler is then initialized a bit later by the
>> clocksource_done_booting() procedure.
>>
>> Normally, timer interrupts should not be delivered between these two
>> calls, but if e.g. the kernel is booted using kexec, there might be some
>> pending interrupts from the previous kernel's context, which can lead to
>> a NULL pointer dereference.
> Reading between the lines here, I'm guessing that this is specific
> to the kexec use case, and never seen anywhere else?

Yes, you're right. I've caught it several times while using kexec.

> In which case,
> it seems a shame to add another conditional to the main timer_interrupt
> for an event that may only happen once at boot, and even then, only
> in a corner use-case.  Can you deal with the invalid state somewhere
> in an _init section instead, perhaps even within CONFIG_KEXEC?  Or
> at least ensure a dummy no-op handler is attached early enough?
>
> Paul.
> --

Agree.

I can init hpet_clockevent.event_handler with clockevents_handle_noop() 
in its definition.

Will rework and resend.

Thanks for replying.

>
>> So, take precautions against spurious timer interrupts by checking the
>> event_handler value before calling it.
>> ---
>>   arch/x86/kernel/time.c |   18 +++++++++++++++++-
>>   1 files changed, 17 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
>> index c6eba2b..43bdd3a 100644
>> --- a/arch/x86/kernel/time.c
>> +++ b/arch/x86/kernel/time.c
>> @@ -57,7 +57,23 @@ EXPORT_SYMBOL(profile_pc);
>>    */
>>   static irqreturn_t timer_interrupt(int irq, void *dev_id)
>>   {
>> -	global_clock_event->event_handler(global_clock_event);
>> +	/*
>> +	 * If hpet is enabled by hpet_late_init(), event_handler can be left
>> +	 * uninitialized by clockevents_register_device() because of
>> +	 * hpet_clockevent low rating (by the time hpet_late_init() is called,
>> +	 * high prio apic timers have already been setup). The event_handler is
>> +	 * then initialized a bit later by the clocksource_done_booting()
>> +	 * procedure.
>> +	 *
>> +	 * Normally, timer interrupts should not be delivered between these two
>> +	 * calls, but if e.g. the kernel is booted using kexec, there might be
>> +	 * some pending interrupts from the previous kernel's context, which
>> +	 * can lead to a NULL pointer dereference.
>> +	 *
>> +	 * So, take precautions against spurious timer interrupts.
>> +	 */
>> +	if (global_clock_event->event_handler)
>> +		global_clock_event->event_handler(global_clock_event);
>>
>>   	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
>>   	if (MCA_bus)

