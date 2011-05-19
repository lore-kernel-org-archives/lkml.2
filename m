Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab1ESNzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:55:12 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:20809
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245Ab1ESNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:55:00 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: [PATCH 5/7] powerpc/85xx: add board support for the Freescale hypervisor
Date: Thu, 19 May 2011 08:54:30 -0500
Message-ID: <1305813272-31826-6-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305813272-31826-1-git-send-email-timur@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the ePAPR-compliant Freescale hypervisor (aka "Topaz") on the
Freescale P3041DS, P4080DS, and P5020DS reference boards.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 arch/powerpc/platforms/85xx/Kconfig      |    3 +++
 arch/powerpc/platforms/85xx/corenet_ds.c |    7 +++++++
 arch/powerpc/platforms/85xx/p3041_ds.c   |   16 +++++++++++++++-
 arch/powerpc/platforms/85xx/p4080_ds.c   |   29 ++++++++++++++++-------------
 arch/powerpc/platforms/85xx/p5020_ds.c   |   16 +++++++++++++++-
 5 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index b6976e1..f1e9db6 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -163,6 +163,7 @@ config P3041_DS
 	select SWIOTLB
 	select MPC8xxx_GPIO
 	select HAS_RAPIDIO
+	select PPC_EPAPR_HV_PIC
 	help
 	  This option enables support for the P3041 DS board
 
@@ -174,6 +175,7 @@ config P4080_DS
 	select SWIOTLB
 	select MPC8xxx_GPIO
 	select HAS_RAPIDIO
+	select PPC_EPAPR_HV_PIC
 	help
 	  This option enables support for the P4080 DS board
 
@@ -188,6 +190,7 @@ config P5020_DS
 	select SWIOTLB
 	select MPC8xxx_GPIO
 	select HAS_RAPIDIO
+	select PPC_EPAPR_HV_PIC
 	help
 	  This option enables support for the P5020 DS board
 
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 2ab338c..07a5e67 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -116,6 +116,13 @@ static const struct of_device_id of_device_ids[] __devinitconst = {
 	{
 		.compatible	= "fsl,rapidio-delta",
 	},
+	/* The following two are for the Freescale hypervisor */
+	{
+		.name		= "hypervisor",
+	},
+	{
+		.name		= "handles",
+	},
 	{}
 };
 
diff --git a/arch/powerpc/platforms/85xx/p3041_ds.c b/arch/powerpc/platforms/85xx/p3041_ds.c
index 0ed52e1..e2cfb6b 100644
--- a/arch/powerpc/platforms/85xx/p3041_ds.c
+++ b/arch/powerpc/platforms/85xx/p3041_ds.c
@@ -30,6 +30,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include <asm/ehv_pic.h>
 
 #include "corenet_ds.h"
 
@@ -40,7 +41,20 @@ static int __init p3041_ds_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
 
-	return of_flat_dt_is_compatible(root, "fsl,P3041DS");
+	if (of_flat_dt_is_compatible(root, "fsl,P3041DS"))
+		return 1;
+
+	/* Check if we're running under the Freescale hypervisor */
+	if (of_flat_dt_is_compatible(root, "fsl,P3041DS-hv")) {
+		ppc_md.init_IRQ = ehv_pic_init;
+		ppc_md.get_irq = ehv_pic_get_irq;
+		ppc_md.restart = fsl_hv_restart;
+		ppc_md.power_off = fsl_hv_halt;
+		ppc_md.halt = fsl_hv_halt;
+		return 1;
+	}
+
+	return 0;
 }
 
 define_machine(p3041_ds) {
diff --git a/arch/powerpc/platforms/85xx/p4080_ds.c b/arch/powerpc/platforms/85xx/p4080_ds.c
index 8417046..af074ff 100644
--- a/arch/powerpc/platforms/85xx/p4080_ds.c
+++ b/arch/powerpc/platforms/85xx/p4080_ds.c
@@ -29,13 +29,10 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include <asm/ehv_pic.h>
 
 #include "corenet_ds.h"
 
-#ifdef CONFIG_PCI
-static int primary_phb_addr;
-#endif
-
 /*
  * Called very early, device-tree isn't unflattened
  */
@@ -43,17 +40,20 @@ static int __init p4080_ds_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
 
-	if (of_flat_dt_is_compatible(root, "fsl,P4080DS")) {
-#ifdef CONFIG_PCI
-		/* treat PCIe1 as primary,
-		 * shouldn't matter as we have no ISA on the board
-		 */
-		primary_phb_addr = 0x0000;
-#endif
+	if (of_flat_dt_is_compatible(root, "fsl,P4080DS"))
+		return 1;
+
+	/* Check if we're running under the Freescale hypervisor */
+	if (of_flat_dt_is_compatible(root, "fsl,P4080DS-hv")) {
+		ppc_md.init_IRQ = ehv_pic_init;
+		ppc_md.get_irq = ehv_pic_get_irq;
+		ppc_md.restart = fsl_hv_restart;
+		ppc_md.power_off = fsl_hv_halt;
+		ppc_md.halt = fsl_hv_halt;
 		return 1;
-	} else {
-		return 0;
 	}
+
+	return 0;
 }
 
 define_machine(p4080_ds) {
@@ -71,4 +71,7 @@ define_machine(p4080_ds) {
 };
 
 machine_device_initcall(p4080_ds, corenet_ds_publish_devices);
+
+#ifdef CONFIG_SWIOTLB
 machine_arch_initcall(p4080_ds, swiotlb_setup_bus_notifier);
+#endif
diff --git a/arch/powerpc/platforms/85xx/p5020_ds.c b/arch/powerpc/platforms/85xx/p5020_ds.c
index 7467b71..94348c9 100644
--- a/arch/powerpc/platforms/85xx/p5020_ds.c
+++ b/arch/powerpc/platforms/85xx/p5020_ds.c
@@ -30,6 +30,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
 #include <sysdev/fsl_pci.h>
+#include <asm/ehv_pic.h>
 
 #include "corenet_ds.h"
 
@@ -40,7 +41,20 @@ static int __init p5020_ds_probe(void)
 {
 	unsigned long root = of_get_flat_dt_root();
 
-	return of_flat_dt_is_compatible(root, "fsl,P5020DS");
+	if (of_flat_dt_is_compatible(root, "fsl,P5020DS"))
+		return 1;
+
+	/* Check if we're running under the Freescale hypervisor */
+	if (of_flat_dt_is_compatible(root, "fsl,P5020DS-hv")) {
+		ppc_md.init_IRQ = ehv_pic_init;
+		ppc_md.get_irq = ehv_pic_get_irq;
+		ppc_md.restart = fsl_hv_restart;
+		ppc_md.power_off = fsl_hv_halt;
+		ppc_md.halt = fsl_hv_halt;
+		return 1;
+	}
+
+	return 0;
 }
 
 define_machine(p5020_ds) {
-- 
1.7.3.4


