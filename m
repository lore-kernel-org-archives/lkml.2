Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946071Ab2LGGZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:45 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 08/15] PCI/acpiphp: Collapse the initialization call chain of
	"acpiphp" further
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:42 -0700
Message-ID: <20121207062542.11051.80189.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch collapses the initialization call chain of "acpiphp" by calling
acpi_pci_[un]register_driver() directly within acpiphp_{init,exit}(),
removing the intervening acpiphp_glue_{init,exit}() call.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp.h      |    2 --
 drivers/pci/hotplug/acpiphp_core.c |    4 ++--
 drivers/pci/hotplug/acpiphp_glue.c |   20 --------------------
 3 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 37f968e..bf62ac8 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -194,8 +194,6 @@ extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 extern struct acpi_pci_driver acpi_pci_hp_driver;
 extern int acpiphp_add_bridge(struct acpi_pci_root *root);
 extern void acpiphp_remove_bridge(struct acpi_pci_root *root);
-extern void acpiphp_glue_init(void);
-extern void acpiphp_glue_exit(void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 extern int acpiphp_enable_slot(struct acpiphp_slot *slot);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 1f4e228..5536b42 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -357,7 +357,7 @@ static int __init acpiphp_init(void)
 
 	if (!acpi_pci_disabled)
 		/* initialize internal data structure etc. */
-		acpiphp_glue_init();
+		acpi_pci_register_driver(&acpi_pci_hp_driver);
 
 	return 0;
 }
@@ -367,7 +367,7 @@ static void __exit acpiphp_exit(void)
 {
 	if (!acpi_pci_disabled)
 		/* deallocate internal data structures etc. */
-		acpiphp_glue_exit();
+		acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
 module_init(acpiphp_init);
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index f96b13c..3d5d7da 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1413,26 +1413,6 @@ struct acpi_pci_driver acpi_pci_hp_driver = {
 };
 
 /**
- * acpiphp_glue_init - initializes all PCI hotplug - ACPI glue data structures
- */
-void __init acpiphp_glue_init(void)
-{
-	acpi_pci_register_driver(&acpi_pci_hp_driver);
-}
-
-
-/**
- * acpiphp_glue_exit - terminates all PCI hotplug - ACPI glue data structures
- *
- * This function frees all data allocated in acpiphp_glue_init().
- */
-void  acpiphp_glue_exit(void)
-{
-	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
-}
-
-
-/**
  * acpiphp_enable_slot - power on slot
  * @slot: ACPI PHP slot
  */

