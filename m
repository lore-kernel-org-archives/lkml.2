Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab1KHLoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:44:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1KHLof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:44:35 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] of: define NO_IRQ globally when not supplied by the architecture
Date: Tue,  8 Nov 2011 11:44:26 +0000
Message-Id: <1320752666-15553-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the application of the commit below the PATA OF platform driver
may now be built on x86 systems:

  ata: Make pata_of_platform.c compile again and work on non-PPC platforms

This leads to the following build failure on 32bit x86 builds:

  .../drivers/ata/pata_of_platform.c: In function 'pata_of_platform_probe':
  .../drivers/ata/pata_of_platform.c:55: error: 'NO_IRQ' undeclared
					(first use in this function)

This occurs because x86 does not supply a definition for NO_IRQ.
However if we examine drivers/of/irq.c we already supply a default value
for NO_IRQ where not specified by the architecture.  Fix the build failure
by pulling this default value up to include/linux/of_irq.h.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/of/irq.c       |    5 -----
 include/linux/of_irq.h |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 6d3dd39..0208e27 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -26,11 +26,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 
-/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
-#ifndef NO_IRQ
-#define NO_IRQ 0
-#endif
-
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index d0307ee..8b2369f 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -77,6 +77,11 @@ extern struct device_node *of_irq_find_parent(struct device_node *child);
 
 extern void of_irq_init(const struct of_device_id *matches);
 
+/* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
+
 #endif /* CONFIG_OF_IRQ */
 #endif /* CONFIG_OF */
 #endif /* __OF_IRQ_H */
-- 
1.7.5.4

