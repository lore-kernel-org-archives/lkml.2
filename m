Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab0I3XRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:37 -0400
Received: from www.tglx.de ([62.245.132.106]:52878 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab0I3XRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:33 -0400
Message-Id: <20100930221741.524034363@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 31/47] ht: Convert to new irq_chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=ht-convert-irq-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 drivers/pci/htirq.c            |   22 ++++++++--------------
 include/linux/htirq.h          |    5 +++--
 3 files changed, 13 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3751,8 +3751,8 @@ static int set_ht_irq_affinity(unsigned 
 
 static struct irq_chip ht_irq_chip = {
 	.name		= "PCI-HT",
-	.mask		= mask_ht_irq,
-	.unmask		= unmask_ht_irq,
+	.irq_mask	= mask_ht_irq,
+	.irq_unmask	= unmask_ht_irq,
 	.irq_ack	= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ht_irq_affinity,
Index: linux-2.6-tip/drivers/pci/htirq.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/htirq.c
+++ linux-2.6-tip/drivers/pci/htirq.c
@@ -57,28 +57,22 @@ void fetch_ht_irq_msg(unsigned int irq, 
 	*msg = cfg->msg;
 }
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq(struct irq_data *data)
 {
-	struct ht_irq_cfg *cfg;
-	struct ht_irq_msg msg;
-
-	cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = data->handler_data;
+	struct ht_irq_msg msg = cfg->msg;
 
-	msg = cfg->msg;
 	msg.address_lo |= 1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(data->irq, &msg);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq(struct irq_data *data)
 {
-	struct ht_irq_cfg *cfg;
-	struct ht_irq_msg msg;
-
-	cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = data->handler_data;
+	struct ht_irq_msg msg = cfg->msg;
 
-	msg = cfg->msg;
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(data->irq, &msg);
 }
 
 /**
Index: linux-2.6-tip/include/linux/htirq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/htirq.h
+++ linux-2.6-tip/include/linux/htirq.h
@@ -9,8 +9,9 @@ struct ht_irq_msg {
 /* Helper functions.. */
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void mask_ht_irq(unsigned int irq);
-void unmask_ht_irq(unsigned int irq);
+struct irq_data;
+void mask_ht_irq(struct irq_data *data);
+void unmask_ht_irq(struct irq_data *data);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);


