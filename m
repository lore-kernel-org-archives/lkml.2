Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1CUAnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 20:43:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38589 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1CUAnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 20:43:15 -0400
Date: Mon, 21 Mar 2011 11:43:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20110321114306.3d91bfb5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in fs/super.c
between commit 9d412a43c3b2 ("vfs: split off vfsmount-related parts of
vfs_kern_mount()") from Linus' tree and commit 95f28604a65b ("fs: assign
sb->s_bdi to default_backing_dev_info if the bdi is going away") from the
block tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/super.c
index e848649,0d89e93..0000000
--- a/fs/super.c
+++ b/fs/super.c
@@@ -928,17 -989,25 +929,18 @@@ mount_fs(struct file_system_type *type
  			goto out_free_secdata;
  	}
  
 -	if (type->mount) {
 -		root = type->mount(type, flags, name, data);
 -		if (IS_ERR(root)) {
 -			error = PTR_ERR(root);
 -			goto out_free_secdata;
 -		}
 -		mnt->mnt_root = root;
 -		mnt->mnt_sb = root->d_sb;
 -	} else {
 -		error = type->get_sb(type, flags, name, data, mnt);
 -		if (error < 0)
 -			goto out_free_secdata;
 +	root = type->mount(type, flags, name, data);
 +	if (IS_ERR(root)) {
 +		error = PTR_ERR(root);
 +		goto out_free_secdata;
  	}
 -	BUG_ON(!mnt->mnt_sb);
 -	WARN_ON(!mnt->mnt_sb->s_bdi);
 -	WARN_ON(mnt->mnt_sb->s_bdi == &default_backing_dev_info);
 -	mnt->mnt_sb->s_flags |= MS_BORN;
 +	sb = root->d_sb;
 +	BUG_ON(!sb);
 +	WARN_ON(!sb->s_bdi);
++	WARN_ON(sb->s_bdi == &default_backing_dev_info);
 +	sb->s_flags |= MS_BORN;
  
 -	error = security_sb_kern_mount(mnt->mnt_sb, flags, secdata);
 +	error = security_sb_kern_mount(sb, flags, secdata);
  	if (error)
  		goto out_sb;
  
