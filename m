Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2EBBGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:06:40 -0400
Received: from nm22.access.bullet.mail.mud.yahoo.com ([66.94.237.223]:44297
	"HELO nm22.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756003Ab2EBBGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:06:38 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2012 21:06:37 EDT
X-Yahoo-Newman-Id: 480128.64469.bm@smtp109.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8zWnFNQVM1ktUpX6bALAPnfHsGD8fwJKxeOH1MNTvhyQ7CN
 sSYNxOfGiA4hBR3cs6aEF2Qz_oNOLVRPw1S6ZTQ9mrv7A7yN9lxhHQSOn9bK
 02Z6n7VWjWT9DziTahyVmmDOgOKTnfGMKZiJE4rYu5h8oBRl1c58vq3rVyLr
 jzLuRFW4Pq6sz7AF015dXBm0KG4p1S7j4DEQANETO7iSCdFrutNwvmq4JBau
 v39HvYTaSVfmecvzG74dgfiVOFn0fcw89rjvU_BjSCRU_dWqyH7SGbNJvE5Y
 fSPVmtwCQCbEFHIx95v1cF2nkhpESLheXP6SlDAzDuslZHyxVjqsL_H5JHw3
 I4MGEfquJlCHs4rkki6c8a0tZLByfF5crBf4ZDVjXELX62YGlC1MSyym5Plp
 D82Z.4i2_BIieILdIh5fvvWWdKxr.JATXhAPXfaUSys8FQXnUdZPG.rsZS5A
 6usvniRvygw4S2IZb6Plaasb47Yuc5dk-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FA08753.8080300@att.net>
Date: Tue, 01 May 2012 20:01:07 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120420 Thunderbird/10.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Generic rbtree search & insert cores
References: <4F9E7365.2040907@att.net> <1335871228.13683.141.camel@twins> <1335888000.13683.158.camel@twins>
In-Reply-To: <1335888000.13683.158.camel@twins>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for examining this!  I don't see any major problems with omitting
the root node offset & accompanying mechanisms.  However, first consider
it's purpose: the idea is to define a relationship between two
structures and then call generic functions to manipulate them. Removing
the root node offset reduces the scope and complexity of the generic
rbtree interface, but also eliminates an abstraction mechanism, which
can be desirable at times. None the less, there are many cases where a
struct rb_root is used as a stand-alone variable, and even though it
could still be used by passing zero for the root_node offset, It would
appear to be chaff most (almost all?) of the time, so I can see that you
are right about this.

On to naming, I think it's probably better to prefix all of these
functions with "rb_" rather than "rbtree_" (as I had done), partially
for brevity, but mostly for consistency.

Next, is the issue of rather or not duplicate keys are allowed, which I
didn't think about when I wrote my code.  For my purposes, I cannot have
duplicate keys, so I coded it that way.  As I see it, the interface
should support both.  Again, I think it better to have a single inline
function that will support duplicate keys or not depending upon a
compile-time constant fed to it.  This adds complexity to the actual
insert function while reducing complexity in the interface (number of
functions) and sources.  As long as gcc behaves, the generated code will
be exactly what is needed and no more (else, we go with adding separate
insert functions for duplicate keys allowed and not).  On top of that, I
tried to leave it up to the caller as to rather or not they wanted their
"insert without duplicates" function to replace an object with a
matching key or not -- I guess some of this depends on what is needed,
but it would seem to make sense to leave that functionality in as well,
as long as it doesn't generated any extra instructions when it isn't needed.

Finally, as for augmented rbtrees, I'm not familiar with them, but I
just read an LWN article about them and they sound cool!  Not only that,
they sound like an excellent candidate for this type of genericizing. 
Had I known about them before, I would have used them in some other
(userspace) code where I'm using the linux rbtree implementation.  So
I'll play with this tomorrow.

As a side note, I had originally tried to combine the search & insert
implementation into a single function that expanded differently
depending upon how it was called (again, with compile-time constants)
but it became it too ugly, so I split it out.

Daniel
PS: the BUILD_BUG_ON macro is really cool, thanks for showing that to me!

On 05/01/2012 11:00 AM, Peter Zijlstra wrote:
> On Tue, 2012-05-01 at 13:20 +0200, Peter Zijlstra wrote:
>> On Mon, 2012-04-30 at 06:11 -0500, Daniel Santos wrote:
>>> So as long as our struct rbtree_relationship is a compile-time
>>> constant, the generated code will look pretty much (if not exactly)
>>> like that of the example code in rbtree.h.  Please let me know what
>>> you think.  I've tested this in a userspace program, but haven't fully
>>> stress tested it in kernelspace yet. 
>> Right, this ought to work.
>>
>> I'm not sure the root_offset thing is worth it though, passing in the
>> rb_root pointer isn't much of a hassle, in fact I'd expect to pass rb
>> related pointers to a function called rbtree_insert().
>>
>> Also, using a macro to create the rbtree_relationship thing would make
>> it easier. Something like:
>>
>> 	RB_RELATION(struct mouse, node, name, name_cmp);
>>
>> I'd think you'd also want to provide an insertion variant that does the
>> leftmost thing, that's used in several places, and you'd also need one
>> for the augmented rb-tree.
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Daniel

"Just because you go to church on Sunday, it doesn't absolve you from
where you put your dick during the week" -- Michele Q.

