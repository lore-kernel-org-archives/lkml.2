Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1KANw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 09:52:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43959 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab1KANw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 09:52:27 -0400
Date: Tue, 1 Nov 2011 09:51:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 08/11] ttm: Provide DMA aware TTM page pool code.
Message-ID: <20111101135139.GC22652@phenom.dumpdata.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
 <1319062772-2793-9-git-send-email-konrad.wilk@oracle.com>
 <20111031193722.GB3036@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031193722.GB3036@homer.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EAFF976.0064,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static struct dma_page *__ttm_dma_alloc_page(struct dma_pool *pool)
> > +{
> > +	struct dma_page *d_page;
> > +
> > +	d_page = kmalloc(sizeof(struct dma_page), GFP_KERNEL);
> > +	if (!d_page)
> > +		return NULL;
> > +
> > +	d_page->vaddr = dma_alloc_coherent(pool->dev, pool->size,
> > +					   &d_page->dma,
> > +					   pool->gfp_flags);
> > +	d_page->p = virt_to_page(d_page->vaddr);
> > +	if (!d_page->vaddr) {
> > +		kfree(d_page);
> > +		d_page = NULL;
> > +	}
> 
> Move d_page->p = virt_to_page(d_page->vaddr); after if (!d_page->vaddr)
> block.

Duh! Yes.

.. snip..
> > +#if 0
> > +	if (nr_free > 1) {
> > +		pr_debug("%s: (%s:%d) Attempting to free %d (%d) pages\n",
> > +			pool->dev_name, pool->name, current->pid,
> > +			npages_to_free, nr_free);
> > +	}
> > +#endif

What is your feeling on those #if 0? I was not sure to keep them - they are useful
when debugging, but not so much during run-time? Rip them out and I can just
keep them in my 'debug' patch queue in case things go wrong?

Or perhas do it (rip 'em out) in 3 months time-frame?

.. snip..
> > +static struct dma_pool *ttm_dma_find_pool(struct device *dev,
> > +					  enum pool_type type)
> > +{
> > +	struct dma_pool *pool, *tmp, *found = NULL;
> > +
> > +	if (type == IS_UNDEFINED)
> > +		return found;
> > +	/* NB: We iterate on the 'struct dev' which has no spinlock, but
> > +	 * it does have a kref which we have taken. */
> 
> I fail to see where we kref dev.

Ah, I should document that more extensivly. That is done way way
earlier. As in in the path of the initialization of the driver:

drm_pci_init
  for non-KMS calls pci_dev_get()

  for KMS calls pci_register_driver..
      which calls 'driver_register' which called 'device_register'

And then during teardown (so unbind on sysfs), it ends up calling the devres
deconstructors which cleans up the 'struct device' dev_res, - in our case
ttm_dma_pool_release. However the nice thing is at that point of time all of
the calls to the TTM have quiseced so nobody is calling ttm for this device
anymore.

Let me stick this in the comment section.

> See comment above, otherwise:
> Reviewed-by: Jerome Glisse <jglisse@redhat.com>

Great! Thank you! 
