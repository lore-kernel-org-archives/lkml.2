Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0GWKEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:04:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:57650 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0GWKEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:04:40 -0400
Date: Fri, 23 Jul 2010 12:04:08 +0200
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100723100408.GB3305@quack.suse.cz>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
 <20100721052007.GT32635@dastard>
 <20100721002907.639802cd.akpm@linux-foundation.org>
 <20100721174809.4781c244.sfr@canb.auug.org.au>
 <20100721121116.GD3447@quack.suse.cz>
 <20100721214016.GA903@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721214016.GA903@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Al,

On Wed 21-07-10 22:40:16, Al Viro wrote:
> On Wed, Jul 21, 2010 at 02:11:17PM +0200, Jan Kara wrote:
> >   Thanks for bisecting this. The patch series indeed seems to uncover
> > some discrepancies.
> >   Ext3 has always dirtied inode in it's ->delete_inode method (via quota
> > code). But previously clear_inode() just overwrote the state with I_CLEAR
> > and thus we never saw the BUG_ON. After Al's patches, i_state is set in
> > end_writeback() which happens earlier. In particular it happens before
> > ext3_free_inode() which dirties the inode through quota code while freeing
> > xattrs - they are accounted in i_blocks, so i_blocks are updated during
> > freeing and inode is dirtied.
> >   Actually, ext3_mark_inode_dirty() called during each mark_inode_dirty()
> > call writes the inode state to the journal so the dirty flag in the inode
> > state is in fact stale and overwriting it with I_CLEAR never mattered. In
> > this sense, the BUG_ON triggered is a false positive. But I believe this is
> > a separate story.
> 
> Could you please explain why the hell does ext2_xattr_delete_inode() call the
> dirtying variant of dquot_free_block()?  Note that the inode is well beyond
> the point where writeback would consider touching it; this mark_inode_dirty()
> will do nothing useful whatsoever at that place.
  Yes, I'm aware that dirtying inode does nothing useful at that point.
But OTOH it does no harm so why not call the standard variant of quota
function? But I have no strong opinion on this particular callsite so
using dquot_free_block_nodirty() at that place is OK with me.
 
> Anyway, I've dealt with ext3 and ext2 (both b0rken with quota) and AFAICS
> the rest of quota-supporting filesystems had been OK.  Changes:
> 
> ext3_evict_inode() hd end_writeback() shifted downstream (needed anyway)
  I like this.

> ext2 switched to nodirty variant of dquot_free_block()
  But I don't like this - see comments in the patch. I'd be much more happy
if ext2 did the same thing as ext3 - pulled ext2_xattr_delete_inode()
call out of ext2_free_inode called end_writeback() after it.

> ext2_xattr_delete_inode() doesn't try to dirty inode anymore (always
> had been pointless).
  As I wrote above I don't care about this very much.

> It's in for-next, should propagate to git.kernel.org in a few.
> 
> Diff against the buggy version follows, feel free to try.
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index e8766a3..c6c684b 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -571,7 +571,7 @@ do_more:
>  error_return:
>  	brelse(bitmap_bh);
>  	release_blocks(sb, freed);
> -	dquot_free_block(inode, freed);
> +	dquot_free_block_nodirty(inode, freed);
>  }
The above call in ext2_free_blocks() modifies the inode and
ext2_free_blocks is enough "black-box" function that it should do the right
thing and dirty the inode if it modified it.
 
>  /**
> @@ -1418,7 +1418,8 @@ allocated:
>  
>  	*errp = 0;
>  	brelse(bitmap_bh);
> -	dquot_free_block(inode, *count-num);
> +	dquot_free_block_nodirty(inode, *count-num);
> +	mark_inode_dirty(inode);
>  	*count = num;
>  	return ret_block;
>  
> @@ -1428,8 +1429,10 @@ out:
>  	/*
>  	 * Undo the block allocation
>  	 */
> -	if (!performed_allocation)
> -		dquot_free_block(inode, *count);
> +	if (!performed_allocation) {
> +		dquot_free_block_nodirty(inode, *count);
> +		mark_inode_dirty(inode);
> +	}
>  	brelse(bitmap_bh);
>  	return 0;
>  }
  Sorry, but the above two changes look stupid... Why call _nodirty variant
and dirty the inode immediately after that? It happens in two other places
in your patch as well...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
