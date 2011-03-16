Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CPV1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:27:51 -0400
Received: from kroah.org ([198.145.64.141]:42599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab1CPVLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/50] memory hotplug: Define memory_block_size_bytes for powerpc/pseries
Date: Wed, 16 Mar 2011 14:10:53 -0700
Message-Id: <1300309888-5028-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Define a version of memory_block_size_bytes() for powerpc/pseries such that
a memory block spans an entire lmb.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   66 ++++++++++++++++++-----
 1 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index bc88036..33867ec 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -17,6 +17,54 @@
 #include <asm/pSeries_reconfig.h>
 #include <asm/sparsemem.h>
 
+static unsigned long get_memblock_size(void)
+{
+	struct device_node *np;
+	unsigned int memblock_size = 0;
+
+	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (np) {
+		const unsigned long *size;
+
+		size = of_get_property(np, "ibm,lmb-size", NULL);
+		memblock_size = size ? *size : 0;
+
+		of_node_put(np);
+	} else {
+		unsigned int memzero_size = 0;
+		const unsigned int *regs;
+
+		np = of_find_node_by_path("/memory@0");
+		if (np) {
+			regs = of_get_property(np, "reg", NULL);
+			memzero_size = regs ? regs[3] : 0;
+			of_node_put(np);
+		}
+
+		if (memzero_size) {
+			/* We now know the size of memory@0, use this to find
+			 * the first memoryblock and get its size.
+			 */
+			char buf[64];
+
+			sprintf(buf, "/memory@%x", memzero_size);
+			np = of_find_node_by_path(buf);
+			if (np) {
+				regs = of_get_property(np, "reg", NULL);
+				memblock_size = regs ? regs[3] : 0;
+				of_node_put(np);
+			}
+		}
+	}
+
+	return memblock_size;
+}
+
+unsigned long memory_block_size_bytes(void)
+{
+	return get_memblock_size();
+}
+
 static int pseries_remove_memblock(unsigned long base, unsigned int memblock_size)
 {
 	unsigned long start, start_pfn;
@@ -127,30 +175,22 @@ static int pseries_add_memory(struct device_node *np)
 
 static int pseries_drconf_memory(unsigned long *base, unsigned int action)
 {
-	struct device_node *np;
-	const unsigned long *lmb_size;
+	unsigned long memblock_size;
 	int rc;
 
-	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
-	if (!np)
+	memblock_size = get_memblock_size();
+	if (!memblock_size)
 		return -EINVAL;
 
-	lmb_size = of_get_property(np, "ibm,lmb-size", NULL);
-	if (!lmb_size) {
-		of_node_put(np);
-		return -EINVAL;
-	}
-
 	if (action == PSERIES_DRCONF_MEM_ADD) {
-		rc = memblock_add(*base, *lmb_size);
+		rc = memblock_add(*base, memblock_size);
 		rc = (rc < 0) ? -EINVAL : 0;
 	} else if (action == PSERIES_DRCONF_MEM_REMOVE) {
-		rc = pseries_remove_memblock(*base, *lmb_size);
+		rc = pseries_remove_memblock(*base, memblock_size);
 	} else {
 		rc = -EINVAL;
 	}
 
-	of_node_put(np);
 	return rc;
 }
 
-- 
1.7.4.1

