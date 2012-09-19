Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab2ISS5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:57:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19869 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896Ab2ISSzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 39/40] PCI, acpiphp: Don't ailout even no slots found yet.
Date: Wed, 19 Sep 2012 11:54:53 -0700
Message-Id: <1348080894-23412-40-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could have root bus hot add later and there may be slot there that need acpiphp.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_core.c |   23 ++---------------------
 drivers/pci/hotplug/acpiphp_glue.c |   22 ----------------------
 3 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index a1afb5b..b3ead7a 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -193,7 +193,6 @@ extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 /* acpiphp_glue.c */
 extern int acpiphp_glue_init (void);
 extern void acpiphp_glue_exit (void);
-extern int acpiphp_get_num_slots (void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 extern int acpiphp_enable_slot (struct acpiphp_slot *slot);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 96316b7..c2fd309 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -50,7 +50,6 @@
 bool acpiphp_debug;
 
 /* local variables */
-static int num_slots;
 static struct acpiphp_attention_info *attention_info;
 
 #define DRIVER_VERSION	"0.5"
@@ -272,25 +271,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-static int __init init_acpi(void)
-{
-	int retval;
-
-	/* initialize internal data structure etc. */
-	retval = acpiphp_glue_init();
-
-	/* read initial number of slots */
-	if (!retval) {
-		num_slots = acpiphp_get_num_slots();
-		if (num_slots == 0) {
-			acpiphp_glue_exit();
-			retval = -ENODEV;
-		}
-	}
-
-	return retval;
-}
-
 /**
  * release_slot - free up the memory used by a slot
  * @hotplug_slot: slot to free
@@ -379,7 +359,8 @@ static int __init acpiphp_init(void)
 		return 0;
 
 	/* read all the ACPI info from the system */
-	return init_acpi();
+	/* initialize internal data structure etc. */
+	return acpiphp_glue_init();
 }
 
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e9e2e06..1f26706 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1408,28 +1408,6 @@ void  acpiphp_glue_exit(void)
 	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
-
-/**
- * acpiphp_get_num_slots - count number of slots in a system
- */
-int __init acpiphp_get_num_slots(void)
-{
-	struct acpiphp_bridge *bridge;
-	int num_slots = 0;
-
-	list_for_each_entry(bridge, &bridge_list, list) {
-		dbg("Bus %04x:%02x has %d slot%s\n",
-				pci_domain_nr(bridge->pci_bus),
-				bridge->pci_bus->number, bridge->nr_slots,
-				bridge->nr_slots == 1 ? "" : "s");
-		num_slots += bridge->nr_slots;
-	}
-
-	dbg("Total %d slots\n", num_slots);
-	return num_slots;
-}
-
-
 /**
  * acpiphp_enable_slot - power on slot
  * @slot: ACPI PHP slot
-- 
1.7.7

