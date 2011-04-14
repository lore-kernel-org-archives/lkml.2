Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1DNHI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab1DNHIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:08:25 -0400
Date: Thu, 14 Apr 2011 17:08:14 +1000
From: NeilBrown <neilb@suse.de>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: fix unchecked interruptible mutex locks
Message-ID: <20110414170814.40f4d3eb@notabene.brown>
In-Reply-To: <4DA698BE.70903@ispras.ru>
References: <4DA698BE.70903@ispras.ru>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 10:48:30 +0400 Alexey Khoroshilov <khoroshilov@ispras.ru>
wrote:

> mddev_lock() is an alias for mutex_lock_interruptible() at the moment,
> but there are places where returned value of mddev_lock() is not checked.
> 
> The patch proposed introduces mddev_lock_interruptible(),
> which is an equivalent for old mddev_lock(), while mddev_lock()
> becomes an alias for uninterruptible mutex_lock(). 
> Calls of mddev_lock(), where the result is being checked, 
> are replaced by mddev_lock_interruptible().
> All the other calls become uninterruptible.

Thanks for reporting this.
I don't agree with your solution though.

I would mark mddev_lock as __must_check__ (or however it is spelt) and fix
the errors produced.

I think the call in md_stop_writes is the only one where an uninterruptible
wait is needed - I'd probaby just change that to an explicit "mutex_lock",
but I wouldn't be against creating "mddev_lock_uninterruptible" for that case.

NeilBrown


> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/md/md.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b12b377..cc6d183 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -623,7 +623,12 @@ static mddev_t * mddev_find(dev_t unit)
>  	goto retry;
>  }
> 
> -static inline int mddev_lock(mddev_t * mddev)
> +static inline void mddev_lock(mddev_t *mddev)
> +{
> +	return mutex_lock(&mddev->reconfig_mutex);
> +}
> +
> +static inline int __must_check mddev_lock_interruptible(mddev_t *mddev)
>  {
>  	return mutex_lock_interruptible(&mddev->reconfig_mutex);
>  }
> @@ -2706,7 +2711,7 @@ rdev_attr_show(struct kobject *kobj, struct
> attribute *attr, char *page)
>  	if (!entry->show)
>  		return -EIO;
> 
> -	rv = mddev ? mddev_lock(mddev) : -EBUSY;
> +	rv = mddev ? mddev_lock_interruptible(mddev) : -EBUSY;
>  	if (!rv) {
>  		if (rdev->mddev == NULL)
>  			rv = -EBUSY;
> @@ -2730,7 +2735,7 @@ rdev_attr_store(struct kobject *kobj, struct
> attribute *attr,
>  		return -EIO;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> -	rv = mddev ? mddev_lock(mddev): -EBUSY;
> +	rv = mddev ? mddev_lock_interruptible(mddev) : -EBUSY;
>  	if (!rv) {
>  		if (rdev->mddev == NULL)
>  			rv = -EBUSY;
> @@ -4199,7 +4204,7 @@ md_attr_show(struct kobject *kobj, struct
> attribute *attr, char *page)
> 
>  	if (!entry->show)
>  		return -EIO;
> -	rv = mddev_lock(mddev);
> +	rv = mddev_lock_interruptible(mddev);
>  	if (!rv) {
>  		rv = entry->show(mddev, page);
>  		mddev_unlock(mddev);
> @@ -4219,7 +4224,7 @@ md_attr_store(struct kobject *kobj, struct
> attribute *attr,
>  		return -EIO;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> -	rv = mddev_lock(mddev);
> +	rv = mddev_lock_interruptible(mddev);
>  	if (mddev->hold_active == UNTIL_IOCTL)
>  		mddev->hold_active = 0;
>  	if (!rv) {
> @@ -4951,7 +4956,7 @@ static void autorun_devices(int part)
>  				"md: cannot allocate memory for md drive.\n");
>  			break;
>  		}
> -		if (mddev_lock(mddev))
> +		if (mddev_lock_interruptible(mddev))
>  			printk(KERN_WARNING "md: %s locked, cannot run\n",
>  			       mdname(mddev));
>  		else if (mddev->raid_disks || mddev->major_version
> @@ -5771,7 +5776,7 @@ static int md_ioctl(struct block_device *bdev,
> fmode_t mode,
>  		goto abort;
>  	}
> 
> -	err = mddev_lock(mddev);
> +	err = mddev_lock_interruptible(mddev);
>  	if (err) {
>  		printk(KERN_INFO
>  			"md: ioctl lock interrupted, reason %d, cmd %d\n",
> @@ -6379,7 +6384,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>  		return 0;
>  	}
> 
> -	if (mddev_lock(mddev) < 0)
> +	if (mddev_lock_interruptible(mddev) < 0)
>  		return -EINTR;
> 
>  	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
> -- 1.7.1

