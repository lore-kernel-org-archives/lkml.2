Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0FXR0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:26:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50105 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0FXR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:26:48 -0400
Subject: Re: [patch 16/52] fs: dcache RCU for multi-step operaitons
From: john stultz <johnstul@us.ibm.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100624030728.129875799@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030728.129875799@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 10:26:37 -0700
Message-ID: <1277400397.15264.34.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> plain text document attachment (fs-dcache_lock-multi-step.patch)
> The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> operations over the directory tree by excluding modifications to the tree.
> Also, to walk in the leaf->root direction in the tree where we don't have
> a natural d_lock ordering.
> 
> This could be accomplished by taking every d_lock, but this would mean a
> huge number of locks and actually gets very tricky.
> 
> Solve this instead by using the rename seqlock for multi-step read-side
> operations. Insert operations are not serialised. Delete operations are
> tricky when walking up the directory our parent might have been deleted
> when dropping locks so also need to check and retry for that.
> 
> XXX: hmm, we could of course just take the rename lock if there is any worry
> about livelock. Most of these are slow paths.

I'll try to point out exactly the spot I think we were hitting in the
-rt tree (once the dcache_lock is removed).


> @@ -1030,9 +1056,15 @@ EXPORT_SYMBOL(have_submounts);
>   */
>  static int select_parent(struct dentry * parent)
>  {
> -	struct dentry *this_parent = parent;
> +	struct dentry *this_parent;
>  	struct list_head *next;
> -	int found = 0;
> +	unsigned seq;
> +	int found;
> +
> +rename_retry:
> +	found = 0;
> +	this_parent = parent;
> +	seq = read_seqbegin(&rename_lock);
> 
>  	spin_lock(&dcache_lock);
>  	spin_lock(&this_parent->d_lock);
> @@ -1043,7 +1075,6 @@ resume:
>  		struct list_head *tmp = next;
>  		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
>  		next = tmp->next;
> -		BUG_ON(this_parent == dentry);
> 
>  		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
>  		dentry_lru_del_init(dentry);
> @@ -1084,17 +1115,33 @@ resume:
>  	 */
>  	if (this_parent != parent) {
>  		struct dentry *tmp;
> -		next = this_parent->d_u.d_child.next;
> +		struct dentry *child;
> +
>  		tmp = this_parent->d_parent;
> +		rcu_read_lock();
>  		spin_unlock(&this_parent->d_lock);
> -		BUG_ON(tmp == this_parent);
> +		child = this_parent;
>  		this_parent = tmp;

Ok. So right here, we get preempted, or dput() is called by another cpu
on the child dentry, or the child->d_u.d_child.next dentry and its
d_kill'ed.

>  		spin_lock(&this_parent->d_lock);
> +		/* might go back up the wrong parent if we have had a rename
> +		 * or deletion */
> +		if (this_parent != child->d_parent ||
> +				// d_unlinked(this_parent) || XXX
> +				read_seqretry(&rename_lock, seq)) {
> +			spin_unlock(&this_parent->d_lock);
> +			spin_unlock(&dcache_lock);
> +			rcu_read_unlock();
> +			goto rename_retry;
> +		}
> +		rcu_read_unlock();
> +		next = child->d_u.d_child.next;

Then at this point, next may point to junk. 

>  		goto resume;
>  	}
>  out:
>  	spin_unlock(&this_parent->d_lock);
>  	spin_unlock(&dcache_lock);
> +	if (read_seqretry(&rename_lock, seq))
> +		goto rename_retry;
>  	return found;
>  }


thanks
-john


