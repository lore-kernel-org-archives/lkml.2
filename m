Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0GUJJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 05:09:25 -0400
Received: from www.tglx.de ([62.245.132.106]:55603 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0GUJJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 05:09:24 -0400
Date: Wed, 21 Jul 2010 11:09:12 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, hjk@linutronix.de,
        Michal Simek <michal.simek@petalogix.com>,
        John Williams <john.williams@petalogix.com>
Subject: Re: UIO: munmap bug for boot time allocated memory
Message-ID: <20100721090912.GC1669@local>
References: <AANLkTikuRjaAUF5KOn1QnVU8VnUiSNPkoKkkBdipXooY@mail.gmail.com>
 <20100708233923.GB8671@suse.de>
 <AANLkTinuMRXSInvNTxVYPH3gFd8HA0LV_pO1e44QvBkt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinuMRXSInvNTxVYPH3gFd8HA0LV_pO1e44QvBkt@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 05:17:17PM +1000, Peter Crosthwaite wrote:
> Hi Greg,
> 
> Thanks for your reply on the mmunmap issue. Sorry about the delay on
> this correspondance.
> 
> I have looked into this bug in more detail. The
> alloc_bootmem_low_pages() call is falling back to a call to kzalloc(),
> so the address passed to UIO when used in UIO_MEM_LOGICAL is a return
> from kmalloc(). So my first question is, is kmalloc'ed memory
> supported by UIO?

Yes, of course. UIO_MEM_LOGICAL is the correct memtype for that. But
that applies only to memory you get _directly_ from kmalloc().
For example, dma_alloc_coherent() on ARM internally gets its memory from
kmalloc, too. But it needs a completely different mapping routine,
trying to map it using UIO_MEM_LOGICAL will fail.

> 
> With regards to the copying the data from the buffer to file, yes it
> is showing the correct data.
> 
> I have since resolved the BUG() by manually modifying the usage
> counters for the buffer pages from kernel space. i.e. Once the memory
> is kmalloc'ed the driver will iterate through all the pages and
> increment the _count field of the struct page. This will cause the
> pages to have a user count of 2 when mmaped (by user space) which
> reverts to 1 when unmapped. Now this fixes the bug, but should this
> manual increment be necessary? Is there a cleaner way in the kernel
> API for kernel space to mark itself as a user of a memory range or
> user space VMA?
> 
> You mentioned linking you up with the source code for my driver. Im
> trying to put together a minimal driver that replicates this bug, but
> it seems UIO enforces the need for a parent device when initialised.
> Considering this bug requires no actual hardware to replicate, is
> there a way to get a UIO device without a physical device to be able
> to test this behaviour in isolation?

There once was the uio_dummy driver. It maps some kmalloc'ed memory
to userspace and uses a timer to simulate interrupts. Just google
for "uio_dummy" and you'll find it. It's quite old (2.6.23), so it
will need some fixing. But it should give you the idea.

Thanks,
Hans
