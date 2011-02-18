Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1BROPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:15:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9363 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1BROPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:15:47 -0500
X-IronPort-AV: E=Sophos;i="4.62,187,1297054800"; 
   d="scan'208";a="136515083"
Subject: Re: [Xen-devel] [PATCH 2/3] xen-pcifront: Sanity check the
 MSI/MSI-X values
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110218140845.GB8446@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
	 <1297894638-28007-3-git-send-email-konrad.wilk@oracle.com>
	 <1297932820.16356.1317.camel@zakaz.uk.xensource.com>
	 <20110218140845.GB8446@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 18 Feb 2011 14:15:43 +0000
Message-ID: <1298038543.16356.3325.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 14:08 +0000, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 17, 2011 at 08:53:40AM +0000, Ian Campbell wrote:
> > On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > > Check the returned vector values for any values that are
> > > odd or plain incorrect (say vector value zero), and if so
> > > print a warning. Also fixup the return values.
> > > 
> 
> How about this one (and there is a cleanup patch shortly following for the *(vector)...)
> 
> From 631b743a5a587d195bf612112026eec8ea649344 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 16 Feb 2011 13:43:22 -0500
> Subject: [PATCH 2/5] xen-pcifront: Sanity check the MSI/MSI-X values
> 
> Check the returned vector values for any values that are
> odd or plain incorrect (say vector value zero), and if so
> print a warning. Also fixup the return values.
> 
> This patch was precipiated by the Xen PCIBack returning the
> incorrect values due to how it was retrieving PIRQ values.
> This has been fixed in the xen-pciback by
> "xen/pciback: Utilize 'xen_pirq_from_irq' to get PIRQ value"
> patch.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/pci/xen-pcifront.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 030ce37..d9fd1e0 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -277,18 +277,25 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
>  	if (likely(!err)) {
>  		if (likely(!op.value)) {
>  			/* we get the result */
> -			for (i = 0; i < nvec; i++)
> +			for (i = 0; i < nvec; i++) {
> +				if (op.msix_entries[i].vector <= 0) {
> +					dev_warn(&dev->dev, "MSI-X entry %d" \
> +						" is invalid: %d!\n", i,

String constants are not subject to the 80-column limit in these days
and the preference is to not split them to make them more greppable.

Otherwise:

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>

> +						op.msix_entries[i].vector);
> +					err = -EINVAL;
> +					*(*vector+i) = -1;
> +					continue;
> +				}
>  				*(*vector+i) = op.msix_entries[i].vector;
> -			return 0;
> +			}
>  		} else {
>  			printk(KERN_DEBUG "enable msix get value %x\n",
>  				op.value);
> -			return op.value;
>  		}
>  	} else {
>  		dev_err(&dev->dev, "enable msix get err %x\n", err);
> -		return err;
>  	}
> +	return err;
>  }
>  
>  static void pci_frontend_disable_msix(struct pci_dev *dev)
> @@ -325,6 +332,12 @@ static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
>  	err = do_pci_op(pdev, &op);
>  	if (likely(!err)) {
>  		*(*vector) = op.value;
> +		if (op.value <= 0) {
> +			dev_warn(&dev->dev, "MSI entry is invalid: %d!\n",
> +				op.value);
> +			err = -EINVAL;
> +			*(*vector) = -1;	
> +		}
>  	} else {
>  		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
>  				    "%x:%x\n", op.bus, op.devfn);


