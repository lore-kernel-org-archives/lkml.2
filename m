Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0IQNOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:14:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45265 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab0IQNOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:14:22 -0400
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        ext-phil.2.carmody@nokia.com, linux-omap@vger.kernel.org
In-Reply-To: <20100830203037.GJ2420@linux.vnet.ibm.com>
References: <1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
	 <20100629.074423.71111160.Hiroshi.DOYU@nokia.com>
	 <20100810.184903.214240645.Hiroshi.DOYU@nokia.com>
	 <20100827.091224.226795338.Hiroshi.DOYU@nokia.com>
	 <20100830203037.GJ2420@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 17 Sep 2010 14:14:15 +0100
Message-ID: <1284729255.26542.39.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2010 13:14:16.0312 (UTC) FILETIME=[3ACB5F80:01CB566A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 13:30 -0700, Paul E. McKenney wrote:
> On Fri, Aug 27, 2010 at 09:12:24AM +0300, Hiroshi DOYU wrote:
> > > +static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
> > > +{
> > > +	struct kmemleak_object *object;
> > > +
> > > +	rcu_read_lock();
> > > +	object = __find_and_get_object(ptr, alias);
> > > +	rcu_read_unlock();
> > > +
> > > +	return object;
> > > +}
> > > +
> > > +static struct kmemleak_object *__find_and_get_alias(unsigned long ptr, int alias)
> > > +{
> > > +	struct kmemleak_object *object = NULL;
> > > +	struct kmemleak_alias *ao = NULL;
> > > +	struct prio_tree_node *node;
> > > +	struct prio_tree_iter iter;
> > > +	unsigned long flags;
> > > +
> > > +	read_lock_irqsave(&kmemleak_lock, flags);
> 
> If we hold this readlock, how is RCU helping us?  Or are there updates
> that do not write-hold kmemleak_lock?

These kind of constructs are already in the existing kmemleak code.
Kmemleak uses the slab allocator itself but it also gets called from the
slab allocator for other memory allocation/freeing. To avoid a race on
the kfree path, kmemleak objects are freed later via he RCU.

The read_lock is used for the prio_tree access/modifications but the
rcu_lock protects an additional get_object() call.

> > > +	prio_tree_iter_init(&iter, &alias_tree_root, ptr, ptr);
> > > +	node = prio_tree_next(&iter);
> > > +	if (node) {
> > > +		ao = prio_tree_entry(node, struct kmemleak_alias, tree_node);
> > > +		if (!alias && to_address(ao) != ptr) {
> > > +			kmemleak_warn("Found object by alias");
> > > +			ao = NULL;
> > > +		}
> > > +	}
> > > +
> > > +	read_unlock_irqrestore(&kmemleak_lock, flags);
> > > +
> > > +	if (ao && get_object(ao->object))
> > > +		object = ao->object;
> > > +
> > > +	return object;
> > > +}
[...]
> > > +static void __delete_alias_object(struct kmemleak_object *object)
> > > +{
> > > +	prio_tree_remove(&alias_tree_root, &object->alias->tree_node);
> > > +	list_del_rcu(&object->alias->alias_list);
> 
> Don't we need an RCU grace period here, based on either synchronize_rcu()
> or call_rcu()?  Perhaps calling free_object_rcu(), though perhaps it frees
> up more than you would like.

You may be right here. The kmemleak objects (not the aliases introduced
by this patch) are freed later by the put_object() call via a
call_rcu().

Anyway, I don't think its worth pursuing this approach for handling
address aliases (e.g. virt_to_phys) because of the performance hit
Hiroshi is seeing.

-- 
Catalin

