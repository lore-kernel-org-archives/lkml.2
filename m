Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2F0NAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:00:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2F0NAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:00:46 -0400
Message-ID: <1340802008.10063.63.camel@twins>
Subject: Re: [PATCH v4 11/13] rbtree.h: Generic Red-Black Trees
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 27 Jun 2012 15:00:08 +0200
In-Reply-To: <1340424048-7759-12-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
	 <1340424048-7759-12-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 23:00 -0500, Daniel Santos wrote:

> +typedef long (*rb_compare_f)(const void *a, const void *b);

> +struct rb_relationship {
> +	ssize_t root_offset;
> +	ssize_t left_offset;
> +	ssize_t right_offset;
> +	ssize_t count_offset;
> +	ssize_t node_offset;
> +	ssize_t key_offset;
> +	int flags;
> +	const rb_compare_f compare;
> +	const rb_augment_f augment;
> +};

> +static __always_inline __flatten
> +struct rb_node *__rb_find(
> +		struct rb_node *node,
> +		const void *key,
> +		const struct rb_relationship *rel)
> +{
> +	__rb_assert_good_rel(rel);
> +	while (node) {
> +		long diff = rel->compare(key, __rb_node_to_key(node, rel));
> +
> +		if (diff > 0)
> +			node = node->rb_right;
> +		else if (diff < 0)
> +			node = node->rb_left;
> +		else
> +			return node;
> +	}
> +
> +	return 0;
> +}

> +#define RB_RELATIONSHIP(						\
> +		cont_type, root, left, right, count,			\
> +		obj_type, node, key,					\
> +		_flags, _compare, _augment) {				\
> +	.root_offset     = offsetof(cont_type, root),			\
> +	.left_offset     = OPT_OFFSETOF(cont_type, left),		\
> +	.right_offset    = OPT_OFFSETOF(cont_type, right),		\
> +	.count_offset    = OPT_OFFSETOF(cont_type, count),		\
> +	.node_offset     = offsetof(obj_type, node),			\
> +	.key_offset      = offsetof(obj_type, key),			\
> +	.flags           = (_flags)					\
> +			 | IFF_EMPTY(left ,    0,  RB_HAS_LEFTMOST)	\
> +			 | IFF_EMPTY(right,    0,  RB_HAS_RIGHTMOST)	\
> +			 | IFF_EMPTY(count,    0,  RB_HAS_COUNT)	\
> +			 | IFF_EMPTY(_augment, 0,  RB_IS_AUGMENTED),	\
> +	.compare         = (const rb_compare_f) (_compare),		\
> +	.augment         = IFF_EMPTY(_augment, 0, _augment)		\
> +}

> +#define RB_DEFINE_INTERFACE(						\
> +	prefix,								\
> +	cont_type, root, left, right, count,				\
> +	obj_type, node, key,						\
> +	flags, compare, augment,					\
> +	find_mod, insert_mod, find_near_mod, insert_near_mod)		\
> +									\
> 									\
> +static const struct rb_relationship prefix ## _rel =			\
> +RB_RELATIONSHIP(							\
> +	cont_type, root, left, right, count,				\
> +	obj_type, node, key,						\
> +	flags, compare, augment);					\
> +									\
> +IFF_EMPTY(find_mod, static __always_inline, find_mod)			\
> +obj_type *prefix ## _find(cont_type *cont,				\
> +			  const typeof(((obj_type *)0)->key) *_key)	\
> +{									\
> +	struct rb_node *ret = rb_find(					\
> +			&cont->root, _key, &prefix ## _rel);		\
> +	return ret ? rb_entry(ret, obj_type, node) : 0;			\
> +}									\


So the one thing I noticed was your 'fixed' long return type for
compare. I guess that's one of the things that inspired your CFS compare
'hack' since on 32bit that's too short.

I tried playing with typeof() and return types of function pointers, but
I couldn't make it work. Bummer. That leaves explicitly passing it to
the RB_DEFINE_INTERFACE() and pulling all relevant inline functions into
the macro as well.


