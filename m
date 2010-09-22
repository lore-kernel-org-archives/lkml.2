Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0IVVP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:15:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58889 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0IVVPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:15:55 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.57,219,1283731200"; 
   d="scan'208";a="593325553"
Date: Wed, 22 Sep 2010 14:15:57 -0700
From: Tom Lyon <pugs@cisco.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jbarnes@virtuousgeek.org, randy.dunlap@oracle.com,
        arnd@arndb.de, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
        gregkh@suse.de, chrisw@sous-sol.org, alex.williamson@redhat.com,
        mst@redhat.com
Subject: [PATCH 0/3] VFIO V4: VFIO driver: Non-privileged user level PCI
 drivers
Message-ID: <4c9a720d.kfMPk+Yyq+IUUwiw%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a long summer break, it's tanned, it's rested, and it's ready to rumble!

In this version:	*** REBASE to 2.6.35 ***

There's new code using generic netlink messages which allows the kernel
to notify the user level of weird events and allows the user level to 
respond. This is currently used to handle device removal (whether software
or hardware driven), PCI error events, and system suspend & hibernate.

The driver now supports devices which use multiple MSI interrupts, reflecting
the actual number of interrupts allocated by the system to the user level.

PCI config accesses are now done through the pci_user_{read,write)_config
routines from drivers/pci/access.c.

Numerous other tweaks and cleanups.

Blurb from version 3:

There are lots of bug fixes and cleanups in this version, but the main
change is to check to make sure that the IOMMU has interrupt remapping
enabled, which is necessary to prevent user level code from triggering
spurious interrupts for other devices.  Since most platforms today
do not have the necessary hardware and/or software for this, a module
option can override this check, thus making vfio useful (but not safe)
on many more platforms.

In the next version I plan to add kernel to user messaging using the
generic netlink mechanism to allow the user driver to react to hot add
and remove, and power management requests.

Blurb from version 2:

This version now requires an IOMMU domain to be set before any access to
device registers is granted (except that config space may be read).  In
addition, the VFIO_DMA_MAP_ANYWHERE is dropped - it used the dma_map_sg API
which does not have sufficient controls around IOMMU usage.  The IOMMU domain
is obtained from the 'uiommu' driver which is included in this patch.

Various locking, security, and documentation issues have also been fixed.

Please commit - it or me!
But seriously, who gets to commit this? Avi for KVM? or GregKH for drivers?

Blurb from version 1:

This patch is the evolution of code which was first proposed as a patch to
uio/uio_pci_generic, then as a more generic uio patch. Now it is taken entirely
out of the uio framework, and things seem much cleaner. Of course, there is
a lot of functional overlap with uio, but the previous version just seemed
like a giant mode switch in the uio code that did not lead to clarity for
either the new or old code.

[a pony for avi...]
The major new functionality in this version is the ability to deal with
PCI config space accesses (through read & write calls) - but includes table
driven code to determine whats safe to write and what is not. Also, some
virtualization of the config space to allow drivers to think they're writing
some registers when they're not.  Also, IO space accesses are also allowed.
Drivers for devices which use MSI-X are now prevented from directly writing
the MSI-X vector area.

All interrupts are now handled using eventfds, which makes things very simple.

The name VFIO refers to the Virtual Function capabilities of SR-IOV devices
but the driver does support many more types of devices.  I was none too sure
what driver directory this should live in, so for now I made up my own under
drivers/vfio. As a new driver/new directory, who makes the commit decision?

I currently have user level drivers working for 3 different network adapters
- the Cisco "Palo" enic, the Intel 82599 VF, and the Intel 82576 VF (but the
whole user level framework is a long ways from release).  This driver could
also clearly replace a number of other drivers written just to give user
access to certain devices - but that will take time.

Tom Lyon (3):
  VFIO V4: export pci_user_{read,write}_config
  VFIO V4: uiommu driver - allow user progs to manipulate iommu domains
  VFIO V4: VFIO driver: Non-privileged user level PCI drivers

 Documentation/ioctl/ioctl-number.txt |    1 +
 Documentation/vfio.txt               |  183 ++++++++
 MAINTAINERS                          |    8 +
 drivers/Kconfig                      |    2 +
 drivers/Makefile                     |    2 +
 drivers/pci/access.c                 |    6 +-
 drivers/pci/pci.h                    |    7 -
 drivers/vfio/Kconfig                 |   18 +
 drivers/vfio/Makefile                |   11 +
 drivers/vfio/uiommu.c                |  126 ++++++
 drivers/vfio/vfio_dma.c              |  346 +++++++++++++++
 drivers/vfio/vfio_intrs.c            |  257 ++++++++++++
 drivers/vfio/vfio_main.c             |  768 ++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_netlink.c          |  459 ++++++++++++++++++++
 drivers/vfio/vfio_pci_config.c       |  698 ++++++++++++++++++++++++++++++
 drivers/vfio/vfio_rdwr.c             |  158 +++++++
 drivers/vfio/vfio_sysfs.c            |  118 ++++++
 include/linux/Kbuild                 |    1 +
 include/linux/pci.h                  |    8 +
 include/linux/uiommu.h               |   76 ++++
 include/linux/vfio.h                 |  267 ++++++++++++
 21 files changed, 3511 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/vfio.txt
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/uiommu.c
 create mode 100644 drivers/vfio/vfio_dma.c
 create mode 100644 drivers/vfio/vfio_intrs.c
 create mode 100644 drivers/vfio/vfio_main.c
 create mode 100644 drivers/vfio/vfio_netlink.c
 create mode 100644 drivers/vfio/vfio_pci_config.c
 create mode 100644 drivers/vfio/vfio_rdwr.c
 create mode 100644 drivers/vfio/vfio_sysfs.c
 create mode 100644 include/linux/uiommu.h
 create mode 100644 include/linux/vfio.h

