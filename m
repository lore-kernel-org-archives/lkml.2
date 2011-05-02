Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1EBGs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:48:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:13350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab1EBGs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,301,1301900400"; 
   d="scan'208";a="741003372"
Subject: Re: [PATCH 2/4] pch_dma: fix dma direction issue for ML7213 IOH
 video-in
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
In-Reply-To: <1303812353-6712-2-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1303812353-6712-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	 <1303812353-6712-2-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 11:46:53 +0530
Message-ID: <1304317013.1589.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 19:05 +0900, Tomoya MORINAGA wrote:
> Currently, even-channel number is set as tx direction and odd is set as rx.
> However, though video-in uses ch6, the direction is not tx but rx.
> This patch sets video-in's DMA direction correctly.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> ---
>  drivers/dma/pch_dma.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 9421ed5..cd7bf83 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -59,6 +59,14 @@
>  #define DMA_DESC_FOLLOW_WITHOUT_IRQ	0x2
>  #define DMA_DESC_FOLLOW_WITH_IRQ	0x3
>  
> +/* PCI Device ID of DMA device */
> +#define PCI_VENDOR_ID_ROHM             0x10DB
> +#define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
> +#define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
> +#define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
> +#define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
> +#define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
> +
>  #define MAX_CHAN_NR			8
These additions does seem to match the patch description, Can you split
them appropriately...
>  
>  static unsigned int init_nr_desc_per_channel = 64;
> @@ -853,7 +861,12 @@ static int __devinit pch_dma_probe(struct pci_dev *pdev,
>  
>  		pd_chan->membase = &regs->desc[i];
>  
> -		pd_chan->dir = (i % 2) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +		/* D10:F0 DMA ch6 "video input" is rx direction */
> +		if ((id->device == PCI_DEVICE_ID_ML7213_DMA1_8CH) && (i == 6))
> +			pd_chan->dir = DMA_FROM_DEVICE;
This kind of initialization is wrong....
Will you change again if video channel assignments change...
You should use the direction field in prep_xxx calls for setting this
> +		else
> +			pd_chan->dir = (i % 2) ? DMA_FROM_DEVICE : \
> +								DMA_TO_DEVICE;
>  
>  		spin_lock_init(&pd_chan->lock);
>  
> @@ -925,14 +938,6 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
>  	}
>  }
>  
> -/* PCI Device ID of DMA device */
> -#define PCI_VENDOR_ID_ROHM             0x10DB
> -#define PCI_DEVICE_ID_EG20T_PCH_DMA_8CH        0x8810
> -#define PCI_DEVICE_ID_EG20T_PCH_DMA_4CH        0x8815
> -#define PCI_DEVICE_ID_ML7213_DMA1_8CH	0x8026
> -#define PCI_DEVICE_ID_ML7213_DMA2_8CH	0x802B
> -#define PCI_DEVICE_ID_ML7213_DMA3_4CH	0x8034
????

> -
>  static const struct pci_device_id pch_dma_id_table[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },


-- 
~Vinod

