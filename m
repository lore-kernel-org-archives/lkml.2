Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0C3MHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:07:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40865 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0C3MHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:07:47 -0400
Message-ID: <4BB1E98E.9050702@canonical.com>
Date: Tue, 30 Mar 2010 14:07:42 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: davem@davemloft.net, gregkh@suse.de, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: patch sparc64-make-prom-entry-spinlock-nmi-safe.patch added to
 2.6.32-stable tree
References: <12689584863184@kroah.org>
In-Reply-To: <12689584863184@kroah.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converted the raw_spinlock usage which is used in the upstream patch but
not available in 2.6.32 to normal spinlock usage. Should it get annotated to
document that?

-Stefan

gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: [PATCH] sparc64: Make prom entry spinlock NMI safe.
> 
> to the 2.6.32-stable tree.  Its filename is
> 
>     sparc64-make-prom-entry-spinlock-nmi-safe.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From c682420e87cdd8db0212e29eb70c325cdfc0860c Mon Sep 17 00:00:00 2001
> From: David S. Miller <davem@davemloft.net>
> Date: Wed, 3 Mar 2010 09:06:03 -0800
> Subject: [PATCH] sparc64: Make prom entry spinlock NMI safe.
> 
> From: David S. Miller <davem@davemloft.net>
> 
> [ Upstream commit 8a4fd1e4922413cfdfa6c51a59efb720d904a5eb ]
> 
> If we do something like try to print to the OF console from an NMI
> while we're already in OpenFirmware, we'll deadlock on the spinlock.
> 
> Use a raw spinlock and disable NMIs when we take it.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/sparc/prom/p1275.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> --- a/arch/sparc/prom/p1275.c
> +++ b/arch/sparc/prom/p1275.c
> @@ -32,8 +32,7 @@ extern void prom_cif_interface(void);
>  extern void prom_cif_callback(void);
>  
>  /*
> - * This provides SMP safety on the p1275buf. prom_callback() drops this lock
> - * to allow recursuve acquisition.
> + * This provides SMP safety on the p1275buf.
>   */
>  DEFINE_SPINLOCK(prom_entry_lock);
>  
> @@ -47,7 +46,9 @@ long p1275_cmd(const char *service, long
>  	
>  	p = p1275buf.prom_buffer;
>  
> -	spin_lock_irqsave(&prom_entry_lock, flags);
> +	raw_local_save_flags(flags);
> +	raw_local_irq_restore(PIL_NMI);
> +	spin_lock(&prom_entry_lock);
>  
>  	p1275buf.prom_args[0] = (unsigned long)p;		/* service */
>  	strcpy (p, service);
> @@ -139,7 +140,8 @@ long p1275_cmd(const char *service, long
>  	va_end(list);
>  	x = p1275buf.prom_args [nargs + 3];
>  
> -	spin_unlock_irqrestore(&prom_entry_lock, flags);
> +	spin_unlock(&prom_entry_lock);
> +	raw_local_irq_restore(flags);
>  
>  	return x;
>  }
> 
> 
> Patches currently in stable-queue which might be from davem@davemloft.net are
> 
> queue-2.6.32/pci-add-support-for-82576ns-serdes-to-existing-sr-iov-quirk.patch
> queue-2.6.32/sparc64-make-prom-entry-spinlock-nmi-safe.patch
> queue-2.6.32/ixgbe-add-support-for-82599-kr-device-0x1517.patch
> queue-2.6.32/e1000e-enable-new-82567v-3-device.patch
> queue-2.6.32/tg3-fix-tg3_poll_controller-passing-wrong-pointer-to-tg3_interrupt.patch
> queue-2.6.32/tg3-fix-5906-transmit-hangs.patch
> --
> To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

