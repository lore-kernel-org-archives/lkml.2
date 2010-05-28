Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0E1JTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:19:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55119 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0E1JTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100528104415.1403541a@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
	<20100527173118.GE2468@srcf.ucam.org>
	<alpine.LFD.2.00.1005271959450.3032@localhost.localdomain>
	<20100528104415.1403541a@schatten.dmk.lab>
Date: Fri, 28 May 2010 02:18:06 -0700
Message-ID: <AANLkTikXtk-f41-z8gXfXLNLqgGVa0z4d-qgIvwljbR-@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Florian Mickler <florian@mickler.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 1:44 AM, Florian Mickler <florian@mickler.org> wrote:
> On Thu, 27 May 2010 20:05:39 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> On Thu, 27 May 2010, Matthew Garrett wrote:
>>
>> > On Thu, May 27, 2010 at 07:24:02PM +0200, Thomas Gleixner wrote:
>> >
>> > > Oh no. They paper over a short coming. If there is a pending event,
>> > > the kernel knows that. It just does not make use of this
>> > > information. Blockers just paper over this by sprinkling
>> > > do_not_suspend() calls all over the place. What a sensible solution.
>> >
>> > Even if we could use suspend-via-deep-idle-state on PCs, we still need
>> > to be able to enter suspend while the system isn't idle. There's two
>> > ways to do that:
>> >
>> > 1) Force the system to be idle. Doing this race-free is difficult.
>> >
>> > 2) Enter suspend even though the system isn't idle. Since we can't rely
>> > on the scheduler, we need drivers to know whether userspace has consumed
>> > all wakeup events before allowing the transition to occur. Doing so
>> > requires either in-kernel suspend blockers or something that's almost
>> > identical.
>>
>> You're just not getting it. If user space has consumed the event is
>> not relevant at all.
>>
>> What's relevant is whether the app has processed the event and reacted
>> accordingly. That's all that matters.
>>
>> Emptying your input queue is just the wrong indicator.
>>
>> And as I explained several times now: It does _NOT_ matter when the
>> app goes back in to blocked/idle state. You have to spend the CPU
>> cycles and power for that anyway.
>>
>> And for the apps which do not use the user space blockers the queue
>> empty indicator is just bullshit, because after emptying the queue the
>> kernel can go into suspend w/o any guarantee that the event has been
>> processed.
>>
>> The whole concept sucks, as it does not solve anything. Burning power
>> now or in 100ms is the same thing power consumption wise.
>>
>> Thanks,
>>
>>       tglx
>
> Thomas,
> do you really have a problem with the actual concept? Or do you just
> don't like the way it is done?
>
> IMO, the whole concept is defining 2 modes of operation:
>
> 1. user interacts with the device (at least one suspend block active)
> 2. user doesn't interact with the device (zero suspend block active)

That is a somewhat odd way of looking at it. Yes we have two modes of
operation, but an active suspend blocker does not mean that the user
is interacting with the device. The way we use it, the "main" suspend
blocker is active when the user interacts with the device (controlled
by writing to /sys/power/state). All other suspend blockers are used
to prevent suspend when user space has decided that the user is not
interacting with the device. This includes blocking suspend in the
kernel on key events which means the user actually is interacting with
the device, even if user-space has not realized it yet. For other
events, like an incoming phone call, we block suspend and make some
noise with the hope that the user will start interacting with the
device.

>
> In case 1. the device wants _everything_ sheduled as normal (and save
> maximum possible power, i.e. runtime pm with every technology available
> now).
>
> In case 2. we want nothing sheduled (and save maximum possible power,
> i.e. suspend)
>
OK.

> And now, every application and every kernel driver annotates (on behalve
> of the user) if it (possibly) interacts with the user.
>

Applications that interact with the user do not normally need to block
suspend. The user interacting with the device blocks suspend (just
like with your desktop screen saver). Not every kernel driver needs to
be annotated either, only potential wakeup events need to be
annotated.

> (Is this really the problematic bit, that userspace is giving
> the kernel hints? Or is it that the hints are called "blocker"?)
>
> We can only enter mode 2, if _nothing_ (claims) to interact with the
> user.
>

If nothing blocks suspend. The reason to block suspend does not have
to be direct user interaction.

> To integrate this with the current way of doing things, i gathered it
> needs to be implemented as an idle-state that does the suspend()-call?
>

I think it is better no not confuse this with idle. Since initiating
suspend will cause the system to become not-idle, I don't think is is
beneficial to initiate suspend from idle.

> Attributes of the idle states could be smth like this:
>
> c3
>        cost-to-transition-to-this-state: X
>        powersavings-per-time: Y
>        expected time we stay in this state: relative short, there is a
>                timer sheduled
>        suspend-blockers: ignored
>
> suspend
>        cost-to-transition-to-this-state: depends, how much drivers to
>        suspend, how much processes to freeze, how much state to save
>        powersavings-per-time: Y
>        expected time we stay in this state: long, independent of
>                sheduled timers
>        suspend-blockers: must not be activated
>
>
> Now all transitions and opportunistic suspend could be handled by the
> same algorithms.
>
> Would this work?
>

I'm not sure what you mean.


-- 
Arve Hjønnevåg
