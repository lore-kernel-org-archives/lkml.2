Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0FXOQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:16:48 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:52250
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0FXOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:16:46 -0400
Message-ID: <4C2368C8.7020708@mit.edu>
Date: Thu, 24 Jun 2010 10:16:40 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, mark gross <640e9920@gmail.com>,
       Neil Brown <neilb@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arve@smtp1.linux-foundation.org, Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during
 suspend
References: <Pine.LNX.4.44L0.1006220952290.1631-100000@iolanthe.rowland.org>	<201006221735.10467.rjw@sisk.pl> <201006222159.28081.rjw__37084.1419128284$1277237903$gmane$org@sisk.pl>
In-Reply-To: <201006222159.28081.rjw__37084.1419128284$1277237903$gmane$org@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, June 22, 2010, Rafael J. Wysocki wrote:
>> On Tuesday, June 22, 2010, Alan Stern wrote:
>>> On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> ... 
>>>> So, even if we can say when the kernel has finished processing the event
>>>> (although that would be complicated in the PCIe case above), I don't think
>>>> it's generally possible to ensure that the entire processing of a wakeup event
>>>> has been completed.  This leads to the question whether or not it is worth
>>>> trying to detect the ending of the processing of a wakeup event.
>>> As Arve pointed out, in some cases it definitely is worthwhile (the
>>> gpio keypad matrix example).  In other cases there may be no reasonable
>>> way to tell.  That doesn't mean we have to give up entirely.
>> Well, I'm not sure, because that really depends on the hardware and bus in
>> question.  The necessary condition seems to be that the event be detected
>> and handled entirely by the same functional unit (eg. a device driver) within
>> the kernel and such that it is able to detect whether or not user space has
>> acquired the event information.  That doesn't seem to be a common case to me.
> 
> Anyway, below's an update that addresses this particular case.
> 
> It adds two more functions, pm_wakeup_begin() and pm_wakeup_end()
> that play similar roles to suspend_block() and suspend_unblock(), but they
> don't operate on suspend blocker objects.  Instead, the first of them increases
> a counter of events in progress and the other one decreases this counter.
> Together they have the same effect as pm_wakeup_event(), but the counter
> of wakeup events in progress they operate on is also checked by
> pm_check_wakeup_events().
> 
> Thus there are two ways kernel subsystems can signal wakeup events.  First,
> if the event is not explicitly handed over to user space and "instantaneous",
> they can simply call pm_wakeup_event() and be done with it.  Second, if the
> event is going to be delivered to user space, the subsystem that processes
> the event can call pm_wakeup_begin() right when the event is detected and
> pm_wakeup_end() when it's been handed over to user space.

How does userspace handle this without races?  (I don't see an example 
in a driver that talks to userspace in your code...)

For example, if I push a button on my keyboard, the driver calls 
pm_wakeup_begin().  Then userspace reads the key from the evdev device 
and tells the userspace suspend manager not to go to sleep.

But there's a race: the keyboard driver (or input subsystem) could call 
pm_wakeup_end() before the userspace program has a chance to tell the 
suspend manager not to sleep.

One possibility would be for poll to report that events are pending 
without calling pm_wakeup_end(), giving userspace a chance to prevent 
itself from suspending before actually reading the event.


(Also, should "echo mem >/sys/power/state" be different from "echo 
mem_respect_suspend_blockers >/sys/power/state?"  If I physically press 
the suspend key on my laptop, I want it to go to sleep even though I'm 
still holding the Fn key that was part of the suspend hotkey.)

--Andy
