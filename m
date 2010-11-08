Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0KHIxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 03:53:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab0KHIxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 03:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tG0vsWs9ao2zYalE0Vd6nR7c10ULIdnq0AN5W3WhtEEP5BiHXjWA87m6fS7dwCi8lv
         v5Q7T6nh+csZ6eLmCO+/6U5RRHaHwQwMTp74RsDj1gZerpDqYVR60r26f+RmF1tkzck0
         GBvvWmlRe8i1rwi0nhrN/vLcMA5NsFzFPSErw=
Subject: Re: [PATCH 4/4] fs: rcu protect inode hash lookups
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <1289201305-14866-5-git-send-email-david@fromorbit.com>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
	 <1289201305-14866-5-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 09:53:41 +0100
Message-ID: <1289206421.2820.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 novembre 2010 à 18:28 +1100, Dave Chinner a écrit :
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that inodes are using RCU freeing, we can walk the hash lists
> using RCU protection during lookups. Convert all the hash list
> operations to use RCU-based operators and drop the inode_hash_lock
> around pure lookup operations.
> 
> Because we are using SLAB_DESTROY_BY_RCU, we need to be careful
> about the lockless lookups and the way we initialise the struct
> inode during allocation. The inode->i_lock is the critical item we
> need to avoid touching when allocating an inode, so move the
> initialisation of this lock to the slab constructor so that we can
> reliably use the lock even after the inode has been freed or is in
> the process of being allocated or initialised.
> 
> We also need to change the order of checks during hash lookups to
> validate we have an active inode before we skip it. That means we
> need to revalidate the inode number and superblock after we have
> checked it for being freed or unhashed under the inode->i_lock.
> 
> Finally, during traversals an inode can be freed and reallocated and
> linked into a new hash chain, so an RCU safe traversal can jump to a
> different chain without indication. On a cache miss we need to
> validate that we ended the search on the same hash chain we started
> on. Do this by converting the hash lists to the hlist_null list type
> and checking the list null on walk termination.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Very nice stuff Dave !

I have one question

> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> index 5d10ae36..29762d1 100644
> --- a/include/linux/list_nulls.h
> +++ b/include/linux/list_nulls.h
> @@ -83,6 +83,13 @@ static inline void hlist_nulls_del(struct hlist_nulls_node *n)
>  	n->pprev = LIST_POISON2;
>  }
>  
> +/* after that we'll appear to be on some hlist and hlist_nulls_del will work */
> +static inline void hlist_nulls_add_fake(struct hlist_nulls_node *n)
> +{
> +	n->next = (struct hlist_nulls_node *)1UL;
> +	n->pprev = &n->next;
> +}
> +


I am not sure why you need to change n->next here ?

This might restart lookups (making them doing a 'goto repeat', and
possibly abort a lookup on slot 0 of hash chain, since this is a 'nulls'
value for slot 0.

So at least I suggest adding a comment, and possibly use a different
slot number (outside of slot ranges). If so, change documentation to
restrict to 2^(BITS_PER_LONG-2) number of possible slots in hash table.

n->next = (struct hlist_nulls_node *)(1UL | (1UL << (BITS_PER_LONG-1));



