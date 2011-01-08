Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab1AHDOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 22:14:50 -0500
Received: from mail.perches.com ([173.55.12.10]:3030 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1AHDOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:14:49 -0500
Subject: Re: [PATCH v3 2/2] apic: Add print error interrupt reason
From: Joe Perches <joe@perches.com>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com, yong.y.wang@linux.intel.com,
        jbaron@redhat.com, arjan@linux.intel.com, trenn@suse.de,
        kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
In-Reply-To: <1294453211-26439-3-git-send-email-youquan.song@intel.com>
References: <1294453211-26439-1-git-send-email-youquan.song@intel.com>
	 <1294453211-26439-2-git-send-email-youquan.song@intel.com>
	 <1294453211-26439-3-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 19:14:46 -0800
Message-ID: <1294456486.17763.75.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Youquan.

Your patch removes KERN_DEBUG and prints at KERN_DEFAULT.
Is that what you want?

This one reduces a few lines and adds KERN_DEBUG and KERN_CONT.
Maybe this one's what you want?

 arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7821813..5a70e63 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1808,6 +1808,17 @@ void smp_spurious_interrupt(struct pt_regs *regs)
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
@@ -1818,19 +1829,20 @@ void smp_error_interrupt(struct pt_regs *regs)
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
 


