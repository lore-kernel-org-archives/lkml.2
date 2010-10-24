Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0JXVRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:17:41 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12907 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932970Ab0JXVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:17:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALM+xEx5Ld2G/2dsb2JhbAChXXK6IYVIBIUM
Date: Mon, 25 Oct 2010 08:17:35 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101024211735.GB3137@amd>
References: <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
 <20101017022539.GA3317@amd>
 <87iq0za32l.fsf@basil.nowhere.org>
 <20101018162105.GB9571@infradead.org>
 <20101019070057.GA7770@amd>
 <20101019165044.GA13531@infradead.org>
 <alpine.LFD.2.00.1010241728510.11642@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010241728510.11642@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 05:44:24PM +0200, Thomas Gleixner wrote:
> On Tue, 19 Oct 2010, Christoph Hellwig wrote:
> 
> > On Tue, Oct 19, 2010 at 06:00:57PM +1100, Nick Piggin wrote:
> > > But it is still "magic". Because you don't even know whether it
> > > is a spin or sleeping lock, let alone whether it is irq or bh safe.
> > > You get far more information seeing a bit_spin_lock(0, &hlist) call
> > > than hlist_lock().
> 
> Errm, when hlist_lock() has proper documentation than it should not be
> rocket science to figure out what it does.

Right, a look at the docmentation and another layer of indirection
for a reader.

And it's not exactly "properly" documented. It doesn't say if it may
turn into a sleeping lock or is allowed to be used from irq or bh
context.


> And if you use bit 0 of hlist then you better have helper functions to
> access it anyway. We do that with other data types which (ab)use the
> lower two bits of pointers.
> 
> > To get back a bit to the point:
> > 
> >  - we have a new bl_hlist sturcture which combines a hash list and a
> >    lock embedded into the head
> >  - the reason why we do it is to be able to use a bitlock
> 
> And if you design that structure clever, then simple dereferencing of
> it (w/o casting magic) should make the compiler barf. So you are
> forced to use the helper functions.
> 
> > Furthermore it allows the RT people to simply throw a mutex into the
> > head and everything keeps working without touching a sinlge line of
> > code outside of hlist_bl.h.
> 
> Yes, please use proper helper functions. Having to change code is a
> horror for RT, when we can get away with a single change in a header
> file.
> 
> Aside of RT there is another advantage of being able to change the
> lock implementation at a single place: you can change it to a real
> spinlock and have lockdep coverage of that code. I fundamentally hate
> bit_spin_locks for sneaking around lockdep.

You do not want to add a bloated mutex to each inode hash bucket and
think you can just dust off your hands and walk away.  You would
probably make a smaller auxiliary hash of locks, sanely sized, and
protect it with that.

So it would be wrong to just bloat hlist_bl by a factor of several times
(how big is a mutex in -rt?) without doing anything else.

Although a sane locking macro and structure like I had, would perfectly
allow you to switch locks in a single place just the same.

