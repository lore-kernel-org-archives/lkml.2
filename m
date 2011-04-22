Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846Ab1DVEFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 00:05:51 -0400
Received: from relay.parallels.com ([195.214.232.42]:39665 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1DVEFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 00:05:41 -0400
Message-ID: <4DB0FE8F.9070407@parallels.com>
Date: Fri, 22 Apr 2011 08:05:35 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tmpfs: fix race between umount and writepage
References: <4DAFD0B1.9090603@parallels.com>	<20110421064150.6431.84511.stgit@localhost6> <20110421124424.0a10ed0c.akpm@linux-foundation.org>
In-Reply-To: <20110421124424.0a10ed0c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 21 Apr 2011 10:41:50 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> shmem_writepage() call igrab() on the inode for the page which is came from
>> reclaimer to add it later into shmem_swaplist for swap-unuse operation.
>>
>> This igrab() can race with super-block deactivating process:
>>
>> shrink_inactive_list()		deactivate_super()
>> pageout()			tmpfs_fs_type->kill_sb()
>> shmem_writepage()		kill_litter_super()
>> 				generic_shutdown_super()
>> 				 evict_inodes()
>>   igrab()
>> 				  atomic_read(&inode->i_count)
>> 				   skip-inode
>>   iput()
>> 				 if (!list_empty(&sb->s_inodes))
>> 					printk("VFS: Busy inodes after...
>>
>> This igrap-iput pair was added in commit 1b1b32f2c6f6bb3253
>> based on incorrect assumptions:
>>
>> : Ah, I'd never suspected it, but shmem_writepage's swaplist manipulation
>> : is unsafe: though still hold page lock, which would hold off inode
>> : deletion if the page were i pagecache, it doesn't hold off once it's in
>> : swapcache (free_swap_and_cache doesn't wait on locked pages).  Hmm: we
>> : could put the the inode on swaplist earlier, but then shmem_unuse_inode
>> : could never prune unswapped inodes.
>>
>> Attached locked page actually protect inode from deletion because
>> truncate_inode_pages_range() will sleep on this, so igrab not required.
>> This patch actually revert last hunk from that commit.
>>
>
> hm, is that last paragraph true?  Let's look at the resulting code.
>
>
> : 	if (swap.val&&  add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
> : 		delete_from_page_cache(page);
>
> Here, the page is removed from inode->i_mapping.  So
> truncate_inode_pages() won't see that page and will not block on its
> lock.

Oops, right. Sorry. It produce use-after-free race, but it is quiet and small.
My test is using too few files to catch it in a reasonable time,
and I ran it without slab poisoning.

So, v1 patch is correct but little ugly, while v2 -- broken.

>
> : 		shmem_swp_set(info, entry, swap.val);
> : 		shmem_swp_unmap(entry);
> : 		spin_unlock(&info->lock);
> : 		if (list_empty(&info->swaplist)) {
> : 			mutex_lock(&shmem_swaplist_mutex);
> : 			/* move instead of add in case we're racing */
> : 			list_move_tail(&info->swaplist,&shmem_swaplist);
> : 			mutex_unlock(&shmem_swaplist_mutex);
> : 		}
>
> Here, the code plays with `info', which points at storage which is
> embedded within the inode's filesystem-private part.
>
> But because the inode now has no attached locked page, a concurrent
> umount can free the inode while this code is using it.

I guess we can try to put delete_from_page_cache(page); right before swap_writepage
but it move it outside info->lock...

>
> : 		swap_shmem_alloc(swap);
> : 		BUG_ON(page_mapped(page));
> : 		swap_writepage(page, wbc);
> : 		return 0;
> : 	}
>
> However, I assume that you reran your testcase with the v2 patch and
> that things ran OK.  How come?  Either my analysis is wrong or the
> testcase doesn't trigger races in this code path?
>
