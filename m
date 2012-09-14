Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034Ab2INVgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:36:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab2INVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 19/24] sh: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:47 +0200
Message-Id: <1347658492-11608-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ItsVwobvl0NriKOf5r4gTuZG9iuA/ZU2VS1bnvsP6Wg
 cc75jFD157654sGZHlXW8Kik+T6u7dt0brntQjS3NthEhXeu4v
 WFRB/gZEH8QfKcmkyySay52/EYaxVplmhipal9J5omLOrPIqCV
 2GwyWG2Yj64p4Z3Qvmgmaqo2gWwJ0GelGWn+tmrOIPCD6hbfho
 oLqx50hegoXLQjp57fiMoDXG3iQBhU7IiVzUKkw9HfyVhovSJV
 C4DpYlVrBZp3zkkZH941sFzvD1M9D39Lj93cyWQCXA8RTcfiQA
 MRAs6byTYkJgOASZmvNM8mrSXYHkm6vB654e8z6wORqRE4kfZt
 qHgeMhchXkZsq2kK0IQ6szwC02D7hUYk61YwhLxCMZCPoiscBq
 YhK27k8OxNNlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

I'm not completely sure about this patch, and it will
probably require some arch/sh changes to go along with it,
but it's clear that something has to be done to avoid
getting hundreds of new warnings on each shmobile build
in v3.7.
Please see this as a prototype.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/sh/intc/access.c    |   56 +++++++++++++++++++++----------------------
 drivers/sh/intc/chip.c      |    8 +++----
 drivers/sh/intc/core.c      |    6 +++--
 drivers/sh/intc/handle.c    |    6 ++---
 drivers/sh/intc/internals.h |   18 +++++++-------
 drivers/sh/intc/virq.c      |    3 ++-
 include/linux/sh_clk.h      |    4 ++--
 7 files changed, 52 insertions(+), 49 deletions(-)

diff --git a/drivers/sh/intc/access.c b/drivers/sh/intc/access.c
index f892ae1..5bd0a56 100644
--- a/drivers/sh/intc/access.c
+++ b/drivers/sh/intc/access.c
@@ -11,7 +11,7 @@
 #include <linux/io.h>
 #include "internals.h"
 
-unsigned long intc_phys_to_virt(struct intc_desc_int *d, unsigned long address)
+void __iomem *intc_phys_to_virt(struct intc_desc_int *d, unsigned long address)
 {
 	struct intc_window *window;
 	int k;
@@ -27,23 +27,23 @@ unsigned long intc_phys_to_virt(struct intc_desc_int *d, unsigned long address)
 			continue;
 
 		address -= window->phys;
-		address += (unsigned long)window->virt;
 
-		return address;
+		return window->virt + address;
 	}
 
 	/* no windows defined, register must be 1:1 mapped virt:phys */
