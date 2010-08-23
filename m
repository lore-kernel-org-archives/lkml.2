Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0HWPol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:44:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54920 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0HWPok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:44:40 -0400
From: Partha Basak <p-basak2@ti.com>
To: linux-kernel@vger.kernel.org
Cc: "Basak, Partha" <p-basak2@ti.com>, Charulatha V <charu@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] OMAP: HWMOD: Handle opt clocks using clk_add_alias
Date: Mon, 23 Aug 2010 21:14:29 +0530
Message-Id: <1282578269-8835-1-git-send-email-p-basak2@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Basak, Partha <p-basak2@ti.com>

For every optional clock present per hwmod per omap-device, this function
adds an entry in the clocks list of the form <dev-id=dev_name, con-id=role>,
if an entry is already present in the list of the form <dev-id=NULL, con-id=role>.

The function is called from within the framework inside omap_device_build_ss(),
after omap_device_register.

This allows drivers to get a pointer to its optional clocks based on its role
by calling clk_get(<dev*>, <role>).

Link to discussions related to this patch:
http://www.spinics.net/lists/linux-omap/msg34809.html

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Basak, Partha <p-basak2@ti.com>
Signed-off-by: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>

Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
---
 arch/arm/plat-omap/omap_device.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

Index: linux-omap-pm/arch/arm/plat-omap/omap_device.c
===================================================================
--- linux-omap-pm.orig/arch/arm/plat-omap/omap_device.c	2010-08-18 02:48:30.789079550 +0530
+++ linux-omap-pm/arch/arm/plat-omap/omap_device.c	2010-08-24 07:19:43.637080138 +0530
@@ -82,6 +82,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 
 #include <plat/omap_device.h>
 #include <plat/omap_hwmod.h>
@@ -243,7 +244,6 @@ static inline struct omap_device *_find_
 	return container_of(pdev, struct omap_device, pdev);
 }
 
-
 /* Public functions for use by core code */
 
 /**
@@ -271,6 +271,47 @@ int omap_device_count_resources(struct o
 }
 
 /**
+ * omap_device_add_opt_clk_alias - Add alias for optional clocks in the
+ * clocks list.
+ *
+ * @od: struct omap_device *od
+ *
+ * For every optional clock present per hwmod per omap-device, this function
+ * adds an entry in the clocks list of the form <dev-id=dev_name, con-id=role>
+ * if an entry is already present in it with the form <dev-id=NULL,con-id=role>
+ *
+ * The function is called from inside omap_device_build_ss(),
+ * after omap_device_register.
+ *
+ * This allows drivers to get a pointer to its optional clocks based on its role
+ * by calling clk_get(<dev*>, <role>).
+ */
+
+static void omap_device_add_opt_clk_alias(struct omap_device *od)
+{
+	int i, j;
+	struct omap_hwmod_opt_clk *oc;
+	struct omap_hwmod *oh;
+
+	for (i = 0, oh = *od->hwmods; i < od->hwmods_cnt; i++, oh++)
+		/* Add Clock alias for all optional clocks*/
+		for (j = oh->opt_clks_cnt, oc = oh->opt_clks;
+			j > 0; j--, oc++) {
+			if ((oc->_clk) &&
+			(IS_ERR(clk_get(&od->pdev.dev, oc->role)))) {
+				int ret;
+
+				ret = clk_add_alias(oc->role,
+					dev_name(&od->pdev.dev),
+					(char *)oc->clk, NULL);
+				if (ret)
+					dev_err(&od->pdev.dev, "omap_device:\
+					clk_add_alias for %s failed\n",
+					oc->role);
+			}
+		}
+}
+/**
  * omap_device_fill_resources - fill in array of struct resource
  * @od: struct omap_device *
  * @res: pointer to an array of struct resource to be filled in
@@ -424,6 +465,12 @@ struct omap_device *omap_device_build_ss
 	for (i = 0; i < oh_cnt; i++)
 		hwmods[i]->od = od;
 
+	/*
+	 * Add Clock alias for all optional
+	 * clocks present in the hwmod
+	 */
+	omap_device_add_opt_clk_alias(od);
+
 	if (ret)
 		goto odbs_exit4;
 
