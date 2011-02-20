Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1BTNoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:44:38 -0500
Received: from mail-ey0-f180.google.com ([209.85.215.180]:61630 "EHLO
	mail-ey0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1BTNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:44:36 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Feb 2011 08:44:35 EST
Message-ID: <4D6118DC.80505@ru.mvista.com>
Date: Sun, 20 Feb 2011 16:36:28 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122346.19110.8441.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122346.19110.8441.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.02.2011 15:23, Bartlomiej Zolnierkiewicz wrote:

>  From ca6c1fbc7d853829524b87a3bcbbb1f67796281c Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:24 +0100
> Subject: [PATCH 02/20] ata_piix: unify code for programming PIO and MWDMA timings

> Besides making things noticably simpler it results in ~2% decrease in
> the driver LOC count and also ~2% decrease in the driver binary size
> (as measured on x86-32).

> Fix piix_set_piomode() documentation while at it.

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 0f4856d..c954f91 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -696,22 +696,11 @@ static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
>
>   static DEFINE_SPINLOCK(piix_lock);
>
> -/**
> - *	piix_set_piomode - Initialize host controller PATA PIO timings
> - *	@ap: Port whose timings we are configuring
> - *	@adev: um
> - *
> - *	Set PIO mode for device, in host controller PCI config space.
> - *
> - *	LOCKING:
> - *	None (inherited from caller).
> - */
> -
> -static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
> +			     u8 pio, bool use_mwdma)
>   {
>   	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
>   	unsigned long flags;
> -	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
>   	unsigned int is_slave	= (adev->devno != 0);
>   	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
>   	unsigned int slave_port	= 0x44;
> @@ -732,14 +721,18 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
>   			    { 2, 1 },
>   			    { 2, 3 }, };
>
> -	if (pio >= 2)
> +	if (pio >= 2 || use_mwdma)

    The 'use_mwdma' check is actually superfluous...

>   		control |= 1;	/* TIME1 enable */
> -	if (ata_pio_need_iordy(adev))
> +	if (ata_pio_need_iordy(adev) || use_mwdma)
>   		control |= 2;	/* IE enable */

    Why IORDY is enabled for MWDMA has always been beyond me... I understand 
that the stupid Intel docs are to be blamed here.

> -
>   	/* Intel specifies that the PPE functionality is for disk only */
>   	if (adev->class == ATA_DEV_ATA)
>   		control |= 4;	/* PPE enable */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO into PIO0 */

    It's not the preferred multi-line comment style:

/*
  * bla
  * bla
  */

> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))

    Parens not needed around +.

> @@ -803,31 +812,20 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
>   {
>   	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
>   	unsigned long flags;
> -	u8 master_port		= ap->port_no ? 0x42 : 0x40;
> -	u16 master_data;
>   	u8 speed		= adev->dma_mode;
>   	int devid		= adev->devno + 2 * ap->port_no;
>   	u8 udma_enable		= 0;
>
> -	static const	 /* ISP  RTC */
> -	u8 timings[][2]	= { { 0, 0 },
> -			    { 0, 0 },
> -			    { 1, 0 },
> -			    { 2, 1 },
> -			    { 2, 3 }, };
> -
> -	spin_lock_irqsave(&piix_lock, flags);
> -
> -	pci_read_config_word(dev, master_port, &master_data);
> -	if (ap->udma_mask)
> -		pci_read_config_byte(dev, 0x48, &udma_enable);

    I don't think you should have removed that...

> @@ -860,56 +858,20 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
>   			   performance (WR_PingPong_En) */
>   			pci_write_config_word(dev, 0x54, ideconf);
>   		}
> +
> +		pci_write_config_byte(dev, 0x48, udma_enable);
> +
> +		spin_unlock_irqrestore(&piix_lock, flags);
>   	} else {
[...]
> -		if (ap->udma_mask)
> -			udma_enable &= ~(1 << devid);

    This does not seem correct -- you must disable UDMA when programming MWDMA.

> -
> -		pci_write_config_word(dev, master_port, master_data);
> +		piix_set_timings(ap, adev, pio, 1);
>   	}
> -	/* Don't scribble on 0x48 if the controller does not support UDMA */
> -	if (ap->udma_mask)
> -		pci_write_config_byte(dev, 0x48, udma_enable);
> -
> -	spin_unlock_irqrestore(&piix_lock, flags);
>   }
>
>   /**

WBR, Sergei
