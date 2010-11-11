Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0KKW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:27:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48365 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KKW1O (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 11 Nov 2010 17:27:14 -0500
Date: Thu, 11 Nov 2010 17:25:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net, jslaby@suse.cz
Subject: [GIT PULL] fixes for Xen PCI + MAINTAINERS file
 (stable/xen-pcifront-fixes) for v2.6.37-rc2
Message-ID: <20101111222500.GA4455@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please pull these five small bug-fixes in your tree. The patches are
based on top git commit c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4
Linus Torvalds (1):
    Linux 2.6.37-rc1

Two of the bug-fixes are leaks found by the static analysis tool Stanse
(http://stanse.fi.muni.cz/). The other has been spotted by
human eyes. There are also two changes to the MAINTAINERS file, they
fix a regression (I was a bit too enthuastic when I added my name to that
file) and also what type of the xen-devel mailing lists are.

The git tree with these patches is:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xen-pcifront-fixes

and I am also attaching the full git diff for easy review.

Thank you!

Jesper Juhl (1):
      xen-pcifront: Remove duplicate inclusion of headers.

Jiri Slaby (2):
      xen: fix memory leak in Xen PCI MSI/MSI-X allocator.
      xen-pcifront: fix PCI reference leak

Joe Perches (1):
      MAINTAINERS: Mark XEN lists as moderated

Konrad Rzeszutek Wilk (1):
      MAINTAINERS: Update mailing list name for Xen pieces.

 MAINTAINERS                |    6 +++---
 arch/x86/pci/xen.c         |    8 +++++---
 drivers/pci/xen-pcifront.c |    6 +++---
 3 files changed, 11 insertions(+), 9 deletions(-)

The full diff:

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..6a16f21 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6598,14 +6598,14 @@ F:	drivers/platform/x86
 
 XEN PCI SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
 S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
@@ -6613,7 +6613,7 @@ F:	drivers/xen/*swiotlb*
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xen.org
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
 L:	virtualization@lists.osdl.org
 S:	Supported
 F:	arch/x86/xen/
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 117f5b8..d7b5109 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -147,8 +147,10 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
 			(type == PCI_CAP_ID_MSIX) ?
 			"pcifront-msi-x" : "pcifront-msi");
-		if (irq < 0)
-			return -1;
+		if (irq < 0) {
+			ret = -1;
+			goto free;
+		}
 
 		ret = set_irq_msi(irq, msidesc);
 		if (ret)
@@ -164,7 +166,7 @@ error:
 	if (ret == -ENODEV)
 		dev_err(&dev->dev, "Xen PCI frontend has not registered" \
 			" MSI/MSI-X support!\n");
-
+free:
 	kfree(v);
 	return ret;
 }
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index a87c498..3a5a6fc 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -13,7 +13,6 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/msi.h>
-#include <xen/xenbus.h>
 #include <xen/interface/io/pciif.h>
 #include <asm/xen/pci.h>
 #include <linux/interrupt.h>
@@ -576,8 +575,9 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 
 	pcidev = pci_get_bus_and_slot(bus, devfn);
 	if (!pcidev || !pcidev->driver) {
-		dev_err(&pcidev->dev,
-			"device or driver is NULL\n");
+		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
+		if (pcidev)
+			pci_dev_put(pcidev);
 		return result;
 	}
 	pdrv = pcidev->driver;
