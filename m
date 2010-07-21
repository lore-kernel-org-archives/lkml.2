Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0GURuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:50:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0GURuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:50:18 -0400
Date: Wed, 21 Jul 2010 18:49:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100721174952.GT31073@ZenIV.linux.org.uk>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
 <20100721052007.GT32635@dastard>
 <20100721002907.639802cd.akpm@linux-foundation.org>
 <20100721174809.4781c244.sfr@canb.auug.org.au>
 <20100721121116.GD3447@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721121116.GD3447@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:11:17PM +0200, Jan Kara wrote:
>   Thanks for bisecting this. The patch series indeed seems to uncover
> some discrepancies.
>   Ext3 has always dirtied inode in it's ->delete_inode method (via quota
> code). But previously clear_inode() just overwrote the state with I_CLEAR
> and thus we never saw the BUG_ON. After Al's patches, i_state is set in
> end_writeback() which happens earlier. In particular it happens before
> ext3_free_inode() which dirties the inode through quota code while freeing
> xattrs - they are accounted in i_blocks, so i_blocks are updated during
> freeing and inode is dirtied.
>   Actually, ext3_mark_inode_dirty() called during each mark_inode_dirty()
> call writes the inode state to the journal so the dirty flag in the inode
> state is in fact stale and overwriting it with I_CLEAR never mattered. In
> this sense, the BUG_ON triggered is a false positive. But I believe this is
> a separate story.
>   I'm not sure how to really fix this. It seems a bit premature to me to
> mark inode as I_CLEAR before the filesystem is actually done with it. So
> maybe the line
>   inode->i_state = I_FREEING | I_CLEAR;
> should be moved to evict() fuction?

Nope.  I_CLEAR is "no async calls from vfs anymore; it's under complete
fs control and is about to die now".

In any case, I'll post a dumb replacement for ext3 after I verify it on
the laptop I have with me.  Should be in an hour or so (the damn thing is
_slow_).
