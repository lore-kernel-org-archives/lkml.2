Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0F1VuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:50:17 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51545 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0F1VuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:50:15 -0400
Date: Mon, 28 Jun 2010 14:50:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 24/52] fs: dcache reduce d_parent locking
Message-ID: <20100628215013.GG2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100624030212.676457061@suse.de>
 <20100624030729.395195069@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624030729.395195069@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:02:36PM +1000, npiggin@suse.de wrote:
> Use RCU property of dcache to simplify locking in some places where we
> take d_parent and d_lock.
> 
> Comment: don't need rcu_deref because we take the spinlock and recheck it.

Looks good other than one question below.

							Thanx, Paul

> Signed-off-by: Nick Piggin <npiggin@suse.de>
> --
> 
> Index: linux-2.6/fs/dcache.c
> ===================================================================
> --- linux-2.6.orig/fs/dcache.c
> +++ linux-2.6/fs/dcache.c
> @@ -311,23 +311,18 @@ struct dentry *dget_parent(struct dentry
>  	struct dentry *ret;
> 
>  repeat:
> -	spin_lock(&dentry->d_lock);
> +	rcu_read_lock();
>  	ret = dentry->d_parent;

Doesn't this need to be as follows?

	ret = rcu_dereference(dentry)->d_parent;

Otherwise, couldn't we end up seeing pre-initialization value for
->d_parent for a newly inserted dentry?

> -	if (!ret)
> -		goto out;
> -	if (dentry == ret) {
> -		ret->d_count++;
> -		goto out;
> -	}
> -	if (!spin_trylock(&ret->d_lock)) {
> -		spin_unlock(&dentry->d_lock);
> +	spin_lock(&ret->d_lock);

Once we do this, however, we are golden, at least for all dentry
fields protected by ->lock.  This does assume that the compiler does not
speculate the fetch that initialized the argument dentry into the critical
section, which I would sure hope would be a reasonable assumption.

> +	if (unlikely(ret != dentry->d_parent)) {
> +		spin_unlock(&ret->d_lock);
> +		rcu_read_unlock();
>  		goto repeat;
>  	}
> +	rcu_read_unlock();
>  	BUG_ON(!ret->d_count);
>  	ret->d_count++;
>  	spin_unlock(&ret->d_lock);
> -out:
> -	spin_unlock(&dentry->d_lock);
>  	return ret;
>  }
>  EXPORT_SYMBOL(dget_parent);
> @@ -601,14 +596,22 @@ static void prune_one_dentry(struct dent
>  		if (inode)
>  			spin_lock(&inode->i_lock);
>  again:
> -		spin_lock(&dentry->d_lock);
> -		if (dentry->d_parent && dentry != dentry->d_parent) {
> -			if (!spin_trylock(&dentry->d_parent->d_lock)) {
> -				spin_unlock(&dentry->d_lock);
> +		rcu_read_lock();
> +		parent = dentry->d_parent;
> +		if (parent) {
> +			spin_lock(&parent->d_lock);
> +			if (unlikely(parent != dentry->d_parent)) {
> +				spin_unlock(&parent->d_lock);
> +				rcu_read_unlock();
>  				goto again;
>  			}
> - 			parent = dentry->d_parent;
> -		}
> +			if (parent != dentry)
> +				spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
> +			else
> +				parent = NULL;
> +		} else
> +			spin_lock(&dentry->d_lock);
> +		rcu_read_unlock();
>  		dentry->d_count--;
>  		if (dentry->d_count) {
>  			if (parent)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
