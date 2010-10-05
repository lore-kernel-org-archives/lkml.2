Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0JEHr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:47:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44548 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0JEHrY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Tue, 5 Oct 2010 03:47:24 -0400
Message-Id: <4CAAF428020000780001A834@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Oct 2010 08:47:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v7] Xen PCI + Xen PCI frontend driver.
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.10.10 at 20:13, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> This patch set contains the supporting patches and the driver itself for
> Xen Paravirtualized (PV) domains to use PCI pass-through devices (the git 
> tree
> is git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
> devel/xen-pcifront-0.7).
> This patch-set is also utilized in Stefano's PV on HVM MSI/MSI-X patchset [1].
> 
> The Xen PCI frontend driver can be used by PV guests on IOMMU hardware
> (or IOMMU-less). Without the hardware IOMMU you have a potential security
> hole wherein a guest domain can use the hardware to map pages outside its
> memory range and slurp pages up. As such, this is more restricted to a
> Privileged PV domain, aka - device driver domain (similar to Qubes but a
> poor-man mechanism [2]).

Somehow this patch series appears to be incomplete: Neither on
xen-devel nor on patchwork I can find patches 6, 11, 18, 19, and 20.

> The first set of patches are specific to the Xen subsystem, where
> we introduce an IRQ chip for Physical IRQs, along with the supporting
> harness code:
>  xen: Don't disable the I/O space
>  xen: define BIOVEC_PHYS_MERGEABLE()
>  xen: implement pirq type event channels
>  xen: identity map gsi->irqs
>  xen: dynamically allocate irq & event structures
>  xen: set pirq name to something useful.
>  xen: statically initialize cpu_evtchn_mask_p
>  xen: Find an unbound irq number in reverse order (high to low).
>  xen: Provide a variant of xen_poll_irq with timeout.
>  xen: fix shared irq device passthrough
> 
> The next set of patches expose functionality for module drivers to be able 
> to
> enumerate and iomap (using the _PAGE_IOMAP flag) PCI devices.
> 
>  x86/io_apic: add get_nr_irqs_gsi()
>  x86/PCI: Clean up pci_cache_line_size
>  x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
>  x86/PCI: Export pci_walk_bus function.
> 
> The next two patches abstract the MSI/MSI-X architecture calls so that the
> default native one (used on bare-metal) can be overwritten when running
> in virtualized mode (right now on Xen). The implementation is a simple
> function pointer structure.
> 
>  x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.
>  x86: Introduce x86_msi_ops
> 
> Next, the Xen PCI stub driver. I've put it in the same location
> where other sub-platform PCI drivers are. It hooks up to the
> PCI legacy IRQ setup ('pcibios_enable_irq'), and MSI/MSI-X
> allocation/de-allocation (via the x86_msi_ops introduced in earlier patches).
> 
>  xen/x86/PCI: Add support for the Xen PCI subsystem
> 
> Lastly, the Xen PCI front-end driver which is responsible for hooking up
> to the PCI configuration read/write methods via the 'pci_scan_bus_parented' 
> call.
> In essence all pci_conf_read/write in the guest will be tunneled via
> pcifront_bus_[read|write] methods. The MSI/MSI-X calls will be handled
> by the Xen-PCI front-end driver as well.
> 
>  xen-pcifront: Xen PCI frontend driver.
> 
> The next two are a bug fix and updating the MAINTAINER file:
> 
>  MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
>  xen/pci: Request ACS when Xen-SWIOTLB is activated.

Also, up to here I count only 20 patch descriptions...

> The shortlog and the diffstat:
> 
> Alex Nixon (3):
>       xen: Don't disable the I/O space
>       x86/PCI: Clean up pci_cache_line_size
>       xen/x86/PCI: Add support for the Xen PCI subsystem
> 
> Gerd Hoffmann (1):
>       xen: set pirq name to something useful.
> 
> Jeremy Fitzhardinge (5):
>       xen: define BIOVEC_PHYS_MERGEABLE()
>       xen: implement pirq type event channels
>       x86/io_apic: add get_nr_irqs_gsi()
>       xen: statically initialize cpu_evtchn_mask_p
>       x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
> 
> Konrad Rzeszutek Wilk (8):
>       xen: identity map gsi->irqs
>       xen: dynamically allocate irq & event structures
>       xen: Find an unbound irq number in reverse order (high to low).
>       xen: Provide a variant of xen_poll_irq with timeout.
>       x86/PCI: Export pci_walk_bus function.
>       x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.
>       xen/pci: Request ACS when Xen-SWIOTLB is activated.
>       MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
> 
> Noboru Iwamatsu (1):
>       xenbus: prevent warnings on unhandled enumeration values
> 
> Ryan Wilson (1):
>       xen-pcifront: Xen PCI frontend driver.
> 
> Stefano Stabellini (1):
>       x86: Introduce x86_msi_ops
> 
> Weidong Han (1):
>       xen: fix shared irq device passthrough
> 
> Yosuke Iwamatsu (1):
>       xenbus: Xen paravirtualised PCI hotplug support.

... while these sum up to the announced (in the actual series) 22.

Jan

>  MAINTAINERS                        |   14 +
>  arch/x86/Kconfig                   |    5 +
>  arch/x86/include/asm/io.h          |   13 +
>  arch/x86/include/asm/io_apic.h     |    1 +
>  arch/x86/include/asm/pci.h         |   25 +-
>  arch/x86/include/asm/pci_x86.h     |    1 +
>  arch/x86/include/asm/x86_init.h    |    9 +
>  arch/x86/include/asm/xen/pci.h     |   53 ++
>  arch/x86/kernel/apic/io_apic.c     |   23 +-
>  arch/x86/kernel/x86_init.c         |    6 +
>  arch/x86/pci/Makefile              |    1 +
>  arch/x86/pci/common.c              |   17 +-
>  arch/x86/pci/i386.c                |    2 +
>  arch/x86/pci/xen.c                 |  147 +++++
>  arch/x86/xen/enlighten.c           |    3 +
>  arch/x86/xen/pci-swiotlb-xen.c     |    4 +
>  arch/x86/xen/setup.c               |    2 -
>  drivers/block/xen-blkfront.c       |    2 +
>  drivers/input/xen-kbdfront.c       |    2 +
>  drivers/net/xen-netfront.c         |    2 +
>  drivers/pci/Kconfig                |   16 +
>  drivers/pci/Makefile               |    2 +
>  drivers/pci/bus.c                  |    1 +
>  drivers/pci/xen-pcifront.c         | 1157 
> ++++++++++++++++++++++++++++++++++++
>  drivers/video/xen-fbfront.c        |    2 +
>  drivers/xen/Makefile               |    2 +-
>  drivers/xen/biomerge.c             |   13 +
>  drivers/xen/events.c               |  338 ++++++++++-
>  drivers/xen/xenbus/xenbus_client.c |    2 +
>  include/xen/events.h               |   18 +
>  include/xen/interface/io/pciif.h   |  122 ++++
>  include/xen/interface/io/xenbus.h  |    8 +-
>  32 files changed, 1982 insertions(+), 31 deletions(-)
> 
> P.S.
> [1]. git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 
> 2.6.36-rc1-pvhvm-pirq-v3
> 
> [2]: http://qubes-os.org/ which utilizes hardware IOMMU to run seperate 
> domains wherein
> each has specific access to hardware.
> 
> [3] Some of the authors of the patches have moved on, so their e-mails
> are bouncing. Any thoughts of what to do about that? Just leave it as is?  
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com 
> http://lists.xensource.com/xen-devel 


