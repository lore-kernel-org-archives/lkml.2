Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0ELWtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:49:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:53057 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0ELWs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:48:58 -0400
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Nicolas Pitre <nico@marvell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Saeed Bishara <saeed@marvell.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100512222154.GA6841@shareable.org>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	 <20100512222154.GA6841@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 08:47:11 +1000
Message-ID: <1273704431.21352.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 23:21 +0100, Jamie Lokier wrote:
> Shilimkar, Santosh wrote:
> > There was a memory write barrier missing before the DMA descriptors 
> > are handed over to DMA controller.
> 
> On that note, are the cache flush functions implicit memory barriers?

(Adding Fujita on CC)

That's a very good question. The generic inline implementation of
dma_sync_* is:

static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
					   size_t size,
					   enum dma_data_direction dir)
{
	struct dma_map_ops *ops = get_dma_ops(dev);

	BUG_ON(!valid_dma_direction(dir));
	if (ops->sync_single_for_cpu)
		ops->sync_single_for_cpu(dev, addr, size, dir);
	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
}

Which means that for coherent architectures that do not implement
the ops->sync_* hooks, we are probably missing a barrier here... 

Thus if the above is expected to be a memory barrier, it's broken on
cache coherent powerpc for example. On non-coherent powerpc, we do cache
flushes and those are implicit barriers.

Now, in the case at hand, which is my ARM based NAS, I believe this
is non cache-coherent and thus uses cache flush ops. I don't know ARM
well enough but I would expect these to be implicit barriers. Russell ?
Nico ?

IE. You may have found a bug here though I don't know whether it's the
bug we are hitting right now :-)

Cheers,
Ben.


