Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0F1Vhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:37:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57899 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab0F1Vhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:37:42 -0400
Date: Mon, 28 Jun 2010 14:37:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 01/52] kernel: add bl_list
Message-ID: <20100628213739.GF2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100624030212.676457061@suse.de>
 <20100624030725.718438579@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030725.718438579@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:13PM +1000, npiggin@suse.de wrote:
> Introduce a type of hlist that can support the use of the lowest bit in the
> hlist_head. This will be subsequently used to implement per-bucket bit spinlock
> for inode and dentry hashes.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Looks good!  One question on non-RCU pointer poisoning and a typo.
When these are addressed (perhaps by showing me the error of my ways):

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/list_bl.h    |   99 +++++++++++++++++++++++++++++++++++++
>  include/linux/rculist_bl.h |  120 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 219 insertions(+)
> 
> Index: linux-2.6/include/linux/list_bl.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/list_bl.h
> @@ -0,0 +1,99 @@
> +#ifndef _LINUX_LIST_BL_H
> +#define _LINUX_LIST_BL_H
> +
> +#include <linux/list.h>
> +
> +/*
> + * Special version of lists, where head of the list has a bit spinlock
> + * in the lowest bit. This is useful for scalable hash tables without
> + * increasing memory footprint overhead.
> + */
> +
> +struct hlist_bl_head {
> +	struct hlist_bl_node *first;
> +};
> +
> +struct hlist_bl_node {
> +	struct hlist_bl_node *next, **pprev;
> +};
> +#define INIT_HLIST_BL_HEAD(ptr) \
> +	((ptr)->first = NULL)
> +
> +static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
> +{
> +	h->next = NULL;
> +	h->pprev = NULL;
> +}
> +
> +#define hlist_bl_entry(ptr, type, member) container_of(ptr,type,member)
> +
> +static inline int hlist_bl_unhashed(const struct hlist_bl_node *h)
> +{
> +	return !h->pprev;
> +}
> +
> +static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
> +{
> +	return (struct hlist_bl_node *)((unsigned long)h->first & ~1UL);
> +}
> +
> +static inline void hlist_bl_set_first(struct hlist_bl_head *h, struct hlist_bl_node *n)
> +{
> +	h->first = (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL));
> +}
> +
> +static inline int hlist_bl_empty(const struct hlist_bl_head *h)
> +{
> +	return !((unsigned long)h->first & ~1UL);
> +}
> +
> +static inline void hlist_bl_add_head(struct hlist_bl_node *n,
> +					struct hlist_bl_head *h)
> +{
> +	struct hlist_bl_node *first = hlist_bl_first(h);
> +
> +	n->next = first;
> +	if (first)
> +		first->pprev = &n->next;
> +	n->pprev = &h->first;
> +	hlist_bl_set_first(h, n);
> +}
> +
> +static inline void __hlist_bl_del(struct hlist_bl_node *n)
> +{
> +	struct hlist_bl_node *next = n->next;
> +	struct hlist_bl_node **pprev = n->pprev;
> +	*pprev = (struct hlist_bl_node *)((unsigned long)next | ((unsigned long)*pprev & 1UL));
> +	if (next)
> +		next->pprev = pprev;
> +}
> +
> +static inline void hlist_bl_del(struct hlist_bl_node *n)
> +{
> +	__hlist_bl_del(n);
> +	n->pprev = LIST_POISON2;

OK, I'll bite...  Why don't we poison the ->next pointer?

> +}
> +
> +static inline void hlist_bl_del_init(struct hlist_bl_node *n)
> +{
> +	if (!hlist_bl_unhashed(n)) {
> +		__hlist_bl_del(n);
> +		INIT_HLIST_BL_NODE(n);
> +	}
> +}
> +
> +/**
> + * hlist_bl_for_each_entry	- iterate over list of given type
> + * @tpos:	the type * to use as a loop cursor.
> + * @pos:	the &struct hlist_node to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the hlist_node within the struct.
> + *
> + */
> +#define hlist_bl_for_each_entry(tpos, pos, head, member)			\
> +	for (pos = hlist_bl_first(head);					\
> +	     pos &&								\
> +		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1;});	\
> +	     pos = pos->next)
> +
> +#endif
> Index: linux-2.6/include/linux/rculist_bl.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/rculist_bl.h
> @@ -0,0 +1,120 @@
> +#ifndef _LINUX_RCULIST_BL_H
> +#define _LINUX_RCULIST_BL_H
> +
> +#ifdef __KERNEL__
> +
> +/*
> + * RCU-protected list version
> + */
> +#include <linux/list_bl.h>
> +#include <linux/rcupdate.h>
> +
> +static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h, struct hlist_bl_node *n)
> +{
> +	rcu_assign_pointer(h->first, (struct hlist_bl_node *)((unsigned long)n | ((unsigned long)h->first & 1UL)));
> +}
> +
> +static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
> +{
> +	return (struct hlist_bl_node *)((unsigned long)rcu_dereference(h->first) & ~1UL);
> +}
> +
> +/**
> + * hlist_bl_del_init_rcu - deletes entry from hash list with re-initialization
> + * @n: the element to delete from the hash list.
> + *
> + * Note: hlist_bl_unhashed() on the node return true after this. It is
                                            returns

> + * useful for RCU based read lockfree traversal if the writer side
> + * must know if the list entry is still hashed or already unhashed.
> + *
> + * In particular, it means that we can not poison the forward pointers
> + * that may still be used for walking the hash list and we can only
> + * zero the pprev pointer so list_unhashed() will return true after
> + * this.
> + *
> + * The caller must take whatever precautions are necessary (such as
> + * holding appropriate locks) to avoid racing with another
> + * list-mutation primitive, such as hlist_bl_add_head_rcu() or
> + * hlist_bl_del_rcu(), running on this same list.  However, it is
> + * perfectly legal to run concurrently with the _rcu list-traversal
> + * primitives, such as hlist_bl_for_each_entry_rcu().
> + */
> +static inline void hlist_bl_del_init_rcu(struct hlist_bl_node *n)
> +{
> +	if (!hlist_bl_unhashed(n)) {
> +		__hlist_bl_del(n);
> +		n->pprev = NULL;
> +	}
> +}
> +
> +/**
> + * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
> + * @n: the element to delete from the hash list.
> + *
> + * Note: hlist_bl_unhashed() on entry does not return true after this,
> + * the entry is in an undefined state. It is useful for RCU based
> + * lockfree traversal.
> + *
> + * In particular, it means that we can not poison the forward
> + * pointers that may still be used for walking the hash list.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
> + * or hlist_bl_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * hlist_bl_for_each_entry().
> + */
> +static inline void hlist_bl_del_rcu(struct hlist_bl_node *n)
> +{
> +	__hlist_bl_del(n);
> +	n->pprev = LIST_POISON2;
> +}
> +
> +/**
> + * hlist_bl_add_head_rcu
> + * @n: the element to add to the hash list.
> + * @h: the list to add to.
> + *
> + * Description:
> + * Adds the specified element to the specified hlist_bl,
> + * while permitting racing traversals.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
> + * or hlist_bl_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * hlist_bl_for_each_entry_rcu(), used to prevent memory-consistency
> + * problems on Alpha CPUs.  Regardless of the type of CPU, the
> + * list-traversal primitive must be guarded by rcu_read_lock().
> + */
> +static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
> +					struct hlist_bl_head *h)
> +{
> +	struct hlist_bl_node *first = hlist_bl_first(h);
> +
> +	n->next = first;
> +	if (first)
> +		first->pprev = &n->next;
> +	n->pprev = &h->first;
> +	hlist_bl_set_first_rcu(h, n);
> +}
> +/**
> + * hlist_bl_for_each_entry_rcu - iterate over rcu list of given type
> + * @tpos:	the type * to use as a loop cursor.
> + * @pos:	the &struct hlist_bl_node to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the hlist_bl_node within the struct.
> + *
> + */
> +#define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)			\
> +	for (pos = hlist_bl_first_rcu(head);					\
> +		pos &&								\
> +		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; });	\
> +		pos = rcu_dereference_raw(pos->next))
> +
> +#endif
> +#endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
