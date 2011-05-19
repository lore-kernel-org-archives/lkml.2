Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265Ab1ESUG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:06:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933670Ab1ESUGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:06:24 -0400
Date: Thu, 19 May 2011 22:06:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/iommu updates for v2.6.40
Message-ID: <20110519200610.GA4626@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Joe Perches (1):
      arch/x86/kernel/pci-iommu_table.c: Convert sprintf_symbol to %pS

Joerg Roedel (18):
      x86/amd-iommu: Move compl-wait command building to own function
      x86/amd-iommu: Move inv-dte command building to own function
      x86/amd-iommu: Cleanup inv_pages command handling
      x86/amd-iommu: Cleanup completion-wait handling
      x86/amd-iommu: Remove command buffer resetting logic
      x86/amd-iommu: Rename iommu_flush* to domain_flush*
      x86/amd-iommu: Improve handling of full command buffer
      x86/amd-iommu: Rename iommu_flush_device
      x86/amd-iommu: Flush all internal TLBs when IOMMUs are enabled
      PCI: Move ATS declarations in seperate header file
      x86/amd-iommu: Select PCI_IOV with AMD IOMMU driver
      x86/amd-iommu: Flush device IOTLB if ATS is enabled
      x86/amd-iommu: Add flag to indicate IOTLB support
      x86/amd-iommu: Add ATS enable/disable code
      x86/amd-iommu: Add extended feature detection
      x86/amd-iommu: Add support for invalidate_all command
      x86/amd-iommu: Use threaded interupt handler
      x86, gart: Rename pci-gart_64.c to amd_gart_64.c

Stanislaw Gruszka (1):
      dma-debug: print information about leaked entry


 Documentation/x86/x86_64/boot-options.txt        |    2 +-
 arch/x86/Kconfig                                 |    1 +
 arch/x86/include/asm/amd_iommu_proto.h           |   13 +-
 arch/x86/include/asm/amd_iommu_types.h           |   28 +-
 arch/x86/kernel/Makefile                         |    2 +-
 arch/x86/kernel/{pci-gart_64.c => amd_gart_64.c} |    0
 arch/x86/kernel/amd_iommu.c                      |  526 +++++++++++++---------
 arch/x86/kernel/amd_iommu_init.c                 |   48 ++-
 arch/x86/kernel/pci-iommu_table.c                |   18 +-
 drivers/pci/intel-iommu.c                        |    1 +
 drivers/pci/iov.c                                |    1 +
 drivers/pci/pci.h                                |   37 --
 include/linux/pci-ats.h                          |   52 +++
 lib/dma-debug.c                                  |   18 +-
 14 files changed, 456 insertions(+), 291 deletions(-)
 rename arch/x86/kernel/{pci-gart_64.c => amd_gart_64.c} (100%)
 create mode 100644 include/linux/pci-ats.h

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 092e596..c54b4f5 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -206,7 +206,7 @@ IOMMU (input/output memory management unit)
       (e.g. because you have < 3 GB memory).
       Kernel boot message: "PCI-DMA: Disabling IOMMU"
 
-   2. <arch/x86_64/kernel/pci-gart.c>: AMD GART based hardware IOMMU.
+   2. <arch/x86/kernel/amd_gart_64.c>: AMD GART based hardware IOMMU.
       Kernel boot message: "PCI-DMA: using GART IOMMU"
 
    3. <arch/x86_64/kernel/pci-swiotlb.c> : Software IOMMU implementation. Used
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..8cc29da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -690,6 +690,7 @@ config AMD_IOMMU
 	bool "AMD IOMMU support"
 	select SWIOTLB
 	select PCI_MSI
+	select PCI_IOV
 	depends on X86_64 && PCI && ACPI
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 916bc81..55d95eb 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -19,13 +19,12 @@
 #ifndef _ASM_X86_AMD_IOMMU_PROTO_H
 #define _ASM_X86_AMD_IOMMU_PROTO_H
 
-struct amd_iommu;
+#include <asm/amd_iommu_types.h>
 
 extern int amd_iommu_init_dma_ops(void);
 extern int amd_iommu_init_passthrough(void);
+extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
-extern void amd_iommu_flush_all_domains(void);
-extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_apply_erratum_63(u16 devid);
 extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
@@ -44,4 +43,12 @@ static inline bool is_rd890_iommu(struct pci_dev *pdev)
 	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
 }
 
