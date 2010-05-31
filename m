Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0EaVNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:13:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35572 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab0EaVNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:13:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Mon, 31 May 2010 23:14:12 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: James Bottomley <James.Bottomley@suse.de>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk> <1275149418.4503.128.camel@mulgrave.site> <1275156734.1645.496.camel@laptop>
In-Reply-To: <1275156734.1645.496.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312314.12391.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, Peter Zijlstra wrote:
> On Sat, 2010-05-29 at 11:10 -0500, James Bottomley wrote:
> > > Correct, I strongly oppose using suspend. Not running runnable tasks is
> > > not a sane solution.
> > 
> > Look, this is getting into the realms of a pointless semantic quibble.
> > The problem is that untrusted tasks need to be forcibly suspended when
> > they have no legitimate work to do and the user hasn't authorised them
> > to continue even if the scheduler sees them as runnable.  Whether that's
> > achieved by suspending the entire system or forcibly idling the tasks
> > (using blocking states or freezers or something) so the scheduler can
> > suspend from idle is something to be discussed,
> 
> So what happens if you task is CPU bound and gets suspended and is
> holding a resource (lock, whatever) that is required by someone else
> that didn't get suspended?
> 
> That's the classic inversion problem, and is caused by not running
> runnable tasks.

That, among other things, is why suspend uses the freezer which guarantees
that nothing like this will happen.

> >  but the net result is
> > that we have to stop a certain set of tasks in such a way that they can
> > still receive certain external events ... semantically, this is
> > equivalent to not running runnable tasks in my book.
> 
> Why would be care about external events? Clearly these apps are ill
> behaved, otherwise they would have listened to the environment telling
> them to idle.
> 
> Why would you try to let buggy apps work as intended instead of break
> them as hard as possible? Such policy promotes crappy code since people
> get away with it.

Yeah, and that's why Windows owns desktop market. ;-)

> >  (Perhaps this whole
> > thing is because the word runnable means different things ... I'm
> > thinking a task that would consume power ... are you thinking in the
> > scheduler R state?)
> 
> Clearly I mean TASK_RUNNABLE, if not that the scheduler doesn't care.
> 
> > Realistically, the main thing we need to do is stop timers posted
> > against the task (which is likely polling in a main loop, that being the
> > usual form of easy to write but power crazy app behaviour) from waking
> > the task and bringing the system out of suspend (whether from idle or
> > forced).
> 
> Sure, that same main loop will probably receive a message along the
> lines of, 'hey, screen is off, we ought to go sleep'. If after that it
> doesn't listen, and more serious messages don't get responded to, simply
> kill the thing.
> 
> Again, there is no reason what so ever to tolerate broken apps, it only
> promotes crappy apps.

Do you realistically think that by hurting the _user_ you will make the
_developer_ write better code?  No, really.

If the user likes the app very much (or depends on it or whatever makes him
use it), he will rather switch the platform to one that allows him to run that
app without _visible_ problems than complain to the developer, because _the_
_user_ _doesn't_ _realize_ that the app is broken.  From the user's
perspective, the platform that has problems with the app is broken, because
the app apparently runs without problems on concurrent platforms.

The whole "no reason to tolerate broken apps" midset is simply misguided IMO,
because it's based on unrealistic assumptions.  That's because in general users
only need the platform for running apps they like (or need or whatever).  If
they can't run apps they like on a given platform, or it is too painful to them
to run their apps on it, they will rather switch to another platform than stop
using the apps.

Thanks,
Rafael
