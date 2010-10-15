Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0JOSPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 14:15:15 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30786 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab0JOSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 14:15:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHs3uEx5Ld+3/2dsb2JhbAChJXLAHYVJBI9K
Date: Sat, 16 Oct 2010 05:14:59 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015181459.GA11273@amd>
References: <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
 <20101015132938.GA3936@amd>
 <20101015173345.GA10731@amd>
 <20101015175247.GA6737@infradead.org>
 <20101015180219.GA11110@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015180219.GA11110@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 05:02:19AM +1100, Nick Piggin wrote:
> For those lookups where you are taking the i_lock anyway, they
> will look the same, except the i_lock lock width reduction
> loses the ability to lock all icache state of the inode (like
> we can practically do today with inode_lock).
> 
> This was a key consideration for maintainability for me.

Maybe you've overlooked this point. It is, in fact, very important
in my opinion. With my locking approach, everywhere where today
we have:

spin_lock(&inode_lock);
do_something(inode);
spin_unlock(&inode_lock);

it can be replaced with

spin_lock(&inode->i_lock);
do_something(inode);
spin_unlock(&inode->i_lock);

Without worrying about the lock coverage. In fact, it is a tiny bit
stronger because you also get to hold the refcount at the same time
(doesn't really matter outside core icache though).

Ditto for my dcache_lock appraoch (it's far more important there, being
much more visible to filesystems IMO, but icache is still important).

I never totally objected to reductions in i_lock lock width if they
really are required for that last bit of performance, but I have always
maintained that I want these kinds of locking irregularities merged on
their own, on top of the base code. Especially with RCU inodes, I'm not
sure if they'll be needed, however.

Most of the slowpaths where that happens, the i_lock needs to be taken
somewhere anyway, so you probably don't really save anything.

