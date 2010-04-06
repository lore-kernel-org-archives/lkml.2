Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0DFV2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:28:16 -0400
Received: from mxout1.idt.com ([157.165.5.25]:34926 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab0DFV2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:28:06 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 17:28:05 EDT
Date: Tue, 6 Apr 2010 17:24:00 -0400
From: Alexandre Bounine <abounine@tundra.com>
To: torvalds@linux-foundation.org
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, thomas.moll@sysgo.com,
       abounine@tundra.com
Subject: [PATCH v3 5/6] RapidIO, powerpc/85xx: Add MChk handler for SRIO port
Message-ID: <20100406212400.GE26292@amak.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexandre Bounine <alexandre.bounine@idt.com>

Add Machine Check exception handling into RapidIO port driver
for Freescale SoCs (MPC85xx).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Tested-by: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
---

 fsl_rio.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 70 insertions(+), 4 deletions(-)

diff -x '*.pj' -X dontdiff_2.6.32-rc5 -pNur w34r3a/arch/powerpc/sysdev/fsl_rio.c w34r3b/arch/powerpc/sysdev/fsl_rio.c
--- w34r3a/arch/powerpc/sysdev/fsl_rio.c	2010-04-06 15:23:58.772536000 -0400
+++ w34r3b/arch/powerpc/sysdev/fsl_rio.c	2010-04-06 15:25:50.446381000 -0400
@@ -31,6 +31,8 @@
 #include <linux/kfifo.h>
 
 #include <asm/io.h>
+#include <asm/machdep.h>
+#include <asm/uaccess.h>
 
 #undef DEBUG_PW	/* Port-Write debugging */
 
@@ -46,6 +48,8 @@
 #define RIO_ESCSR		0x158
 #define RIO_CCSR		0x15c
 #define RIO_LTLEDCSR		0x0608
+#define  RIO_LTLEDCSR_IER	0x80000000
+#define  RIO_LTLEDCSR_PRT	0x01000000
 #define RIO_LTLEECSR		0x060c
 #define RIO_EPWISR		0x10010
 #define RIO_ISR_AACR		0x10120
@@ -213,6 +217,54 @@ struct rio_priv {
 	spinlock_t pw_fifo_lock;
 };
 
+#define __fsl_read_rio_config(x, addr, err, op)		\
+	__asm__ __volatile__(				\
+		"1:	"op" %1,0(%2)\n"		\
+		"	eieio\n"			\
+		"2:\n"					\
+		".section .fixup,\"ax\"\n"		\
+		"3:	li %1,-1\n"			\
+		"	li %0,%3\n"			\
+		"	b 2b\n"				\
+		".section __ex_table,\"a\"\n"		\
+		"	.align 2\n"			\
+		"	.long 1b,3b\n"			\
+		".text"					\
+		: "=r" (err), "=r" (x)			\
+		: "b" (addr), "i" (-EFAULT), "0" (err))
+
+static void __iomem *rio_regs_win;
+
+static int (*saved_mcheck_exception)(struct pt_regs *regs);
+
+static int fsl_rio_mcheck_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *entry = NULL;
+	unsigned long reason = (mfspr(SPRN_MCSR) & MCSR_MASK);
+
+	if (reason & MCSR_BUS_RBERR) {
+		reason = in_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR));
+		if (reason & (RIO_LTLEDCSR_IER | RIO_LTLEDCSR_PRT)) {
+			/* Check if we are prepared to handle this fault */
+			entry = search_exception_tables(regs->nip);
+			if (entry) {
+				pr_debug("RIO: %s - MC Exception handled\n",
+					 __func__);
+				out_be32((u32 *)(rio_regs_win + RIO_LTLEDCSR),
+					 0);
+				regs->msr |= MSR_RI;
+				regs->nip = entry->fixup;
+				return 1;
+			}
+		}
+	}
+
+	if (saved_mcheck_exception)
+		return saved_mcheck_exception(regs);
+	else
+		return cur_cpu_spec->machine_check(regs);
+}
+
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
  * @mport: RapidIO master port info
@@ -313,6 +365,7 @@ fsl_rio_config_read(struct rio_mport *mp
 {
 	struct rio_priv *priv = mport->priv;
 	u8 *data;
+	u32 rval, err = 0;
 
 	pr_debug
 	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
@@ -323,17 +376,24 @@ fsl_rio_config_read(struct rio_mport *mp
 	data = (u8 *) priv->maint_win + offset;
 	switch (len) {
 	case 1:
-		*val = in_8((u8 *) data);
+		__fsl_read_rio_config(rval, data, err, "lbz");
 		break;
 	case 2:
-		*val = in_be16((u16 *) data);
+		__fsl_read_rio_config(rval, data, err, "lhz");
 		break;
 	default:
-		*val = in_be32((u32 *) data);
+		__fsl_read_rio_config(rval, data, err, "lwz");
 		break;
 	}
 
-	return 0;
+	if (err) {
+		pr_debug("RIO: cfg_read error %d for %x:%x:%x\n",
+			 err, destid, hopcount, offset);
+	}
+
+	*val = rval;
+
+	return err;
 }
 
 /**
@@ -1364,6 +1424,7 @@ int fsl_rio_setup(struct of_device *dev)
 	rio_register_mport(port);
 
 	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
+	rio_regs_win = priv->regs_win;
 
 	/* Probe the master port phy type */
 	ccsr = in_be32(priv->regs_win + RIO_CCSR);
@@ -1432,6 +1493,11 @@ int fsl_rio_setup(struct of_device *dev)
 	fsl_rio_doorbell_init(port);
 	fsl_rio_port_write_init(port);
 
+	saved_mcheck_exception = ppc_md.machine_check_exception;
+	ppc_md.machine_check_exception = fsl_rio_mcheck_exception;
+	/* Ensure that RFXE is set */
+	mtspr(SPRN_HID1, (mfspr(SPRN_HID1) | 0x20000));
+
 	return 0;
 err:
 	iounmap(priv->regs_win);
