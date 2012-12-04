Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2LDXpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 18:45:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2LDXpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 18:45:36 -0500
Date: Tue, 4 Dec 2012 15:45:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] aoe: avoid races between device destruction and
 discovery
Message-Id: <20121204154534.7fb65f2b.akpm@linux-foundation.org>
In-Reply-To: <d3095fd2ad59a9e1fffe9208c34e8b35e7a8b5e5.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
	<d3095fd2ad59a9e1fffe9208c34e8b35e7a8b5e5.1354501189.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 20:42:56 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> This change avoids a race that could result in a NULL pointer
> derference following a WARNing from kobject_add_internal, "don't
> try to register things with the same name in the same directory."
> 
> The problem was found with a test that forgets and discovers an
> aoe device in a loop:
> 
>   while test ! -r /tmp/stop; do
> 	aoe-flush -a
> 	aoe-discover
>   done
> 
> The race was between aoedev_flush taking aoedevs out of the
> devlist, allowing a new discovery of the same AoE target to take
> place before the driver gets around to calling
> sysfs_remove_group.  Fixing that one revealed another race
> between do_open and add_disk, and this patch avoids that, too.
> 
> The fix required some care, because for flushing (forgetting) an
> aoedev, some of the steps must be performed under lock and some
> must be able to sleep.  Also, for discovering a new aoedev, some
> steps might sleep.
> 
> The check for a bad aoedev pointer remains from a time when about
> half of this patch was done, and it was possible for the
> bdev->bd_disk->private_data to become corrupted.  The check
> should be removed eventually, but it is not expected to add
> significant overhead, occurring in the aoeblk_open routine.
> 
>
> ...
>
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -147,9 +147,18 @@ aoeblk_open(struct block_device *bdev, fmode_t mode)
>  	struct aoedev *d = bdev->bd_disk->private_data;
>  	ulong flags;
>  
> +	if (!virt_addr_valid(d)) {
> +		pr_crit("aoe: invalid device pointer in %s\n",
> +			__func__);
> +		WARN_ON(1);
> +		return -ENODEV;
> +	}

Can this ever happen?

> +	if (!(d->flags & DEVFL_UP) || d->flags & DEVFL_TKILL)
> +		return -ENODEV;
> +
>  	mutex_lock(&aoeblk_mutex);
>  	spin_lock_irqsave(&d->lock, flags);
> -	if (d->flags & DEVFL_UP) {
> +	if (d->flags & DEVFL_UP && !(d->flags & DEVFL_TKILL)) {
>  		d->nopen++;
>  		spin_unlock_irqrestore(&d->lock, flags);
>  		mutex_unlock(&aoeblk_mutex);
> @@ -259,6 +268,18 @@ aoeblk_gdalloc(void *vp)
>  	struct request_queue *q;
>  	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
>  	ulong flags;
> +	int late = 0;
> +
> +	spin_lock_irqsave(&d->lock, flags);
> +	if (d->flags & DEVFL_GDALLOC
> +	&& !(d->flags & DEVFL_TKILL)
> +	&& !(d->flags & DEVFL_GD_NOW))

That's pretty sickly-looking code layout.

We often do

	if ((d->flags & (DEVFL_GDALLOC|DEVFL_TKILL|DEVFL_GD_NOW)) ==
		DEVFL_GDALLOC)

in these cases.

> +		d->flags |= DEVFL_GD_NOW;
> +	else
> +		late = 1;
> +	spin_unlock_irqrestore(&d->lock, flags);
> +	if (late)
> +		return;
>  
>  	gd = alloc_disk(AOE_PARTITIONS);
>  	if (gd == NULL) {
>
> ...
>

