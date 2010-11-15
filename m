Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0KORZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:25:23 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:46836 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab0KORZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:25:17 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw02.freescale.net;RD:az33egw02.freescale.net;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <amit.kucheria@canonical.com>, <eric@eukrea.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 2/3] ARM: imx: Add mx53 support to common msl functions.
Date: Mon, 15 Nov 2010 11:30:00 -0600
Message-ID: <1289842201-3277-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1289842201-3277-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1289842201-3277-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add mx53 support to cpu.c and mm.c.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/cpu.c |   19 ++++++++++++++++++-
 arch/arm/mach-mx5/mm.c  |   19 ++++++++++++++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
index 8c9a29e..a00d2bc 100644
--- a/arch/arm/mach-mx5/cpu.c
+++ b/arch/arm/mach-mx5/cpu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -92,6 +92,23 @@ static int __init mx51_neon_fixup(void)
 late_initcall(mx51_neon_fixup);
 #endif
 
+/*
+ * Returns:
+ *	the silicon revision of the cpu
+ *	-EINVAL - not a mx53
+ */
+int mx53_revision(void)
+{
+	if (!cpu_is_mx53())
+		return -EINVAL;
+
+	if (cpu_silicon_rev == -1)
+		query_silicon_parameter();
+
+	return cpu_silicon_rev;
+}
+EXPORT_SYMBOL(mx53_revision);
+
 static int __init post_cpu_init(void)
 {
 	unsigned int reg;
diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
index 2822d0e..cbaf282 100644
--- a/arch/arm/mach-mx5/mm.c
+++ b/arch/arm/mach-mx5/mm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * The code contained herein is licensed under the GNU General Public
  * License.  You may obtain a copy of the GNU General Public License
@@ -32,6 +32,15 @@ static struct map_desc mx51_io_desc[] __initdata = {
 };
 
 /*
+ * Define the MX53 memory map.
+ */
+static struct map_desc mx53_io_desc[] __initdata = {
+	imx_map_entry(MX53, AIPS1, MT_DEVICE),
+	imx_map_entry(MX53, SPBA0, MT_DEVICE),
+	imx_map_entry(MX53, AIPS2, MT_DEVICE),
+};
+
+/*
  * This function initializes the memory map. It is called during the
  * system startup to create static physical to virtual memory mappings
  * for the IO modules.
@@ -44,6 +53,14 @@ void __init mx51_map_io(void)
 	iotable_init(mx51_io_desc, ARRAY_SIZE(mx51_io_desc));
 }
 
+void __init mx53_map_io(void)
+{
+	mxc_set_cpu_type(MXC_CPU_MX53);
+	mxc_iomux_v3_init(MX53_IO_ADDRESS(MX53_IOMUXC_BASE_ADDR));
+	mxc_arch_reset_init(MX53_IO_ADDRESS(MX53_WDOG_BASE_ADDR));
+	iotable_init(mx53_io_desc, ARRAY_SIZE(mx53_io_desc));
+}
+
 int imx51_register_gpios(void);
 
 void __init mx51_init_irq(void)
-- 
1.6.0.4


