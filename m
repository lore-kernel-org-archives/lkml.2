Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0I3XP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:15:27 -0400
Received: from www.tglx.de ([62.245.132.106]:52344 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0I3XPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:15:24 -0400
Message-Id: <20100930221738.976171570@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:14:58 -0000
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
Subject: [patch 05/47] genirq-sanitize-irq-data-accessors.patch
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=genirq-sanitize-irq-data-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h |   31 ++++++++++++++++++++++++++-----
 kernel/irq/chip.c   |    8 ++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -478,17 +478,38 @@ extern int set_irq_data(unsigned int irq
 extern int set_irq_chip_data(unsigned int irq, void *data);
 extern int set_irq_type(unsigned int irq, unsigned int type);
 extern int set_irq_msi(unsigned int irq, struct msi_desc *entry);
+extern struct irq_data *irq_get_irq_data(unsigned int irq);
 
+static inline struct irq_chip *get_irq_chip(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->chip : NULL;
+}
+
+static inline void *get_irq_chip_data(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->chip_data : NULL;
+}
+
+static inline void *get_irq_data(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->handler_data : NULL;
+}
+
+static inline struct msi_desc *get_irq_msi(unsigned int irq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+	return d ? d->msi_desc : NULL;
+}
+
+/* Needs to die ! */
 static inline void set_irq_desc_chip_data(struct irq_desc *desc, void *data)
 {
 	desc->irq_data.chip_data = data;
 }
 
-#define get_irq_chip(irq)	(irq_to_desc(irq)->chip)
-#define get_irq_chip_data(irq)	(irq_to_desc(irq)->irq_data.chip_data)
-#define get_irq_data(irq)	(irq_to_desc(irq)->irq_data.handler_data)
-#define get_irq_msi(irq)	(irq_to_desc(irq)->irq_data.msi_desc)
-
 #define get_irq_desc_chip(desc)		((desc)->irq_data.chip)
 #define get_irq_desc_chip_data(desc)	((desc)->irq_data.chip_data)
 #define get_irq_desc_data(desc)		((desc)->irq_data.handler_data)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -259,6 +259,14 @@ int set_irq_chip_data(unsigned int irq, 
 }
 EXPORT_SYMBOL(set_irq_chip_data);
 
+struct irq_data *irq_get_irq_data(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc ? &desc->irq_data : NULL;
+}
+EXPORT_SYMBOL_GPL(irq_get_irq_data);
+
 /**
  *	set_irq_nested_thread - Set/Reset the IRQ_NESTED_THREAD flag of an irq
  *


