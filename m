Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab2EVTV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:21:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33092 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2EVTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:21:54 -0400
Date: Tue, 22 May 2012 21:21:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.5
Message-ID: <20120522192148.GA6475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   HEAD: 0ab711ae6ab0db7696b43c74f9ba9de4d7fc1deb x86/apic: Implement EIO micro-optimization

Most of the changes are about helping virtualized guest kernels 
achieve better performance.

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      x86/apic: Fix UP boot crash
      x86/xen/apic: Add missing #include <xen/xen.h>

Konrad Rzeszutek Wilk (3):
      x86/apic: Replace io_apic_ops with x86_io_apic_ops.
      xen/x86: Implement x86_apic_ops
      Revert "xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'"

Lin Ming (1):
      xen/apic: implement io apic read with hypercall

Michael S. Tsirkin (4):
      x86/apic: Fix typo EIO_ACK -> EOI_ACK and document it
      x86/apic: Use symbolic APIC_EOI_ACK
      x86/apic: Add apic->eoi_write() callback
      x86/apic: Implement EIO micro-optimization

Márton Németh (1):
      x86/apic: Only compile local function if used with !CONFIG_GENERIC_PENDING_IRQ

Shai Fultheim (1):
      x86: Conditionally update time when ack-ing pending irqs


 arch/x86/include/asm/apic.h            | 23 +++++++--
 arch/x86/include/asm/apicdef.h         |  2 +-
 arch/x86/include/asm/io_apic.h         | 35 ++++++++-----
 arch/x86/include/asm/x86_init.h        |  9 +++-
 arch/x86/kernel/apic/apic.c            | 12 +++--
 arch/x86/kernel/apic/apic_flat_64.c    |  2 +
 arch/x86/kernel/apic/apic_noop.c       |  1 +
 arch/x86/kernel/apic/apic_numachip.c   |  1 +
 arch/x86/kernel/apic/bigsmp_32.c       |  1 +
 arch/x86/kernel/apic/es7000_32.c       |  2 +
 arch/x86/kernel/apic/io_apic.c         | 92 ++++++++++------------------------
 arch/x86/kernel/apic/numaq_32.c        |  1 +
 arch/x86/kernel/apic/probe_32.c        |  1 +
 arch/x86/kernel/apic/summit_32.c       |  1 +
 arch/x86/kernel/apic/x2apic_cluster.c  |  1 +
 arch/x86/kernel/apic/x2apic_phys.c     |  1 +
 arch/x86/kernel/apic/x2apic_uv_x.c     |  1 +
 arch/x86/kernel/setup.c                |  3 +-
 arch/x86/kernel/x86_init.c             |  8 +++
 arch/x86/platform/visws/visws_quirks.c |  2 +-
 arch/x86/xen/Makefile                  |  2 +-
 arch/x86/xen/apic.c                    | 33 ++++++++++++
 arch/x86/xen/enlighten.c               |  2 +
 arch/x86/xen/mmu.c                     |  4 +-
 arch/x86/xen/xen-ops.h                 |  4 ++
 25 files changed, 151 insertions(+), 93 deletions(-)
 create mode 100644 arch/x86/xen/apic.c

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d854101..eaff479 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -138,6 +138,11 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 	wrmsr(APIC_BASE_MSR + (reg >> 4), v, 0);
 }
 
