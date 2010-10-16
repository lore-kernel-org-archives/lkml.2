Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0JPH5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:57:08 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41809 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab0JPH5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:57:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:57:03 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101016075703.GO19147@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-12-git-send-email-david@fromorbit.com>
 <20101008185409.GA29251@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008185409.GA29251@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:54:09PM -0400, Christoph Hellwig wrote:
> > +struct inode_hash_bucket {
> > +	struct hlist_bl_head head;
> > +};
> > +
> > +static inline void spin_lock_bucket(struct inode_hash_bucket *b)
> > +{
> > +	bit_spin_lock(0, (unsigned long *)b);
> > +}
> > +
> > +static inline void spin_unlock_bucket(struct inode_hash_bucket *b)
> > +{
> > +	__bit_spin_unlock(0, (unsigned long *)b);
> > +}
> 
> I've looked at the dcache version of this again, and I really hate
> duplicating these helpers in the dcache code aswell.  IMHO they
> should simple operate directly on the hlist_bl_head, as that's
> what it was designed for.  I also don't really see any point in
> wrapping the hlist_bl_head as inode_hash_bucket.  If the bucket naming
> is important we could rename the hlist_bl stuff to bl_hash, and the
> hlist_bl_head could become bl_hash_bucket.

It was done because someone, like -rt, might want more than one bit of
memory to implement a lock. They would have to make a few other
changes, granted, but this helps reduce a lot of churn.

I didn't see the point of a layer of dumb wrappers for hlist_bl_head
locking. Just reproducing bit spin and wait locks in wrappers when we
already have good functions for them.

