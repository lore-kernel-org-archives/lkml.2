Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab2KDEj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 00:39:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27162 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2KDEjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 00:39:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 8/8] PCI, ACPI: reserve fw allocated resource for hot added root bus
Date: Sat,  3 Nov 2012 21:39:31 -0700
Message-Id: <1352003971-22278-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1352003971-22278-1-git-send-email-yinghai@kernel.org>
References: <20121030040237.GA10472@google.com>
 <1352003971-22278-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FW could already allocate resource in pci bar registers, and we need to
reserve it before try to allocate another one.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 012f40d..bc09567 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -644,8 +644,10 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
-	if (system_state != SYSTEM_BOOTING)
+	if (system_state != SYSTEM_BOOTING) {
+		pcibios_resource_survey_bus(root->bus);
 		pci_assign_unassigned_bus_resources(root->bus);
+	}
 
 	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
-- 
1.7.7