+static inline void native_apic_msr_eoi_write(u32 reg, u32 v)
+{
+	wrmsr(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK, 0);
+}
+
 static inline u32 native_apic_msr_read(u32 reg)
 {
 	u64 msr;
@@ -351,6 +356,14 @@ struct apic {
 	/* apic ops */
 	u32 (*read)(u32 reg);
 	void (*write)(u32 reg, u32 v);
+	/*
+	 * ->eoi_write() has the same signature as ->write().
+	 *
+	 * Drivers can support both ->eoi_write() and ->write() by passing the same
+	 * callback value. Kernel can override ->eoi_write() and fall back
+	 * on write for EOI.
+	 */
+	void (*eoi_write)(u32 reg, u32 v);
 	u64 (*icr_read)(void);
 	void (*icr_write)(u32 low, u32 high);
 	void (*wait_icr_idle)(void);
@@ -426,6 +439,11 @@ static inline void apic_write(u32 reg, u32 val)
 	apic->write(reg, val);
 }
 
+static inline void apic_eoi(void)
+{
+	apic->eoi_write(APIC_EOI, APIC_EOI_ACK);
+}
+
 static inline u64 apic_icr_read(void)
 {
 	return apic->icr_read();
@@ -450,6 +468,7 @@ static inline u32 safe_apic_wait_icr_idle(void)
 
 static inline u32 apic_read(u32 reg) { return 0; }
 static inline void apic_write(u32 reg, u32 val) { }
+static inline void apic_eoi(void) { }
 static inline u64 apic_icr_read(void) { return 0; }
 static inline void apic_icr_write(u32 low, u32 high) { }
 static inline void apic_wait_icr_idle(void) { }
@@ -463,9 +482,7 @@ static inline void ack_APIC_irq(void)
 	 * ack_APIC_irq() actually gets compiled as a single instruction
 	 * ... yummie.
 	 */
-
-	/* Docs say use 0 for future compatibility */
-	apic_write(APIC_EOI, 0);
+	apic_eoi();
 }
 
 static inline unsigned default_get_apic_id(unsigned long x)
diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 134bba0..c46bb99 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -37,7 +37,7 @@
 #define		APIC_ARBPRI_MASK	0xFFu
 #define	APIC_PROCPRI	0xA0
 #define	APIC_EOI	0xB0
-#define		APIC_EIO_ACK		0x0
+#define		APIC_EOI_ACK		0x0 /* Docs say 0 for future compat. */
 #define	APIC_RRR	0xC0
 #define	APIC_LDR	0xD0
 #define		APIC_LDR_MASK		(0xFFu << 24)
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 2c4943d..73d8c53 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -5,7 +5,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
-
+#include <asm/x86_init.h>
 /*
  * Intel IO-APIC support for SMP and UP systems.
  *
@@ -21,15 +21,6 @@
 #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
 #define IO_APIC_REDIR_MASKED		(1 << 16)
 
-struct io_apic_ops {
-	void		(*init)  (void);
-	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
-	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
-};
-
-void __init set_io_apic_ops(const struct io_apic_ops *);
-
 /*
  * The structure of the IO-APIC:
  */
@@ -156,7 +147,6 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
@@ -185,12 +175,29 @@ extern void mp_save_irq(struct mpc_intsrc *m);
 
 extern void disable_ioapic_support(void);
 
+extern void __init native_io_apic_init_mappings(void);
+extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
+extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
+extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+
+static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+{
+	return x86_io_apic_ops.read(apic, reg);
+}
+
+static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	x86_io_apic_ops.write(apic, reg, value);
+}
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	x86_io_apic_ops.modify(apic, reg, value);
+}
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static const int timer_through_8259 = 0;
-static inline void ioapic_and_gsi_init(void) { }
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
@@ -212,6 +219,10 @@ static inline int restore_ioapic_entries(void)
 
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
+#define native_io_apic_init_mappings	NULL
+#define native_io_apic_read		NULL
+#define native_io_apic_write		NULL
+#define native_io_apic_modify		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 764b66a..c090af1 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -188,11 +188,18 @@ struct x86_msi_ops {
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
 };
 
+struct x86_io_apic_ops {
+	void		(*init)  (void);
+	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
+	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+};
+
 extern struct x86_init_ops x86_init;
 extern struct x86_cpuinit_ops x86_cpuinit;
 extern struct x86_platform_ops x86_platform;
 extern struct x86_msi_ops x86_msi;
