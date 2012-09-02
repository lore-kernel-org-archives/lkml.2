Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2IBV4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:56:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40053 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2IBV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:56:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part5 1/7] ACPI, PCI: Use normal list for struct acpi_pci_driver
Date: Sun,  2 Sep 2012 14:55:59 -0700
Message-Id: <1346622965-30937-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
References: <1346622965-30937-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use normal list for struct acpi_pci_driver to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   16 +++-------------
 include/linux/acpi.h    |    2 +-
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 12791fd..2aec08d 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -72,8 +72,8 @@ static struct acpi_driver acpi_pci_root_driver = {
 };
 
 static LIST_HEAD(acpi_pci_roots);
+static LIST_HEAD(acpi_pci_drivers);
 
-static struct acpi_pci_driver *sub_driver;
 static DEFINE_MUTEX(osc_lock);
 
 int acpi_pci_register_driver(struct acpi_pci_driver *driver)
@@ -81,10 +81,7 @@ int acpi_pci_register_driver(struct acpi_pci_driver *driver)
 	int n = 0;
 	struct acpi_pci_root *root;
 
-	struct acpi_pci_driver **pptr = &sub_driver;
-	while (*pptr)
-		pptr = &(*pptr)->next;
-	*pptr = driver;
+	list_add_tail(&driver->node, &acpi_pci_drivers);
 
 	if (!driver->add)
 		return 0;
@@ -103,14 +100,7 @@ void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
 {
 	struct acpi_pci_root *root;
 
-	struct acpi_pci_driver **pptr = &sub_driver;
-	while (*pptr) {
-		if (*pptr == driver)
-			break;
-		pptr = &(*pptr)->next;
-	}
-	BUG_ON(!*pptr);
-	*pptr = (*pptr)->next;
+	list_del(&driver->node);
 
 	if (!driver->remove)
 		return;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 3ad510b..a54cf8e 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -138,7 +138,7 @@ void acpi_penalize_isa_irq(int irq, int active);
 void acpi_pci_irq_disable (struct pci_dev *dev);
 
 struct acpi_pci_driver {
-	struct acpi_pci_driver *next;
+	struct list_head node;
 	int (*add)(acpi_handle handle);
 	void (*remove)(acpi_handle handle);
 };
-- 
1.7.7

