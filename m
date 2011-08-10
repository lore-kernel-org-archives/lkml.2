Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1HJNvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:51:06 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:40392 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751724Ab1HJNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:51:04 -0400
Subject: Re: [PATCH 2/6] staging: vme: make [alloc|free]_consistent bridge
 specific
From: Joe Perches <joe@perches.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E4288CB.7080708@ge.com>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
	 <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>
	 <1312981940.11924.68.camel@Joe-Laptop>  <4E4288CB.7080708@ge.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 06:51:01 -0700
Message-ID: <1312984261.11924.91.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 14:34 +0100, Martyn Welch wrote:
> On 10/08/11 14:12, Joe Perches wrote:
> > On Wed, 2011-08-10 at 11:33 +0200, Manohar Vanga wrote:
> >> Make PCI dependent functions ([alloc|free]_consistent() in
> >> 'vme.c') bridge specific. By removing the dependency of the
> >> VME bridge framework on PCI, this patch allows for addition of
> >> non-PCI based VME bridges.
> > []
> >> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> > []
> >> +void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
> >> +	dma_addr_t *dma)
> >> +{
> >> +	struct pci_dev *pdev;
> >> +
> >> +	/* Find pci_dev container of dev */
> >> +	pdev = container_of(parent, struct pci_dev, dev);
> >> +
> >> +	return pci_alloc_consistent(pdev, size, dma);
> >> +}
> >> +
> >> +void ca91cx42_free_consistent(struct device *parent, size_t size, void *vaddr,
> >> +	dma_addr_t dma)
> >> +{
> >> +	struct pci_dev *pdev;
> >> +
> >> +	/* Find pci_dev container of dev */
> >> +	pdev = container_of(parent, struct pci_dev, dev);
> >> +
> >> +	pci_free_consistent(pdev, size, vaddr, dma);
> >> +}
> > []
> >> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> > []
> >> @@ -2122,6 +2122,28 @@ static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
> >>  	return (int)slot;
> >>  }
> >>  
> >> +void *tsi148_alloc_consistent(struct device *parent, size_t size,
> >> +	dma_addr_t *dma)
> >> +{
> >> +	struct pci_dev *pdev;
> >> +
> >> +	/* Find pci_dev container of dev */
> >> +	pdev = container_of(parent, struct pci_dev, dev);
> >> +
> >> +	return pci_alloc_consistent(pdev, size, dma);
> >> +}
> >> +
> >> +void tsi148_free_consistent(struct device *parent, size_t size, void *vaddr,
> >> +	dma_addr_t dma)
> >> +{
> >> +	struct pci_dev *pdev;
> >> +
> >> +	/* Find pci_dev container of dev */
> >> +	pdev = container_of(parent, struct pci_dev, dev);
> >> +
> >> +	pci_free_consistent(pdev, size, vaddr, dma);
> >> +}
> >> +
> >>  static int __init tsi148_init(void)
> >>  {
> >>  	return pci_register_driver(&tsi148_driver);
> > 
> > Except for the name, those 2 blocks are identical.
> > Maybe create a non-pci generic version instead?
> > 
> 
> I'm not sure you can (I spent quite a bit of time attempting to do just that
> when I wrote the original). It just so happens that both of the bridges we
> have at the moment are PCI devices,

Doesn't something like this work?

void *generic_vme_pci_alloc_consistent(struct device *parent, size_t size,
				       dma_addr_t *dma)
[implementation...]
EXPORT_SYMBOL(generic_vme_pci_alloc_consistent);
(if necessary)

void *generic_vme_pci_free_consistent(struct device *parent, size_t size,
				      void *vaddr, dma_addr_t dma)
[implementation...]
EXPORT_SYMBOL(generic_vme_pci_free_consistent);

and uses like:

+       ca91cx42_bridge->alloc_consistent = generic_vme_pci_alloc_consistent;
+       ca91cx42_bridge->free_consistent = generic_vme_pci_free_consistent;

?

