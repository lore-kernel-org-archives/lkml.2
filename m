Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0IPRJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:09:43 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51585 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935Ab0IPRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:09:41 -0400
Subject: Re: memory barrier question
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
	 <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com>
	 <6383.1284647456@redhat.com> <20100916150356.GD2462@linux.vnet.ibm.com>
	 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
	 <20100916163708.GG2462@linux.vnet.ibm.com>
	 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 13:09:38 -0400
Message-ID: <1284656978.26423.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:56 +0200, Miklos Szeredi wrote:
> On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > On Thu, Sep 16, 2010 at 06:06:53PM +0200, Miklos Szeredi wrote:
> > > On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > > > On Thu, Sep 16, 2010 at 03:30:56PM +0100, David Howells wrote:
> > > > > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > > 
> > > > > > Is the rmb() really needed?
> > > > > > 
> > > > > > Take this code from fs/namei.c for example:
> > > > > > 
> > > > > > 		inode = next.dentry->d_inode;
> > > > > > 		if (!inode)
> > > > > > 			goto out_dput;
> > > > > > 
> > > > > > 		if (inode->i_op->follow_link) {
> > > > > > 
> > > > > > It happily dereferences dentry->d_inode without a barrier after
> > > > > > checking it for non-null, while that d_inode might have just been
> > > > > > initialized on another CPU with a freshly created inode.  There's
> > > > > > absolutely no synchornization with that on this side.
> > > > > 
> > > > > Perhaps it's not necessary; once set, how likely is i_op to be changed once
> > > > > I_NEW is cleared?
> > > > 
> > > > Are the path_get()s protecting this?
> > > 
> > > No, when creating a file the dentry will go from negative to positive
> > > independently from lookup.  The dentry can get instantiated with an
> > > inode between the path_get() and dereferencing ->d_inode.
> > > 
> > > > If there is no protection, then something like rcu_dereference() is
> > > > needed for the assignment from next.dentry->d_inode.
> > > 
> > > Do I understand correctly that the problem is that a CPU may have a
> > > stale cache associated with *inode, one that was loaded before the
> > > write barrier took effect?
> > 
> > Yes, especially if the compiler is aggressively optimizing.
> 
> How do compiler optimizations make a difference?

There are two types of reorderings that cause problems if you expect the
bus visible ordering to matter.  One is CPU issue reordering, where the
cpu decides to output loads and stores in a different order than the
input instruction stream actually said.  The other is compiler
re-ordering where the compiler actually reorders the instructions to
execute in a different order from what you'd expect by simply reading
the C code.

We have compiler barrier instructions for the latter and barriers which
issue CPU primitives for the former.

James


