Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1HJIkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:40:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab1HJIkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:40:15 -0400
Date: Wed, 10 Aug 2011 11:40:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Chris Wright <chrisw@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110810084012.GD13911@redhat.com>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805001507.GA5987@local>
 <20110808062431.GB5182@redhat.com>
 <20110808171931.GB867@local>
 <20110809113743.GA32299@redhat.com>
 <20110809185341.GD4229@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809185341.GD4229@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:53:41PM +0200, Hans J. Koch wrote:
> On Tue, Aug 09, 2011 at 02:37:43PM +0300, Michael S. Tsirkin wrote:
> > > 
> > > Should I hack up a patch to remove the lock, or do you have anything in your
> > > pipeline?
> > 
> > 
> > Please do.
> > 
> 
> Here it is:
> 
> Greg (and anyone else...), you can also pull this from branch "uio-for-greg" from
> 
> git://hansjkoch.de/git/linux-hjk
> 
> 
> >From ff74627ade002d40fe1f902b7aadab8b1f15f889 Mon Sep 17 00:00:00 2001
> From: "Hans J. Koch" <hjk@hansjkoch.de>
> Date: Tue, 9 Aug 2011 20:34:31 +0200
> Subject: [PATCH] uio: uio_pci_generic: Remove useless spin_lock
> 
> The spin_lock in uio_pci_generic.c is only used in the interrupt
> handler, which cannot be executed twice at the same time.
> That makes the lock rather pointless. This patch removes it.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Chris Wright <chrisw@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Anthony Foiani <anthony.foiani@gmail.com>
> Reported-by: Anthony Foiani <anthony.foiani@gmail.com>
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

I also suggest this for the stable trees.

> ---
>  drivers/uio/uio_pci_generic.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index fc22e1e..02bd47b 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -24,7 +24,6 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/uio_driver.h>
> -#include <linux/spinlock.h>
>  
>  #define DRIVER_VERSION	"0.01.0"
>  #define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
> @@ -33,7 +32,6 @@
>  struct uio_pci_generic_dev {
>  	struct uio_info info;
>  	struct pci_dev *pdev;
> -	spinlock_t lock; /* guards command register accesses */
>  };
>  
>  static inline struct uio_pci_generic_dev *
> @@ -57,7 +55,6 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  	BUILD_BUG_ON(PCI_COMMAND % 4);
>  	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
>  
> -	spin_lock_irq(&gdev->lock);
>  	pci_block_user_cfg_access(pdev);
>  
>  	/* Read both command and status registers in a single 32-bit operation.
> @@ -83,7 +80,6 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  done:
>  
>  	pci_unblock_user_cfg_access(pdev);
> -	spin_unlock_irq(&gdev->lock);
>  	return ret;
>  }
>  
> @@ -158,7 +154,6 @@ static int __devinit probe(struct pci_dev *pdev,
>  	gdev->info.irq_flags = IRQF_SHARED;
>  	gdev->info.handler = irqhandler;
>  	gdev->pdev = pdev;
> -	spin_lock_init(&gdev->lock);
>  
>  	if (uio_register_device(&pdev->dev, &gdev->info))
>  		goto err_register;
> -- 
> 1.7.5.4
