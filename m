Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0KAJiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:38:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63447 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0KAJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NOiqIO6+av70MDq3uuIui3en1FU184mZeuykaWJEwu69OVORp8SSymb+cSc1iO56+M
         2NRUZ6breEV+JVP2zf8CNPEc4fmViM3AgORbGyY4D422Dh8iyxE2n00tA96Sw9K1NQpN
         bRuAx666CsZjFEMpBeC7NfKBXth/VXBSn0nGY=
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288589624-15251-4-git-send-email-david@fromorbit.com>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
	 <1288589624-15251-4-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 10:38:07 +0100
Message-ID: <1288604287.2660.94.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 novembre 2010 à 16:33 +1100, Dave Chinner a écrit :
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that inodes are using RCU freeing, we can walk the hash lists
> using RCU protection during lookups. Convert all the hash list
> operations to use RCU-based operators and drop the inode_hash_lock
> around pure lookup operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

You probably should copy Paul on this stuff, I added him in Cc, because
SLAB_DESTROY_BY_RCU is really tricky, and Paul review is a must.

> ---
>  fs/inode.c |   89 ++++++++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 57 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 106ec7a..6bead3d 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -50,11 +50,12 @@
>   *   inode->i_lock
>   *
>   * inode_hash_lock
> - *   inode_sb_list_lock
> - *   inode->i_lock
> + *   rcu_read_lock
> + *     inode_sb_list_lock
> + *     inode->i_lock
>   *
>   * iunique_lock
> - *   inode_hash_lock
> + *   rcu_read_lock
>   */
>  
>  /*
> @@ -413,7 +414,7 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
>  
>  	spin_lock(&inode_hash_lock);
>  	spin_lock(&inode->i_lock);
> -	hlist_add_head(&inode->i_hash, b);
> +	hlist_add_head_rcu(&inode->i_hash, b);
>  	spin_unlock(&inode->i_lock);
>  	spin_unlock(&inode_hash_lock);
>  }
> @@ -429,7 +430,7 @@ void remove_inode_hash(struct inode *inode)
>  {
>  	spin_lock(&inode_hash_lock);
>  	spin_lock(&inode->i_lock);
> -	hlist_del_init(&inode->i_hash);
> +	hlist_del_init_rcu(&inode->i_hash);
>  	spin_unlock(&inode->i_lock);
>  	spin_unlock(&inode_hash_lock);
>  }
> @@ -741,26 +742,38 @@ static void __wait_on_freeing_inode(struct inode *inode);
>  static struct inode *find_inode(struct super_block *sb,
>  				struct hlist_head *head,
>  				int (*test)(struct inode *, void *),
> -				void *data)
> +				void *data, bool locked)
>  {
>  	struct hlist_node *node;
>  	struct inode *inode = NULL;
>  
>  repeat:
> +	rcu_read_lock();
>  	hlist_for_each_entry(inode, node, head, i_hash) {
>  		if (inode->i_sb != sb)
>  			continue;
>  		if (!test(inode, data))
>  			continue;
>  		spin_lock(&inode->i_lock);

Problem with SLAB_DESTROY_BY_RCU is the inode can be freed, and reused
immediately (no grace period) by another cpu.

So you need to recheck test(inode, data) _after_ getting a stable
reference on the inode (spin_lock() in this case), to make sure you
indeed found the inode you are looking for, not another one.

The test on inode->i_sb != sb can be omitted, _if_ each sb has its own
kmem_cache (but I am not sure, please check if this is the case)

Also, you should make sure the allocation of inode is careful of not
overwriting some fields (the i_lock in particular), since you could
break a concurrent lookup. This is really tricky, you cannot use
spin_lock_init(&inode->i_lock) anymore in inode_init_always().

You can read Documentation/RCU/rculist_nulls.txt for some doc I wrote
when adding SLAB_DESTROY_BY_RCU to UDP/TCP sockets. Sockets stable
reference is not a spinlock, but a refcount, so it was easier to init
this refcount. With a spinlock, I believe you might need to use SLAB
constructor, to initialize the spinlock only on fresh objects, not on
reused ones.

> +		if (inode_unhashed(inode)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
> +			rcu_read_unlock();
> +			if (locked)
> +				spin_unlock(&inode_hash_lock);
>  			__wait_on_freeing_inode(inode);
> +			if (locked)
> +				spin_lock(&inode_hash_lock);
>  			goto repeat;
>  		}
>  		__iget(inode);
>  		spin_unlock(&inode->i_lock);
> +		rcu_read_unlock();
>  		return inode;
>  	}
> +	rcu_read_unlock();
>  	return NULL;
>  }
>  
> @@ -769,26 +782,39 @@ repeat:
>   * iget_locked for details.
>   */
>  static struct inode *find_inode_fast(struct super_block *sb,
> -				struct hlist_head *head, unsigned long ino)
> +				struct hlist_head *head, unsigned long ino,
> +				bool locked)
>  {
>  	struct hlist_node *node;
>  	struct inode *inode = NULL;
>  
>  repeat:
> +	rcu_read_lock();
>  	hlist_for_each_entry(inode, node, head, i_hash) {
>  		if (inode->i_ino != ino)
>  			continue;
>  		if (inode->i_sb != sb)
>  			continue;
>  		spin_lock(&inode->i_lock);

same here, you must recheck if (inode->i_ino != ino)

> +		if (inode_unhashed(inode)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}
>  		if (inode->i_state & (I_FREEING|I_WILL_FREE)) {
> +			rcu_read_unlock();
> +			if (locked)
> +				spin_unlock(&inode_hash_lock);
>  			__wait_on_freeing_inode(inode);
> +			if (locked)
> +				spin_lock(&inode_hash_lock);
>  			goto repeat;
>  		}
>  		__iget(inode);
>  		spin_unlock(&inode->i_lock);
> +		rcu_read_unlock();
>  		return inode;
>  	}
> +	rcu_read_unlock();
>  	return NULL;
>  }
>  
> @@ -913,14 +939,14 @@ static struct inode *get_new_inode(struct super_block *sb,
>  
>  		spin_lock(&inode_hash_lock);
>  		/* We released the lock, so.. */
> -		old = find_inode(sb, head, test, data);
> +		old = find_inode(sb, head, test, data, true);
>  		if (!old) {
>  			if (set(inode, data))
>  				goto set_failed;
>  
>  			spin_lock(&inode->i_lock);
>  			inode->i_state = I_NEW;
> -			hlist_add_head(&inode->i_hash, head);
> +			hlist_add_head_rcu(&inode->i_hash, head);
>  			spin_unlock(&inode->i_lock);
>  			inode_sb_list_add(inode);
>  			spin_unlock(&inode_hash_lock);
> @@ -964,12 +990,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
>  
>  		spin_lock(&inode_hash_lock);
>  		/* We released the lock, so.. */
> -		old = find_inode_fast(sb, head, ino);
> +		old = find_inode_fast(sb, head, ino, true);
>  		if (!old) {
>  			inode->i_ino = ino;
>  			spin_lock(&inode->i_lock);
>  			inode->i_state = I_NEW;
> -			hlist_add_head(&inode->i_hash, head);
> +			hlist_add_head_rcu(&inode->i_hash, head);
>  			spin_unlock(&inode->i_lock);
>  			inode_sb_list_add(inode);
>  			spin_unlock(&inode_hash_lock);
> @@ -1006,15 +1032,22 @@ static int test_inode_iunique(struct super_block *sb, unsigned long ino)
>  	struct hlist_node *node;
>  	struct inode *inode;
>  
> -	spin_lock(&inode_hash_lock);
> -	hlist_for_each_entry(inode, node, b, i_hash) {
> -		if (inode->i_ino == ino && inode->i_sb == sb) {
> -			spin_unlock(&inode_hash_lock);
> -			return 0;
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(inode, node, b, i_hash) {
> +		if (inode->i_ino != ino)
> +			continue;
> +		if (inode->i_sb != sb)
> +			continue;
> +		spin_lock(&inode->i_lock);

same here

> +		if (inode_unhashed(inode)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
>  		}
> +		spin_unlock(&inode->i_lock);
> +		rcu_read_unlock();
> +		return 0;
>  	}
> -	spin_unlock(&inode_hash_lock);
> -
> +	rcu_read_unlock();
>  	return 1;
>  }


