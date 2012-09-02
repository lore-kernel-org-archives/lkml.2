Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2IBVzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:55:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20055 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2IBVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:49 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH part4 06/11] PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
Date: Sun,  2 Sep 2012 14:54:16 -0700
Message-Id: <1346622861-30865-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will call new added pci_stop_and_remove_bus() to stop/remove pci root bus.

Also checking if that pci_root_bus get removed already in bus remove in /sys

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index ec54014..12791fd 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -645,10 +645,24 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
+	/* that root bus could be removed already */
+	if (!pci_find_bus(root->segment, root->secondary.start)) {
+		dev_printk(KERN_DEBUG, &device->dev,
+		  "freeing acpi_pci_root, but pci root bus was removed before");
+		goto out;
+	}
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
+	dev_printk(KERN_DEBUG, &device->dev,
+		"freeing acpi_pci_root, will remove pci root bus at first");
+	pci_stop_and_remove_bus(root->bus);
+
+out:
+	list_del(&root->node);
 	kfree(root);
+
 	return 0;
 }
 
-- 
1.7.7

