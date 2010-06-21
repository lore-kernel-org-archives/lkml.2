Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0FUUjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:39:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53232 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0FUUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:39:22 -0400
Date: Mon, 21 Jun 2010 22:38:41 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621223841.1cf1942d@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1006211111060.1687-100000@iolanthe.rowland.org>
References: <20100621073233.3f874ad0@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1006211111060.1687-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 11:23:33 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 21 Jun 2010, Florian Mickler wrote:
> 
> > On Sun, 20 Jun 2010 22:23:38 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > This is the race I was talking about:
> > > 
> > > > > What happens if an event arrives just before you read
> > > > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > > > there is a new unprocessed event until after the power manager checks
> > > > > it?
> > > 
> > > > I think this is not the kernel's problem.  In this approach the kernel makes it
> > > > possible for the user space to avoid the race.  Whether or not the user space
> > > > will use this opportunity is a different matter.
> > > 
> > > It is _not_ possible for userspace to avoid this race.  Help from the 
> > > kernel is needed.
> > 
> > It is possible if every (relevant) userspace program implements a
> > callback for the powermanager to check if one of it's wakeup-sources
> > got activated.
> > 
> > That way the powermanager would read /sys/power/wakeup_count, then do
> > the roundtrip to all it's registered users and only then suspend. 
> > 
> > This turns the suspend_blockers concept around. Instead of actively
> > signaling the suspend_blockers, the userspace programs only answer
> > "yes/no" when asked.  (i.e. polling?) 
> 
> In the end you would want to have communication in both directions:  
> suspend blockers _and_ callbacks.  Polling is bad if done too often.  
> But I think the idea is a good one.

Actually, I'm not so shure. 

1. you have to roundtrip whereas in the suspend_blocker scheme you have
active annotations (i.e. no further action needed) 

2. it may not be possible for a user to determine if a wake-event is
in-flight. you would have to somehow pass the wake-event-number with
it, so that the userspace process could ack it properly without
confusion. Or... I don't know of anything else... 

	1. userspace-manager (UM) reads a number (42). 

	2. it questions userspace program X: is it ok to suspend?

	[please fill in how userspace program X determines to block
	suspend]

	3a. UM's roundtrip ends and it proceeds to write "42" to the
	kernel [suspending]
	3b. UM's roundtrip ends and it aborts suspend, because a
	(userspace-)suspend-blocker got activated

I'm not shure how the userspace program could determine that there is a
wake-event in flight. Perhaps by storing the number of last wake-event.
But then you need per-wake-event-counters... :|


> In fact, you don't need a "yes/no" response.  Programs merely need a
> chance to activate a new suspend blocker if a wakeup source was
> recently activated before they acknowledge the poll.

true. (incorporated alreeady above)

> 
> > You _can not_ implement userspace suspend blockers with this approach,
> > as it is vital for every userspace program to get scheduled and check
> > it's wakeup-source (if even possible) before you know that the right
> > parties have won the race.
> 
> I'm not sure what you mean.  

Sorry, that was not understandable. What I meant was that you "_can
not_" implement the suspend-blockers scheme, where you don't need to
roundtrip through all userspace (with all it's glory).
( => you need the roundtrip here)

> 
> There is still at least one loophole to be closed: Android's
> timer-based wakelocks.  These include cases where the Android
> developers didn't add enough wakelocks to cover the entire path from
> kernel-event to userspace-handler, so they punted and relied on a timer
> to decide when the wakelock should be deactivated.  (There may be other
> cases too; I didn't follow the original discussion very closely.)  
> It's not clear whether these things can be handled already in Rafael's
> scheme with your addition, or whether something new is needed.
> 
> Alan Stern

Do you have some thoughts about the wake-event-in-flight detection?

Cheers,
Flo
