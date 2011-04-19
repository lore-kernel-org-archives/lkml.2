Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1DSRtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:49:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1DSRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:49:12 -0400
Date: Tue, 19 Apr 2011 17:48:55 GMT
From: tip-bot for Youquan Song <youquan.song@intel.com>
Message-ID: <tip-2b398bd9f8f73be706b41adcbb240ce95793049a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joe@perches.com, tglx@linutronix.de, youquan.song@intel.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, tglx@linutronix.de, youquan.song@intel.com,
        mingo@elte.hu
In-Reply-To: <1302762968-24380-2-git-send-email-youquan.song@intel.com>
References: <1302762968-24380-2-git-send-email-youquan.song@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Print verbose error interrupt reason on apic=debug
Git-Commit-ID: 2b398bd9f8f73be706b41adcbb240ce95793049a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 17:48:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b398bd9f8f73be706b41adcbb240ce95793049a
Gitweb:     http://git.kernel.org/tip/2b398bd9f8f73be706b41adcbb240ce95793049a
Author:     Youquan Song <youquan.song@intel.com>
AuthorDate: Thu, 14 Apr 2011 14:36:08 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 Apr 2011 19:03:30 +0200

x86, apic: Print verbose error interrupt reason on apic=debug

End users worry about the error interrupt printout we generate
currently:

	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
	smp_processor_id(), v , v1);

... and would like to know the reason why error interrupts are generated.

This patch prints out more detailed debug information.

Another practical problem is that dynamic debug is not initialized yet
when the APIC initializes, so the pr_debug() will not output the error
interrupt debug information on bootup. In this patch, we use
apic_printk(APIC_DEBUG, ...), so the apic=debug boot option will print
verbose error interupts during bootup.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: hpa@linux.intel.com
Cc: suresh.b.siddha@intel.com
Cc: yong.y.wang@linux.intel.com
Cc: jbaron@redhat.com
Cc: trenn@suse.de
Cc: kent.liu@intel.com
Cc: chaohong.guo@intel.com
Link: http://lkml.kernel.org/r/1302762968-24380-2-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
 
