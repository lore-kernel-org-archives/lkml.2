Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2I1PTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:19:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532Ab2I1PTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:19:39 -0400
Date: Fri, 28 Sep 2012 11:19:29 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: build failure after merge of the akpm tree
In-Reply-To: <20120928163029.19d304240b796e2c7a7d633b@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1209281117580.21946@file.rdu.redhat.com>
References: <20120928163029.19d304240b796e2c7a7d633b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Sep 2012, Stephen Rothwell wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/block_dev.c: In function 'set_blocksize':
> fs/block_dev.c:135:2: error: implicit declaration of function 'prio_tree_empty' [-Werror=implicit-function-declaration]
> 
> Caused by commit b87570f5d349 ("Fix a crash when block device is read and
> block size is changed at the same time") from the block tree interacting
> with commit "prio_tree: remove" from the akpm tree.
> 
> I added the following merge fix patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 28 Sep 2012 16:21:10 +1000
> Subject: [PATCH] prio_tree: fix fs/block_dev.c for removal of prio_tree
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/block_dev.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 246a81e..165b01f 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -27,6 +27,7 @@
>  #include <linux/namei.h>
>  #include <linux/log2.h>
>  #include <linux/cleancache.h>
> +#include <linux/rbtree.h>
>  #include <asm/uaccess.h>
>  #include "internal.h"
>  
> @@ -132,7 +133,7 @@ int set_blocksize(struct block_device *bdev, int size)
>  	/* Check that the block device is not memory mapped */
>  	mapping = bdev->bd_inode->i_mapping;
>  	mutex_lock(&mapping->i_mmap_mutex);
> -	if (!prio_tree_empty(&mapping->i_mmap) ||
> +	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
>  	    !list_empty(&mapping->i_mmap_nonlinear)) {
>  		mutex_unlock(&mapping->i_mmap_mutex);
>  		percpu_up_write(&bdev->bd_block_size_semaphore);
> -- 
> 1.7.10.280.gaa39
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

... or replace it with

if (mapping_mapped(&mapping)) { ...

Mikulas
