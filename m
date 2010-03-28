Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab0C1CN7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 22:13:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0C1CN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 22:13:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=V6AqxGVSrI2O+1PNY+BE3ET7Y2fK2zpaj+WzqZbVGiPkDkLBEWIPwGNZhe3Ru+RDR
	sSBgN7wF11babyDyS4kFg==
Date: Sat, 27 Mar 2010 19:13:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] slab: add memory hotplug support
In-Reply-To: <20100309134633.GM8653@laptop>
Message-ID: <alpine.DEB.2.00.1003271849260.7249@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com> <alpine.DEB.2.00.1002251228140.18861@router.home> <20100226114136.GA16335@basil.fritz.box> <alpine.DEB.2.00.1002260904311.6641@router.home> <20100226155755.GE16335@basil.fritz.box>
 <alpine.DEB.2.00.1002261123520.7719@router.home> <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com> <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com> <20100305062002.GV8653@laptop> <alpine.DEB.2.00.1003081502400.30456@chino.kir.corp.google.com>
 <20100309134633.GM8653@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010, Nick Piggin wrote:

> On Mon, Mar 08, 2010 at 03:19:48PM -0800, David Rientjes wrote:
> > On Fri, 5 Mar 2010, Nick Piggin wrote:
> > 
> > > > +#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
> > > > +/*
> > > > + * Drains and frees nodelists for a node on each slab cache, used for memory
> > > > + * hotplug.  Returns -EBUSY if all objects cannot be drained on memory
> > > > + * hot-remove so that the node is not removed.  When used because memory
> > > > + * hot-add is canceled, the only result is the freed kmem_list3.
> > > > + *
> > > > + * Must hold cache_chain_mutex.
> > > > + */
> > > > +static int __meminit free_cache_nodelists_node(int node)
> > > > +{
> > > > +	struct kmem_cache *cachep;
> > > > +	int ret = 0;
> > > > +
> > > > +	list_for_each_entry(cachep, &cache_chain, next) {
> > > > +		struct array_cache *shared;
> > > > +		struct array_cache **alien;
> > > > +		struct kmem_list3 *l3;
> > > > +
> > > > +		l3 = cachep->nodelists[node];
> > > > +		if (!l3)
> > > > +			continue;
> > > > +
> > > > +		spin_lock_irq(&l3->list_lock);
> > > > +		shared = l3->shared;
> > > > +		if (shared) {
> > > > +			free_block(cachep, shared->entry, shared->avail, node);
> > > > +			l3->shared = NULL;
> > > > +		}
> > > > +		alien = l3->alien;
> > > > +		l3->alien = NULL;
> > > > +		spin_unlock_irq(&l3->list_lock);
> > > > +
> > > > +		if (alien) {
> > > > +			drain_alien_cache(cachep, alien);
> > > > +			free_alien_cache(alien);
> > > > +		}
> > > > +		kfree(shared);
> > > > +
> > > > +		drain_freelist(cachep, l3, l3->free_objects);
> > > > +		if (!list_empty(&l3->slabs_full) ||
> > > > +					!list_empty(&l3->slabs_partial)) {
> > > > +			/*
> > > > +			 * Continue to iterate through each slab cache to free
> > > > +			 * as many nodelists as possible even though the
> > > > +			 * offline will be canceled.
> > > > +			 */
> > > > +			ret = -EBUSY;
> > > > +			continue;
> > > > +		}
> > > > +		kfree(l3);
> > > > +		cachep->nodelists[node] = NULL;
> > > 
> > > What's stopping races of other CPUs trying to access l3 and array
> > > caches while they're being freed?
> > > 
> > 
> > numa_node_id() will not return an offlined nodeid and cache_alloc_node() 
> > already does a fallback to other onlined nodes in case a nodeid is passed 
> > to kmalloc_node() that does not have a nodelist.  l3->shared and l3->alien 
> > cannot be accessed without l3->list_lock (drain, cache_alloc_refill, 
> > cache_flusharray) or cache_chain_mutex (kmem_cache_destroy, cache_reap).
> 
> Yeah, but can't it _have_ a nodelist (ie. before it is set to NULL here)
> while it is being accessed by another CPU and concurrently being freed
> on this one? 
> 

You're right, we can't free cachep->nodelists[node] for any node that is 
being hot-removed to avoid a race in cache_alloc_node().  I thought we had 
protection for this under cache_chain_mutex for most dereferences and 
could disregard cache_alloc_refill() because numa_node_id() would never 
return a node being removed under memory hotplug, that would be the 
responsibility of cpu hotplug instead (offline the cpu first, then ensure 
numa_node_id() can't return a node under hot-remove).

Thanks for pointing that out, it's definitely broken here.

As an alternative, I think we should do something like this on 
MEM_GOING_OFFLINE:

	int ret = 0;

	mutex_lock(&cache_chain_mutex);
	list_for_each_entry(cachep, &cache_chain, next) {
		struct kmem_list3 *l3;

		l3 = cachep->nodelists[node];
		if (!l3)
			continue;
		drain_freelist(cachep, l3, l3->free_objects);

		ret = list_empty(&l3->slabs_full) &&
		      list_empty(&l3->slabs_partial);
		if (ret)
			break;
	}
	mutex_unlock(&cache_chain_mutex);
	return ret ? NOTIFY_BAD : NOTIFY_OK;

to preempt hot-remove of a node where there are slabs on the partial or 
free list that can't be freed.

Then, for MEM_OFFLINE, we leave cachep->nodelists[node] to be valid in 
case there are cache_alloc_node() racers or the node ever comes back 
online; susbequent callers to kmalloc_node() for the offlined node would 
actually return objects from fallback_alloc() since kmem_getpages() would 
fail for a node without present pages.

If slab is allocated after the drain_freelist() above, we'll never 
actually get MEM_OFFLINE since all pages can't be isolated for memory 
hot-remove, thus, the node will never be offlined.  kmem_getpages() can't 
allocate isolated pages, so this race must happen after drain_freelist() 
and prior to the pageblock being isolated.

So the MEM_GOING_OFFLINE check above is really more of a convenience to 
short-circuit the hot-remove if we know we can't free all slab on that 
node to avoid all the subsequent work that would happen only to run into 
isolation failure later.

We don't need to do anything for MEM_CANCEL_OFFLINE since the only affect 
of MEM_GOING_OFFLINE is to drain the freelist.
