Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab1DNGl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:41:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:34214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab1DNGlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:41:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,209,1301900400"; 
   d="scan'208";a="418963147"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, hpa@linux.intel.com, suresh.b.siddha@intel.com,
        yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH v4 2/2] apic: Add print error interrupt reason
Date: Thu, 14 Apr 2011 14:36:08 +0800
Message-Id: <1302762968-24380-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
References: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

End user worry about the error interrupt information and intend to know what
kind of error interrupts are generated, so this patch add printing out the
detail debug information of error interrupt. 
dynamic debug is not initiated when LAPIC initiation, so the pr_debug will not
output the error interrupt debug information when boot.
In this patch, we use apic_printk(APIC_DEBUG,), so if add kernel option
apic=debug will output the error interrupt during boot.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Joe Perches <joe@perches.com> 
---
 arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..3ddf4ef 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1813,6 +1813,17 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 void smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v, v1;
+	u32 i = 0;
+	static const char * const error_interrupt_reason[] = {
+		"Send CS error",		/* APIC Error Bit 0 */
+		"Receive CS error",		/* APIC Error Bit 1 */
+		"Send accept error",		/* APIC Error Bit 2 */
+		"Receive accept error",		/* APIC Error Bit 3 */
+		"Redirectable IPI",		/* APIC Error Bit 4 */
+		"Send illegal vector",		/* APIC Error Bit 5 */
+		"Received illegal vector",	/* APIC Error Bit 6 */
+		"Illegal register address",	/* APIC Error Bit 7 */
+	};
 
 	exit_idle();
 	irq_enter();
@@ -1823,19 +1834,20 @@ void smp_error_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
 
-	/*
-	 * Here is what the APIC error bits mean:
-	 * 0: Send CS error
-	 * 1: Receive CS error
-	 * 2: Send accept error
-	 * 3: Receive accept error
-	 * 4: Reserved
-	 * 5: Send illegal vector
-	 * 6: Received illegal vector
-	 * 7: Illegal register address
-	 */
-	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
-		smp_processor_id(), v , v1);
+	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
+		    smp_processor_id(), v , v1);
+
+	v1 = v1 & 0xff;
+	while (v1) {
+		if (v1 & 0x1)
+			apic_printk(APIC_DEBUG, KERN_CONT " : %s",
+				    error_interrupt_reason[i]);
+		i++;
+		v1 >>= 1;
+	};
+
+	apic_printk(APIC_DEBUG, KERN_CONT "\n");
+
 	irq_exit();
 }
 
-- 
1.6.4.2