+static inline bool iommu_feature(struct amd_iommu *iommu, u64 f)
+{
+	if (!(iommu->cap & (1 << IOMMU_CAP_EFR)))
+		return false;
+
+	return !!(iommu->features & f);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index e3509fc..4c99829 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -68,12 +68,25 @@
 #define MMIO_CONTROL_OFFSET     0x0018
 #define MMIO_EXCL_BASE_OFFSET   0x0020
 #define MMIO_EXCL_LIMIT_OFFSET  0x0028
+#define MMIO_EXT_FEATURES	0x0030
 #define MMIO_CMD_HEAD_OFFSET	0x2000
 #define MMIO_CMD_TAIL_OFFSET	0x2008
 #define MMIO_EVT_HEAD_OFFSET	0x2010
 #define MMIO_EVT_TAIL_OFFSET	0x2018
 #define MMIO_STATUS_OFFSET	0x2020
 
+
+/* Extended Feature Bits */
+#define FEATURE_PREFETCH	(1ULL<<0)
+#define FEATURE_PPR		(1ULL<<1)
+#define FEATURE_X2APIC		(1ULL<<2)
+#define FEATURE_NX		(1ULL<<3)
+#define FEATURE_GT		(1ULL<<4)
+#define FEATURE_IA		(1ULL<<6)
+#define FEATURE_GA		(1ULL<<7)
+#define FEATURE_HE		(1ULL<<8)
+#define FEATURE_PC		(1ULL<<9)
+
 /* MMIO status bits */
 #define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
 
@@ -113,7 +126,9 @@
 /* command specific defines */
 #define CMD_COMPL_WAIT          0x01
 #define CMD_INV_DEV_ENTRY       0x02
-#define CMD_INV_IOMMU_PAGES     0x03
+#define CMD_INV_IOMMU_PAGES	0x03
+#define CMD_INV_IOTLB_PAGES	0x04
+#define CMD_INV_ALL		0x08
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
 #define CMD_COMPL_WAIT_INT_MASK		0x02
@@ -215,6 +230,8 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
+#define DTE_FLAG_IOTLB	0x01
+
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
 #define IOMMU_PTE_PAGE(pte) (phys_to_virt((pte) & IOMMU_PAGE_MASK))
@@ -227,6 +244,7 @@
 /* IOMMU capabilities */
 #define IOMMU_CAP_IOTLB   24
 #define IOMMU_CAP_NPCACHE 26
+#define IOMMU_CAP_EFR     27
 
 #define MAX_DOMAIN_ID 65536
 
@@ -249,6 +267,8 @@ extern bool amd_iommu_dump;
 
 /* global flag if IOMMUs cache non-present entries */
 extern bool amd_iommu_np_cache;
+/* Only true if all IOMMUs support device IOTLBs */
+extern bool amd_iommu_iotlb_sup;
 
 /*
  * Make iterating over all IOMMUs easier
@@ -371,6 +391,9 @@ struct amd_iommu {
 	/* flags read from acpi table */
 	u8 acpi_flags;
 
+	/* Extended features */
+	u64 features;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -409,9 +432,6 @@ struct amd_iommu {
 	/* if one, we need to send a completion wait command */
 	bool need_sync;
 
-	/* becomes true if a command buffer reset is running */
-	bool reset_in_progress;
-
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7338ef2..97ebf82e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -117,7 +117,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_AUDIT)		+= audit_64.o
 
-	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
+	obj-$(CONFIG_GART_IOMMU)	+= amd_gart_64.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/amd_gart_64.c
similarity index 100%
rename from arch/x86/kernel/pci-gart_64.c
rename to arch/x86/kernel/amd_gart_64.c
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 57ca777..873e7e1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/pci-ats.h>
 #include <linux/bitmap.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
@@ -25,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu-helper.h>
 #include <linux/iommu.h>
+#include <linux/delay.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
@@ -34,7 +36,7 @@
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
-#define EXIT_LOOP_COUNT 10000000
+#define LOOP_TIMEOUT	100000
 
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
@@ -57,7 +59,6 @@ struct iommu_cmd {
 	u32 data[4];
 };
 
-static void reset_iommu_command_buffer(struct amd_iommu *iommu);
 static void update_domain(struct protection_domain *domain);
 
 /****************************************************************************
@@ -322,8 +323,6 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		break;
 	case EVENT_TYPE_ILL_CMD:
 		printk("ILLEGAL_COMMAND_ERROR address=0x%016llx]\n", address);
-		iommu->reset_in_progress = true;
-		reset_iommu_command_buffer(iommu);
 		dump_command(address);
 		break;
 	case EVENT_TYPE_CMD_HARD_ERR:
@@ -367,7 +366,7 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-irqreturn_t amd_iommu_int_handler(int irq, void *data)
+irqreturn_t amd_iommu_int_thread(int irq, void *data)
 {
 	struct amd_iommu *iommu;
 
@@ -377,192 +376,300 @@ irqreturn_t amd_iommu_int_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+irqreturn_t amd_iommu_int_handler(int irq, void *data)
+{
+	return IRQ_WAKE_THREAD;
+}
+
 /****************************************************************************
  *
  * IOMMU command queuing functions
  *
  ****************************************************************************/
 
-/*
- * Writes the command to the IOMMUs command buffer and informs the
- * hardware about the new command. Must be called with iommu->lock held.
- */
-static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
+static int wait_on_sem(volatile u64 *sem)
+{
+	int i = 0;
+
+	while (*sem == 0 && i < LOOP_TIMEOUT) {
+		udelay(1);
+		i += 1;
+	}
+
+	if (i == LOOP_TIMEOUT) {
+		pr_alert("AMD-Vi: Completion-Wait loop timed out\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void copy_cmd_to_buffer(struct amd_iommu *iommu,
+			       struct iommu_cmd *cmd,
+			       u32 tail)
 {
-	u32 tail, head;
 	u8 *target;
 
-	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
-	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 	target = iommu->cmd_buf + tail;
-	memcpy_toio(target, cmd, sizeof(*cmd));
-	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
-	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
-	if (tail == head)
-		return -ENOMEM;
+	tail   = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
+
+	/* Copy command to buffer */
+	memcpy(target, cmd, sizeof(*cmd));
+
+	/* Tell the IOMMU about it */
 	writel(tail, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+}
 
-	return 0;
+static void build_completion_wait(struct iommu_cmd *cmd, u64 address)
+{
+	WARN_ON(address & 0x7ULL);
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = lower_32_bits(__pa(address)) | CMD_COMPL_WAIT_STORE_MASK;
+	cmd->data[1] = upper_32_bits(__pa(address));
+	cmd->data[2] = 1;
+	CMD_SET_TYPE(cmd, CMD_COMPL_WAIT);
+}
+
+static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0] = devid;
+	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);
+}
+
+static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
+				  size_t size, u16 domid, int pde)
+{
+	u64 pages;
+	int s;
+
+	pages = iommu_num_pages(address, size, PAGE_SIZE);
+	s     = 0;
+
+	if (pages > 1) {
+		/*
+		 * If we have to flush more than one page, flush all
+		 * TLB entries for this domain
+		 */
+		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		s = 1;
+	}
+
+	address &= PAGE_MASK;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[1] |= domid;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[3]  = upper_32_bits(address);
+	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
+	if (s) /* size bit - we flush more than one 4kb page */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+}
+
+static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
+				  u64 address, size_t size)
+{
+	u64 pages;
+	int s;
+
+	pages = iommu_num_pages(address, size, PAGE_SIZE);
+	s     = 0;
+
+	if (pages > 1) {
+		/*
+		 * If we have to flush more than one page, flush all
+		 * TLB entries for this domain
+		 */
+		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		s = 1;
+	}
+
+	address &= PAGE_MASK;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[0]  = devid;
+	cmd->data[0] |= (qdep & 0xff) << 24;
+	cmd->data[1]  = devid;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[3]  = upper_32_bits(address);
+	CMD_SET_TYPE(cmd, CMD_INV_IOTLB_PAGES);
+	if (s)
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+}
+
+static void build_inv_all(struct iommu_cmd *cmd)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	CMD_SET_TYPE(cmd, CMD_INV_ALL);
 }
 
 /*
- * General queuing function for commands. Takes iommu->lock and calls
- * __iommu_queue_command().
+ * Writes the command to the IOMMUs command buffer and informs the
+ * hardware about the new command.
  */
 static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 {
+	u32 left, tail, head, next_tail;
 	unsigned long flags;
-	int ret;
 
+	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
+
+again:
 	spin_lock_irqsave(&iommu->lock, flags);
-	ret = __iommu_queue_command(iommu, cmd);
-	if (!ret)
-		iommu->need_sync = true;
-	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	return ret;
-}
+	head      = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	tail      = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+	next_tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
+	left      = (head - next_tail) % iommu->cmd_buf_size;
 
