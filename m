Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2DQIOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:14:47 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:48261 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340Ab2DQIOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:14:43 -0400
Message-ID: <4F8D266D.4030207@ti.com>
Date: Tue, 17 Apr 2012 13:44:37 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>  <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>  <4F8AC59D.6070909@ti.com> <1334613816.28674.108.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1334613816.28674.108.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012 03:33 AM, Suresh Siddha wrote:
> On Sun, 2012-04-15 at 18:27 +0530, Santosh Shilimkar wrote:
>> On Tuesday 10 April 2012 04:11 AM, Suresh Siddha wrote:
>>> @@ -575,10 +575,12 @@ void tick_broadcast_switch_to_oneshot(void)
>>>  	unsigned long flags;
>>>  
>>>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>>> +
>>> +	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
>>> +
>>>  	if (cpumask_empty(tick_get_broadcast_mask()))
>>>  		goto end;
>>>  
>>> -	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
>>>  	bc = tick_broadcast_device.evtdev;
>>>  	if (bc)
>>>  		tick_broadcast_setup_oneshot(bc);
>>>
>>>
>> Last time when I tried your patch, some how he ethernet IRQ masked
>> the issue.
>>
>> The problem is still as before. If you make a minimal kernel
>> configuration and possibly have only local timer, broadcast timer
>> and say console device as CPU wakeup sources, you should hang in
>> the boot process itself(Assuming CPUIDLE driver is built-in)
>>
>> The main issue is, you are not letting the one time setup
>> needed for the broadcast device. Even with above change,
>> the 'tick_broadcast_device.evtdev' is still in SHUTDOWN
>> mode and the event handler is pointing to clockevents_handle_noop()
> 
> On x86, idle driver (like drivers/idle/intel_idle.c:
> __setup_broadcast_timer()) calls clockevents_notify() with
> CLOCK_EVT_NOTIFY_BROADCAST_ON, during which we do
> tick_broadcast_setup_oneshot(). See tick_do_broadcast_on_off() which
> does this. That should setup the evtdev handler, mode etc.
> 
> And during the next CLOCK_EVT_NOTIFY_BROADCAST_ENTER we program the next
> broadcast event.
>
I see.

>> So the very first 'CLOCK_EVT_NOTIFY_BROADCAST_ENTER' call won't
>> program the broadcast device with next event and CPU won't wakeup
>> from low power. if you are lucky and have some other wakeup source,
>> system will move further and eventually the handler and
>> mode of the broad-cast device get set correctly.
> 
> I am confused. Can you elaborate on how on the next spurious wakeup
> event, broad-cast device handler, mode is set?
> 
No it doesn't set it. I was wrong in quoting that. The system was
working because of other wakeup sources. I checked the broadcast
events and they were not happening.

> 
> Anyways, can you add CLOCK_EVT_NOTIFY_BROADCAST_ON/OFF notifications in
> your idle driver to see if it addresses the problem. That is the correct
> thing to do here.
> 
Before your commit 77b0d60c{clockevents: Leave the broadcast device..},
my idle driver was working without CLOCK_EVT_NOTIFY_BROADCAST_ON
notifier. Now it's clear that it was relying on the default
'tick_broadcast_setup_oneshot()' which was happening during boot.

And ofcource notifying explicitly with BROADCAST_ON does the
tick setup. Will update my idle driver accordingly but can
you please explain me why the proposed patch [1] is not correct
approach ? It should be also do what you intended to do
with minimal change, right ?

Regards
Santosh
[1] https://lkml.org/lkml/2012/4/9/13

