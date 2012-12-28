Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2L1Hcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 02:32:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2L1Hce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 02:32:34 -0500
X-IronPort-AV: E=Sophos;i="4.84,367,1355068800"; 
   d="scan'208";a="6492408"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, tangchen@cn.fujitsu.com,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] pci: remove redundant function calls in pci_reassigndev_resource_alignment()
Date: Fri, 28 Dec 2012 15:31:42 +0800
Message-Id: <1356679902-4266-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/28 15:32:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/28 15:32:15,
	Serialize complete at 2012/12/28 15:32:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_reassigndev_resource_alignment() potentially calls
pci_specified_resource_alignment() twice, which is redundant.

pci_is_reassigndev() is only called in pci_reassigndev_resource_alignment(),
and from sematic/functionality aspects pci_specified_resource_alignment() is
sufficient to substitute, so also make some cleanup.

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5cb5820..789f401 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3766,18 +3766,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
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
@@ -3792,7 +3780,8 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	resource_size_t align, size;
 	u16 command;
 
-	if (!pci_is_reassigndev(dev))
+	align = pci_specified_resource_alignment(dev);
+	if (!align)
 		return;
 
 	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
@@ -3808,7 +3797,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	align = pci_specified_resource_alignment(dev);
 	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
 		r = &dev->resource[i];
 		if (!(r->flags & IORESOURCE_MEM))
-- 
1.7.1

