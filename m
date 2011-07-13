Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1GMNO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:14:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34229 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1GMNO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:14:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 Jul 2011 15:14:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
Message-ID: <20110713151410.59a3a193@stein>
In-Reply-To: <4E1D6900.6040500@cam.ac.uk>
References: <4E1D6900.6040500@cam.ac.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 13 Jonathan Cameron wrote:
> Taking ida's first, how about the following patch?  I'm not at
> all attached to the form it takes, merely to cutting out on the
> cut and paste.

Not a big-picture opinion here whether this is a good thing; only some
small comments on side issues:

[...]
> The other thing this highlights is that I suspect quite a few are protected by
> spin locks when a mutex would be fine. Hence that might be worth tidying up first.

It seems to be the other way around in this case:  Why use a mutex if a
spinlock is fine?

[...]
> --- a/drivers/misc/cb710/core.c
> +++ b/drivers/misc/cb710/core.c
> @@ -254,18 +254,9 @@ static int __devinit cb710_probe(struct pci_dev *pdev,
>  	if (err)
>  		return err;
>  
> -	do {
> -		if (!ida_pre_get(&cb710_ida, GFP_KERNEL))
> -			return -ENOMEM;
> -
> -		spin_lock_irqsave(&cb710_ida_lock, flags);
> -		err = ida_get_new(&cb710_ida, &chip->platform_id);
> -		spin_unlock_irqrestore(&cb710_ida_lock, flags);
> -
> -		if (err && err != -EAGAIN)
> -			return err;
> -	} while (err);
> -
> +	err = ida_get_id(&cb710_ida_lock, &cb710_ida, &chip->platform_id);
> +	if (err)
> +		return err;
>  
>  	dev_info(&pdev->dev, "id %d, IO 0x%p, IRQ %d\n",
>  		chip->platform_id, chip->iobase, pdev->irq);

To balance this change to cb710_probe, also switch from spin_lock_irqsave/
spin_unlock_irqrestore to spin_lock/spin_unlock in cb710_remove_one for
clarity.

[...]
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -939,3 +939,23 @@ void ida_init(struct ida *ida)
>  
>  }
>  EXPORT_SYMBOL(ida_init);
> +
> +int ida_get_id(spinlock_t *lock, struct ida *ida, int *val)
> +{
> +	int ret = 0;
> +ida_again:
> +	if (unlikely(ida_pre_get(ida, GFP_KERNEL) == 0))
> +		return -ENOMEM;
> +
> +	spin_lock(lock);
> +	ret = ida_get_new(ida, val);
> +	spin_unlock(lock);
> +
> +	if (unlikely (ret == -EAGAIN))
> +		goto ida_again;
> +	else if (likely(!ret))
> +		*val = *val & MAX_ID_MASK;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ida_get_id);

A new exported function (in lib/ even) should come with a kerneldoc comment
of course.  Here it is among else noteworthy that the caller must provide
GFP_KERNEL allocations capable context and that @lock cannot be shared
with users in IRQ or softIRQ contexts.
-- 
Stefan Richter
-=====-==-== -=== -==-=
http://arcgraph.de/sr/
