Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2IYVin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:38:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51775 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2IYVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:38:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org,
        konrad.wilk@oracle.com, konrad.wilk@oracle.com, konrad.wilk@oracle.com,
        konrad.wilk@oracle.com, konrad.wilk@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH 1/2] xen/pciback: Restore the PCI config space after an FLR.
Date: Tue, 25 Sep 2012 17:27:19 -0400
Message-Id: <1348608440-4018-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
References: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do an FLR, or D0->D3_hot we may lose the BARs as the
device has turned itself off (and on). This means the device cannot
function unless the pci_restore_state is called - which it is
when the PCI device is unbound from the Xen PCI backend driver.
For PV guests it ends up calling pci_enable_device / pci_enable_msi[x]
which does the proper steps

That however is not happening if a HVM guest is run as QEMU
deals with PCI configuration space. QEMU also requires that the
device be "parked"  under the ownership of a pci-stub driver to
guarantee that the PCI device is not being used. Hence we
follow the same incantation as pci_reset_function does - by
doing an FLR, then restoring the PCI configuration space.

The result of this patch is that when you run lspci, you get
now this:

-       Region 0: [virtual] Memory at fe8c0000 (32-bit, non-prefetchable) [size=128K]
-       Region 1: [virtual] Memory at fe800000 (32-bit, non-prefetchable) [size=512K]
+       Region 0: Memory at fe8c0000 (32-bit, non-prefetchable) [size=128K]
+       Region 1: Memory at fe800000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at c000 [size=32]
-       Region 3: [virtual] Memory at fe8e0000 (32-bit, non-prefetchable) [size=16K]
+       Region 3: Memory at fe8e0000 (32-bit, non-prefetchable) [size=16K]

The [virtual] means that lspci read those entries from SysFS but when
it read them from the device it got a different value (0xfffffff).

CC: stable@vger.kernel.org # only for v3.4 and v3.5
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index acec6fa..e5a0c13 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -362,6 +362,7 @@ static int __devinit pcistub_init_device(struct pci_dev *dev)
 	else {
 		dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
 		__pci_reset_function_locked(dev);
+		pci_restore_state(dev);
 	}
 	/* Now disable the device (this also ensures some private device
 	 * data is setup before we export)
-- 
1.7.7.6

