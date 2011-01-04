Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1ADSQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:16:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41776 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ADSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:16:18 -0500
Message-ID: <4D2363E7.30101@linux.vnet.ibm.com>
Date: Tue, 04 Jan 2011 10:16:07 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Nick Piggin <npiggin@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the v9fs
 tree
References: <20110104124054.c767a4ee.sfr@canb.auug.org.au>
In-Reply-To: <20110104124054.c767a4ee.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/2011 5:40 PM, Stephen Rothwell wrote:
> Hi Nick,
> 
> Today's linux-next merge of the vfs-scale tree got a conflict in
> fs/9p/vfs_inode.c between commit 3d21652a1d23591e7f0bbbbedae29ce78c2c1113
> ("fs/9p: Move dotl inode operations into a seperate file") from the v9fs
> tree and various commits from the vfs-scale tree.
> 
> I fixed it up by using the v9fs changes to that file and then applying
> the following merge fixup patch (which I can carry as necessary).
> 
> Someone will need to fix this up before one of these trees is merged by
> Linus, or to send this merge fix to Linus.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Jan 2011 12:33:54 +1100
> Subject: [PATCH] v9fs: merge fix for changes in the vfs-scale tree
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/9p/vfs_inode_dotl.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> index 38d5880..9dd534b 100644
> --- a/fs/9p/vfs_inode_dotl.c
> +++ b/fs/9p/vfs_inode_dotl.c
> @@ -78,11 +78,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
>  {
>  	struct dentry *dentry;
> 
> -	spin_lock(&dcache_lock);
> +	spin_lock(&inode->i_lock);
>  	/* Directory should have only one entry. */
>  	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
>  	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
> -	spin_unlock(&dcache_lock);
> +	spin_unlock(&inode->i_lock);

Are we doing away with dcache_lock?

I am not sure if the i_lock can serve the same purpose..but looks like with the
current code
there may not need any lock around this code. Aneesh/Eric do you guys have any
comments?


>  	return dentry;
>  }
> 
> @@ -215,7 +215,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>  				err);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_cached_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);

Assuming that this is a macro to the same operation.. rest of the changes look
fine to me.

Thanks,
JV

>  		d_instantiate(dentry, inode);
>  		err = v9fs_fid_add(dentry, fid);
>  		if (err < 0)
> @@ -233,7 +233,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>  			err = PTR_ERR(inode);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_dentry_operations);
>  		d_instantiate(dentry, inode);
>  	}
>  	/* Now set the ACL based on the default value */
> @@ -331,7 +331,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
>  				err);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_cached_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
>  		d_instantiate(dentry, inode);
>  		err = v9fs_fid_add(dentry, fid);
>  		if (err < 0)
> @@ -348,7 +348,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
>  			err = PTR_ERR(inode);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_dentry_operations);
>  		d_instantiate(dentry, inode);
>  	}
>  	/* Now set the ACL based on the default value */
> @@ -589,7 +589,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
>  					err);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_cached_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
>  		d_instantiate(dentry, inode);
>  		err = v9fs_fid_add(dentry, fid);
>  		if (err < 0)
> @@ -602,7 +602,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
>  			err = PTR_ERR(inode);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_dentry_operations);
>  		d_instantiate(dentry, inode);
>  	}
> 
> @@ -678,7 +678,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
>  		ihold(old_dentry->d_inode);
>  	}
> 
> -	dentry->d_op = old_dentry->d_op;
> +	d_set_d_op(dentry, old_dentry->d_op);
>  	d_instantiate(dentry, old_dentry->d_inode);
> 
>  	return err;
> @@ -757,7 +757,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
>  				err);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_cached_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
>  		d_instantiate(dentry, inode);
>  		err = v9fs_fid_add(dentry, fid);
>  		if (err < 0)
> @@ -773,7 +773,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
>  			err = PTR_ERR(inode);
>  			goto error;
>  		}
> -		dentry->d_op = &v9fs_dentry_operations;
> +		d_set_d_op(dentry, &v9fs_dentry_operations);
>  		d_instantiate(dentry, inode);
>  	}
>  	/* Now set the ACL based on the default value */


