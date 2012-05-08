Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2EIP4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:56:01 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27612 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab2EIPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:55:58 -0400
Message-ID: <201205091555.q49FttvG010396@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 8 May 2012 16:53:03 -0400
Subject: [PATCH v2 0/2] arch/tile: PCI root complex support
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        "David Howells <dhowells@redhat.com> Jesper Juhl" <jj@chaosbits.net>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
  <201204072319.q37NJgrI019382@farm-0023.internal.tilera.com>
  <alpine.LNX.2.00.1204080126300.4431@swampdragon.chaosbits.net>
  <CAErSpo6_gV1XKJ1jsDSvHo+BEORL_5wLC2YRyVG+OjVNDYbHgw@mail.gmail.com>
  <201204091359.13059.arnd@arndb.de>
  <4F8356C7.60706@tilera.com>
  <201204100914.06168.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of the patch series to add PCI root complex
support to the tilegx architecture.  Again, I am cc'ing the change
that adds PCI support per-se to a wider audience.

This series incorporates feedback from Jesper Juhl, Arnd Bergmann, and
Bjorn Helgaas.

- Use pcie_bus_configure_settings(), pci_scan_root_bus(), and
  pci_enable_resources().
- Use PCI_SLOT() and PCI_FUNC() as appropriate.
- Stop enabling PCI_COMMAND_IO, since we don't support I/O space yet.
- Use msleep() instead of mdelay()
- Machine-generated code (e.g. iorpc_trio.c) is now terser and more
  human-readable.
- Some whitespace issues (e.g. " * " before a particular pointer, and
  function return type on a line by itself too frequently) corrected.

We don't currently plan to add support for I/O space.  We didn't implement
the kernel support in the RC driver, because only old, legacy devices use
PCI I/O space and it seems unlikely that our chip will end up having to
control one of these devices. Plus, supporting it costs one of 8 total
TRIO PIO regions, which are in short supply.  But this is secondary;
we'll add support if needed in the future.

 arch/tile/Kconfig                            |    3 +
 arch/tile/gxio/Kconfig                       |    6 +
 arch/tile/gxio/Makefile                      |    1 +
 arch/tile/gxio/iorpc_trio.c                  |  307 +++++
 arch/tile/gxio/trio.c                        |   49 +
 arch/tile/include/arch/trio.h                |   72 ++
 arch/tile/include/arch/trio_constants.h      |   36 +
 arch/tile/include/arch/trio_def.h            |   41 +
 arch/tile/include/arch/trio_pcie_intfc.h     |  229 ++++
 arch/tile/include/arch/trio_pcie_intfc_def.h |   32 +
 arch/tile/include/arch/trio_pcie_rc.h        |  156 +++
 arch/tile/include/arch/trio_pcie_rc_def.h    |   24 +
 arch/tile/include/arch/trio_shm.h            |  125 ++
 arch/tile/include/arch/trio_shm_def.h        |   19 +
 arch/tile/include/asm/pci.h                  |   99 ++-
 arch/tile/include/gxio/iorpc_trio.h          |   97 ++
 arch/tile/include/gxio/trio.h                |  304 +++++
 arch/tile/include/hv/drv_trio_intf.h         |  195 ++++
 arch/tile/kernel/Makefile                    |    4 +
 arch/tile/kernel/pci_gx.c                    | 1545 ++++++++++++++++++++++++++
 arch/tile/kernel/setup.c                     |    6 +
 arch/tile/mm/pgtable.c                       |    7 -
 drivers/pci/quirks.c                         |    6 +-
 23 files changed, 3363 insertions(+), 20 deletions(-)
