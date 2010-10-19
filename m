Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab0JSHBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:01:05 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45758 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758044Ab0JSHBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:01:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoEAEffvEx5LcB2gWdsb2JhbAChZxYBARYiIsBkhUkE
Date: Tue, 19 Oct 2010 18:00:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101019070057.GA7770@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
 <20101016075703.GO19147@amd>
 <20101016161642.GC16861@infradead.org>
 <20101016171213.GC3240@amd>
 <20101017004610.GB29677@dastard>
 <20101017022539.GA3317@amd>
 <87iq0za32l.fsf@basil.nowhere.org>
 <20101018162105.GB9571@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018162105.GB9571@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:21:05PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 18, 2010 at 06:16:50PM +0200, Andi Kleen wrote:
> > > Hiding the type of lock, and hiding the fact that it sets the low bit?
> > > I don't agree. We don't have synchronization in our data structures,
> > > where possible, because it is just restrictive or goes wrong when people
> > > don't think enough about the locking.
> > 
> > I fully agree. The old skb lists in networking made this mistake
> > long ago and it was a big problem, until people essentially stopped 
> > using it (always using __ variants) and it was eventually removed.
> > 
> > Magic locking in data structures is usually a bad idea.
> 
> Err, there is no implicit locking in the calls to hlist_*.  There
> is just two small wrappers for the bit-lock/unlock so that the callers
> don't have to know how the lock is overloaded onto the pointer in the
> list head.  

But it is still "magic". Because you don't even know whether it
is a spin or sleeping lock, let alone whether it is irq or bh safe.
You get far more information seeing a bit_spin_lock(0, &hlist) call
than hlist_lock().

Even if you do rename them to hlist_bit_spin_lock, etc. Then you need
to add variants for each type of locking a caller wants to do on it.
Ask Linus what he thinks about that.

