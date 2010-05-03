Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0ECNfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:35:05 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:50033 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0ECNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:35:03 -0400
Date: Mon, 03 May 2010 08:34:50 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/8] ipmi: Only register one si per bmc
Message-id: <20100503133450.GC8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Only register one si per bmc. Use any user-provided devices first, followed
by the first device with an irq, followed by the first device discovered.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -3300,6 +3300,14 @@ static __devinit int init_ipmi_si(void)
 
 	hardcode_find_bmc();
 
+	/* If the user gave us a device, they presumably want us to use it */
+	mutex_lock(&smi_infos_lock);
+	if (!list_empty(&smi_infos)) {
+		mutex_unlock(&smi_infos_lock);
+		return 0;
+	}
+	mutex_unlock(&smi_infos_lock);
+
 #ifdef CONFIG_DMI
 	dmi_find_bmc();
 #endif
@@ -3323,10 +3331,27 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
+	/* Try to register something with interrupts first */
+
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry(e, &smi_infos, link) {
-		if (!e->si_sm)
-			try_smi_init(e);
+		if (e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
+	}
+
+	/* Fall back to the preferred device */
+
+	list_for_each_entry(e, &smi_infos, link) {
+		if (!e->irq) {
+			if (!try_smi_init(e)) {
+				mutex_unlock(&smi_infos_lock);
+				return 0;
+			}
+		}
 	}
 	mutex_unlock(&smi_infos_lock);
 
