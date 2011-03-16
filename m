Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1CPTrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:47:32 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23309 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1CPTr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:47:27 -0400
Date: Wed, 16 Mar 2011 14:47:26 -0500
From: scameron@beardog.cce.hp.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dab@hp.com,
        mike.miller@hp.com, scameron@beardog.cce.hp.com
Subject: Re: Question about driver ioctl, big kernel lock, mutexes
Message-ID: <20110316194726.GY12760@beardog.cce.hp.com>
References: <20110316155033.GQ12760@beardog.cce.hp.com> <201103162006.15084.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103162006.15084.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 08:06:14PM +0100, Arnd Bergmann wrote:
> On Wednesday 16 March 2011 16:50:33 scameron@beardog.cce.hp.com wrote:
> > 
> > I just noticed the existence of this change (I guess
> > I'm a little slow):
> > 
> > 	commit 2a48fc0ab24241755dc93bfd4f01d68efab47f5a
> > 	Author: Arnd Bergmann <arnd@arndb.de>
> > 	Date:   Wed Jun 2 14:28:52 2010 +0200
> > 
> > 	    block: autoconvert trivial BKL users to private mutex
> > 	    
> > 	    The block device drivers have all gained new lock_kernel
> > 	    calls from a recent pushdown, and some of the drivers
> > 	    were already using the BKL before.
> > 	    
> > 	    This turns the BKL into a set of per-driver mutexes.
> > 	    Still need to check whether this is safe to do.
> > 
> > This changes the behavior of, for example, the CCISS_PASSTHRU and 
> > other ioctls.  Previously, these were "protected" by the Big
> > Kernel Lock.  Now, from what I understand and what I've observed,
> > the Big Kernel Lock is kind of strange, in that it auto-releases 
> > whenever you sleep.  This means that the ioctl path in cciss used
> > to allow concurrency (which is fine, they should all be thread
> > safe.  I'm kind of wondering why the BKL was there in the first
> > place.  I guess I assumed it was necessary for reasons having to
> > do with the upper layers.)  
> 
> The reason to have the BKL there is that the BKL used to protect
> every syscall. The block ioctl handling was simply one of the
> final places to lose it, after it was gone almost everywhere
> else.
> 
> Originally (before Linux-1.3!), the only concurrency that was
> going on in the kernel was when one task was sleeping, so it was
> straightforward to add the semantics of the BKL that look so
> strange in retrospect.
> 
> > Now, if I understand things correctly, with this new driver specific mutex
> > surrounding the ioctl path, only one thread is permitted in the ioctl path at a
> > time, and whether it sleeps or not, the mutex is not released until it's done.
> 
> Yes.
> 
> > That's a pretty big change in behavior.  Some commands sent through
> > the passthrough ioctls may take awhile, and they're going to block
> > any other ioctls from getting started while they're going.  Previously,
> > it was possible to saturate the controller using multiple threads or
> > processes hammering on the ioctl path.  This would appear to no longer
> > be the case.
> 
> Correct. Almost all ioctls in the kernel are of the "instantly
> return" kind, any ioctl that blocks for a potentially unlimited
> amount of time under a mutex would be a bug that I introduced
> in the conversion.
> 
> > That being said, there was previously no real limit (other than
> > pci_alloc_consistent eventually failing) on how many commands
> > could be shoved through the cciss ioctl path at once, which was probably
> > a bug.  It has occurred to me to put a limit on this, and return
> > -EBUSY when the limit is hit, though I don't know if programs using
> > the ioctl are prepared to receive EBUSY... but maybe that's not my
> > problem.
> > 
> > Thoughts?
> > 
> > I'm thinking that if there's no reason the ioctl path can't allow
> > concurrency, then it should allow concurrency.
> 
> Absolutely. The best way forward would be to prove that the mutex
> I introduced is actually pointless, or alternatively change the code
> so that the mutex is only held in the places where it is really
> required, if any.

Pretty sure the ioctl stuff is already thread safe, but I will look at it
again.

There are a couple of other places the mutex is used, open, release, I think
one other place, that I'm less sure about, only because I haven't thought
about them.  It should be a safe assumption that nothing outside
the driver depends on these mutexes (obviously, since they're declared
only in the driver) so that should make it pretty easy to figure out.
 
> 
> When I submitted the patches, I always tried to make it clear that
> most of the new mutexes are not required at all, but that proving
> this for every single driver takes a lot of hard work. 
> 
> Having a mutex that should not be there causes a performance regression
> or a deadlock, both of which are fairly easy to bisect and fix, but
> missing a mutex because of a subtle BKL dependency would have meant
> introducing a race condition that would be extremely hard to analyse.
> 
> Limiting the number of concurrent I/Os submitted to a device might
> be a good idea, but I think that's a separate discussion.

Ok.  Thanks for the explanation and confirmation of what I was thinking.
I'll start working on a fix for this.  May take me a little while as 
there are a bunch of other things I have to work on, but it's been
this way since June of 2010 so far with no complaints (that I know of),
so I guess it won't hurt too much for it to be this way for a little
while longer.

-- steve

