Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab2EDV6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:58:30 -0400
Received: from nm37-vm1.bullet.mail.ne1.yahoo.com ([98.138.229.129]:23038 "HELO
	nm37-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752129Ab2EDV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:58:28 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 17:58:27 EDT
X-Yahoo-Newman-Id: 471956.66667.bm@omp1006.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g_g5DCYVM1lLOfb9eBRTa8GqbzSKyvwxTu4AmohULmjU_Xv
 8SowIz8zNtaer2.2Mfy83y.abbOeoLt_78kNPddM2pPNCP6Qxm8Ao5j3neVw
 MgdlUUPlvFTIcHo1HxQqBy7X0o9mXT3VgGEeWXeoVW_PWGWOe2l6CHnFBjUO
 uPMm_b5S3zj.VqDzLF7JypR.K.pZBWoDJUOtgkh1tk2fip.vdsHC8DFLnKD7
 5bpCJj4q6rJz.4WDhAc1mHbXYjzZCTTmc4T9BvYVqfpZlr2n2RiGkSJZQsut
 q9Jbcyp2yzWrk45C6bVf2uDsObF9BOPKVso7zdoUjLlDcL4XHbEasX3hgXmg
 pYUMJCPvlU31vgKpWUrItQccb.u9j38ME20cSsuMEnRDCMRvApUGRMgI.l0H
 Om.FUmoj8UBDd3o0dRQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FA44F93.7090009@att.net>
Date: Fri, 04 May 2012 16:52:19 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: daniel.santos@pobox.com, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Generic rbtree search & insert cores
References: <4F9E7365.2040907@att.net> <1335871228.13683.141.camel@twins> <1335888000.13683.158.camel@twins>
In-Reply-To: <1335888000.13683.158.camel@twins>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After working with this a bit more and thinking about it more, I've come
to a few conclusions.  First off, my original approach (aside from not
supporting leftmost or duplicate keys) created an alternate paradigm
that I think you may have misunderstood (granted, it's lacking in some
areas).  The concept is a mechanism to interact with an rb-tree
interface where you directly "talk your types" and leave the details to
the interface.  That is, once you setup your struct rb_relationship, you
don't mess with the struct rb_node and struct rb_root members of your
structs again (in theory).  As long as everything goes well in the
compiler, all of the overhead for this abstraction is completely
compiled out.  Thus,

rbtree_insert(&my_container->some_objects, &my_object->rb_node, rel);

generates the exact same code as

rbtree_insert(my_container, my_object, rel);

where the initial section of rbtree_insert() contains this:

struct rb_root *root   = __rb_to_root(container, rel);
struct rb_node *node   = __rb_to_node(obj, rel);

Being that the root_offset and node_offset members are compile-time
constants and the _rb_to_xxx() static inlines simply do pointer
arithmetic.  Either way, the compiler must take the address of your
struct and perform an access with an offset.  So none of this should be
a performance issue. One serious flaw in my eyes is the lack of type
safety and the expectation of the implementor to pass the correct
types.  I've thought about this and I think it should be addressed with
a macro somehow.

But what the real issue here is interface.  My proposal isn't
consistient with the interface in rb_tree.h, I guess that's why I
thought to put it in a separate file and use a different function
prefix: rbtree_ instead of rb_.  However, I guess the real questions are:
* Can an interface be designed perfectly enough that users can perform
all functionality only passing pointers to their actual containers &
objects and still have zero overhead for doing so? (my proposal only
addresses part of it)
* Should an interface... ^^ (the above)?
* Is this a paradigm that can be accepted?

I don't consider myself a serious power C programmer, I'm mainly from
the OO, Java, C++, metaprogramming arena, which I'm sure is why I tend
to think in abstractions and figuring out what I can force the compiler
to do.  If you try to think in terms of databases, the struct
rb_relationship is like the DDL that describes the relationship &
constraints between two entities.  This is my updated struct to cover
leftmost & non-unique keys:

struct rb_relationship {
    size_t root_offset;
    size_t left_offset;
    size_t node_offset;
    size_t key_offset;
    long (*compare)(const void *a, const void *b);
    int unique;
};

Alternately, I can add this to rbtree.h and remove the
object-abstraction, using something similar to Peter's proposal (the
struct rb_relationship only specifies offsets from struct rb_node to the
key and struct rb_root to the "leftmost" pointer), but this means
abandoning a certain level of abstraction that may actually be good as
it removes a layer of details from the code that uses rbtrees, keeping
sources tidier and supporting encapsulation.

Daniel


