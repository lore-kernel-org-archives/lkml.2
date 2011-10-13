Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1JMMXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:23:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1JMMXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:23:47 -0400
Message-ID: <4E96D81F.8000400@mvista.com>
Date: Thu, 13 Oct 2011 16:22:55 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_via: add via_fixup()
References: <201110131310.51896.bzolnier@gmail.com>
In-Reply-To: <201110131310.51896.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-10-2011 15:10, Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_via: add via_fixup()

> Factor out common code from via_[re]init_one() to via_fixup().

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> earlier references:
> https://lkml.org/lkml/2009/11/25/381

>   drivers/ata/pata_via.c |   49 +++++++++++++++++++++++--------------------------
>   1 file changed, 23 insertions(+), 26 deletions(-)

> Index: b/drivers/ata/pata_via.c
> ===================================================================
> --- a/drivers/ata/pata_via.c
> +++ b/drivers/ata/pata_via.c
> @@ -491,6 +491,27 @@ static void via_config_fifo(struct pci_d
>   	}
>   }
>
> +static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
> +{
> +	u32 timing;
> +
> +	/* Initialise the FIFO for the enabled channels. */
> +	via_config_fifo(pdev, config->flags);
> +
> +	if (config->udma_mask == ATA_UDMA4) {
> +		/* The 66 MHz devices require we enable the clock */
> +		pci_read_config_dword(pdev, 0x50,&timing);
> +		timing |= 0x80008;
> +		pci_write_config_dword(pdev, 0x50, timing);
> +	}

    Hm, via_init_one() doesn't do this now... but used to do this before your 
patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=460f5318460a9a3b2562d8055b9fb1c60b768e1f

    Was that patch wrong or am I misundertanding?

> +	if (config->flags&  VIA_BAD_CLK66) {
> +		/* Disable the 66MHz clock on problem devices */
> +		pci_read_config_dword(pdev, 0x50,&timing);
> +		timing&= ~0x80008;
> +		pci_write_config_dword(pdev, 0x50, timing);
> +	}
> +}
> +
>   /**
>    *	via_init_one		-	discovery callback
>    *	@pdev: PCI device
> @@ -553,7 +574,6 @@ static int via_init_one(struct pci_dev *
>   	const struct via_isa_bridge *config;
>   	static int printed_version;
>   	u8 enable;
> -	u32 timing;
>   	unsigned long flags = id->driver_data;
>   	int rc;
>
> @@ -593,9 +613,6 @@ static int via_init_one(struct pci_dev *
>   			return -ENODEV;
>   	}
>
> -	/* Initialise the FIFO for the enabled channels. */
> -	via_config_fifo(pdev, config->flags);
> -
>   	/* Clock set up */
>   	switch (config->udma_mask) {
>   	case 0x00:
> @@ -621,12 +638,7 @@ static int via_init_one(struct pci_dev *
>   		return -ENODEV;
>    	}
>
> -	if (config->flags&  VIA_BAD_CLK66) {
> -		/* Disable the 66MHz clock on problem devices */
> -		pci_read_config_dword(pdev, 0x50,&timing);
> -		timing&= ~0x80008;
> -		pci_write_config_dword(pdev, 0x50, timing);
> -	}
> +	via_fixup(pdev, config);
>
>   	/* We have established the device type, now fire it up */
>   	return ata_pci_bmdma_init_one(pdev, ppi,&via_sht, (void *)config, 0);

WBR, Sergei
