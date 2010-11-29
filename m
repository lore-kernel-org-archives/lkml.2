Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0K2PN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:13:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0K2PN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:13:28 -0500
Date: Mon, 29 Nov 2010 10:13:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] fs: introduce inode writeback helpers
Message-ID: <20101129151327.GE26076@infradead.org>
References: <20101123140610.292941494@kernel.dk>
 <20101123140707.846551304@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123140707.846551304@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:06:13AM +1100, npiggin@kernel.dk wrote:
> Inode dirty state cannot be securely tested without participating properly
> in the inode writeback protocol. Some filesystems need to check this state,
> so break out the code into helpers and make them available.
> 
> This could also be used to reduce strange interactions between background
> writeback and fsync. Currently if we fsync a single page in a file, the
> entire file gets requeued to the back of the background IO list, even if
> it is due for writeout and has a large number of pages. That's left for
> a later time.

Generally looks fine, but as Dave already mentioned I'd rather keep
i_state manipulation outside the filesystems.  This could be done with
two wrappers like the following, which should also keep the churn
inside fsync implementations downs:

int fsync_begin(struct inode *inode, int datasync)
{
	int ret = 0;
	unsigned mask = I_DIRTY_DATASYNC;

	if (!datasync)
		mask |= I_DIRTY_SYNC;

	spin_lock(&inode_lock);
	if (!inode_writeback_begin(inode, 1))
		goto out;
	if (!(inode->i_state & mask))
		goto out;

	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
	ret = 1;
out:
	spin_unlock(&inode_lock);
	return ret;
}

static void fsync_end(struct inode *inode, int fail)
{
	spin_lock(&inode_lock);
	if (fail)
		inode->i_state |= I_DIRTY_SYNC | I_DIRTY_DATASYNC;
	inode_writeback_end(inode);
	spin_unlock(&inode_lock);
}

note that this one marks the inode fully dirty in case of a failure,
which is a bit overkill but keeps the interface simpler.  Given that
failure is fsync is catastrophic anyway (filesystem corruption, etc)
that seems fine to me.

Alternatively we could add a fsync_helper that gets a function
pointer with the ->write_inode signature and contains the above
code before and after it. generic_file_fsync would pass the real
->write_inode while other filesystems could pass specific routines.

