Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1D1GkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:40:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1D1GkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:40:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 08:40:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110427073514.GH17290@n2100.arm.linux.org.uk> <1303940271.2513.187.camel@pasglop>
In-Reply-To: <1303940271.2513.187.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104280840.09206.arnd@arndb.de>
X-Provags-ID: V02:K0:xFruQv+AA9jrj4Gvh9u3+5H+UF8GSdk/XfNASLTLOSI
 mrS0dfYIRYSlpetuY1CaO3VsqInEBWit11yAjHHaPpIbNmEdoh
 xCU5qE+dioh2gHqzL4HNKfW8blW5pV5nLnqKAmCN9tUOymhZ3S
 oSzLA7jB4W0b4DSkI+RVn7uRS8tHHab5VXwIeNnJ1IxbF7abgf
 gCb7TCogw5BHtOv/ul6Dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 23:37:51 Benjamin Herrenschmidt wrote:
> On Wed, 2011-04-27 at 08:35 +0100, Russell King - ARM Linux wrote:
> > On Thu, Apr 21, 2011 at 09:29:16PM +0200, Arnd Bergmann wrote:
> > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > >    that this is needed, and it currently is not implemented, with
> > >    an outdated comment explaining why it used to not be possible
> > >    to do it.
> > 
> > dma_alloc_noncoherent is an entirely pointless API afaics.
> 
> I was about to ask what the point is ... (what is the expected
> semantic ? Memory that is reachable but not necessarily cache
> coherent ?)

Drivers use this when they explicitly want to manage the caching
themselves. I think this is most interesting on big NUMA systems,
where you really want to use fast (local cached) memory and
then flush it explicitly to do dma. Very few drivers use this:

arnd@wuerfel:~/linux-2.6$ git grep dma_alloc_noncoherent drivers/
drivers/base/dma-mapping.c:     vaddr = dma_alloc_noncoherent(dev, size, dma_handle, gfp);
drivers/net/au1000_eth.c:       aup->vaddr = (u32)dma_alloc_noncoherent(NULL, MAX_BUF_SIZE *
drivers/net/lasi_82596.c:#define DMA_ALLOC                        dma_alloc_noncoherent
drivers/net/sgiseeq.c:  sr = dma_alloc_noncoherent(&pdev->dev, sizeof(*sp->srings),
drivers/scsi/53c700.c:  memory = dma_alloc_noncoherent(hostdata->dev, TOTAL_MEM_SIZE,
drivers/scsi/sgiwd93.c: hdata->cpu = dma_alloc_noncoherent(&pdev->dev, HPC_DMA_SIZE,
drivers/tty/serial/mpsc.c:              } else if ((pi->dma_region = dma_alloc_noncoherent(pi->port.dev,
drivers/video/au1200fb.c:               fbdev->fb_mem = dma_alloc_noncoherent(&dev->dev,

> > So you can't have a dma_map_ops for the cache handling bits, a dma_map_ops
> > for IOMMU, and a dma_map_ops for the dmabounce stuff.  It just doesn't
> > work like that.
> 
> Well, the dmabounce and cache handling is one implementation that's just
> on/off with parameters no ?. iommu is different implementations. So the
> ops should be for the iommu backends. The dmabounce & cache handling is
> then done by those backends based on flags you stick in struct device
> for example.

Well, what we are currently discussing is to have a common implementation
for IOMMUs that provide the generic iommu_ops that the KVM people introduced.
Once we get there, we only need a single dma_map_ops structure for all
IOMMUs.

	Arnd
