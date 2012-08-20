Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2HTO24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:28:56 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38033 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2HTO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:28:50 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
In-Reply-To: <20120815092409.591460800@openvz.org>
Date: Mon, 20 Aug 2012 19:49:23 +0530
Message-ID: <87fw7habo4.fsf@skywalker.in.ibm.com>
References: <20120815092116.700948346@openvz.org> <20120815092409.591460800@openvz.org>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12082014-9264-0000-0000-0000022A4D09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> To provide fsnotify object inodes being watched without
> binding to alphabetical path we need to encode them with
> exportfs help. This patch adds a helper which operates
> with plain inodes directly.

doesn't name_to_handle_at()  work for you ? It also allows to get a file
handle using file descriptor.

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


If you are looking at getting file handle, that may not be
sufficient. Some file system put more info in file handle (btrfs)

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

-aneesh

