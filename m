Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab0FRQnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:43:47 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:38314 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757687Ab0FRQnp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:43:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JhDa/OvRj0SXY6hwmh3CQwjR9u2NYOUUoFYILSTDbcFrw5+v7Txp1/G2EKS+s5Sx7y2GIrhHktZhtAql9xrnf+7uRosXpdj/3mCLfHm/22f2NQ/7WfWG7iFI7JdJ7kmP;
Date: Fri, 18 Jun 2010 09:42:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: fix compilation when CONFIG_PCI_MSI=n
Message-ID: <20100618094207.203ca7be@virtuousgeek.org>
In-Reply-To: <20100616082240.GA3848@redhat.com>
References: <201006161421.11148.rusty@rustcorp.com.au>
	<4C186A87.6040005@jp.fujitsu.com>
	<20100616082240.GA3848@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 11:22:40 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Jun 16, 2010 at 03:09:11PM +0900, Hidetoshi Seto wrote:
> > (2010/06/16 13:51), Rusty Russell wrote:
> > > drivers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
> > > include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here
> > > 
> > > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > > ---
> > >  drivers/pci/pci.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > --- a/drivers/pci/pci.c
> > > +++ b/drivers/pci/pci.c
> > > @@ -2266,6 +2266,7 @@ pci_intx(struct pci_dev *pdev, int enabl
> > >  	}
> > >  }
> > >  
> > > +#ifdef CONFIG_PCI_MSI
> > >  /**
> > >   * pci_msi_off - disables any msi or msix capabilities
> > >   * @dev: the PCI device to operate on
> > > @@ -2293,6 +2294,7 @@ void pci_msi_off(struct pci_dev *dev)
> > >  	}
> > >  }
> > >  EXPORT_SYMBOL_GPL(pci_msi_off);
> > > +#endif
> > >  
> > >  #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
> > >  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
> > 
> > Rusty, thank you for reporting it.
> > But I think this fix is not correct.
> > 
> > It looks like a bug in Michael's patch:
> >   [PATCH for-2.6.35] virtio-pci: disable msi at startup
> > 
> > The patch includes a change as following:
> > 
> > > > --- a/include/linux/pci.h
> > > > +++ b/include/linux/pci.h
> > > > @@ -780,7 +780,11 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
> > > >  int pci_try_set_mwi(struct pci_dev *dev);
> > > >  void pci_clear_mwi(struct pci_dev *dev);
> > > >  void pci_intx(struct pci_dev *dev, int enable);
> > > > +#ifdef CONFIG_PCI_MSI
> > > >  void pci_msi_off(struct pci_dev *dev);
> > > > +#else
> > > > +static inline void pci_msi_off(struct pci_dev *dev) {}
> > > > +#endif
> > > >  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
> > > >  int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
> > > >  int pcix_get_max_mmrbc(struct pci_dev *dev);
> > 
> > According to the old commit f5f2b13129a6541debf8851bae843cbbf48298b7,
> > pci_msi_off() was designed to be available even when msi support is not
> > compiled in.  So I think this change will make something wrong.
> > 
> > Michael, could you check your patch?
> > 
> > 
> > Thanks,
> > H.Seto
> 
> You are right. I didn't think this through: we must disable
> the capability at startup even if the current kernel does not
> support MSI, otherwise the device won't work.
> 
> Please apply this on top.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ---
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 31d8a12..7cb0084 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -780,11 +780,7 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
>  int pci_try_set_mwi(struct pci_dev *dev);
>  void pci_clear_mwi(struct pci_dev *dev);
>  void pci_intx(struct pci_dev *dev, int enable);
> -#ifdef CONFIG_PCI_MSI
>  void pci_msi_off(struct pci_dev *dev);
> -#else
> -static inline void pci_msi_off(struct pci_dev *dev) {}
> -#endif
>  int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
>  int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
>  int pcix_get_max_mmrbc(struct pci_dev *dev);

I don't have the #ifdef in pci.h or the export in my tree.  Can you
guys fix this up in the virt tree and add my acked-by?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
