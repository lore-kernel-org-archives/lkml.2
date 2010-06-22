Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0FVAuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:50:23 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:56417 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0FVAuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <201006220040.41524.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1006211814370.1687-100000@iolanthe.rowland.org>
	<201006220040.41524.rjw@sisk.pl>
Date: Mon, 21 Jun 2010 17:50:18 -0700
Message-ID: <AANLkTimIq0y9ZtXNJ79qCTg8DKHxDUJAz4VE6pxet21B@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Neil Brown <neilb@suse.de>,
       mark gross <640e9920@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 3:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, June 22, 2010, Alan Stern wrote:
>> On Mon, 21 Jun 2010, Florian Mickler wrote:
>>
>> > > In the end you would want to have communication in both directions:
>> > > suspend blockers _and_ callbacks.  Polling is bad if done too often.
>> > > But I think the idea is a good one.
>> >
>> > Actually, I'm not so shure.
>> >
>> > 1. you have to roundtrip whereas in the suspend_blocker scheme you have
>> > active annotations (i.e. no further action needed)
>>
>> That's why it's best to use both.  The normal case is that programs
>> activate and deactivate blockers by sending one-way messages to the PM
>> process.  The exceptional case is when the PM process is about to
>> initiate a suspend; that's when it does the round-trip polling.  Since
>> the only purpose of the polling is to avoid a race, 90% of the time it
>> will succeed.
>>
>> > 2. it may not be possible for a user to determine if a wake-event is
>> > in-flight. you would have to somehow pass the wake-event-number with
>> > it, so that the userspace process could ack it properly without
>> > confusion. Or... I don't know of anything else...
>> >
>> >     1. userspace-manager (UM) reads a number (42).
>> >
>> >     2. it questions userspace program X: is it ok to suspend?
>> >
>> >     [please fill in how userspace program X determines to block
>> >     suspend]
>> >
>> >     3a. UM's roundtrip ends and it proceeds to write "42" to the
>> >     kernel [suspending]
>> >     3b. UM's roundtrip ends and it aborts suspend, because a
>> >     (userspace-)suspend-blocker got activated
>> >
>> > I'm not shure how the userspace program could determine that there is a
>> > wake-event in flight. Perhaps by storing the number of last wake-event.
>> > But then you need per-wake-event-counters... :|
>>
>> Rafael seems to think timeouts will fix this.  I'm not so sure.
>>
>> > Do you have some thoughts about the wake-event-in-flight detection?
>>
>> Not really, except for something like the original wakelock scheme in
>> which the kernel tells the PM core when an event is over.
>
> But the kernel doesn't really know that, so it really can't tell the PM core
> anything useful.  What happens with suspend blockers is that a kernel suspend
> cooperates with a user space consumer of the event to get the story straight.
>
> However, that will only work if the user space is not buggy and doesn't crash,
> for example, before releasing the suspend blocker it's holding.
>
> Apart from this, there are those events withoug user space "handoff" that
> use timeouts.
>
> Also there are events like wake-on-LAN that can be regarded as instantaneous
> from the power manager's point of view, so they don't really need all of the
> "suspend blockers" machinery and for them we will need to use a cooldown
> timeout anyway.
>
> And if we need to use that cooldown timeout, I don't see why not to use
> timeouts for avoiding the race you're worrying about.
>

Just because some events need to use timeouts, does not mean that all
events should use timeouts. You may even want different timeout for
different events. If I want a 5 minute timeout after a wake-on-lan
packet, I don't want the same timeout after every battery check alarm
(every 10 minutes on the Nexus One).

Also, I don't see how this patch helps with events that never make
reach user-space. Unless each driver blocks suspend by returning and
error from its suspend hook, the driver then becomes dependent on the
user-space power manager to choose a sufficiently long timeout. For
some drivers, like the gpio keypad matrix driver there, is no safe
value for the timeout. The keypad driver has to block suspend if any
keys are held down.

I won't have time to actively follow this discussion, but I don't
think this patch is a good solution.

-- 
Arve Hjønnevåg
