Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab2GPVbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:31:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab2GPV2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:28:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 14/14] ARM: shmobile: Add support for storing PM domain information in DTs
Date: Mon, 16 Jul 2012 23:32:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207052217.48086.rjw@sisk.pl> <201207162315.49073.rjw@sisk.pl>
In-Reply-To: <201207162315.49073.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207162332.16328.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Allow the common power management support code for Renesas SoCs to
read the names of the power domains that platform devices belong to
from a device tree describing the platform.

The name of the power domain is stored within the given device's DT
node as a case-sensitive string attribute of the name
"renesas,pmdomain".  The values of those attributes are read by the
platform code throuch a platform bus type notifier which is executed
right after adding the device to the device hierarchy and are then
used for adding devices to the given PM domains with the help of
pm_genpd_name_add_device().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-rmobile.c |   92 ++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 9 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-rmobile.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-rmobile.c
+++ linux/arch/arm/mach-shmobile/pm-rmobile.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2012  Renesas Solutions Corp.
  * Copyright (C) 2012  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+ * Copyright (C) 2012  Rafael J. Wysocki <rjw@sisk.pl>
  *
  * based on pm-sh7372.c
  *  Copyright (C) 2011 Magnus Damm
@@ -13,7 +14,9 @@
  */
 #include <linux/console.h>
 #include <linux/delay.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
+#include <linux/of_platform.h>
 #include <linux/pm.h>
 #include <linux/pm_clock.h>
 #include <asm/io.h>
@@ -149,21 +152,92 @@ static void rmobile_init_pm_domain(struc
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
-void rmobile_init_domains(struct rmobile_pm_domain domains[], int num)
-{
-	int j;
-
-	for (j = 0; j < num; j++)
-		rmobile_init_pm_domain(&domains[j]);
-}
-
 void rmobile_add_device_to_domain(const char *domain_name,
 				 struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	int ret;
 
-	pm_genpd_name_add_device(domain_name, dev);
+	do
+		ret = pm_genpd_name_add_device(domain_name, dev);
+	while (ret == -EAGAIN);
 	if (pm_clk_no_clocks(dev))
 		pm_clk_add(dev, NULL);
 }
+
+#ifdef CONFIG_USE_OF
+
+static void rmobile_read_domain_from_dt(struct device *dev)
+{
+	const char *domain_name;
+	int ret;
+
+	ret = of_property_read_string(dev->of_node, "renesas,pmdomain",
+				      &domain_name);
+	if (!ret)
+		rmobile_add_device_to_domain(domain_name,
+					     to_platform_device(dev));
+}
+
+static void rmobile_remove_from_domain(struct device *dev)
+{
+	struct generic_pm_domain *genpd = dev_to_genpd(dev);
+	int ret;
+
+	/*
+	 * The check below takes care of the situations in which the device's
+	 * pm_domain pointer contains a valid address, but that is not an
+	 * address of a generic PM domain object.
+	 */
+	if (pm_genpd_present(genpd)) {
+		do
+			ret = pm_genpd_remove_device(genpd, dev);
+		while (ret == -EAGAIN);
+	}
+}
+
+static int rmobile_pm_notifier_call(struct notifier_block *nb,
+				    unsigned long event, void *data)
+{
+	struct device *dev = data;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		if (dev->of_node)
+			rmobile_read_domain_from_dt(dev);
+
+		break;
+
+	case BUS_NOTIFY_DEL_DEVICE:
+		rmobile_remove_from_domain(dev);
+
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block platform_nb = {
+	.notifier_call = rmobile_pm_notifier_call,
+};
+
+static void rmobile_add_bus_notifier_for_domains(void)
+{
+	bus_register_notifier(&platform_bus_type, &platform_nb);
+}
+
+#else
+
+static inline void rmobile_add_bus_notifier_for_domains(void) {}
+
+#endif /* CONFIG_USE_OF */
+
+void rmobile_init_domains(struct rmobile_pm_domain domains[], int num)
+{
+	int j;
+
+	for (j = 0; j < num; j++)
+		rmobile_init_pm_domain(&domains[j]);
+
+	rmobile_add_bus_notifier_for_domains();
+}
 #endif /* CONFIG_PM */

