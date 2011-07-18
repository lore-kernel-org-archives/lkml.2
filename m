Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1GRDgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:36:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191Ab1GRDgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:36:39 -0400
Date: Mon, 18 Jul 2011 13:36:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-Id: <20110718133636.579d9002dbb56cd6408a2a7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/xfs/linux-2.6/xfs_super.c between commit 2bcf6e970f5a ("xfs: start
periodic workers later") from the xfs tree and commit d86b98f73104 ("xfs:
make use of new shrinker callout for the inode cache") from the vfs tree.

I fixed it up (I think, see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/linux-2.6/xfs_super.c
index 25fd2cd,a9c6ccf..0000000
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@@ -1411,9 -1407,7 +1406,7 @@@ xfs_fs_fill_super
  	sb->s_time_gran = 1;
  	set_posix_acl_flag(sb);
  
- 	xfs_inode_shrinker_register(mp);
- 
 -	error = xfs_syncd_init(mp);
 +	error = xfs_mountfs(mp);
  	if (error)
  		goto out_filestream_unmount;
  
@@@ -1438,8 -1432,9 +1431,7 @@@
  
  	return 0;
  
 - out_syncd_stop:
 -	xfs_syncd_stop(mp);
   out_filestream_unmount:
- 	xfs_inode_shrinker_unregister(mp);
  	xfs_filestream_unmount(mp);
   out_free_sb:
  	xfs_freesb(mp);
@@@ -1453,12 -1448,16 +1445,11 @@@
   out:
  	return -error;
  
 - fail_vnrele:
 -	if (sb->s_root) {
 -		dput(sb->s_root);
 -		sb->s_root = NULL;
 -	} else {
 -		iput(root);
 -	}
 -
 - fail_unmount:
 + out_iput:
 +	iput(root);
 + out_syncd_stop:
  	xfs_syncd_stop(mp);
 + out_unmount:
- 	xfs_inode_shrinker_unregister(mp);
  
  	/*
  	 * Blow away any referenced inode in the filestreams cache.
