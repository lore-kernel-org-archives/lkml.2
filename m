Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2HTP0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:26:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab2HTP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:26:16 -0400
Date: Mon, 20 Aug 2012 08:26:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] drivers-core: beware dev_printk() from printing nonsense
Message-ID: <20120820152611.GB28039@kroah.com>
References: <20120820103337.GA16744@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820103337.GA16744@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:33:37PM +0200, Sebastian Andrzej Siewior wrote:
> on boot I saw plenty of rubbish like:
> 
> |ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> |pci_root PNP0A03:00: Force enabled HPET at 0x%lx
> |host bridge window [io  0x0000-0x0cf7] (ignored)
> |pci_root PNP0A03:00: Force enabled HPET at 0x%lx
> |host bridge window [io  0x0d00-0xffff] (ignored)
> |pci_root PNP0A03:00: Force enabled HPET at 0x%lx
> |ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> |virtio-pci 0000:00:05.0: Force enabled HPET at 0x%lx
> 
> First I wonder myself why the kernel Force enables more than one HPET
> and why the address isn't printed. Then I wasn't sure why virtio-pci
> does the same thing.
> As it turns out commit af7f2158fdee ("drivers-core: make structured
> logging play nice with dynamic-debug") has probably an off by one error.
> Since commit 314ba3520 ("printk: add kern_levels.h to make KERN_<LEVEL>
> available for asm use") the whole shrunk by one byte. And for some
> reason the compiler put the HPET string just after one of the kernel log
> levels so level[3] was always true.
> 
> This should make the rubish go away, I am not sure if the dynamic debug
> is still working. Jim could you please try?
> 
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: stable <stable@vger.kernel.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/base/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index cdd01c5..5a864c3 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1912,7 +1912,7 @@ int __dev_printk(const char *level, const struct device *dev,
>  				    "DEVICE=+%s:%s", subsys, dev_name(dev));
>  	}
>  skip:
> -	if (level[3])
> +	if (level[sizeof(KERN_ERR) - 1])

This has already been fixed in my driver-core tree and will go to Linus
in a few hours.

thanks,

greg k-h
