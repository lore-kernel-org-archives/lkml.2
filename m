Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011Ab0KLGCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:02:10 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1103 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab0KLGCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:02:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ9n3Ex5LcEI/2dsb2JhbACiS3K+UYVKBJBS
Date: Fri, 12 Nov 2010 17:02:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101112060202.GB3332@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109220506.GE3246@amd>
 <AANLkTi=H5ZZ3b5F=Z-PM6FX84FJNzdSh4_HbeeU666ts@mail.gmail.com>
 <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimn623-N1R_Bn4sF4U6OX55TQZ2w7jGOq+kB5Pz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 08:48:38PM -0800, Linus Torvalds wrote:
> On Thu, Nov 11, 2010 at 5:24 PM, Nick Piggin <npiggin@gmail.com> wrote:
> >
> > So this is really not a "oh, maybe someone will see 10-20% slowdown", or even
> > 1-2% slowdown.
> 
> You ignored my bigger issue: the _normal_ way - and the better way -
> to handle these thingsis with SLAB_DESTROY_BY_RCU.

Well I tried to answer that in the other threads.

SLAB_DESTROY_BY_RCU is indeed quite natural for a lot of RCU usages,
because even with standard RCU you almost always have the pattern like

rcu_read_lock();
obj = lookup_data_structure(key);
if (obj) {
  lock(obj);
  verify_obj_in_structure(obj, key);
  /* blah... (eg. take refcount) */
}

And in this pattern, SLAB_DESTROY_BY_RCU takes almost zero work.

OK, but rcu-walk doesn't have that. In rcu-walk, we can't take a lock
or a reference on either the dentry _or_ the inode, because the whole
point is to reduce atomics (for single threaded performance), and
stores into shared cachelines along the path (for scalability).

It gets really interesting when you have crazy stuff going on like
inode->i_ops changing from underneath you while you're trying to do
permission lookups, or inode type changing from link to dir to reg
in the middle of the traversal.


> So what are the advantages of using the inferior approach?  I really
> don't see why you push the whole "free the damn things individually"
> approach.

I'm not pushing _that_ aspect of it. I'm pushing the "don't go away and
come back as something else" aspect.

Yes it may be _possible_ to do store-free walking SLAB_DESTROY_BY_RCU,
and I have some ideas. But it is hairy. More hairy than rcu-walk, by
quite a long shot.

And the complexity and issues that need to be understood are basically
rcu-walk + *more*. So I want basic rcu-walk to be reviewed and basically
verified first, and we could think about the +more part after that.

Basically SLAB_DESTROY_BY_RCU is not exactly natural for a completely
store-free algorithm.

