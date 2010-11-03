Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0KCVDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:03:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15957 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab0KCVDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:03:16 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAB5r0UyrR7Hu/2dsb2JhbACDIp5GcaURii6RGoEigzFzBIRXhX4
X-IronPort-AV: E=Sophos;i="4.58,290,1286150400"; 
   d="scan'208";a="614038483"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: Fix PCI 2.3 shared interrupt
Date: Wed, 3 Nov 2010 14:03:52 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.5-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
References: <20101103201732.7400.28058.stgit@s20.home>
In-Reply-To: <20101103201732.7400.28058.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011031403.53081.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

On Wednesday, November 03, 2010 01:17:33 pm Alex Williamson wrote:
> Trying to be too clever with setting the irq_disabled flag.  PCI 2.3
> disabled devices can still share IRQs, which can lead to clearing
> the irq_disabled flag, preventing the EOI from registering, and leaving
> the device without interrupts.  Interrupt handler should only ever
> set irq_disabled and we can exit earlier to avoid the config space
> access if we know we're disabled.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/vfio/vfio_intrs.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_intrs.c b/drivers/vfio/vfio_intrs.c
> index 604082c..73e3deb 100644
> --- a/drivers/vfio/vfio_intrs.c
> +++ b/drivers/vfio/vfio_intrs.c
> @@ -57,6 +57,12 @@ irqreturn_t vfio_interrupt(int irq, void *dev_id)
> 
>  	spin_lock_irq(&vdev->irqlock);
> 
> +	/* INTX disabled interrupts can still be shared */
> +	if (vdev->irq_disabled) {
> +		spin_unlock_irq(&vdev->irqlock);
> +		return ret;
> +	}
> +
>  	if (vdev->pci_2_3) {
>  		pci_block_user_cfg_access(pdev);
> 
> @@ -87,7 +93,8 @@ done:
>  		ret = IRQ_HANDLED;
>  	}
> 
> -	vdev->irq_disabled = (ret == IRQ_HANDLED);
> +	if (ret == IRQ_HANDLED)
> +		vdev->irq_disabled = true;
> 
>  	spin_unlock_irq(&vdev->irqlock);