-/*
- * This function waits until an IOMMU has completed a completion
- * wait command
- */
-static void __iommu_wait_for_completion(struct amd_iommu *iommu)
-{
-	int ready = 0;
-	unsigned status = 0;
-	unsigned long i = 0;
+	if (left <= 2) {
+		struct iommu_cmd sync_cmd;
+		volatile u64 sem = 0;
+		int ret;
 
-	INC_STATS_COUNTER(compl_wait);
+		build_completion_wait(&sync_cmd, (u64)&sem);
+		copy_cmd_to_buffer(iommu, &sync_cmd, tail);
 
-	while (!ready && (i < EXIT_LOOP_COUNT)) {
-		++i;
-		/* wait for the bit to become one */
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
+		spin_unlock_irqrestore(&iommu->lock, flags);
+
+		if ((ret = wait_on_sem(&sem)) != 0)
+			return ret;
+
+		goto again;
 	}
 
-	/* set bit back to zero */
-	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
-	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
+	copy_cmd_to_buffer(iommu, cmd, tail);
+
+	/* We need to sync now to make sure all commands are processed */
+	iommu->need_sync = true;
+
+	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	if (unlikely(i == EXIT_LOOP_COUNT))
-		iommu->reset_in_progress = true;
+	return 0;
 }
 
 /*
  * This function queues a completion wait command into the command
  * buffer of an IOMMU
  */
-static int __iommu_completion_wait(struct amd_iommu *iommu)
+static int iommu_completion_wait(struct amd_iommu *iommu)
 {
 	struct iommu_cmd cmd;
+	volatile u64 sem = 0;
+	int ret;
 
-	 memset(&cmd, 0, sizeof(cmd));
-	 cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
-	 CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
+	if (!iommu->need_sync)
+		return 0;
 
-	 return __iommu_queue_command(iommu, &cmd);
+	build_completion_wait(&cmd, (u64)&sem);
+
+	ret = iommu_queue_command(iommu, &cmd);
+	if (ret)
+		return ret;
+
+	return wait_on_sem(&sem);
 }
 
-/*
- * This function is called whenever we need to ensure that the IOMMU has
- * completed execution of all commands we sent. It sends a
- * COMPLETION_WAIT command and waits for it to finish. The IOMMU informs
- * us about that by writing a value to a physical address we pass with
- * the command.
- */
-static int iommu_completion_wait(struct amd_iommu *iommu)
+static int iommu_flush_dte(struct amd_iommu *iommu, u16 devid)
 {
-	int ret = 0;
-	unsigned long flags;
+	struct iommu_cmd cmd;
 
-	spin_lock_irqsave(&iommu->lock, flags);
+	build_inv_dte(&cmd, devid);
 
-	if (!iommu->need_sync)
-		goto out;
+	return iommu_queue_command(iommu, &cmd);
+}
 
-	ret = __iommu_completion_wait(iommu);
+static void iommu_flush_dte_all(struct amd_iommu *iommu)
+{
+	u32 devid;
 
-	iommu->need_sync = false;
+	for (devid = 0; devid <= 0xffff; ++devid)
+		iommu_flush_dte(iommu, devid);
 
-	if (ret)
-		goto out;
-
-	__iommu_wait_for_completion(iommu);
+	iommu_completion_wait(iommu);
+}
 
-out:
-	spin_unlock_irqrestore(&iommu->lock, flags);
+/*
+ * This function uses heavy locking and may disable irqs for some time. But
+ * this is no issue because it is only called during resume.
+ */
+static void iommu_flush_tlb_all(struct amd_iommu *iommu)
+{
+	u32 dom_id;
 
-	if (iommu->reset_in_progress)
-		reset_iommu_command_buffer(iommu);
+	for (dom_id = 0; dom_id <= 0xffff; ++dom_id) {
+		struct iommu_cmd cmd;
+		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+				      dom_id, 1);
+		iommu_queue_command(iommu, &cmd);
+	}
 
-	return 0;
+	iommu_completion_wait(iommu);
 }
 
