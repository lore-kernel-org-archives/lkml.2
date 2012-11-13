Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2KMAkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:40:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KMAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:40:24 -0500
Date: Mon, 12 Nov 2012 16:40:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/7] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-Id: <20121112164022.1bc3dd4e.akpm@linux-foundation.org>
In-Reply-To: <20121112101845.678229459@openvz.org>
References: <20121112101440.665694060@openvz.org>
	<20121112101845.678229459@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:14:41 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This patch brings ability to print out auxiliary data associated
> with file in procfs interface /proc/pid/fdinfo/fd.
> 
> In particular further patches make eventfd, evenpoll, signalfd
> and fsnotify to print additional information complete enough
> to restore these objects after checkpoint.
> 
> To simplify the code we add show_fdinfo callback inside
> struct file_operations (as Al and Pavel are proposing).
>
> ...
>
> --- linux-2.6.git.orig/include/linux/fs.h
> +++ linux-2.6.git/include/linux/fs.h
> @@ -1517,6 +1517,8 @@ struct block_device_operations;
>  #define HAVE_COMPAT_IOCTL 1
>  #define HAVE_UNLOCKED_IOCTL 1
>  
> +struct seq_file;
> +

We already have a forward declaration of seq_file in fs.h.  At line
1583(!).

This is why forward declarations should always be placed at the start
of the file, please.

--- a/include/linux/fs.h~procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers-fix
+++ a/include/linux/fs.h
@@ -44,6 +44,7 @@ struct vm_area_struct;
 struct vfsmount;
 struct cred;
 struct swap_info_struct;
+struct seq_file;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1517,8 +1518,6 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
-struct seq_file;
-
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
@@ -1583,8 +1582,6 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 } ____cacheline_aligned;
 
-struct seq_file;
-
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
_

