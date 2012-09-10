Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2IJCsT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:48:19 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46156 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754427Ab2IJCsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:48:17 -0400
Date: Sun, 9 Sep 2012 22:48:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, ebiederm@xmission.com, josh@joshtriplett.org,
        David.Laight@ACULAB.COM, palves@redhat.com, rmallon@gmail.com,
        bfields@fieldses.org
Subject: Re: [PATCH v4] hashtable: introduce a small and naive hashtable
Message-ID: <20120910024813.GA32008@Krystal>
References: <1347195123-5210-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347195123-5210-1-git-send-email-levinsasha928@gmail.com>
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
> I'll send just the hashtable patch itself to avoid spamming a bunch of people until
> it's stable again.
> 
>  include/linux/hashtable.h | 183 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
>  create mode 100644 include/linux/hashtable.h
> 
> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
> new file mode 100644
> index 0000000..2d2fd14
> --- /dev/null
> +++ b/include/linux/hashtable.h
> @@ -0,0 +1,183 @@
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
> +			{ [0 ... HASH_SIZE(bits) - 1] = HLIST_HEAD_INIT };

I think the final ";" should not be here.

> +
> +#define DECLARE_HASHTABLE(name, bits)                                   	\
> +	struct hlist_head name[1 << bits];

Is the operator priority always OK here, or should we put bits between
parenthesis ?

The final ";" should not be here.

> +
> +#define HASH_SIZE(name) (1 << (HASH_BITS(name)))

Parenthesis around HASH_BITS(name) seem useless.

> +#define HASH_BITS(name) (ilog2(ARRAY_SIZE(name)))

Parenthesis around ilog2(ARRAY_SIZE(name)) seem useless too.

> +
> +/* Use hash_32 when possible to allow for fast 32bit hashing in 64bit kernels. */
> +#define hash_min(val, bits) ({							\

hash_init has a newline before ({, but not here. Please use a consistent
style.

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
> + */
> +#define hash_init(hashtable)							\
> +({										\
> +	int __i;								\
> +										\
> +	for (__i = 0; __i < HASH_BITS(hashtable); __i++)			\
> +		INIT_HLIST_HEAD(hashtable + __i);				\

I suspect that hashtable will be a pointer, and you use the "+" operator
to do an offset on this pointer. Any thought on using:

            INIT_HLIST_HEAD(&hashtable[__i]);

instead ? It would provide the same result, but would ensure that the
user is indeed passing a pointer, and not an integer.

Also, why isn't it a static inline ? I'm probably missing something. If
there is a reason why it needs to stay a #define, please document it in
the comment.

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

Same question here about static inline instead of #define ?

Thanks,

Mathieu

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
