Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1AKMs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:48:29 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41137 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1AKMs1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Tue, 11 Jan 2011 07:48:27 -0500
Message-Id: <4D2C5FA5020000780002BB21@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 11 Jan 2011 12:48:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <ian.campbell@citrix.com>
Cc: <Stefano.Stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: use PCI interfaces to request IO
	 and MEM resources on platform device.
References: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.01.11 at 12:50, Ian Campbell <ian.campbell@citrix.com> wrote:
> This is the correct interface to use and something has broken the use
> of the previous incorrect interface (which fails because the request
> conflicts with the resources assigned for the PCI device itself
> instead of nesting like the PCI interfaces do).

While I agree that using the PCI interface is preferable, I can't see
how this can make a functional difference: __pci_request_region()
calls request_region() for the port resource and
__request_mem_region() for the mmio one exactly like what was
open coded before (request_mem_region() being equivalent to
__request_mem_region(..., 0), so I don't follow how this fixes
anything but half of the potentially incorrect use of "long" for
mmio_addr.

I'm mainly asking because if it really addresses some problem,
then unmodified_drivers/linux-2.6/platform-pci/platform-pci.c
in -unstable should probably get updated too.

Jan

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: stable@kernel.org # 2.6.37 only
> ---
>  drivers/xen/platform-pci.c |   21 +++++++--------------
>  1 files changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> index c01b5dd..afbe041 100644
> --- a/drivers/xen/platform-pci.c
> +++ b/drivers/xen/platform-pci.c
> @@ -105,7 +105,7 @@ static int __devinit platform_pci_init(struct pci_dev 
> *pdev,
>  				       const struct pci_device_id *ent)
>  {
>  	int i, ret;
> -	long ioaddr, iolen;
> +	long ioaddr;
>  	long mmio_addr, mmio_len;
>  	unsigned int max_nr_gframes;
>  
> @@ -114,7 +114,6 @@ static int __devinit platform_pci_init(struct pci_dev 
> *pdev,
>  		return i;
>  
>  	ioaddr = pci_resource_start(pdev, 0);
> -	iolen = pci_resource_len(pdev, 0);
>  
>  	mmio_addr = pci_resource_start(pdev, 1);
>  	mmio_len = pci_resource_len(pdev, 1);
> @@ -125,19 +124,13 @@ static int __devinit platform_pci_init(struct pci_dev 
> *pdev,
>  		goto pci_out;
>  	}
>  
> -	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
> -		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
> -		       mmio_addr, mmio_len);
> -		ret = -EBUSY;
> +	ret = pci_request_region(pdev, 1, DRV_NAME);
> +	if (ret < 0)
>  		goto pci_out;
> -	}
>  
> -	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
> -		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
> -		       iolen, ioaddr);
> -		ret = -EBUSY;
> +	ret = pci_request_region(pdev, 0, DRV_NAME);
> +	if (ret < 0)
>  		goto mem_out;
> -	}
>  
>  	platform_mmio = mmio_addr;
>  	platform_mmiolen = mmio_len;
> @@ -169,9 +162,9 @@ static int __devinit platform_pci_init(struct pci_dev 
> *pdev,
>  	return 0;
>  
>  out:
> -	release_region(ioaddr, iolen);
> +	pci_release_region(pdev, 0);
>  mem_out:
> -	release_mem_region(mmio_addr, mmio_len);
> +	pci_release_region(pdev, 1);
>  pci_out:
>  	pci_disable_device(pdev);
>  	return ret;




