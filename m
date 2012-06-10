Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2FJTBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 15:01:51 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49416 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab2FJTBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 15:01:50 -0400
Date: Sun, 10 Jun 2012 21:01:46 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120610190145.GB2629@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <4FD1FB49.3020905@siemens.com>
 <1339165009.26976.60.camel@ul30vt>
 <1339166867.3870.29.camel@blech>
 <4FD22552.6090609@01019freenet.de>
 <20120608164426.GE9705@local>
 <1339175476.26976.102.camel@ul30vt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339175476.26976.102.camel@ul30vt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 11:11:16AM -0600, Alex Williamson wrote:
> On Fri, 2012-06-08 at 18:44 +0200, Hans J. Koch wrote:
> > On Fri, Jun 08, 2012 at 06:16:18PM +0200, Andreas Hartmann wrote:
> > > Hi Dominic,
> > > 
> > > Dominic Eschweiler wrote:
> > > > Am Freitag, den 08.06.2012, 08:16 -0600 schrieb Alex Williamson:
> > > >> Yes, thanks Jan.  This is exactly what VFIO does.  VFIO provides
> > > >> secure config space access, resource access, DMA mapping services, and
> > > >> full interrupt support to userspace.  
> > 
> > VFIO is not a "better UIO". It *requires* an IOMMU. Dominic didn't say on
> > what CPU he's working, so it's not clear if he can use VFIO at all.
> > 
> > UIO is intended for general use with devices that have mappable registers
> > and don't fit into any other subsystem. No more, no less.
> 
> VFIO is a secure UIO.  An IOMMU is required for any model that allows a
> user to program DMA of a device, whether VFIO or something else.  As
> Michael noted, if we allow UIO PCI to enable bus master, we open
> ourselves up to a whole world of problems with a user suddenly having
> access to and DMA'able memory in the system.  So really, add that the
> device must only use PIO to your list of requirements for UIO, which
> rules out any kind of high speed device.  Thanks,

You're living in a completely different world. If you want to discuss UIO,
it would be best if you forget PCI, DMA, and virtualization first.

UIO was introduced to handle crazy hardware that doesn't fit into an existing
subsystem, e.g. a customer specific FPGA. Before UIO, people wrote kernel
char device drivers with 5000+ lines of code for that. They controlled their
device with 50 new ioctls, the driver was buggy and could never make it to
mainline.

With UIO, they write a very simple kernel driver, typically around 150 LOC.
The rest can be done in userspace. That's the purpose of UIO. And since
strange devices like the FPGA mentioned above are mainly found in
Embedded Devices, it's absolutely neccesary that UIO works on ANY CPU,
including ARM, MIPS, older x86 like LX800, or PowerPC. Not just some
shiny new Core i7 with IOMMU. And it's not only for PCI, most of the drivers
use platform devices and the chips are directly attached to some SoC bus.

And one last word about DMA: The reason the UIO core doesn't support DMA
is simply that so far nobody wanted it. In five years, I never had a device
on my desk where a UIO driver needed DMA support by the core. On the other
hand, I met several people who said "Bad thing that UIO doesn't support DMA".
When I asked what they're about to do, everyone answered "Oh well, I don't
need DMA, but UIO should support it, don't you think so?". So much for that.

One fine day some time ago (2010?), somebody came up with a patch set that
attempted to change half the UIO core. In the resulting discussion, we
quickly found out that he had completly different requirements for a
completely different purpose. The result of that insight was the birth
of VFIO. A new subsystem for new requirements.

If you say "VFIO is a secure UIO", then please post a replacement for
uio_pdrv_genirq.c that runs on an ARM9 and offers the advantages you're
talking about. If that is impossible, please stop comparing VFIO with UIO.

Thanks,
Hans

