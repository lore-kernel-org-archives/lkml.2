Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0FHDGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:06:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33185 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0FHDF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1006072153030.27878-100000@netrider.rowland.org>
References: <AANLkTikRSV5dFX10apUntFi4eJkRt645Iod91qrPk9gI@mail.gmail.com>
	<Pine.LNX.4.44L0.1006072153030.27878-100000@netrider.rowland.org>
Date: Mon, 7 Jun 2010 20:05:56 -0700
Message-ID: <AANLkTimcDzHBmgqPkCHB6pW2RZivFhmb_zk68T0I3NJY@mail.gmail.com>
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
>> > It's true that under some exceptional circumstances the system would
>> > never remove a wakeup source from the "active" list and then would
>> > never go idle.  But exactly the same problem exists with wakelocks, if
>> > the kernel activates a wakelock and there's no user process reading the
>> > corresponding event queue.
>> >
>>
>> No, you have a different problem. If you open an input device and
>> issue the ioctl to enable the suspend blocker that blocks while the
>
> Um, the suspend blocker that is active while the queue is nonempty is
> an in-kernel suspend blocker, right?  Not a userspace suspend blocker.
> Hence it doesn't have to be enabled by an ioctl.  Or is this some part
> of the whole wakelock design that hasn't yet been posted?  As far as I
> know, you intended the in-kernel suspend blocker to be enabled whenever
> the input device file is open.
>

The patch that modifies evdev (posted in this patchset) uses an ioctl
to enable the suspend blocker. Not all input devices are used for
wakeup events and those don't need to block suspend.

>> queue is not empty then don't read the event, that is a bug that is
>> easy to fix.
>
> I assume you mean "you open an input device but then fail to read from
> it".  When that happens the device's driver will activate its in-kernel
> suspend blocker, and since the input queue will never become empty, the
> suspend blocker will never be deactivated.  Yes, that's a bug.
>
>> What you have is a race condition. If you read an event
>> that occurred after you blocked the task freezing tasks will never get
>> frozen again (until more events occur).
>
> Sorry, I can't parse that sentence.  Could you rephrase it more
> grammatically?
>

If you read an event that occurred after you blocked the task
freezing, then tasks will never get frozen again (until more events
occur). I think my original description was less confusing, but it
seems you got completely distracted by my use of block and unblock
suspend when referring to the user space api.


> It seems to say: "If you read an event that occurred after [something],

Block suspend, block task freezing or whatever you want to call it.

> then tasks won't get frozen again until more events occur".  Which
> doesn't make sense, firstly because in my scheme reading events has no
> direct connection with freezing or unfreezing tasks, and secondly

It has an indirect connection. You report a wakeup event when it
occurs, but clear it when user space calls an api before reading the
event. So:
Wakeup event occurs, and the driver:
- report wakeup event type A
- queue event for delivery to user-space
User space wakes up:
- Calls api to block task freezing for event type A
Another wakeup event occurs, and the driver:
- report wakeup event type A
- queue event for delivery to user-space
User space continues:
- Read events
- Wait for more events

Result: Task are not frozen again.

> because the occurrence of events doesn't cause tasks to be frozen --
> just the opposite: occurrence of events _prevents_ tasks from being
> frozen.
>
>> We have multiple input devices and one thread reading from them. Do
>> all input devices that can generate wakeup events share a wakeup
>> source?
>
> Basically, a wakeup source is a file descriptor that in your scheme,
> some user process would read from in order to clear an in-kernel
> wakelock.  Thus, if each of your input devices activates an in-kernel
> wakelock that is cleared when a user process reads the device, then the
> file descriptors for these input devices would each be considered a
> wakeup source.
>
>> It seems you would need a way to pass the wakeup source id to use from
>> user space to the driver and for this to work
>
> No, nothing needs to be passed from userspace to the kernel.  However
> the source ID (or a set of source IDs) does need to be passed to the
> power manager process, probably when the suspend blocker is created.
>

Then the source id need to be passed from the kernel to user-space.

> [On rereading this, I realized it might not have been clear that in my
> scheme, suspend blockers have no in-kernel component.  They are
> implemented entirely by IPC between the process owning the suspend
> blocker and the power manager process.  Would it be less confusing if I
> called them something else?]

No, that is not the unclear part. What is unclear to me is where the
source IDs come from. Are they static and hardcoded in the driver and
user-space, or are they passed between the driver and user-space
client?

>
>> (ignoring the race if
>> you allow multiple alarms per file) which seems like more work than
>> using a suspend blocker.
>
> It's not very much more: just one additional argument to the routine
> that creates a suspend blocker.
>
> I get the impression that you don't fully understand how my scheme is
> meant to work.  Would some additional explanation or examples help?
>

I don't understand how you are planning to ensure that the driver and
user-space code that consumes the real event use the same source id.
The biggest problem I have with it though is that you have created a
new race condition between reporting that a wakeup event has occurred
and processing of the real event.

-- 
Arve Hjønnevåg
