Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0GGOgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:36:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab0GGOgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:36:12 -0400
Date: Thu, 8 Jul 2010 00:35:56 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 24/52] fs: dcache reduce d_parent locking
Message-ID: <20100707143556.GQ11732@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030729.395195069@suse.de>
 <20100628215013.GG2357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628215013.GG2357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Sorry I had left this in my postponed folder while rechecking your
questions and forgot about it :P


On Mon, Jun 28, 2010 at 02:50:13PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 24, 2010 at 01:02:36PM +1000, npiggin@suse.de wrote:
> > Use RCU property of dcache to simplify locking in some places where we
> > take d_parent and d_lock.
> > 
> > Comment: don't need rcu_deref because we take the spinlock and recheck it.
> 
> Looks good other than one question below.
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > --
> > 
> > Index: linux-2.6/fs/dcache.c
> > ===================================================================
> > --- linux-2.6.orig/fs/dcache.c
> > +++ linux-2.6/fs/dcache.c
> > @@ -311,23 +311,18 @@ struct dentry *dget_parent(struct dentry
> >  	struct dentry *ret;
> > 
> >  repeat:
> > -	spin_lock(&dentry->d_lock);
> > +	rcu_read_lock();
> >  	ret = dentry->d_parent;
> 
> Doesn't this need to be as follows?
> 
> 	ret = rcu_dereference(dentry)->d_parent;
> 
> Otherwise, couldn't we end up seeing pre-initialization value for
> ->d_parent for a newly inserted dentry?

I don't think so. The child's dentry memory should be guaranteed to be
post-initialized at the point it is passed to dget_parent, becase we've
to have a stable refcount on it at that point. Ie. if it was pulled from
an RCU list, it should already have been rcu dereferenced by now.

So ->d_parent should be a valid pointer with lifetime guarantee provided
by RCU -- so enough to take the spinlock and recheck.

> 
> > -	if (!ret)
> > -		goto out;
> > -	if (dentry == ret) {
> > -		ret->d_count++;
> > -		goto out;
> > -	}
> > -	if (!spin_trylock(&ret->d_lock)) {
> > -		spin_unlock(&dentry->d_lock);
> > +	spin_lock(&ret->d_lock);
> 
> Once we do this, however, we are golden, at least for all dentry
> fields protected by ->lock.  This does assume that the compiler does not
> speculate the fetch that initialized the argument dentry into the critical
> section, which I would sure hope would be a reasonable assumption.

Yes I think the above fact that we have a "good" ref on the dentry
should prevent this.
 
Thanks,
Nick

