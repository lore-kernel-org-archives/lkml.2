Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0IPPEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:04:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60276 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0IPPEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:04:02 -0400
Date: Thu, 16 Sep 2010 08:03:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100916150356.GD2462@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1OwEjQ-0006wS-MU@pomaz-ex.szeredi.hu>
 <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
 <3777.1284638136@redhat.com>
 <6383.1284647456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6383.1284647456@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:30:56PM +0100, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Is the rmb() really needed?
> > 
> > Take this code from fs/namei.c for example:
> > 
> > 		inode = next.dentry->d_inode;
> > 		if (!inode)
> > 			goto out_dput;
> > 
> > 		if (inode->i_op->follow_link) {
> > 
> > It happily dereferences dentry->d_inode without a barrier after
> > checking it for non-null, while that d_inode might have just been
> > initialized on another CPU with a freshly created inode.  There's
> > absolutely no synchornization with that on this side.
> 
> Perhaps it's not necessary; once set, how likely is i_op to be changed once
> I_NEW is cleared?

Are the path_get()s protecting this?

If there is no protection, then something like rcu_dereference() is
needed for the assignment from next.dentry->d_inode.

> > Isn't the fact that we check the pointer for being non-null (together
> > with locking/barrier on the other side) enough to ensure that it's
> > safe to dereference it?
> 
> It's possible that since there's a dependency between the variables on the
> reading CPU that the barrier is not required.
> 
> I think I have to refer that question to Paul.

We would need either one of the rcu_dereference() or smp_read_barrier_depends()
APIs to enforce the dependency, for example, against the compiler.

							Thanx, Paul
