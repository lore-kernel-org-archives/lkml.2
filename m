Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2LRDb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 22:31:59 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:38663 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2LRDb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 22:31:58 -0500
Date: Mon, 17 Dec 2012 19:25:35 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] mm,ksm: use new hashtable implementation
In-Reply-To: <1355756497-15834-2-git-send-email-sasha.levin@oracle.com>
Message-ID: <alpine.LNX.2.00.1212171923440.5826@eggly.anvils>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com> <1355756497-15834-2-git-send-email-sasha.levin@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Sasha Levin wrote:
> Switch ksm to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in the ksm module.
> 
> This patch depends on d9b482c ("hashtable: introduce a small and naive
> hashtable") which was merged in v3.6.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

This seems fine, thanks:
except please drop that irrelevant final hunk to ksm_init(), then
Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/ksm.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 382d930..e888f54 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -33,7 +33,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/swap.h>
>  #include <linux/ksm.h>
> -#include <linux/hash.h>
> +#include <linux/hashtable.h>
>  #include <linux/freezer.h>
>  #include <linux/oom.h>
>  
> @@ -156,9 +156,8 @@ struct rmap_item {
>  static struct rb_root root_stable_tree = RB_ROOT;
>  static struct rb_root root_unstable_tree = RB_ROOT;
>  
> -#define MM_SLOTS_HASH_SHIFT 10
> -#define MM_SLOTS_HASH_HEADS (1 << MM_SLOTS_HASH_SHIFT)
> -static struct hlist_head mm_slots_hash[MM_SLOTS_HASH_HEADS];
> +#define MM_SLOTS_HASH_BITS 10
> +static DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>  
>  static struct mm_slot ksm_mm_head = {
>  	.mm_list = LIST_HEAD_INIT(ksm_mm_head.mm_list),
> @@ -275,26 +274,21 @@ static inline void free_mm_slot(struct mm_slot *mm_slot)
>  
>  static struct mm_slot *get_mm_slot(struct mm_struct *mm)
>  {
> -	struct mm_slot *mm_slot;
> -	struct hlist_head *bucket;
>  	struct hlist_node *node;
> +	struct mm_slot *slot;
> +
> +	hash_for_each_possible(mm_slots_hash, slot, node, link, (unsigned long)mm) 
> +		if (slot->mm == mm)
> +			return slot;
>  
> -	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
> -	hlist_for_each_entry(mm_slot, node, bucket, link) {
> -		if (mm == mm_slot->mm)
> -			return mm_slot;
> -	}
>  	return NULL;
>  }
>  
>  static void insert_to_mm_slots_hash(struct mm_struct *mm,
>  				    struct mm_slot *mm_slot)
>  {
> -	struct hlist_head *bucket;
> -
> -	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
>  	mm_slot->mm = mm;
> -	hlist_add_head(&mm_slot->link, bucket);
> +	hash_add(mm_slots_hash, &mm_slot->link, (unsigned long)mm);
>  }
>  
>  static inline int in_stable_tree(struct rmap_item *rmap_item)
> @@ -647,7 +641,7 @@ static int unmerge_and_remove_all_rmap_items(void)
>  		ksm_scan.mm_slot = list_entry(mm_slot->mm_list.next,
>  						struct mm_slot, mm_list);
>  		if (ksm_test_exit(mm)) {
> -			hlist_del(&mm_slot->link);
> +			hash_del(&mm_slot->link);
>  			list_del(&mm_slot->mm_list);
>  			spin_unlock(&ksm_mmlist_lock);
>  
> @@ -1392,7 +1386,7 @@ next_mm:
>  		 * or when all VM_MERGEABLE areas have been unmapped (and
>  		 * mmap_sem then protects against race with MADV_MERGEABLE).
>  		 */
> -		hlist_del(&slot->link);
> +		hash_del(&slot->link);
>  		list_del(&slot->mm_list);
>  		spin_unlock(&ksm_mmlist_lock);
>  
> @@ -1559,7 +1553,7 @@ void __ksm_exit(struct mm_struct *mm)
>  	mm_slot = get_mm_slot(mm);
>  	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
>  		if (!mm_slot->rmap_list) {
> -			hlist_del(&mm_slot->link);
> +			hash_del(&mm_slot->link);
>  			list_del(&mm_slot->mm_list);
>  			easy_to_free = 1;
>  		} else {
> @@ -2035,6 +2029,7 @@ static int __init ksm_init(void)
>  	 */
>  	hotplug_memory_notifier(ksm_memory_callback, 100);
>  #endif
> +
>  	return 0;
>  
>  out_free:
> -- 
> 1.8.0
