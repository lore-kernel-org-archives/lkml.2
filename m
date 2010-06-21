Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab0FUOsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:48:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab0FUOsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:48:13 -0400
Date: Tue, 22 Jun 2010 00:48:06 +1000
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 11/33] fs: dcache scale subdirs
Message-ID: <20100621144806.GC31679@laptop>
References: <20090904065142.114706411@nick.local0.net>
 <20090904065535.609317663@nick.local0.net>
 <1276787615.27822.426.camel@twins>
 <20100617165329.GA6138@laptop>
 <1277127322.1875.516.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277127322.1875.516.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:35:22PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-18 at 02:53 +1000, Nick Piggin wrote:
> 
> > > Right, so this isn't going to work well, this dentry recursion is
> > > basically unbounded afaict, so the 2nd subdir will also be locked using
> > > DENRTY_D_LOCKED_NESTED, resulting in the 1st and 2nd subdir both having
> > > the same (sub)class and lockdep doesn't like that much.
> > 
> > No it's a bit of a trucky loop, but it is not unbounded. It takes the
> > parent, then the child, then it may continue again with the child as
> > the new parent but in that case it drops the parent lock and tricks
> > lockdep into not barfing.
> 
> Ah, indeed the thing you pointed out below should work.
> 
> > > Do we really need to keep the whole path locked? One of the comments
> > > seems to suggest we could actually drop some locks and re-acquire.
> > 
> > As far as I can tell, RCU should be able to cover it without taking more
> > than 2 locks at a time. John saw some issues in the -rt tree (I haven't
> > reproduced yet) so he's locking the full chains there but I hope that
> > won't be needed.
> 
> Right, so I was staring at the -rt splat, so its John who created that
> wreckage?

It was, but apparently they saw an RCU bug there somewhere and hit it
with the big hammer. I haven't been able to reproduce it on a non-rt
kernel yet, and I see yet why RCU is not good enough here.

> > > >                 /*
> > > >                  * Descend a level if the d_subdirs list is non-empty.
> > > >                  */
> > > >                 if (!list_empty(&dentry->d_subdirs)) {
> > > > +                       spin_unlock(&this_parent->d_lock);
> > > > +                       spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
> > > >                         this_parent = dentry;
> > > > +                       spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
> > > >                         goto repeat;
> > 
> >                             ^^^ That's what we do when descending.
> 
> You can write that as:
>   lock_set_subclass(&this_parent->d_lock.dep_map, 0, _RET_IP_);
> 
> See kernel/sched.c:double_unlock_balance().

OK I'll keep that in mind, thanks!

