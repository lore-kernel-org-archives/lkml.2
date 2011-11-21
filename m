Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1KUSyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:54:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1KUSyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:54:03 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 0/3] PCI: Convert maintaining FW-assigned BIOS BAR values
	to a list of temporary entries
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Mon, 21 Nov 2011 11:54:01 -0700
Message-ID: <20111121185401.9603.34587.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 58c84eda075 functionality was introduced that attempts to
reinstate the original, FW-assigned, BAR addresses of a PCI device when
normal resource assignment fails.  To keep track of the BIOS BAR
addresses, struct pci_dev was augmented with an array to hold the device's
BAR addresses: 'resource_size_t fw_addr[DEVICE_COUNT_RESOURCE]'.

The reinstatement of BAR addresses is an uncommon event leaving the
'fw_addr' array unused under normal circumstances.  As the use of struct
pci_dev is so prevalent, this seems wasteful.

This patch series introduces a stand alone data structure and
corresponding interface routine that is used in converting the
underlying aspects of the existing maintanence scheme to a list of
temporary BIOS BAR value entries.

[v2]
 - Simplified list maintenance by adding a routine, and call to such,
   to delete the entire list once PCI enumeration is complete (as opposed
   to keeping reference counters and deleting entries as the reference
   counts go to 0).
 - Reinstatement of FW-assigned BAR addresses is currently only
   implemented for x86 so I relocated the stand alone data structure and
   maintenance routines within an x86 architecture specific file and
   introduced a '__weak' attribute generic interface routine -
   'pcibios_retrieve_fw_addr()' which returns a failure condition - into
   the PCI core that resolves the interface for all other architectures.

---

Myron Stowe (3):
      x86/PCI: Convert maintaining FW-assigned BIOS BAR values to use a list
      x86/PCI: Infrastructure to maintain a list of FW-assigned BIOS BAR values
      PCI: Fix starting basis for resource requests


 arch/x86/pci/i386.c     |   83 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/setup-res.c |   36 ++++++++++++++++----
 include/linux/pci.h     |    2 +
 3 files changed, 112 insertions(+), 9 deletions(-)

-- 
