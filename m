Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab0FPGKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:10:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36729 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0FPGKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:10:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C186A87.6040005@jp.fujitsu.com>
Date: Wed, 16 Jun 2010 15:09:11 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] pci: fix compilation when CONFIG_PCI_MSI=n
References: <201006161421.11148.rusty@rustcorp.com.au>
In-Reply-To: <201006161421.11148.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/16 13:51), Rusty Russell wrote:
> drivers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
> include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/pci/pci.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2266,6 +2266,7 @@ pci_intx(struct pci_dev *pdev, int enabl
>  	}
>  }
>  
> +#ifdef CONFIG_PCI_MSI
>  /**
>   * pci_msi_off - disables any msi or msix capabilities
>   * @dev: the PCI device to operate on
> @@ -2293,6 +2294,7 @@ void pci_msi_off(struct pci_dev *dev)
>  	}
>  }
>  EXPORT_SYMBOL_GPL(pci_msi_off);
> +#endif
>  
>  #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
>  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)

Rusty, thank you for reporting it.
But I think this fix is not correct.

It looks like a bug in Michael's patch:
  [PATCH for-2.6.35] virtio-pci: disable msi at startup

The patch includes a change as following:

> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -780,7 +780,11 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
> >  int pci_try_set_mwi(struct pci_dev *dev);
> >  void pci_clear_mwi(struct pci_dev *dev);
> >  void pci_intx(struct pci_dev *dev, int enable);
> > +#ifdef CONFIG_PCI_MSI
> >  void pci_msi_off(struct pci_dev *dev);
> > +#else
> > +static inline void pci_msi_off(struct pci_dev *dev) {}
> > +#endif
> >  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
> >  int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
> >  int pcix_get_max_mmrbc(struct pci_dev *dev);

According to the old commit f5f2b13129a6541debf8851bae843cbbf48298b7,
pci_msi_off() was designed to be available even when msi support is not
compiled in.  So I think this change will make something wrong.

Michael, could you check your patch?


Thanks,
H.Seto

