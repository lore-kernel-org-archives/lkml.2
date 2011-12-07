Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1LGCEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:04:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38102 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1LGCEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:04:50 -0500
Date: Wed, 7 Dec 2011 02:04:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] BTRFS: Establish i_ops before calling d_instantiate
Message-ID: <20111207020446.GU2203@ZenIV.linux.org.uk>
References: <4EDEB5D6.4040202@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDEB5D6.4040202@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 04:39:50PM -0800, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> The Smack LSM hook for security_d_instantiate checks
> the inode's i_op->getxattr value to determine if the
[snip]

> +	inode->i_op = &btrfs_special_inode_operations;
> +
>  	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
>  	if (err)
>  		drop_inode = 1;
>  	else {
> -		inode->i_op = &btrfs_special_inode_operations;
>  		init_special_inode(inode, inode->i_mode, rdev);
>  		btrfs_update_inode(trans, root, inode);

To hell with LSM, there are much stronger reasons why d_instantiate() on
a half-baked inode is wrong.  As soon as you've done it somebody can
come and look that dentry up.

IOW, the bug is real, but this patch is not enough - in particular, ->create()
part is simply wrong.  We need to set ->a_ops before some joker comes and
tries to open it, at the very least...
