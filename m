Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2KDEmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 00:42:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2KDEmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 00:42:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org
Subject: [PATCH 5/8] PCI, x86: Add pcibios_fw_addr_done
Date: Sat,  3 Nov 2012 21:39:28 -0700
Message-Id: <1352003971-22278-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352003971-22278-1-git-send-email-yinghai@kernel.org>
References: <20121030040237.GA10472@google.com>
 <1352003971-22278-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use it to skip not needed function after pcibios_fw_addr_list_del is called.

for pci root bus hot add, we will need to use pcibios_allocate_dev_resources(),
and don't want to mess up with fw_addr, for hot-add removing path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
---
 arch/x86/pci/i386.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 42dd755..edfc376 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -51,6 +51,7 @@ struct pcibios_fwaddrmap {
 
 static LIST_HEAD(pcibios_fwaddrmappings);
 static DEFINE_SPINLOCK(pcibios_fwaddrmap_lock);
+static bool pcibios_fw_addr_done;
 
 /* Must be called with 'pcibios_fwaddrmap_lock' lock held. */
 static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
@@ -72,6 +73,9 @@ pcibios_save_fw_addr(struct pci_dev *dev, int idx, resource_size_t fw_addr)
 	unsigned long flags;
 	struct pcibios_fwaddrmap *map;
 
+	if (pcibios_fw_addr_done)
+		return;
+
 	spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
 	map = pcibios_fwaddrmap_lookup(dev);
 	if (!map) {
@@ -97,6 +101,9 @@ resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
 	struct pcibios_fwaddrmap *map;
 	resource_size_t fw_addr = 0;
 
+	if (pcibios_fw_addr_done)
+		return fw_addr;
+
 	spin_lock_irqsave(&pcibios_fwaddrmap_lock, flags);
 	map = pcibios_fwaddrmap_lookup(dev);
 	if (map)
@@ -106,7 +113,7 @@ resource_size_t pcibios_retrieve_fw_addr(struct pci_dev *dev, int idx)
 	return fw_addr;
 }
 
-static void pcibios_fw_addr_list_del(void)
+static void __init pcibios_fw_addr_list_del(void)
 {
 	unsigned long flags;
 	struct pcibios_fwaddrmap *entry, *next;
@@ -118,6 +125,7 @@ static void pcibios_fw_addr_list_del(void)
 		kfree(entry);
 	}
 	spin_unlock_irqrestore(&pcibios_fwaddrmap_lock, flags);
+	pcibios_fw_addr_done = true;
 }
 
 static int
-- 
1.7.7

