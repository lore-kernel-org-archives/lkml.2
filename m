Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423128Ab2KNRiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:38:01 -0500
Received: from fieldses.org ([174.143.236.118]:52214 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978Ab2KNRiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:38:00 -0500
Date: Wed, 14 Nov 2012 12:37:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, oleg@redhat.com, rientjes@google.com,
        tvrtko.ursulin@onelan.co.uk, Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 6/7] fs, exportfs: Add exportfs_encode_inode_fh helper
Message-ID: <20121114173757.GJ23604@fieldses.org>
References: <20121114151937.344922058@openvz.org>
 <20121114152239.840001980@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114152239.840001980@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 07:19:43PM +0400, Cyrill Gorcunov wrote:
> We will need this helper in the next patch to
> provide a file handle for inotify marks in
> /proc/pid/fdinfo output.
> 
> The patch is rather providing the way to use inodes
> directly when dentry is not available (like in case
> of inotify system).

Looks OK to me.--b.

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: James Bottomley <jbottomley@parallels.com>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Matthew Helsley <matt.helsley@gmail.com>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
> ---
>  fs/exportfs/expfs.c      |   19 ++++++++++++++-----
>  include/linux/exportfs.h |    2 ++
>  2 files changed, 16 insertions(+), 5 deletions(-)
> Index: linux-2.6.git/fs/exportfs/expfs.c
> ===================================================================
> --- linux-2.6.git.orig/fs/exportfs/expfs.c
> +++ linux-2.6.git/fs/exportfs/expfs.c
> @@ -341,10 +341,21 @@ static int export_encode_fh(struct inode
>  	return type;
>  }
>  
> +int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
> +			     int *max_len, struct inode *parent)
> +{
> +	const struct export_operations *nop = inode->i_sb->s_export_op;
> +
> +	if (nop && nop->encode_fh)
> +		return nop->encode_fh(inode, fid->raw, max_len, parent);
> +
> +	return export_encode_fh(inode, fid, max_len, parent);
> +}
> +EXPORT_SYMBOL_GPL(exportfs_encode_inode_fh);
> +
>  int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
>  		int connectable)
>  {
> -	const struct export_operations *nop = dentry->d_sb->s_export_op;
>  	int error;
>  	struct dentry *p = NULL;
>  	struct inode *inode = dentry->d_inode, *parent = NULL;
> @@ -357,10 +368,8 @@ int exportfs_encode_fh(struct dentry *de
>  		 */
>  		parent = p->d_inode;
>  	}
> -	if (nop && nop->encode_fh)
> -		error = nop->encode_fh(inode, fid->raw, max_len, parent);
> -	else
> -		error = export_encode_fh(inode, fid, max_len, parent);
> +
> +	error = exportfs_encode_inode_fh(inode, fid, max_len, parent);
>  	dput(p);
>  
>  	return error;
> Index: linux-2.6.git/include/linux/exportfs.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/exportfs.h
> +++ linux-2.6.git/include/linux/exportfs.h
> @@ -177,6 +177,8 @@ struct export_operations {
>  	int (*commit_metadata)(struct inode *inode);
>  };
>  
> +extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
> +				    int *max_len, struct inode *parent);
>  extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
>  	int *max_len, int connectable);
>  extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
> 
