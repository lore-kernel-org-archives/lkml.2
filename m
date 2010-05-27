Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0E0K4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:56:13 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59658 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0E0K4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:56:11 -0400
Date: Thu, 27 May 2010 12:56:05 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vitaly Wool <vitalywool@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       <Paul@smtp1.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527125605.2855f980@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1005261033440.1961-100000@iolanthe.rowland.org>
References: <20100526151945.1b3813ac@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1005261033440.1961-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 10:38:50 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 26 May 2010, Florian Mickler wrote:
> 
> > I don't think that the in-kernel suspend block is a bad idea. 
> > 
> > You could probably use the suspend-blockers unconditionally in the
> > suspend framework to indicate if a suspend is possible or not.
> 
> That's not how it works.  Drivers aren't supposed to abort
> unconditional suspend -- not without a really good reason (for example,
> the device received a wakeup event before it was fully suspended).  In
> short, suspends should be considered to be _always_ possible.
> 
> > Regardless of opportunistic suspend or not. This way, you don't have to
> > try-and-fail on a suspend request and thus making suspending
> > potentially more robust or allowing for a "suspend as soon as
> > possible" semantic (which is probably a good idea, if you have to grab
> > your laptop in a hurry to get away).
> 
> That's different.  Suspend blockers could block (not abort!) regular 
> suspends, just as they do opportunistic suspends.
> 
> But why should they?  I mean, if userspace wants to initiate a suspend
> that is capable of being blocked by a kernel suspend blocker, then all
> it has to do is initiate an opportunistic suspend instead of a normal
> suspend.
> 
> Alan Stern

Let me elaborate what i mean:

The assumption beeing that specifying pm constraints in the drivers is
a good thing which we will be doing anyway in the long run. 
(See Alan Cox's summary of current mainline problems[1].)

I don't wanna go into specifing any constraint API here, but it could
probably be either a blocker flag (the here presented suspend-blocker,
which Alan doesnt like?) 
or maybe a few integer-typed constraints defined by the pm-core.
(needed scheduler-latency/needed io-latency?)

As an intermediate step, it would probably be possible to
specify the "I cant be suspended" constraint (aka blocker) for all
drivers not explicitly stating anything other. 

Converting a driver to using any constraint-API would require analysing
what makes a driver refuse suspending in the old suspend handler and
then specify any "no suspend" (or whatever) constraint before those
conditions arise and clearing of the constraints when it is no longer critical.  
(Much work.)

A future switch from something like a flag (blocker) to a
full integer-typed requirement would probably be a simple search and
replace or even possible by extending the blocker-api. 

If that is done, the prototype of the driver callback

int suspend(); 

could probably be changed to 

void suspend();

and it be expected to always _successfully_ suspend.

The hard part is finding the places where special guarantees are
needed. But android did show that this is possible.

Cheers,
Flo

[1]: http://lkml.org/lkml/2010/5/26/575
