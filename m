Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab0J0HKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:10:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60240 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0J0HKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:10:02 -0400
Message-ID: <4CC7CFDD.10807@ontolinux.com>
Date: Wed, 27 Oct 2010 09:08:13 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] fs: Lock the inode LRU list separately
References: <1288153384-8878-1-git-send-email-david@fromorbit.com> <1288153384-8878-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1288153384-8878-4-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:EQLisecrMXBBVw80IBftmdCqIzKxU+ZmFMSMWmQx7X4
 o3pOAFfGadwSQTwJjpIt260WBz+Zf6U7GDrg4XMw3N5YJWwcie
 Nd7oVvy8OcbexNDzjExoQgtFrFkNGLnAN8MHNfoTRmr78NU55k
 ZWaRGWs6IsH1fjXCWFqJBPYS2P5wZ/7rOGxqna81FGmXYhW3It
 XxqAwATT1mmVHoe76yLVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  some typos

On the 27.10.2010 06:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Introduce the inode_lru_lock to protect the inode_lru list. This
> lock is nested inside the inode->i_lock to allow the inode to be
> added to the LRU list in iput_final without needing to deal with
> lock inversions. This keeps iput_final() clean and neat.
>
> Further, where marking the inode I_FREEING and removing it from the
> LRU, move the LRU list manipulation within the inode->i_lock to keep
> the list manipulation consistent with iput_final. This also means
> that most of the open coded LRU list removal + unused inode
> accounting can now use the inode_lru_list_del() wrappers which
> cleans the code up further.
>
> However, this locking change means what the LRU traversal in
> prune_icache() inverts this lock ordering and needs to use trylock
> semantics on the inode->i_lock to avoid deadlocking. In these cases,
> if we fail to lock the inode we move it to the back of the LRU to
> prevent spinning on it.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/inode.c |   45 +++++++++++++++++++++++++++++----------------
>   1 files changed, 29 insertions(+), 16 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index f134aa4..e04371e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -30,10 +30,13 @@
>    *
>    * inode->i_lock protects:
>    *   i_state
> + * inode_lru_lock protects:
> + *   inode_lru, i_lru
>    *
>    * Lock ordering:
>    * inode_lock
>    *   inode->i_lock
> + *     inode_lru_lock
>    */
>
>   /*
> @@ -83,6 +86,7 @@ static unsigned int i_hash_shift __read_mostly;
>    */
>
>   static LIST_HEAD(inode_lru);
> +static DEFINE_SPINLOCK(inode_lru_lock);
>   static struct hlist_head *inode_hashtable __read_mostly;
>
>   /*
> @@ -344,16 +348,20 @@ EXPORT_SYMBOL(ihold);
>   static void inode_lru_list_add(struct inode *inode)
>   {
>   	if (list_empty(&inode->i_lru)) {
> +		spin_lock(&inode_lru_lock);
>   		list_add(&inode->i_lru,&inode_lru);
>   		percpu_counter_inc(&nr_inodes_unused);
> +		spin_unlock(&inode_lru_lock);
>   	}
>   }
>
>   static void inode_lru_list_del(struct inode *inode)
>   {
>   	if (!list_empty(&inode->i_lru)) {
> +		spin_lock(&inode_lru_lock);
>   		list_del_init(&inode->i_lru);
>   		percpu_counter_dec(&nr_inodes_unused);
> +		spin_unlock(&inode_lru_lock);
>   	}
>   }
>
> @@ -537,15 +545,10 @@ void evict_inodes(struct super_block *sb)
>   		}
>
>   		inode->i_state |= I_FREEING;
> -		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
> +		inode_lru_list_del(inode);
>   		spin_unlock(&inode->i_lock);
>
> -		/*
> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> -		 */
> -		list_move(&inode->i_lru,&dispose);
> +		list_add(&inode->i_lru,&dispose);
>   	}
>   	spin_unlock(&inode_lock);
>
> @@ -582,15 +585,10 @@ int invalidate_inodes(struct super_block *sb)
>   		}
>
>   		inode->i_state |= I_FREEING;
> -		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
> +		inode_lru_list_del(inode);
>   		spin_unlock(&inode->i_lock);
>
> -		/*
> -		 * Move the inode off the IO lists and LRU once I_FREEING is
> -		 * set so that it won't get moved back on there if it is dirty.
> -		 */
> -		list_move(&inode->i_lru,&dispose);
> +		list_add(&inode->i_lru,&dispose);
>   	}
>   	spin_unlock(&inode_lock);
>
> @@ -637,6 +635,7 @@ static void prune_icache(int nr_to_scan)
>
>   	down_read(&iprune_sem);
>   	spin_lock(&inode_lock);
> +	spin_lock(&inode_lru_lock);
>   	for (nr_scanned = 0; nr_scanned<  nr_to_scan; nr_scanned++) {
>   		struct inode *inode;
>
> @@ -646,10 +645,19 @@ static void prune_icache(int nr_to_scan)
>   		inode = list_entry(inode_lru.prev, struct inode, i_lru);
>
>   		/*
> +		 * we are inverting the inode_lru_lock/inode->i_lock here,
> +		 * so use a trylock. If we fail to get the lock, just move the
, then just move
or
, then move
> +		 * inode to the back of the list so we don't spin on it.
> +		 */
> +		if (!spin_trylock(&inode->i_lock)) {
> +			list_move(&inode->i_lru,&inode_lru);
> +			continue;
> +		}
> +
> +		/*
>   		 * Referenced or dirty inodes are still in use. Give them
>   		 * another pass through the LRU as we canot reclaim them now.
cannot
>   		*/
> -		spin_lock(&inode->i_lock);
>   		if (atomic_read(&inode->i_count) ||
>   		    (inode->i_state&  ~I_REFERENCED)) {
>   			spin_unlock(&inode->i_lock);
> @@ -668,17 +676,21 @@ static void prune_icache(int nr_to_scan)
>   		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
>   			__iget(inode);
>   			spin_unlock(&inode->i_lock);
> +			spin_unlock(&inode_lru_lock);
>   			spin_unlock(&inode_lock);
>   			if (remove_inode_buffers(inode))
>   				reap += invalidate_mapping_pages(&inode->i_data,
>   								0, -1);
>   			iput(inode);
>   			spin_lock(&inode_lock);
> +			spin_lock(&inode_lru_lock);
>
>   			if (inode != list_entry(inode_lru.next,
>   						struct inode, i_lru))
>   				continue;	/* wrong inode or list_empty */
> -			spin_lock(&inode->i_lock);
> +			/* avoid lock inversions with trylock */
> +			if (!spin_trylock(&inode->i_lock))
> +				continue;
>   			if (!can_unuse(inode)) {
>   				spin_unlock(&inode->i_lock);
>   				continue;
> @@ -699,6 +711,7 @@ static void prune_icache(int nr_to_scan)
>   		__count_vm_events(KSWAPD_INODESTEAL, reap);
>   	else
>   		__count_vm_events(PGINODESTEAL, reap);
> +	spin_unlock(&inode_lru_lock);
>   	spin_unlock(&inode_lock);
>
>   	dispose_list(&freeable);

