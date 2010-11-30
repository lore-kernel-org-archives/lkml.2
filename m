Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0K3ALJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:11:09 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26996 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab0K3ALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:11:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP7O80x5LcIv/2dsb2JhbACjCnLCT4VHBA
Date: Tue, 30 Nov 2010 11:11:03 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/7] fs: fsync optimisations
Message-ID: <20101130001103.GE3255@amd>
References: <20101123140610.292941494@kernel.dk>
 <20101123140708.058372884@kernel.dk>
 <20101129150325.GD26076@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129150325.GD26076@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:03:25AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 24, 2010 at 01:06:16AM +1100, npiggin@kernel.dk wrote:
> > Optimise fsync by adding a datasync parameter to sync_inode_metadata to
> > DTRT with writing back the inode (->write_inode in theory should have a
> > datasync parameter too perhaps, but that's for another time).
> > 
> > Also, implement the metadata sync optimally rather than reusing the
> > normal data writeback path. This means less useless moving the inode around the
> > writeback lists, and less dropping and retaking of inode_lock, and avoiding
> > the data writeback call with nr_pages == 0.
> 
> This patch looks good to me, but a few minor comments below:

(BTW. it actually had a bug with writeback_end not being called in some
cases, in case you test it)

> > @@ -1315,13 +1315,49 @@ EXPORT_SYMBOL(sync_inode);
> >   *
> >   * Note: only writes the actual inode, no associated data or other metadata.
> >   */
> > -int sync_inode_metadata(struct inode *inode, int wait)
> > +int sync_inode_metadata(struct inode *inode, int datasync, int wait)
> >  {
> > +	struct address_space *mapping = inode->i_mapping;
> >  	struct writeback_control wbc = {
> >  		.sync_mode = wait ? WB_SYNC_ALL : WB_SYNC_NONE,
> >  		.nr_to_write = 0, /* metadata-only */
> >  	};
> > +	unsigned dirty, mask;
> > +	int ret = 0;
> >  
> > -	return sync_inode(inode, &wbc);
> > +	/*
> > +	 * This is a similar implementation to writeback_single_inode.
> > +	 * Keep them in sync.
> > +	 */
> 
> I'd move this comment to above the function.

OK

> 
> > +	/*
> > +	 * Generic write_inode doesn't distinguish between sync and datasync,
> > +	 * so even a datasync can clear the sync state. Filesystems which
> > +	 * distiguish these cases must only clear 'mask' in their metadata
> > +	 * sync code.
> > +	 */
> 
> I don't understand this comment.  Currenly filesystems never clear
> i_state bits by themselves.

No, but with the new inode writeback routines they could. Basically
they might be expected to copy this function, and put their own
improvements in.

