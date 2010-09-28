Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0I1Uy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0I1Uy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:54:27 -0400
Message-ID: <4CA255FE.7060308@redhat.com>
Date: Tue, 28 Sep 2010 17:54:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Vasiliy Kulikov <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: i7300_edac: call pci_disable_device
References: <1285696172-5612-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1285696172-5612-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-09-2010 14:49, Vasiliy Kulikov escreveu:
> i7300_init_one() should call pci_disable_device() on error.
> i7300_remove_one() should call pci_disable_device() as i7300_init_one() calls
> pci_enable_device().
> Also pci_enable_device() might return any error, not only -EIO, so check
> for nonzero return code instead of checking equation to -EIO.

hmm... not sure if this is a good idea. A lspci (before applying i7300 edac
drivers) pointed to another driver for i7300, handling other things.
A grep i7300 revels a few drivers with i7300 string on it.

So, before disabling the device, we need to be sure that this won't hurt the
other drivers.

> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  drivers/edac/i7300_edac.c |   35 +++++++++++++++++++++--------------
>  1 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
> index 38920c0..749fa75 100644
> --- a/drivers/edac/i7300_edac.c
> +++ b/drivers/edac/i7300_edac.c
> @@ -1046,7 +1046,7 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  
>  	/* wake up device */
>  	rc = pci_enable_device(pdev);
> -	if (rc == -EIO)
> +	if (rc)
>  		return rc;
>  
>  	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
> @@ -1055,8 +1055,9 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
>  
>  	/* We only are looking for func 0 of the set */
> +	rc = -ENODEV;
>  	if (PCI_FUNC(pdev->devfn) != 0)
> -		return -ENODEV;
> +		goto fail_disable;
>  
>  	/* As we don't have a motherboard identification routine to determine
>  	 * actual number of slots/dimms per channel, we thus utilize the
> @@ -1073,10 +1074,10 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  		__func__, num_channels, num_dimms_per_channel, num_csrows);
>  
>  	/* allocate a new MC control structure */
> +	rc = -ENOMEM;
>  	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
> -
>  	if (mci == NULL)
> -		return -ENOMEM;
> +		goto fail_disable;
>  
>  	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
>  
> @@ -1085,15 +1086,15 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  	pvt = mci->pvt_info;
>  	pvt->pci_dev_16_0_fsb_ctlr = pdev;	/* Record this device in our private */
>  
> +	rc = -ENOMEM;
>  	pvt->tmp_prt_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!pvt->tmp_prt_buffer) {
> -		edac_mc_free(mci);
> -		return -ENOMEM;
> -	}
> +	if (!pvt->tmp_prt_buffer)
> +		goto fail_free;
>  
>  	/* 'get' the pci devices we want to reserve for our use */
> +	rc = -ENODEV;
>  	if (i7300_get_devices(mci))
> -		goto fail0;
> +		goto fail_buffer_free;
>  
>  	mci->mc_idx = 0;
>  	mci->mtype_cap = MEM_FLAG_FB_DDR2;
> @@ -1121,13 +1122,14 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  	}
>  
>  	/* add this new MC control structure to EDAC's list of MCs */
> +	rc = -ENODEV;
>  	if (edac_mc_add_mc(mci)) {
>  		debugf0("MC: " __FILE__
>  			": %s(): failed edac_mc_add_mc()\n", __func__);
>  		/* FIXME: perhaps some code should go here that disables error
>  		 * reporting if we just enabled it
>  		 */
> -		goto fail1;
> +		goto fail_put;
>  	}
>  
>  	i7300_clear_error(mci);
> @@ -1146,14 +1148,18 @@ static int __devinit i7300_init_one(struct pci_dev *pdev,
>  	return 0;
>  
>  	/* Error exit unwinding stack */
> -fail1:
> -
> +fail_put:
>  	i7300_put_devices(mci);
>  
> -fail0:
> +fail_buffer_free:
>  	kfree(pvt->tmp_prt_buffer);
> +
> +fail_free:
>  	edac_mc_free(mci);
> -	return -ENODEV;
> +
> +fail_disable:
> +	pci_disable_device(pdev);
> +	return rc;
>  }
>  
>  /**
> @@ -1181,6 +1187,7 @@ static void __devexit i7300_remove_one(struct pci_dev *pdev)
>  
>  	kfree(tmp);
>  	edac_mc_free(mci);
> +	pci_disable_device(pdev);
>  }
>  
>  /*

