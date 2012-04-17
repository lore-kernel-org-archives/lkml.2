Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2DQVO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:14:26 -0400
Received: from fieldses.org ([174.143.236.118]:60244 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2DQVOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:14:25 -0400
Date: Tue, 17 Apr 2012 17:14:19 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417211419.GC27426@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
 <20120417182825.GX6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417182825.GX6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:28:26PM +0100, Al Viro wrote:
> On Tue, Apr 17, 2012 at 07:01:29PM +0100, Al Viro wrote:
> 
> > It isn't.  Hell knows - I wonder if taking s_vfs_rename_mutex in all cases
> > in lock_rename() would be the right thing to do; it would remove the
> > problem, but might cost us too much contention...
> 
> Actually, it's even worse.  ext4_move_extents() locks a _pair_ of
> ->i_mutex (having checked that both are non-directories first).  In
> i_ino order.  So the only plausible ordering would be
> 	* directories by tree order (with s_vfs_rename_mutex held to
> stabilize the tree topology)
> 	* non-directories after all directories, ordered in some consistent
> way.  Which would have to be by inumber if we want to leave ext4 code
> as-is.
> 
> Bruce: for now I'm dropping that patch.  We _might_ take ext4
> mutex_inode_double_lock() into fs/namei.c and have it used by
> vfs_rename_other(), but I'm not convinced that this is the right
> thing to do.  Is there any other sane way to deal with nfsd problem?
> i_mutex is already used for more things than I'd like...

I don't want to give out a delegation while a rename, link, unlink, or
setattr of an inode is in progress.  All but rename are covered by the
i_mutex.

I'm happy just failing the delegation in case of conflict.

Maybe instead I could continue using the i_mutex but handle rename some
other way; e.g. in delegation code:

	if (!mutex_trylock(inode->i_mutex))
		return -EAGAIN;
	if (atomic_read(inode->i_renames_in_progress))
		return -EAGAIN;

and add an

	atomic_inc(inode->i_renames_in_progress);
	atomic_dec(inode->i_renames_in_progress);

pair around rename.

Or I could increment that counter for all the conflicting operations and
rely on it instead of the i_mutex.  I was trying to avoid adding
something like that (an inc, a dec, another error path) to every
operation.  And hoping to avoid adding another field to struct inode.
Oh well.

--b.