-	return address;
+	return (void __iomem *)address;
 }
 
 unsigned int intc_get_reg(struct intc_desc_int *d, unsigned long address)
 {
 	unsigned int k;
+	void __iomem *virt;
 
-	address = intc_phys_to_virt(d, address);
+	virt = intc_phys_to_virt(d, address);
 
 	for (k = 0; k < d->nr_reg; k++) {
-		if (d->reg[k] == address)
+		if (d->reg[k] == virt)
 			return k;
 	}
 
@@ -72,25 +72,25 @@ unsigned long intc_get_field_from_handle(unsigned int value, unsigned int handle
 	return (value & mask) >> shift;
 }
 
-static unsigned long test_8(unsigned long addr, unsigned long h,
+static unsigned long test_8(void __iomem * addr, unsigned long h,
 			    unsigned long ignore)
 {
 	return intc_get_field_from_handle(__raw_readb(addr), h);
 }
 
-static unsigned long test_16(unsigned long addr, unsigned long h,
+static unsigned long test_16(void __iomem * addr, unsigned long h,
 			     unsigned long ignore)
 {
 	return intc_get_field_from_handle(__raw_readw(addr), h);
 }
 
-static unsigned long test_32(unsigned long addr, unsigned long h,
+static unsigned long test_32(void __iomem * addr, unsigned long h,
 			     unsigned long ignore)
 {
 	return intc_get_field_from_handle(__raw_readl(addr), h);
 }
 
-static unsigned long write_8(unsigned long addr, unsigned long h,
+static unsigned long write_8(void __iomem * addr, unsigned long h,
 			     unsigned long data)
 {
 	__raw_writeb(intc_set_field_from_handle(0, data, h), addr);
@@ -98,7 +98,7 @@ static unsigned long write_8(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long write_16(unsigned long addr, unsigned long h,
+static unsigned long write_16(void __iomem * addr, unsigned long h,
 			      unsigned long data)
 {
 	__raw_writew(intc_set_field_from_handle(0, data, h), addr);
@@ -106,7 +106,7 @@ static unsigned long write_16(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long write_32(unsigned long addr, unsigned long h,
+static unsigned long write_32(void __iomem * addr, unsigned long h,
 			      unsigned long data)
 {
 	__raw_writel(intc_set_field_from_handle(0, data, h), addr);
@@ -114,7 +114,7 @@ static unsigned long write_32(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long modify_8(unsigned long addr, unsigned long h,
+static unsigned long modify_8(void __iomem * addr, unsigned long h,
 			      unsigned long data)
 {
 	unsigned long flags;
@@ -127,7 +127,7 @@ static unsigned long modify_8(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long modify_16(unsigned long addr, unsigned long h,
+static unsigned long modify_16(void __iomem * addr, unsigned long h,
 			       unsigned long data)
 {
 	unsigned long flags;
@@ -140,7 +140,7 @@ static unsigned long modify_16(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long modify_32(unsigned long addr, unsigned long h,
+static unsigned long modify_32(void __iomem * addr, unsigned long h,
 			       unsigned long data)
 {
 	unsigned long flags;
@@ -153,9 +153,9 @@ static unsigned long modify_32(unsigned long addr, unsigned long h,
 	return 0;
 }
 
-static unsigned long intc_mode_field(unsigned long addr,
+static unsigned long intc_mode_field(void __iomem * addr,
 				     unsigned long handle,
-				     unsigned long (*fn)(unsigned long,
+				     unsigned long (*fn)(void __iomem *addr,
 						unsigned long,
 						unsigned long),
 				     unsigned int irq)
@@ -163,9 +163,9 @@ static unsigned long intc_mode_field(unsigned long addr,
 	return fn(addr, handle, ((1 << _INTC_WIDTH(handle)) - 1));
 }
 
-static unsigned long intc_mode_zero(unsigned long addr,
+static unsigned long intc_mode_zero(void __iomem * addr,
 				    unsigned long handle,
-				    unsigned long (*fn)(unsigned long,
+				    unsigned long (*fn)(void __iomem *addr,
 					       unsigned long,
 					       unsigned long),
 				    unsigned int irq)
@@ -173,9 +173,9 @@ static unsigned long intc_mode_zero(unsigned long addr,
 	return fn(addr, handle, 0);
 }
 
-static unsigned long intc_mode_prio(unsigned long addr,
+static unsigned long intc_mode_prio(void __iomem * addr,
 				    unsigned long handle,
-				    unsigned long (*fn)(unsigned long,
+				    unsigned long (*fn)(void __iomem *addr,
 					       unsigned long,
 					       unsigned long),
 				    unsigned int irq)
@@ -183,7 +183,7 @@ static unsigned long intc_mode_prio(unsigned long addr,
 	return fn(addr, handle, intc_get_prio_level(irq));
 }
 
-unsigned long (*intc_reg_fns[])(unsigned long addr,
+unsigned long (*intc_reg_fns[])(void __iomem * addr,
 				unsigned long h,
 				unsigned long data) = {
 	[REG_FN_TEST_BASE + 0] = test_8,
@@ -197,9 +197,9 @@ unsigned long (*intc_reg_fns[])(unsigned long addr,
 	[REG_FN_MODIFY_BASE + 3] = modify_32,
 };
 
-unsigned long (*intc_enable_fns[])(unsigned long addr,
+unsigned long (*intc_enable_fns[])(void __iomem * addr,
 				   unsigned long handle,
-				   unsigned long (*fn)(unsigned long,
+				   unsigned long (*fn)(void __iomem *,
 					    unsigned long,
 					    unsigned long),
 				   unsigned int irq) = {
@@ -210,9 +210,9 @@ unsigned long (*intc_enable_fns[])(unsigned long addr,
 	[MODE_PCLR_REG] = intc_mode_prio,
 };
 
-unsigned long (*intc_disable_fns[])(unsigned long addr,
+unsigned long (*intc_disable_fns[])(void __iomem * addr,
 				    unsigned long handle,
-				    unsigned long (*fn)(unsigned long,
+				    unsigned long (*fn)(void __iomem *,
 					     unsigned long,
 					     unsigned long),
 				    unsigned int irq) = {
@@ -223,9 +223,9 @@ unsigned long (*intc_disable_fns[])(unsigned long addr,
 	[MODE_PCLR_REG] = intc_mode_field,
 };
 
-unsigned long (*intc_enable_noprio_fns[])(unsigned long addr,
+unsigned long (*intc_enable_noprio_fns[])(void __iomem * addr,
 					  unsigned long handle,
-					  unsigned long (*fn)(unsigned long,
+					  unsigned long (*fn)(void __iomem *,
 						unsigned long,
 						unsigned long),
 					  unsigned int irq) = {
diff --git a/drivers/sh/intc/chip.c b/drivers/sh/intc/chip.c
index 012df26..2928264 100644
--- a/drivers/sh/intc/chip.c
+++ b/drivers/sh/intc/chip.c
@@ -17,7 +17,7 @@ void _intc_enable(struct irq_data *data, unsigned long handle)
 {
 	unsigned int irq = data->irq;
 	struct intc_desc_int *d = get_intc_desc(irq);
-	unsigned long addr;
+	void __iomem *addr;
 	unsigned int cpu;
 
 	for (cpu = 0; cpu < SMP_NR(d, _INTC_ADDR_E(handle)); cpu++) {
@@ -43,7 +43,7 @@ static void intc_disable(struct irq_data *data)
 	unsigned int irq = data->irq;
 	struct intc_desc_int *d = get_intc_desc(irq);
 	unsigned long handle = (unsigned long)irq_data_get_irq_chip_data(data);
-	unsigned long addr;
+	void __iomem *addr;
 	unsigned int cpu;
 
 	intc_balancing_disable(irq);
@@ -83,7 +83,7 @@ static void intc_mask_ack(struct irq_data *data)
 	unsigned int irq = data->irq;
 	struct intc_desc_int *d = get_intc_desc(irq);
 	unsigned long handle = intc_get_ack_handle(irq);
-	unsigned long addr;
+	void __iomem * addr;
 
 	intc_disable(data);
 
@@ -177,7 +177,7 @@ static int intc_set_type(struct irq_data *data, unsigned int type)
 	struct intc_desc_int *d = get_intc_desc(irq);
 	unsigned char value = intc_irq_sense_table[type & IRQ_TYPE_SENSE_MASK];
 	struct intc_handle_int *ihp;
-	unsigned long addr;
+	void __iomem *addr;
 
 	if (!value)
 		return -EINVAL;
diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 32c26d7..1ddbba0 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -172,10 +172,12 @@ static unsigned int __init save_reg(struct intc_desc_int *d,
 				    unsigned long value,
 				    unsigned int smp)
 {
+	void __iomem *virt;
+
 	if (value) {
-		value = intc_phys_to_virt(d, value);
+		virt = intc_phys_to_virt(d, value);
 
-		d->reg[cnt] = value;
+		d->reg[cnt] = virt;
 #ifdef CONFIG_SMP
 		d->smp[cnt] = smp;
 #endif
diff --git a/drivers/sh/intc/handle.c b/drivers/sh/intc/handle.c
index 7863a44..1971ef1 100644
--- a/drivers/sh/intc/handle.c
+++ b/drivers/sh/intc/handle.c
@@ -206,10 +206,10 @@ static unsigned int intc_ack_data(struct intc_desc *desc,
 static void intc_enable_disable(struct intc_desc_int *d,
 				unsigned long handle, int do_enable)
 {
-	unsigned long addr;
+	void __iomem *addr;
 	unsigned int cpu;
-	unsigned long (*fn)(unsigned long, unsigned long,
-		   unsigned long (*)(unsigned long, unsigned long,
+	unsigned long(*fn)(void __iomem *, unsigned long,
+		   unsigned long (*)(void __iomem *, unsigned long,
 				     unsigned long),
 		   unsigned int);
 
diff --git a/drivers/sh/intc/internals.h b/drivers/sh/intc/internals.h
index 7dff08e..29e4299 100644
--- a/drivers/sh/intc/internals.h
+++ b/drivers/sh/intc/internals.h
@@ -56,7 +56,7 @@ struct intc_desc_int {
 	struct radix_tree_root tree;
 	raw_spinlock_t lock;
 	unsigned int index;
-	unsigned long *reg;
+	void * __iomem *reg;
 #ifdef CONFIG_SMP
 	unsigned long *smp;
 #endif
@@ -120,25 +120,25 @@ static inline int intc_handle_int_cmp(const void *a, const void *b)
 
 /* access.c */
 extern unsigned long
-(*intc_reg_fns[])(unsigned long addr, unsigned long h, unsigned long data);
+(*intc_reg_fns[])(void __iomem * addr, unsigned long h, unsigned long data);
 
 extern unsigned long
-(*intc_enable_fns[])(unsigned long addr, unsigned long handle,
-		     unsigned long (*fn)(unsigned long,
+(*intc_enable_fns[])(void __iomem * addr, unsigned long handle,
+		     unsigned long (*fn)(void __iomem *,
 				unsigned long, unsigned long),
 		     unsigned int irq);
 extern unsigned long
-(*intc_disable_fns[])(unsigned long addr, unsigned long handle,
-		      unsigned long (*fn)(unsigned long,
+(*intc_disable_fns[])(void __iomem * addr, unsigned long handle,
+		      unsigned long (*fn)(void __iomem *,
 				unsigned long, unsigned long),
 		      unsigned int irq);
 extern unsigned long
-(*intc_enable_noprio_fns[])(unsigned long addr, unsigned long handle,
-		            unsigned long (*fn)(unsigned long,
+(*intc_enable_noprio_fns[])(void __iomem * addr, unsigned long handle,
+		            unsigned long (*fn)(void __iomem *,
 				unsigned long, unsigned long),
 			    unsigned int irq);
 
-unsigned long intc_phys_to_virt(struct intc_desc_int *d, unsigned long address);
+void __iomem * intc_phys_to_virt(struct intc_desc_int *d, unsigned long address);
 unsigned int intc_get_reg(struct intc_desc_int *d, unsigned long address);
 unsigned int intc_set_field_from_handle(unsigned int value,
 			    unsigned int field_value,
diff --git a/drivers/sh/intc/virq.c b/drivers/sh/intc/virq.c
index f30ac93..d45cfcd 100644
--- a/drivers/sh/intc/virq.c
+++ b/drivers/sh/intc/virq.c
@@ -117,7 +117,8 @@ static void intc_virq_handler(unsigned int irq, struct irq_desc *desc)
 	chip->irq_mask_ack(data);
 
 	for_each_virq(entry, vlist) {
-		unsigned long addr, handle;
+		void __iomem *addr;
+		unsigned long handle;
 
 		handle = (unsigned long)irq_get_handler_data(entry->irq);
 		addr = INTC_REG(d, _INTC_ADDR_E(handle), 0);
diff --git a/include/linux/sh_clk.h b/include/linux/sh_clk.h
index 5091091..6579041 100644
--- a/include/linux/sh_clk.h
+++ b/include/linux/sh_clk.h
@@ -173,7 +173,7 @@ int sh_clk_div4_reparent_register(struct clk *clks, int nr,
 #define SH_CLK_DIV6_EXT(_reg, _flags, _parents,			\
 			_num_parents, _src_shift, _src_width)	\
 {								\
-	.enable_reg = (void __iomem *)_reg,			\
+	.enable_reg = _reg,					\
 	.enable_bit = 0, /* unused */				\
 	.flags = _flags | CLK_MASK_DIV_ON_DISABLE,		\
 	.div_mask = SH_CLK_DIV6_MSK,				\
@@ -186,7 +186,7 @@ int sh_clk_div4_reparent_register(struct clk *clks, int nr,
 #define SH_CLK_DIV6(_parent, _reg, _flags)			\
 {								\
 	.parent		= _parent,				\
-	.enable_reg	= (void __iomem *)_reg,			\
+	.enable_reg	= _reg,					\
 	.enable_bit	= 0,	/* unused */			\
 	.div_mask	= SH_CLK_DIV6_MSK,			\
 	.flags		= _flags | CLK_MASK_DIV_ON_DISABLE,	\
-- 
1.7.10

