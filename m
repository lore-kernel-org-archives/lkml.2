Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2KWLYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:24:53 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:24561 "HELO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753800Ab2KWLYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:24:51 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: davem@davemloft.net
Cc: sam@ravnborg.org, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: [PATCH] of/address: sparc: Declare of_iomap as an extern function for sparc again
Date: Fri, 23 Nov 2012 12:24:09 +0100
Message-Id: <1353669849-23697-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug-fix makes sure that of_iomap is defined extern for sparc so that the
sparc-specific implementation of_iomap is once again used when including
include/linux/of_address.h in a sparc context. OF_GPIO that is now available for
sparc relies on this.

The bug was inadvertently introduced in a850a75, "of/address: add empty static
inlines for !CONFIG_OF", that added a static dummy inline for of_iomap when
!CONFIG_OF_ADDRESS. However, CONFIG_OF_ADDRESS is never defined for sparc, but
there is a sparc-specific implementation /arch/sparc/kernel/of_device_common.c.

This fix takes the same approach as 0bce04b that solved the equivalent problem
for of_address_to_resource.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 arch/sparc/include/asm/prom.h |    5 ++++-
 include/linux/of_address.h    |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index f930031..67c6257 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -63,10 +63,13 @@ extern char *of_console_options;
 extern void irq_trans_init(struct device_node *dp);
 extern char *build_path_component(struct device_node *dp);
 
-/* SPARC has a local implementation */
+/* SPARC has local implementations */
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 #define of_address_to_resource of_address_to_resource
 
+void __iomem *of_iomap(struct device_node *node, int index);
+#define of_iomap of_iomap
+
 #endif /* __KERNEL__ */
 #endif /* _SPARC_PROM_H */
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index e20e3af..0506eb5 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -42,10 +42,12 @@ static inline struct device_node *of_find_matching_node_by_address(
 {
 	return NULL;
 }
+#ifndef of_iomap
 static inline void __iomem *of_iomap(struct device_node *device, int index)
 {
 	return NULL;
 }
+#endif
 static inline const __be32 *of_get_address(struct device_node *dev, int index,
 					u64 *size, unsigned int *flags)
 {
-- 
1.7.0.4

