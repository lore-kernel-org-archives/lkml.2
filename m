Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab0EMKnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:43:14 -0400
Received: from snt0-omc1-s10.snt0.hotmail.com ([65.55.90.21]:10009 "EHLO
	snt0-omc1-s10.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758539Ab0EMKnN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:43:13 -0400
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS6290E10B4DF4E25B7054FA7FC0@phx.gbl>
From: "limp" <johnkyr83@hotmail.com>
To: "'john stultz'" <johnstul@us.ibm.com>
CC: <linux-kernel@vger.kernel.org>
References: <SNT111-DS115B558E5855C0FAEA860CA7F60@phx.gbl> <AANLkTin7itFVRzywm9g776bpE5IaFNsGVVW_PUbv0RKm@mail.gmail.com>
In-Reply-To: <AANLkTin7itFVRzywm9g776bpE5IaFNsGVVW_PUbv0RKm@mail.gmail.com>
Subject: RE: Weird timer handler used with LAPIC selected
Date: Thu, 13 May 2010 11:42:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcryLro21Ckp6R5pQYWrb445woxFDwAVKPzg
Content-Language: en-gb
X-OriginalArrivalTime: 13 May 2010 10:43:12.0822 (UTC) FILETIME=[16124D60:01CAF289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John and thanks for your reply,

>You might want to read the code in further detail. The clockevent
>device is an abstraction on top of the actual hardware, so the
>event_handler method is not mapped into the irq handler directly.
>
>So the local_apic_timer_interrupt() is called by the apic hardware
>interrupt, it then calls lapic clockevent device's event_handler()
>method, which is set to tick_handle_periodic(). Since you're in
>_PERIODIC mode, not _ONESHOT (hrtimers/nohz), this seems correct to
>me.

I have examined the code in more detail and now I see what you're saying.
The thing that is confusing me a bit is why the LAPIC interrupt triggers
the local_apic_timer_interrupt() and not the timer_interrupt() in time.c?
ASAIU, every timer IRQ should call timer_interrupt() and for there, 
according to the selected clocksource, the appropriate event_handler should
be called but for LAPIC this is not the case...

>> I have put some printks inside "local_apic_timer_interrupt" handler which
>> should never be executed as the handler selected for the timer is
>> "hrtimer_interrupt" and not "local_apic_timer_interrupt" as verified.
>
>Nope. Again, local_apic_timer_interrupt is the actual irq hook. It
>then calls the lapic clockevent device's event_handler() method, which
>is hrtimer_interrupt.

Hmm, I am quite sure that hrtimer_interrupt() event_handler is called from
timer_interrupt() and not from local_apic_timer_interrupt()..

The reason for not getting any printks from the "local_apic_timer_interrupt"
irq hook was because I was getting about 318-360 LOC (Local timer
interrupts)
- the number was varied at every system boot - and then they were stopped
and the
LOC number was not incremented!!!! I've put a printk in lapic_timer_setup
and it
seems that LAPIC was going to shutdown mode after a while. 

01[14:43] <limp> ...
01[14:43] <limp> [    0.046999] LIMP: lapic_timer_setup: the mode used is 1
01[14:43] <limp> [    0.046999] LIMP: lapic_timer_setup: the mode used is 2
01[14:43] <limp> ...
01[14:43] <limp> [    0.699077] LIMP: lapic_timer_setup: the mode used is 1

This solved by disabling ACPI from the kernel command line. After that, I
was
Getting LOCs at HZ rate and irq0_timer were stalled at boot time after some
initial ones (I guess there is no sense of getting LOCs and irq0_timer ticks
simultaneously on a uniprocessor target).  

It seems that the system were entering a deep sleep state and was never
waking
up. Again, this seems a bit weird as the irq0 timer interrupt was still
triggered
periodically at HZ rate and should have not let ACPI to put LAPIC timer into
sleep...

Another question is this: Is there a way to know when my target enters an
ACPI
power state? Also, is there a way to prevent my target for entering into
power
states, without having to disable the whole ACPI support (something like 
acpi_sleep=false)? 

Many thanks for the useful help.

Kind Regards

John K.

