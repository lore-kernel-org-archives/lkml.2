Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab1CBBBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:01:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546Ab1CBBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:01:53 -0500
Date: Tue, 1 Mar 2011 17:01:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Meyerriecks <rmeyerriecks@digium.com>
Cc: sruffell@digium.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mm/dmapool.c: Do not create/destroy sysfs file while
 holding pools_lock
Message-Id: <20110301170117.258e06e2.akpm@linux-foundation.org>
In-Reply-To: <20110228224124.GA31769@blackmagic.digium.internal>
References: <20110228224124.GA31769@blackmagic.digium.internal>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 16:41:24 -0600
Russ Meyerriecks <rmeyerriecks@digium.com> wrote:

> From: Shaun Ruffell <sruffell@digium.com>
> 
> Eliminates a circular lock dependency reported by lockdep. When reading the
> "pools" file from a PCI device via sysfs, the s_active lock is acquired before
> the pools_lock. When unloading the driver and destroying the pool, pools_lock
> is acquired before the s_active lock.
> 
>  cat/12016 is trying to acquire lock:
>   (pools_lock){+.+.+.}, at: [<c04ef113>] show_pools+0x43/0x140
> 
>  but task is already holding lock:
>   (s_active#82){++++.+}, at: [<c0554e1b>] sysfs_read_file+0xab/0x160
> 
>  which lock already depends on the new lock.

sysfs_dirent_init_lockdep() and the 6992f53349 ("sysfs: Use one lockdep
class per sysfs attribute") which added it are rather scary.

The alleged bug appears to be due to taking pools_lock outside
device_create_file() (which takes magical sysfs PseudoVirtualLocks)
versus show_pools(), which takes pools_lock but is called from inside
magical sysfs PseudoVirtualLocks.

I don't know if this is actually a real bug or not.  Probably not, as
this device_create_file() does not match the reasons for 6992f53349:
"There is a sysfs idiom where writing to one sysfs file causes the
addition or removal of other sysfs files".  But that's a guess.

> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -174,21 +174,28 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  	init_waitqueue_head(&retval->waitq);
>  
>  	if (dev) {
> -		int ret;
> +		int first_pool;
>  
>  		mutex_lock(&pools_lock);
>  		if (list_empty(&dev->dma_pools))
> -			ret = device_create_file(dev, &dev_attr_pools);
> +			first_pool = 1;
>  		else
> -			ret = 0;
> +			first_pool = 0;
>  		/* note:  not currently insisting "name" be unique */
> -		if (!ret)
> -			list_add(&retval->pools, &dev->dma_pools);
> -		else {
> -			kfree(retval);
> -			retval = NULL;
> -		}
> +		list_add(&retval->pools, &dev->dma_pools);
>  		mutex_unlock(&pools_lock);
> +
> +		if (first_pool) {
> +			int ret;
> +			ret = device_create_file(dev, &dev_attr_pools);
> +			if (ret) {
> +				mutex_lock(&pools_lock);
> +				list_del(&retval->pools);
> +				mutex_unlock(&pools_lock);
> +				kfree(retval);
> +				retval = NULL;
> +			}
> +		}

Not a good fix, IMO.  The problem is that if two CPUs concurrently call
dma_pool_create(), the first CPU will spend time creating the sysfs
file.  Meanwhile, the second CPU will whizz straight back to its
caller.  The caller now thinks that the sysfs file has been created and
returns to userspace, which immediately tries to read the sysfs file. 
But the first CPU hasn't finished creating it yet.  Userspace fails.

One way of fixing this would be to create another singleton lock:


	{
		static DEFINE_MUTEX(pools_sysfs_lock);
		static bool pools_sysfs_done;

		mutex_lock(&pools_sysfs_lock);
		if (pools_sysfs_done == false) {
			create_sysfs_stuff();
			pools_sysfs_done = true;
		}
		mutex_unlock(&pools_sysfs_lock);
	}

That's not terribly pretty.

