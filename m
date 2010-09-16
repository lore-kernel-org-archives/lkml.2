Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0IPRR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:17:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35349 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0IPRR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:17:27 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: miklos@szeredi.hu, paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-reply-to: <1284656978.26423.11.camel@mulgrave.site> (message from James
	Bottomley on Thu, 16 Sep 2010 13:09:38 -0400)
Subject: Re: memory barrier question
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
	 <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com>
	 <6383.1284647456@redhat.com> <20100916150356.GD2462@linux.vnet.ibm.com>
	 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
	 <20100916163708.GG2462@linux.vnet.ibm.com>
	 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu> <1284656978.26423.11.camel@mulgrave.site>
Message-Id: <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Sep 2010 19:17:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, James Bottomley wrote:
> On Thu, 2010-09-16 at 18:56 +0200, Miklos Szeredi wrote:
> > On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > > On Thu, Sep 16, 2010 at 06:06:53PM +0200, Miklos Szeredi wrote:
> > > > On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > > > > On Thu, Sep 16, 2010 at 03:30:56PM +0100, David Howells wrote:
> > > > > > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > > 
> > > > > > > Is the rmb() really needed?
> > > > > > > 
> > > > > > > Take this code from fs/namei.c for example:
> > > > > > > 
> > > > > > > 		inode = next.dentry->d_inode;
> > > > > > > 		if (!inode)
> > > > > > > 			goto out_dput;
> > > > > > > 
> > > > > > > 		if (inode->i_op->follow_link) {
> > > > > > > 
> > > > > > > It happily dereferences dentry->d_inode without a barrier after
> > > > > > > checking it for non-null, while that d_inode might have just been
> > > > > > > initialized on another CPU with a freshly created inode.  There's
> > > > > > > absolutely no synchornization with that on this side.
> > > > > > 
> > > > > > Perhaps it's not necessary; once set, how likely is i_op to be changed once
> > > > > > I_NEW is cleared?
> > > > > 
> > > > > Are the path_get()s protecting this?
> > > > 
> > > > No, when creating a file the dentry will go from negative to positive
> > > > independently from lookup.  The dentry can get instantiated with an
> > > > inode between the path_get() and dereferencing ->d_inode.
> > > > 
> > > > > If there is no protection, then something like rcu_dereference() is
> > > > > needed for the assignment from next.dentry->d_inode.
> > > > 
> > > > Do I understand correctly that the problem is that a CPU may have a
> > > > stale cache associated with *inode, one that was loaded before the
> > > > write barrier took effect?
> > > 
> > > Yes, especially if the compiler is aggressively optimizing.
> > 
> > How do compiler optimizations make a difference?
> 
> There are two types of reorderings that cause problems if you expect the
> bus visible ordering to matter.  One is CPU issue reordering, where the
> cpu decides to output loads and stores in a different order than the
> input instruction stream actually said.  The other is compiler
> re-ordering where the compiler actually reorders the instructions to
> execute in a different order from what you'd expect by simply reading
> the C code.
> 
> We have compiler barrier instructions for the latter and barriers which
> issue CPU primitives for the former.

Right but in the concrete namei example I can't see how a compiler
optimization can make a difference.  The order of the loads is quite
clear:

   LOAD inode = next.dentry->inode
   if (inode != NULL)
   	LOAD inode->f_op

What is there the compiler can optimize?

Thanks,
Miklos
