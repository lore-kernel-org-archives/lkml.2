Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3AGWHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AGWHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:07:09 -0500
Subject: [PATCH 0/1] vfio-pci: Towards VGA support
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2013 15:07:08 -0700
Message-ID: <20130107214605.8669.26237.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfio makes a nice interface to start looking at supporting VGA devices
assigned to virtual machines (ie. userspace drivers) because we can so
easily add additional ranges for a device.  In this patch we add
legacy MMIO (below 1MB) and I/O port (64k) to devices with PCI class
code VGA.  We can then use the kernel VGA arbiter service to change
chipset routing for each access to the VGA ranges defined in the PCI
spec.  The rest of the region space not used by VGA is left
inaccessible until we add future feature that needs some other
legacy range.

There's also a qemu userspace companion series to this which learns
how to look for this new feature flag and setup ranges.  Together
they get a step closer to supporting vfio-based VGA assignment, but
it doesn't yet work.  I'm posting in this broken state both for
archival purposes as well as the hope that someone has ideas of what
might be missing or be able to pick up and run with this code.

Some cards are able to get through execution of their VGA BIOS with
these patches, but none that I've seen sync the monitor to VGA text
mode from seabios.  With a hack in qemu for a card specific backdoor
on a Radeon HD5450 I've been able to get syslinux graphics mode to
work and Windows will use it during normal bootup.  I have no idea
what might be missing for VGA text mode.  Thanks,

Alex

---

Alex Williamson (1):
      vfio-pci: [NOT FOR COMMIT] Add support for legacy MMIO & I/O port towards VGA support


 drivers/vfio/pci/vfio_pci.c         |   74 ++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |    6 +
 drivers/vfio/pci/vfio_pci_rdwr.c    |  170 +++++++++++++++++++++++++++--------
 include/uapi/linux/vfio.h           |    3 +
 4 files changed, 197 insertions(+), 56 deletions(-)
