Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2CJHCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:02:55 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39335 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2CJHCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:02:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH v2 21/37] PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
Date: Fri,  9 Mar 2012 23:00:21 -0800
Message-Id: <1331362837-10740-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F5AFC91.001E,ss=1,re=0.000,fgs=0
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
index 7aff631..b38e347 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -643,10 +643,24 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
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

