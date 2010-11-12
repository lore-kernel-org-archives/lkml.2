Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab0KLFpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 00:45:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58343 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0KLFpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 00:45:34 -0500
Date: Thu, 11 Nov 2010 21:45:26 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/3] x86: of: define irq functions to allow drivers/of/* to
 build on x86
Message-ID: <20101111214526.5de7121b@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - Define a stub irq_create_of_mapping for x86 as a stop-gap solution until
   drivers/of/irq is further along.
 - Define irq_dispose_mapping for x86 to appease of_i2c.c

These are needed to allow stuff in drivers/of/ to build on x86.  This stuff
will eventually get replaced; quoting Grant,

"The long term plan is to have the drivers/of/ code handling the mapping
intelligently like powerpc currently does."  But for now, just provide
these functions.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/include/asm/irq.h |    3 +++
 arch/x86/kernel/irq.c      |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 13b0eba..8d2c671 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,9 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+/* Even though we don't support this, supply it to appease OF */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 83ec017..d833d1b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
+#include <linux/of.h>
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
@@ -275,6 +276,15 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
+#ifdef CONFIG_OF
+unsigned int irq_create_of_mapping(struct device_node *controller,
+		const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0];
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
-- 
1.7.2.3

