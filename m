Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946018Ab2LGGZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGGZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:25:28 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 05/15] PCI/acpiphp: Collapse initialization call chain of
	"acpiphp" sub-driver
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:25 -0700
Message-ID: <20121207062524.11051.46916.stgit@amt.stowe>
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
acpiphp_glue_init() directly within acphphp_init(), removing the
intervening init_acpi() call.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/hotplug/acpiphp_core.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 011a538..1f4e228 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -271,14 +271,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-static int __init init_acpi(void)
-{
-	/* initialize internal data structure etc. */
-	acpiphp_glue_init();
-
-	return 0;
-}
-
 /**
  * release_slot - free up the memory used by a slot
  * @hotplug_slot: slot to free
@@ -363,21 +355,19 @@ static int __init acpiphp_init(void)
 {
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
-	if (acpi_pci_disabled)
-		return 0;
+	if (!acpi_pci_disabled)
+		/* initialize internal data structure etc. */
+		acpiphp_glue_init();
 
-	/* read all the ACPI info from the system */
-	return init_acpi();
+	return 0;
 }
 
 
 static void __exit acpiphp_exit(void)
 {
-	if (acpi_pci_disabled)
-		return;
-
-	/* deallocate internal data structures etc. */
-	acpiphp_glue_exit();
+	if (!acpi_pci_disabled)
+		/* deallocate internal data structures etc. */
+		acpiphp_glue_exit();
 }
 
 module_init(acpiphp_init);

