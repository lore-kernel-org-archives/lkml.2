Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030390Ab2CVAd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:33:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46928 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2CVAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:33:58 -0400
Date: Thu, 22 Mar 2012 00:33:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hugetlbfs: add err code in initializing module
Message-ID: <20120322003356.GT6589@ZenIV.linux.org.uk>
References: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBK4tx91ZQu0WKzBGx8E-Na6oUwmpBUQVB0yPkR=ySPjg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 01:09:59PM +0800, Hillf Danton wrote:
> Error code is added if fail to create inode kmem cache, and newly registered
> hugetlb FS is unregistered if fail to mount, both for unlikely corner cases.
> 
> --- a/fs/hugetlbfs/inode.c	Sun Mar 11 12:46:38 2012
> +++ b/fs/hugetlbfs/inode.c	Sun Mar 11 12:49:28 2012
> @@ -1000,6 +1000,7 @@ static int __init init_hugetlbfs_fs(void
>  	hugetlbfs_inode_cachep = kmem_cache_create("hugetlbfs_inode_cache",
>  					sizeof(struct hugetlbfs_inode_info),
>  					0, 0, init_once);
> +	error = -ENOMEM;
>  	if (hugetlbfs_inode_cachep == NULL)
>  		goto out2;
> 
> @@ -1015,6 +1016,7 @@ static int __init init_hugetlbfs_fs(void
>  	}
> 
>  	error = PTR_ERR(vfsmount);
> +	unregister_filesystem(&hugetlbfs_fs_type);

Bloody bad idea, that...  Realistically, the proper action on failure here
(as well as in sock_init(), etc.) is panic().  If we fail to OOM that early,
the box is doomed anyway.

Note that unregister_filesystem() in module init is *always* wrong; it's not
an issue here (it's done too early to care about and realistically the box
is not going anywhere - it'll panic when attempt to exec /sbin/init fails,
if not earlier), but it's a damn bad example.

Consider a normal fs module.  Somebody loads it and in parallel with that
we get a mount attempt on that fs type.  It comes between register and
failure exits that causes unregister; at that point we are screwed since
grabbing a reference to module as done by mount is enough to prevent
exit, but not to prevent the failure of init.  As the result, module will
get freed when init fails, mounted fs of that type be damned.

Again, this is not an issue here, but we had a bunch of real races of that
sort - the fixes for those just went in.  We _still_ have b0rken ones -
e.g. fuse and gfs2 are FUBAR in that respect and there's not a damn thing
we can do with the current API - anything that registers several fs types
can fail on the last register_filesystem() and that's it.

BTW, why in the name of everything unholy does hugetlbfs have module_exit()?
	* it's not a module
	* it does kern_mount() in module_init, which pins it down anyway
	* even if it wouldn't bother with kern_mount() (that can be worked
around, by switching to simple_pin_fs() done on demand), we would still have
the code in core kernel calling the functions in there.  Good luck working
around _that_ in a race-free way...
