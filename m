Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab0FUPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:23:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34932 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932811Ab0FUPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:23:35 -0400
Date: Mon, 21 Jun 2010 11:23:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Mickler <florian@mickler.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100621073233.3f874ad0@schatten.dmk.lab>
Message-ID: <Pine.LNX.4.44L0.1006211111060.1687-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Florian Mickler wrote:

> On Sun, 20 Jun 2010 22:23:38 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:

> > This is the race I was talking about:
> > 
> > > > What happens if an event arrives just before you read
> > > > /sys/power/wakeup_count, but the userspace consumer doesn't realize
> > > > there is a new unprocessed event until after the power manager checks
> > > > it?
> > 
> > > I think this is not the kernel's problem.  In this approach the kernel makes it
> > > possible for the user space to avoid the race.  Whether or not the user space
> > > will use this opportunity is a different matter.
> > 
> > It is _not_ possible for userspace to avoid this race.  Help from the 
> > kernel is needed.
> 
> It is possible if every (relevant) userspace program implements a
> callback for the powermanager to check if one of it's wakeup-sources
> got activated.
> 
> That way the powermanager would read /sys/power/wakeup_count, then do
> the roundtrip to all it's registered users and only then suspend. 
> 
> This turns the suspend_blockers concept around. Instead of actively
> signaling the suspend_blockers, the userspace programs only answer
> "yes/no" when asked.  (i.e. polling?) 

In the end you would want to have communication in both directions:  
suspend blockers _and_ callbacks.  Polling is bad if done too often.  
But I think the idea is a good one.

In fact, you don't need a "yes/no" response.  Programs merely need a
chance to activate a new suspend blocker if a wakeup source was
recently activated before they acknowledge the poll.

> You _can not_ implement userspace suspend blockers with this approach,
> as it is vital for every userspace program to get scheduled and check
> it's wakeup-source (if even possible) before you know that the right
> parties have won the race.

I'm not sure what you mean.  Certainly you can take a userspace 
suspend-blocker implementation of the sort discussed before (where 
programs communicate their needs to a central power-manager process) 
and add this callback mechanism on top.

There is still at least one loophole to be closed: Android's
timer-based wakelocks.  These include cases where the Android
developers didn't add enough wakelocks to cover the entire path from
kernel-event to userspace-handler, so they punted and relied on a timer
to decide when the wakelock should be deactivated.  (There may be other
cases too; I didn't follow the original discussion very closely.)  
It's not clear whether these things can be handled already in Rafael's
scheme with your addition, or whether something new is needed.

Alan Stern

