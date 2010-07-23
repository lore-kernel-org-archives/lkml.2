Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214Ab0GWOYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:24:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36087 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0GWOY2 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 23 Jul 2010 10:24:28 -0400
Date: Fri, 23 Jul 2010 10:22:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alok Kataria <akataria@vmware.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>
Subject: Re: swiotlb detection should be memory hotplug aware ?
Message-ID: <20100723142208.GA4008@phenom.dumpdata.com>
References: <20100721135750Z.fujita.tomonori@lab.ntt.co.jp>
 <1279732414.10874.6.camel@ank32.eng.vmware.com>
 <20100722084413I.fujita.tomonori@lab.ntt.co.jp>
 <20100722090329O.fujita.tomonori@lab.ntt.co.jp>
 <1279823680.31733.20.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279823680.31733.20.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C49A5E3.000A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:34:40AM -0700, Alok Kataria wrote:
> Hi,
> 
> On Wed, 2010-07-21 at 17:03 -0700, FUJITA Tomonori wrote:
> > On Thu, 22 Jul 2010 08:44:42 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Wed, 21 Jul 2010 10:13:34 -0700
> > > Alok Kataria <akataria@vmware.com> wrote:
> > > 
> > > > > Basically, you want to add hot-plug memory and enable swiotlb, right?
> > > > 
> > > > Not really, I am planning to do something like this, 
> > > > 
> > > > @@ -52,7 +52,7 @@ int __init pci_swiotlb_detect(void)
> > > >  
> > > >  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
> > > >  #ifdef CONFIG_X86_64
> > > > -	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> > > > +	if (!no_iommu && (max_pfn > MAX_DMA32_PFN || hotplug_possible()))
> > > >  		swiotlb = 1;
> > > 
> > > Always enable swiotlb with memory hotplug enabled?
> 
> yep though only on systems which have hotpluggable memory support.

What machines are there that have hotplug support and no hardware IOMMU?
I know of the IBM ones - but they use the Calgary IOMMU.
> 
> >  Wasting 64MB on a
> > > x86_64 system with 128MB doesn't look to be a good idea. I don't think
> > > that there is an easy solution for this issue though.
> 
> Good now that you agree that, that's the only feasible solution, do you
> have any suggestions for any interfaces that are available from SRAT for
> implementing hotplug_possible ?

I thought SRAT has NUMA affinity information - so for example my AMD
desktop box has that, but it does not support hotplug capability.

I think first your 'hotplug_possible' code needs to be more specific -
not just check if SRAT exists, but also if there are swaths of memory
that are non-populated. It would also help if there was some indication
of whether the box truly does a hardware hotplug - is there a way to do
this?

> 
> > 
> > btw, you need more work to enable switch on the fly.
> > 
> > You need to change the dma_ops pointer (see get_dma_ops()). It means
> > that you need to track outstanding dma operations per device, locking,
> > etc.
> 
> Yeah though if we are doing this during swiotlb_init time i.e. at bootup
> as suggested in the pseudo patch, we don't need to worry about all this,
> right ? 

Right..
> 
> Thanks,
> Alok
