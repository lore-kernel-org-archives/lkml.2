Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0EaQd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:33:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:53743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0EaQd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:33:58 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275149418.4503.128.camel@mulgrave.site>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	 <20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	 <20100527220949.GB10602@srcf.ucam.org>
	 <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100527223605.GB11364@srcf.ucam.org>
	 <20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	 <20100528043114.GC26177@thunk.org> <1275030704.32462.11.camel@laptop>
	 <AANLkTikEtlbkT4Ws3H2YGt_9QC46B5dr-b1oxJOcG4GN@mail.gmail.com>
	 <1275120618.27810.12699.camel@twins>
	 <1275149418.4503.128.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 20:12:14 +0200
Message-ID: <1275156734.1645.496.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 11:10 -0500, James Bottomley wrote:
> > Correct, I strongly oppose using suspend. Not running runnable tasks is
> > not a sane solution.
> 
> Look, this is getting into the realms of a pointless semantic quibble.
> The problem is that untrusted tasks need to be forcibly suspended when
> they have no legitimate work to do and the user hasn't authorised them
> to continue even if the scheduler sees them as runnable.  Whether that's
> achieved by suspending the entire system or forcibly idling the tasks
> (using blocking states or freezers or something) so the scheduler can
> suspend from idle is something to be discussed,

So what happens if you task is CPU bound and gets suspended and is
holding a resource (lock, whatever) that is required by someone else
that didn't get suspended?

That's the classic inversion problem, and is caused by not running
runnable tasks.

>  but the net result is
> that we have to stop a certain set of tasks in such a way that they can
> still receive certain external events ... semantically, this is
> equivalent to not running runnable tasks in my book.

Why would be care about external events? Clearly these apps are ill
behaved, otherwise they would have listened to the environment telling
them to idle.

Why would you try to let buggy apps work as intended instead of break
them as hard as possible? Such policy promotes crappy code since people
get away with it.

>  (Perhaps this whole
> thing is because the word runnable means different things ... I'm
> thinking a task that would consume power ... are you thinking in the
> scheduler R state?)

Clearly I mean TASK_RUNNABLE, if not that the scheduler doesn't care.

> Realistically, the main thing we need to do is stop timers posted
> against the task (which is likely polling in a main loop, that being the
> usual form of easy to write but power crazy app behaviour) from waking
> the task and bringing the system out of suspend (whether from idle or
> forced).

Sure, that same main loop will probably receive a message along the
lines of, 'hey, screen is off, we ought to go sleep'. If after that it
doesn't listen, and more serious messages don't get responded to, simply
kill the thing.

Again, there is no reason what so ever to tolerate broken apps, it only
promotes crappy apps.



