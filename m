Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0FPI1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:27:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0FPI1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:27:35 -0400
Date: Wed, 16 Jun 2010 11:22:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: fix compilation when CONFIG_PCI_MSI=n
Message-ID: <20100616082240.GA3848@redhat.com>
References: <201006161421.11148.rusty@rustcorp.com.au> <4C186A87.6040005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C186A87.6040005@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 03:09:11PM +0900, Hidetoshi Seto wrote:
> (2010/06/16 13:51), Rusty Russell wrote:
> > drivers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
> > include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  drivers/pci/pci.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2266,6 +2266,7 @@ pci_intx(struct pci_dev *pdev, int enabl
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_PCI_MSI
> >  /**
> >   * pci_msi_off - disables any msi or msix capabilities
> >   * @dev: the PCI device to operate on
> > @@ -2293,6 +2294,7 @@ void pci_msi_off(struct pci_dev *dev)
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(pci_msi_off);
> > +#endif
> >  
> >  #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
> >  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
> 
> Rusty, thank you for reporting it.
> But I think this fix is not correct.
> 
> It looks like a bug in Michael's patch:
>   [PATCH for-2.6.35] virtio-pci: disable msi at startup
> 
> The patch includes a change as following:
> 
> > > --- a/include/linux/pci.h
> > > +++ b/include/linux/pci.h
> > > @@ -780,7 +780,11 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
> > >  int pci_try_set_mwi(struct pci_dev *dev);
> > >  void pci_clear_mwi(struct pci_dev *dev);
> > >  void pci_intx(struct pci_dev *dev, int enable);
> > > +#ifdef CONFIG_PCI_MSI
> > >  void pci_msi_off(struct pci_dev *dev);
> > > +#else
> > > +static inline void pci_msi_off(struct pci_dev *dev) {}
> > > +#endif
> > >  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
> > >  int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
> > >  int pcix_get_max_mmrbc(struct pci_dev *dev);
> 
> According to the old commit f5f2b13129a6541debf8851bae843cbbf48298b7,
> pci_msi_off() was designed to be available even when msi support is not
> compiled in.  So I think this change will make something wrong.
> 
> Michael, could you check your patch?
> 
> 
> Thanks,
> H.Seto

You are right. I didn't think this through: we must disable
the capability at startup even if the current kernel does not
support MSI, otherwise the device won't work.

Please apply this on top.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 31d8a12..7cb0084 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -780,11 +780,7 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
-#ifdef CONFIG_PCI_MSI
 void pci_msi_off(struct pci_dev *dev);
-#else
-static inline void pci_msi_off(struct pci_dev *dev) {}
-#endif
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);

