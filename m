Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722Ab1ESUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:40:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40459 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933968Ab1ESUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:40:29 -0400
Date: Thu, 19 May 2011 22:40:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v2.6.40
Message-ID: <20110519204016.GA26181@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

 Thanks,

	Ingo

------------------>
Youquan Song (1):
      x86, apic: Print verbose error interrupt reason on apic=debug


 arch/x86/kernel/apic/apic.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..ae14712 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1812,30 +1812,41 @@ void smp_spurious_interrupt(struct pt_regs *regs)
  */
 void smp_error_interrupt(struct pt_regs *regs)
 {
-	u32 v, v1;
+	u32 v0, v1;
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
 	/* First tickle the hardware, only then report what went on. -- REW */
-	v = apic_read(APIC_ESR);
+	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
 	v1 = apic_read(APIC_ESR);
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
+		    smp_processor_id(), v0 , v1);
+
+	v1 = v1 & 0xff;
+	while (v1) {
+		if (v1 & 0x1)
+			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
+		i++;
+		v1 >>= 1;
+	};
+
+	apic_printk(APIC_DEBUG, KERN_CONT "\n");
+
 	irq_exit();
 }
 
