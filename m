Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2JBVMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2JBVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:12:31 -0400
Date: Tue, 2 Oct 2012 14:12:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] aoe: support more AoE addresses with dynamic block
 device minor numbers
Message-Id: <20121002141230.17f59ed8.akpm@linux-foundation.org>
In-Reply-To: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012 18:59:12 -0700
Ed Cashin <ecashin@coraid.com> wrote:

> The ATA over Ethernet protocol uses a major (shelf) and
> minor (slot) address to identify a particular storage target.
> These changes remove an artificial limitation the aoe driver
> imposes on the use of AoE addresses.  For example, without these
> changes, the slot address has a maximum of 15, but users commonly
> use slot numbers much greater than that.
> 
> The AoE shelf and slot address space is often used sparsely.
> Instead of using a static mapping between AoE addresses and the
> block device minor number, the block device minor numbers are now
> allocated on demand.
> 
> ...

Very minor things...

>
> ...
>
> +static int
> +minor_get(ulong *minor)
>  {
> -	struct aoedev *d;
>  	ulong flags;
> +	ulong n;
> +	int error = 0;
> +
> +	spin_lock_irqsave(&used_minors_lock, flags);
> +	n = find_first_zero_bit(used_minors, N_DEVS);
> +	if (n < N_DEVS)
> +		set_bit(n, used_minors);
> +	else
> +		error = -1;
> +	spin_unlock_irqrestore(&used_minors_lock, flags);
> +
> +	*minor = n * AOE_PARTITIONS;
> +	return error;
> +}

- can use the more efficient __set_bit() inside that spinlock.

- could avoid setting *minor if we're returning an error.

> -	spin_lock_irqsave(&devlist_lock, flags);
> +static void
> +minor_free(ulong minor)
> +{
> +	ulong flags;
>  
> -	for (d=devlist; d; d=d->next)
> -		if (d->aoemajor == maj && d->aoeminor == min) {
> -			d->ref++;
> -			break;
> -		}
> +	minor /= AOE_PARTITIONS;
> +	BUG_ON(minor >= N_DEVS);
>  
> -	spin_unlock_irqrestore(&devlist_lock, flags);
> -	return d;
> +	spin_lock_irqsave(&used_minors_lock, flags);
> +	BUG_ON(!test_bit(minor, used_minors));
> +	clear_bit(minor, used_minors);
> +	spin_unlock_irqrestore(&used_minors_lock, flags);
>  }

Could use

	BUG_ON(!__test_and_clear_bit(...));

This will work, but I think it's bad form to put an expression with
side-effects inside an assert macro.


