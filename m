Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2BXQaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:30:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42863 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2BXQ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:29:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.136.100 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org
Subject: [PATCH] irq_domain/mips: Allow irq_domain on MIPS
Date: Fri, 24 Feb 2012 09:29:55 -0700
Message-Id: <1330100995-19823-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes IRQ_DOMAIN usable on MIPS.  It uses an ugly workaround
to preserve current behaviour so that MIPS has time to add irq_domain
registration to the irq controller drivers.  The workaround will be
removed in Linux v3.6

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org
---

This applies on top of linux-next or my irqdomain/next branch.  Ralf, with
your ack I should merge it via that tree.

git://git.secretlab.ca/git/linux-2.6 irqdomain/next

 arch/mips/Kconfig           |    1 +
 arch/mips/include/asm/irq.h |    5 +----
 arch/mips/kernel/prom.c     |   14 --------------
 kernel/irq/irqdomain.c      |   12 ++++++++++++
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5ab6e89..edbbae1 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -2327,6 +2327,7 @@ config USE_OF
 	bool "Flattened Device Tree support"
 	select OF
 	select OF_EARLY_FLATTREE
+	select IRQ_DOMAIN
 	help
 	  Include support for flattened device tree machine descriptions.
 
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 2354c87..fb698dc 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -11,15 +11,12 @@
 
 #include <linux/linkage.h>
 #include <linux/smp.h>
+#include <linux/irqdomain.h>
 
 #include <asm/mipsmtregs.h>
 
 #include <irq.h>
 
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-}
-
 #ifdef CONFIG_I8259
 static inline int irq_canonicalize(int irq)
 {
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 6b8b420..558b539 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -60,20 +60,6 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 }
 #endif
 
-/*
- * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
- *
- * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
- * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
- * supported.
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	return intspec[0];
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
 void __init early_init_devtree(void *params)
 {
 	/* Setup flat device-tree pointer */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 25a498e..af48e59 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -411,6 +411,18 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 
 	domain = controller ? irq_find_host(controller) : irq_default_domain;
 	if (!domain) {
+#ifdef CONFIG_MIPS
+		/*
+		 * Workaround to avoid breaking interrupt controller drivers
+		 * that don't yet register an irq_domain.  This is temporary
+		 * code. ~~~gcl, Feb 24, 2012
+		 *
+		 * Scheduled for removal in Linux v3.6.  That should be enough
+		 * time.
+		 */
+		if (intsize > 0)
+			return intspec[0];
+#endif
 		printk(KERN_WARNING "irq: no irq domain found for %s !\n",
 		       controller->full_name);
 		return 0;
-- 
1.7.9

