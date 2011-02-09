Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1BIT7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:59:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1BIT7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:59:21 -0500
Message-ID: <4D52F1BF.3090006@ru.mvista.com>
Date: Wed, 09 Feb 2011 22:57:51 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: add CONFIG_SATA_HOST config option
References: <201102091514.31355.bzolnier@gmail.com>
In-Reply-To: <201102091514.31355.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Add CONFIG_SATA_HOST config option (for selecting SATA Host
> support) to make setup easier on PATA-only systems.

> Additionally this allows us to save ~9.5k of the output code
> size (x86-64) on such systems:

>    text    data     bss     dec     hex filename
>   49909    6576      57   56542    dcde drivers/ata/libata-core.o.before
>   31862      16       2   31880    7c88 drivers/ata/libata-eh.o.before
>   20256       0      19   20275    4f33 drivers/ata/libata-sff.o.before
>   44495    6576      57   51128    c7b8 drivers/ata/libata-core.o.after
>   27831      16       2   27849    6cc9 drivers/ata/libata-eh.o.after
>   20144       0      19   20163    4ec3 drivers/ata/libata-sff.o.after

    Good job!

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> I also wonder if  SATA code should be moved to libata-sata.c (to avoid ifdefs)?

>  drivers/ata/Kconfig       |   25 ++++++++--
>  drivers/ata/libata-core.c |  107 +++++++++++++++++++++++++++++++++++++++-------
>  drivers/ata/libata-eh.c   |   21 ++++++++-
>  drivers/ata/libata-sff.c  |    8 +++
>  4 files changed, 141 insertions(+), 20 deletions(-)

> Index: b/drivers/ata/Kconfig
> ===================================================================
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
[...]
> @@ -122,7 +133,7 @@ comment "SFF controllers with custom DMA
>  
>  config PDC_ADMA
>  	tristate "Pacific Digital ADMA support"
> -	depends on PCI
> +	depends on PCI && SATA_HOST

    I thought ADMA spec. was designed for PATA... are you sure this should 
depend on CONFIG_SATA_HOST?

> @@ -165,8 +176,6 @@ config ATA_BMDMA
>  
>  if ATA_BMDMA
>  
> -comment "SATA SFF controllers with BMDMA"
> -
>  config ATA_PIIX
>  	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
>  	depends on PCI
> @@ -177,6 +186,10 @@ config ATA_PIIX
>  
>  	  If unsure, say N.
>  
> +if SATA_HOST
> +
> +comment "SATA/PATA SFF controllers with BMDMA"

    How it can be "SATA/PATA" if it's only enabled when CONFIG_SATA_HOST=y?

> Index: b/drivers/ata/libata-core.c
> ===================================================================
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
[...]
> @@ -601,6 +609,9 @@ void ata_tf_from_fis(const u8 *fis, stru
>  	tf->nsect	= fis[12];
>  	tf->hob_nsect	= fis[13];
>  }
> +#else
> +void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf) { }
> +#endif

    Is it really ever called by non-SATA code? Ah, it's exported at end of file 
and so should be defined... isn't it better to carry over the export from the 
bottom of the file (and thus silence one of checkpatch.pl's warnings :-).

> @@ -2690,6 +2718,7 @@ struct ata_device *ata_dev_pair(struct a
>  	return pair;
>  }
>  
> +#ifdef CONFIG_SATA_HOST
>  /**
>   *	sata_down_spd_limit - adjust SATA spd limit downward
>   *	@link: Link to adjust SATA spd limit for
> @@ -2843,6 +2872,18 @@ int sata_set_spd(struct ata_link *link)
>  
>  	return 1;
>  }
> +#else
[...]
> +int sata_set_spd(struct ata_link *link)
> +{
> +	return 0;
> +}

    Again, I don't think that's called by non-SATA code...

> +#endif
> +EXPORT_SYMBOL_GPL(sata_set_spd);

    Here you're carrying over the export...

> @@ -3436,6 +3477,7 @@ int ata_wait_after_reset(struct ata_link
>  	return ata_wait_ready(link, deadline, check_ready);
>  }
>  
> +#ifdef CONFIG_SATA_HOST
>  /**
>   *	sata_link_debounce - debounce SATA phy status
>   *	@link: ATA link to debounce SATA phy status for
> @@ -3638,6 +3680,26 @@ int sata_link_scr_lpm(struct ata_link *l
>  	ehc->i.serror &= ~SERR_PHYRDY_CHG;
>  	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
>  }
> +#else
> +int sata_link_debounce(struct ata_link *link, const unsigned long *params,
> +		       unsigned long deadline)
> +{
> +	return -EOPNOTSUPP;
> +}

    Again, not called by non-SATA code...

> +int sata_link_resume(struct ata_link *link, const unsigned long *params,
> +		     unsigned long deadline)
> +{
> +	return -EOPNOTSUPP;
> +}

    This one is not called by non-SATA code now either...

WBR, Sergei

