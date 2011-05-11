Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1EKANV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:13:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1EKANU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:13:20 -0400
Date: Tue, 10 May 2011 17:13:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: print information about leaked entry
Message-Id: <20110510171313.490625d9.akpm@linux-foundation.org>
In-Reply-To: <20110331120759.GA5230@redhat.com>
References: <20110331120759.GA5230@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 14:08:09 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> When driver leak dma mapping, print additional information about one of
> leaked entries, to to help investigate problem. Patch should be useful
> for debugging drivers, which maps many different class of buffers.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  lib/dma-debug.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 4bfb047..db07bfd 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -649,7 +649,7 @@ out_err:
>  	return -ENOMEM;
>  }
>  
> -static int device_dma_allocations(struct device *dev)
> +static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
>  {
>  	struct dma_debug_entry *entry;
>  	unsigned long flags;
> @@ -660,8 +660,10 @@ static int device_dma_allocations(struct device *dev)
>  	for (i = 0; i < HASH_SIZE; ++i) {
>  		spin_lock(&dma_entry_hash[i].lock);
>  		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
> -			if (entry->dev == dev)
> +			if (entry->dev == dev) {
>  				count += 1;
> +				*out_entry = entry;
> +			}
>  		}
>  		spin_unlock(&dma_entry_hash[i].lock);
>  	}
> @@ -674,6 +676,7 @@ static int device_dma_allocations(struct device *dev)
>  static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
>  {
>  	struct device *dev = data;
> +	struct dma_debug_entry *uninitialized_var(entry);

The warning you saw was due to gcc assuming that foo(&bar) might not
write to `bar'.  That was fixed (ie: suppressed) in later gcc's, so we
tend not to bother working around it.

>  	int count;
>  
>  	if (global_disable)
> @@ -681,12 +684,17 @@ static int dma_debug_device_change(struct notifier_block *nb, unsigned long acti
>  
>  	switch (action) {
>  	case BUS_NOTIFY_UNBOUND_DRIVER:
> -		count = device_dma_allocations(dev);
> +		count = device_dma_allocations(dev, &entry);
>  		if (count == 0)
>  			break;
> -		err_printk(dev, NULL, "DMA-API: device driver has pending "
> +		err_printk(dev, entry, "DMA-API: device driver has pending "
>  				"DMA allocations while released from device "
> -				"[count=%d]\n", count);
> +				"[count=%d]\n"
> +				"One of leaked entries details: "
> +				"[device address=0x%016llx] [size=%llu bytes] "
> +				"[mapped with %s] [mapped as %s]\n",
> +			count, entry->dev_addr, entry->size,
> +			dir2name[entry->direction], type2name[entry->type]);

hm, how does the programmer use this info.  Does the device address
identify the device and its driver?  That seems a bit indirect.

ah, I see that the gruesome err_printk() does a WARN, so the stack
backtrace will tell us where the problem is occurring.

