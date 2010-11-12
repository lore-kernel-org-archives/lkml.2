Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0KLGtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:49:19 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56070 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab0KLGtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:49:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACpy3Ex5LcEI/2dsb2JhbACiS3K+N4VKBJBS
Date: Fri, 12 Nov 2010 17:49:11 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101112064911.GA3775@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
 <20101112060202.GB3332@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112060202.GB3332@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 05:02:02PM +1100, Nick Piggin wrote:
> On Thu, Nov 11, 2010 at 08:48:38PM -0800, Linus Torvalds wrote:
> > On Thu, Nov 11, 2010 at 5:24 PM, Nick Piggin <npiggin@gmail.com> wrote:
> > >
> > > So this is really not a "oh, maybe someone will see 10-20% slowdown", or even
> > > 1-2% slowdown.
> > 
> > You ignored my bigger issue: the _normal_ way - and the better way -
> > to handle these thingsis with SLAB_DESTROY_BY_RCU.
> 
> Well I tried to answer that in the other threads.
> 
> SLAB_DESTROY_BY_RCU is indeed quite natural for a lot of RCU usages,
> because even with standard RCU you almost always have the pattern like
> 
> rcu_read_lock();
> obj = lookup_data_structure(key);
> if (obj) {
>   lock(obj);
>   verify_obj_in_structure(obj, key);
>   /* blah... (eg. take refcount) */
> }
> 
> And in this pattern, SLAB_DESTROY_BY_RCU takes almost zero work.
> 
> OK, but rcu-walk doesn't have that. In rcu-walk, we can't take a lock
> or a reference on either the dentry _or_ the inode, because the whole
> point is to reduce atomics (for single threaded performance), and
> stores into shared cachelines along the path (for scalability).
> 
> It gets really interesting when you have crazy stuff going on like
> inode->i_ops changing from underneath you while you're trying to do
> permission lookups, or inode type changing from link to dir to reg
> in the middle of the traversal.
> 
> 
> > So what are the advantages of using the inferior approach?  I really
> > don't see why you push the whole "free the damn things individually"
> > approach.
> 
> I'm not pushing _that_ aspect of it. I'm pushing the "don't go away and
> come back as something else" aspect.
> 
> Yes it may be _possible_ to do store-free walking SLAB_DESTROY_BY_RCU,
> and I have some ideas. But it is hairy. More hairy than rcu-walk, by
> quite a long shot.

So in short, that is my justification. 12% is a worst case regression,
but the demonstration is obviously absurdly worst case, and is merely
there as a "ok, the sky won't fall on anybody's head" upper bound.

In reality, it's likely to be well under 0.1% in any real workload, even
an inode intensive one. So I much prefer to err on the side of less
complexity, to start with. There just isn't much risk of regression
AFAIKS, and much more risk of becoming unmaintainable too complex.

