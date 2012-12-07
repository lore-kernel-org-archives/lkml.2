Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945955Ab2LGGZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2LGGY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:24:57 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 00/15] PCI/ACPI: Remove "pci_root" sub-driver support
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:24:54 -0700
Message-ID: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "PCI Root Bridge ("pci_root")" driver includes support for attaching
sub-drivers.  acpi_pci_register_driver() and acpi_pci_unregister_driver()
are the interfaces that sub-drivers use to attach themselves.

Currently there are only two callers of acpi_pci_register_driver(): the
"ACPI Hot Plug PCI Controller Driver ("acpiphp")" and "ACPI PCI Slot
Detection Driver ("pci_slot")" sub-drivers.

Sub-drivers may be compiled as modules.  Kernel modules are instantiated
somewhat randomly - the order in which they are linked as the kernel as
built - thus if there are any dependencies on the ordering of attaching
sub-drivers, they can not be effectively dealt with.

This patch series resolves any potential sequencing inter-dependencies by
converting sub-driver functionality to being only supported as statically
built-in to the kernel as part of the "pci_root" driver itself (i.e. no
longer supported as a module).  Inter-dependencies can then be effectively
handled by explicitly sequencing the addition of such functionality.


The series begins with a patch from Yinghai Lu's "PCI, ACPI, x86: pci root
bus hotplug support" series that separates host bridge specific hot-plug
functionality from PCI device hot-plug functionality.  This patch
significantly simplifies a fairly confusing implementation due to the
co-mingling that currently exists.
  Reference: https://lkml.org/lkml/2012/9/19/413

The rest of the patches in this series implement the conversion of the
"PCI Root Bridge" sub-drivers.  This also simplifies the implementation as
is revealed by a 'diffstat' of the respective, conversion related,
patches: 9 files changed, 86 insertions(+), 237 deletions(-)


This series is targeting the 3.9 merge window.  I expect that after
3.8-rc1 is released, a -v2 of this series will be required due to Bill
Pemberton's "[PATCH 000/493] remove CONFIG_HOTPLUG as an option" series.
That said, I wanted to go ahead and get this out now in order to solicit
feedback.
  Reference: https://lkml.org/lkml/2012/11/16/660
---

Myron Stowe (14):
      PCI/ACPI: Remove the "pci_root" driver's sub-driver infrastructure
      PCI/ACPI: Add "pci_slot" functionality statically within "pci_root"
      PCI/ACPI: Convert "pci_slot" sub-driver's functionality to built-in only
      PCI/ACPI: Move where dmi_check_system() is called from
      PCI/ACPI: Fix latent refcount issue in acpi_pci_root_start()
      PCI/acpiphp: Change acpiphp_add_bridge() to return void instead of 0
      PCI/acpiphp: Add "acpiphp" functionality statically within "pci_root"
      PCI/acpiphp: Collapse the initialization call chain of "acpiphp" further
      PCI/acpiphp: Declare acpi_{add,remove}_bridge() as external functions
      PCI/acpiphp: Convert "acpiphp" sub-driver's functionality to built-in only
      PCI/acpiphp: Collapse initialization call chain of "acpiphp" sub-driver
      PCI/acpiphp: Change acpiphp_glue_init() to return void instead of 0
      PCI/acpiphp: Leave the "acpiphp" sub-driver registered and in place
      PCI/acpiphp: Fix coding style of external declarations in acpiphp.h

Yinghai Lu (1):
      PCI, acpiphp: Separate out hot-add support of pci host bridge


 drivers/acpi/Kconfig               |    5 -
 drivers/acpi/Makefile              |    1 
 drivers/acpi/pci_root.c            |   50 +-------
 drivers/acpi/pci_root_hp.c         |  228 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/pci_slot.c            |   84 +++++--------
 drivers/pci/hotplug/Kconfig        |    5 -
 drivers/pci/hotplug/acpiphp.h      |   17 +--
 drivers/pci/hotplug/acpiphp_core.c |   45 -------
 drivers/pci/hotplug/acpiphp_glue.c |  115 +++---------------
 include/linux/acpi.h               |    9 -
 include/linux/pci-acpi.h           |   16 +++
 11 files changed, 312 insertions(+), 263 deletions(-)
 create mode 100644 drivers/acpi/pci_root_hp.c

-- 
