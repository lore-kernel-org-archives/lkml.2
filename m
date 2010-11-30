Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab0K3AWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:22:10 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26454 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274Ab0K3AWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:22:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHbS80x5LcIv/2dsb2JhbACjCnLCS4VHBA
Date: Tue, 30 Nov 2010 11:22:04 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] fs: introduce inode writeback helpers
Message-ID: <20101130002204.GF3255@amd>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.846551304@kernel.dk>
 <20101129151327.GE26076@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129151327.GE26076@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 10:13:27AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 24, 2010 at 01:06:13AM +1100, npiggin@kernel.dk wrote:
> > Inode dirty state cannot be securely tested without participating properly
> > in the inode writeback protocol. Some filesystems need to check this state,
> > so break out the code into helpers and make them available.
> > 
> > This could also be used to reduce strange interactions between background
> > writeback and fsync. Currently if we fsync a single page in a file, the
> > entire file gets requeued to the back of the background IO list, even if
> > it is due for writeout and has a large number of pages. That's left for
> > a later time.
> 
> Generally looks fine, but as Dave already mentioned I'd rather keep
> i_state manipulation outside the filesystems.  This could be done with

I don't see a big problem with it. They already did load it previously
in way which required inode_lock (and was buggy in part because it
didn't take that lock).


> two wrappers like the following, which should also keep the churn
> inside fsync implementations downs:
> 
> int fsync_begin(struct inode *inode, int datasync)
> {
> 	int ret = 0;
> 	unsigned mask = I_DIRTY_DATASYNC;
> 
> 	if (!datasync)
> 		mask |= I_DIRTY_SYNC;
> 
> 	spin_lock(&inode_lock);
> 	if (!inode_writeback_begin(inode, 1))
> 		goto out;
> 	if (!(inode->i_state & mask))
> 		goto out;
> 
> 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> 	ret = 1;
> out:
> 	spin_unlock(&inode_lock);
> 	return ret;
> }
> 
> static void fsync_end(struct inode *inode, int fail)
> {
> 	spin_lock(&inode_lock);
> 	if (fail)
> 		inode->i_state |= I_DIRTY_SYNC | I_DIRTY_DATASYNC;
> 	inode_writeback_end(inode);
> 	spin_unlock(&inode_lock);
> }

I prefer not to do that because it doesn't give any control over
setting or clearing the state flags (which might be done more
intelligently by the filesystem and so this function might be
unusable), and just restricts how filesystems use inode_writeback_begin
and inode lock.

Basically if you are doing anything slightly smart, you can start
inode_writeback_begin to exclude concurrent writeout, and if the
inode_lock is held, you can also prevent new changes to dirty bits
and thus keep the generic inode dirty bits in synch with your filesystem
private state.

In short, I don't see anything wrong with exporting
inode_writeback_begin and allowing i_state manipulation by filesystems
that want to do interesting things. And the wrappers AFAIKS don't add
that much -- it's not very long or difficult code.


> note that this one marks the inode fully dirty in case of a failure,
> which is a bit overkill but keeps the interface simpler.  Given that
> failure is fsync is catastrophic anyway (filesystem corruption, etc)
> that seems fine to me.
> 
> Alternatively we could add a fsync_helper that gets a function
> pointer with the ->write_inode signature and contains the above
> code before and after it. generic_file_fsync would pass the real
> ->write_inode while other filesystems could pass specific routines.


