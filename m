Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0IJLJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:09:30 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41136 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab0IJLJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:09:29 -0400
Date: Fri, 10 Sep 2010 06:01:51 -0700
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Mitch Bradley <wmb@laptop.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 2/2] x86: of: define irq functions to allow drivers/of/* to
 build on x86
Message-ID: <20100910060151.6613e9c3@debxo>
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

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/include/asm/irq.h |    3 +++
 arch/x86/kernel/irq.c      |    8 ++++++++
 include/linux/of_irq.h     |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..8ffa06f 100644
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
index 91fd0c7..b78bb6f 100644
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
@@ -275,6 +276,13 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
+unsigned int irq_create_of_mapping(struct device_node *controller,
+		const u32 *intspec, unsigned int intsize)
+{
+	return intspec[0] + 1;
+}
+EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 090cbaa..109e013 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -5,6 +5,7 @@
 struct of_irq;
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/irq.h>
 #include <linux/ioport.h>
 #include <linux/of.h>
 
-- 
1.5.6.5

