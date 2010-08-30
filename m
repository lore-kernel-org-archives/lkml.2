Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab0H3EEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 00:04:21 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57996 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab0H3EET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 00:04:19 -0400
Date: Mon, 30 Aug 2010 00:06:14 -0400
From: Andres Salomon <dilinger@queued.net>
To: devicetree-discuss@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, cjb@laptop.org,
        Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        grant.likely@secretlab.ca,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 8/9] x86: of: irq additions to make drivers/of/* build on
 x86
Message-ID: <20100830000614.0d571f10@debxo>
In-Reply-To: <20100829235100.6dcedcb8@debxo>
References: <20100628215407.2017bf2f@debian>
	<20100829235100.6dcedcb8@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This functionality overlaps with patches previously submitted
by Stephen Neuendorffer.  I don't care whose eventually get applied,
so long as drivers/of/* becomes buildable on x86.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/include/asm/irq.h |    5 +++++
 arch/x86/kernel/irq.c      |    8 ++++++++
 include/linux/of_irq.h     |    1 +
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 5458380..0a656b9 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,11 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+#define NO_IRQ 0
+
+/* Even though we don't support this, supply it to appease OF */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 91fd0c7..d53f639 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -7,6 +7,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/of.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
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
index 5929781..05ad27b 100644
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

