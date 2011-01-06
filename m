Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1AFEuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:50:32 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:53297 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752637Ab1AFEub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:50:31 -0500
Date: Thu, 6 Jan 2011 15:50:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the xfs
 tree
Message-ID: <20110106045014.GE8322@dastard>
References: <20110106121056.0758b16f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106121056.0758b16f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 12:10:56PM +1100, Stephen Rothwell wrote:
> Hi Nick,
> 
> Today's linux-next merge of the vfs-scale tree got a conflict in
> fs/xfs/xfs_iget.c between commits
> d95b7aaf9ab6738bef1ebcc52ab66563085e44ac ("xfs: rcu free inodes") and
> 1a3e8f3da09c7082d25b512a0ffe569391e4c09a ("xfs: convert inode cache
> lookups to use RCU locking") from the xfs tree and commit
> bb3e8c37a0af21d0a8fe54a0b0f17aca16335a82 ("fs: icache RCU free inodes")
> from the vfs-scale tree.
> 
> OK, so looking at this, the first xfs tree patch above does the same as
> the vfs-scale tree patch (just using i_dentry instead of the (union
> eqivalent) i_rcu.  I fixed it up (see below - the diff does not show that
> __xfs_inode_free has been removed) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/xfs/xfs_iget.c
> index 3ecad00,d7de5a3..0000000
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@@ -157,17 -145,7 +156,17 @@@ xfs_inode_free
>   	ASSERT(!spin_is_locked(&ip->i_flags_lock));
>   	ASSERT(completion_done(&ip->i_flush));
>   
>  +	/*
>  +	 * Because we use RCU freeing we need to ensure the inode always
>  +	 * appears to be reclaimed with an invalid inode number when in the
>  +	 * free state. The ip->i_flags_lock provides the barrier against lookup
>  +	 * races.
>  +	 */
>  +	spin_lock(&ip->i_flags_lock);
>  +	ip->i_flags = XFS_IRECLAIM;
>  +	ip->i_ino = 0;
>  +	spin_unlock(&ip->i_flags_lock);
> - 	call_rcu((struct rcu_head *)&VFS_I(ip)->i_dentry, __xfs_inode_free);
> + 	call_rcu(&ip->i_vnode.i_rcu, xfs_inode_free_callback);

The fixed up call_rcu() shoul dbe:

+	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
