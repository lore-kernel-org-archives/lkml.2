Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab0FKW0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:26:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59639 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab0FKW0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1006111018190.12006-100000@netrider.rowland.org>
References: <AANLkTik9xMxx8IdYkUhd-oa_ik_MjGFOff_siUztls-9@mail.gmail.com>
	<Pine.LNX.4.44L0.1006111018190.12006-100000@netrider.rowland.org>
Date: Fri, 11 Jun 2010 15:18:44 -0700
Message-ID: <AANLkTikEJ5pWNNg6fVNHEJqN_DA3iXWfUfKQaQyQv0mL@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: tytso@mit.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Felipe Balbi <felipe.balbi@nokia.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/11 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 10 Jun 2010, Arve Hjønnevåg wrote:
>
>> > You've lost me.  If the power manager is sitting inside a select/poll,
>> > how can it miss the event (given that the event will make data
>> > available to be read on one of the descriptors being polled)?
>> >
>>
>> It cannot sit inside of select/poll all the time.
>>
>> > Or put it another way: With wakelocks, if the app doesn't use a suspend
>> > blocker then once it reads the event data and the timed wakelock is
>> > deactivated, there is nothing to prevent the system from immediately
>> > going into opportunistic suspend.  My scheme can fail in the same way.
>> > Is that what you meant?
>> >
>>
>> No, if an app reads from a file descriptor and block suspend when the
>> read call returns, then suspend is blocked while processing the data.
>> If the driver uses a wakelock with a timeout this will fail if the
>> thread does not get to the suspend block call before the timeout
>> expires, but unrelated events that don't prevent the app from running
>> will not cause any problems.
>
> Wait a second.  Maybe I have misunderstood how timeouts are supposed to
> work with wakelocks.  I thought the idea was that the wakelock would be
> released when the timeout expires or the event queue is emptied,

That is one way to use it, and I did this so code that opened an input
device without reading from it would not prevent suspend forever. In
the last patchset I posted, I instead used an ioctl to enable the
suspend blocker.

> whichever comes first.  Now it sounds like you're saying that the
> wakelock doesn't get released until the timeout expires, even if
> userspace finishes processing all pending events before then.
>

For incoming network traffic we use a wakelock with a timeout to
prevent suspend long enough for the data to make it to user-space
since we have not added wakelocks to the network stack.

>> In your scheme the user-space power
>> manager may miss events on this file descriptor since select/poll will
>> not see an event if the app read that event right before the power
>> manager called select/poll.
>
> If the wakelock is supposed to remain active until the timeout expires
> then you are right.  On the other hand, this seems like a rather
> strange and suspicious way of handling wakelocks.  Why would you want
> to do it that way?
>

We did this to avoid changing to the network stack, tty layer, etc.

>> > There's one question that I don't remember ever seeing answered.  To
>> > which kernel drivers do you intend to add suspend blockers?
>> >
>>
>> All drivers that generate wakeup events need to either use suspend
>> blockers directly or call into something else that does. For instance,
>> with the patch to block suspend while input events are queued to
>> user-space, an input driver that fully handles its events in its
>> interrupt handler does not need any additional suspend blockers, but
>> if the driver needs a work function or a timer to run before it
>> reports the event it needs to block suspend until it has reported the
>> event.
>
> Sure.  But specifically, which drivers on Android generate wakeup
> events?  And which of them don't fully handle their events in their
> interrupt handlers?
>

Keypad, network, charger, rtc, but I'm sure I forgot some.

> Maybe another way to put this is: Where in the kernel do you intend to
> add suspend blockers?
>

In addition to the drivers that enable the wakeup events, we have
added suspend blockers to the input event code and power supply
framework. The tty layer and network stack would also need suspend
blockers to avoid using timeouts.

-- 
Arve Hjønnevåg
