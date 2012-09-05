Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab2IES3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:29:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54600 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2IES3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:29:31 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Aneesh V <aneesh@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] memory: fix build when CONFIG_OF && !CONFIG_DDR
Date: Wed,  5 Sep 2012 12:29:23 -0600
Message-Id: <1346869763-11798-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit e6b42eb "memory: emif: add device tree support to emif driver"
added drivers/memory/of_memory.c, which references tables defined in
lib/jedec_ddr_data.c. of_memory.c is compiled when CONFIG_OF, whereas
jedec_ddr_data.c is compiled when CONFIG_DDR. This breaks the build
when CONFIG_OF is defined but not CONFIG_DDR:

drivers/built-in.o: In function `of_get_ddr_timings':
drivers/memory/of_memory.c:138: undefined reference to `lpddr2_jedec_timings'
drivers/built-in.o: In function `of_get_min_tck':
drivers/memory/of_memory.c:62: undefined reference to `lpddr2_jedec_min_tck'
make: *** [vmlinux] Error 1

To solve this, only compile of_memory.c when CONFIG_OF && CONFIG_DDR,
otherwise, stub out the functions.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/memory/Makefile    |    2 ++
 drivers/memory/of_memory.h |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index cd8486b..9cce5d7 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -2,7 +2,9 @@
 # Makefile for memory devices
 #
 
+ifeq ($(CONFIG_DDR),y)
 obj-$(CONFIG_OF)		+= of_memory.o
+endif
 obj-$(CONFIG_TI_EMIF)		+= emif.o
 obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
 obj-$(CONFIG_TEGRA30_MC)	+= tegra30-mc.o
diff --git a/drivers/memory/of_memory.h b/drivers/memory/of_memory.h
index 20b496e..ef2514f 100644
--- a/drivers/memory/of_memory.h
+++ b/drivers/memory/of_memory.h
@@ -12,7 +12,7 @@
 #ifndef __LINUX_MEMORY_OF_REG_H
 #define __LINUX_MEMORY_OF_REG_H
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_DDR)
 extern const struct lpddr2_min_tck *of_get_min_tck(struct device_node *np,
 		struct device *dev);
 extern const struct lpddr2_timings
@@ -31,6 +31,6 @@ static inline const struct lpddr2_timings
 {
 	return NULL;
 }
-#endif /* CONFIG_OF */
+#endif /* CONFIG_OF && CONFIG_DDR */
 
 #endif /* __LINUX_MEMORY_OF_REG_ */
-- 
1.7.0.4

