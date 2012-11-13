Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2KMAzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:55:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2KMAzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:55:41 -0500
Date: Mon, 12 Nov 2012 16:55:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-Id: <20121112165540.2ec39f50.akpm@linux-foundation.org>
In-Reply-To: <20121112101845.839702715@openvz.org>
References: <20121112101440.665694060@openvz.org>
	<20121112101845.839702715@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:14:43 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This file handle will be used in /proc/pid/fdinfo/fd
> output, which in turn will allow to restore a watch
> target after checkpoint (thus it's provided for
> CONFIG_CHECKPOINT_RESTORE only).

This changelog isn't very good.

What appears to be happening is that you're borrowing exportfs's
ability to encode file handles and this is being reused to transport
inotify fd's to userspace for c/r?  Or something else - I didn't try
very hard.  Please explain better?

> --- linux-2.6.git.orig/fs/notify/inotify/inotify.h
> +++ linux-2.6.git/fs/notify/inotify/inotify.h
> @@ -1,6 +1,7 @@
>  #include <linux/fsnotify_backend.h>
>  #include <linux/inotify.h>
>  #include <linux/slab.h> /* struct kmem_cache */
> +#include <linux/exportfs.h>
>  
>  extern struct kmem_cache *event_priv_cachep;
>  
> @@ -9,9 +10,16 @@ struct inotify_event_private_data {
>  	int wd;
>  };
>  
> +#if defined(CONFIG_PROC_FS) && defined(CONFIG_EXPORTFS) && defined(CONFIG_CHECKPOINT_RESTORE)
> +# define INOTIFY_USE_FHANDLE
> +#endif

Does this mean that c/r will fail to work properly if
CONFIG_EXPORTFS=n?  If so, that should be expressed in Kconfig
dependencies?

>  struct inotify_inode_mark {
>  	struct fsnotify_mark fsn_mark;
>  	int wd;
> +#ifdef INOTIFY_USE_FHANDLE
> +	__u8 fhandle[sizeof(struct file_handle) + MAX_HANDLE_SZ];
> +#endif
>  };

Whoa.  This adds 128+8 bytes to the inotify_inode_mark.  That's a lot of
bloat, and there can be a lot of inotify_inode_mark's in the system?

Also, what about alignment?  That embedded `struct file_handle' will
have a 4-byte alignment and if there's anything in there which is an
8-byte quantity then some architectures (ia64?) might get upset about
the kernel-mode unaligned access.  It appears that this won't happen in
the present code, but are we future-proof?

Why did you use a __u8, anyway?  Could have done something like

	struct {
		struct file_handle fhandle;
		u8 pad[MAX_HANDLE_SZ];
	};

and got some additional type safety and less typecasting?

>  extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
> Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
> ===================================================================
> --- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
> +++ linux-2.6.git/fs/notify/inotify/inotify_user.c
> @@ -566,6 +566,33 @@ static void inotify_free_mark(struct fsn
>  	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
>  }
>  
> +#ifdef INOTIFY_USE_FHANDLE
> +static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
> +{
> +	struct file_handle *fhandle = (struct file_handle *)mark->fhandle;
> +	int size, ret;
> +
> +	BUILD_BUG_ON(sizeof(mark->fhandle) <= sizeof(struct file_handle));
> +
> +	fhandle->handle_bytes = sizeof(mark->fhandle) - sizeof(struct file_handle);
> +	size = fhandle->handle_bytes >> 2;
> +
> +	ret = exportfs_encode_fh(dentry, (struct fid *)fhandle->f_handle, &size,  0);
> +	if ((ret == 255) || (ret == -ENOSPC))

Sigh.  ENOSPC means "your disk is full".  If this error ever gets back
to userspace, our poor user will go and provision more disks and then
wonder why that didn't fix anything.

> +		return -EOVERFLOW;

That doesn't seem very appropriate either, unsure.

> +	fhandle->handle_type = ret;
> +	fhandle->handle_bytes = size * sizeof(u32);
> +
> +	return 0;
> +}
>
> ...
>
