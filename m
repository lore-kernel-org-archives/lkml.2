Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab0E1R1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:27:17 -0400
Received: from ip-70-38-54-39.static.privatedns.com ([70.38.54.39]:43818 "EHLO
	ginevra.hungrycats.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753485Ab0E1R1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:27:15 -0400
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
X-Envelope-Mail-From: vger-linux-omap-esightcorp@mailtoo.hungrycats.org
Date: Fri, 28 May 2010 13:27:13 -0400
From: Zygo Blaxell <vger-linux-omap-esightcorp@mailtoo.hungrycats.org>
To: Brian Swetland <swetland@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Igor Stoppa <igor.stoppa@nokia.com>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528172713.GA7444@gibbs.hungrycats.org>
References: <20100528114123.GA22947@srcf.ucam.org>
 <4BFFB681.1000105@nokia.com>
 <AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
 <4BFFC5DF.5030504@nokia.com>
 <20100528133900.GG26177@thunk.org>
 <4BFFCFC7.7070302@nokia.com>
 <20100528142124.GA26733@srcf.ucam.org>
 <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
 <20100528160628.7c121dab@lxorguk.ukuu.org.uk>
 <AANLkTin3suKfGBSfiDj0n8ztY8UiHzr4af_Cr0SPOevY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin3suKfGBSfiDj0n8ztY8UiHzr4af_Cr0SPOevY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 08:13:08AM -0700, Brian Swetland wrote:
> On Fri, May 28, 2010 at 8:06 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > They fix a general problem in terms of a driver specific item. We end up
> > making changes around the tree but we make everyone happy not just
> > Android. Also we are isolating policy properly. The apps and drivers say
> > "I have these needs", the power manager figures out how to meet them.
> 
> That makes sense -- and as I've mentioned elsewhere, we're really not
> super picky about naming -- if it turns out that
> wakelocks/suspendblockers were shorthand for "request a qos constraint
> that ensures that threads are running", we'll be able to get things
> done just as well as we do now.

>From my reading of this thread, there's a lot of overlap between
suspendblockers and constraints.  Many use cases are served equally
well with one or the other, except for one:  a case where an event that
should ultimately wake the system triggers a code execution path (or data
flow path) that wanders through a user-space full of complex interacting
processes where the kernel (and maybe even the processes) can't see it.

Suspend-blockers in user-space handle this by making such code/data paths
visible to the kernel.  An all-kernel constraint-based approach has no
way to see the user-space paths, so the system will end up trying to
sleep when it should be waking up.

Wait, what?  Surely all the user-space code handling such events is
running under a PM-QoS constraint that says "don't sleep if this process
is runnable," so the system won't go to sleep.  Presumably all other
processes which don't handle wakeup events will be running under a
PM-QoS constraint that says "do sleep even if this process is runnable."

That's true, except for one common case:  a process is drawing things on
the display on behalf of other processes, and that drawing process can't
have the "don't sleep" constraint because if it did the system would
seem to be continuously busy and never go to sleep.  Any process that is
handling a critical event but also needs to talk to the display process
will end up being not-runnable, and the system may go to sleep before the
display process wakes up.  So we need another PM-QoS constraint that says
"don't sleep even if this process isn't runnable, because some *other*
runnable process might do something that makes our critical process
runnable again."  The critical event handling app would switch to this
PM-QoS constraint until it had received an ack from whatever it talked
to in user-space, then switch back to the "don't sleep if this process
is runnable" state until a new event comes in.

So, three constraint policies should do it (*):

	1.  Do sleep even if this process is runnable,

	2.  Don't sleep if this process is runnable, and

	3.  Don't sleep even if this process isn't runnable, as long as
	at least one other runnable process exists somewhere on the
	system.

"Runnable" would include tasks that are literally runnable as well as
tasks that aren't runnable but are presumed to be imminently runnable
(e.g. blocked on timers that are going to expire before the wakeup
latency).

"Sleep" means going into any state where the scheduler doesn't run
any tasks.  That covers most CPU idle modes, deep power saving states,
ACPI suspend, or whatever.

(*) or you could define a "please stop wasting CPU" message in user-space,
and send that message to anything in user-space which has a PM-QoS
constraint better than "none" whenever something in user-space thinks
the user has gone away.  Then the display process can have constraint #2,
and we don't need #3.

