Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab1EJQCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:02:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1EJQCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:02:02 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v4 0/3] Store and load PCI device saved state across function
	resets
To: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Tue, 10 May 2011 10:01:58 -0600
Message-ID: <20110510155642.3490.61935.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 -> v4:
  Renamed struct pci_cap_saved -> struct pci_cap_saved_data and
  the element name within struct pci_cap_saved_state to cap.

Jesse, I hope this helps provide the clarification you were looking
for.  Thanks for the comments.

v2 -> v3:
  Saved structure has variable contents.

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
