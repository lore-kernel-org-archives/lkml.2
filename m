Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab2CMH2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:28:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49449 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759735Ab2CMH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:27:59 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/12] PCI: Kill pci_is_reassignedev()
Date: Tue, 13 Mar 2012 00:26:26 -0700
Message-Id: <1331623594-30543-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5EF6FC.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one user. Just use pci_specified_resource_alignement() directly.
So could only get get align one time for the dev that in the list

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b832f0f..32ab301 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3682,18 +3682,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
 	return align;
 }
 
-/**
- * pci_is_reassigndev - check if specified PCI is target device to reassign
- * @dev: the PCI device to check
- *
- * RETURNS: non-zero for PCI device is a target device to reassign,
- *          or zero is not.
- */
-int pci_is_reassigndev(struct pci_dev *dev)
-{
-	return (pci_specified_resource_alignment(dev) != 0);
-}
-
 /*
  * This function disables memory decoding and releases memory resources
  * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
@@ -3708,7 +3696,9 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	resource_size_t align, size;
 	u16 command;
 
-	if (!pci_is_reassigndev(dev))
+	/* check if specified PCI is target device to reassign */
+	align = pci_specified_resource_alignment(dev);
+	if (!align)
 		return;
 
 	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
@@ -3724,7 +3714,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	align = pci_specified_resource_alignment(dev);
 	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
 		r = &dev->resource[i];
 		if (!(r->flags & IORESOURCE_MEM))
-- 
1.7.7

