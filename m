Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0JSQuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:50:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab0JSQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:50:50 -0400
Date: Tue, 19 Oct 2010 12:50:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101019165044.GA13531@infradead.org>
References: <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
 <20101017022539.GA3317@amd>
 <87iq0za32l.fsf@basil.nowhere.org>
 <20101018162105.GB9571@infradead.org>
 <20101019070057.GA7770@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019070057.GA7770@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 06:00:57PM +1100, Nick Piggin wrote:
> But it is still "magic". Because you don't even know whether it
> is a spin or sleeping lock, let alone whether it is irq or bh safe.
> You get far more information seeing a bit_spin_lock(0, &hlist) call
> than hlist_lock().
> 
> Even if you do rename them to hlist_bit_spin_lock, etc. Then you need
> to add variants for each type of locking a caller wants to do on it.
> Ask Linus what he thinks about that.

And why do we need all these versions?  We never had irqsave or bhsave
versions of bitlocks.  The only thing we might eventually want are
trylock and is_locked operations once we grow user of it.

To get back a bit to the point:

 - we have a new bl_hlist sturcture which combines a hash list and a
   lock embedded into the head
 - the reason why we do it is to be able to use a bitlock
 
Now your initial version exposed the ugly defaults of that to the user
which is required to case the hash head to and unsigned long and use
bit_spin_lock on bit 0 of it.  There's zero abstraction and a lot
internal gutting required there.

The version I suggest and that dave implemented instead adds wrappers
to call bit_spin_lock/unlock with thos conventions as helper that
operate on the abstract type.  This frees the caller from revinventing
just those same wrappers, as done in your demo tree for the inode and
dentry hashes.

Furthermore it allows the RT people to simply throw a mutex into the
head and everything keeps working without touching a sinlge line of
code outside of hlist_bl.h.

To me that's very clearly preferable, and I'd really like to see
a clearly reasoned argument against it.
