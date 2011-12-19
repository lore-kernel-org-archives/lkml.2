Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1LSUNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:13:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36060 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1LSUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:13:51 -0500
Date: Mon, 19 Dec 2011 12:13:36 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Nai Xia <nai.xia@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree: take radix_tree_path off stack
In-Reply-To: <CAPQyPG7MQPmekvXZdMTQ9Z=4HqPfG3xQbjstO2e_hatSYSyV4w@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1112191145310.3639@eggly.anvils>
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils> <4EEEF3B3.909@gmail.com> <CAPQyPG7MQPmekvXZdMTQ9Z=4HqPfG3xQbjstO2e_hatSYSyV4w@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Nai Xia wrote:
> On Mon, Dec 19, 2011 at 4:20 PM, nai.xia <nai.xia@gmail.com> wrote:
> >
> > Can rcu_head in someway unionized with radix_tree_node->height
> > and radix_tree_node->count? count is always referenced under lock
> > and only the first node's height is referenced during lookup.
> > Seems like if we atomically set root->rnode to NULL, before
> > freeing the last node, we can ensure a valid read of the
> > radix_tree_node->height when lookup by following it with
> > a root->rnode == NULL test.
> >
> > I am not very sure of course, just a naive feeling.

I think you are right about radix_tree_node->count (only used under
lock, of no interest when lockless), but I'm not so sure about
radix_tree_node->height.

If you're right, then radix_tree_node->height shouldn't be needed
at all, we could work from radix_tree_root->height throughout.
And many places do so, but lockless (rcu locked) ones are relying
on radix_tree_node->height.

Caution tells me that it's intimately a part of the way we can
safely look up locklessly while the tree is being expanded or shrunk:
notice how a node never changes its height.  But perhaps it could be
reduced to a flag bit, saying whether node is a leafnode or not.

But I wouldn't risk making any such change without spending time to
think it through, time I must spend on other tasks now.  Please play
with it yourself if you've a mind to.

> 
> And besides, I think maybe there were another few ways if
> we really care about the stack usage of radix_tree_path,
> e.g.
> 1. We can make radix_tree_path.offset compact to u8
> which is enough to index inside a node.

Well, I could have halved the usage with a patch just recalculating
the offset when ascending; but I'd rather get rid of the whole array.

> 
> 2. We can use dynamic array on stack instead of
> RADIX_TREE_MAX_PATH, I think for most cases
> this may save half of the space

tag_if_tagged() was using a dynamic array on stack: that came as a
surprise to me, we usually forbid that in kernel.  It becomes hard
to estimate stack usage, so may cause nasty surprises in rare cases.

> 
> 3. Take benefit of radix_tree_path array already
> traveled down to clear the tags instead of calling
> a radix_tree_tag_clear with full array.

There must be a more efficient way of doing that, yes; but it's such a
very rare path that it's not worth extra code, I just added the comment
"This way of doing it would be inefficient, but seldom is any set".

> 
> I am not speaking of the negatives of your patch
> , just some alternatives for your reference.
> 
> And forgive my possible selfishness, I just created a home
> made radix tree traveler based on radix_tree_path array to
> simulate recursive calls, not ready to its vanishing...

I did remove
struct radix_tree_path {
	struct radix_tree_node *node;
	int offset;
};
but it's easy enough for you to add back if you have good use for it.

Hugh
