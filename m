Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab2IOPOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 11:14:33 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50639 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750731Ab2IOPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 11:14:32 -0400
Date: Sat, 15 Sep 2012 11:14:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, David.Laight@ACULAB.COM, rmallon@gmail.com,
        palves@redhat.com
Subject: Re: [PATCH v5] hashtable: introduce a small and naive hashtable
Message-ID: <20120915151428.GA30459@Krystal>
References: <1347702798-19202-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347702798-19202-1-git-send-email-levinsasha928@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sasha Levin (levinsasha928@gmail.com) wrote:
> This hashtable implementation is using hlist buckets to provide a simple
> hashtable to prevent it from getting reimplemented all over the kernel.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
> 
> Changes from v4:
> 
>  - Addressed comments by Mathieu Desnoyers.
> 
>  include/linux/hashtable.h | 190 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 190 insertions(+)
>  create mode 100644 include/linux/hashtable.h
> 
> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
> new file mode 100644
> index 0000000..6d0c6c2
> --- /dev/null
> +++ b/include/linux/hashtable.h
> @@ -0,0 +1,190 @@
> +/*
> + * Hash table implementation
> + * (C) 2012  Sasha Levin <levinsasha928@gmail.com>
> + */
> +
> +#ifndef _LINUX_HASHTABLE_H
> +#define _LINUX_HASHTABLE_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/hash.h>
> +#include <linux/rculist.h>
> +
> +#define DEFINE_HASHTABLE(name, bits)						\
> +	struct hlist_head name[HASH_SIZE(bits)] =				\
> +			{ [0 ... HASH_SIZE(bits) - 1] = HLIST_HEAD_INIT }
> +
> +#define DECLARE_HASHTABLE(name, bits)                                   	\
> +	struct hlist_head name[1 << (bits)]
> +
> +#define HASH_SIZE(name) (1 << HASH_BITS(name))
> +#define HASH_BITS(name) ilog2(ARRAY_SIZE(name))
> +
> +/* Use hash_32 when possible to allow for fast 32bit hashing in 64bit kernels. */
> +#define hash_min(val, bits)							\
> +({										\
> +	sizeof(val) <= 4 ?							\
> +	hash_32(val, bits) :							\
> +	hash_long(val, bits);							\
> +})
> +
> +/**
> + * hash_init - initialize a hash table
> + * @hashtable: hashtable to be initialized
> + *
> + * Calculates the size of the hashtable from the given parameter, otherwise
> + * same as hash_init_size.
> + *
> + * This has to be a macro since HASH_BITS() will not work on pointers since
> + * it calculates the size during preprocessing.
> + */
> +#define hash_init(hashtable)							\
> +({										\
> +	int __i;								\
> +										\
> +	for (__i = 0; __i < HASH_BITS(hashtable); __i++)			\

I think this fails to initialize the whole table. You'd need

  HASH_BITS -> HASH_SIZE

Which brings the following question: how did you test this code ? It
would be nice to have a small test module along with this patchset that
stress-tests this simple hash table in various configurations (on stack,
in data, etc).

Also, I don't see how hash_init() can be useful, since DEFINE_HASHTABLE
already initialize the array entries. If it is for dynamically allocated
hash tables, this also won't work, considering the comment "This has to
be a macro since HASH_BITS() will not work on pointers since it
calculates the size during preprocessing."

> +		INIT_HLIST_HEAD(&hashtable[__i]);				\
> +})
> +
> +/**
> + * hash_add - add an object to a hashtable
> + * @hashtable: hashtable to add to
> + * @node: the &struct hlist_node of the object to be added
> + * @key: the key of the object to be added
> + */
> +#define hash_add(hashtable, node, key)						\
> +	hlist_add_head(node, &hashtable[hash_min(key, HASH_BITS(hashtable))]);
> +
> +/**
> + * hash_add_rcu - add an object to a rcu enabled hashtable
> + * @hashtable: hashtable to add to
> + * @node: the &struct hlist_node of the object to be added
> + * @key: the key of the object to be added
> + */
> +#define hash_add_rcu(hashtable, node, key)					\
> +	hlist_add_head_rcu(node, &hashtable[hash_min(key, HASH_BITS(hashtable))]);
> +
> +/**
> + * hash_hashed - check whether an object is in any hashtable
> + * @node: the &struct hlist_node of the object to be checked
> + */
> +#define hash_hashed(node) (!hlist_unhashed(node))
> +
> +/**
> + * hash_empty - check whether a hashtable is empty
> + * @hashtable: hashtable to check
> + *
> + * This has to be a macro since HASH_BITS() will not work on pointers since
> + * it calculates the size during preprocessing.

So I get that hash_empty is only expected to be used for statically
defined hash tables ? Does it support hash tables in dynamically
allocated memory ? On the stack ? If these are never expected to be
supported, this should be documented.

Thanks,

Mathieu

> + */
> +#define hash_empty(hashtable)							\
> +({										\
> +	int __i;								\
> +	bool __ret = true;							\
> +										\
> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> +		if (!hlist_empty(&hashtable[__i]))				\
> +			__ret = false;						\
> +										\
> +	__ret;									\
> +})
> +
> +/**
> + * hash_del - remove an object from a hashtable
> + * @node: &struct hlist_node of the object to remove
> + */
> +static inline void hash_del(struct hlist_node *node)
> +{
> +	hlist_del_init(node);
> +}
> +
> +/**
> + * hash_del_rcu - remove an object from a rcu enabled hashtable
> + * @node: &struct hlist_node of the object to remove
> + */
> +static inline void hash_del_rcu(struct hlist_node *node)
> +{
> +	hlist_del_init_rcu(node);
> +}
> +
> +/**
> + * hash_for_each - iterate over a hashtable
> + * @name: hashtable to iterate
> + * @bkt: integer to use as bucket loop cursor
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @obj: the type * to use as a loop cursor for each entry
> + * @member: the name of the hlist_node within the struct
> + */
> +#define hash_for_each(name, bkt, node, obj, member)				\
> +	for (bkt = 0, node = NULL; node == NULL && bkt < HASH_SIZE(name); bkt++)\
> +		hlist_for_each_entry(obj, node, &name[bkt], member)
> +
> +/**
> + * hash_for_each_rcu - iterate over a rcu enabled hashtable
> + * @name: hashtable to iterate
> + * @bkt: integer to use as bucket loop cursor
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @obj: the type * to use as a loop cursor for each entry
> + * @member: the name of the hlist_node within the struct
> + */
> +#define hash_for_each_rcu(name, bkt, node, obj, member)				\
> +	for (bkt = 0, node = NULL; node == NULL && bkt < HASH_SIZE(name); bkt++)\
> +		hlist_for_each_entry_rcu(obj, node, &name[bkt], member)
> +
> +/**
> + * hash_for_each_safe - iterate over a hashtable safe against removal of
> + * hash entry
> + * @name: hashtable to iterate
> + * @bkt: integer to use as bucket loop cursor
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @tmp: a &struct used for temporary storage
> + * @obj: the type * to use as a loop cursor for each entry
> + * @member: the name of the hlist_node within the struct
> + */
> +#define hash_for_each_safe(name, bkt, node, tmp, obj, member)			\
> +	for (bkt = 0, node = NULL; node == NULL && bkt < HASH_SIZE(name); bkt++)\
> +		hlist_for_each_entry_safe(obj, node, tmp, &name[bkt], member)
> +
> +/**
> + * hash_for_each_possible - iterate over all possible objects hashing to the
> + * same bucket
> + * @name: hashtable to iterate
> + * @obj: the type * to use as a loop cursor for each entry
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @member: the name of the hlist_node within the struct
> + * @key: the key of the objects to iterate over
> + */
> +#define hash_for_each_possible(name, obj, node, member, key)			\
> +	hlist_for_each_entry(obj, node,	&name[hash_min(key, HASH_BITS(name))], member)
> +
> +/**
> + * hash_for_each_possible_rcu - iterate over all possible objects hashing to the
> + * same bucket in an rcu enabled hashtable
> + * in a rcu enabled hashtable
> + * @name: hashtable to iterate
> + * @obj: the type * to use as a loop cursor for each entry
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @member: the name of the hlist_node within the struct
> + * @key: the key of the objects to iterate over
> + */
> +#define hash_for_each_possible_rcu(name, obj, node, member, key)		\
> +	hlist_for_each_entry_rcu(obj, node, &name[hash_min(key, HASH_BITS(name))], member)
> +
> +/**
> + * hash_for_each_possible_safe - iterate over all possible objects hashing to the
> + * same bucket safe against removals
> + * @name: hashtable to iterate
> + * @obj: the type * to use as a loop cursor for each entry
> + * @node: the &struct list_head to use as a loop cursor for each entry
> + * @tmp: a &struct used for temporary storage
> + * @member: the name of the hlist_node within the struct
> + * @key: the key of the objects to iterate over
> + */
> +#define hash_for_each_possible_safe(name, obj, node, tmp, member, key)		\
> +	hlist_for_each_entry_safe(obj, node, tmp,				\
> +		&name[hash_min(key, HASH_BITS(name))], member)
> +
> +
> +#endif
> -- 
> 1.7.12
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
