Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2CLX6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:58:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2CLX62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:58:28 -0400
Date: Mon, 12 Mar 2012 16:58:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
Message-Id: <20120312165826.c59dc219.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBBn35FU99qoXwmPx+FK6=Vt-DXsCje3bAXYB+GrvR9hPg@mail.gmail.com>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
	<CAJd=RBB3202WV4zJratpp8c8VjkipNEbB_p9bGjLKrxr7qL-RA@mail.gmail.com>
	<alpine.DEB.2.00.1203111322550.20299@chino.kir.corp.google.com>
	<CAJd=RBBn35FU99qoXwmPx+FK6=Vt-DXsCje3bAXYB+GrvR9hPg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 20:01:43 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Mon, Mar 12, 2012 at 4:25 AM, David Rientjes <rientjes@google.com> wrote:
> >
> > The patch looks good, however, we typically do things like
> >
> > __ __ __ __error = -ENOMEM;
> > __ __ __ __hugetlbfs_inode_cachep = kmem_cache_create(...);
> > __ __ __ __if (!hugetlbfs_inode_cachep)
> > __ __ __ __ __ __ __ __...
> >
> > instead. __Sometimes people grep to see if a call a function that can fail,
> > such as kmem_cache_create(), is followed up by a check for NULL and this
> > would otherwise fail.
> >
> >
> It is updated, thanks David.
> 
> -hd
> ===cut here===
> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] hugetlbfs: add err code in initilizing module
> 
> Error code is added if fail to create inode kmem cache, and newly registered
> hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
> +++ b/fs/hugetlbfs/inode.c	Mon Mar 12 19:52:16 2012
> @@ -997,6 +997,7 @@ static int __init init_hugetlbfs_fs(void
>  	if (error)
>  		return error;
> 
> +	error = -ENOMEM;
>  	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
>  					sizeof(struct hugetlbfs_inode_info),
>  					0, 0, init_once);
> @@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
>  	}
> 
>  	error = PTR_ERR(vfsmount);
> +	unregister_filesystem(&hugetlbfs_fs_type);
> 
>   out:
>  	if (error)

And this, yes?

remove unneeded test of `error'

--- a/fs/hugetlbfs/inode.c~hugetlbfs-return-error-code-when-initializing-module-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1035,8 +1035,7 @@ static int __init init_hugetlbfs_fs(void
 	unregister_filesystem(&hugetlbfs_fs_type);
 
  out:
-	if (error)
-		kmem_cache_destroy(hugetlbfs_inode_cachep);
+	kmem_cache_destroy(hugetlbfs_inode_cachep);
  out2:
 	bdi_destroy(&hugetlbfs_backing_dev_info);
 	return error;
_

