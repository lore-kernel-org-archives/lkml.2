Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1AEPxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:53:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46884 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1AEPxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:53:31 -0500
Date: Wed, 5 Jan 2011 15:52:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-nfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marc Kleine-Budde <m.kleine-budde@pengutronix.de>
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
Message-ID: <20110105155230.GC8638@n2100.arm.linux.org.uk>
References: <20101230191846.GB14221@pengutronix.de> <20110103213850.GC25121@pengutronix.de> <1294100558.25100.8.camel@heimdal.trondhjem.org> <20110105084014.GN25121@pengutronix.de> <20110105110517.GQ25121@pengutronix.de> <20110105112701.GA8638@n2100.arm.linux.org.uk> <20110105134045.GS25121@pengutronix.de> <1294239193.3014.9.camel@heimdal.trondhjem.org> <4D2487CA.5040501@pengutronix.de> <1294240457.3014.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294240457.3014.13.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:14:17AM -0500, Trond Myklebust wrote:
> OK. So,the new behaviour in 2.6.37 is that we're writing to a series of
> pages via the usual kmap_atomic()/kunmap_atomic() and kmap()/kunmap()
> interfaces, but we can end up reading them via a virtual address range
> that gets set up via vm_map_ram() (that range gets set up before the
> write occurs).

kmap of lowmem pages will always reuses the existing kernel direct
mapping, so there won't be a problem there.

> Do we perhaps need an invalidate_kernel_vmap_range() before we can read
> the data on ARM in this kind of scenario?

Firstly, vm_map_ram() does no cache maintainence of any sort, nor does
it take care of page colouring - so any architecture where cache aliasing
can occur will see this problem.  It should not limited to ARM.

Secondly, no, invalidate_kernel_vmap_range() probably isn't sufficient.
There's two problems here:

	addr = kmap(lowmem_page);
	*addr = stuff;
	kunmap(lowmem_page);

Such lowmem pages are accessed through their kernel direct mapping.

	ptr = vm_map_ram(lowmem_page);
	read = *ptr;

This creates a new mapping which can alias with the kernel direct mapping.
Now, as this is a new mapping, there should be no cache lines associated
with it.  (Looking at vm_unmap_ram(), it calls free_unmap_vmap_area_addr(),
free_unmap_vmap_area(), which then calls flush_cache_vunmap() on the
region.  vb_free() also calls flush_cache_vunmap() too.)

If the write after kmap() hits an already present cache line, the cache
line will be updated, but it won't be written back to memory.  So, on
a subsequent vm_map_ram(), with any kind of aliasing cache, there's
no guarantee that you'll hit that cache line and read the data just
written there.

The kernel direct mapping would need to be flushed.

I'm really getting to the point of hating the poliferation of RAM
remapping interfaces - it's going to (and is) causing nothing but lots
of pain on virtual cache architectures, needing more and more cache
flushing interfaces to be created.

Is there any other solution to this?
