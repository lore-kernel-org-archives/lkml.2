Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2C1JcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 05:32:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2C1JcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 05:32:19 -0400
Date: Wed, 28 Mar 2012 02:32:01 -0700
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-136d249ef7dbf0fefa292082cc40be1ea864cbd6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <1332385090-18056-2-git-send-email-konrad.wilk@oracle.com>
References: <1332385090-18056-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/ioapic:
  Add io_apic_ops driver layer to allow interception
Git-Commit-ID: 136d249ef7dbf0fefa292082cc40be1ea864cbd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 28 Mar 2012 02:32:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  136d249ef7dbf0fefa292082cc40be1ea864cbd6
Gitweb:     http://git.kernel.org/tip/136d249ef7dbf0fefa292082cc40be1ea864cbd6
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Wed, 21 Mar 2012 22:58:08 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Mar 2012 09:49:29 +0200

x86/ioapic: Add io_apic_ops driver layer to allow interception

Xen dom0 needs to paravirtualize IO operations to the IO APIC,
so add a io_apic_ops for it to intercept.  Do this as ops
structure because there's at least some chance that another
paravirtualized environment may want to intercept these.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: jwboyer@redhat.com
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/1332385090-18056-2-git-send-email-konrad.wilk@oracle.com
[ Made all the affected code easier on the eyes ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/io_apic.h |    9 ++++++
 arch/x86/kernel/apic/io_apic.c |   58 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 690d1cc..2c4943d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -21,6 +21,15 @@
 #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
 #define IO_APIC_REDIR_MASKED		(1 << 16)
 
+struct io_apic_ops {
+	void		(*init)  (void);
+	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
+	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *);
+
 /*
  * The structure of the IO-APIC:
  */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2c428c5..e88300d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -64,9 +64,28 @@
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
+
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
+static void		__init __ioapic_init_mappings(void);
+
+static unsigned int	__io_apic_read  (unsigned int apic, unsigned int reg);
+static void		__io_apic_write (unsigned int apic, unsigned int reg, unsigned int val);
+static void		__io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+
+static struct io_apic_ops io_apic_ops = {
+	.init	= __ioapic_init_mappings,
+	.read	= __io_apic_read,
+	.write	= __io_apic_write,
+	.modify = __io_apic_modify,
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *ops)
+{
+	io_apic_ops = *ops;
+}
+
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -294,6 +313,22 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
+static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+{
+	return io_apic_ops.read(apic, reg);
+}
+
+static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	io_apic_ops.write(apic, reg, value);
+}
+
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	io_apic_ops.modify(apic, reg, value);
+}
+
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -314,16 +349,17 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 	writel(vector, &io_apic->eoi);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+static unsigned int __io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
+
 	writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
@@ -334,7 +370,7 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -377,6 +413,7 @@ static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
 
 	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
 	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+
 	return eu.entry;
 }
 
@@ -384,9 +421,11 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
+
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	eu.entry = __ioapic_read_entry(apic, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
 	return eu.entry;
 }
 
@@ -396,8 +435,7 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
  * the interrupt, and we need to make sure the entry is fully populated
  * before that happens.
  */
-static void
-__ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+static void __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	union entry_union eu = {{0, 0}};
 
@@ -409,6 +447,7 @@ __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
+
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(apic, pin, e);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -435,8 +474,7 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static int
-__add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -521,6 +559,7 @@ static void io_apic_sync(struct irq_pin_list *entry)
 	 * a dummy read from the IO-APIC
 	 */
 	struct io_apic __iomem *io_apic;
+
 	io_apic = io_apic_base(entry->apic);
 	readl(&io_apic->data);
 }
@@ -3894,6 +3933,11 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 
 void __init ioapic_and_gsi_init(void)
 {
+	io_apic_ops.init();
+}
+
+static void __init __ioapic_init_mappings(void)
+{
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
 	int i;
