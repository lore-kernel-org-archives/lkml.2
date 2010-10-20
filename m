Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0JTLb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:31:28 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58557 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0JTLb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:31:27 -0400
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <20101019231747.GC12506@dastard>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
	 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
	 <20101019231747.GC12506@dastard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 13:31:09 +0200
Message-ID: <1287574269.3488.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 10:17 +1100, Dave Chinner wrote:
> On Tue, Oct 19, 2010 at 06:58:39PM -0400, Eric Paris wrote:
> > @@ -36,12 +63,11 @@ struct ima_iint_cache *ima_iint_find_get(struct inode *inode)
> >  	struct ima_iint_cache *iint;
> >  
> >  	rcu_read_lock();
> > -	iint = radix_tree_lookup(&ima_iint_store, (unsigned long)inode);
> > -	if (!iint)
> > -		goto out;
> > -	kref_get(&iint->refcount);
> > -out:
> > +	iint = __ima_iint_find(inode);
> > +	if (iint)
> > +		kref_get(&iint->refcount);
> >  	rcu_read_unlock();
> > +
> 
> This is wrong - the rbtree is protected only by the ima_iint_lock(),
> not RCU. Hence you can't do lockless lookups on an rbtree in this
> manner as they will race with inserts and deletes.

Correct, what can be made to work is combine RCU with a seqlock. Retry
the lookup using read_seqretry(), RCU here helps to ensure you're not
stepping on already freed memory.


So, tree modification does:

  write_seqlock();
  /* frob RB-tree, using call_rcu() for frees where needed */
  write_sequnlock();

Lookup does:

  unsigned seq;

  rcu_read_lock()
again;
  seq = read_seqbegin();

  /* RB-tree lookup */

  if (read_seqretry(seq))
    goto again;

  rcu_read_unlock();

  return obj;
  


