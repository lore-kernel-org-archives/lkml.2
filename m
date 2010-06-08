Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0FHBbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 21:31:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53160 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0FHBbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 21:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1006072030420.26784-100000@netrider.rowland.org>
References: <AANLkTiny-hiPoKKKolNAhpvFUS-GaArBO8bwYBUg5glx@mail.gmail.com>
	<Pine.LNX.4.44L0.1006072030420.26784-100000@netrider.rowland.org>
Date: Mon, 7 Jun 2010 18:31:31 -0700
Message-ID: <AANLkTikRSV5dFX10apUntFi4eJkRt645Iod91qrPk9gI@mail.gmail.com>
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

2010/6/7 Alan Stern <stern@rowland.harvard.edu>:
> On Mon, 7 Jun 2010, Arve Hjønnevåg wrote:
>
>> > In fact it's possible to do this with only minimal changes to the
>> > userspace, providing you can specify all your possible hardware wakeup
>> > sources.  (On the Android this list probably isn't very large -- I
>> > imagine it includes the keypad, the radio link(s), the RTC, and maybe
>> > a few switches, buttons, or other things.)
>> >
>> > Here's how you can do it.  Extend the userspace suspend-blocker API, so
>> > that each suspend blocker can optionally have an associated wakeup
>> > source.
>> >
>> > The power-manager process should keep a list of "active" wakeup
>> > sources.  A source gets removed from the list when an associated
>> > suspend blocker is activated.
>> >
>>
>> How do you do this safely? If you remove the active wakeup only when
>
> "remove the active wakeup" isn't a good way of expressing this.  You
> remove the wakeup source from the power manager's list of active
> sources.  This is just manipulation of a data structure internal to the
> power manager; it doesn't affect the actual source.
>
>> activating the suspend blocker, you will never unblock suspend if
>> another wakeup event happens after user-space blocked suspend but
>> before user-space read the events.
>
> I'm not sure what you mean.  In this scheme userspace doesn't ever
> block suspends.  Instead the power manager freezes and unfreezes all
> the other processes.  And the system never suspends, it simply goes
> idle for prolonged periods of time... with all processes frozen except
> the power manager, and it sitting inside a poll() system call.
>
> It's true that under some exceptional circumstances the system would
> never remove a wakeup source from the "active" list and then would
> never go idle.  But exactly the same problem exists with wakelocks, if
> the kernel activates a wakelock and there's no user process reading the
> corresponding event queue.
>

No, you have a different problem. If you open an input device and
issue the ioctl to enable the suspend blocker that blocks while the
queue is not empty then don't read the event, that is a bug that is
easy to fix. What you have is a race condition. If you read an event
that occurred after you blocked the task freezing tasks will never get
frozen again (until more events occur).

>> Also, I'm not sure we can easily associate a wakeup event with a user
>> space suspend blocker. For instance when an alarm triggers it is
>> sometimes because of a user-space alarm and sometimes because an
>> in-kernel alarm.
>
> That's okay.  The association is optional, and not all suspend blockers
> will have an associated wakeup source.  (However, each wakeup source
> that needs to percolate up into userspace -- i.e., that isn't handled
> internally by the kernel -- should have at least one associated suspend
> blocker.)  The purpose of these associations is to make explicit the
> "handoff" in your original scheme, whereby a source would cause the
> kernel to activate a wakelock until some user process activated its own
> and then cleared the kernel's wakelock.  In your scheme, the connection
> between the userspace wakelock and the wakeup source is implicit; in
> my scheme it is explicit.
>
> For example, a process that uses a suspend blocker in order to read
> keystrokes would obviously associate its suspend blocker with the
> keypad-matrix wakeup source.
>

We have multiple input devices and one thread reading from them. Do
all input devices that can generate wakeup events share a wakeup
source?

> Or take your example of an alarm.  To make it work in my scheme, each
> user alarm would have to be implemented as a poll-able file descriptor.
> Processes reading the descriptor would block until the alarm expires.
> (I don't know of any driver that provides this sort of timer interface,
> but it would be easy to write one.  You could think of it as applying
> Unix's "Everything is a file" philosophy to alarms.)  Each of these
> descriptors would then be a wakeup source, included among the sources
> that the power manager polls for, and a suspend blocker could be
> associated with it.
>

It seems you would need a way to pass the wakeup source id to use from
user space to the driver and for this to work (ignoring the race if
you allow multiple alarms per file) which seems like more work than
using a suspend blocker.

-- 
Arve Hjønnevåg
