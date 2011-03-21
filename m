Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1CUVco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:32:44 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:28504
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab1CUVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:32:42 -0400
X-SpamScore: 2
X-BigFish: VS2(z616jzzz1202hzz8275bhz2dh2a8h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <arnaud.patard@rtp-net.org>, <ra5478@freescale.com>,
        <xiao-lizhang@freescale.com>, <festevam@gmail.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 1/4] ARM: mx50: Add support to get the silicon revision
Date: Mon, 21 Mar 2011 16:30:35 -0500
Message-ID: <1300743038-3901-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

For MX50, the HW_ADADIG_DIGPROG register in the ANATOP module will
have the correct silicon revision:

Major       Minor   Description
0x50        0x0     TO1.0
0x50        0x1     TO1.1

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/cpu.c               |   39 +++++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/mx50.h |    4 +++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/cpu.c b/arch/arm/mach-mx5/cpu.c
index df46b5e..c205494 100644
--- a/arch/arm/mach-mx5/cpu.c
+++ b/arch/arm/mach-mx5/cpu.c
@@ -21,6 +21,7 @@
 static int cpu_silicon_rev = -1;
 
 #define IIM_SREV 0x24
+#define MX50_HW_ADADIG_DIGPROG	0xB0
 
 static int get_mx51_srev(void)
 {
@@ -107,6 +108,44 @@ int mx53_revision(void)
 }
 EXPORT_SYMBOL(mx53_revision);
 
+static int get_mx50_srev(void)
+{
+	void __iomem *anatop = ioremap(MX50_ANATOP_BASE_ADDR, SZ_8K);
+	u32 rev;
+
+	if (!anatop) {
+		cpu_silicon_rev = -EINVAL;
+		return 0;
+	}
+
+	rev = readl(anatop + MX50_HW_ADADIG_DIGPROG);
+	rev &= 0xff;
+
+	iounmap(anatop);
+	if (rev == 0x0)
+		return IMX_CHIP_REVISION_1_0;
+	else if (rev == 0x1)
+		return IMX_CHIP_REVISION_1_1;
+	return 0;
+}
+
+/*
+ * Returns:
+ *	the silicon revision of the cpu
+ *	-EINVAL - not a mx50
+ */
+int mx50_revision(void)
+{
+	if (!cpu_is_mx50())
+		return -EINVAL;
+
+	if (cpu_silicon_rev == -1)
+		cpu_silicon_rev = get_mx50_srev();
+
+	return cpu_silicon_rev;
+}
+EXPORT_SYMBOL(mx50_revision);
+
 static int __init post_cpu_init(void)
 {
 	unsigned int reg;
diff --git a/arch/arm/plat-mxc/include/mach/mx50.h b/arch/arm/plat-mxc/include/mach/mx50.h
index aaec2a6..5f2da75 100644
--- a/arch/arm/plat-mxc/include/mach/mx50.h
+++ b/arch/arm/plat-mxc/include/mach/mx50.h
@@ -282,4 +282,8 @@
 #define MX50_INT_APBHDMA_CHAN6	116
 #define MX50_INT_APBHDMA_CHAN7	117
 
+#if !defined(__ASSEMBLY__) && !defined(__MXC_BOOT_UNCOMPRESS)
+extern int mx50_revision(void);
+#endif
+
 #endif /* ifndef __MACH_MX50_H__ */
-- 
1.6.0.4


