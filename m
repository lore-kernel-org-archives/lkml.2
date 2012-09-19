Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2ISSzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:55:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19703 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab2ISSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 24/40] PCI, acpi: Update acpi_pci_driver add/remove interface
Date: Wed, 19 Sep 2012 11:54:38 -0700
Message-Id: <1348080894-23412-25-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To take acpi_pci_root pointer instead, so later caller will not need to

check the apci_pci_root list to find it.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c            |    4 ++--
 drivers/acpi/pci_slot.c            |   12 +++++++-----
 drivers/pci/hotplug/acpiphp_glue.c |   12 +++++++-----
 include/linux/acpi.h               |    4 ++--
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 72a2c98..3d92c0e 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -90,7 +90,7 @@ int acpi_pci_register_driver(struct acpi_pci_driver *driver)
 		return 0;
 
 	list_for_each_entry(root, &acpi_pci_roots, node) {
-		driver->add(root->device->handle);
+		driver->add(root);
 		n++;
 	}
 
@@ -116,7 +116,7 @@ void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
 		return;
 
 	list_for_each_entry(root, &acpi_pci_roots, node)
-		driver->remove(root->device->handle);
+		driver->remove(root);
 }
 
 EXPORT_SYMBOL(acpi_pci_unregister_driver);
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index e50e31a..1c16c20 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -67,8 +67,8 @@ struct acpi_pci_slot {
 	struct list_head list;		/* node in the list of slots */
 };
 
-static int acpi_pci_slot_add(acpi_handle handle);
-static void acpi_pci_slot_remove(acpi_handle handle);
+static int acpi_pci_slot_add(struct acpi_pci_root *root);
+static void acpi_pci_slot_remove(struct acpi_pci_root *root);
 
 static LIST_HEAD(slot_list);
 static DEFINE_MUTEX(slot_list_lock);
@@ -295,11 +295,11 @@ walk_root_bridge(acpi_handle handle, acpi_walk_callback user_function)
  * @handle: points to an acpi_pci_root
  */
 static int
-acpi_pci_slot_add(acpi_handle handle)
+acpi_pci_slot_add(struct acpi_pci_root *root)
 {
 	acpi_status status;
 
-	status = walk_root_bridge(handle, register_slot);
+	status = walk_root_bridge(root->device->handle, register_slot);
 	if (ACPI_FAILURE(status))
 		err("%s: register_slot failure - %d\n", __func__, status);
 
@@ -311,12 +311,14 @@ acpi_pci_slot_add(acpi_handle handle)
  * @handle: points to an acpi_pci_root
  */
 static void
-acpi_pci_slot_remove(acpi_handle handle)
+acpi_pci_slot_remove(struct acpi_pci_root *root)
 {
 	struct acpi_pci_slot *slot, *tmp;
 	struct pci_bus *pbus;
+	acpi_handle handle;
 
 	mutex_lock(&slot_list_lock);
+	handle = root->device->handle;
 	list_for_each_entry_safe(slot, tmp, &slot_list, list) {
 		if (slot->root_handle == handle) {
 			list_del(&slot->list);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 00fa414..201c5f7 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -382,10 +382,10 @@ static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
 
 
 /* allocate and initialize host bridge data structure */
-static void add_host_bridge(acpi_handle *handle)
+static void add_host_bridge(struct acpi_pci_root *root)
 {
+	acpi_handle handle = root->device->handle;
 	struct acpiphp_bridge *bridge;
-	struct acpi_pci_root *root = acpi_pci_find_root(handle);
 
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (bridge == NULL)
@@ -468,8 +468,9 @@ find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 
 /* find hot-pluggable slots, and then find P2P bridge */
-static int add_bridge(acpi_handle handle)
+static int add_bridge(struct acpi_pci_root *root)
 {
+	acpi_handle handle = root->device->handle;
 	acpi_status status;
 	unsigned long long tmp;
 	acpi_handle dummy_handle;
@@ -490,7 +491,7 @@ static int add_bridge(acpi_handle handle)
 	/* check if this bridge has ejectable slots */
 	if (detect_ejectable_slots(handle) > 0) {
 		dbg("found PCI host-bus bridge with hot-pluggable slots\n");
-		add_host_bridge(handle);
+		add_host_bridge(root);
 	}
 
 	/* search P2P bridges under this host bridge */
@@ -591,8 +592,9 @@ cleanup_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-static void remove_bridge(acpi_handle handle)
+static void remove_bridge(struct acpi_pci_root *root)
 {
+	acpi_handle handle = root->device->handle;
 	struct acpiphp_bridge *bridge;
 
 	/* cleanup p2p bridges under this host bridge
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4f2a762..a686098 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -139,8 +139,8 @@ void acpi_pci_irq_disable (struct pci_dev *dev);
 
 struct acpi_pci_driver {
 	struct acpi_pci_driver *next;
-	int (*add)(acpi_handle handle);
-	void (*remove)(acpi_handle handle);
+	int (*add)(struct acpi_pci_root *root);
+	void (*remove)(struct acpi_pci_root *root);
 };
 
 int acpi_pci_register_driver(struct acpi_pci_driver *driver);
-- 
1.7.7

