Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab2ISSzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:55:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48057 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab2ISSzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 25/40] PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
Date: Wed, 19 Sep 2012 11:54:39 -0700
Message-Id: <1348080894-23412-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will call new added pci_stop_and_remove_bus() to stop/remove pci root bus.

Also checking if that pci_root_bus get removed already in bus remove in /sys

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 3d92c0e..92ec5c9 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -652,10 +652,26 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
+	/* that root bus could be removed already */
+	if (!pci_find_bus(root->segment, root->secondary.start)) {
+		dev_printk(KERN_DEBUG, &device->dev,
+		  "freeing acpi_pci_root, but pci root bus was removed before");
+		goto out;
+	}
+
+	pci_stop_root_bus(root->bus);
+
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
+	dev_printk(KERN_DEBUG, &device->dev,
+		"freeing acpi_pci_root, will remove pci root bus at first");
+	pci_remove_root_bus(root->bus);
+
+out:
+	list_del(&root->node);
 	kfree(root);
+
 	return 0;
 }
 
-- 
1.7.7

