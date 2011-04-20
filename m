Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1DTQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:34:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab1DTQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:34:49 -0400
Date: Wed, 20 Apr 2011 09:38:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: simplify destroying inode
Message-Id: <20110420093823.38f1c2fe.akpm@linux-foundation.org>
In-Reply-To: <BANLkTins3c6r0z-WR8PWrVvYa5OdOZ1BGg@mail.gmail.com>
References: <BANLkTins3c6r0z-WR8PWrVvYa5OdOZ1BGg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 11:36:56 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> Just before reclaimed by the hugetlbfs inode cache, little difference
> could be made by initializing the list head of the dentry member of
> vfs inode, thus the operation of initialization could be removed to
> simplify the destroy of hugetlbfs inode.
> 
> Signed-off-by: Hillf Danton <gmail.com>
> ---
> 
> --- a/fs/hugetlbfs/inode.c	2011-03-30 03:09:48.000000000 +0800
> +++ b/fs/hugetlbfs/inode.c	2011-04-04 11:27:30.000000000 +0800
> @@ -665,7 +665,6 @@ static struct inode *hugetlbfs_alloc_ino
>  static void hugetlbfs_i_callback(struct rcu_head *head)
>  {
>  	struct inode *inode = container_of(head, struct inode, i_rcu);
> -	INIT_LIST_HEAD(&inode->i_dentry);
>  	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
>  }

How well was this tested?

hugetlbfs_inode_cachep has a slab constructor,
init_once()->inode_init_once().  The slab protocol requires that
objects be returned to the cache in the same state as that which the
constructor creates.  (It's a bit weird and it would probably be faster
and certainly saner if the ctor were run by kmem_cache_alloc()).

inode_init_once() does INIT_LIST_HEAD(&inode->i_dentry), so objects
should be returned to the cache in that state.  If no other code was
already reliably reinitialising ->i_dentry, the patch will add a bug.

