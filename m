Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0IPQu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:50:27 -0400
Received: from mail2.shareable.org ([80.68.89.115]:59843 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab0IPQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:50:26 -0400
Date: Thu, 16 Sep 2010 17:50:18 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100916165018.GA26539@shareable.org>
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu> <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com> <6383.1284647456@redhat.com> <20100916150356.GD2462@linux.vnet.ibm.com> <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > On Thu, Sep 16, 2010 at 03:30:56PM +0100, David Howells wrote:
> > > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > 
> > > > Is the rmb() really needed?
> > > > 
> > > > Take this code from fs/namei.c for example:
> > > > 
> > > > 		inode = next.dentry->d_inode;
> > > > 		if (!inode)
> > > > 			goto out_dput;
> > > > 
> > > > 		if (inode->i_op->follow_link) {
> > > > 
> > > > It happily dereferences dentry->d_inode without a barrier after
> > > > checking it for non-null, while that d_inode might have just been
> > > > initialized on another CPU with a freshly created inode.  There's
> > > > absolutely no synchornization with that on this side.
> > > 
> > > Perhaps it's not necessary; once set, how likely is i_op to be changed once
> > > I_NEW is cleared?
> > 
> > Are the path_get()s protecting this?
> 
> No, when creating a file the dentry will go from negative to positive
> independently from lookup.  The dentry can get instantiated with an
> inode between the path_get() and dereferencing ->d_inode.
> 
> > 
> > If there is no protection, then something like rcu_dereference() is
> > needed for the assignment from next.dentry->d_inode.
> 
> Do I understand correctly that the problem is that a CPU may have a
> stale cache associated with *inode, one that was loaded before the
> write barrier took effect?
> 
> Funny that such a bug could stay unnoticed in so often excercised
> code.  Yeah I know it's alpha only.

When I first saw read_barrier_depends(), I thought it must be Alpha's
speculative execution, fetching memory out of order and confirming
it's valid later.  I was really surprised to find out it's not that -
it's a quirk of the Alpha's cache/forwarding protocol.  Others
presumably don't have it because they were designed with awareness of
this coding pattern.

But...

I wonder if it can happen on IA64 with it's funky memory-alias
compiler optimisations.

I wonder if it can happen on x86 and others, if the compiler decides
this is a valid transformation (it is with a single CPU):

Original code:

    foo = global_ptr_to_foo;
    foo_x = foo->x;

    bar = global_ptr_to_bar;
    bar_y = bar->y;
    // use bar_y;

Transformed by compiler:

    foo = global_ptr_to_foo;
    foo_x = foo->x;

    bar = global_ptr_to_bar;
    bar_y = (__typeof__(bar->y))foo_x;
    if ((void *)bar != (void *)foo)
        bar_y = bar->y;

    // use bar_y;

In other words, without a barrier, the compiler doesn't have to order
the executed bar->y dereference *instruction* after the bar =
global_ptr_to_bar instruction.  Thus making it a compiler property,
not a CPU one.

There is no danger of dereferencing NULL in that example, but
dereferencing the values from the wrong object is just as wrong.

-- Jamie
