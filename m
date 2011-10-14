Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1JNE2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab1JNE2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=P0j6JMthzdv6CNxCsQ4Jb0sug5NAGh3WrZKV0C4lC8cQGf/FcW+oCjqvLCHSrR1p0
	vH+TQETqQJZqkuhw+gWZg==
Subject: [PATCH v2 20/29] parisc/PCI: deal with LMMIO/PAT overlaps before
	creating PCI root bus
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:28:49 -0600
Message-ID: <20111014042849.23504.74781.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the truncate_pat_collision() call out of the pcibios_fixup_bus()
path so that when a future patch builds a list of root bus resources for
pci_create_bus(), it can use the truncated LMMIO range.

truncate_pat_collision() used to be called in this path:

    pci_scan_bus_parented
      pci_create_bus
      pci_scan_child_bus
        pcibios_fixup_bus
	  lba_fixup_bus
	    truncate_pat_collision

All of the PAT and lba_dev resource setup must be done before we call
pci_scan_bus_parented(), so it should be safe to move the
truncate_pat_collision() to just before pci_scan_bus_parented().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/parisc/lba_pci.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 3aeb327..2c7edf3 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -689,23 +689,7 @@ lba_fixup_bus(struct pci_bus *bus)
 				bus->resource[i++] = &(ldev->hba.elmmio_space);
 		}
 
-
-		/*   Overlaps with elmmio can (and should) fail here.
-		 *   We will prune (or ignore) the distributed range.
-		 *
-		 *   FIXME: SBA code should register all elmmio ranges first.
-		 *      that would take care of elmmio ranges routed
-		 *	to a different rope (already discovered) from
-		 *	getting registered *after* LBA code has already
-		 *	registered it's distributed lmmio range.
-		 */
-		if (truncate_pat_collision(&iomem_resource,
-				       	&(ldev->hba.lmmio_space))) {
-
-			printk(KERN_WARNING "LBA: lmmio_space [%lx/%lx] duplicate!\n",
-					(long)ldev->hba.lmmio_space.start,
-					(long)ldev->hba.lmmio_space.end);
-		} else {
+		if (ldev->hba.lmmio_space.flags) {
 			err = request_resource(&iomem_resource, &(ldev->hba.lmmio_space));
 			if (err < 0) {
 				printk(KERN_ERR "FAILED: lba_fixup_bus() request for "
@@ -1518,6 +1502,23 @@ lba_driver_probe(struct parisc_device *dev)
 	if (lba_dev->hba.bus_num.start < lba_next_bus)
 		lba_dev->hba.bus_num.start = lba_next_bus;
 
+	/*   Overlaps with elmmio can (and should) fail here.
+	 *   We will prune (or ignore) the distributed range.
+	 *
+	 *   FIXME: SBA code should register all elmmio ranges first.
+	 *      that would take care of elmmio ranges routed
+	 *	to a different rope (already discovered) from
+	 *	getting registered *after* LBA code has already
+	 *	registered it's distributed lmmio range.
+	 */
+	if (truncate_pat_collision(&iomem_resource,
+				   &(lba_dev->hba.lmmio_space))) {
+		printk(KERN_WARNING "LBA: lmmio_space [%lx/%lx] duplicate!\n",
+				(long)lba_dev->hba.lmmio_space.start,
+				(long)lba_dev->hba.lmmio_space.end);
+		lba_dev->hba.lmmio_space.flags = 0;
+	}
+
 	dev->dev.platform_data = lba_dev;
 	lba_bus = lba_dev->hba.hba_bus =
 		pci_scan_bus_parented(&dev->dev, lba_dev->hba.bus_num.start,

