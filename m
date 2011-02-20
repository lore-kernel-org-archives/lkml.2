Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1BTOd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:33:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35277 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1BTOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:33:27 -0500
Message-ID: <4D6125E7.2090706@ru.mvista.com>
Date: Sun, 20 Feb 2011 17:32:07 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/20] pata_efar: unify code for programming PIO and MWDMA
 timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122401.19110.20615.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122401.19110.20615.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:

>  From 2de7db4bcc16b7e95cca9ceb5921a6f620be76b7 Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:25 +0100
> Subject: [PATCH 04/20] pata_efar: unify code for programming PIO and MWDMA timings

> Besides making things noticably simpler it results in ~10% decrease in
> the driver LOC count and also ~8% decrease in the driver binary size
> (as measured on x86-32).

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
> index afe92b7..1e2ff7d 100644
> --- a/drivers/ata/pata_efar.c
> +++ b/drivers/ata/pata_efar.c
[...]
> @@ -103,13 +92,18 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   			    { 2, 1 },
>   			    { 2, 3 }, };
>
> -	if (pio>  1)
> +	if (pio>  1 || use_mwdma)
>   		control |= 1;	/* TIME */
> -	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
> +	if (ata_pio_need_iordy(adev) || use_mwdma)
>   		control |= 2;	/* IE */

    Same comments as for ata_piix for these two bits...

>   	/* Intel specifies that the prefetch/posting is for disk only */
>   	if (adev->class == ATA_DEV_ATA)
>   		control |= 4;	/* PPE */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO into PIO0 */

    Fix comment style, like in ata_piix.

> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))

    Parens not needed around +.

> @@ -145,6 +139,22 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   }
>
>   /**
> + *	efar_set_piomode - Initialize host controller PATA PIO timings
> + *	@ap: Port whose timings we are configuring
> + *	@adev: Device to program
> + *
> + *	Set PIO mode for device, in host controller PCI config space.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + */
> +
> +static void efar_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	efar_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);

    s/0/false/? Likewise in ata_piix...

> @@ -158,29 +168,19 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
>   {
>   	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
> -	u8 master_port		= ap->port_no ? 0x42 : 0x40;
> -	u16 master_data;
>   	u8 speed		= adev->dma_mode;
>   	int devid		= adev->devno + 2 * ap->port_no;
>   	unsigned long flags;
>   	u8 udma_enable;
>
> -	static const	 /* ISP  RTC */
> -	u8 timings[][2]	= { { 0, 0 },
> -			    { 0, 0 },
> -			    { 1, 0 },
> -			    { 2, 1 },
> -			    { 2, 3 }, };
> -
> -	spin_lock_irqsave(&efar_lock, flags);
> -
> -	pci_read_config_word(dev, master_port, &master_data);
> -	pci_read_config_byte(dev, 0x48, &udma_enable);
> -
>   	if (speed>= XFER_UDMA_0) {
> -		unsigned int udma	= adev->dma_mode - XFER_UDMA_0;
> +		unsigned int udma = speed - XFER_UDMA_0;
>   		u16 udma_timing;
>
> +		spin_lock_irqsave(&efar_lock, flags);
> +
> +		pci_read_config_byte(dev, 0x48, &udma_enable);

    Don't think you should have moved this...

> +
>   		udma_enable |= (1 << devid);
>
>   		/* Load the UDMA mode number */
> @@ -188,50 +188,20 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
[...]
> -		udma_enable &= ~(1 << devid);
> -		pci_write_config_word(dev, master_port, master_data);

    No, you should disable UDMA when programming MWDMA.

> +		efar_set_timings(ap, adev, pio, 1);

    s/1/true/? Likewise in ata_piix...

WBR, Sergei
