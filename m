Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0DLRxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:53:39 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35508 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0DLRxh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 12 Apr 2010 13:53:37 -0400
Date: Mon, 12 Apr 2010 13:52:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>,
       Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [LKML] Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412175225.GB31508@phenom.dumpdata.com>
References: <20100412162947.GQ18855@one.firstfloor.org> <Pine.LNX.4.44L0.1004121252310.1702-100000@iolanthe.rowland.org> <20100412171507.GB30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412171507.GB30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC35E01.00F4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 07:15:07PM +0200, Daniel Mack wrote:
> On Mon, Apr 12, 2010 at 12:57:16PM -0400, Alan Stern wrote:
> > On Mon, 12 Apr 2010, Andi Kleen wrote:
> > > Hmm, thanks. But things must still go wrong somewhere, otherwise
> > > the GFP_DMA32 wouldn't be needed?
> > 
> > Indeed, something must go wrong somewhere.  Since Daniel's patch fixed
> > the problem by changing the buffer from a streaming mapping to a
> > coherent mapping, it's logical to assume that bad DMA addresses have
> > something to do with it.  But we don't really know for certain.
> 
> Given that - at least for non-64-aware host controllers - we want memory
> <4GB anyway for USB transfers to avoid DMA bouncing buffers, maybe we
> should just do that and fix the problem at this level? I already started
> to implement usb_[mz]alloc() and use it in some USB drivers.

You might want to run some benchmarks first to see if it is such a
problem. Keep in mind that you would be addressing only the host-side of
this: all DMA transfers from the USB controller to the memory. But for any
transfer from the user space to the USB device you can't make
the <4GB assumption as the stack/heap in the user-land is stiched from
various memory areas - some of them above your 4GB mark. So when you
write your response to this e-mail, and your /var/spool/clientmqueue is on your
USB disk, the page with your response that is being written to the disk, can be
allocated from a page above the 4GB mark and then has to be bounced-buffered
for the USB controller. Note, I am only talking about 64-bit kernels,
the 32-bit are a different beast altogether when it comes to

Thought please keep in mind that this issue of bounce-buffer is less of
a problem nowadays. Both AMD and Intel are outfitting their machines
with hardware IOMMU's that replace the SWIOTLB (and IBM's high-end boxes
with the Calgary ones). And on AMD the GART has been used for many years
as a poor-man IOMMU.

> 
> But even after all collected wisdom about memory management in this
> thread, I'm still uncertain of how to get suitable memory. Using
> dma_alloc_coherent() seems overdone as that type of memory is not
> necessarily needed and might be a costly good on some platforms. And as
> fas as I understand, kmalloc(GFP_DMA) does not avoid memory >4GB.
> 
> Can anyone explain which is the right way to go?

Fix whatever makes the DMA address have the wrong value. In the 
0x08...00<bus address> address the 0x08 looks quite suspicious. Like it
has been used as a flag or the generated casting code (by GCC) from 64-bit
to 32-bit didn't get the right thing (I remember seeing this with
InfiniBand with RHEL5.. which was GCC 4.1 I think?)

It would be worth instrumenting the PCI-DMA API code and trigger a
dump_stack when that flag (0x008) is detected in the return from the
underlaying page mapping code. If you need help with this I can
give you some debug patches.
