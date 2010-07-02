Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937Ab0GBEB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:01:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38361 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0GBEB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:01:57 -0400
Date: Thu, 1 Jul 2010 21:01:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Dave Chinner <david@fromorbit.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100702040151.GA2370@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
 <20100630124049.GH21358@laptop>
 <AANLkTilZHnTiTJRYtYAkAChvAZKy-ZD-7M0y5o3hvRr1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilZHnTiTJRYtYAkAChvAZKy-ZD-7M0y5o3hvRr1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:35:35AM -0700, Linus Torvalds wrote:
> On Wed, Jun 30, 2010 at 5:40 AM, Nick Piggin <npiggin@suse.de> wrote:
> >>
> >> That's a pretty big ouch. Why does RCU freeing of inodes cause that
> >> much regression? The RCU freeing is out of line, so where does the big
> >> impact come from?
> >
> > That comes mostly from inability to reuse the cache-hot inode structure,
> > and the cost to go over the deferred RCU list and free them after they
> > get cache cold.
> 
> I do wonder if this isn't a big design bug.
> 
> Most of the time with RCU, we don't need to wait to actually do the
> _freeing_ of the individual data structure, we only need to make sure
> that the data structure remains of the same _type_. IOW, we can free
> it (and re-use it), but the backing storage cannot be released to the
> page cache. That's what SLAB_DESTROY_BY_RCU should give us.
> 
> Is that not possible in this situation? Do we really need to keep the
> inode _identity_ around for RCU?

In this case, the workload can be very update-heavy, so this type-safe
(vs. identity-safe) approach indeed makes a lot of sense.  But if this
was a read-heavy situation (think SELinux or many areas in networking),
the read-side simplifications and speedups that often come with
identity safety would probably more than make up for the occasional
grace-period-induced cache miss.

So, as a -very- rough rule of thumb, when less than a few percent
of the accesses are updates, you most likely want identity safety.
If more than half of the accesses can be updates, you probably want
SLAB_DESTROY_BY_RCU-style type safety instead -- or maybe just straight
locking.  If you are somewhere in between, pick one randomly, if
it works, go with it, otherwise try something else.  ;-)

In this situation, a create/rename/delete workload would be quite update
heavy, so, as you say, SLAB_DESTROY_BY_RCU is well worth looking into.

							Thanx, Paul

> If you use just SLAB_DESTROY_BY_RCU, then inode re-use remains, and
> cache behavior would be much improved. The usual requirement for
> SLAB_DESTROY_BY_RCU is that you only touch a lock (and perhaps
> re-validate the identity) in the RCU-reader paths. Could that be made
> to work?
> 
> Because that 27% drop really is pretty distressing.
> 
> That said, open (of the non-creating kind), close, and stat are
> certainly more important than creating and freeing files. So as a
> trade-off, it's probably the right thing to do. But if we can get all
> the improvement _without_ that big downside, that would obviously be
> better yet.
> 
>                       Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
