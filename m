Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1HDVDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab1HDVDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:03:48 -0400
Date: Fri, 5 Aug 2011 00:04:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110804210413.GA29222@redhat.com>
References: <20110804204606.GA19724@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804204606.GA19724@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:46:06PM +0200, Sebastian Andrzej Siewior wrote:
> As reported by Anthony in a short way:
> 
> |irq 17 handler uio_interrupt+0x0/0x68 enabled interrupts
> |NIP [c0069d84] handle_irq_event_percpu+0x260/0x26c
> 
> The problem here is that spin_unlock_irq() enables the interrupts which
> is a no-no in interrupt context because they always run with interrupts
> disabled. This is the case even if IRQF_DISABLED has not been specified
> since v2.6.35. Therefore this patch uses simple spin_locks().
> 
> Looking at it further here is only one spot where the lock is hold. So
> giving the fact that an ISR is not reentrant and is not executed on two
> cpus at the same time why do we need a lock here?

I'm not sure anymore. I think the idea was to use
it for synchronization down the road somehow,
but it never materialized. Let's drop that lock completely.

> The driver lacks of ->irqcontrol function so I guess the interrupt is
> enabled via direct PCI-access in userland.

Through sysfs.

> So there is _no_ protection
> against read-modify-write of user vs kernel so even that
> pci_block_user_cfg_access() is kinda pointless.

I didn't get that. pci_block_user_cfg_access is to prevent
sysfs access while we read modify-write the command register.
Isn't it effective for that?

> pci_block_user_cfg_access() in open() + ->irqcontrol() should fix this.

Why block in open? We don't access the device there, do we?

> Since changes the API of this driver I leave it up to the relevant users
> what to do.

Yes, changing API's not good, we need to keep existing userspace happy.

> Cc: <stable@kernel.org> # .35 and later
> Reported-and-Tested-by: Anthony Foiani <anthony.foiani@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/uio/uio_pci_generic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index fc22e1e..5c82681 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -57,7 +57,7 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  	BUILD_BUG_ON(PCI_COMMAND % 4);
>  	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
>  
> -	spin_lock_irq(&gdev->lock);
> +	spin_lock(&gdev->lock);
>  	pci_block_user_cfg_access(pdev);
>  
>  	/* Read both command and status registers in a single 32-bit operation.
> @@ -83,7 +83,7 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  done:
>  
>  	pci_unblock_user_cfg_access(pdev);
> -	spin_unlock_irq(&gdev->lock);
> +	spin_unlock(&gdev->lock);
>  	return ret;
>  }
>  
> -- 
> 1.7.4.4
