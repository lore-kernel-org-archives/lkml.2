Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1BQIxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:53:45 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34523 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1BQIxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:53:43 -0500
X-IronPort-AV: E=Sophos;i="4.60,485,1291611600"; 
   d="scan'208";a="136295808"
Subject: Re: [Xen-devel] [PATCH 2/3] xen-pcifront: Sanity check the
 MSI/MSI-X values
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1297894638-28007-3-git-send-email-konrad.wilk@oracle.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
	 <1297894638-28007-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 17 Feb 2011 08:53:40 +0000
Message-ID: <1297932820.16356.1317.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> Check the returned vector values for any values that are
> odd or plain incorrect (say vector value zero), and if so
> print a warning. Also fixup the return values.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/pci/xen-pcifront.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 3a5a6fc..6acf6ae 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -277,13 +277,20 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
>  	if (likely(!err)) {
>  		if (likely(!op.value)) {
>  			/* we get the result */
> -			for (i = 0; i < nvec; i++)
> +			for (i = 0; i < nvec; i++) {
> +				if (op.msix_entries[i].vector <= 0) {
> +					dev_warn(&dev->dev, "MSI-X entry %d" \
> +						" is zero!\n", i);

The test says "<= 0" but the text says "== 0". Perhaps
					dev_warn(&dev->dev, "MSI-X entry %d has invalid vector %d\n",
						 i, op.msix_entries[i].vector);

> 
> +					err = -EINVAL;
> +					continue;

Do we need / should we set *(*vector+i) to something to indicate its
invalidness rather than leave it potentially uninitialised?

> +				}
>  				*(*vector+i) = op.msix_entries[i].vector;

BTW does the double indirection of the vector serve a purpose?
Everywhere I can see just updates *(*vector+i), I can't see any realloc
of the array itself etc.

Removing the extra level of indirection leads to vector[i] = foo instead
which is much easier on the eye.

> -			return 0;
> +			}
> +			return err;
>  		} else {
>  			printk(KERN_DEBUG "enable msix get value %x\n",
>  				op.value);
> -			return op.value;
> +			return err;

I think all of these "return err"s can now be pulled out to the end of
the function? makes it clearer what the return is.

>  		}
>  	} else {
>  		dev_err(&dev->dev, "enable msix get err %x\n", err);
> @@ -325,6 +332,10 @@ static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
>  	err = do_pci_op(pdev, &op);
>  	if (likely(!err)) {
>  		*(*vector) = op.value;
> +		if (op.value <= 0) {
> +			dev_warn(&dev->dev, "MSI entry is zero!\n");

Same comment re <= vs == 0.

> +			err = -EINVAL;
> +		}
>  	} else {
>  		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
>  				    "%x:%x\n", op.bus, op.devfn);


