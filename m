Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2ENKoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:44:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:51293 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab2ENKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:44:05 -0400
Message-ID: <4FB0E1EE.6080002@parallels.com>
Date: Mon, 14 May 2012 14:43:58 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120425 Thunderbird/10.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: x86: init hpet event_handler to noop
References: <1335283031-12942-1-git-send-email-vdavydov@parallels.com> <alpine.LFD.2.02.1205072150590.6271@ionos>
In-Reply-To: <alpine.LFD.2.02.1205072150590.6271@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 12:26 AM, Thomas Gleixner wrote:
> On Tue, 24 Apr 2012, Vladimir Davydov wrote:
>
>> If hpet is enabled by hpet_late_init() - this usually occurs on systems
>> with buggy BIOS, which does not report about hpet presence through ACPI,
>> hpet_clockevent's event_handler can be left uninitialized by
>> clockevents_register_device() because of hpet_clockevent low rating (by
>> the time hpet_late_init() is called, high prio apic timers have already
>> been setup). The event_handler is then initialized a bit later by the
>> clocksource_done_booting() procedure.
>>
> This explanation is worse than an oracle and aside of that, it's
> patently wrong.
>
> How the hell is clocksource_done_booting() related to the HPET
> clockevent mechanism?
>
>> Normally, timer interrupts should not be delivered between these two
>> calls, but if e.g. the kernel is booted using kexec, there might be some
>> pending interrupts from the previous kernel's context, which can lead to
>> a NULL pointer dereference in timer_interrupt().
> How is kexec related to this?
>
> And how should pending interrupts be not handled by the always first
> initialized PIT ?

 From timer_interrupt() global_clock_event->event_handler is called.

global_clock_event is first initialized to i8253_clockevent (PIT), but 
from hpet_late_init() it is reinitialized as follows (see 
hpet_legacy_clockevent_register()):

clockevents_config_and_register(&hpet_clockevent, ...);
global_clock_event = &hpet_clockevent;

It turns out that clockevents_config_and_register() lefts 
global_clock_event->event_handler unintialized (NULL).

After digging deeper into clockevent_config_and_register(), I've found 
that the event_handler should be set inside tick_check_new_device(), but 
by the time we call it, high prio apic timers have already been setup 
(see setup_APIC_timer()) so that hpet is not initialized as a oneshot 
device. The attempt to set it as a broadcast device also fails since the 
broadcast cpumask is empty (see tick_check_broadcast_device()).

Thus, for some time we have event_handler=NULL, which can lead to a NULL 
ptr deref in timer_interrupt() if a pending interrupt is handled.

>
>> Avoid this by initializing hpet's event_handler to noop in its definition.
> "Avoid" is the correct term: You're avoiding to track down the root
> cause of the problem.
>
> This is fairy tale mode. I really love fairy tales, just not in the
> context of kernel code.
>
> Please provide proper proof why this can happen instead of some
> handwavy explanations.
>
> Thanks,
>
> 	tglx

