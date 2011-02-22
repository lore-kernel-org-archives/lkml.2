Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1BVVAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:00:55 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13993 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1BVU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:20 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH 04/10] MIPS: Octeon: Add a irq_create_of_mapping() implementation.
Date: Tue, 22 Feb 2011 12:57:48 -0800
Message-Id: <1298408274-20856-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 22 Feb 2011 20:58:20.0191 (UTC) FILETIME=[3C4EA2F0:01CBD2D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for Octeon to use the Device Tree.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/cavium-octeon/octeon-irq.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index b365710..b0a9261 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -8,7 +8,9 @@
 
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
+#include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/of_irq.h>
 #include <linux/irq.h>
 #include <linux/smp.h>
 
@@ -64,6 +66,29 @@ static void __init octeon_irq_set_ciu_mapping(int irq, int line, int bit,
 	octeon_irq_ciu_to_irq[line][bit] = irq;
 }
 
+/*
+ * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
+ *
+ * Octeon irq maps are a pair of indexes.  The first selects either
+ * ciu0 or ciu1, the second is the bit within the ciu register.
+ */
+unsigned int irq_create_of_mapping(struct device_node *controller,
+				   const u32 *intspec, unsigned int intsize)
+{
+	int ciu, bit;
+	unsigned int irq = 0;
+
+	ciu = be32_to_cpup(intspec);
+	bit = be32_to_cpup(intspec + 1);
+
+	if (ciu < 8 && bit < 64)
+		irq = octeon_irq_ciu_to_irq[ciu][bit];
+
+	return irq;
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+
 static int octeon_coreid_for_cpu(int cpu)
 {
 #ifdef CONFIG_SMP
-- 
1.7.2.3

