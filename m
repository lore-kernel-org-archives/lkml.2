Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0J3Q67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0J3Q65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:58:57 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/5] Fixes, non-PCI-2.3 support, EOI enhancements
To: pugs@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, chrisw@redhat.com, mst@redhat.com,
        alex.williamson@redhat.com
Date: Sat, 30 Oct 2010 10:58:55 -0600
Message-ID: <20101030164626.885.89216.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

I've updated some patches I've been working on to v5 and wanted to
see what you think.  I also found a couple minor bugs, fixed in this
series.

The main idea is that since the VFIO interface defines that the INTx
interrupt is disabled when it fires, we should provide an interface
to re-enable it.  We currently have to do a read-modify-write to PCI
config space, requring two ioctls.  I introduce an ioctl to do this
for us.  An important aspect of this is that now we can support
non-PCI-2.3 devices since re-enabling the interrupt is abstracted
(with the same caveat as current KVM device assignment, that they
must get an exclusive interrupt).  The real trick though is that we
can then also create an irqfd-like mechanism to trigger re-enabling
interrupts from and eventfd.  This allows qemu to do all the setup
for connecting interrupts from VFIO into KVM and EOIs from KVM to
VFIO, then lets userspace get completely out of the way.

Hope you like it.  Thanks,

Alex
---

Alex Williamson (5):
      vfio: Add a new ioctl to support EOI via eventfd
      vfio: Add support for non-PCI 2.3 compliant devices
      vfio: Add ioctl to re-enable interrupts
      vfio: Fix requested regions
      vfio: Fix the ROM mask


 drivers/vfio/vfio_intrs.c      |  254 +++++++++++++++++++++++++++++++++++++---
 drivers/vfio/vfio_main.c       |   37 +++++-
 drivers/vfio/vfio_pci_config.c |    2 
 drivers/vfio/vfio_rdwr.c       |    4 -
 include/linux/vfio.h           |   14 ++
 5 files changed, 279 insertions(+), 32 deletions(-)
