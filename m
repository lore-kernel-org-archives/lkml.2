Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1DTUbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab1DTUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:31:30 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 0/3] Store and load PCI device saved state across function
	resets
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, jbarnes@virtuousgeek.org
Date: Wed, 20 Apr 2011 14:31:27 -0600
Message-ID: <20110420202523.3189.31306.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2 -> v3:
  Saved structure has variable contents.

Avi, see if this adds any credibility to the pci-core allocated
opaque buffer.  It was wrong in the previous versions to distill
the variable device capability save list into a fixed struct.
This should also eliminate any future maintenance specific to
this storing and loading of state as capability save changes.

v1 -> v2:
  Make the pointer passed around less opaque for type safety.

Bug https://bugs.launchpad.net/qemu/+bug/754591 is caused because
the KVM module attempts to do a pci_save_state() before assigning
the device to a VM, expecting that the saved state will remain
valid until we release the device.  This is in conflict with our
need to reset devices using PCI sysfs during a VM reset to
quiesce the device.  Any calls to pci_reset_function() will
overwrite the device saved stated prior to reset, and reload and
invalidate the state after.  KVM then ends up trying to restore
the state, but it's already invalid, so the device ends up with
reset values.

This series adds a mechanism to pull the saved state off the
struct pci_dev and reload it later.  Thanks,

Alex
---

Alex Williamson (3):
      KVM: Use pci_store/load_saved_state() around VM device usage
      PCI: Add interfaces to store and load the device saved state
      PCI: Track the size of each saved capability data area


 drivers/pci/pci.c        |  110 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h |    1 
 include/linux/pci.h      |   15 +++++-
 virt/kvm/assigned-dev.c  |   18 ++++++--
 4 files changed, 132 insertions(+), 12 deletions(-)
