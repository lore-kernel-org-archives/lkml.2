Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2HFPjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:39:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:60109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2HFPjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:39:09 -0400
Message-ID: <1344267537.27828.93.camel@twins>
Subject: Re: [PATCH v2 8/9] rbtree: faster augmented rbtree manipulation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Mon, 06 Aug 2012 17:38:57 +0200
In-Reply-To: <1344262669.27828.55.camel@twins>
References: <1343946858-8170-1-git-send-email-walken@google.com>
	 <1343946858-8170-9-git-send-email-walken@google.com>
	 <1344262669.27828.55.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 16:17 +0200, Peter Zijlstra wrote:

> Why would every user need to replicate the propagate and rotate
> boilerplate?

So I don't have a tree near that any of this applies to (hence no actual
patch), but why can't we have something like:

struct rb_augment_callback {
	const bool (*update)(struct rb_node *node);
	const int offset;
	const int size;
};

#define RB_AUGMENT_CALLBACK(_update, _type, _rb_member, _aug_member)	\
(struct rb_augment_callback){						\
	.update = _update,						\
	.offset = offsetof(_type, _aug_member) - 			\
		  offsetof(_type, _rb_member),				\
	.size   = sizeof(((_type *)NULL)->_aug_member),			\
}

static __always_inline void 
augment_copy(struct rb_node *dst, struct rb_node *src,
	     const rb_augment_callback *ac)
{
	memcpy((void *)dst + ac->offset,
	       (void *)src + ac->offset,
	       ac->size);
} 

static __always_inline void 
augment_propagate(struct rb_node *rb, struct rb_node *stop,
		  const struct rb_augment_callback *ac)
{
	while (rb != stop) {
		if (!ac->update(rb))
			break;
		rb = rb_parent(rb);
	}
}

static __always_inline void
augment_rotate(struct rb_node *old, struct rb_node *new.
	       const struct rb_augment_callback *ac)
{
	augment_copy(new, old, ac);
	(void)ac->update(old);
}


