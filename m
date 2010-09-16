Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0IPNmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:42:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35456 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0IPNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:42:42 -0400
To: David Howells <dhowells@redhat.com>
CC: miklos@szeredi.hu, paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-reply-to: <3777.1284638136@redhat.com> (message from David Howells on Thu,
	16 Sep 2010 12:55:36 +0100)
Subject: Re: memory barrier question
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu> <3777.1284638136@redhat.com>
Message-Id: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Sep 2010 15:42:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Consider the following example:
> > 
> > Start:
> > 	p = NULL;
> > 	x = 0;
> > 
> > CPU1:
> > 	atomic_inc(&x);
> > 	p = &x;
> > 
> > CPU2:
> > 	if (p)
> > 		z = atomic_read(p);
> > 
> > Is it possible to end up with z == 0?
> 
> I think so.  I'm not sure that you can assume that CPU1 does its two
> 'operations' in the same order.  You can guarantee that the read of x,
> increment, and write of x will be done in an order, and that no one else will
> see an intermediate state, but you can't guarantee that CPU2 will see x
> changed before p is changed.
> 
> In Documentation/memory-barriers.txt, it says:
> 
> 	The following also do _not_ imply memory barriers, and so may require
> 	explicit memory barriers under some circumstances
> 	(smp_mb__before_atomic_dec() for instance):
> 
> 		atomic_add();
> 		atomic_sub();
> 		atomic_inc();
> 		atomic_dec();
> 
> so you need _two_ memory barriers, e.g.:
> 
> 	CPU1:
> 		atomic_inc(&x);
> 		smp_mb__after_atomic_inc()
> 		p = &x;
> 
> 	CPU2:
> 		q = p;
> 		smp_rmb();
> 		if (q)
> 			z = atomic_read(q);
> 
> Note that atomic_inc() may imply a suitable memory barrier on some arches, and
> so has special variant barrier functions of its own.

Is the rmb() really needed?

Take this code from fs/namei.c for example:

		inode = next.dentry->d_inode;
		if (!inode)
			goto out_dput;

		if (inode->i_op->follow_link) {

It happily dereferences dentry->d_inode without a barrier after
checking it for non-null, while that d_inode might have just been
initialized on another CPU with a freshly created inode.  There's
absolutely no synchornization with that on this side.

Isn't the fact that we check the pointer for being non-null (together
with locking/barrier on the other side) enough to ensure that it's
safe to dereference it?

Thanks,
Miklos
