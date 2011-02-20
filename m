Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1BTOyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 09:54:20 -0500
Received: from mail-ey0-f180.google.com ([209.85.215.180]:43395 "EHLO
	mail-ey0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab1BTOyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 09:54:19 -0500
Message-ID: <4D612ACB.7080708@ru.mvista.com>
Date: Sun, 20 Feb 2011 17:52:59 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/20] pata_oldpiix: unify code for programming PIO and
 MWDMA timings
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122438.19110.37982.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122438.19110.37982.sendpatchset@linux-mhg7.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:

>  From 30f6c60ad1e2f9c640352b74279fdf8a930847bf Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:26 +0100
> Subject: [PATCH 09/20] pata_oldpiix: unify code for programming PIO and MWDMA timings

> Besides making things noticably simpler it results in ~12% decrease in
> the driver LOC count and also ~5% decrease in the driver binary size
> (as measured on x86-32).

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
[...]

> diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
> index b811c16..433d2fc 100644
> --- a/drivers/ata/pata_oldpiix.c
> +++ b/drivers/ata/pata_oldpiix.c
[...]
> @@ -82,14 +71,18 @@ static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   			    { 2, 1 },
>   			    { 2, 3 }, };
>
> -	if (pio>  1)
> +	if (pio > 1 || use_mwdma)

    'use_mwdma' check is superfluous...

>   		control |= 1;	/* TIME */
> -	if (ata_pio_need_iordy(adev))
> +	if (ata_pio_need_iordy(adev) || use_mwdma)
>   		control |= 2;	/* IE */
> -
>   	/* Intel specifies that the prefetch/posting is for disk only */
>   	if (adev->class == ATA_DEV_ATA)
>   		control |= 4;	/* PPE */
> +	/* If the drive MWDMA is faster than it can do PIO then
> +	   we must force PIO into PIO0 */

    Please fix the comment style.

> +	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))

    Parens not needed around +.

> +		/* Enable DMA timing only */
> +		control |= 8;	/* PIO cycles in PIO0 */
>
>   	pci_read_config_word(dev, idetm_port,&idetm_data);
>
> @@ -113,6 +106,22 @@ static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   }
>
>   /**
> + *	oldpiix_set_piomode - Initialize host controller PATA PIO timings
> + *	@ap: Port whose timings we are configuring
> + *	@adev: Device whose timings we are configuring
> + *
> + *	Set PIO mode for device, in host controller PCI config space.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + */
> +
> +static void oldpiix_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	oldpiix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);

    s/0/false/?

> +}
> +
> +/**
>    *	oldpiix_set_dmamode - Initialize host controller PATA DMA timings
>    *	@ap: Port whose timings we are configuring
>    *	@adev: Device to program
> @@ -125,58 +134,15 @@ static void oldpiix_set_piomode (struct ata_port *ap, struct ata_device *adev)
[...]
> +	oldpiix_set_timings(ap, adev, pio, 1);

    s/1/true/?

WBR, Sergei
