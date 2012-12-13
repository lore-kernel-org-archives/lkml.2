Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2LMSjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:39:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443Ab2LMSjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:39:12 -0500
From: Tony Camuso <tcamuso@redhat.com>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, openipmi-developer@lists.sourceforge.net,
        grant.likely@secretlab.ca, minyard@acm.org,
        Tony Camuso <tcamuso@redhat.com>,
        Robert Evans <Robert.Evans@stratus.com>,
        Jim Paradis <jparadis@redhat.com>
Subject: [PATCH] ipmi: add new kernel options to prevent automatic ipmi init
Date: Thu, 13 Dec 2012 13:40:08 -0500
Message-Id: <1355424008-20491-1-git-send-email-tcamuso@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration change building ipmi_si into the kernel precludes the
use of a custom driver that can utilize more than one KCS interface,
multiple IPMBs, and more than one BMC. This capability is important for
fault-tolerant systems.

Even if the kernel option ipmi_si.trydefaults=0 is specified, ipmi_si
discovers and claims one of the KCS interfaces on a Stratus server.
The inability to now prevent the kernel from managing this device is a
regression from previous kernels. The regression breaks a capability
fault-tolerant vendors have relied upon.

To support both ACPI opregion access and the need to avoid activation
of ipmi_si on some platforms, we've added two new kernel options,
ipmi_si.tryacpi and ipmi_si.trydmi be added to prevent ipmi_si from
initializing when these options are set to 0 on the kernel command line.
With these options at the default value of 1, ipmi_si init proceeds
according to the kernel default.

Tested-by: Jim Paradis <jparadis@redhat.com>
Signed-off-by: Robert Evans <Robert.Evans@stratus.com>
Signed-off-by: Jim Paradis <jparadis@redhat.com>
Signed-off-by: Tony Camuso <tcamuso@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 20ab5b3..0a441cf 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1208,6 +1208,12 @@ static int smi_num; /* Used to sequence the SMIs */
 #define DEFAULT_REGSPACING	1
 #define DEFAULT_REGSIZE		1
 
+#ifdef CONFIG_ACPI
+static int           si_tryacpi = 1;
+#endif
+#ifdef CONFIG_DMI
+static int           si_trydmi = 1;
+#endif
 static bool          si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
@@ -1238,6 +1244,16 @@ MODULE_PARM_DESC(hotmod, "Add and remove interfaces.  See"
 		 " Documentation/IPMI.txt in the kernel sources for the"
 		 " gory details.");
 
+#ifdef CONFIG_ACPI
+module_param_named(tryacpi, si_tryacpi, bool, 0);
+MODULE_PARM_DESC(tryacpi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via ACPI");
+#endif
+#ifdef CONFIG_DMI
+module_param_named(trydmi, si_trydmi, bool, 0);
+MODULE_PARM_DESC(trydmi, "Setting this to zero will disable the"
+		 " default scan of the interfaces identified via DMI");
+#endif
 module_param_named(trydefaults, si_trydefaults, bool, 0);
 MODULE_PARM_DESC(trydefaults, "Setting this to 'false' will disable the"
 		 " default scan of the KCS and SMIC interface at the standard"
@@ -3408,16 +3424,20 @@ static int init_ipmi_si(void)
 #endif
 
 #ifdef CONFIG_ACPI
-	pnp_register_driver(&ipmi_pnp_driver);
-	pnp_registered = 1;
+	if (si_tryacpi) {
+		pnp_register_driver(&ipmi_pnp_driver);
+		pnp_registered = 1;
+	}
 #endif
 
 #ifdef CONFIG_DMI
-	dmi_find_bmc();
+	if (si_trydmi)
+		dmi_find_bmc();
 #endif
 
 #ifdef CONFIG_ACPI
-	spmi_find_bmc();
+	if (si_tryacpi)
+		spmi_find_bmc();
 #endif
 
 	/* We prefer devices with interrupts, but in the case of a machine
-- 
1.7.11.7

