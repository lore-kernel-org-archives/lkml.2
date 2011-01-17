Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1AQXMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:12:00 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46984 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1AQXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:11:59 -0500
Date: Mon, 17 Jan 2011 17:11:48 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: Re: linux-next: manual merge of the ecryptfs tree with Linus' tree
Message-ID: <20110117231147.GC31581@boyd.l.tihix.com>
References: <20110115111535.c919c470.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115111535.c919c470.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat Jan 15, 2011 at 11:15:35AM +1100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Tyler,
> 
> Today's linux-next merge of the ecryptfs tree got a conflict in
> fs/ecryptfs/main.c between commit
> 66cb76666d69502fe982990b2cff5b6d607fd3b1 ("sanitize ecryptfs ->mount()")
> from Linus' tree and commit c65b788ce32e9cd1c7d221551275774f1aa83084
> ("ecryptfs: missing initialization of the superblock 'magic' field") from
> the ecryptfs tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks Stephen - I made the same fix up earlier today when preparing a
branch for a pull request to Linus. Linus has completed the pull and
I've updated the eCryptfs next branch accordingly, so you shouldn't see
any merge conflicts today.

Tyler

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/ecryptfs/main.c
> index d3b28ab,70009a7..0000000
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@@ -546,54 -587,34 +546,55 @@@ static struct dentry *ecryptfs_mount(st
>   	/* ->kill_sb() will take care of sbi after that point */
>   	sbi = NULL;
>   	s->s_op = &ecryptfs_sops;
>  +	s->s_d_op = &ecryptfs_dops;
>   
>  -	rc = -ENOMEM;
>  -	s->s_root = d_alloc(NULL, &(const struct qstr) {
>  -			     .hash = 0,.name = "/",.len = 1});
>  +	err = "Reading sb failed";
>  +	rc = kern_path(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
>  +	if (rc) {
>  +		ecryptfs_printk(KERN_WARNING, "kern_path() failed\n");
>  +		goto out1;
>  +	}
>  +	if (path.dentry->d_sb->s_type == &ecryptfs_fs_type) {
>  +		rc = -EINVAL;
>  +		printk(KERN_ERR "Mount on filesystem of type "
>  +			"eCryptfs explicitly disallowed due to "
>  +			"known incompatibilities\n");
>  +		goto out_free;
>  +	}
>  +	ecryptfs_set_superblock_lower(s, path.dentry->d_sb);
>  +	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
>  +	s->s_blocksize = path.dentry->d_sb->s_blocksize;
> ++	s->s_magic = ECRYPTFS_SUPER_MAGIC;
>  +
>  +	inode = ecryptfs_get_inode(path.dentry->d_inode, s);
>  +	rc = PTR_ERR(inode);
>  +	if (IS_ERR(inode))
>  +		goto out_free;
>  +
>  +	s->s_root = d_alloc_root(inode);
>   	if (!s->s_root) {
>  -		deactivate_locked_super(s);
>  -		goto out;
>  +		iput(inode);
>  +		rc = -ENOMEM;
>  +		goto out_free;
>   	}
>  -	s->s_root->d_op = &ecryptfs_dops;
>  -	s->s_root->d_sb = s;
>  -	s->s_root->d_parent = s->s_root;
>   
>  +	rc = -ENOMEM;
>   	root_info = kmem_cache_zalloc(ecryptfs_dentry_info_cache, GFP_KERNEL);
>  -	if (!root_info) {
>  -		deactivate_locked_super(s);
>  -		goto out;
>  -	}
>  +	if (!root_info)
>  +		goto out_free;
>  +
>   	/* ->kill_sb() will take care of root_info */
>   	ecryptfs_set_dentry_private(s->s_root, root_info);
>  +	ecryptfs_set_dentry_lower(s->s_root, path.dentry);
>  +	ecryptfs_set_dentry_lower_mnt(s->s_root, path.mnt);
>  +
>   	s->s_flags |= MS_ACTIVE;
>  -	rc = ecryptfs_read_super(s, dev_name);
>  -	if (rc) {
>  -		deactivate_locked_super(s);
>  -		err = "Reading sb failed";
>  -		goto out;
>  -	}
>   	return dget(s->s_root);
>   
>  +out_free:
>  +	path_put(&path);
>  +out1:
>  +	deactivate_locked_super(s);
>   out:
>   	if (sbi) {
>   		ecryptfs_destroy_mount_crypt_stat(&sbi->mount_crypt_stat);
