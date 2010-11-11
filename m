Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0KKWLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:11:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756348Ab0KKWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:11:36 -0500
Date: Thu, 11 Nov 2010 14:10:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        jens.axboe@oracle.com, anfei.zhou@gmail.com, avati@gluster.com,
        fuse-devel@lists.sourceforge.net
Subject: Re: [PATCH] Fix bug in FUSE where the attribute cache for a file
 was not cleared when a file is opened with O_TRUNC.
Message-Id: <20101111141037.b1358d1c.akpm@linux-foundation.org>
In-Reply-To: <E1PC9ed-00045m-LA@pomaz-ex.szeredi.hu>
References: <1288395700-9527-1-git-send-email-ksumrall@android.com>
	<20101029170209.0aced0ca.akpm@linux-foundation.org>
	<AANLkTimJWX5WnG6oiUfBxiD=BBJ=Q5iRc73iar=gPKCy@mail.gmail.com>
	<E1PC9ed-00045m-LA@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010 13:31:23 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Subject: fuse: fix attributes after open(O_TRUNC)
> From: Ken Sumrall <ksumrall@android.com>
> 
> The attribute cache for a file was not being cleared when a file is
> opened with O_TRUNC.
> 
> If the filesystem's open operation truncates the file
> ("atomic_o_trunc" feature flag is set) then the kernel should
> invalidate the cached st_mtime and st_ctime attributes.
> 
> Also i_size should be explicitly be set to zero as it is used
> sometimes without refreshing the cache.
> 
> Signed-off-by: Ken Sumrall <ksumrall@android.com>
> Cc: Anfei <anfei.zhou@gmail.com>
> Cc: "Anand V. Avati" <avati@gluster.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
> Cc: stable@kernel.org
> ---
> 
>  fs/fuse/file.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux-2.6/fs/fuse/file.c
> ===================================================================
> --- linux-2.6.orig/fs/fuse/file.c	2010-10-27 14:04:02.000000000 +0200
> +++ linux-2.6/fs/fuse/file.c	2010-10-30 13:14:07.000000000 +0200
> @@ -134,6 +134,7 @@ EXPORT_SYMBOL_GPL(fuse_do_open);
>  void fuse_finish_open(struct inode *inode, struct file *file)
>  {
>  	struct fuse_file *ff = file->private_data;
> +	struct fuse_conn *fc = get_fuse_conn(inode);
>  
>  	if (ff->open_flags & FOPEN_DIRECT_IO)
>  		file->f_op = &fuse_direct_io_file_operations;
> @@ -141,6 +142,15 @@ void fuse_finish_open(struct inode *inod
>  		invalidate_inode_pages2(inode->i_mapping);
>  	if (ff->open_flags & FOPEN_NONSEEKABLE)
>  		nonseekable_open(inode, file);
> +	if (fc->atomic_o_trunc && (file->f_flags & O_TRUNC)) {
> +		struct fuse_inode *fi = get_fuse_inode(inode);
> +
> +		spin_lock(&fc->lock);
> +		fi->attr_version = ++fc->attr_version;
> +		i_size_write(inode, 0);

i_size_write() requires that i_mutex be held, as described at the
i_size_write() definition site.

Is it reliably the case that i_mutex is held here?

> +		spin_unlock(&fc->lock);
> +		fuse_invalidate_attr(inode);
> +	}
>  }
>  
>  int fuse_open_common(struct inode *inode, struct file *file, bool isdir)

