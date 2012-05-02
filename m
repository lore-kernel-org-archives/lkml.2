Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab2EBVW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:22:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57490 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2EBVWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:22:22 -0400
MIME-Version: 1.0
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 May 2012 15:22:00 -0600
Message-ID: <CAErSpo7RNLdP4sRfg_3NE78rbvKM5HyRrApmLSLJOA8ggX=VvQ@mail.gmail.com>
Subject: Re: [PATCH -v11 00/30] PCI: allocate pci bus num range for unassigned
 bridge busn
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Set up iobusn_resource tree, and register bus number range to it.
> Later when need to find bus range, will try to allocate from the tree
>
> Need to test on arches other than x86. esp for ia64 and powerpc that support
>  more than on peer root buses.
>
> The patches need to apply to linux v3.3 + pci-next and
>        [PATCH -v3] PCI: pci_host_bridge related cleanup
>
> could be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

I started merging this series, but I didn't get very far.  I stopped
at the "resources: Add probe_resource()" patch because I don't think
that interface makes sense yet.  My work-in-progress is at
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git on the
topic/yinghai-busn-alloc branch.

I *could* merge that branch, but I don't think they fix anything (that
would come in the later patches), and there are still some issues in
my mind.

  - I think we really want a [bus 00-ff] resource for each *domain*,
with each host bridge in the domain requesting part of that range.  I
think these patches only track bus number usage within each host
bridge, and I'm not sure there's any place we would detect conflicts
between host bridges.

  - I think I made a mistake in the pci_create_root_bus() and
pci_scan_root_bus() interfaces.  They currently take a bus number and
a list of resources, and we expect the arch to include the bus number
aperture in the list.  The bus number argument should have been
replaced with a bus number aperture resource.  The bus number aperture
is essential, while the MMIO/IO aperture list may be empty.  And it's
stupid to pass both the starting bus number and a bus resource that
contains the starting bus number.  Fixing this would make some of
these patches quite a bit simpler.

  - In some of the arches (sparc, powerpc), you added a bus number
resource right next to existing first_busno, last_busno fields.  So
now that data lives two places, which will bite us later.

Bjorn


> Yinghai Lu (30):
>  x86, PCI: Add print all root info for not using _CRS path
>  x86, PCI: Allocate temp range array in amd_bus pci_root_info probing
>  x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
>  PCI: Add busn_res into struct pci_bus.
>  PCI: Add busn_res operation functions
>  PCI: Release busn_res when removing bus
>  PCI: Insert busn_res in pci_create_root_bus()
>  PCI: Checking busn_res in pci_scan_root_bus()
>  PCI: Add default busn_resource
>  PCI: Add default busn_res for pci_scan_bus()
>  x86, PCI: Add busn_res into resources list for acpi path
>  x86, PCI: Put busn resource in pci_root_info for not using _CRS path
>  PCI, ia64: Register busn_res for root buses
>  PCI, sparc: Register busn_res for root buses
>  PCI, powerpc: Register busn_res for root buses
>  PCI, parisc: Register busn_res for root buses
>  resources: Add probe_resource()
>  resources: Replace registered resource in tree.
>  PCI: Add pci_bus_extend/shrink_top()
>  PCI: Probe safe range that we can use for unassigned bridge.
>  PCI: Add pci_bus_replace_busn_res()
>  PCI: Allocate bus range instead of use max blindly
>  PCI: Strict checking of valid range for bridge
>  PCI: Kill pci_fixup_parent_subordinate_busnr()
>  PCI: Seperate child bus scanning to two passes overall
>  pcmcia: Remove workaround for fixing pci parent bus subordinate
>  PCI: Double checking setting for bus register and bus struct.
>  PCI, pciehp: Remove not needed bus number range checking
>  PCI: More strict checking of valid range for bridge
>  PCI: Don't shrink too much for hotplug bridge
>
>  arch/ia64/pci/pci.c                   |    2 +
>  arch/powerpc/include/asm/pci-bridge.h |    1 +
>  arch/powerpc/kernel/pci-common.c      |   10 +-
>  arch/sparc/kernel/pci.c               |    4 +
>  arch/sparc/kernel/pci_impl.h          |    1 +
>  arch/x86/pci/acpi.c                   |   11 +-
>  arch/x86/pci/amd_bus.c                |   14 +-
>  arch/x86/pci/bus_numa.c               |   30 ++-
>  arch/x86/pci/bus_numa.h               |    4 +-
>  arch/x86/pci/common.c                 |   27 +--
>  drivers/parisc/dino.c                 |    5 +
>  drivers/parisc/lba_pci.c              |    3 +
>  drivers/pci/hotplug/pciehp_pci.c      |   12 +-
>  drivers/pci/probe.c                   |  439 +++++++++++++++++++++++++++------
>  drivers/pci/remove.c                  |    1 +
>  drivers/pcmcia/yenta_socket.c         |   75 ------
>  include/linux/ioport.h                |    8 +
>  include/linux/pci.h                   |    6 +
>  kernel/resource.c                     |  175 +++++++++++++-
>  19 files changed, 613 insertions(+), 215 deletions(-)
>
> --
> 1.7.7
>
