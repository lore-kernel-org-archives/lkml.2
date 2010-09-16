Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0IPQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 12:56:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58081 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0IPQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 12:56:11 -0400
To: paulmck@linux.vnet.ibm.com
CC: miklos@szeredi.hu, dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-reply-to: <20100916163708.GG2462@linux.vnet.ibm.com>
	(paulmck@linux.vnet.ibm.com)
Subject: Re: memory barrier question
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
 <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
 <3777.1284638136@redhat.com>
 <6383.1284647456@redhat.com>
 <20100916150356.GD2462@linux.vnet.ibm.com>
 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu> <20100916163708.GG2462@linux.vnet.ibm.com>
Message-Id: <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Sep 2010 18:56:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> On Thu, Sep 16, 2010 at 06:06:53PM +0200, Miklos Szeredi wrote:
> > On Thu, 16 Sep 2010, Paul E. McKenney wrote:
> > > On Thu, Sep 16, 2010 at 03:30:56PM +0100, David Howells wrote:
> > > > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > 
> > > > > Is the rmb() really needed?
> > > > > 
> > > > > Take this code from fs/namei.c for example:
> > > > > 
> > > > > 		inode = next.dentry->d_inode;
> > > > > 		if (!inode)
> > > > > 			goto out_dput;
> > > > > 
> > > > > 		if (inode->i_op->follow_link) {
> > > > > 
> > > > > It happily dereferences dentry->d_inode without a barrier after
> > > > > checking it for non-null, while that d_inode might have just been
> > > > > initialized on another CPU with a freshly created inode.  There's
> > > > > absolutely no synchornization with that on this side.
> > > > 
> > > > Perhaps it's not necessary; once set, how likely is i_op to be changed once
> > > > I_NEW is cleared?
> > > 
> > > Are the path_get()s protecting this?
> > 
> > No, when creating a file the dentry will go from negative to positive
> > independently from lookup.  The dentry can get instantiated with an
> > inode between the path_get() and dereferencing ->d_inode.
> > 
> > > If there is no protection, then something like rcu_dereference() is
> > > needed for the assignment from next.dentry->d_inode.
> > 
> > Do I understand correctly that the problem is that a CPU may have a
> > stale cache associated with *inode, one that was loaded before the
> > write barrier took effect?
> 
> Yes, especially if the compiler is aggressively optimizing.

How do compiler optimizations make a difference?

Thanks,
Miklos
