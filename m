Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2LGG3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:29:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965054Ab2LGGZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:18 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 03/15] PCI/acpiphp: Leave the "acpiphp" sub-driver registered
	and in place
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:13 -0700
Message-ID: <20121207062513.11051.99972.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ACPI Hot Plug PCI Controller Driver ("acpiphp")" can be either
statically built-in or a kernel module.  If statically built-in, the
sub-driver needs to remain registered and in place in order to accommodate
any future hot-plug insertion events of devices it supports.

As currently implemented, the sub-driver may unregister itself during its
initialization.  This patch changes that behavior so that the sub-driver
remains registered and in place.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_core.c |   16 +---------------
 drivers/pci/hotplug/acpiphp_glue.c |   21 ---------------------
 3 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 014ae78..4b798e9 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -193,7 +193,6 @@ extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 /* acpiphp_glue.c */
 extern int acpiphp_glue_init(void);
 extern void acpiphp_glue_exit(void);
-extern int acpiphp_get_num_slots(void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 extern int acpiphp_enable_slot(struct acpiphp_slot *slot);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 96316b7..3350b09 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -50,7 +50,6 @@
 bool acpiphp_debug;
 
 /* local variables */
-static int num_slots;
 static struct acpiphp_attention_info *attention_info;
 
 #define DRIVER_VERSION	"0.5"
@@ -274,21 +273,8 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 
 static int __init init_acpi(void)
 {
-	int retval;
-
 	/* initialize internal data structure etc. */
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
+	return acpiphp_glue_init();
 }
 
 /**
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index d0369dc..a378a48 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1435,27 +1435,6 @@ void  acpiphp_glue_exit(void)
 
 
 /**
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
-/**
  * acpiphp_enable_slot - power on slot
  * @slot: ACPI PHP slot
  */