-static void iommu_flush_complete(struct protection_domain *domain)
+static void iommu_flush_all(struct amd_iommu *iommu)
 {
-	int i;
+	struct iommu_cmd cmd;
 
-	for (i = 0; i < amd_iommus_present; ++i) {
-		if (!domain->dev_iommu[i])
-			continue;
+	build_inv_all(&cmd);
 
-		/*
-		 * Devices of this domain are behind this IOMMU
-		 * We need to wait for completion of all commands.
-		 */
-		iommu_completion_wait(amd_iommus[i]);
+	iommu_queue_command(iommu, &cmd);
+	iommu_completion_wait(iommu);
+}
+
+void iommu_flush_all_caches(struct amd_iommu *iommu)
+{
+	if (iommu_feature(iommu, FEATURE_IA)) {
+		iommu_flush_all(iommu);
+	} else {
+		iommu_flush_dte_all(iommu);
+		iommu_flush_tlb_all(iommu);
 	}
 }
 
 /*
- * Command send function for invalidating a device table entry
+ * Command send function for flushing on-device TLB
  */
-static int iommu_flush_device(struct device *dev)
+static int device_flush_iotlb(struct device *dev, u64 address, size_t size)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
 	u16 devid;
+	int qdep;
 
+	qdep  = pci_ats_queue_depth(pdev);
 	devid = get_device_id(dev);
 	iommu = amd_iommu_rlookup_table[devid];
 
-	/* Build command */
-	memset(&cmd, 0, sizeof(cmd));
-	CMD_SET_TYPE(&cmd, CMD_INV_DEV_ENTRY);
-	cmd.data[0] = devid;
+	build_inv_iotlb_pages(&cmd, devid, qdep, address, size);
 
 	return iommu_queue_command(iommu, &cmd);
 }
 
-static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
-					  u16 domid, int pde, int s)
-{
-	memset(cmd, 0, sizeof(*cmd));
-	address &= PAGE_MASK;
-	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
-	cmd->data[1] |= domid;
-	cmd->data[2] = lower_32_bits(address);
-	cmd->data[3] = upper_32_bits(address);
-	if (s) /* size bit - we flush more than one 4kb page */
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
-	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
-}
-
 /*
- * Generic command send function for invalidaing TLB entries
+ * Command send function for invalidating a device table entry
  */
-static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
-		u64 address, u16 domid, int pde, int s)
+static int device_flush_dte(struct device *dev)
 {
-	struct iommu_cmd cmd;
+	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	u16 devid;
 	int ret;
 
-	__iommu_build_inv_iommu_pages(&cmd, address, domid, pde, s);
+	pdev  = to_pci_dev(dev);
+	devid = get_device_id(dev);
+	iommu = amd_iommu_rlookup_table[devid];
 
-	ret = iommu_queue_command(iommu, &cmd);
+	ret = iommu_flush_dte(iommu, devid);
+	if (ret)
+		return ret;
+
+	if (pci_ats_enabled(pdev))
+		ret = device_flush_iotlb(dev, 0, ~0UL);
 
 	return ret;
 }
@@ -572,23 +679,14 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
  * It invalidates a single PTE if the range to flush is within a single
  * page. Otherwise it flushes the whole TLB of the IOMMU.
  */
