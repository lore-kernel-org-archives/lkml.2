Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab1C3USM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:18:12 -0400
Received: from mail.atheros.com ([12.19.149.2]:51126 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1C3USL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:18:11 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <mcgrof@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat: backport IRQ namespace cleanup
Date: Wed, 30 Mar 2011 13:18:06 -0700
Message-ID: <1301516286-8134-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This backports this upstream patch:

commit a0cd9ca2b907d7ee26575e7b63ac92dad768a75e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Feb 10 11:36:33 2011 +0100

    genirq: Namespace cleanup

    The irq namespace has become quite convoluted. My bad.  Clean it up
    and deprecate the old functions. All new functions follow the scheme:

    irq number based:
        irq_set/get/xxx/_xxx(unsigned int irq, ...)

    irq_data based:
         irq_data_set/get/xxx/_xxx(struct irq_data *d, ....)

    irq_desc based:
         irq_desc_get_xxx(struct irq_desc *desc)

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/compat-2.6.39.h |   76 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 0c4f030..bf4442b 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -6,6 +6,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39))
 
 #include <linux/tty.h>
+#include <linux/irq.h>
 
 /*
  * This is not part of The 2.6.37 kernel yet but we
@@ -31,6 +32,81 @@
 extern int tty_set_termios(struct tty_struct *tty, struct ktermios *kt);
 #endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)) */
 
+static inline int irq_set_irq_wake(unsigned int irq, unsigned int on)
+{
+	return set_irq_wake(irq, on);
+}
+static inline int irq_set_chip(unsigned int irq, struct irq_chip *chip)
+{
+	return set_irq_chip(irq, chip);
+}
+static inline int irq_set_handler_data(unsigned int irq, void *data)
+{
+	return set_irq_data(irq, data);
+}
+static inline int irq_set_chip_data(unsigned int irq, void *data)
+{
+	return set_irq_chip_data(irq, data);
+}
+static inline int irq_set_irq_type(unsigned int irq, unsigned int type)
+{
+	return set_irq_type(irq, type);
+}
+static inline int irq_set_msi_desc(unsigned int irq, struct msi_desc *entry)
+{
+	return set_irq_msi(irq, entry);
+}
+static inline struct irq_chip *irq_get_chip(unsigned int irq)
+{
+	return get_irq_chip(irq);
+}
+static inline void *irq_get_chip_data(unsigned int irq)
+{
+	return get_irq_chip_data(irq);
+}
+static inline void *irq_get_handler_data(unsigned int irq)
+{
+	return get_irq_data(irq);
+}
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+static inline void *irq_data_get_irq_handler_data(struct irq_data *d)
+{
+	return irq_data_get_irq_data(d);
+}
+#endif
+
+static inline struct msi_desc *irq_get_msi_desc(unsigned int irq)
+{
+	return get_irq_msi(irq);
+}
+static inline void irq_set_noprobe(unsigned int irq)
+{
+	set_irq_noprobe(irq);
+}
+static inline void irq_set_probe(unsigned int irq)
+{
+	set_irq_probe(irq);
+}
+static inline struct irq_chip *irq_desc_get_chip(struct irq_desc *desc)
+{
+	return get_irq_desc_chip(desc);
+}
+static inline void *irq_desc_get_handler_data(struct irq_desc *desc)
+{
+	return get_irq_desc_data(desc);
+}
+
+static inline void *irq_desc_get_chip_data(struct irq_desc *desc)
+{
+	return get_irq_desc_chip_data(desc);
+}
+
+static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
+{
+	return get_irq_desc_msi(desc);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
 
 #endif /* LINUX_26_39_COMPAT_H */
-- 
1.7.4.15.g7811d