On 05/01/2012 11:00 AM, Peter Zijlstra wrote:
>
> Something like the below,.. I wanted to add typechecking to
> __RB_RELS_KEY and __RB_RELS_LEFT like:
>
> #define __RB_RELS_KEY(_node_type, _node, _key) 				\
> 	(typecheck(struct rb_node *, &((_node_type *)NULL)->_node),	\
> 	 __REL_OFFSET(_node_type, _node, _key))
>
> #define __RB_RELS_LEFT(_root_type, _root, _left) 			\
> 	(typecheck(struct rb_root *, &((_root_type *)NULL)->_root),	\
> 	 typecheck(struct rb_node *, ((_root_type *)NULL)->_left),	\
> 	 __REL_OFFSET(_root_type, _root, _left))
>
> But I didn't find a way to make GCC like that.
>
> The below compiles, I haven't looked at the generated asm, nor booted
> the thing.
>
> ---
>  include/linux/rbtree.h |   84 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/fair.c    |   51 ++++++-----------------------
>  2 files changed, 93 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index 033b507..2a5f803 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -96,6 +96,8 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
>  
>  #include <linux/kernel.h>
>  #include <linux/stddef.h>
> +#include <linux/typecheck.h>
> +#include <linux/bug.h>
>  
>  struct rb_node
>  {
> @@ -174,4 +176,86 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
>  	*rb_link = node;
>  }
>  
> +struct rbtree_relations {
> +	size_t key_offset;
> +	size_t left_offset;
> +
> +	bool (*less)(const void *a, const void *b);
> +};
> +
> +#define __REL_OFFSET(_t, _f1, _f2) \
> +	(offsetof(_t, _f2) - offsetof(_t, _f1))
> +
> +#define __RB_RELS_KEY(_node_type, _node, _key) 				\
> +	__REL_OFFSET(_node_type, _node, _key)
> +
> +#define __RB_RELS_LEFT(_root_type, _root, _left) 			\
> +	__REL_OFFSET(_root_type, _root, _left)
> +
> +#define RB_RELATIONS(_node_type, _node, _key, _less) 			\
> +	(const struct rbtree_relations){				\
> +		.key_offset = __RB_RELS_KEY(_node_type, _node, _key),	\
> +		.less = (bool (*)(const void *, const void *))_less,	\
> +	}
> +
> +#define RB_RELATIONS_LEFT(_root_type, _root, _left, _node_type, _node, _key, _less) \
> +	(const struct rbtree_relations){				\
> +		.key_offset = __RB_RELS_KEY(_node_type, _node, _key),	\
> +		.left_offset = __RB_RELS_LEFT(_root_type, _root, _left), \
> +		.less = (bool (*)(const void *, const void *))_less,	\
> +	}
> +
> +static __always_inline 
> +const void *__rb_node_to_key(const struct rbtree_relations *rel, struct rb_node *node)
> +{
> +	BUILD_BUG_ON(!__builtin_constant_p(rel->key_offset));
> +	return (const void *)((char *)node + rel->key_offset);
> +}
> +
> +static __always_inline
> +struct rb_node **__rb_root_to_left(const struct rbtree_relations *rel, struct rb_root *root)
> +{
> +	BUILD_BUG_ON(!__builtin_constant_p(rel->left_offset));
> +	return (struct rb_node **)((char *)root + rel->left_offset);
> +}
> +
> +static __always_inline 
> +void rbtree_insert(struct rb_root *root, struct rb_node *node,
> +		   const struct rbtree_relations *rel)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node *parent = NULL;
> +	const void *key = __rb_node_to_key(rel, node);
> +	int leftmost = 1;
> +
> +	while (*p) {
> +		parent = *p;
> +		if (rel->less(key, __rb_node_to_key(rel, *p)))
> +			p = &(*p)->rb_left;
> +		else {
> +			p = &(*p)->rb_right;
> +			leftmost = 0;
> +		}
> +	}
> +
> +	if (rel->left_offset && leftmost)
> +		*__rb_root_to_left(rel, root) = node;
> +
> +	rb_link_node(node, parent, p);
> +	rb_insert_color(node, root);
> +}
> +
> +static __always_inline
> +void rbtree_remove(struct rb_root *root, struct rb_node *node,
> +		   const struct rbtree_relations *rel)
> +{
> +	if (rel->left_offset) {
> +		struct rb_node **left = __rb_root_to_left(rel, root);
> +		
> +		if (*left == node)
> +			*left = rb_next(node);
> +	}
> +	rb_erase(node, root);
> +}
> +
>  #endif	/* _LINUX_RBTREE_H */
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e955364..81424a9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -441,8 +441,8 @@ static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
>  	return min_vruntime;
>  }
>  
> -static inline int entity_before(struct sched_entity *a,
> -				struct sched_entity *b)
> +static inline bool entity_before(struct sched_entity *a,
> +				 struct sched_entity *b)
>  {
>  	return (s64)(a->vruntime - b->vruntime) < 0;
>  }
> @@ -472,55 +472,22 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
>  #endif
>  }
>  
> +static const struct rbtree_relations fair_tree_rels = 
> +	RB_RELATIONS_LEFT(struct cfs_rq, tasks_timeline, rb_leftmost,
> +			  struct sched_entity, run_node, vruntime,
> +			  entity_before);
> +
>  /*
>   * Enqueue an entity into the rb-tree:
>   */
>  static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
> -	struct rb_node *parent = NULL;
> -	struct sched_entity *entry;
> -	int leftmost = 1;
> -
> -	/*
> -	 * Find the right place in the rbtree:
> -	 */
> -	while (*link) {
> -		parent = *link;
> -		entry = rb_entry(parent, struct sched_entity, run_node);
> -		/*
> -		 * We dont care about collisions. Nodes with
> -		 * the same key stay together.
> -		 */
> -		if (entity_before(se, entry)) {
> -			link = &parent->rb_left;
> -		} else {
> -			link = &parent->rb_right;
> -			leftmost = 0;
> -		}
> -	}
> -
> -	/*
> -	 * Maintain a cache of leftmost tree entries (it is frequently
> -	 * used):
> -	 */
> -	if (leftmost)
> -		cfs_rq->rb_leftmost = &se->run_node;
> -
> -	rb_link_node(&se->run_node, parent, link);
> -	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
> +	rbtree_insert(&cfs_rq->tasks_timeline, &se->run_node, &fair_tree_rels);
>  }
>  
>  static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -	if (cfs_rq->rb_leftmost == &se->run_node) {
> -		struct rb_node *next_node;
> -
> -		next_node = rb_next(&se->run_node);
> -		cfs_rq->rb_leftmost = next_node;
> -	}
> -
> -	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
> +	rbtree_remove(&cfs_rq->tasks_timeline, &se->run_node, &fair_tree_rels);
>  }
>  
>  struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
>

