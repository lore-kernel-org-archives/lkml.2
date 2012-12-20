Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2LTJqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:46:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14422 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTJq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:46:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 20 Dec 2012 01:43:54 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/9] ARM: tegra: # of CPU cores detection w/ & w/o HAVE_ARM_SCU
Date: Thu, 20 Dec 2012 11:44:01 +0200
Message-ID: <1355996654-6579-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The method to detect the number of CPU cores on Cortex-A9 MPCore and
Cortex-A15 MPCore is different. On Cortex-A9 MPCore we can get this
information from the Snoop Control Unit(SCU). On Cortex-A15 MPCore we
have to read it from the system coprocessor(CP15), because the SCU on
Cortex-A15 MPCore does not have software readable registers. This
patch selects the correct method at runtime based on the CPU ID.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/platsmp.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1b926df..68e76ef 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -23,6 +23,7 @@
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
 #include <asm/smp_scu.h>
+#include <asm/cputype.h>
 
 #include <mach/powergate.h>
 
@@ -34,9 +35,13 @@
 #include "common.h"
 #include "iomap.h"
 
+#define CPU_MASK		0xff0ffff0
+#define CPU_CORTEX_A9		0x410fc090
+#define CPU_CORTEX_A15		0x410fc0f0
+
 extern void tegra_secondary_startup(void);
 
-static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
+static void __iomem *scu_base;
 
 #define EVP_CPU_RESET_VECTOR \
 	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
@@ -149,7 +154,26 @@ done:
  */
 static void __init tegra_smp_init_cpus(void)
 {
-	unsigned int i, ncores = scu_get_core_count(scu_base);
+	unsigned int i, cpu_id, ncores;
+	u32 l2ctlr;
+	phys_addr_t pa;
+
+	cpu_id = read_cpuid(CPUID_ID) & CPU_MASK;
+	switch (cpu_id) {
+	case CPU_CORTEX_A15:
+		asm("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
+		ncores = ((l2ctlr >> 24) & 3) + 1;
+		break;
+	case CPU_CORTEX_A9:
+		/* Get SCU physical base */
+		asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (pa));
+		scu_base = IO_ADDRESS(pa);
+		ncores = scu_get_core_count(scu_base);
+		break;
+	default:
+		BUG();
+		break;
+	}
 
 	if (ncores > nr_cpu_ids) {
 		pr_warn("SMP: %u cores greater than maximum (%u), clipping\n",
@@ -166,7 +190,8 @@ static void __init tegra_smp_init_cpus(void)
 static void __init tegra_smp_prepare_cpus(unsigned int max_cpus)
 {
 	tegra_cpu_reset_handler_init();
-	scu_enable(scu_base);
+	if (scu_base)
+		scu_enable(scu_base);
 }
 
 struct smp_operations tegra_smp_ops __initdata = {
-- 
1.7.9.5

