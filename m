Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0FUFdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:33:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53205 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0FUFdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:33:13 -0400
Date: Mon, 21 Jun 2010 07:32:33 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Stern <stern@rowland.harvard.edu>
Newsgroups: gmane.linux.kernel
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621073233.3f874ad0@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
References: <201006202350.27143.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 22:23:38 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sun, 20 Jun 2010, Rafael J. Wysocki wrote:

> > > In what way is this better than suspend blockers?
> > 
> > It doesn't add any new framework and it doesn't require the users of
> > pm_wakeup_event() to "unblock" suspend, so it is simpler.  It also doesn't add
> > the user space interface that caused so much opposition to appear.
> 
> Okay.  A quick comparison shows that in your proposal:
> 
> 	There's no need to register and unregister suspend blockers.
> 	But instead you create the equivalent of a suspend blocker
> 	inside every struct device.
> 
> 	Drivers (or subsystems) don't have to activate suspend 
> 	blockers.  But instead they have to call pm_wakeup_event().
> 
> 	Drivers don't have to deactivate suspend blockers.  You don't
> 	have anything equivalent, and as a result your scheme is 
> 	subject to the race described below.
> 
> 	There are no userspace suspend blockers and no opportunistic
> 	suspend.  Instead a power-manager process takes care of 
> 	initiating or preventing suspends as needed.
> 
> In short, you have eliminated the userspace part of the suspend blocker 
> approach just as in some of the proposals posted earlier, and you have 
> replaced the in-kernel suspend blockers with new data in struct device 
> and a new PM API.  On the whole, it doesn't seem very different from 
> the in-kernel part of suspend blockers.  The most notable difference is 
> the name: pm_wake_event() vs. suspend_blocker_activate(), or whatever 
> it ended up being called.
> 
> This is the race I was talking about:
> 
> > > What happens if an event arrives just before you read
> > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > there is a new unprocessed event until after the power manager checks
> > > it?
> 
> > I think this is not the kernel's problem.  In this approach the kernel makes it
> > possible for the user space to avoid the race.  Whether or not the user space
> > will use this opportunity is a different matter.
> 
> It is _not_ possible for userspace to avoid this race.  Help from the 
> kernel is needed.

It is possible if every (relevant) userspace program implements a
callback for the powermanager to check if one of it's wakeup-sources
got activated.

That way the powermanager would read /sys/power/wakeup_count, then do
the roundtrip to all it's registered users and only then suspend. 

This turns the suspend_blockers concept around. Instead of actively
signaling the suspend_blockers, the userspace programs only answer
"yes/no" when asked.  (i.e. polling?) 

You _can not_ implement userspace suspend blockers with this approach,
as it is vital for every userspace program to get scheduled and check
it's wakeup-source (if even possible) before you know that the right
parties have won the race.


Cheers,
Flo
