Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab0FJRxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 13:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab0FJRxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 13:53:36 -0400
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] ipmi: Make sure drivers were registered before unregistering them
Date: Thu, 10 Jun 2010 13:53:26 -0400
Message-Id: <1276192406-3612-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipmi code will never register a PCI or Open Firmware driver if
a hardcoded device is provided by the user. This can cause us to attempt
to unregister a driver that was never registered, resulting in an oops.
Keep track of registration in order to avoid this.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 35603dd..311f85b 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -302,6 +302,12 @@ struct smi_info {
 
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
+#ifdef CONFIG_PCI
+static int pci_registered;
+#endif
+#ifdef CONFIG_PPC_OF
+static int of_registered;
+#endif
 
 static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
 static int num_max_busy_us;
@@ -3314,6 +3320,8 @@ static __devinit int init_ipmi_si(void)
 	rv = pci_register_driver(&ipmi_pci_driver);
 	if (rv)
 		printk(KERN_ERR PFX "Unable to register PCI driver: %d\n", rv);
+	else
+		pci_registered = 1;
 #endif
 
 #ifdef CONFIG_ACPI
@@ -3330,6 +3338,7 @@ static __devinit int init_ipmi_si(void)
 
 #ifdef CONFIG_PPC_OF
 	of_register_platform_driver(&ipmi_of_platform_driver);
+	of_registered = 1;
 #endif
 
 	/* We prefer devices with interrupts, but in the case of a machine
@@ -3383,11 +3392,13 @@ static __devinit int init_ipmi_si(void)
 	if (unload_when_empty && list_empty(&smi_infos)) {
 		mutex_unlock(&smi_infos_lock);
 #ifdef CONFIG_PCI
-		pci_unregister_driver(&ipmi_pci_driver);
+		if (pci_registered)
+			pci_unregister_driver(&ipmi_pci_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
-		of_unregister_platform_driver(&ipmi_of_platform_driver);
+		if (of_registered)
+			of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 		driver_unregister(&ipmi_driver.driver);
 		printk(KERN_WARNING PFX
@@ -3478,14 +3489,16 @@ static __exit void cleanup_ipmi_si(void)
 		return;
 
 #ifdef CONFIG_PCI
-	pci_unregister_driver(&ipmi_pci_driver);
+	if (pci_registered)
+		pci_unregister_driver(&ipmi_pci_driver);
 #endif
 #ifdef CONFIG_ACPI
 	pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
-	of_unregister_platform_driver(&ipmi_of_platform_driver);
+	if (of_registered)
+		of_unregister_platform_driver(&ipmi_of_platform_driver);
 #endif
 
 	mutex_lock(&smi_infos_lock);
-- 
1.7.0.1

