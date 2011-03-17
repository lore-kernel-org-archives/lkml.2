Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1CQN0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:26:41 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2985 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1CQN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:26:37 -0400
Date: Thu, 17 Mar 2011 08:26:34 -0500
From: scameron@beardog.cce.hp.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dab@hp.com,
        mike.miller@hp.com, scameron@beardog.cce.hp.com
Subject: Re: Question about driver ioctl, big kernel lock, mutexes
Message-ID: <20110317132634.GB12760@beardog.cce.hp.com>
References: <20110316155033.GQ12760@beardog.cce.hp.com> <201103162006.15084.arnd@arndb.de> <20110316194726.GY12760@beardog.cce.hp.com> <201103162140.34893.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103162140.34893.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 09:40:34PM +0100, Arnd Bergmann wrote:
> On Wednesday 16 March 2011 20:47:26 scameron@beardog.cce.hp.com wrote:
> > On Wed, Mar 16, 2011 at 08:06:14PM +0100, Arnd Bergmann wrote:
> 
> > > Absolutely. The best way forward would be to prove that the mutex
> > > I introduced is actually pointless, or alternatively change the code
> > > so that the mutex is only held in the places where it is really
> > > required, if any.
> > 
> > Pretty sure the ioctl stuff is already thread safe, but I will look at it
> > again.
> > 
> > There are a couple of other places the mutex is used, open, release, I think
> > one other place, that I'm less sure about, only because I haven't thought
> > about them.  It should be a safe assumption that nothing outside
> > the driver depends on these mutexes (obviously, since they're declared
> > only in the driver) so that should make it pretty easy to figure out.
> 
> Ah, right. The open/release functions use access the two usage_count
> variables in an unsafe way. The mutex serializes between the two,
> but there are other functions that look at the same data without
> taking the mutex. It would be good to make this safer in some
> way.
> 
> I think turning it into an atomic_t would be enough, unless the
> two usage counts need to be strictly taken atomically or in the
> context of something else.
> 
> The rest of open/close looks fine to me without the mutex.
> 
> > > When I submitted the patches, I always tried to make it clear that
> > > most of the new mutexes are not required at all, but that proving
> > > this for every single driver takes a lot of hard work. 
> > > 
> > > Having a mutex that should not be there causes a performance regression
> > > or a deadlock, both of which are fairly easy to bisect and fix, but
> > > missing a mutex because of a subtle BKL dependency would have meant
> > > introducing a race condition that would be extremely hard to analyse.
> > > 
> > > Limiting the number of concurrent I/Os submitted to a device might
> > > be a good idea, but I think that's a separate discussion.
> > 
> > Ok.  Thanks for the explanation and confirmation of what I was thinking.
> > I'll start working on a fix for this.  May take me a little while as 
> > there are a bunch of other things I have to work on, but it's been
> > this way since June of 2010 so far with no complaints (that I know of),
> > so I guess it won't hurt too much for it to be this way for a little
> > while longer.
> 
> I'm curious: what is even the intention behind the passthru ioctls?
> Do you have applications that use them a lot?

Yes.  The main user would be the HP Array configuration utility.
Also SNMP storage agents, and SMX providers for storage.  And things
like cciss_vol_status and other utils here: 
http://cciss.sourceforge.net/#cciss_utils

The passthru ioctl is how new logical drives are configured, added, removed,
etc. RAID levels can be changed, migrated, etc. on the fly, and lots of other
stuff.  Essentially the firmware on the Smart Array boards has a ton of Smart
Array specific functionality which can be controlled through the pass through
ioctls.

-- steve

