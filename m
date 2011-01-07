Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1AGQjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:39:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:2990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab1AGQjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:39:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,289,1291622400"; 
   d="scan'208";a="644537614"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        suresh.b.siddha@intel.com
Cc: yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        arjan@linux.intel.com, trenn@suse.de, kent.liu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH v2 2/2] apic: Add print error interrupt reason
Date: Sat,  8 Jan 2011 00:36:44 +0800
Message-Id: <1294418204-15587-3-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1294418204-15587-2-git-send-email-youquan.song@intel.com>
References: <1294418204-15587-1-git-send-email-youquan.song@intel.com>
 <1294418204-15587-2-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

End user worry about the error interrupt information and intend to know what
kind of error interrupts are generated, so this patch add printing out the
detail debug information of error interrupt. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 arch/x86/kernel/apic/apic.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..f0f2809 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1794,6 +1794,32 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+static const char * const error_interrupt_reason[] = {
+	"Send CS error",
+	"Receive CS error",
+	"Send accept error",
+	"Receive accept error",
+	"Redirectable IPI",
+	"Send illegal vector",
+	"Received illegal vector",
+	"Illegal register address",
+};
+
+static void print_error_interrupt_reason(u32 reason)
+{
+	u32 i = 0;
+	reason = reason & 0xff;
+	do {
+		if (reason & 0x1)
+			apic_printk(APIC_DEBUG, " : %s",
+					error_interrupt_reason[i]);
+		i++;
+		reason >>= 1;
+	} while (reason > 0);
+
+	apic_printk(APIC_DEBUG, "\n");
+}
+
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
@@ -1821,8 +1847,9 @@ void smp_error_interrupt(struct pt_regs *regs)
 	 * 6: Received illegal vector
 	 * 7: Illegal register address
 	 */
-	pr_debug("APIC error on CPU%d: %02x(%02x)\n",
+	apic_printk(APIC_DEBUG, "APIC error on CPU%d: %02x(%02x)",
 		smp_processor_id(), v , v1);
+	print_error_interrupt_reason(v1);
 	irq_exit();
 }
 
-- 
1.6.4.2