-static void __iommu_flush_pages(struct protection_domain *domain,
-				u64 address, size_t size, int pde)
+static void __domain_flush_pages(struct protection_domain *domain,
+				 u64 address, size_t size, int pde)
 {
-	int s = 0, i;
-	unsigned long pages = iommu_num_pages(address, size, PAGE_SIZE);
-
-	address &= PAGE_MASK;
-
-	if (pages > 1) {
-		/*
-		 * If we have to flush more than one page, flush all
-		 * TLB entries for this domain
-		 */
-		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-		s = 1;
-	}
+	struct iommu_dev_data *dev_data;
+	struct iommu_cmd cmd;
+	int ret = 0, i;
 
+	build_inv_iommu_pages(&cmd, address, size, domain->id, pde);
 
 	for (i = 0; i < amd_iommus_present; ++i) {
 		if (!domain->dev_iommu[i])
@@ -598,101 +696,70 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 		 * Devices of this domain are behind this IOMMU
 		 * We need a TLB flush
 		 */
-		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
-					    domain->id, pde, s);
+		ret |= iommu_queue_command(amd_iommus[i], &cmd);
+	}
+
+	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
+
+		if (!pci_ats_enabled(pdev))
+			continue;
+
+		ret |= device_flush_iotlb(dev_data->dev, address, size);
 	}
 
-	return;
+	WARN_ON(ret);
 }
 
-static void iommu_flush_pages(struct protection_domain *domain,
-			     u64 address, size_t size)
+static void domain_flush_pages(struct protection_domain *domain,
+			       u64 address, size_t size)
 {
-	__iommu_flush_pages(domain, address, size, 0);
+	__domain_flush_pages(domain, address, size, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain */
-static void iommu_flush_tlb(struct protection_domain *domain)
+static void domain_flush_tlb(struct protection_domain *domain)
 {
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
+	__domain_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
-static void iommu_flush_tlb_pde(struct protection_domain *domain)
+static void domain_flush_tlb_pde(struct protection_domain *domain)
 {
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
-}
-
-
-/*
- * This function flushes the DTEs for all devices in domain
- */
-static void iommu_flush_domain_devices(struct protection_domain *domain)
-{
-	struct iommu_dev_data *dev_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&domain->lock, flags);
-
-	list_for_each_entry(dev_data, &domain->dev_list, list)
-		iommu_flush_device(dev_data->dev);
-
-	spin_unlock_irqrestore(&domain->lock, flags);
+	__domain_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
 }
 
-static void iommu_flush_all_domain_devices(void)
+static void domain_flush_complete(struct protection_domain *domain)
 {
-	struct protection_domain *domain;
-	unsigned long flags;
+	int i;
 
-	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
 
-	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		iommu_flush_domain_devices(domain);
-		iommu_flush_complete(domain);
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need to wait for completion of all commands.
+		 */
+		iommu_completion_wait(amd_iommus[i]);
 	}
-
-	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
 }
 
-void amd_iommu_flush_all_devices(void)
-{
-	iommu_flush_all_domain_devices();
-}
 
 /*
- * This function uses heavy locking and may disable irqs for some time. But
- * this is no issue because it is only called during resume.
+ * This function flushes the DTEs for all devices in domain
  */
-void amd_iommu_flush_all_domains(void)
+static void domain_flush_devices(struct protection_domain *domain)
 {
-	struct protection_domain *domain;
+	struct iommu_dev_data *dev_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&amd_iommu_pd_lock, flags);
-
-	list_for_each_entry(domain, &amd_iommu_pd_list, list) {
-		spin_lock(&domain->lock);
-		iommu_flush_tlb_pde(domain);
-		iommu_flush_complete(domain);
-		spin_unlock(&domain->lock);
-	}
-
-	spin_unlock_irqrestore(&amd_iommu_pd_lock, flags);
-}
-
-static void reset_iommu_command_buffer(struct amd_iommu *iommu)
-{
-	pr_err("AMD-Vi: Resetting IOMMU command buffer\n");
-
-	if (iommu->reset_in_progress)
-		panic("AMD-Vi: ILLEGAL_COMMAND_ERROR while resetting command buffer\n");
+	spin_lock_irqsave(&domain->lock, flags);
 
-	amd_iommu_reset_cmd_buffer(iommu);
-	amd_iommu_flush_all_devices();
-	amd_iommu_flush_all_domains();
+	list_for_each_entry(dev_data, &domain->dev_list, list)
+		device_flush_dte(dev_data->dev);
 
-	iommu->reset_in_progress = false;
+	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
 /****************************************************************************
@@ -1410,17 +1477,22 @@ static bool dma_ops_domain(struct protection_domain *domain)
 	return domain->flags & PD_DMA_OPS_MASK;
 }
 
-static void set_dte_entry(u16 devid, struct protection_domain *domain)
+static void set_dte_entry(u16 devid, struct protection_domain *domain, bool ats)
 {
 	u64 pte_root = virt_to_phys(domain->pt_root);
+	u32 flags = 0;
 
 	pte_root |= (domain->mode & DEV_ENTRY_MODE_MASK)
 		    << DEV_ENTRY_MODE_SHIFT;
 	pte_root |= IOMMU_PTE_IR | IOMMU_PTE_IW | IOMMU_PTE_P | IOMMU_PTE_TV;
 
-	amd_iommu_dev_table[devid].data[2] = domain->id;
-	amd_iommu_dev_table[devid].data[1] = upper_32_bits(pte_root);
-	amd_iommu_dev_table[devid].data[0] = lower_32_bits(pte_root);
+	if (ats)
+		flags |= DTE_FLAG_IOTLB;
+
+	amd_iommu_dev_table[devid].data[3] |= flags;
+	amd_iommu_dev_table[devid].data[2]  = domain->id;
+	amd_iommu_dev_table[devid].data[1]  = upper_32_bits(pte_root);
+	amd_iommu_dev_table[devid].data[0]  = lower_32_bits(pte_root);
 }
 
 static void clear_dte_entry(u16 devid)
@@ -1437,34 +1509,42 @@ static void do_attach(struct device *dev, struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
+	bool ats = false;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	pdev     = to_pci_dev(dev);
+
+	if (amd_iommu_iotlb_sup)
+		ats = pci_ats_enabled(pdev);
 
 	/* Update data structures */
 	dev_data->domain = domain;
 	list_add(&dev_data->list, &domain->dev_list);
-	set_dte_entry(devid, domain);
+	set_dte_entry(devid, domain, ats);
 
 	/* Do reference counting */
 	domain->dev_iommu[iommu->index] += 1;
 	domain->dev_cnt                 += 1;
 
 	/* Flush the DTE entry */
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 }
 
 static void do_detach(struct device *dev)
 {
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
+	struct pci_dev *pdev;
 	u16 devid;
 
 	devid    = get_device_id(dev);
 	iommu    = amd_iommu_rlookup_table[devid];
 	dev_data = get_dev_data(dev);
+	pdev     = to_pci_dev(dev);
 
 	/* decrease reference counters */
 	dev_data->domain->dev_iommu[iommu->index] -= 1;
@@ -1476,7 +1556,7 @@ static void do_detach(struct device *dev)
 	clear_dte_entry(devid);
 
 	/* Flush the DTE entry */
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 }
 
 /*
@@ -1539,9 +1619,13 @@ out_unlock:
 static int attach_device(struct device *dev,
 			 struct protection_domain *domain)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long flags;
 	int ret;
 
+	if (amd_iommu_iotlb_sup)
+		pci_enable_ats(pdev, PAGE_SHIFT);
+
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	ret = __attach_device(dev, domain);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
@@ -1551,7 +1635,7 @@ static int attach_device(struct device *dev,
 	 * left the caches in the IOMMU dirty. So we have to flush
 	 * here to evict all dirty stuff.
 	 */
