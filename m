Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0LOWFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:05:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0LOWFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:05:05 -0500
Date: Wed, 15 Dec 2010 17:04:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling
 with CFQ queue and group at the same level
Message-ID: <20101215220453.GA11382@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057A9D.1090809@cn.fujitsu.com>
 <20101214034914.GA8713@redhat.com>
 <4D08680C.5000905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D08680C.5000905@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 03:02:36PM +0800, Gui Jianfeng wrote:
[..]
> >>  static inline unsigned
> >>  cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >>  {
> >> -	struct cfq_rb_root *st = &cfqd->grp_service_tree;
> >>  	struct cfq_entity *cfqe = &cfqg->cfqe;
> >> +	struct cfq_rb_root *st = cfqe->service_tree;
> >>  
> >> -	return cfq_target_latency * cfqe->weight / st->total_weight;
> >> +	if (st)
> >> +		return cfq_target_latency * cfqe->weight
> >> +			/ st->total_weight;
> > 
> > Is it still true in hierarchical mode. Previously group used to be
> > at the top and there used to be only one service tree for groups so
> > st->total_weight represented total weight in the system.
> >  
> > Now with hierarhcy this will not/should not be true. So a group slice
> > calculation should be different?
> 
> I just keep the original group slice calculation here. I was thinking that
> calculate group slice in a hierachical way, this might get a really small
> group slice and not sure how it works. So I just keep the original calculation.
> Any thoughts?

Corrado already had minimum per queue limits (16ms or something) so don't
worry about it getting too small. But we have to do hierarchical groups
share calculation otherwise what's the point of writting this code and
all the logic of trying to meet soft latency of 300ms.

> 

> > 
> >> +	else
> >> +		/* If this is the root group, give it a full slice. */
> >> +		return cfq_target_latency;
> >>  }
> >>  
> >>  static inline void
> >> @@ -804,17 +809,6 @@ static struct cfq_entity *cfq_rb_first(struct cfq_rb_root *root)
> >>  	return NULL;
> >>  }
> >>  
> >> -static struct cfq_entity *cfq_rb_first_entity(struct cfq_rb_root *root)
> >> -{
> >> -	if (!root->left)
> >> -		root->left = rb_first(&root->rb);
> >> -
> >> -	if (root->left)
> >> -		return rb_entry_entity(root->left);
> >> -
> >> -	return NULL;
> >> -}
> >> -
> >>  static void rb_erase_init(struct rb_node *n, struct rb_root *root)
> >>  {
> >>  	rb_erase(n, root);
> >> @@ -888,12 +882,15 @@ __cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> >>  
> >>  	rb_link_node(&cfqe->rb_node, parent, node);
> >>  	rb_insert_color(&cfqe->rb_node, &st->rb);
> >> +
> >> +	update_min_vdisktime(st);
> >>  }
> >>  
> >>  static void
> >>  cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> >>  {
> >>  	__cfq_entity_service_tree_add(st, cfqe);
> >> +	cfqe->reposition_time = jiffies;
> >>  	st->count++;
> >>  	st->total_weight += cfqe->weight;
> >>  }
> >> @@ -901,34 +898,57 @@ cfq_entity_service_tree_add(struct cfq_rb_root *st, struct cfq_entity *cfqe)
> >>  static void
> >>  cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
> >>  {
> >> -	struct cfq_rb_root *st = &cfqd->grp_service_tree;
> >>  	struct cfq_entity *cfqe = &cfqg->cfqe;
> >> -	struct cfq_entity *__cfqe;
> >>  	struct rb_node *n;
> >> +	struct cfq_entity *entity;
> >> +	struct cfq_rb_root *st;
> >> +	struct cfq_group *__cfqg;
> >>  
> >>  	cfqg->nr_cfqq++;
> >> +
> >> +	/*
> >> +	 * Root group doesn't belongs to any service
> >> +	 */
> >> +	if (cfqg == &cfqd->root_group)
> >> +		return;
> > 
> > Can we keep root group on cfqd->grp_service_tree?  In hierarchical mode
> > there will be only 1 group on grp service tree and in flat mode there
> > can be many.
> 
> Keep top service tree different for hierarchical mode and flat mode is just
> fine to me. If you don't strongly object, I'd to keep the current way. :)

I am saying that keep one top tree both for hierarchical and flat mode and
not separate trees.

for flat mode everything goes on cfqd->grp_service_tree.

			grp_service_tree
			  /  |     \
		       root test1  test2

for hierarchical mode it will look as follows.

			grp_service_tree
			  	|	
		       	       root
				/ \
			     test1 test2

Or it could looks as follows if user has set use_hier=1 in test2 only.

			grp_service_tree
			 |     |      | 
		       	 root  test1  test2
					|
				      test3

Thanks
Vivek
