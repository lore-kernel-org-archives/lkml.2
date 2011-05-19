Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab1ESN4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:56:17 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:25043
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245Ab1ESN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:56:13 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Timur Tabi <timur@freescale.com>
To: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: [PATCH 4/7] powerpc: add Freescale hypervisor partition control functions
Date: Thu, 19 May 2011 08:54:29 -0500
Message-ID: <1305813272-31826-5-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305813272-31826-1-git-send-email-timur@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to restart and halt the current partition when running under
the Freescale hypervisor.  These functions should be assigned to various
function pointers of the ppc_md structure during the .probe() function for
the board:

	ppc_md.restart = fsl_hv_restart;
	ppc_md.power_off = fsl_hv_halt;
	ppc_md.halt = fsl_hv_halt;

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 arch/powerpc/sysdev/fsl_soc.c |   27 +++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_soc.h |    3 +++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 19e5015..265313e 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -41,6 +41,7 @@
 #include <sysdev/fsl_soc.h>
 #include <mm/mmu_decl.h>
 #include <asm/cpm2.h>
+#include <asm/fsl_hcalls.h>	/* For the Freescale hypervisor */
 
 extern void init_fcc_ioports(struct fs_platform_info*);
 extern void init_fec_ioports(struct fs_platform_info*);
@@ -252,3 +253,29 @@ void fsl_rstcr_restart(char *cmd)
 struct platform_diu_data_ops diu_ops;
 EXPORT_SYMBOL(diu_ops);
 #endif
+
+/*
+ * Restart the current partition
+ *
+ * This function should be assigned to the ppc_md.restart function pointer,
+ * to initiate a partition restart when we're running under the Freescale
+ * hypervisor.
+ */
+void fsl_hv_restart(char *cmd)
+{
+	pr_info("hv restart\n");
+	fh_partition_restart(-1);
+}
+
+/*
+ * Halt the current partition
+ *
+ * This function should be assigned to the ppc_md.power_off and ppc_md.halt
+ * function pointers, to shut down the partition when we're running under
+ * the Freescale hypervisor.
+ */
+void fsl_hv_halt(void)
+{
+	pr_info("hv exit\n");
+	fh_partition_stop(-1);
+}
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 5360948..2ece02b 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -36,5 +36,8 @@ struct platform_diu_data_ops {
 extern struct platform_diu_data_ops diu_ops;
 #endif
 
+void fsl_hv_restart(char *cmd);
+void fsl_hv_halt(void);
+
 #endif
 #endif
-- 
1.7.3.4


