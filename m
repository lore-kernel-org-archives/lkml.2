Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526Ab2KBLEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 07:04:14 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:23915 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755608Ab2KBLEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 07:04:13 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>, davem@davemloft.net
Cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        software@gaisler.com, sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of/address: sparc: Declare of_address_to_resource() as an extern function for sparc again
Date: Fri,  2 Nov 2012 12:03:56 +0100
Message-Id: <1351854236-14230-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug-fix makes sure that of_address_to_resource is defined extern for sparc
so that the sparc-specific implementation of of_address_to_resource() is once
again used when including include/linux/of_address.h in a sparc context. A
number of drivers in mainline relies on this function working for sparc.

The bug was introduced in a850a7554442f08d3e910c6eeb4ee216868dda1e, "of/address:
add empty static inlines for !CONFIG_OF". Contrary to that commit title, the
static inlines are added for !CONFIG_OF_ADRESS, and CONFIG_OF_ADRESS is never
defined for sparc. This is good behavior for the other functions in
include/linux/of_address.h, as the extern functions defined in
drivers/of/address.c only gets linked when OF_ADDRESS is configured. However,
for of_address_to_resource is that there exists a sparc-specific implementation
in arch/sparc/arch/sparc/kernel/of_device_common.c

A similar solution is already in place for irq_of_parse_and_map() in
include/linux/of_irq.h.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 include/linux/of_address.h |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index a1984dd..66adde9 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -4,11 +4,24 @@
 #include <linux/errno.h>
 #include <linux/of.h>
 
+/* of_address_to_resource() is used by all OF enabled platforms; but SPARC
+ * implements it differently. However, the prototype is the same for all,
+ * so declare it here for sparc as well as when CONFIG_OF_ADDRESS is set.
+ */
+#if defined(CONFIG_OF_ADDRESS) || defined(CONFIG_SPARC)
+extern int of_address_to_resource(struct device_node *dev, int index,
+				  struct resource *r);
+#else
+static inline int of_address_to_resource(struct device_node *dev, int index,
+					 struct resource *r)
+{
+	return -EINVAL;
+}
+#endif
+
 #ifdef CONFIG_OF_ADDRESS
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern bool of_can_translate_address(struct device_node *dev);
-extern int of_address_to_resource(struct device_node *dev, int index,
-				  struct resource *r);
 extern struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
@@ -28,11 +41,6 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #endif
 
 #else /* CONFIG_OF_ADDRESS */
-static inline int of_address_to_resource(struct device_node *dev, int index,
-					 struct resource *r)
-{
-	return -EINVAL;
-}
 static inline struct device_node *of_find_matching_node_by_address(
 					struct device_node *from,
 					const struct of_device_id *matches,
-- 
1.7.0.4

