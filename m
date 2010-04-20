Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0DTSlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0DTSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:41:30 -0400
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] ipmi: Change device discovery order
Date: Tue, 20 Apr 2010 14:40:28 -0400
Message-Id: <1271788828-10231-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1271788828-10231-2-git-send-email-mjg@redhat.com>
References: <1271788828-10231-1-git-send-email-mjg@redhat.com>
 <1271788828-10231-2-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipmi spec provides an ordering for si discovery. Change the driver
to match.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 95af023..a36cab1 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3301,23 +3301,24 @@ static __devinit int init_ipmi_si(void)
 	}
 	mutex_unlock(&smi_infos_lock);
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
+#ifdef CONFIG_PCI
+	rv = pci_register_driver(&ipmi_pci_driver);
+	if (rv)
+		printk(KERN_ERR
+		       "init_ipmi_si: Unable to register PCI driver: %d\n",
+		       rv);
 #endif
 
 #ifdef CONFIG_ACPI
-	spmi_find_bmc();
+	pnp_register_driver(&ipmi_pnp_driver);
 #endif
+
 #ifdef CONFIG_ACPI
-	pnp_register_driver(&ipmi_pnp_driver);
+	spmi_find_bmc();
 #endif
 
-#ifdef CONFIG_PCI
-	rv = pci_register_driver(&ipmi_pci_driver);
-	if (rv)
-		printk(KERN_ERR
-		       "init_ipmi_si: Unable to register PCI driver: %d\n",
-		       rv);
+#ifdef CONFIG_DMI
+	dmi_find_bmc();
 #endif
 
 #ifdef CONFIG_PPC_OF
-- 
1.6.5.2