-
+extern struct x86_io_apic_ops x86_io_apic_ops;
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index edc2448..3beab62 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1325,11 +1325,13 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
-			rdtscll(ntsc);
-			max_loops = (cpu_khz << 10) - (ntsc - tsc);
-		} else
-			max_loops--;
+		if (queued) {
+			if (cpu_has_tsc) {
+				rdtscll(ntsc);
+				max_loops = (cpu_khz << 10) - (ntsc - tsc);
+			} else
+				max_loops--;
+		}
 	} while (queued && max_loops > 0);
 	WARN_ON(max_loops <= 0);
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 359b689..0e881c4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -227,6 +227,7 @@ static struct apic apic_flat =  {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
@@ -386,6 +387,7 @@ static struct apic apic_physflat =  {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 634ae6c..a6e4c6e 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -181,6 +181,7 @@ struct apic apic_noop = {
 
 	.read				= noop_apic_read,
 	.write				= noop_apic_write,
+	.eoi_write			= noop_apic_write,
 	.icr_read			= noop_apic_icr_read,
 	.icr_write			= noop_apic_icr_write,
 	.wait_icr_idle			= noop_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 23e7542..6ec6d5d 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -295,6 +295,7 @@ static struct apic apic_numachip __refconst = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 0cdec70..31fbdbf 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -248,6 +248,7 @@ static struct apic apic_bigsmp = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index e42d1d3b9..db4ab1b 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -678,6 +678,7 @@ static struct apic __refdata apic_es7000_cluster = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
@@ -742,6 +743,7 @@ static struct apic __refdata apic_es7000 = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..e245365 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,24 +68,6 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-static void		__init __ioapic_init_mappings(void);
-
-static unsigned int	__io_apic_read  (unsigned int apic, unsigned int reg);
-static void		__io_apic_write (unsigned int apic, unsigned int reg, unsigned int val);
-static void		__io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
-
-static struct io_apic_ops io_apic_ops = {
-	.init	= __ioapic_init_mappings,
-	.read	= __io_apic_read,
-	.write	= __io_apic_write,
-	.modify = __io_apic_modify,
-};
-
-void __init set_io_apic_ops(const struct io_apic_ops *ops)
-{
-	io_apic_ops = *ops;
-}
-
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -313,21 +295,6 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
-{
-	return io_apic_ops.read(apic, reg);
-}
-
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	io_apic_ops.write(apic, reg, value);
-}
-
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	io_apic_ops.modify(apic, reg, value);
-}
-
 
 struct io_apic {
 	unsigned int index;
@@ -349,14 +316,14 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 	writel(vector, &io_apic->eoi);
 }
 
-static unsigned int __io_apic_read(unsigned int apic, unsigned int reg)
+unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -370,7 +337,7 @@ static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int va
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -379,29 +346,6 @@ static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int v
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		unsigned int reg;
-		int pin;
-
-		pin = entry->pin;
-		reg = io_apic_read(entry->apic, 0x10 + pin*2);
-		/* Is the remote IRR bit set? */
-		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
-			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-			return true;
-		}
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-
-	return false;
-}
-
 union entry_union {
 	struct { u32 w1, w2; };
 	struct IO_APIC_route_entry entry;
@@ -2552,6 +2496,29 @@ static void ack_apic_edge(struct irq_data *data)
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
+{
+	struct irq_pin_list *entry;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&ioapic_lock, flags);
+	for_each_irq_pin(entry, cfg->irq_2_pin) {
+		unsigned int reg;
+		int pin;
+
+		pin = entry->pin;
+		reg = io_apic_read(entry->apic, 0x10 + pin*2);
+		/* Is the remote IRR bit set? */
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
+			raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
+	}
+	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return false;
+}
+
 static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
 {
 	/* If we are moving the irq we need to mask it */
@@ -3931,12 +3898,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	return res;
 }
 
