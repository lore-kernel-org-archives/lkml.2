Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1JNMCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:02:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39008 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1JNMCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:02:42 -0400
Message-ID: <4E9824AC.6020902@mvista.com>
Date: Fri, 14 Oct 2011 16:01:48 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <201110131539.11190.bzolnier@gmail.com>
In-Reply-To: <201110131539.11190.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-10-2011 17:39, Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH v2] ata_piix: unify code for programming PIO and MWDMA timings

> Besides making things noticably simpler it results in ~2% decrease in
> the driver LOC count and also ~2% decrease in the driver binary size
> (as measured on x86-32).

> Fix piix_set_piomode() documentation while at it.

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>

    I'm still inclined to NAK this patch.

> ---
> v2: remove use_mwdma variable and fix comment style

> earlier references:
> https://lkml.org/lkml/2011/2/8/99
>
>   drivers/ata/ata_piix.c |  111 ++++++++++++++++---------------------------------
>   1 file changed, 38 insertions(+), 73 deletions(-)

> Index: b/drivers/ata/ata_piix.c
> ===================================================================
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
[...]
> @@ -811,31 +822,20 @@ static void do_pata_set_dmamode(struct a
[...]
> -	if (ap->udma_mask)
> -		pci_read_config_byte(dev, 0x48,&udma_enable);

    Don't think you should remove this.

> -
>   	if (speed>= XFER_UDMA_0) {
> -		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
> +		unsigned int udma = speed - XFER_UDMA_0;
>   		u16 udma_timing;
>   		u16 ideconf;
>   		int u_clock, u_speed;
>
> +		spin_lock_irqsave(&piix_lock, flags);
> +
> +		pci_read_config_byte(dev, 0x48, &udma_enable);

    But you should also clear the UDMA enable bit when setting an MWDMA mode, no?

> +
>   		/*
>   		 * UDMA is handled by a combination of clock switching and
>   		 * selection of dividers
> @@ -868,56 +868,21 @@ static void do_pata_set_dmamode(struct a
>   			   performance (WR_PingPong_En) */
>   			pci_write_config_word(dev, 0x54, ideconf);
>   		}
> +
> +		pci_write_config_byte(dev, 0x48, udma_enable);
> +
> +		spin_unlock_irqrestore(&piix_lock, flags);
>   	} else {
> -		/*
> -		 * MWDMA is driven by the PIO timings. We must also enable
> -		 * IORDY unconditionally along with TIME1. PPE has already
> -		 * been set when the PIO timing was set.
> -		 */
> -		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
> -		unsigned int control;
> -		u8 slave_data;
> +		/* MWDMA is driven by the PIO timings. */
> +		unsigned int mwdma = speed - XFER_MW_DMA_0;
>   		const unsigned int needed_pio[3] = {
>   			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
>   		};
>   		int pio = needed_pio[mwdma] - XFER_PIO_0;
>
[...]
> -		if (ap->udma_mask)
> -			udma_enable&= ~(1<<  devid);

    Still don't understand why you're removing this code.

> -
> -		pci_write_config_word(dev, master_port, master_data);
> +		/* XFER_PIO_0 is never used currently */
> +		piix_set_timings(ap, adev, pio);
>   	}
> -	/* Don't scribble on 0x48 if the controller does not support UDMA */
> -	if (ap->udma_mask)
> -		pci_write_config_byte(dev, 0x48, udma_enable);

    Should have kept this one too...

MBR, Sergei