-	iommu_flush_tlb_pde(domain);
+	domain_flush_tlb_pde(domain);
 
 	return ret;
 }
@@ -1598,12 +1682,16 @@ static void __detach_device(struct device *dev)
  */
 static void detach_device(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long flags;
 
 	/* lock device table */
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 	__detach_device(dev);
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	if (amd_iommu_iotlb_sup && pci_ats_enabled(pdev))
+		pci_disable_ats(pdev);
 }
 
 /*
@@ -1692,7 +1780,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		goto out;
 	}
 
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -1753,8 +1841,9 @@ static void update_device_table(struct protection_domain *domain)
 	struct iommu_dev_data *dev_data;
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
+		struct pci_dev *pdev = to_pci_dev(dev_data->dev);
 		u16 devid = get_device_id(dev_data->dev);
-		set_dte_entry(devid, domain);
+		set_dte_entry(devid, domain, pci_ats_enabled(pdev));
 	}
 }
 
@@ -1764,8 +1853,9 @@ static void update_domain(struct protection_domain *domain)
 		return;
 
 	update_device_table(domain);
-	iommu_flush_domain_devices(domain);
-	iommu_flush_tlb_pde(domain);
+
+	domain_flush_devices(domain);
+	domain_flush_tlb_pde(domain);
 
 	domain->updated = false;
 }
@@ -1924,10 +2014,10 @@ retry:
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
-		iommu_flush_tlb(&dma_dom->domain);
+		domain_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
 	} else if (unlikely(amd_iommu_np_cache))
-		iommu_flush_pages(&dma_dom->domain, address, size);
+		domain_flush_pages(&dma_dom->domain, address, size);
 
 out:
 	return address;
@@ -1976,7 +2066,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
+		domain_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
@@ -2012,7 +2102,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 	if (addr == DMA_ERROR_CODE)
 		goto out;
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -2039,7 +2129,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, dir);
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2104,7 +2194,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -2150,7 +2240,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2200,7 +2290,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out_free;
 	}
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2232,7 +2322,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	iommu_flush_complete(domain);
+	domain_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2476,7 +2566,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return;
 
-	iommu_flush_device(dev);
+	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 }
 
@@ -2542,7 +2632,7 @@ static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 	unmap_size = iommu_unmap_page(domain, iova, page_size);
 	mutex_unlock(&domain->api_lock);
 
-	iommu_flush_tlb_pde(domain);
+	domain_flush_tlb_pde(domain);
 
 	return get_order(unmap_size);
 }
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 246d727..9179c21 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -137,6 +137,7 @@ int amd_iommus_present;
 
 /* IOMMUs have a non-present cache? */
 bool amd_iommu_np_cache __read_mostly;
+bool amd_iommu_iotlb_sup __read_mostly = true;
 
 /*
  * The ACPI table parsing functions set this variable on an error
@@ -180,6 +181,12 @@ static u32 dev_table_size;	/* size of the device table */
 static u32 alias_table_size;	/* size of the alias table */
 static u32 rlookup_table_size;	/* size if the rlookup table */
 
