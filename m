Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0KCKXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:23:32 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:11757
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab0KCKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:23:27 -0400
X-SpamScore: -3
X-BigFish: VS-3(zzbb2cKzz1202hzz8275bhz2dh2a8h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
From: Shaohui Xie <b21989@freescale.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Shaohui Xie <b21989@freescale.com>, Li Yang <leoli@freescale.com>,
        Kumar Gala <kumar.gala@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Date: Wed, 3 Nov 2010 17:36:58 +0800
Message-ID: <1288777018-24259-1-git-send-email-b21989@freescale.com>
X-Mailer: git-send-email 1.6.4
X-OriginalArrivalTime: 03 Nov 2010 10:08:51.0259 (UTC) FILETIME=[1D2940B0:01CB7B3F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shaohui Xie <b21989@freescale.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <kumar.gala@freescale.com>
Cc: Roy Zang <tie-fei.zang@freescale.com>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
---
 arch/powerpc/kernel/traps.c   |   14 +++++++++++++-
 arch/powerpc/sysdev/fsl_rio.c |   15 +++------------
 include/linux/rio.h           |    1 +
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index a45a63c..2a5fb9d 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -55,6 +55,7 @@
 #endif
 #include <asm/kexec.h>
 #include <asm/ppc-opcode.h>
+#include <linux/rio.h>
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
@@ -500,6 +501,13 @@ int machine_check_e500mc(struct pt_regs *regs)
 		       reason & MCSR_MEA ? "Effective" : "Physical", addr);
 	}
 
+	if (reason & MCSR_BUS_RBERR) {
+		printk("Bus - Read Data Bus Error\n");
+#ifdef CONFIG_RAPIDIO
+		recoverable = fsl_rio_mcheck_exception(regs);
+#endif
+	}
+
 	mtspr(SPRN_MCSR, mcsr);
 	return mfspr(SPRN_MCSR) == 0 && recoverable;
 }
@@ -527,8 +535,12 @@ int machine_check_e500(struct pt_regs *regs)
 		printk("Bus - Write Address Error\n");
 	if (reason & MCSR_BUS_IBERR)
 		printk("Bus - Instruction Data Error\n");
-	if (reason & MCSR_BUS_RBERR)
+	if (reason & MCSR_BUS_RBERR) {
 		printk("Bus - Read Data Bus Error\n");
+#ifdef CONFIG_RAPIDIO
+		fsl_rio_mcheck_exception(regs);
+#endif
+	}
 	if (reason & MCSR_BUS_WBERR)
 		printk("Bus - Read Data Bus Error\n");
 	if (reason & MCSR_BUS_IPERR)
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 1143c93..a9bc1e8 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -256,9 +256,7 @@ struct rio_priv {
 static void __iomem *rio_regs_win;
 
 #ifdef CONFIG_E500
-static int (*saved_mcheck_exception)(struct pt_regs *regs);
-
-static int fsl_rio_mcheck_exception(struct pt_regs *regs)
+int fsl_rio_mcheck_exception(struct pt_regs *regs)
 {
 	const struct exception_table_entry *entry = NULL;
 	unsigned long reason = mfspr(SPRN_MCSR);
@@ -280,11 +278,9 @@ static int fsl_rio_mcheck_exception(struct pt_regs *regs)
 		}
 	}
 
-	if (saved_mcheck_exception)
-		return saved_mcheck_exception(regs);
-	else
-		return cur_cpu_spec->machine_check(regs);
+	return 0;
 }
+EXPORT_SYMBOL_GPL(fsl_rio_mcheck_exception);
 #endif
 
 /**
@@ -1534,11 +1530,6 @@ int fsl_rio_setup(struct platform_device *dev)
 	fsl_rio_doorbell_init(port);
 	fsl_rio_port_write_init(port);
 
-#ifdef CONFIG_E500
-	saved_mcheck_exception = ppc_md.machine_check_exception;
-	ppc_md.machine_check_exception = fsl_rio_mcheck_exception;
-#endif
-
 	return 0;
 err:
 	iounmap(priv->regs_win);
diff --git a/include/linux/rio.h b/include/linux/rio.h
index bd6eb0e..685b18f 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -365,5 +365,6 @@ extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_inb_mbox(struct rio_mport *, int);
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_outb_mbox(struct rio_mport *, int);
+extern int fsl_rio_mcheck_exception(struct pt_regs *);
 
 #endif				/* LINUX_RIO_H */
-- 
1.6.4


