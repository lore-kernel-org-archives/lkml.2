Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2AAXMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 18:12:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65194 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2AAXMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 18:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120101205352.GI3677@valkosipuli.localdomain>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<201112091413.03736.arnd@arndb.de>
	<20111220090306.GO3677@valkosipuli.localdomain>
	<201112201536.49754.arnd@arndb.de>
	<20120101205352.GI3677@valkosipuli.localdomain>
Date: Sun, 1 Jan 2012 17:12:34 -0600
Message-ID: <CAF6AEGv=W1FTeb6pU3VY9AdF7rbBHu0f5Ad1-9pWvWOUOWvBAA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
From: Rob Clark <robdclark@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Vetter <daniel@ffwll.ch>,
        "Semwal, Sumit" <sumit.semwal@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 2:53 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Arnd,
>
> On Tue, Dec 20, 2011 at 03:36:49PM +0000, Arnd Bergmann wrote:
>> On Tuesday 20 December 2011, Sakari Ailus wrote:
>> > (I'm jumping into the discussion in the middle, and might miss something
>> > that has already been talked about. I still hope what I'm about to say is
>> > relevant. :-))
>>
>> It certainly is relevant.
>>
>> > In subsystems such as V4L2 where drivers deal with such large buffers, the
>> > buffers stay mapped all the time. The user explicitly gives the control of
>> > the buffers to the driver and eventually gets them back. This is already
>> > part of those APIs, whether they're using dma_buf or not. The user could
>> > have, and often has, the same buffers mapped elsewhere.
>>
>> Do you normally use streaming (dma_{map,sync,unmap}_*) or consistent
>> (dma_{alloc,free}_*) mappings for this then?
>
> The OMAP 3 ISP driver I'm familiar with uses the OMAP 3 IOMMU / IOVMM API
> which is to be replaced by dmabuf. I'm trying to understand how the dma
> api / dma-buf should be used to achieve a superset of that functionality.
>
> I think I'm interested in the DMA mapping API. I replied to Sumit's new
> patchset, you're cc'd.
>
>> > When it comes to passing these buffers between different hardware devices,
>> > either V4L2 or not, the user might not want to perform extra cache flush
>> > when the buffer memory itself is not being touched by the CPU in the process
>> > at all. I'd consider it impossible for the driver to know how the user space
>> > intends to user the buffer.
>>
>> The easiest solution to this problem would be to only allow consistent mappings
>> to be shared using the dma_buf mechanism. That means we never have to flush.
>
> Do you mean the memory would be non-cacheable? Accessing memory w/o caching
> is typically prohibitively expensive, so I don't think this could ever be
> the primary means to do the above.
>
> In some cases non-cacheable can perform better, taking into account the time
> which is required for flusing the cache and the other consequences of that,
> but I still think it's more of an exception than a rule.

I think we decided to completely leave cpu virtual mappings out of the
API to start with, because (a) we can already get significant value
out of the API without this, and (b) it is not quite clear how to
handle virtual mappings in a way that can deal with all cases.  For
now, userspace virtual mappings must come from the exporting device,
and kernel virtual mappings (if needed by the importing device) are
not supported.. although I think it is a smaller subset of devices
that might need a kernel virtual mapping.

This sidesteps the whole issue of cache handling, avoiding aliased
mappings, etc.  And leaves cpu access synchronization and cache
handling to be handled however the exporting device handles this
today.

BR,
-R

>> If you don't need the CPU to touch the buffer, that would not have any cost
>> at all, we could even have no kernel mapping at all instead of an uncached
>> mapping on ARM.
>
> I think in general creating unused mappings should really be avoided.
> Creating them consumes time, effort at creation time and possibly also in
> cache related operations.
>
>> > Flushing the cache is quite expensive: typically it's the best to flush the
>> > whole data cache when one needs to flush buffers. The V4L2 DQBUF and QBUF
>> > IOCTLs already have flags to suggest special cache handling for buffers.
>>
>> [sidenote: whether it makes sense to flush individual cache lines or the entire
>> cache is a decision best left to the architectures. On systems with larger
>> caches than on ARM, e.g. 64MB instead of 512KB, you really want to keep
>> the cache intact.]
>
> That also depend on the buffer size and what the rest of the system is
> doing. I could imagine buffer size, system memory data rate, CPU frequency,
> cache line width and the properties of the cache all affect how fast both of
> the operations are.
>
> It would probably be possible to perform a heuristic analysis on this at
> system startup similar to different software raid algorithm implementations
> ( e.g. to use MMX or SSE for sw raid).
>
> Some additional complexity will arise from the fact that on some ARM machines
> one must know all the CPU MMU mappings pointing to a piece of physical
> memory to properly flush them, AFAIR. Naturally a good alternative on such
> system is to pperform full dcache flush / cleaning.
>
> Also, cache handling only affects systems without coherent cache. ARM CPUs
> are finding their ways to servers as well, but I'd guess it'll still take a
> while before we have ARM CPUs with 64 MiB of cache..
>
> Kind regards,
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