+/*
+ * This function flushes all internal caches of
+ * the IOMMU used by this driver.
+ */
+extern void iommu_flush_all_caches(struct amd_iommu *iommu);
+
 static inline void update_last_devid(u16 devid)
 {
 	if (devid > amd_iommu_last_bdf)
@@ -293,9 +300,23 @@ static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 /* Function to enable the hardware */
 static void iommu_enable(struct amd_iommu *iommu)
 {
-	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx\n",
+	static const char * const feat_str[] = {
+		"PreF", "PPR", "X2APIC", "NX", "GT", "[5]",
+		"IA", "GA", "HE", "PC", NULL
+	};
+	int i;
+
+	printk(KERN_INFO "AMD-Vi: Enabling IOMMU at %s cap 0x%hx",
 	       dev_name(&iommu->dev->dev), iommu->cap_ptr);
 
+	if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
+		printk(KERN_CONT " extended features: ");
+		for (i = 0; feat_str[i]; ++i)
+			if (iommu_feature(iommu, (1ULL << i)))
+				printk(KERN_CONT " %s", feat_str[i]);
+	}
+	printk(KERN_CONT "\n");
+
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
@@ -651,7 +672,7 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 {
 	int cap_ptr = iommu->cap_ptr;
-	u32 range, misc;
+	u32 range, misc, low, high;
 	int i, j;
 
 	pci_read_config_dword(iommu->dev, cap_ptr + MMIO_CAP_HDR_OFFSET,
@@ -667,6 +688,15 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 
+	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
+		amd_iommu_iotlb_sup = false;
+
+	/* read extended feature bits */
+	low  = readl(iommu->mmio_base + MMIO_EXT_FEATURES);
+	high = readl(iommu->mmio_base + MMIO_EXT_FEATURES + 4);
+
+	iommu->features = ((u64)high << 32) | low;
+
 	if (!is_rd890_iommu(iommu->dev))
 		return;
 
@@ -1004,10 +1034,11 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 	if (pci_enable_msi(iommu->dev))
 		return 1;
 
-	r = request_irq(iommu->dev->irq, amd_iommu_int_handler,
-			IRQF_SAMPLE_RANDOM,
-			"AMD-Vi",
-			NULL);
+	r = request_threaded_irq(iommu->dev->irq,
+				 amd_iommu_int_handler,
+				 amd_iommu_int_thread,
+				 0, "AMD-Vi",
+				 iommu->dev);
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
@@ -1244,6 +1275,7 @@ static void enable_iommus(void)
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
 		iommu_enable(iommu);
+		iommu_flush_all_caches(iommu);
 	}
 }
 
@@ -1274,8 +1306,8 @@ static void amd_iommu_resume(void)
 	 * we have to flush after the IOMMUs are enabled because a
 	 * disabled IOMMU will never execute the commands we send
 	 */
-	amd_iommu_flush_all_devices();
-	amd_iommu_flush_all_domains();
+	for_each_iommu(iommu)
+		iommu_flush_all_caches(iommu);
 }
 
 static int amd_iommu_suspend(void)
