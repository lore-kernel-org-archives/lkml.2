Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2KMBAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:00:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2KMBAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:00:19 -0500
Date: Mon, 12 Nov 2012 17:00:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 4/7] fs, notify: Add procfs fdinfo helper v4
Message-Id: <20121112170017.537e3c97.akpm@linux-foundation.org>
In-Reply-To: <20121112101845.907133141@openvz.org>
References: <20121112101440.665694060@openvz.org>
	<20121112101845.907133141@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:14:44 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This allow us to print out fsnotify details such as
> watchee inode, device, mask and optionally a file handle.
> 
> For inotify objects if kernel compiled with exportfs support
> the output will be
> 
>  | pos:	0
>  | flags:	02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153
> 
> If kernel compiled without exportfs support, the file handle
> won't be provided but inode and device only.
> 
>  | pos:	0
>  | flags:	02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0
> 
> For fanotify the output is like
> 
>  | pos:	0
>  | flags:	02
>  | fanotify ino:            68f71 sdev:   800013 mask:        1 ignored_mask: 40000000
>  | fanotify mnt_id:       13 mask:        1 ignored_mask: 40000000
> 
> To minimize impact on general fsnotify code the new functionality
> is gathered in fs/notify/fdinfo.c file.
> 
>
> ...
>
> --- /dev/null
> +++ linux-2.6.git/fs/notify/fdinfo.h
> @@ -0,0 +1,22 @@
> +#ifndef __FSNOTIFY_FDINFO_H__
> +#define __FSNOTIFY_FDINFO_H__
> +
> +#include <linux/errno.h>
> +#include <linux/proc_fs.h>
> +
> +struct seq_file;
> +struct file;
> +
> +#ifdef CONFIG_PROC_FS
> +
> +#ifdef CONFIG_INOTIFY_USER
> +extern int inotify_show_fdinfo(struct seq_file *m, struct file *f);
> +#endif
> +#ifdef CONFIG_FANOTIFY
> +extern int fanotify_show_fdinfo(struct seq_file *m, struct file *f);
> +#endif

#else	/* CONFIG_PROC_FS */
#define inotify_show_fdinfo NULL
#define fanotify_show_fdinfo NULL
#endif	/* CONFIG_PROC_FS */

> +
>
> ...
>
> @@ -335,6 +336,9 @@ static long inotify_ioctl(struct file *f
>  }
>  
>  static const struct file_operations inotify_fops = {
> +#ifdef CONFIG_PROC_FS
> +	.show_fdinfo	= inotify_show_fdinfo,
> +#endif
>  	.poll		= inotify_poll,
>  	.read		= inotify_read,
>  	.fasync		= inotify_fasync,
> @@ -427,6 +428,9 @@ static long fanotify_ioctl(struct file *
>  }
>  
>  static const struct file_operations fanotify_fops = {
> +#ifdef CONFIG_PROC_FS
> +	.show_fdinfo	= fanotify_show_fdinfo,
> +#endif
>  	.poll		= fanotify_poll,
>  	.read		= fanotify_read,
>  	.write		= fanotify_write,

Then remove these ifdefs.

That's if you can be bothered.  It's a bit of a party trick which
doesn't make things much clearer IMO.

