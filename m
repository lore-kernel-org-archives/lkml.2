Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FJCXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 22:23:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0FJCXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 22:23:30 -0400
Message-ID: <4C104CBE.8060404@cn.fujitsu.com>
Date: Thu, 10 Jun 2010 10:23:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] ksm: cleanup for mm_slots_hash
References: <4BFF66CC.4050204@cn.fujitsu.com>
In-Reply-To: <4BFF66CC.4050204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Izik

Could you give some comments about this patch.
Thanks,

Lai

Lai Jiangshan wrote:
> Use compile-allocated memory instead of dynamic allocated
> memory for mm_slots_hash.
> 
> Use hash_ptr() instead divisions for bucket calculation.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 8cdfc2a..81b379e 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -33,6 +33,7 @@
>  #include <linux/mmu_notifier.h>
>  #include <linux/swap.h>
>  #include <linux/ksm.h>
> +#include <linux/hash.h>
>  
>  #include <asm/tlbflush.h>
>  #include "internal.h"
> @@ -153,8 +154,9 @@ struct rmap_item {
>  static struct rb_root root_stable_tree = RB_ROOT;
>  static struct rb_root root_unstable_tree = RB_ROOT;
>  
> -#define MM_SLOTS_HASH_HEADS 1024
> -static struct hlist_head *mm_slots_hash;
> +#define MM_SLOTS_HASH_SHIFT 10
> +#define MM_SLOTS_HASH_HEADS (1 << MM_SLOTS_HASH_SHIFT)
> +static struct hlist_head mm_slots_hash[MM_SLOTS_HASH_HEADS];
>  
>  static struct mm_slot ksm_mm_head = {
>  	.mm_list = LIST_HEAD_INIT(ksm_mm_head.mm_list),
> @@ -269,28 +271,13 @@ static inline void free_mm_slot(struct mm_slot *mm_slot)
>  	kmem_cache_free(mm_slot_cache, mm_slot);
>  }
>  
> -static int __init mm_slots_hash_init(void)
> -{
> -	mm_slots_hash = kzalloc(MM_SLOTS_HASH_HEADS * sizeof(struct hlist_head),
> -				GFP_KERNEL);
> -	if (!mm_slots_hash)
> -		return -ENOMEM;
> -	return 0;
> -}
> -
> -static void __init mm_slots_hash_free(void)
> -{
> -	kfree(mm_slots_hash);
> -}
> -
>  static struct mm_slot *get_mm_slot(struct mm_struct *mm)
>  {
>  	struct mm_slot *mm_slot;
>  	struct hlist_head *bucket;
>  	struct hlist_node *node;
>  
> -	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
> -				% MM_SLOTS_HASH_HEADS];
> +	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
>  	hlist_for_each_entry(mm_slot, node, bucket, link) {
>  		if (mm == mm_slot->mm)
>  			return mm_slot;
> @@ -303,8 +290,7 @@ static void insert_to_mm_slots_hash(struct mm_struct *mm,
>  {
>  	struct hlist_head *bucket;
>  
> -	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
> -				% MM_SLOTS_HASH_HEADS];
> +	bucket = &mm_slots_hash[hash_ptr(mm, MM_SLOTS_HASH_SHIFT)];
>  	mm_slot->mm = mm;
>  	hlist_add_head(&mm_slot->link, bucket);
>  }
> @@ -1943,15 +1929,11 @@ static int __init ksm_init(void)
>  	if (err)
>  		goto out;
>  
> -	err = mm_slots_hash_init();
> -	if (err)
> -		goto out_free1;
> -
>  	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
>  	if (IS_ERR(ksm_thread)) {
>  		printk(KERN_ERR "ksm: creating kthread failed\n");
>  		err = PTR_ERR(ksm_thread);
> -		goto out_free2;
> +		goto out_free;
>  	}
>  
>  #ifdef CONFIG_SYSFS
> @@ -1959,7 +1941,7 @@ static int __init ksm_init(void)
>  	if (err) {
>  		printk(KERN_ERR "ksm: register sysfs failed\n");
>  		kthread_stop(ksm_thread);
> -		goto out_free2;
> +		goto out_free;
>  	}
>  #else
>  	ksm_run = KSM_RUN_MERGE;	/* no way for user to start it */
> @@ -1975,9 +1957,7 @@ static int __init ksm_init(void)
>  #endif
>  	return 0;
>  
> -out_free2:
> -	mm_slots_hash_free();
> -out_free1:
> +out_free:
>  	ksm_slab_free();
>  out:
>  	return err;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

