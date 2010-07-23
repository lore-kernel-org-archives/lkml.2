Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab0GWUCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:02:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46642 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768Ab0GWUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:02:43 -0400
Subject: [PATCH] of: remove of_default_bus_ids
To: jonas@southpole.se, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 14:02:40 -0600
Message-ID: <20100723200240.18403.83633.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Bonn <jonas@southpole.se>

This list used was by only two platforms with all other platforms defining an
own list of valid bus id's to pass to of_platform_bus_probe.  This patch:

i)   copies the default list to the two platforms that depended on it (powerpc)
ii)  remove the usage of of_default_bus_ids in of_platform_bus_probe
iii) removes the definition of the list from all architectures that defined it

Passing a NULL 'matches' parameter to of_platform_bus_probe is still valid; the
function returns no error in that case as the NULL value is equivalent to an
empty list.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
[grant.likely@secretlab.ca: added __initdata annotations, warn on and return error on missing match table, and fix whitespace errors]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/Makefile           |    2 +
 arch/microblaze/kernel/of_platform.c      |   49 -----------------------------
 arch/powerpc/kernel/of_platform.c         |   24 --------------
 arch/powerpc/platforms/cell/qpace_setup.c |   14 ++++++++
 arch/powerpc/platforms/cell/setup.c       |   14 ++++++++
 drivers/of/platform.c                     |    4 +-
 include/linux/of_platform.h               |    2 -
 7 files changed, 28 insertions(+), 81 deletions(-)
 delete mode 100644 arch/microblaze/kernel/of_platform.c

diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index 727e2cb..7fcc5f7 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -16,7 +16,7 @@ extra-y := head.o vmlinux.lds
 
 obj-y += dma.o exceptions.o \
 	hw_exception_handler.o init_task.o intc.o irq.o \
-	of_platform.o process.o prom.o prom_parse.o ptrace.o \
+	process.o prom.o prom_parse.o ptrace.o \
 	setup.o signal.o sys_microblaze.o timer.o traps.o reset.o
 
 obj-y += cpu/
diff --git a/arch/microblaze/kernel/of_platform.c b/arch/microblaze/kernel/of_platform.c
deleted file mode 100644
index 6cffadb..0000000
--- a/arch/microblaze/kernel/of_platform.c
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- *    Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corp.
- *			 <benh@kernel.crashing.org>
- *    and		 Arnd Bergmann, IBM Corp.
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version
- *  2 of the License, or (at your option) any later version.
- *
- */
-
-#undef DEBUG
-
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/pci.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/of_platform.h>
-
-#include <linux/errno.h>
-#include <linux/topology.h>
-#include <asm/atomic.h>
-
-/*
- * The list of OF IDs below is used for matching bus types in the
- * system whose devices are to be exposed as of_platform_devices.
- *
- * This is the default list valid for most platforms. This file provides
- * functions who can take an explicit list if necessary though
- *
- * The search is always performed recursively looking for children of
- * the provided device_node and recursively if such a children matches
- * a bus type in the list
- */
-
-const struct of_device_id of_default_bus_ids[] = {
-	{ .type = "soc", },
-	{ .compatible = "soc", },
-	{ .type = "plb5", },
-	{ .type = "plb4", },
-	{ .type = "opb", },
-	{ .type = "simple", },
-	{},
-};
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 760a7af..b2c363e 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -28,30 +28,6 @@
 #include <asm/ppc-pci.h>
 #include <asm/atomic.h>
 
-/*
- * The list of OF IDs below is used for matching bus types in the
- * system whose devices are to be exposed as of_platform_devices.
- *
- * This is the default list valid for most platforms. This file provides
- * functions who can take an explicit list if necessary though
- *
- * The search is always performed recursively looking for children of
- * the provided device_node and recursively if such a children matches
- * a bus type in the list
- */
-
-const struct of_device_id of_default_bus_ids[] = {
-	{ .type = "soc", },
-	{ .compatible = "soc", },
-	{ .type = "spider", },
-	{ .type = "axon", },
-	{ .type = "plb5", },
-	{ .type = "plb4", },
-	{ .type = "opb", },
-	{ .type = "ebc", },
-	{},
-};
-
 #ifdef CONFIG_PPC_OF_PLATFORM_PCI
 
 /* The probing of PCI controllers from of_platform is currently
diff --git a/arch/powerpc/platforms/cell/qpace_setup.c b/arch/powerpc/platforms/cell/qpace_setup.c
index c5ce02e..1b57490 100644
--- a/arch/powerpc/platforms/cell/qpace_setup.c
+++ b/arch/powerpc/platforms/cell/qpace_setup.c
@@ -61,12 +61,24 @@ static void qpace_progress(char *s, unsigned short hex)
 	printk("*** %04x : %s\n", hex, s ? s : "");
 }
 
+static const struct of_device_id qpace_bus_ids[] __initdata = {
+	{ .type = "soc", },
+	{ .compatible = "soc", },
+	{ .type = "spider", },
+	{ .type = "axon", },
+	{ .type = "plb5", },
+	{ .type = "plb4", },
+	{ .type = "opb", },
+	{ .type = "ebc", },
+	{},
+};
+
 static int __init qpace_publish_devices(void)
 {
 	int node;
 
 	/* Publish OF platform devices for southbridge IOs */
-	of_platform_bus_probe(NULL, NULL, NULL);
+	of_platform_bus_probe(NULL, qpace_bus_ids, NULL);
 
 	/* There is no device for the MIC memory controller, thus we create
 	 * a platform device for it to attach the EDAC driver to.
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index 50385db..6919957 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -141,6 +141,18 @@ static int __devinit cell_setup_phb(struct pci_controller *phb)
 	return 0;
 }
 
+static const struct of_device_id cell_bus_ids[] __initdata = {
+	{ .type = "soc", },
+	{ .compatible = "soc", },
+	{ .type = "spider", },
+	{ .type = "axon", },
+	{ .type = "plb5", },
+	{ .type = "plb4", },
+	{ .type = "opb", },
+	{ .type = "ebc", },
+	{},
+};
+
 static int __init cell_publish_devices(void)
 {
 	struct device_node *root = of_find_node_by_path("/");
@@ -148,7 +160,7 @@ static int __init cell_publish_devices(void)
 	int node;
 
 	/* Publish OF platform devices for southbridge IOs */
-	of_platform_bus_probe(NULL, NULL, NULL);
+	of_platform_bus_probe(NULL, cell_bus_ids, NULL);
 
 	/* On spider based blades, we need to manually create the OF
 	 * platform devices for the PCI host bridges
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9126064..94fa719 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -701,9 +701,7 @@ int of_platform_bus_probe(struct device_node *root,
 	struct platform_device *dev;
 	int rc = 0;
 
-	if (matches == NULL)
-		matches = of_default_bus_ids;
-	if (matches == OF_NO_DEEP_PROBE)
+	if (WARN_ON(!matches || matches == OF_NO_DEEP_PROBE))
 		return -EINVAL;
 	if (root == NULL)
 		root = of_find_node_by_path("/");
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index b24c5a5..4e6d989 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -19,8 +19,6 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 
-extern const struct of_device_id of_default_bus_ids[];
-
 /*
  * An of_platform_driver driver is attached to a basic of_device on
  * the "platform bus" (platform_bus_type).

