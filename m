Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab0ECNfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:35:40 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:50467 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0ECNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:35:37 -0400
Date: Mon, 03 May 2010 08:35:36 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/8] ipmi: Change device discovery order
Message-id: <20100503133536.GD8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

The ipmi spec provides an ordering for si discovery. Change the driver
to match, with the exception of preferring smbios to SPMI as HPs (at least)
contain accurate information in the former but not the latter.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -3308,17 +3308,6 @@ static __devinit int init_ipmi_si(void)
 	}
 	mutex_unlock(&smi_infos_lock);
 
-#ifdef CONFIG_DMI
-	dmi_find_bmc();
-#endif
-
-#ifdef CONFIG_ACPI
-	spmi_find_bmc();
-#endif
-#ifdef CONFIG_ACPI
-	pnp_register_driver(&ipmi_pnp_driver);
-#endif
-
 #ifdef CONFIG_PCI
 	rv = pci_register_driver(&ipmi_pci_driver);
 	if (rv)
@@ -3327,6 +3316,18 @@ static __devinit int init_ipmi_si(void)
 		       rv);
 #endif
 
+#ifdef CONFIG_ACPI
+	pnp_register_driver(&ipmi_pnp_driver);
+#endif
+
+#ifdef CONFIG_DMI
+	dmi_find_bmc();
+#endif
+
+#ifdef CONFIG_ACPI
+	spmi_find_bmc();
+#endif
+
 #ifdef CONFIG_PPC_OF
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
