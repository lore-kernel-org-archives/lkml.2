Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0HRRhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:37:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:36451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0HRRhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:37:52 -0400
Date: Wed, 18 Aug 2010 19:37:09 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        npiggin@kernel.dk, a.p.zijlstra@chello.nl, jack@suse.cz
Subject: Re: [bug] radix_tree_gang_lookup_tag_slot() looping endlessly
Message-ID: <20100818173708.GB15010@quack.suse.cz>
References: <20100818135651.GK7362@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818135651.GK7362@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 18-08-10 23:56:51, Dave Chinner wrote:
> I'm seeing a livelock with the new writeback sync livelock avoidance
> code. The problem is that the radix tree lookup via
> pagevec_lookup_tag()->find_get_pages_tag() is getting stuck in
> radix_tree_gang_lookup_tag_slot() and never exitting.
  Is this pagevec_lookup_tag() from write_cache_pages() which was called
for fsync() or so? 

> The reproducer I'm running is xfstests 013 on 2.6.35-rc1 with some
> pending XFS changes available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git for-oss
> 
> It's 100% reproducable, and a regression against 2.6.35 patched wth exactly
> the same extra XFS commits as the above branch.
  Hmm, what HW config do you have? I didn't hit the livelock and I've been
running xfstests several times with the livelock avoidance patch. Hmm,
looking at the code maybe what you describe could happen if we remove the
page from page cache but leave a dangling tag in the radix tree... But
remove_from_page_cache() is called with tree_lock held and it removes all
tags from the index we just remove so it shouldn't really happen. Could
you dump more info about the inode this happens on? Like the i_size, the
index we stall at... Thanks.

> I tried applying Nick's recent indirect pointer fixup patch for the
> radix tree, but that didn't fix the problem. I applied the patch
> below on top of that to detect when __lookup_tag is not making
> progress and the livelock has gone away. Someone who knows the how
> the radix tree code is supposed to work might be able to pinpoint
> the problem exactly from this.

								Honza
> ---
>  lib/radix-tree.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index 9eeb9f3..5d2872c 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -1077,6 +1077,11 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
>  			break;
>  		slots_found = __lookup_tag(node, (void ***)results + ret,
>  				cur_index, max_items - ret, &next_index, tag);
> +
> +		/* livelock avoidance */
> +		if (slots_found == 0 && cur_index == next_index)
> +			break;
> +
>  		nr_found = 0;
>  		for (i = 0; i < slots_found; i++) {
>  			struct radix_tree_node *slot;
> @@ -1147,6 +1152,9 @@ radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
>  			break;
>  		slots_found = __lookup_tag(node, results + ret,
>  				cur_index, max_items - ret, &next_index, tag);
> +		/* livelock avoidance */
> +		if (slots_found == 0 && cur_index == next_index)
> +			break;
>  		ret += slots_found;
>  		if (next_index == 0)
>  			break;
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
