Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1LETaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:30:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1LETaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:30:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Vetter <daniel@ffwll.ch>, t.stanislaws@samsung.com,
        linux@arm.linux.org.uk, Sumit Semwal <sumit.semwal@ti.com>,
        jesse.barker@linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, rob@ti.com, m.szyprowski@samsung.com,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-media@vger.kernel.org
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Mon, 05 Dec 2011 20:29:49 +0100
Message-ID: <1426302.asOzFeeJzz@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CAKMK7uE-ZJ-VQRWy+zJJWsvr9nARWuf-4nupXhTJ0CLqC88CEw@mail.gmail.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112051718.48324.arnd@arndb.de> <CAKMK7uE-ZJ-VQRWy+zJJWsvr9nARWuf-4nupXhTJ0CLqC88CEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7tYvPR/KSsE7P4sLZxE1UyZEbbZwoELmnmGAyzsz7sp
 nyWgidU8gD5y4DuC0vXD3lcLbZK5M/BhNIGw9iQ4t8UTVsCx0Z
 J1wYnBSFKhlsR9r9iDm7EfUmawg6bCOcACdZFNozbZW7bYM1YT
 aEhkSxkxS3ajxUqeCPcrAjOSHp5aF9fTYMozfcTcrtgawcY5Dy
 XP/pL06ohZcSRVWH6uk/PGYk4XAEBzGssLuY2X8MD3p3R6X1KO
 yYDmppftJyqeI9dpHYIU7+BirEVh9fTRQUPbXfrpzYUiCN5fq8
 YCQ8Sp9OaEMDz0dd5jo3zK8g4lskfmPH+esPkg/jbuDnaMR3et
 RrmDRk9x84FrjeIF4le8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 December 2011 19:55:44 Daniel Vetter wrote:
> > The only way to solve this that I can think of right now is to
> > mandate that the mappings are all coherent (i.e. noncachable
> > on noncoherent architectures like ARM). If you do that, you no
> > longer need the sync_sg_for_* calls.
> 
> Woops, totally missed the addition of these. Can somebody explain to used
> to rather coherent x86 what we need these for and the code-flow would look
> like in a typical example. I was kinda assuming that devices would bracket
> their use of a buffer with the attachment_map/unmap calls and any cache
> coherency magic that might be needed would be somewhat transparent to
> users of the interface?

I'll describe how the respective functions work in the streaming mapping
API (dma_map_*): You start out with a buffer that is owned by the CPU,
i.e. the kernel can access it freely. When you call dma_map_sg or similar,
a noncoherent device reading the buffer requires the cache to be flushed
in order to see the data that was written by the CPU into the cache.

After dma_map_sg, the device can perform both read and write accesses
(depending on the flag to the map call), but the CPU is no longer allowed
to read (which would allocate a cache line that may become invalid but
remain marked as clean) or write (which would create a dirty cache line
without writing it back) that buffer.

Once the device is done, the driver calls dma_unmap_* and the buffer is
again owned by the CPU. The device can no longer access it (in fact
the address may be no longer be backed if there is an iommu) and the CPU
can again read and write the buffer. On ARMv6 and higher, possibly some
other architectures, dma_unmap_* also needs to invalidate the cache
for the buffer, because due to speculative prefetching, there may also
be a new clean cache line with stale data from an earlier version of
the buffer.

Since map/unmap is an expensive operation, the interface was extended
to pass back the ownership to the CPU and back to the device while leaving
the buffer mapped. dma_sync_sg_for_cpu invalidates the cache in the same
way as dma_unmap_sg, so the CPU can access the buffer, and
dma_sync_sg_for_device hands it back to the device by performing the
same cache flush that dma_map_sg would do.

You could for example do this if you want video input with a
cacheable buffer, or in an rdma scenario with a buffer accessed
by a remote machine.

In case of software iommu (swiotlb, dmabounce), the map and sync
functions don't do cache management but instead copy data between
a buffer accessed by hardware and a different buffer accessed
by the user.

> The map call gets the dma_data_direction parameter, so it should be able
> to do the right thing. And because we keep the attachement around, any
> caching of mappings should be possible, too.
> 
> Yours, Daniel
> 
> PS: Slightly related, because it will make the coherency nightmare worse,
> afaict: Can we kill mmap support?

The mmap support is required (and only make sense) for consistent mappings,
not for streaming mappings. The provider must ensure that if you map
something uncacheable into the kernel in order to provide consistency,
any mapping into user space must also be uncacheable. A driver
that wants to have the buffer mapped to user space as many do should
not need to know whether it is required to do cacheable or uncacheable
mapping because of some other driver, and it should not need to worry
about how to set up uncached mappings in user space.

	Arnd
