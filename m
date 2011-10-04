Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab1JDOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:34:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:56812 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1JDOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:34:20 -0400
Date: Tue, 4 Oct 2011 16:34:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>, Len Brown <len.brown@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: [PATCH RFC] x86: hpet: Disable HPET MSI on Lenovo W510
Message-ID: <alpine.LFD.2.02.1110041519220.18778@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86: hpet: Disable MSI on Lenovo W510
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 20:03:37 +0200

MSI based per cpu timers lose interrupts when intel_idle() is enabled
independent of the effective c-state. With idle=poll the problem
cannot be observed.

We have no idea yet, whether this is a W510 specific issue or a
general chipset oddity. Blacklist the known problem machine.

Reported-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/dmi.h>
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
@@ -566,6 +567,29 @@ static void init_one_hpet_msi_clockevent
 #define RESERVE_TIMERS 0
 #endif
 
+static int __init dmi_disable_hpet_msi(const struct dmi_system_id *d)
+{
+	hpet_msi_disable = 1;
+}
+
+static struct dmi_system_id __initdata dmi_hpet_table[] = {
+	/*
+	 * MSI based per cpu timers lose interrupts when intel_idle()
+	 * is enabled - independent of the c-state. With idle=poll the
+	 * problem cannot be observed. We have no idea yet, whether
+	 * this is a W510 specific issue or a general chipset oddity.
+	 */
+	{
+	 .callback = dmi_disable_hpet_msi,
+	 .ident = "Lenovo W510",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
+		     },
+	 },
+	{}
+};
+
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
 	unsigned int id;
@@ -573,6 +597,8 @@ static void hpet_msi_capability_lookup(u
 	unsigned int num_timers_used = 0;
 	int i;
 
+	dmi_check_system(dmi_hpet_table);
+
 	if (hpet_msi_disable)
 		return;
 
