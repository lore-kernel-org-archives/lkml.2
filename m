Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1BIUKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:10:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1BIUKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:01 -0500
Message-ID: <4D52F43F.5040507@ru.mvista.com>
Date: Wed, 09 Feb 2011 23:08:31 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: reduce ata_pci_[sff,bmdma]_init_one() size
References: <201102091515.22677.bzolnier@gmail.com>
In-Reply-To: <201102091515.22677.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Turn both helpers (which are used only during LLDs initialization
> time and thus are not performance sensitive) into wrappers around
> the new ata_pci_init_one() function, this cuts 20 LOC and saves
> ~1.1k of the output code size (x86-64):

>  text    data     bss     dec     hex filename
>   21392       0      19   21411    53a3 drivers/ata/libata-sff.o.before
>   20256       0      19   20275    4f33 drivers/ata/libata-sff.o.after

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/libata-sff.c |  112 +++++++++++++++++++----------------------------
>  1 file changed, 46 insertions(+), 66 deletions(-)

> Index: b/drivers/ata/libata-sff.c
> ===================================================================
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
[...]
> @@ -2538,14 +2517,22 @@ int ata_pci_sff_init_one(struct pci_dev
>  	if (rc)
>  		goto out;
>  
> -	/* prepare and activate SFF host */
> -	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
> +	if (bmdma)
> +		/* prepare and activate BMDMA host */
> +		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
> +	else
> +		/* prepare and activate SFF host */
> +		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
>  	if (rc)
>  		goto out;
>  	host->private_data = host_priv;
> -	host->flags |= hflag;
> +	host->flags |= hflags;
>  
> -	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
> +	if (bmdma) {
> +		pci_set_master(pdev);
> +		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
> +	} else
> +		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);

    Perhaps this will save even more:

	if (bmdma)
		pci_set_master(pdev);
	rc = ata_pci_sff_activate_host(host, bmdma ? ata_bmdma_interrupt :
						     ata_sff_interrupt, sht);

> @@ -2554,6 +2541,35 @@ out:
>  
>  	return rc;
>  }
> +
> +/**
> + *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
> + *	@pdev: Controller to be initialized
> + *	@ppi: array of port_info, must be enough for two ports
> + *	@sht: scsi_host_template to use when registering the host
> + *	@host_priv: host private_data
> + *	@hflag: host flags
> + *
> + *	This is a helper function which can be called from a driver's
> + *	xxx_init_one() probe function if the hardware uses traditional
> + *	IDE taskfile registers and is PIO only.
> + *
> + *	ASSUMPTION:
> + *	Nobody makes a single channel controller that appears solely as
> + *	the secondary legacy port on PCI.
> + *
> + *	LOCKING:
> + *	Inherited from PCI layer (may sleep).
> + *
> + *	RETURNS:
> + *	Zero on success, negative on errno-based value on error.
> + */
> +int ata_pci_sff_init_one(struct pci_dev *pdev,
> +		 const struct ata_port_info * const *ppi,
> +		 struct scsi_host_template *sht, void *host_priv, int hflag)

    s/hflag/hflags/ for consistency?

> +{
> +	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0);

    s/0/false/?

> +}
>  EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
>  
>  #endif /* CONFIG_PCI */
> @@ -3272,43 +3288,7 @@ int ata_pci_bmdma_init_one(struct pci_de
>  			   struct scsi_host_template *sht, void *host_priv,
>  			   int hflags)
>  {
[...]
> +	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1);

    s/1/true/?

WBR, Sergei
