Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab2HOUpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:45:49 -0400
Received: from fieldses.org ([174.143.236.118]:39717 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab2HOUpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:45:47 -0400
Date: Wed, 15 Aug 2012 16:45:46 -0400
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120815204546.GC25062@fieldses.org>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815092409.591460800@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:21:20PM +0400, Cyrill Gorcunov wrote:
> To provide fsnotify object inodes being watched without
> binding to alphabetical path we need to encode them with
> exportfs help. This patch adds a helper which operates
> with plain inodes directly.

I don't get it--this seems like a really roundabout way to get inode and
generation number, if that's all you want.

On the other hand, if you want a real filehandle then wouldn't you want
to e.g. call the filesystem's ->encode_fh() if necessary, as
exportfs_encode_fh() does?

--b.

> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Acked-by: Pavel Emelyanov <xemul@parallels.com>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: James Bottomley <jbottomley@parallels.com>
> ---
>  fs/exportfs/expfs.c      |   19 +++++++++++++++++++
>  include/linux/exportfs.h |    2 ++
>  2 files changed, 21 insertions(+)
> 
> Index: linux-2.6.git/fs/exportfs/expfs.c
> ===================================================================
> --- linux-2.6.git.orig/fs/exportfs/expfs.c
> +++ linux-2.6.git/fs/exportfs/expfs.c
> @@ -302,6 +302,25 @@ out:
>  	return error;
>  }
>  
> +int export_encode_inode_fh(struct inode *inode, struct fid *fid, int *max_len)
> +{
> +	int len = *max_len;
> +	int type = FILEID_INO32_GEN;
> +
> +	if (len < 2) {
> +		*max_len = 2;
> +		return 255;
> +	}
> +
> +	len = 2;
> +	fid->i32.ino = inode->i_ino;
> +	fid->i32.gen = inode->i_generation;
> +	*max_len = len;
> +
> +	return type;
> +}
> +EXPORT_SYMBOL_GPL(export_encode_inode_fh);
> +
>  /**
>   * export_encode_fh - default export_operations->encode_fh function
>   * @inode:   the object to encode
> Index: linux-2.6.git/include/linux/exportfs.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/exportfs.h
> +++ linux-2.6.git/include/linux/exportfs.h
> @@ -177,6 +177,8 @@ struct export_operations {
>  	int (*commit_metadata)(struct inode *inode);
>  };
>  
> +extern int export_encode_inode_fh(struct inode *inode, struct fid *fid, int *max_len);
> +
>  extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
>  	int *max_len, int connectable);
>  extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
