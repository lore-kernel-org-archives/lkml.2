Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1BASIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 13:08:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:7677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1BASIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 13:08:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,411,1291622400"; 
   d="scan'208";a="702911503"
Date: Tue, 1 Feb 2011 10:07:49 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: b44 driver causes panic when using swiotlb
Message-ID: <20110201180749.GA19382@tassilo.jf.intel.com>
References: <20110131105412.7252a09c@katamari>
 <20110131163639.GA32095@tassilo.jf.intel.com>
 <4D4759BD.2000006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4759BD.2000006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 06:54:21PM -0600, Robert Hancock wrote:
> On 01/31/2011 10:36 AM, Andi Kleen wrote:
> >On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
> >>The b44 driver is triggering this panic in swiotlb_map_page():
> >>
> >>         if (!dma_capable(dev, dev_addr, size))
> >>                 panic("map_single: bounce buffer is not DMA'ble");
> >>
> >>The kernel log says the bounce buffers are at 0xdb400000, but b44 can
> >>only do DMA to the first 1GB of memory:
> >
> >b44 needs to use GFP_DMA then and do its own custom bouncing.
> >The standard pci_map_* bounce buffering is only designed for at least
> >32bit capable devices.
> 
> That seems wrong - it's a documented API and that restriction isn'

Please read the documentation. When PCI DMA cannot handle it
it returns failure. That is what happened here.

Besides historically PCI-DMA never handled < 4GB.

> documented. Either it should comply with the request or return a
> failure if it can't accomodate it, not just blow up internally.

It does return failure, that is what breaks the driver because
it doesn't handle it.

> There's no reason the driver should have to deal with this on its
> own.

Even if swiotlb could handle it, other implementations of PCI-DMA
can not

> In this case the DMA mapping code  should really be falling back to
> GFP_DMA automatically if the IOMMU aperture is outside the DMA mask
> of the device.

No, no -- you cannot allocate memory in DMA API.  It's forbidden.
Some paths that use it cannot tolerate it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
