Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1AKNBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:01:31 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45936 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab1AKNB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:01:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,307,1291611600"; 
   d="scan'208";a="11871145"
Subject: Re: [Xen-devel] [PATCH] xen: use PCI interfaces to request IO	 and
 MEM resources on platform device.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jan Beulich <JBeulich@novell.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D2C5FA5020000780002BB21@vpn.id2.novell.com>
References: <1294746628-20396-1-git-send-email-ian.campbell@citrix.com>
	 <4D2C5FA5020000780002BB21@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 11 Jan 2011 13:01:24 +0000
Message-ID: <1294750884.3831.5866.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 12:48 +0000, Jan Beulich wrote:
> >>> On 11.01.11 at 12:50, Ian Campbell <ian.campbell@citrix.com> wrote:
> > This is the correct interface to use and something has broken the use
> > of the previous incorrect interface (which fails because the request
> > conflicts with the resources assigned for the PCI device itself
> > instead of nesting like the PCI interfaces do).
> 
> While I agree that using the PCI interface is preferable, I can't see
> how this can make a functional difference: __pci_request_region()
> calls request_region() for the port resource and
> __request_mem_region() for the mmio one exactly like what was
> open coded before (request_mem_region() being equivalent to
> __request_mem_region(..., 0), so I don't follow how this fixes
> anything

request_mem_region was failing, the requested region appeared to
conflict with the top level "PCI mem" resource. I don't know why and I
didn't investigate deeper because using the pci_* interfaces is correct
in its own right.

The old way was correct circa 2.6.37-rc5 but broken in 2.6.37 final,
there were a bunch of (reverts of) PCI resource changes in that window,
If I had to make a guess I'd say it was something in there which did it.

>  but half of the potentially incorrect use of "long" for
> mmio_addr.

Hmm yes, that should probably have a better type, although we probably
know it's going to be <4G. Can you spin a patch please?

> I'm mainly asking because if it really addresses some problem,
> then unmodified_drivers/linux-2.6/platform-pci/platform-pci.c
> in -unstable should probably get updated too.

Assuming the pci_* interfaces exist back as far as we care about for
those drivers then I don't see why not to apply it.

Ian.

> 
> Jan
> 
> > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > Cc: stable@kernel.org # 2.6.37 only
> > ---
> >  drivers/xen/platform-pci.c |   21 +++++++--------------
> >  1 files changed, 7 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> > index c01b5dd..afbe041 100644
> > --- a/drivers/xen/platform-pci.c
> > +++ b/drivers/xen/platform-pci.c
> > @@ -105,7 +105,7 @@ static int __devinit platform_pci_init(struct pci_dev 
> > *pdev,
> >  				       const struct pci_device_id *ent)
> >  {
> >  	int i, ret;
> > -	long ioaddr, iolen;
> > +	long ioaddr;
> >  	long mmio_addr, mmio_len;
> >  	unsigned int max_nr_gframes;
> >  
> > @@ -114,7 +114,6 @@ static int __devinit platform_pci_init(struct pci_dev 
> > *pdev,
> >  		return i;
> >  
> >  	ioaddr = pci_resource_start(pdev, 0);
> > -	iolen = pci_resource_len(pdev, 0);
> >  
> >  	mmio_addr = pci_resource_start(pdev, 1);
> >  	mmio_len = pci_resource_len(pdev, 1);
> > @@ -125,19 +124,13 @@ static int __devinit platform_pci_init(struct pci_dev 
> > *pdev,
> >  		goto pci_out;
> >  	}
> >  
> > -	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
> > -		dev_err(&pdev->dev, "MEM I/O resource 0x%lx @ 0x%lx busy\n",
> > -		       mmio_addr, mmio_len);
> > -		ret = -EBUSY;
> > +	ret = pci_request_region(pdev, 1, DRV_NAME);
> > +	if (ret < 0)
> >  		goto pci_out;
> > -	}
> >  
> > -	if (request_region(ioaddr, iolen, DRV_NAME) == NULL) {
> > -		dev_err(&pdev->dev, "I/O resource 0x%lx @ 0x%lx busy\n",
> > -		       iolen, ioaddr);
> > -		ret = -EBUSY;
> > +	ret = pci_request_region(pdev, 0, DRV_NAME);
> > +	if (ret < 0)
> >  		goto mem_out;
> > -	}
> >  
> >  	platform_mmio = mmio_addr;
> >  	platform_mmiolen = mmio_len;
> > @@ -169,9 +162,9 @@ static int __devinit platform_pci_init(struct pci_dev 
> > *pdev,
> >  	return 0;
> >  
> >  out:
> > -	release_region(ioaddr, iolen);
> > +	pci_release_region(pdev, 0);
> >  mem_out:
> > -	release_mem_region(mmio_addr, mmio_len);
> > +	pci_release_region(pdev, 1);
> >  pci_out:
> >  	pci_disable_device(pdev);
> >  	return ret;
> 
> 
> 
> 


