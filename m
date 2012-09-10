Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab2IJTgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:36:47 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:40834 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445Ab2IJTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:36:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Feng Tang <feng.tang@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 1/1] PCI: fix on-stack pci_device_id's
Date: Mon, 10 Sep 2012 21:36:41 +0200
Message-Id: <1347305801-7712-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.11.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "PCI: Use pci_device_id on stack for pci_get_subsys/class() to
avoid kmalloc" changed heap allocations to on-stack variables, but it
did not add initialization of other than set members. This causes
random failures during bootup wherever pci device is needed to be
found. Hence the boot just hangs or panics.

This patches fixes it by setting the content of pci_device_id directly
in the initializer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/pci/search.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 00d486a..bf969ba 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -243,12 +243,12 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 			       unsigned int ss_vendor, unsigned int ss_device,
 			       struct pci_dev *from)
 {
-	struct pci_device_id id;
-
-	id.vendor = vendor;
-	id.device = device;
-	id.subvendor = ss_vendor;
-	id.subdevice = ss_device;
+	struct pci_device_id id = {
+		.vendor = vendor,
+		.device = device,
+		.subvendor = ss_vendor,
+		.subdevice = ss_device,
+	};
 
 	return pci_get_dev_by_id(&id, from);
 }
@@ -289,11 +289,14 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
  */
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
 {
-	struct pci_device_id id;
-
-	id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
-	id.class_mask = PCI_ANY_ID;
-	id.class = class;
+	struct pci_device_id id = {
+		.vendor = PCI_ANY_ID,
+		.device = PCI_ANY_ID,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.class_mask = PCI_ANY_ID,
+		.class = class,
+	};
 
 	return pci_get_dev_by_id(&id, from);
 }
-- 
1.7.11.5


