Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab2CSF60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:58:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30865 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161518Ab2CSFsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 37/47] PCI: Kill pci_is_reassignedev()
Date: Sun, 18 Mar 2012 22:46:26 -0700
Message-Id: <1332135996-13860-38-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C89F.003D,ss=1,re=0.000,fgs=0
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
index 8156744..82ed56a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3685,18 +3685,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
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
@@ -3711,7 +3699,9 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	resource_size_t align, size;
 	u16 command;
 
-	if (!pci_is_reassigndev(dev))
+	/* check if specified PCI is target device to reassign */
+	align = pci_specified_resource_alignment(dev);
+	if (!align)
 		return;
 
 	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
@@ -3727,7 +3717,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
 	command &= ~PCI_COMMAND_MEMORY;
 	pci_write_config_word(dev, PCI_COMMAND, command);
 
-	align = pci_specified_resource_alignment(dev);
 	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
 		r = &dev->resource[i];
 		if (!(r->flags & IORESOURCE_MEM))
-- 
1.7.7

