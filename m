Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0HSN0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:26:08 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:54353 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751873Ab0HSN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:26:07 -0400
Date: Thu, 19 Aug 2010 23:25:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        npiggin@kernel.dk, a.p.zijlstra@chello.nl
Subject: Re: [bug] radix_tree_gang_lookup_tag_slot() looping endlessly
Message-ID: <20100819132552.GU10429@dastard>
References: <20100818135651.GK7362@dastard>
 <20100818173708.GB15010@quack.suse.cz>
 <20100818232917.GN7362@dastard>
 <20100819072520.GR7362@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819072520.GR7362@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 05:25:20PM +1000, Dave Chinner wrote:
> On Thu, Aug 19, 2010 at 09:29:17AM +1000, Dave Chinner wrote:
> > On Wed, Aug 18, 2010 at 07:37:09PM +0200, Jan Kara wrote:
> > >   Hi,
> > > 
> > > On Wed 18-08-10 23:56:51, Dave Chinner wrote:
> > > > I'm seeing a livelock with the new writeback sync livelock avoidance
> > > > code. The problem is that the radix tree lookup via
> > > > pagevec_lookup_tag()->find_get_pages_tag() is getting stuck in
> > > > radix_tree_gang_lookup_tag_slot() and never exitting.
> 
> [snip]
> 
> > 
> > > Hmm,
> > > looking at the code maybe what you describe could happen if we remove the
> > > page from page cache but leave a dangling tag in the radix tree... But
> > > remove_from_page_cache() is called with tree_lock held and it removes all
> > > tags from the index we just remove so it shouldn't really happen.
> > 
> > This might be a stupid question, but here goes anyway. I know the
> > slot contents are protected on lookup by rcu_read_lock() and
> > rcu_dereference_raw(), but what protects the tags on read? AFAICT,
> > they are being looked up without any locking, memory barriers, etc
> > w.r.t. deletion. i.e. I cannot see how a tag lookup is prevented
> > from racing with the propagation of a tag removal back up the tree
> > (which is done under the tree lock). What am I missing?
> 
> Definitely looks like corrupted tags:
> 
> [   97.301618] lookup ino 9283137, size 2106992, mapping pages 146, root 0xffff880073d83e20, index 497, nr_pages 14, tag 1
> [   97.301711] lookup ino 9283137, size 2106992, mapping pages 9, root 0xffff880073d83e20, index 75, nr_pages 14, tag 2
> [   97.301713] livelock @ root 0xffff880073d83e20, index 256, first 75
> [   97.301715] height 2
> [   97.301716] shift 6
> [   97.301717] tag_get 0xffff8800769f5b40, 4
> [   97.301718] height 1
> [   97.301719] shift 0
> [   97.301720] no more slots 4
> [   97.301721] livelock @ root 0xffff880073d83e20, index 256, first 75
> 
> The slot (#4) has the tag set, but the actual slot is empty and so
> the lookup aborts without changing the index, and as such we have an
> endless loop. In this case, it apears to have occurred directly
> after the mapping was almost entirely invalidated....

And it look slike the corrupted tags are coming through
radix_tree_set_tag_if_tagged:

[   29.533595] tag @ root 0xffff880078088d60, pages 261 (466 -> 472), nr 0
[   29.534410] settag root @ 0xffff880078088d60, index 466, offset 7, height 2, shift 6
[   29.535331] slot[settag] 0x80 iftag 0x88
[   29.535805] leveldown root @ 0xffff880078088d60, index 466, offset 7, height 1, shift 0
[   29.536842] tag @ root 0xffff880078088d60, pages 261 (473 -> 472), nr 0
                                                         ^^^^^^^^^^   ^^^^

Here we've tried to set the tags on the index 462 -> 472, but we have scanned
to index 472 and not set any tags on pages. *However*, because
radix_tree_set_tag_if_tagged() does a top-down traversal it has set the
tag on the parent node before checking if any of the child nodes can
have the tag set.

hence when radix_tree_gang_lookup_tag_slot() comes along:

[   29.543718] lookup ino 4452983, size 1453202, mapping pages 256, root 0xffff880078088d60, index 502, nr_pages 14, tag 2
[   29.545015] livelock @ root 0xffff880078088d60, index 502, first 502
[   29.545785] height 2
[   29.546117] shift 6
[   29.546381] tag_get 0xffff880078040d70, 7
                                           ^
The parent node has the tag set for slot 7

[   29.546862] slot[tag] 0x80
[   29.547192] height 1
[   29.547461] shift 0
[   29.547721] no more slots 7

but slot 7 has no children. Because the children didn't have the
TO_WRITE tag set, the tags ont eh parent node never got removed.
Hence we get a livelock because whenever this bad tag is encountered
we abort without increasing the start index, so we re-enter and
traverse exactly the sae path again....

[   29.548090] livelock @ root 0xffff880078088d60, index 502, first 502

It looks to me like radix_tree_set_tag_if_tagged() is fundamentally
broken.  All the tag set/clear code stores the tree path in a cursor
and uses that to propagate the tags if and only if the full path
from root to leaf is resolved. radix_tree_set_tag_if_tagged() sets
tags on intermediate nodes before it has resolved the full path and
hence can set tags when it should not. The "should not" cases occur
when we have to tag sub-ranges or the scan aborts because it's
reached the number ot tag in a batch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
