Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0GLPsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:48:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37158 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0GLPsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:48:41 -0400
Message-ID: <4C3B3956.3020205@austin.ibm.com>
Date: Mon, 12 Jul 2010 10:48:38 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH 7/7] Enable multiple memory sections per sysfs memory directory
 for powerpc/pseries
References: <4C3B3446.5090302@austin.ibm.com>
In-Reply-To: <4C3B3446.5090302@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the powerpc/pseries code to initialize
the memory sysfs directory creation to create sysfs directories
that each cover an LMB's worth of memory.

Signed-off-by; Nathan Fontenot <nfont@austin.ibm.ocm>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   66 +++++++++++++++++++-----
 1 file changed, 53 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/hotplug-memory.c	2010-07-09 14:36:52.000000000 -0500
+++ linux-2.6/arch/powerpc/platforms/pseries/hotplug-memory.c	2010-07-09 14:38:25.000000000 -0500
@@ -17,6 +17,54 @@
 #include <asm/pSeries_reconfig.h>
 #include <asm/sparsemem.h>
 
+static u32 get_lmb_size(void)
+{
+	struct device_node *np;
+	unsigned int lmb_size = 0;
+
+	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (np) {
+		const unsigned int *size;
+
+		size = of_get_property(np, "ibm,lmb-size", NULL);
+		lmb_size = size ? *size : 0;
+
+		of_node_put(np);
+	} else {
+		const unsigned int *regs;
+
+		np = of_find_node_by_path("/memory@0");
+		if (np) {
+			regs = of_get_property(np, "reg", NULL);
+			lmb_size = regs ? regs[3] : 0;
+			of_node_put(np);
+		}
+
+		if (lmb_size) {
+			/* We now know the size of memory@0, use this to find
+			 * the first lmb and get its size.
+			 */
+			char buf[64];
+
+			sprintf(buf, "/memory@%x", lmb_size);
+			np = of_find_node_by_path(buf);
+			if (np) {
+				regs = of_get_property(np, "reg", NULL);
+				lmb_size = regs ? regs[3] : 0;
+				of_node_put(np);
+			} else
+				lmb_size = 0;
+		}
+	}
+
+	return lmb_size;
+}
+
+u32 memory_block_size(void)
+{
+	return get_lmb_size();
+}
+
 static int pseries_remove_lmb(unsigned long base, unsigned int lmb_size)
 {
 	unsigned long start, start_pfn;
@@ -127,30 +175,22 @@
 
 static int pseries_drconf_memory(unsigned long *base, unsigned int action)
 {
-	struct device_node *np;
-	const unsigned long *lmb_size;
+	unsigned long lmb_size;
 	int rc;
 
-	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
-	if (!np)
+	lmb_size = get_lmb_size();
+	if (!lmb_size)
 		return -EINVAL;
 
-	lmb_size = of_get_property(np, "ibm,lmb-size", NULL);
-	if (!lmb_size) {
-		of_node_put(np);
-		return -EINVAL;
-	}
-
 	if (action == PSERIES_DRCONF_MEM_ADD) {
-		rc = lmb_add(*base, *lmb_size);
+		rc = lmb_add(*base, lmb_size);
 		rc = (rc < 0) ? -EINVAL : 0;
 	} else if (action == PSERIES_DRCONF_MEM_REMOVE) {
-		rc = pseries_remove_lmb(*base, *lmb_size);
+		rc = pseries_remove_lmb(*base, lmb_size);
 	} else {
 		rc = -EINVAL;
 	}
 
-	of_node_put(np);
 	return rc;
 }