diff --git a/arch/x86/kernel/pci-iommu_table.c b/arch/x86/kernel/pci-iommu_table.c
index 55d745e..35ccf75 100644
--- a/arch/x86/kernel/pci-iommu_table.c
+++ b/arch/x86/kernel/pci-iommu_table.c
@@ -50,20 +50,14 @@ void __init check_iommu_entries(struct iommu_table_entry *start,
 				struct iommu_table_entry *finish)
 {
 	struct iommu_table_entry *p, *q, *x;
-	char sym_p[KSYM_SYMBOL_LEN];
-	char sym_q[KSYM_SYMBOL_LEN];
 
 	/* Simple cyclic dependency checker. */
 	for (p = start; p < finish; p++) {
 		q = find_dependents_of(start, finish, p);
 		x = find_dependents_of(start, finish, q);
 		if (p == x) {
-			sprint_symbol(sym_p, (unsigned long)p->detect);
-			sprint_symbol(sym_q, (unsigned long)q->detect);
-
-			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %s depends" \
-					" on %s and vice-versa. BREAKING IT.\n",
-					sym_p, sym_q);
+			printk(KERN_ERR "CYCLIC DEPENDENCY FOUND! %pS depends on %pS and vice-versa. BREAKING IT.\n",
+			       p->detect, q->detect);
 			/* Heavy handed way..*/
 			x->depend = 0;
 		}
@@ -72,12 +66,8 @@ void __init check_iommu_entries(struct iommu_table_entry *start,
 	for (p = start; p < finish; p++) {
 		q = find_dependents_of(p, finish, p);
 		if (q && q > p) {
-			sprint_symbol(sym_p, (unsigned long)p->detect);
-			sprint_symbol(sym_q, (unsigned long)q->detect);
-
-			printk(KERN_ERR "EXECUTION ORDER INVALID! %s "\
-					"should be called before %s!\n",
-					sym_p, sym_q);
+			printk(KERN_ERR "EXECUTION ORDER INVALID! %pS should be called before %pS!\n",
+			       p->detect, q->detect);
 		}
 	}
 }
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index d552d2c..6af6b62 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
+#include <linux/pci-ats.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 553d8ee..42fae47 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/pci-ats.h>
 #include "pci.h"
 
 #define VIRTFN_ID_LEN	16
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index a6ec200..4020025 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -250,15 +250,6 @@ struct pci_sriov {
 	u8 __iomem *mstate;	/* VF Migration State Array */
 };
 
-/* Address Translation Service */
-struct pci_ats {
-	int pos;	/* capability position */
-	int stu;	/* Smallest Translation Unit */
-	int qdep;	/* Invalidate Queue Depth */
-	int ref_cnt;	/* Physical Function reference count */
-	unsigned int is_enabled:1;	/* Enable bit is set */
-};
-
 #ifdef CONFIG_PCI_IOV
 extern int pci_iov_init(struct pci_dev *dev);
 extern void pci_iov_release(struct pci_dev *dev);
@@ -269,19 +260,6 @@ extern resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev,
 extern void pci_restore_iov_state(struct pci_dev *dev);
 extern int pci_iov_bus_range(struct pci_bus *bus);
 
-extern int pci_enable_ats(struct pci_dev *dev, int ps);
-extern void pci_disable_ats(struct pci_dev *dev);
-extern int pci_ats_queue_depth(struct pci_dev *dev);
-/**
- * pci_ats_enabled - query the ATS status
- * @dev: the PCI device
- *
- * Returns 1 if ATS capability is enabled, or 0 if not.
- */
-static inline int pci_ats_enabled(struct pci_dev *dev)
-{
-	return dev->ats && dev->ats->is_enabled;
-}
 #else
 static inline int pci_iov_init(struct pci_dev *dev)
 {
@@ -304,21 +282,6 @@ static inline int pci_iov_bus_range(struct pci_bus *bus)
 	return 0;
 }
 
-static inline int pci_enable_ats(struct pci_dev *dev, int ps)
-{
-	return -ENODEV;
-}
-static inline void pci_disable_ats(struct pci_dev *dev)
-{
-}
-static inline int pci_ats_queue_depth(struct pci_dev *dev)
-{
-	return -ENODEV;
-}
-static inline int pci_ats_enabled(struct pci_dev *dev)
-{
-	return 0;
-}
 #endif /* CONFIG_PCI_IOV */
 
 static inline resource_size_t pci_resource_alignment(struct pci_dev *dev,
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
new file mode 100644
index 0000000..655824f
--- /dev/null
+++ b/include/linux/pci-ats.h
@@ -0,0 +1,52 @@
+#ifndef LINUX_PCI_ATS_H
+#define LINUX_PCI_ATS_H
+
+/* Address Translation Service */
+struct pci_ats {
+	int pos;        /* capability position */
+	int stu;        /* Smallest Translation Unit */
+	int qdep;       /* Invalidate Queue Depth */
+	int ref_cnt;    /* Physical Function reference count */
+	unsigned int is_enabled:1;      /* Enable bit is set */
+};
+
+#ifdef CONFIG_PCI_IOV
+
+extern int pci_enable_ats(struct pci_dev *dev, int ps);
+extern void pci_disable_ats(struct pci_dev *dev);
+extern int pci_ats_queue_depth(struct pci_dev *dev);
+/**
+ * pci_ats_enabled - query the ATS status
+ * @dev: the PCI device
+ *
+ * Returns 1 if ATS capability is enabled, or 0 if not.
+ */
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return dev->ats && dev->ats->is_enabled;
+}
+
+#else /* CONFIG_PCI_IOV */
+
+static inline int pci_enable_ats(struct pci_dev *dev, int ps)
+{
+	return -ENODEV;
+}
+
+static inline void pci_disable_ats(struct pci_dev *dev)
+{
+}
+
+static inline int pci_ats_queue_depth(struct pci_dev *dev)
+{
+	return -ENODEV;
+}
+
+static inline int pci_ats_enabled(struct pci_dev *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PCI_IOV */
+
+#endif /* LINUX_PCI_ATS_H*/
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 4bfb047..db07bfd 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -649,7 +649,7 @@ out_err:
 	return -ENOMEM;
 }
 
-static int device_dma_allocations(struct device *dev)
+static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
 {
 	struct dma_debug_entry *entry;
 	unsigned long flags;
@@ -660,8 +660,10 @@ static int device_dma_allocations(struct device *dev)
 	for (i = 0; i < HASH_SIZE; ++i) {
 		spin_lock(&dma_entry_hash[i].lock);
 		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
-			if (entry->dev == dev)
+			if (entry->dev == dev) {
 				count += 1;
+				*out_entry = entry;
+			}
 		}
 		spin_unlock(&dma_entry_hash[i].lock);
 	}
@@ -674,6 +676,7 @@ static int device_dma_allocations(struct device *dev)
 static int dma_debug_device_change(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct device *dev = data;
+	struct dma_debug_entry *uninitialized_var(entry);
 	int count;
 
 	if (global_disable)
@@ -681,12 +684,17 @@ static int dma_debug_device_change(struct notifier_block *nb, unsigned long acti
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
-		count = device_dma_allocations(dev);
+		count = device_dma_allocations(dev, &entry);
 		if (count == 0)
 			break;
-		err_printk(dev, NULL, "DMA-API: device driver has pending "
+		err_printk(dev, entry, "DMA-API: device driver has pending "
 				"DMA allocations while released from device "
-				"[count=%d]\n", count);
+				"[count=%d]\n"
+				"One of leaked entries details: "
+				"[device address=0x%016llx] [size=%llu bytes] "
+				"[mapped with %s] [mapped as %s]\n",
+			count, entry->dev_addr, entry->size,
+			dir2name[entry->direction], type2name[entry->type]);
 		break;
 	default:
 		break;
