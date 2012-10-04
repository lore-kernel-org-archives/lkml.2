Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2JDVzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:55:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37779 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab2JDVzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:55:35 -0400
Date: Thu, 4 Oct 2012 22:55:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Brian Foster <bfoster@redhat.com>, Theodore Tso <tytso@mit.edu>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004215528.GK13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225202.266707400@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225202.266707400@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 110/180] ext4: dont let i_reserved_meta_blocks go negative
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:53:47AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Brian Foster <bfoster@redhat.com>
> 
> commit 97795d2a5b8d3c8dc4365d4bd3404191840453ba upstream.
> 
> If we hit a condition where we have allocated metadata blocks that
> were not appropriately reserved, we risk underflow of
> ei->i_reserved_meta_blocks.  In turn, this can throw
> sbi->s_dirtyclusters_counter significantly out of whack and undermine
> the nondelalloc fallback logic in ext4_nonda_switch().  Warn if this
> occurs and set i_allocated_meta_blocks to avoid this problem.
> 
> This condition is reproduced by xfstests 270 against ext2 with
> delalloc enabled:
> 
> Mar 28 08:58:02 localhost kernel: [  171.526344] EXT4-fs (loop1): delayed block allocation failed for inode 14 at logical offset 64486 with max blocks 64 with error -28
> Mar 28 08:58:02 localhost kernel: [  171.526346] EXT4-fs (loop1): This should not happen!! Data will be lost
> 
> 270 ultimately fails with an inconsistent filesystem and requires an
> fsck to repair.  The cause of the error is an underflow in
> ext4_da_update_reserve_space() due to an unreserved meta block
> allocation.
[...]
> +	if (unlikely(ei->i_allocated_meta_blocks > ei->i_reserved_meta_blocks)) {
> +		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, allocated %d "
> +			 "with only %d reserved metadata blocks\n", __func__,
> +			 inode->i_ino, ei->i_allocated_meta_blocks,
> +			 ei->i_reserved_meta_blocks);
> +		WARN_ON(1);
> +		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
> +	}
[...]
 
This seems to be working around a bug elsewhere.  Has the underlying
bug been fixed in mainline yet?

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
