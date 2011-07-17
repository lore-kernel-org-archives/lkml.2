Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1GQFea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 01:34:30 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43875 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750984Ab1GQFe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 01:34:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QL1KNGEuWyKzgO5LVLd7PoeqFVs9ACctPMM1DNMo5uuq27GcghKse6AhRQcD6h0eooZaP2gPgoTJM936AONhb8NaEub2+iUXxoqh2mBGCjJKJ9d12WcMV5cNItyVdHNc;
Date: Sat, 16 Jul 2011 22:34:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: sfr@canb.auug.org.au, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] tpm: Move tpm_tis_reenable_interrupts out of CONFIG_PNP
 block
Message-Id: <20110716223426.f1507465.rdunlap@xenotime.net>
In-Reply-To: <1310879064.15064.4.camel@d941e-10>
References: <1310879064.15064.4.camel@d941e-10>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011 01:04:24 -0400 Stefan Berger wrote:

> This patch moves the tpm_tis_reenable_interrupts function out of the
> CONFIG_PNP-surrounded #define block. This solves a compilation error in
> case CONFIG_PNP is not defined.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

New warning:
drivers/char/tpm/tpm_tis.c:97: warning: 'is_itpm' defined but not used

Thanks.

> 
> ---
>  drivers/char/tpm/tpm_tis.c |   45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/char/tpm/tpm_tis.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
> +++ linux-2.6/drivers/char/tpm/tpm_tis.c
> @@ -731,6 +731,29 @@ out_err:
>  	tpm_remove_hardware(chip->dev);
>  	return rc;
>  }
> +
> +static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> +{
> +	u32 intmask;
> +
> +	/* reenable interrupts that device may have lost or
> +	   BIOS/firmware may have disabled */
> +	iowrite8(chip->vendor.irq, chip->vendor.iobase +
> +		 TPM_INT_VECTOR(chip->vendor.locality));
> +
> +	intmask =
> +	    ioread32(chip->vendor.iobase +
> +		     TPM_INT_ENABLE(chip->vendor.locality));
> +
> +	intmask |= TPM_INTF_CMD_READY_INT
> +	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
> +	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
> +
> +	iowrite32(intmask,
> +		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
> +}
> +
> +
>  #ifdef CONFIG_PNP
>  static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  				      const struct pnp_device_id *pnp_id)
> @@ -757,28 +780,6 @@ static int tpm_tis_pnp_suspend(struct pn
>  	return tpm_pm_suspend(&dev->dev, msg);
>  }
>  
> -static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
> -{
> -	u32 intmask;
> -
> -	/* reenable interrupts that device may have lost or
> -	   BIOS/firmware may have disabled */
> -	iowrite8(chip->vendor.irq, chip->vendor.iobase +
> -		 TPM_INT_VECTOR(chip->vendor.locality));
> -
> -	intmask =
> -	    ioread32(chip->vendor.iobase +
> -		     TPM_INT_ENABLE(chip->vendor.locality));
> -
> -	intmask |= TPM_INTF_CMD_READY_INT
> -	    | TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_DATA_AVAIL_INT
> -	    | TPM_INTF_STS_VALID_INT | TPM_GLOBAL_INT_ENABLE;
> -
> -	iowrite32(intmask,
> -		  chip->vendor.iobase + TPM_INT_ENABLE(chip->vendor.locality));
> -}
> -
> -
>  static int tpm_tis_pnp_resume(struct pnp_dev *dev)
>  {
>  	struct tpm_chip *chip = pnp_get_drvdata(dev);
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
