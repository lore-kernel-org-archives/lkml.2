Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0KIVsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:48:35 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56649 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708Ab0KIVsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:48:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMtN2Ux5LcZK/2dsb2JhbACiJ3K+AoVKBA
Date: Wed, 10 Nov 2010 08:48:29 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109214829.GC3246@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <20101109162131.GA3781@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109162131.GA3781@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:21:31AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 09, 2010 at 08:02:38AM -0800, Linus Torvalds wrote:
> > Remind me why it wasn't sufficient to just use SLAB_DESTROY_BY_RCU?
> 
> Dave sent a patch for it, which looks much better to me.

It's horribly complex and why even do any of that for icache by
itself? What is going on there really? Do you think RCU inodes
are really important for inode hash lookup?

>  Nick thinks
> it doesn't work for his store free path walk, but I haven't seen an
> explanation why exactly.

I posted explanations several times, and the code is there to
look at. I haven't seen an explanation from you about how it should
be used with rcu-walk, and why we shouldn't go with the simpler
RCU approach first and then evaulate an incremental patch.

> 
> > The only thing we care about is the pathname walk - there are no other
> > inode operations that are common enough to worry about. And the only
> > thing _that_ needs is the ability to look at the inode under RCU, and
> > SLAB_DESTROY_BY_RCU should be entirely sufficient for that.
> 
> It might be worth it for inode lookup.  While it's shadowed by the
> dcache hash we still hit it a lot, especially for NFS serving.  

No, you would never make inode RCU for that case alone. That's
crazy. _If_ NFS serving really hits that bottleneck, then fine
grained hash locking makes it go away. So it's not a justification
for anything.

