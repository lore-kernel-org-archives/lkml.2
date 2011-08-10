Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1HJNMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:12:23 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:52531 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750963Ab1HJNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:12:22 -0400
Subject: Re: [PATCH 2/6] staging: vme: make [alloc|free]_consistent bridge
 specific
From: Joe Perches <joe@perches.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: martyn.welch@ge.com, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch>
	 <1312968830-13377-3-git-send-email-manohar.vanga@cern.ch>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 06:12:20 -0700
Message-ID: <1312981940.11924.68.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:33 +0200, Manohar Vanga wrote:
> Make PCI dependent functions ([alloc|free]_consistent() in
> 'vme.c') bridge specific. By removing the dependency of the
> VME bridge framework on PCI, this patch allows for addition of
> non-PCI based VME bridges.
[]
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
[]
> +void *ca91cx42_alloc_consistent(struct device *parent, size_t size,
> +	dma_addr_t *dma)
> +{
> +	struct pci_dev *pdev;
> +
> +	/* Find pci_dev container of dev */
> +	pdev = container_of(parent, struct pci_dev, dev);
> +
> +	return pci_alloc_consistent(pdev, size, dma);
> +}
> +
> +void ca91cx42_free_consistent(struct device *parent, size_t size, void *vaddr,
> +	dma_addr_t dma)
> +{
> +	struct pci_dev *pdev;
> +
> +	/* Find pci_dev container of dev */
> +	pdev = container_of(parent, struct pci_dev, dev);
> +
> +	pci_free_consistent(pdev, size, vaddr, dma);
> +}
[]
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
[]
> @@ -2122,6 +2122,28 @@ static int tsi148_slot_get(struct vme_bridge *tsi148_bridge)
>  	return (int)slot;
>  }
>  
> +void *tsi148_alloc_consistent(struct device *parent, size_t size,
> +	dma_addr_t *dma)
> +{
> +	struct pci_dev *pdev;
> +
> +	/* Find pci_dev container of dev */
> +	pdev = container_of(parent, struct pci_dev, dev);
> +
> +	return pci_alloc_consistent(pdev, size, dma);
> +}
> +
> +void tsi148_free_consistent(struct device *parent, size_t size, void *vaddr,
> +	dma_addr_t dma)
> +{
> +	struct pci_dev *pdev;
> +
> +	/* Find pci_dev container of dev */
> +	pdev = container_of(parent, struct pci_dev, dev);
> +
> +	pci_free_consistent(pdev, size, vaddr, dma);
> +}
> +
>  static int __init tsi148_init(void)
>  {
>  	return pci_register_driver(&tsi148_driver);

Except for the name, those 2 blocks are identical.
Maybe create a non-pci generic version instead?

> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
[]
> @@ -104,28 +100,29 @@ void *vme_alloc_consistent(struct vme_resource *resource, size_t size,
>  		return NULL;
>  	}
>  
> -	/* Find pci_dev container of dev */
>  	if (bridge->parent == NULL) {
> -		printk(KERN_ERR "Dev entry NULL\n");
> +		printk(KERN_ERR "Dev entry NULL for"
> +			" bridge %s\n", bridge->name);

Please don't split formats like this.
Use unsplit format strings even if they exceed 80 cols.
This one doesn't.

		printk(KERN_ERR "Dev entry NULL for bridge %s\n", bridge->name);
or
		pr_err("Dev entry NULL for bridge %s\n", bridge->name);

> +		return NULL;
> +	}
> +
> +	if (bridge->alloc_consistent == NULL) {
> +		printk(KERN_ERR "alloc_consistent not supported by"
> +			" bridge %s\n", bridge->name);

		printk(KERN_ERR "alloc_consistent not supported by bridge %s\n",
		       bridge->name);

> @@ -138,10 +135,19 @@ void vme_free_consistent(struct vme_resource *resource, size_t size,
>  		return;
>  	}
>  
> -	/* Find pci_dev container of dev */
> -	pdev = container_of(bridge->parent, struct pci_dev, dev);
> +	if (bridge->parent == NULL) {
> +		printk(KERN_ERR "Dev entry NULL for"
> +			" bridge %s\n", bridge->name);

etc.


