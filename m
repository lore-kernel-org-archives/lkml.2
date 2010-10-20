Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab0JTWJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:09:08 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:44726 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754872Ab0JTWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:09:07 -0400
Date: Thu, 21 Oct 2010 09:05:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101020220557.GN32255@dastard>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
 <20101019231747.GC12506@dastard>
 <1287574269.3488.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287574269.3488.11.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 01:31:09PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 10:17 +1100, Dave Chinner wrote:
> > On Tue, Oct 19, 2010 at 06:58:39PM -0400, Eric Paris wrote:
> > > @@ -36,12 +63,11 @@ struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
> > >  	struct ima_iint_cache *iint;
> > >  
> > >  	rcu_read_lock();
> > > -	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
> > > -	if (!iint)
> > > -		goto out;
> > > -	kref_get(&iint->refcount);
> > > -out:
> > > +	iint = __ima_iint_find(inode);
> > > +	if (iint)
> > > +		kref_get(&iint->refcount);
> > >  	rcu_read_unlock();
> > > +
> > 
> > This is wrong - the rbtree is protected only by the ima_iint_lock(),
> > not RCU. Hence you can't do lockless lookups on an rbtree in this
> > manner as they will race with inserts and deletes.
> 
> Correct, what can be made to work is combine RCU with a seqlock. Retry
> the lookup using read_seqretry(), RCU here helps to ensure you're not
> stepping on already freed memory.
> 
> 
> So, tree modification does:
> 
>   write_seqlock();
>   /* frob RB-tree, using call_rcu() for frees where needed */
>   write_sequnlock();
> 
> Lookup does:
> 
>   unsigned seq;
> 
>   rcu_read_lock()
> again;
>   seq = read_seqbegin();
> 
>   /* RB-tree lookup */
> 
>   if (read_seqretry(seq))
>     goto again;
> 
>   rcu_read_unlock();
> 
>   return obj;

Nice trick, Peter. Thanks for sharing that - I'll definitely find
that useful. :)

/me wanders off to look at converting the xfs buffer cache rbtrees
to RCU....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
