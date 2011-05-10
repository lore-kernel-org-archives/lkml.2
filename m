Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab1EJMF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:05:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:58675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab1EJMFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:05:24 -0400
Date: Tue, 10 May 2011 14:05:17 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 02/17] writeback: update dirtied_when for synced inode
 to prevent livelock
Message-ID: <20110510120517.GA4402@quack.suse.cz>
References: <20110506030821.523093711@intel.com>
 <20110506031612.043390260@intel.com>
 <20110506163312.GH18982@quack.suse.cz>
 <20110510021421.GA6758@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510021421.GA6758@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-05-11 10:14:21, Wu Fengguang wrote:
> On Sat, May 07, 2011 at 12:33:12AM +0800, Jan Kara wrote:
> > On Fri 06-05-11 11:08:23, Wu Fengguang wrote:
> > > With the more aggressive "keep writeback as long as we wrote something"
> > > logic in wb_writeback(), the "use LONG_MAX .nr_to_write" trick in commit
> > > b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") is
> > > no longer enough to stop sync livelock.
> > > 
> > > The fix is to explicitly update .dirtied_when on synced inodes, so that
> > > they are no longer considered for writeback in the next round.
> >   The changelog doesn't make sense now when the patch is in the second
> > place in the series... Also as we discussed in the previous iteration of
> > the patches, I thought you'll move the condition before mapping_tagged()
> > test. I.e. the code would be (comment updated):
> > 	if (!(inode->i_state & I_FREEING)) {
> > 		/*
> > 		 * Sync livelock prevention: Each inode is tagged and
> > 		 * synced in one shot. So we can unconditionally update its
> > 		 * dirty time to prevent syncing it again. Note that time
> > 		 * ordering of b_dirty list will be kept because the
> > 		 * following code either removes the inode from b_dirty
> > 		 * or calls redirty_tail().
> > 		 */
> > 		if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
> > 			inode->dirtied_when = jiffies;
> > 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> 
> It looks good, thanks!  Here is the updated patch with your
> reviewed-by. Note that I retains a modified paragraph in the changelog
> to clarify its relationship to the other two patches.
  Thanks. It's fine now.

								Honza

> Thanks,
> Fengguang
> ---
> Subject: writeback: update dirtied_when for synced inode to prevent livelock
> Date: Wed Apr 27 19:05:21 CST 2011
> 
> Explicitly update .dirtied_when on synced inodes, so that they are no
> longer considered for writeback in the next round.
> 
> We'll do more aggressive "keep writeback as long as we wrote something"
> logic in wb_writeback(). Then the "use LONG_MAX .nr_to_write" trick in
> commit b9543dac5b ("writeback: avoid livelocking WB_SYNC_ALL writeback")
> will no longer be enough to stop sync livelock.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-10 09:50:07.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-10 10:03:00.000000000 +0800
> @@ -419,6 +419,15 @@ writeback_single_inode(struct inode *ino
>  	spin_lock(&inode->i_lock);
>  	inode->i_state &= ~I_SYNC;
>  	if (!(inode->i_state & I_FREEING)) {
> +		/*
> +		 * Sync livelock prevention. Each inode is tagged and synced in
> +		 * one shot, so we can unconditionally update its dirty time to
> +		 * prevent syncing it again. Note that time ordering of b_dirty
> +		 * list will be kept because the following code either removes
> +		 * the inode from b_dirty or calls redirty_tail().
> +		 */
> +		if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_sync)
> +			inode->dirtied_when = jiffies;
>  		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
>  			/*
>  			 * We didn't write back all the pages.  nfs_writepages()
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
