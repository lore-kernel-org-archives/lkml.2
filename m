Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1DTUF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:05:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755933Ab1DTUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:05:57 -0400
Date: Wed, 20 Apr 2011 13:04:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tmpfs: fix race between umount and writepage
Message-Id: <20110420130453.3985144c.akpm@linux-foundation.org>
In-Reply-To: <20110405103452.18737.28363.stgit@localhost6>
References: <20110405103452.18737.28363.stgit@localhost6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 14:34:52 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> shmem_writepage() call igrab() on the inode for the page which is came from
> reclaimer to add it later into shmem_swaplist for swap-unuse operation.
> 
> This igrab() can race with super-block deactivating process:
> 
> shrink_inactive_list()		deactivate_super()
> pageout()			tmpfs_fs_type->kill_sb()
> shmem_writepage()		kill_litter_super()
> 				generic_shutdown_super()
> 				 evict_inodes()
>  igrab()
> 				  atomic_read(&inode->i_count)
> 				   skip-inode
>  iput()
> 				 if (!list_empty(&sb->s_inodes))
> 					printk("VFS: Busy inodes after...

Generally, ->writepage implementations shouldn't play with the inode,
for the reasons you've discovered.  A more common race is
writepage-versus-reclaim, where writepage is playing with the inode
when a concurrent reclaim frees the inode (and hence the
address_space).

It is safe to play with the inode while the passed-in page is locked
because nobody will free an inode which has an attached locked page. 
But once the page is unlocked, nothing pins the inode.  Typically,
tmpfs goes and breakes this rule.


Question is: why is shmem_writepage() doing the igrab/iput?

Read 1b1b32f2c6f6bb3253 and weep.

That changelog is a little incorrect:

: Ah, I'd never suspected it, but shmem_writepage's swaplist manipulation
: is unsafe: though still hold page lock, which would hold off inode
: deletion if the page were i pagecache, it doesn't hold off once it's in
: swapcache (free_swap_and_cache doesn't wait on locked pages).  Hmm: we
: could put the the inode on swaplist earlier, but then shmem_unuse_inode
: could never prune unswapped inodes.

We don't actually hold the page lock when altering the swaplist:
swap_writepage() unlocks the page.  Doesn't seem to matter.


I think we should get the igrab/iput out of there and come up with a
different way of pinning the inode in ->writepage().

Can we do it in this order?

	mutex_lock(&shmem_swaplist_mutex);
	list_move_tail(&info->swaplist, &shmem_swaplist);
	delete_from_page_cache(page);
	shmem_swp_set(info, entry, swap.val);
	shmem_swp_unmap(entry);
	mutex_unlock(&shmem_swaplist_mutex);
	swap_writepage(page, wbc);									

