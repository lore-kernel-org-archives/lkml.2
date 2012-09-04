Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2IDQvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:51:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33271 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2IDQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:51:01 -0400
Date: Tue, 4 Sep 2012 12:40:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Stefano Panella <stefano.panella@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in
	xen_swiotlb_alloc_coherent.
Message-ID: <20120904164028.GJ23361@phenom.dumpdata.com>
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
 <5040B249.4000306@citrix.com>
 <20120831164010.GA18929@localhost.localdomain>
 <50460B2E.3020200@citrix.com>
 <20120904143731.GC23361@phenom.dumpdata.com>
 <50461654.5040901@citrix.com>
 <50461A59.2050504@citrix.com>
 <50462FFE.7070100@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50462FFE.7070100@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:44:46PM +0100, David Vrabel wrote:
> On 04/09/12 16:12, Stefano Panella wrote:
> > On 09/04/2012 03:55 PM, David Vrabel wrote:
> >> On 04/09/12 15:37, Konrad Rzeszutek Wilk wrote:
> >>> On Tue, Sep 04, 2012 at 03:07:42PM +0100, Stefano Panella wrote:
> >>>> So if hwdev->coherent_dma_mask is set to 0xffffffffffffffff our
> >>>> dma_mask will
> >>>> be u64 set to 0xffffffffffffffff even if we set it to
> >>>> DMA_BIT_MASK(32) previously.
> >>> That is what I was missing. Let me include that in the git commit and
> >>> also
> >>> put this patch on the stable tree.
> >> Note that this appears to be a work around for a bug in the sound system
> >> or Intel HDA device driver which is incorrectly truncating a dma_addr_t
> >> to a u32.  So by ensuring a DMA_BIT_MASK(32) when the dma_addr_t is
> >> truncated it still works.
> >>
> >> David
> > Sorry David, I am not completely sure I understand your argument in
> > favour of a bug in the
> > sound system or Intel HDA device driver. Could you please elaborate more
> > in detail about this?
> 
> The HDA driver claims to support 64-bit DMA addresses, so it should be
> perfectly fine for the Xen DMA mapping/allocation functions to return
> DMA addresses > 4 GiB.  For most devices this seems to work just fine.
> 
> I think that somewhere between the buffer being mapped or allocated and
> the address being programmed into the hardware, the 64-bit dma_addr_t
> value is being truncated to 32 bits giving an invalid DMA address.
> 
> The patch would avoid this by setting the DMA mask to 32-bit and only
> returning DMA address < 4 GiB which can quite happily be stuffed into a
> u32 without losing bits.
> 
> I think it would be useful (without the patch applied) to print the DMA
> addresses returned by the allocate/mapping functions and the address
> programmed into the hardware.  It will be easily to spot if it got
> truncated or not.

Just enable DMA debug API (CONFIG_DEBUG_DMA_API) and use this fancy module:


/*
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License v2.0 as published by
 * the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include <linux/module.h>
#include <linux/string.h>
#include <linux/types.h>
#include <linux/init.h>
#include <linux/stat.h>
#include <linux/err.h>
#include <linux/ctype.h>
#include <linux/slab.h>
#include <linux/limits.h>
#include <linux/device.h>
#include <linux/pci.h>
#include <linux/blkdev.h>
#include <linux/device.h>

#include <linux/init.h>
#include <linux/mm.h>
#include <linux/fcntl.h>
#include <linux/slab.h>
#include <linux/kmod.h>
#include <linux/major.h>
#include <linux/highmem.h>
#include <linux/blkdev.h>
#include <linux/module.h>
#include <linux/blkpg.h>
#include <linux/buffer_head.h>
#include <linux/mpage.h>
#include <linux/mount.h>
#include <linux/uio.h>
#include <linux/namei.h>
#include <asm/uaccess.h>

#include <linux/pagemap.h>
#include <linux/pagevec.h>

#include <linux/dma-debug.h>

#define DUMP_DMA_FUN  "0.1"

MODULE_AUTHOR("Konrad Rzeszutek Wilk <konrad@virtualiron>");
MODULE_DESCRIPTION("dump dma");
MODULE_LICENSE("GPL");
MODULE_VERSION(DUMP_DMA_FUN);

static int __init dump_dma_init(void)
{
	debug_dma_dump_mappings(NULL);
	return 0;
}

static void __exit dump_dma_exit(void)
{
}

module_init(dump_dma_init);
module_exit(dump_dma_exit);
> 
> David
