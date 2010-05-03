Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab0ECNh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:37:59 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:36155 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0ECNh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:37:58 -0400
Date: Mon, 03 May 2010 08:37:45 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 7/8] ipmi: Attempt to register multiple SIs of the same type
Message-id: <20100503133745.GG8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Some odd systems may have multiple BMCs, and we want to be able to support
them. Let's make the assumption that if a system legitimately has multiple
BMCs then each BMC's SI will be of the same type, and also that we won't
see multiple SIs of the same type unless we have multiple BMCs. If these
hold true then we should register all SIs of the same type.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -3278,6 +3278,7 @@ static __devinit int init_ipmi_si(void)
 	char *str;
 	int  rv;
 	struct smi_info *e;
+	enum ipmi_addr_src type = SI_INVALID;
 
 	if (initialized)
 		return 0;
@@ -3344,30 +3345,43 @@ static __devinit int init_ipmi_si(void)
 	of_register_platform_driver(&ipmi_of_platform_driver);
 #endif
 
-	/* Try to register something with interrupts first */
+	/* We prefer devices with interrupts, but in the case of a machine
+	   with multiple BMCs we assume that there will be several instances
+	   of a given type so if we succeed in registering a type then also
+	   try to register everything else of the same type */
 
 	mutex_lock(&smi_infos_lock);
 	list_for_each_entry(e, &smi_infos, link) {
-		if (e->irq) {
+		/* Try to register a device if it has an IRQ and we either
+		   haven't successfully registered a device yet or this
+		   device has the same type as one we successfully registered */
+		if (e->irq && (!type || e->addr_source == type)) {
 			if (!try_smi_init(e)) {
-				mutex_unlock(&smi_infos_lock);
-				return 0;
+				type = e->addr_source;
 			}
 		}
 	}
 
+	/* type will only have been set if we successfully registered an si */
+	if (type) {
+		mutex_unlock(&smi_infos_lock);
+		return 0;
+	}
+
 	/* Fall back to the preferred device */
 
 	list_for_each_entry(e, &smi_infos, link) {
-		if (!e->irq) {
+		if (!e->irq && (!type || e->addr_source == type)) {
 			if (!try_smi_init(e)) {
-				mutex_unlock(&smi_infos_lock);
-				return 0;
+				type = e->addr_source;
 			}
 		}
 	}
 	mutex_unlock(&smi_infos_lock);
 
+	if (type)
+		return 0;
+
 	if (si_trydefaults) {
 		mutex_lock(&smi_infos_lock);
 		if (list_empty(&smi_infos)) {
