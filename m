Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0JSWcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab0JSWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:32:06 -0400
Date: Tue, 19 Oct 2010 15:31:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] support polling of /proc/swaps
Message-Id: <20101019153136.b2543f7b.akpm@linux-foundation.org>
In-Reply-To: <1287479956.1729.1.camel@yio.site>
References: <1287479956.1729.1.camel@yio.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 11:19:16 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: support polling of /proc/swaps
> 
> System management wants to subscribe to changes in swap
> configuration. Make /proc/swaps pollable like /proc/mounts.
> 

It's a bit sad that we have to add quite a pile of infrastructure to
make a procfs file pollable.  I wonder if it's possible to provide some
core support for this, and reduce the amount of code at each particular
handler site.

Also, I wonder how we are to communicate the existence of this feature
to our users.  Nobody will look in Documentation/filesystems/.  Is
there a manpage?  Seems not...

> ---
>  mm/swapfile.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -30,6 +30,7 @@
>  #include <linux/capability.h>
>  #include <linux/syscalls.h>
>  #include <linux/memcontrol.h>
> +#include <linux/poll.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
> @@ -58,6 +59,9 @@ static struct swap_info_struct *swap_inf
>  
>  static DEFINE_MUTEX(swapon_mutex);
>  
> +static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> +static int proc_poll_event;

Please pick a lock to protect proc_poll_event.  Then document that
locking here, when you also document proc_poll_event ;)

>  static inline unsigned char swap_count(unsigned char ent)
>  {
>  	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
> @@ -1680,6 +1684,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
>  	}
>  	filp_close(swap_file, NULL);
>  	err = 0;
> +	proc_poll_event++;

Then fix this race.

> +	wake_up_interruptible(&proc_poll_wait);
>  
>  out_dput:
>  	filp_close(victim, NULL);

