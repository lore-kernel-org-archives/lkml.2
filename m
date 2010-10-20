Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0JTDLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:11:10 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55517 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab0JTDLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:11:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMj4vUx5LdoF/2dsb2JhbAChVnLCZYVKBA
Date: Wed, 20 Oct 2010 14:11:05 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Andi Kleen <andi@firstfloor.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101020031105.GI3740@amd>
References: <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
 <20101017022539.GA3317@amd>
 <87iq0za32l.fsf@basil.nowhere.org>
 <20101018162105.GB9571@infradead.org>
 <20101019070057.GA7770@amd>
 <20101019165044.GA13531@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019165044.GA13531@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:50:44PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 19, 2010 at 06:00:57PM +1100, Nick Piggin wrote:
> > But it is still "magic". Because you don't even know whether it
> > is a spin or sleeping lock, let alone whether it is irq or bh safe.
> > You get far more information seeing a bit_spin_lock(0, &hlist) call
> > than hlist_lock().
> > 
> > Even if you do rename them to hlist_bit_spin_lock, etc. Then you need
> > to add variants for each type of locking a caller wants to do on it.
> > Ask Linus what he thinks about that.
> 
> And why do we need all these versions?  We never had irqsave or bhsave
> versions of bitlocks.  The only thing we might eventually want are
> trylock and is_locked operations once we grow user of it.

Or sleeping locks. And there is no reason not to have irqsave or
bhsave versions of bitlocks (which could enable interrupts etc on
a contended lock) but they just haven't been put in yet. If someone
needs them, and implements them in the bitlock code, everybody can
use them.


> To get back a bit to the point:
> 
>  - we have a new bl_hlist sturcture which combines a hash list and a
>    lock embedded into the head
>  - the reason why we do it is to be able to use a bitlock

To use bit 0 as a lock bit, yes. But if another use for the API was
required like to store some other OOB state (not a lock), then some
assertions can come out of the hlist_bl code quite easily and it
can be extended to have an arbitrary bit there. (or several arbitrary
bits if the pointer is aligned correctly).

  
> Now your initial version exposed the ugly defaults of that to the user
> which is required to case the hash head to and unsigned long and use
> bit_spin_lock on bit 0 of it.  There's zero abstraction and a lot
> internal gutting required there.

What do you mean zero abstraction? It changes all the hlist operations
to handle bit 0 as lock bit.

Locking and unlocking a bit, we already have abstractions for. They work
really well, and nobody has to check the implementation to know what
they do.

