Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1EYSQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:16:36 -0400
Received: from mail4.comsite.net ([205.238.176.238]:37333 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1EYSQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:16:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Thomas Gleixner <tglx@linutronix.de>
From: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/4] sparse irq: protect irq_to_desc against irq_free_descs
In-Reply-To: <alpine.LFD.2.02.1105250958380.3078@ionos>
References: <generic-irq-changes@mdm.bga.com>
	<rcu-lock-radix-lookup-sparse-irq@mdm.bga.com>
	 <alpine.LFD.2.02.1105250958380.3078@ionos>
Message-ID: <sparse-irq-rcu-reply@mdm.bga.com>
Date: Wed, 25 May 2011 05:49:18 -0500 
X-To-Not-Matched: true
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 about 10:14:20 +0200 (CEST), Thomas Gleixner wrote:
> On Wed, 25 May 2011, Milton Miller wrote:
> > The radix-tree code uses call_rcu to delay freeing internal data
> > elements when removing when deleting an entry.  We must protect
> > against the elements being freed while we traverse the tree.
> > 
> > While preparing a patch to expand the contexts in which the radix
> > tree optionally used by powerpc for mapping hardware irq numbers to
> > linux numbers would be called, I realized that the radix tree was
> > not locked when radix_tree_lookup was called.  I then realized the
> > same issue applies to the generic irq code when sparse irqs are in use.
> > 
> > While the powerpc radix tree was only referenced from one callsite
> > that was irqs_disabled and irq_enter, irq_to_desc is called from
> > many more contexts including threaded irq handlers and other
> > process contexts.
> > 
> > This does not show up in the rcu lockdep because in 2.6.34 commit
> > 2676a58c98 (radix-tree: Disable RCU lockdep checking in radix tree)
> > deemed it too hard to pass the condition of the protecting lock
> > to the library.
> > 
> > Signed-off-by: Milton Miller <miltonm@bga.com>
> > Cc: <stable@kernel.org>
> > ---
> > I expect the relatively infrequent calls to irq_free_descs, combined
> > with most calls to irq_to_desc being irqs_disabled and the fact
> > merged to mainline implemntations of call_rcu requiring a cpu to
> > respond to a hard irq or schedule has hidden this error to date.
> 
> The reason why nobody ever noticed is that the free happens in the
> teardown path of PCI devices and at this point nothing accesses that
> irq anymore.

I'm not talking about the irq_desc that is being removed from the
tree, instead I'm talking about the internal elements in the
radix tree that are used to find the pointers at the bottom of
the tree (that in turn point to the irq_desc in the irq tree case).

>  
> 
> > Index: work.git/kernel/irq/irqdesc.c
> > ===================================================================
> > --- work.git.orig/kernel/irq/irqdesc.c	2011-05-23 13:34:08.728585785 -0500
> > +++ work.git/kernel/irq/irqdesc.c	2011-05-23 13:46:09.197635762 -0500
> > @@ -108,7 +108,13 @@ static void irq_insert_desc(unsigned int
> >  
> >  struct irq_desc *irq_to_desc(unsigned int irq)
> >  {
> > -	return radix_tree_lookup(&irq_desc_tree, irq);
> > +	struct irq_desc *desc;
> > +
> > +	rcu_read_lock();
> > +	desc = radix_tree_lookup(&irq_desc_tree, irq);
> > +	rcu_read_unlock();
> > +
> > +	return desc
> 
> That does not really compile :)

Hmm, Ooops I thought I had sparse irq enabled, but I had

CONFIG_HAVE_SPARSE_IRQ=y
# CONFIG_SPARSE_IRQ is not set

and indeed, I am missing a semicolon.  Sorry about that.

> 
> And it does not help at all because we unconditionally free the irq
> descriptor and do not use rcu based kfree. Further you protect only

As I said above, its the actual radix tree leading to the descriptors
that are currently freed with call_rcu that I'm tring to cover.

> the lookup and not the complete section which uses the descriptor, so
> it could go away after the rcu_read_unlock() in theory.

Presently there is no locking in the generic layer between allocating
a descriptor and allowing the irq to be used; that seems to be left
to the code in the various architetures that call irq_alloc_descs.

In fact the generic layer doesn't check if there are irq actions
chained off the irq, let alone if the irq is in progress or the thread
is active.  While I agree it may be prudent to add such locking,
it is a seperate issue beyond traversing the radix tree.

Most of the architecture code I've seen so far doesn't check either.
Powerpc calls synchronise_irq, but that leaves windows and doesn't
gard against actions being registered.  Otherwise it's up to the
callers to not request an irq be freed before it is shutdown.

Back to this patch.

Depending on the tree I believe (from my partial reading of the radix
tree code) an element being deleted could collapse the path to adjacent
entries.  The fact that the tree will not always collapse will further
reduce the incidence of an error being detected and reported beyond
the fact that a lookup has to be delayed across an rcu boundary, which
the merged mainline rcu schemes will not do with hard irq disabled.

So one needs (1) the ability to collapse a tree node and (2) an
irq descriptor lookup to traverse that node either (3a) not from an
irq handler, but an irq thread or other process or bh context, or
(3b) with an out-of-tree rcu such as the Concurent RT rcu that Paul
mentioned, and (4) the free to result in the memory used by the lookup
traversial to be overwriten.   Rare, but probably not impossible.

milton
