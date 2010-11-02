Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0KBMLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:11:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35403 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab0KBMLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:11:17 -0400
Date: Tue, 2 Nov 2010 05:11:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
Message-ID: <20101102121113.GG2664@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
 <1288589624-15251-4-git-send-email-david@fromorbit.com>
 <1288604287.2660.94.camel@edumazet-laptop>
 <20101101134451.GN2715@dastard>
 <1288625362.2660.108.camel@edumazet-laptop>
 <20101102000152.GO2715@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101102000152.GO2715@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 11:01:52AM +1100, Dave Chinner wrote:
> On Mon, Nov 01, 2010 at 04:29:22PM +0100, Eric Dumazet wrote:
> > Le mardi 02 novembre 2010 à 00:44 +1100, Dave Chinner a écrit :
> > 
> > > Perhaps you should rename that file "slab_destroy_by_rcu-tips.txt",
> > > because the current name seems unrelated to the contents. :/
> > > 
> > 
> > Hmm, I dont know, this doc really is about the nulls thing.
> 
> Ok, now I understand - there's a new list type that I didn't know
> about called hlist_nulls. not surprising - it's not documented
> anywhere.
> 
> Maybe explicitly describing what the list_null pattern іs or a
> pointer to linux/include/list_nulls.h might be appropriate, because
> I managed to read that documentation and not realise that it was
> refering to a specific type of list that was already implemented
> rather than a simple marker technique.
> 
> > This stuff also addressed one problem I forgot to tell you about: During
> > a lookup, you might find an item that is moved to another chain by
> > another cpu, so your lookup is redirected to another chain. You can miss
> > your target.
> 
> <groan>
> 
> So, to go to per-chain locks as per the proposed bit-lock-on-the-
> low-bit-of-the-head-pointer infrastructure, we'll have to cross that
> with the hlist_null code that plays low-bit pointer games for
> detecting the end of the chain.
> 
> That's just messy - another hash chain specific scalability hackup.
> My dislike of using hash tables for unbounded caches is not
> improved by this....

Indeed, using call_rcu() or synchronize_rcu() guarantees that the identity
of a given RCU-protected structure will not change while you remain in a
given RCU read-side critical section.  In contrast, SLAB_DESTROY_BY_RCU
only guarantees that the type of the object will remain the same.  So this
is the usual complexity/speed tradeoff.  Use of call_rcu() gives the freed
memory more time to grow cache-cold, and synchronize_rcu() further blocks
the caller for several milliseconds, but allows much simpler identity
checks, often permitting you to dispense entirely with identity checks.

In contrast, SLAB_DESTROY_BY_RCU avoid cache-coldness, but requires
much more careful identity checks.

> > You must find a way to detect such thing to restart the lookup at
> > the beginning (of the right chain).  Either you stick the chain
> > number in a new inode field (that costs extra memory), or you use
> > the 'nulls' value that can let you know if you ended your lookup
> > in the right chain.
> 
> The chain is determined by hashing the inode number. Perhaps a
> simple enough test is to hash the last inode number on a cache miss
> and if that doesn't match the hash of the lookup key we redo the
> search. That seems to me like it will avoid needing to play games
> with termination markers - does that sound reasonable?

As long as you do the test under a lock that prevents the inode's identity
from changing.  Not sure what you should do about hash collisions, though.
Perhaps recheck the incoming pointer?

							Thanx, Paul
