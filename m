Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1APTpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:45:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab1APTpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:45:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] ACPI: Fix boot problem related to APEI with acpi_disabled set
Date: Sun, 16 Jan 2011 20:44:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andres Salomon <dilinger@queued.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201101162041.02419.rjw@sisk.pl>
In-Reply-To: <201101162041.02419.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101162044.22325.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 415e12b (PCI/ACPI: Request _OSC control once for each root
bridge (v3)) put the acpi_hest_init() call in acpi_pci_root_init()
into a wrong place, presumably because the author confused
acpi_pci_disabled with acpi_disabled.  Bring the code ordering in
acpi_pci_root_init() back to sanity.

Additionally, make sure that hest_disable is set when acpi_disabled
is set, which is going to prevent acpi_hest_parse(), that still may
be executed for acpi_disabled=1 through aer_acpi_firmware_first(),
from crashing because of uninitialized hest_tab.

Reported-and-tested-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/apei/hest.c |    6 +++---
 drivers/acpi/pci_root.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -631,11 +631,11 @@ static int acpi_pci_root_remove(struct a
 
 static int __init acpi_pci_root_init(void)
 {
+	acpi_hest_init();
+
 	if (acpi_pci_disabled)
 		return 0;
 
-	acpi_hest_init();
-
 	pci_acpi_crs_quirks();
 	if (acpi_bus_register_driver(&acpi_pci_root_driver) < 0)
 		return -ENODEV;
Index: linux-2.6/drivers/acpi/apei/hest.c
===================================================================
--- linux-2.6.orig/drivers/acpi/apei/hest.c
+++ linux-2.6/drivers/acpi/apei/hest.c
@@ -201,14 +201,14 @@ void __init acpi_hest_init(void)
 	int rc = -ENODEV;
 	unsigned int ghes_count = 0;
 
-	if (acpi_disabled)
-		return;
-
 	if (hest_disable) {
 		pr_info(HEST_PFX "Table parsing disabled.\n");
 		return;
 	}
 
+	if (acpi_disabled)
+		goto err;
+
 	status = acpi_get_table(ACPI_SIG_HEST, 0,
 				(struct acpi_table_header **)&hest_tab);
 	if (status == AE_NOT_FOUND) {