-void __init ioapic_and_gsi_init(void)
-{
-	io_apic_ops.init();
-}
-
-static void __init __ioapic_init_mappings(void)
+void __init native_io_apic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 00d2422..f00a68c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -530,6 +530,7 @@ static struct apic __refdata apic_numaq = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index ff2c1b9..1b291da 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -142,6 +142,7 @@ static struct apic apic_default = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index fea000b..659897c 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -546,6 +546,7 @@ static struct apic apic_summit = {
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
+	.eoi_write			= native_apic_mem_write,
 	.icr_read			= native_apic_icr_read,
 	.icr_write			= native_apic_icr_write,
 	.wait_icr_idle			= native_apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 48f3103..ff35cff 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -260,6 +260,7 @@ static struct apic apic_x2apic_cluster = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 991e315..c17e982 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -172,6 +172,7 @@ static struct apic apic_x2apic_phys = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 87bfa69..c6d03f7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -404,6 +404,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.read				= native_apic_msr_read,
 	.write				= native_apic_msr_write,
+	.eoi_write			= native_apic_msr_eoi_write,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..7e67c5a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1012,7 +1012,8 @@ void __init setup_arch(char **cmdline_p)
 	init_cpu_to_node();
 
 	init_apic_mappings();
-	ioapic_and_gsi_init();
+	if (x86_io_apic_ops.init)
+		x86_io_apic_ops.init();
 
 	kvm_guest_init();
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9cf71d0..35c5e54 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -18,6 +18,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/io_apic.h>
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
@@ -119,3 +120,10 @@ struct x86_msi_ops x86_msi = {
 	.teardown_msi_irqs = default_teardown_msi_irqs,
 	.restore_msi_irqs = default_restore_msi_irqs,
 };
+
+struct x86_io_apic_ops x86_io_apic_ops = {
+	.init	= native_io_apic_init_mappings,
+	.read	= native_io_apic_read,
+	.write	= native_io_apic_write,
+	.modify	= native_io_apic_modify,
+};
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index c7abf13..94d8a39 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -445,7 +445,7 @@ static void ack_cobalt_irq(struct irq_data *data)
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	disable_cobalt_irq(data);
-	apic_write(APIC_EOI, APIC_EIO_ACK);
+	apic_write(APIC_EOI, APIC_EOI_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index add2c2d..96ab2c0 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -20,5 +20,5 @@ obj-$(CONFIG_EVENT_TRACING) += trace.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
-obj-$(CONFIG_XEN_DOM0)		+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
new file mode 100644
index 0000000..ec57bd3
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,33 @@
+#include <linux/init.h>
+
+#include <asm/x86_init.h>
+#include <asm/apic.h>
+#include <asm/xen/hypercall.h>
+
+#include <xen/xen.h>
+#include <xen/interface/physdev.h>
+
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+{
+	struct physdev_apic apic_op;
+	int ret;
+
+	apic_op.apic_physbase = mpc_ioapic_addr(apic);
+	apic_op.reg = reg;
+	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
+	if (!ret)
+		return apic_op.value;
+
+	/* fallback to return an emulated IO_APIC values */
+	if (reg == 0x1)
+		return 0x00170020;
+	else if (reg == 0x0)
+		return apic << 24;
+
+	return 0xfd;
+}
+
+void __init xen_init_apic(void)
+{
+	x86_io_apic_ops.read = xen_io_apic_read;
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a8f8844..c2ea9e9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1362,6 +1362,8 @@ asmlinkage void __init xen_start_kernel(void)
 		xen_start_info->console.domU.mfn = 0;
 		xen_start_info->console.domU.evtchn = 0;
 
+		xen_init_apic();
+
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b8e2794..988828b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1859,7 +1859,6 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 #endif	/* CONFIG_X86_64 */
 
 static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
-static unsigned char fake_ioapic_mapping[PAGE_SIZE] __page_aligned_bss;
 
 static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
@@ -1900,7 +1899,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		 * We just don't map the IO APIC - all access is via
 		 * hypercalls.  Keep the address in the pte for reference.
 		 */
-		pte = pfn_pte(PFN_DOWN(__pa(fake_ioapic_mapping)), PAGE_KERNEL);
+		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
 		break;
 #endif
 
@@ -2065,7 +2064,6 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-	memset(fake_ioapic_mapping, 0xfd, PAGE_SIZE);
 }
 
 /* Protected by xen_reservation_lock. */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index b095739..45c0c06 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -92,11 +92,15 @@ struct dom0_vga_console_info;
 
 #ifdef CONFIG_XEN_DOM0
 void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+void __init xen_init_apic(void);
 #else
 static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
 				       size_t size)
 {
 }
+static inline void __init xen_init_apic(void)
+{
+}
 #endif
 
 /* Declare an asm function, along with symbols needed to make it
