Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1AFBLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:11:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44298 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1AFBK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 20:10:59 -0500
Date: Thu, 6 Jan 2011 12:10:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the vfs-scale tree with the xfs tree
Message-Id: <20110106121056.0758b16f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Today's linux-next merge of the vfs-scale tree got a conflict in
fs/xfs/xfs_iget.c between commits
d95b7aaf9ab6738bef1ebcc52ab66563085e44ac ("xfs: rcu free inodes") and
1a3e8f3da09c7082d25b512a0ffe569391e4c09a ("xfs: convert inode cache
lookups to use RCU locking") from the xfs tree and commit
bb3e8c37a0af21d0a8fe54a0b0f17aca16335a82 ("fs: icache RCU free inodes")
from the vfs-scale tree.

OK, so looking at this, the first xfs tree patch above does the same as
the vfs-scale tree patch (just using i_dentry instead of the (union
eqivalent) i_rcu.  I fixed it up (see below - the diff does not show that
__xfs_inode_free has been removed) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_iget.c
index 3ecad00,d7de5a3..0000000
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@@ -157,17 -145,7 +156,17 @@@ xfs_inode_free
  	ASSERT(!spin_is_locked(&ip->i_flags_lock));
  	ASSERT(completion_done(&ip->i_flush));
  
 +	/*
 +	 * Because we use RCU freeing we need to ensure the inode always
 +	 * appears to be reclaimed with an invalid inode number when in the
 +	 * free state. The ip->i_flags_lock provides the barrier against lookup
 +	 * races.
 +	 */
 +	spin_lock(&ip->i_flags_lock);
 +	ip->i_flags = XFS_IRECLAIM;
 +	ip->i_ino = 0;
 +	spin_unlock(&ip->i_flags_lock);
- 	call_rcu((struct rcu_head *)&VFS_I(ip)->i_dentry, __xfs_inode_free);
+ 	call_rcu(&ip->i_vnode.i_rcu, xfs_inode_free_callback);
  }
  
  /*
