Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1BTOjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:39:00 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49560 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1BTOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:38:59 -0500
Message-ID: <4D612734.20605@ru.mvista.com>
Date: Sun, 20 Feb 2011 17:37:40 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/20] pata_it8213: unify code for programming PIO and
 MWDMA timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122424.19110.10832.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122424.19110.10832.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:

>  From 57632718f2e761e69b96e14f6900a487bad5d586 Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:26 +0100
> Subject: [PATCH 07/20] pata_it8213: unify code for programming PIO and MWDMA timings

> Besides making things noticably simpler it results in ~9% decrease in
> the driver LOC count and also ~6% decrease in the driver binary size
> (as measured on x86-32).

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
> index 911f50b..ccfd1ae 100644
> --- a/drivers/ata/pata_it8213.c
> +++ b/drivers/ata/pata_it8213.c
[...]
> @@ -92,13 +81,18 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   			    { 2, 1 },
>   			    { 2, 3 }, };
>
> -	if (pio > 1)
> +	if (pio > 1 || use_mwdma)
>   		control |= 1;	/* TIME */
> -	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
> +	if (ata_pio_need_iordy(adev) || use_mwdma)
>   		control |= 2;	/* IE */
>   	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
>   	if (adev->class != ATA_DEV_ATA)
>   		control |= 4;	/* PPE */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO into PIO0 */

    Fix the comment style, please.

> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))

    Parens not needed around +.

> +		/* Enable DMA timing only */
> +		control |= 8;	/* PIO cycles in PIO0 */
>
>   	pci_read_config_word(dev, master_port,&master_data);
>
> @@ -126,6 +120,22 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   }
>
>   /**
> + *	it8213_set_piomode - Initialize host controller PATA PIO timings
> + *	@ap: Port whose timings we are configuring
> + *	@adev: Device whose timings we are configuring
> + *
> + *	Set PIO mode for device, in host controller PCI config space.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + */
> +
> +static void it8213_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	it8213_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);

     s/0/false/?

> @@ -140,23 +150,14 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
>   {
>   	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
> -	u16 master_data;
>   	u8 speed		= adev->dma_mode;
>   	int devid		= adev->devno;
>   	u8 udma_enable;
>
> -	static const	 /* ISP  RTC */
> -	u8 timings[][2]	= { { 0, 0 },
> -			    { 0, 0 },
> -			    { 1, 0 },
> -			    { 2, 1 },
> -			    { 2, 3 }, };
> -
> -	pci_read_config_word(dev, 0x40,&master_data);
>   	pci_read_config_byte(dev, 0x48,&udma_enable);

    Strange, here you're not moving that read and nnot removing disabling of 
UDMA -- is that because of the missing lock?

> @@ -184,46 +185,16 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
[...]
> +		it8213_set_timings(ap, adev, pio, 1);

    s/1/true/?

> +
>   		udma_enable&= ~(1 << devid);
> -		pci_write_config_word(dev, 0x40, master_data);
>   	}
>   	pci_write_config_byte(dev, 0x48, udma_enable);
>   }

WBR, Sergei
