Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1LUXzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:55:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1LUXzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:55:32 -0500
Date: Wed, 21 Dec 2011 15:55:30 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Chinner <david@fromorbit.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree: take radix_tree_path off stack
In-Reply-To: <20111221221527.GE23662@dastard>
Message-ID: <alpine.LSU.2.00.1112211545150.25868@eggly.anvils>
References: <alpine.LSU.2.00.1112182234310.1503@eggly.anvils> <20111221050740.GD23662@dastard> <alpine.LSU.2.00.1112202218490.4026@eggly.anvils> <20111221221527.GE23662@dastard>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, Dave Chinner wrote:
> On Tue, Dec 20, 2011 at 10:53:17PM -0800, Hugh Dickins wrote:
> > On Wed, 21 Dec 2011, Dave Chinner wrote:
> > 
> > We do need to set node->parent NULL in all cases (and cannot clear
> > it when freeing).  I chose the "slot = blah(slot)" style to follow the
> > "newptr = blah(newptr)" over in radix_tree_shrink(), thought it helped
> > to keep those blocks alike.
> 
> You're right. I really was being dense yesterday. To tell the truth,
> though, I found the "newptr" style easier to follow because it was
> obvious which was the object being initialised. I think that it not
> being obvious which object needed full initialisation contribted to
> my mix up of node and slot parent pointers in my above comment...

Yes, I too get confused between parent and child and node and slot,
slot being a node which contains an array of slots.  I did experiment
with saying "parent" instead of "node" in several of the places touched,
or "child" instead of "slot", but didn't end up with anything that
satisfied me very much; so stuck with the bland node and slot.

> > At the top of the hunk, we can see the tag_set(slot, settag, offset)
> > where it sets the tag in the leafnode "slot"; then it loops up to parent
> > "node" of slot, to parent of parent, etc, setting tag in those, but
> > breaking as soon as it finds the tag already set - it can be sure that
> > the tag must already be set on all nodes above.
> > 
> > If afterwards it comes to set tag at another offset (most likely the
> > very next) in this same leafnode, we know that it has already set tag
> > on the parent, the parent's parent etc., so need not bother to tag_get
> > from the level above to discover that.  And since we happen to have a
> > variable "node" which stops the loop when it's NULL, let's set it to
> > NULL now to stop the loop immediately in future.
> 
> Ok, gotcha. perhaps a more expansive comment along the lines of:
> 
> /*
>  * we can clear the node pointer now as all it's ancestors have the
>  * tage set due to setting it on the slot above. Hence we have no
>  * need to walk back up the tree to set tags if there is no further
>  * tags to set.
>  */
> 
> is in order to remind me in a few months time why it this was done?

I've plagiarized your wording, but changed it enough that I cannot
honestly cite you as the Author.  Incremental patch to akpm follows
in a moment.

Hugh
