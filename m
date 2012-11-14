Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161049Ab2KNJtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:49:21 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:57413 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab2KNJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:48:53 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 01/10] s390/pci: base support
Date: Wed, 14 Nov 2012 10:41:33 +0100
Message-Id: <c6f38a8b22d0bf2980785a2f9a786ba4616a3284.1352719877.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-4966-0000-0000-00000413E036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCI support for s390, (only 64 bit mode is supported by hardware):
- PCI facility tests
- PCI instructions: pcilg, pcistg, pcistb, stpcifc, mpcifc, rpcit
- map readb/w/l/q and writeb/w/l/q to pcilg and pcistg instructions
- pci_iomap implementation
- memcpy_fromio/toio
- pci_root_ops using special pcilg/pcistg
- device, bus and domain allocation

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/Kbuild                 |   1 +
 arch/s390/include/asm/io.h       |  55 +++-
 arch/s390/include/asm/pci.h      |  82 +++++-
 arch/s390/include/asm/pci_insn.h | 280 ++++++++++++++++++++
 arch/s390/include/asm/pci_io.h   | 194 ++++++++++++++
 arch/s390/kernel/dis.c           |  15 ++
 arch/s390/pci/Makefile           |   5 +
 arch/s390/pci/pci.c              | 557 +++++++++++++++++++++++++++++++++++++++
 include/asm-generic/io.h         |  21 +-
 9 files changed, 1201 insertions(+), 9 deletions(-)
 create mode 100644 arch/s390/include/asm/pci_insn.h
 create mode 100644 arch/s390/include/asm/pci_io.h
 create mode 100644 arch/s390/pci/Makefile
 create mode 100644 arch/s390/pci/pci.c

diff --git a/arch/s390/Kbuild b/arch/s390/Kbuild
index cc45d25..647c3ec 100644
--- a/arch/s390/Kbuild
+++ b/arch/s390/Kbuild
@@ -6,3 +6,4 @@ obj-$(CONFIG_S390_HYPFS_FS)	+= hypfs/
 obj-$(CONFIG_APPLDATA_BASE)	+= appldata/
 obj-$(CONFIG_MATHEMU)		+= math-emu/
 obj-y				+= net/
+obj-$(CONFIG_PCI)		+= pci/
diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index 559e921..5f3766b 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -9,9 +9,9 @@
 #ifndef _S390_IO_H
 #define _S390_IO_H
 
+#include <linux/kernel.h>
 #include <asm/page.h>
-
-#define IO_SPACE_LIMIT 0xffffffff
+#include <asm/pci_io.h>
 
 /*
  * Change virtual addresses to physical addresses and vv.
@@ -24,10 +24,11 @@ static inline unsigned long virt_to_phys(volatile void * address)
 		 "	lra	%0,0(%1)\n"
 		 "	jz	0f\n"
 		 "	la	%0,0\n"
-                 "0:"
+		 "0:"
 		 : "=a" (real_address) : "a" (address) : "cc");
-        return real_address;
+	return real_address;
 }
+#define virt_to_phys virt_to_phys
 
 static inline void * phys_to_virt(unsigned long address)
 {
@@ -42,4 +43,50 @@ void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
  */
 #define xlate_dev_kmem_ptr(p)	p
 
+#define IO_SPACE_LIMIT 0
+
+#ifdef CONFIG_PCI
+
+#define ioremap_nocache(addr, size)	ioremap(addr, size)
+#define ioremap_wc			ioremap_nocache
+
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)                \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
+{
+	return (void __iomem *) offset;
+}
+
+static inline void iounmap(volatile void __iomem *addr)
+{
+}
+
+/*
+ * s390 needs a private implementation of pci_iomap since ioremap with its
+ * offset parameter isn't sufficient. That's because BAR spaces are not
+ * disjunctive on s390 so we need the bar parameter of pci_iomap to find
+ * the corresponding device and create the mapping cookie.
+ */
+#define pci_iomap pci_iomap
+#define pci_iounmap pci_iounmap
+
+#define memcpy_fromio(dst, src, count)	zpci_memcpy_fromio(dst, src, count)
+#define memcpy_toio(dst, src, count)	zpci_memcpy_toio(dst, src, count)
+#define memset_io(dst, val, count)	zpci_memset_io(dst, val, count)
+
+#define __raw_readb	zpci_read_u8
+#define __raw_readw	zpci_read_u16
+#define __raw_readl	zpci_read_u32
+#define __raw_readq	zpci_read_u64
+#define __raw_writeb	zpci_write_u8
+#define __raw_writew	zpci_write_u16
+#define __raw_writel	zpci_write_u32
+#define __raw_writeq	zpci_write_u64
+
+#endif /* CONFIG_PCI */
+
+#include <asm-generic/io.h>
+
 #endif
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 42a145c..5e286ce 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -1,10 +1,84 @@
 #ifndef __ASM_S390_PCI_H
 #define __ASM_S390_PCI_H
 
-/* S/390 systems don't have a PCI bus. This file is just here because some stupid .c code
- * includes it even if CONFIG_PCI is not set.
- */
+/* must be set before including asm-generic/pci.h */
 #define PCI_DMA_BUS_IS_PHYS (0)
+/* must be set before including pci_clp.h */
+#define PCI_BAR_COUNT	6
 
-#endif /* __ASM_S390_PCI_H */
+#include <asm-generic/pci.h>
+#include <asm-generic/pci-dma-compat.h>
 
+#define PCIBIOS_MIN_IO		0x1000
+#define PCIBIOS_MIN_MEM		0x10000000
+
+#define pcibios_assign_all_busses()	(0)
+
+void __iomem *pci_iomap(struct pci_dev *, int, unsigned long);
+void pci_iounmap(struct pci_dev *, void __iomem *);
+int pci_domain_nr(struct pci_bus *);
+int pci_proc_domain(struct pci_bus *);
+
+#define ZPCI_BUS_NR			0	/* default bus number */
+#define ZPCI_DEVFN			0	/* default device number */
+
+/* PCI Function Controls */
+#define ZPCI_FC_FN_ENABLED		0x80
+#define ZPCI_FC_ERROR			0x40
+#define ZPCI_FC_BLOCKED			0x20
+#define ZPCI_FC_DMA_ENABLED		0x10
+
+enum zpci_state {
+	ZPCI_FN_STATE_RESERVED,
+	ZPCI_FN_STATE_STANDBY,
+	ZPCI_FN_STATE_CONFIGURED,
+	ZPCI_FN_STATE_ONLINE,
+	NR_ZPCI_FN_STATES,
+};
+
+struct zpci_bar_struct {
+	u32		val;		/* bar start & 3 flag bits */
+	u8		size;		/* order 2 exponent */
+	u16		map_idx;	/* index into bar mapping array */
+};
+
+/* Private data per function */
+struct zpci_dev {
+	struct pci_dev	*pdev;
+	struct pci_bus  *bus;
+	struct list_head entry;		/* list of all zpci_devices, needed for hotplug, etc. */
+
+	enum zpci_state state;
+	u32		fid;		/* function ID, used by sclp */
+	u32		fh;		/* function handle, used by insn's */
+	u16		pchid;		/* physical channel ID */
+	u8		pfgid;		/* function group ID */
+	u16		domain;
+
+	struct zpci_bar_struct bars[PCI_BAR_COUNT];
+
+	enum pci_bus_speed max_bus_speed;
+};
+
+static inline bool zdev_enabled(struct zpci_dev *zdev)
+{
+	return (zdev->fh & (1UL << 31)) ? true : false;
+}
+
+/* -----------------------------------------------------------------------------
+  Prototypes
+----------------------------------------------------------------------------- */
+/* Base stuff */
+struct zpci_dev *zpci_alloc_device(void);
+int zpci_create_device(struct zpci_dev *);
+int zpci_enable_device(struct zpci_dev *);
+void zpci_stop_device(struct zpci_dev *);
+void zpci_free_device(struct zpci_dev *);
+int zpci_scan_device(struct zpci_dev *);
+
+/* Helpers */
+struct zpci_dev *get_zdev(struct pci_dev *);
+struct zpci_dev *get_zdev_by_fid(u32);
+bool zpci_fid_present(u32);
+
+#endif
diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
new file mode 100644
index 0000000..15b88b9
--- /dev/null
+++ b/arch/s390/include/asm/pci_insn.h
@@ -0,0 +1,280 @@
+#ifndef _ASM_S390_PCI_INSN_H
+#define _ASM_S390_PCI_INSN_H
+
+#include <linux/delay.h>
+
+#define ZPCI_INSN_BUSY_DELAY	1	/* 1 millisecond */
+
+/* Load/Store status codes */
+#define ZPCI_PCI_ST_FUNC_NOT_ENABLED		4
+#define ZPCI_PCI_ST_FUNC_IN_ERR			8
+#define ZPCI_PCI_ST_BLOCKED			12
+#define ZPCI_PCI_ST_INSUF_RES			16
+#define ZPCI_PCI_ST_INVAL_AS			20
+#define ZPCI_PCI_ST_FUNC_ALREADY_ENABLED	24
+#define ZPCI_PCI_ST_DMA_AS_NOT_ENABLED		28
+#define ZPCI_PCI_ST_2ND_OP_IN_INV_AS		36
+#define ZPCI_PCI_ST_FUNC_NOT_AVAIL		40
+#define ZPCI_PCI_ST_ALREADY_IN_RQ_STATE		44
+
+/* Load/Store return codes */
+#define ZPCI_PCI_LS_OK				0
+#define ZPCI_PCI_LS_ERR				1
+#define ZPCI_PCI_LS_BUSY			2
+#define ZPCI_PCI_LS_INVAL_HANDLE		3
+
+/* Load/Store address space identifiers */
+#define ZPCI_PCIAS_MEMIO_0			0
+#define ZPCI_PCIAS_MEMIO_1			1
+#define ZPCI_PCIAS_MEMIO_2			2
+#define ZPCI_PCIAS_MEMIO_3			3
+#define ZPCI_PCIAS_MEMIO_4			4
+#define ZPCI_PCIAS_MEMIO_5			5
+#define ZPCI_PCIAS_CFGSPC			15
+
+/* Modify PCI Function Controls */
+#define ZPCI_MOD_FC_REG_INT	2
+#define ZPCI_MOD_FC_DEREG_INT	3
+#define ZPCI_MOD_FC_REG_IOAT	4
+#define ZPCI_MOD_FC_DEREG_IOAT	5
+#define ZPCI_MOD_FC_REREG_IOAT	6
+#define ZPCI_MOD_FC_RESET_ERROR	7
+#define ZPCI_MOD_FC_RESET_BLOCK	9
+#define ZPCI_MOD_FC_SET_MEASURE	10
+
+/* FIB function controls */
+#define ZPCI_FIB_FC_ENABLED	0x80
+#define ZPCI_FIB_FC_ERROR	0x40
+#define ZPCI_FIB_FC_LS_BLOCKED	0x20
+#define ZPCI_FIB_FC_DMAAS_REG	0x10
+
+/* FIB function controls */
+#define ZPCI_FIB_FC_ENABLED	0x80
+#define ZPCI_FIB_FC_ERROR	0x40
+#define ZPCI_FIB_FC_LS_BLOCKED	0x20
+#define ZPCI_FIB_FC_DMAAS_REG	0x10
+
+/* Function Information Block */
+struct zpci_fib {
+	u32 fmt		:  8;	/* format */
+	u32		: 24;
+	u32 reserved1;
+	u8 fc;			/* function controls */
+	u8 reserved2;
+	u16 reserved3;
+	u32 reserved4;
+	u64 pba;		/* PCI base address */
+	u64 pal;		/* PCI address limit */
+	u64 iota;		/* I/O Translation Anchor */
+	u32		:  1;
+	u32 isc		:  3;	/* Interrupt subclass */
+	u32 noi		: 12;	/* Number of interrupts */
+	u32		:  2;
+	u32 aibvo	:  6;	/* Adapter interrupt bit vector offset */
+	u32 sum		:  1;	/* Adapter int summary bit enabled */
+	u32		:  1;
+	u32 aisbo	:  6;	/* Adapter int summary bit offset */
+	u32 reserved5;
+	u64 aibv;		/* Adapter int bit vector address */
+	u64 aisb;		/* Adapter int summary bit address */
+	u64 fmb_addr;		/* Function measurement block address and key */
+	u64 reserved6;
+	u64 reserved7;
+} __packed;
+
+/* Modify PCI Function Controls */
+static inline u8 __mpcifc(u64 req, struct zpci_fib *fib, u8 *status)
+{
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rxy,0xe300000000d0,%[req],%[fib]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [req] "+d" (req), [fib] "+Q" (*fib)
+		: : "cc");
+	*status = req >> 24 & 0xff;
+	return cc;
+}
+
+static inline int mpcifc_instr(u64 req, struct zpci_fib *fib)
+{
+	u8 cc, status;
+
+	do {
+		cc = __mpcifc(req, fib, &status);
+		if (cc == 2)
+			msleep(ZPCI_INSN_BUSY_DELAY);
+	} while (cc == 2);
+
+	if (cc)
+		printk_once(KERN_ERR "%s: error cc: %d  status: %d\n",
+			     __func__, cc, status);
+	return (cc) ? -EIO : 0;
+}
+
+/* Refresh PCI Translations */
+static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
+{
+	register u64 __addr asm("2") = addr;
+	register u64 __range asm("3") = range;
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rre,0xb9d30000,%[fn],%[addr]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [fn] "+d" (fn)
+		: [addr] "d" (__addr), "d" (__range)
+		: "cc");
+	*status = fn >> 24 & 0xff;
+	return cc;
+}
+
+static inline int rpcit_instr(u64 fn, u64 addr, u64 range)
+{
+	u8 cc, status;
+
+	do {
+		cc = __rpcit(fn, addr, range, &status);
+		if (cc == 2)
+			msleep(ZPCI_INSN_BUSY_DELAY);
+	} while (cc == 2);
+
+	if (cc)
+		printk_once(KERN_ERR "%s: error cc: %d  status: %d  dma_addr: %Lx  size: %Lx\n",
+			    __func__, cc, status, addr, range);
+	return (cc) ? -EIO : 0;
+}
+
+/* Store PCI function controls */
+static inline u8 __stpcifc(u32 handle, u8 space, struct zpci_fib *fib, u8 *status)
+{
+	u64 fn = (u64) handle << 32 | space << 16;
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rxy,0xe300000000d4,%[fn],%[fib]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [fn] "+d" (fn), [fib] "=m" (*fib)
+		: : "cc");
+	*status = fn >> 24 & 0xff;
+	return cc;
+}
+
+/* Set Interruption Controls */
+static inline void sic_instr(u16 ctl, char *unused, u8 isc)
+{
+	asm volatile (
+		"	.insn	rsy,0xeb00000000d1,%[ctl],%[isc],%[u]\n"
+		: : [ctl] "d" (ctl), [isc] "d" (isc << 27), [u] "Q" (*unused));
+}
+
+/* PCI Load */
+static inline u8 __pcilg(u64 *data, u64 req, u64 offset, u8 *status)
+{
+	register u64 __req asm("2") = req;
+	register u64 __offset asm("3") = offset;
+	u64 __data;
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rre,0xb9d20000,%[data],%[req]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [data] "=d" (__data), [req] "+d" (__req)
+		:  "d" (__offset)
+		: "cc");
+	*status = __req >> 24 & 0xff;
+	*data = __data;
+	return cc;
+}
+
+static inline int pcilg_instr(u64 *data, u64 req, u64 offset)
+{
+	u8 cc, status;
+
+	do {
+		cc = __pcilg(data, req, offset, &status);
+		if (cc == 2)
+			msleep(ZPCI_INSN_BUSY_DELAY);
+	} while (cc == 2);
+
+	if (cc) {
+		printk_once(KERN_ERR "%s: error cc: %d  status: %d  req: %Lx  offset: %Lx\n",
+			    __func__, cc, status, req, offset);
+		/* TODO: on IO errors set data to 0xff...
+		 * here or in users of pcilg (le conversion)?
+		 */
+	}
+	return (cc) ? -EIO : 0;
+}
+
+/* PCI Store */
+static inline u8 __pcistg(u64 data, u64 req, u64 offset, u8 *status)
+{
+	register u64 __req asm("2") = req;
+	register u64 __offset asm("3") = offset;
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rre,0xb9d00000,%[data],%[req]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [req] "+d" (__req)
+		: "d" (__offset), [data] "d" (data)
+		: "cc");
+	*status = __req >> 24 & 0xff;
+	return cc;
+}
+
+static inline int pcistg_instr(u64 data, u64 req, u64 offset)
+{
+	u8 cc, status;
+
+	do {
+		cc = __pcistg(data, req, offset, &status);
+		if (cc == 2)
+			msleep(ZPCI_INSN_BUSY_DELAY);
+	} while (cc == 2);
+
+	if (cc)
+		printk_once(KERN_ERR "%s: error cc: %d  status: %d  req: %Lx  offset: %Lx\n",
+			__func__, cc, status, req, offset);
+	return (cc) ? -EIO : 0;
+}
+
+/* PCI Store Block */
+static inline u8 __pcistb(const u64 *data, u64 req, u64 offset, u8 *status)
+{
+	u8 cc;
+
+	asm volatile (
+		"	.insn	rsy,0xeb00000000d0,%[req],%[offset],%[data]\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [req] "+d" (req)
+		: [offset] "d" (offset), [data] "Q" (*data)
+		: "cc");
+	*status = req >> 24 & 0xff;
+	return cc;
+}
+
+static inline int pcistb_instr(const u64 *data, u64 req, u64 offset)
+{
+	u8 cc, status;
+
+	do {
+		cc = __pcistb(data, req, offset, &status);
+		if (cc == 2)
+			msleep(ZPCI_INSN_BUSY_DELAY);
+	} while (cc == 2);
+
+	if (cc)
+		printk_once(KERN_ERR "%s: error cc: %d  status: %d  req: %Lx  offset: %Lx\n",
+			    __func__, cc, status, req, offset);
+	return (cc) ? -EIO : 0;
+}
+
+#endif
diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
new file mode 100644
index 0000000..5fd81f3
--- /dev/null
+++ b/arch/s390/include/asm/pci_io.h
@@ -0,0 +1,194 @@
+#ifndef _ASM_S390_PCI_IO_H
+#define _ASM_S390_PCI_IO_H
+
+#ifdef CONFIG_PCI
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <asm/pci_insn.h>
+
+/* I/O Map */
+#define ZPCI_IOMAP_MAX_ENTRIES		0x7fff
+#define ZPCI_IOMAP_ADDR_BASE		0x8000000000000000ULL
+#define ZPCI_IOMAP_ADDR_IDX_MASK	0x7fff000000000000ULL
+#define ZPCI_IOMAP_ADDR_OFF_MASK	0x0000ffffffffffffULL
+
+struct zpci_iomap_entry {
+	u32 fh;
+	u8 bar;
+};
+
+extern struct zpci_iomap_entry *zpci_iomap_start;
+
+#define ZPCI_IDX(addr)								\
+	(((__force u64) addr & ZPCI_IOMAP_ADDR_IDX_MASK) >> 48)
+#define ZPCI_OFFSET(addr)							\
+	((__force u64) addr & ZPCI_IOMAP_ADDR_OFF_MASK)
+
+#define ZPCI_CREATE_REQ(handle, space, len)					\
+	((u64) handle << 32 | space << 16 | len)
+
+#define zpci_read(LENGTH, RETTYPE)						\
+static inline RETTYPE zpci_read_##RETTYPE(const volatile void __iomem *addr)	\
+{										\
+	struct zpci_iomap_entry *entry = &zpci_iomap_start[ZPCI_IDX(addr)];	\
+	u64 req = ZPCI_CREATE_REQ(entry->fh, entry->bar, LENGTH);		\
+	u64 data;								\
+	int rc;									\
+										\
+	rc = pcilg_instr(&data, req, ZPCI_OFFSET(addr));			\
+	if (rc)									\
+		data = -1ULL;							\
+	return (RETTYPE) data;							\
+}
+
+#define zpci_write(LENGTH, VALTYPE)						\
+static inline void zpci_write_##VALTYPE(VALTYPE val,				\
+					const volatile void __iomem *addr)	\
+{										\
+	struct zpci_iomap_entry *entry = &zpci_iomap_start[ZPCI_IDX(addr)];	\
+	u64 req = ZPCI_CREATE_REQ(entry->fh, entry->bar, LENGTH);		\
+	u64 data = (VALTYPE) val;						\
+										\
+	pcistg_instr(data, req, ZPCI_OFFSET(addr));				\
+}
+
+zpci_read(8, u64)
+zpci_read(4, u32)
+zpci_read(2, u16)
+zpci_read(1, u8)
+zpci_write(8, u64)
+zpci_write(4, u32)
+zpci_write(2, u16)
+zpci_write(1, u8)
+
+static inline int zpci_write_single(u64 req, const u64 *data, u64 offset, u8 len)
+{
+	u64 val;
+
+	switch (len) {
+	case 1:
+		val = (u64) *((u8 *) data);
+		break;
+	case 2:
+		val = (u64) *((u16 *) data);
+		break;
+	case 4:
+		val = (u64) *((u32 *) data);
+		break;
+	case 8:
+		val = (u64) *((u64 *) data);
+		break;
+	default:
+		val = 0;		/* let FW report error */
+		break;
+	}
+	return pcistg_instr(val, req, offset);
+}
+
+static inline int zpci_read_single(u64 req, u64 *dst, u64 offset, u8 len)
+{
+	u64 data;
+	u8 cc;
+
+	cc = pcilg_instr(&data,	 req, offset);
+	switch (len) {
+	case 1:
+		*((u8 *) dst) = (u8) data;
+		break;
+	case 2:
+		*((u16 *) dst) = (u16) data;
+		break;
+	case 4:
+		*((u32 *) dst) = (u32) data;
+		break;
+	case 8:
+		*((u64 *) dst) = (u64) data;
+		break;
+	}
+	return cc;
+}
+
+static inline int zpci_write_block(u64 req, const u64 *data, u64 offset)
+{
+	return pcistb_instr(data, req, offset);
+}
+
+static inline u8 zpci_get_max_write_size(u64 src, u64 dst, int len, int max)
+{
+	int count = len > max ? max : len, size = 1;
+
+	while (!(src & 0x1) && !(dst & 0x1) && ((size << 1) <= count)) {
+		dst = dst >> 1;
+		src = src >> 1;
+		size = size << 1;
+	}
+	return size;
+}
+
+static inline int zpci_memcpy_fromio(void *dst,
+				     const volatile void __iomem *src,
+				     unsigned long n)
+{
+	struct zpci_iomap_entry *entry = &zpci_iomap_start[ZPCI_IDX(src)];
+	u64 req, offset = ZPCI_OFFSET(src);
+	int size, rc = 0;
+
+	while (n > 0) {
+		size = zpci_get_max_write_size((u64) src, (u64) dst, n, 8);
+		req = ZPCI_CREATE_REQ(entry->fh, entry->bar, size);
+		rc = zpci_read_single(req, dst, offset, size);
+		if (rc)
+			break;
+		offset += size;
+		dst += size;
+		n -= size;
+	}
+	return rc;
+}
+
+static inline int zpci_memcpy_toio(volatile void __iomem *dst,
+				   const void *src, unsigned long n)
+{
+	struct zpci_iomap_entry *entry = &zpci_iomap_start[ZPCI_IDX(dst)];
+	u64 req, offset = ZPCI_OFFSET(dst);
+	int size, rc = 0;
+
+	if (!src)
+		return -EINVAL;
+
+	while (n > 0) {
+		size = zpci_get_max_write_size((u64) dst, (u64) src, n, 128);
+		req = ZPCI_CREATE_REQ(entry->fh, entry->bar, size);
+
+		if (size > 8) /* main path */
+			rc = zpci_write_block(req, src, offset);
+		else
+			rc = zpci_write_single(req, src, offset, size);
+		if (rc)
+			break;
+		offset += size;
+		src += size;
+		n -= size;
+	}
+	return rc;
+}
+
+static inline int zpci_memset_io(volatile void __iomem *dst,
+				 unsigned char val, size_t count)
+{
+	u8 *src = kmalloc(count, GFP_KERNEL);
+	int rc;
+
+	if (src == NULL)
+		return -ENOMEM;
+	memset(src, val, count);
+
+	rc = zpci_memcpy_toio(dst, src, count);
+	kfree(src);
+	return rc;
+}
+
+#endif /* CONFIG_PCI */
+
+#endif /* _ASM_S390_PCI_IO_H */
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index f00286b..8c6c421 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -320,6 +320,10 @@ enum {
 	LONG_INSN_TABORT,
 	LONG_INSN_TBEGIN,
 	LONG_INSN_TBEGINC,
+	LONG_INSN_PCISTG,
+	LONG_INSN_MPCIFC,
+	LONG_INSN_STPCIFC,
+	LONG_INSN_PCISTB,
 };
 
 static char *long_insn_name[] = {
@@ -340,6 +344,10 @@ static char *long_insn_name[] = {
 	[LONG_INSN_TABORT] = "tabort",
 	[LONG_INSN_TBEGIN] = "tbegin",
 	[LONG_INSN_TBEGINC] = "tbeginc",
+	[LONG_INSN_PCISTG] = "pcistg",
+	[LONG_INSN_MPCIFC] = "mpcifc",
+	[LONG_INSN_STPCIFC] = "stpcifc",
+	[LONG_INSN_PCISTB] = "pcistb",
 };
 
 static struct insn opcode[] = {
@@ -946,6 +954,9 @@ static struct insn opcode_b9[] = {
 	{ "slhhh", 0xcb, INSTR_RRF_R0RR2 },
 	{ "chhr ", 0xcd, INSTR_RRE_RR },
 	{ "clhhr", 0xcf, INSTR_RRE_RR },
+	{ { 0, LONG_INSN_PCISTG }, 0xd0, INSTR_RRE_RR },
+	{ "pcilg", 0xd2, INSTR_RRE_RR },
+	{ "rpcit", 0xd3, INSTR_RRE_RR },
 	{ "ahhlr", 0xd8, INSTR_RRF_R0RR2 },
 	{ "shhlr", 0xd9, INSTR_RRF_R0RR2 },
 	{ "slhhl", 0xdb, INSTR_RRF_R0RR2 },
@@ -1175,6 +1186,8 @@ static struct insn opcode_e3[] = {
 	{ "chf", 0xcd, INSTR_RXY_RRRD },
 	{ "clhf", 0xcf, INSTR_RXY_RRRD },
 	{ "ntstg", 0x25, INSTR_RXY_RRRD },
+	{ { 0, LONG_INSN_MPCIFC }, 0xd0, INSTR_RXY_RRRD },
+	{ { 0, LONG_INSN_STPCIFC }, 0xd4, INSTR_RXY_RRRD },
 #endif
 	{ "lrv", 0x1e, INSTR_RXY_RRRD },
 	{ "lrvh", 0x1f, INSTR_RXY_RRRD },
@@ -1254,6 +1267,8 @@ static struct insn opcode_eb[] = {
 	{ "alsi", 0x6e, INSTR_SIY_IRD },
 	{ "algsi", 0x7e, INSTR_SIY_IRD },
 	{ "ecag", 0x4c, INSTR_RSY_RRRD },
+	{ { 0, LONG_INSN_PCISTB }, 0xd0, INSTR_RSY_RRRD },
+	{ "sic", 0xd1, INSTR_RSY_RRRD },
 	{ "srak", 0xdc, INSTR_RSY_RRRD },
 	{ "slak", 0xdd, INSTR_RSY_RRRD },
 	{ "srlk", 0xde, INSTR_RSY_RRRD },
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
new file mode 100644
index 0000000..78a1344
--- /dev/null
+++ b/arch/s390/pci/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the s390 PCI subsystem.
+#
+
+obj-$(CONFIG_PCI)	+= pci.o
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
new file mode 100644
index 0000000..0b80ac7
--- /dev/null
+++ b/arch/s390/pci/pci.c
@@ -0,0 +1,557 @@
+/*
+ * Copyright IBM Corp. 2012
+ *
+ * Author(s):
+ *   Jan Glauber <jang@linux.vnet.ibm.com>
+ *
+ * The System z PCI code is a rewrite from a prototype by
+ * the following people (Kudoz!):
+ *   Alexander Schmidt <alexschm@de.ibm.com>
+ *   Christoph Raisch <raisch@de.ibm.com>
+ *   Hannes Hering <hering2@de.ibm.com>
+ *   Hoang-Nam Nguyen <hnguyen@de.ibm.com>
+ *   Jan-Bernd Themann <themann@de.ibm.com>
+ *   Stefan Roscher <stefan.roscher@de.ibm.com>
+ *   Thomas Klein <tklein@de.ibm.com>
+ */
+
+#define COMPONENT "zPCI"
+#define pr_fmt(fmt) COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/seq_file.h>
+#include <linux/pci.h>
+#include <linux/msi.h>
+
+#include <asm/facility.h>
+#include <asm/pci_insn.h>
+
+#define DEBUG				/* enable pr_debug */
+
+#define ZPCI_NR_DMA_SPACES		1
+#define ZPCI_NR_DEVICES			CONFIG_PCI_NR_FUNCTIONS
+
+/* list of all detected zpci devices */
+LIST_HEAD(zpci_list);
+DEFINE_MUTEX(zpci_list_lock);
+
+static DECLARE_BITMAP(zpci_domain, ZPCI_NR_DEVICES);
+static DEFINE_SPINLOCK(zpci_domain_lock);
+
+/* I/O Map */
+static DEFINE_SPINLOCK(zpci_iomap_lock);
+static DECLARE_BITMAP(zpci_iomap, ZPCI_IOMAP_MAX_ENTRIES);
+struct zpci_iomap_entry *zpci_iomap_start;
+EXPORT_SYMBOL_GPL(zpci_iomap_start);
+
+struct zpci_dev *get_zdev(struct pci_dev *pdev)
+{
+	return (struct zpci_dev *) pdev->sysdata;
+}
+
+struct zpci_dev *get_zdev_by_fid(u32 fid)
+{
+	struct zpci_dev *tmp, *zdev = NULL;
+
+	mutex_lock(&zpci_list_lock);
+	list_for_each_entry(tmp, &zpci_list, entry) {
+		if (tmp->fid == fid) {
+			zdev = tmp;
+			break;
+		}
+	}
+	mutex_unlock(&zpci_list_lock);
+	return zdev;
+}
+
+bool zpci_fid_present(u32 fid)
+{
+	return (get_zdev_by_fid(fid) != NULL) ? true : false;
+}
+
+static struct zpci_dev *get_zdev_by_bus(struct pci_bus *bus)
+{
+	return (bus && bus->sysdata) ? (struct zpci_dev *) bus->sysdata : NULL;
+}
+
+int pci_domain_nr(struct pci_bus *bus)
+{
+	return ((struct zpci_dev *) bus->sysdata)->domain;
+}
+EXPORT_SYMBOL_GPL(pci_domain_nr);
+
+int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+EXPORT_SYMBOL_GPL(pci_proc_domain);
+
+/* Store PCI function information block */
+static int zpci_store_fib(struct zpci_dev *zdev, u8 *fc)
+{
+	struct zpci_fib *fib;
+	u8 status, cc;
+
+	fib = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!fib)
+		return -ENOMEM;
+
+	do {
+		cc = __stpcifc(zdev->fh, 0, fib, &status);
+		if (cc == 2) {
+			msleep(ZPCI_INSN_BUSY_DELAY);
+			memset(fib, 0, PAGE_SIZE);
+		}
+	} while (cc == 2);
+
+	if (cc)
+		pr_err_once("%s: cc: %u  status: %u\n",
+			    __func__, cc, status);
+
+	/* Return PCI function controls */
+	*fc = fib->fc;
+
+	free_page((unsigned long) fib);
+	return (cc) ? -EIO : 0;
+}
+
+#define ZPCI_PCIAS_CFGSPC	15
+
+static int zpci_cfg_load(struct zpci_dev *zdev, int offset, u32 *val, u8 len)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, ZPCI_PCIAS_CFGSPC, len);
+	u64 data;
+	int rc;
+
+	rc = pcilg_instr(&data, req, offset);
+	data = data << ((8 - len) * 8);
+	data = le64_to_cpu(data);
+	if (!rc)
+		*val = (u32) data;
+	else
+		*val = 0xffffffff;
+	return rc;
+}
+
+static int zpci_cfg_store(struct zpci_dev *zdev, int offset, u32 val, u8 len)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, ZPCI_PCIAS_CFGSPC, len);
+	u64 data = val;
+	int rc;
+
+	data = cpu_to_le64(data);
+	data = data >> ((8 - len) * 8);
+	rc = pcistg_instr(data, req, offset);
+	return rc;
+}
+
+void __devinit pcibios_fixup_bus(struct pci_bus *bus)
+{
+}
+
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+				       resource_size_t size,
+				       resource_size_t align)
+{
+	return 0;
+}
+
+/* Create a virtual mapping cookie for a PCI BAR */
+void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
+{
+	struct zpci_dev *zdev =	get_zdev(pdev);
+	u64 addr;
+	int idx;
+
+	if ((bar & 7) != bar)
+		return NULL;
+
+	idx = zdev->bars[bar].map_idx;
+	spin_lock(&zpci_iomap_lock);
+	zpci_iomap_start[idx].fh = zdev->fh;
+	zpci_iomap_start[idx].bar = bar;
+	spin_unlock(&zpci_iomap_lock);
+
+	addr = ZPCI_IOMAP_ADDR_BASE | ((u64) idx << 48);
+	return (void __iomem *) addr;
+}
+EXPORT_SYMBOL_GPL(pci_iomap);
+
+void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
+{
+	unsigned int idx;
+
+	idx = (((__force u64) addr) & ~ZPCI_IOMAP_ADDR_BASE) >> 48;
+	spin_lock(&zpci_iomap_lock);
+	zpci_iomap_start[idx].fh = 0;
+	zpci_iomap_start[idx].bar = 0;
+	spin_unlock(&zpci_iomap_lock);
+}
+EXPORT_SYMBOL_GPL(pci_iounmap);
+
+static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+		    int size, u32 *val)
+{
+	struct zpci_dev *zdev = get_zdev_by_bus(bus);
+
+	if (!zdev || devfn != ZPCI_DEVFN)
+		return 0;
+	return zpci_cfg_load(zdev, where, val, size);
+}
+
+static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+		     int size, u32 val)
+{
+	struct zpci_dev *zdev = get_zdev_by_bus(bus);
+
+	if (!zdev || devfn != ZPCI_DEVFN)
+		return 0;
+	return zpci_cfg_store(zdev, where, val, size);
+}
+
+static struct pci_ops pci_root_ops = {
+	.read = pci_read,
+	.write = pci_write,
+};
+
+static void zpci_map_resources(struct zpci_dev *zdev)
+{
+	struct pci_dev *pdev = zdev->pdev;
+	resource_size_t len;
+	int i;
+
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		len = pci_resource_len(pdev, i);
+		if (!len)
+			continue;
+		pdev->resource[i].start = (resource_size_t) pci_iomap(pdev, i, 0);
+		pdev->resource[i].end = pdev->resource[i].start + len - 1;
+		pr_debug("BAR%i: -> start: %Lx  end: %Lx\n",
+			i, pdev->resource[i].start, pdev->resource[i].end);
+	}
+};
+
+static void zpci_unmap_resources(struct pci_dev *pdev)
+{
+	resource_size_t len;
+	int i;
+
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		len = pci_resource_len(pdev, i);
+		if (!len)
+			continue;
+		pci_iounmap(pdev, (void *) pdev->resource[i].start);
+	}
+};
+
+struct zpci_dev *zpci_alloc_device(void)
+{
+	struct zpci_dev *zdev;
+
+	/* Alloc memory for our private pci device data */
+	zdev = kzalloc(sizeof(*zdev), GFP_KERNEL);
+	if (!zdev)
+		return ERR_PTR(-ENOMEM);
+	return zdev;
+}
+
+void zpci_free_device(struct zpci_dev *zdev)
+{
+	kfree(zdev);
+}
+
+/* Called on removal of pci_dev, leaves zpci and bus device */
+static void zpci_remove_device(struct pci_dev *pdev)
+{
+	struct zpci_dev *zdev = get_zdev(pdev);
+
+	dev_info(&pdev->dev, "Removing device %u\n", zdev->domain);
+	zdev->state = ZPCI_FN_STATE_CONFIGURED;
+	zpci_unmap_resources(pdev);
+	list_del(&zdev->entry);		/* can be called from init */
+	zdev->pdev = NULL;
+}
+
+static void zpci_scan_devices(void)
+{
+	struct zpci_dev *zdev;
+
+	mutex_lock(&zpci_list_lock);
+	list_for_each_entry(zdev, &zpci_list, entry)
+		if (zdev->state == ZPCI_FN_STATE_CONFIGURED)
+			zpci_scan_device(zdev);
+	mutex_unlock(&zpci_list_lock);
+}
+
+/*
+ * Too late for any s390 specific setup, since interrupts must be set up
+ * already which requires DMA setup too and the pci scan will access the
+ * config space, which only works if the function handle is enabled.
+ */
+int pcibios_enable_device(struct pci_dev *pdev, int mask)
+{
+	struct resource *res;
+	u16 cmd;
+	int i;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		res = &pdev->resource[i];
+
+		if (res->flags & IORESOURCE_IO)
+			return -EINVAL;
+
+		if (res->flags & IORESOURCE_MEM)
+			cmd |= PCI_COMMAND_MEMORY;
+	}
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	return 0;
+}
+
+void pcibios_disable_device(struct pci_dev *pdev)
+{
+	zpci_remove_device(pdev);
+	pdev->sysdata = NULL;
+}
+
+static struct resource *zpci_alloc_bus_resource(unsigned long start, unsigned long size,
+						unsigned long flags, int domain)
+{
+	struct resource *r;
+	char *name;
+	int rc;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+	r->start = start;
+	r->end = r->start + size - 1;
+	r->flags = flags;
+	r->parent = &iomem_resource;
+	name = kmalloc(18, GFP_KERNEL);
+	if (!name) {
+		kfree(r);
+		return ERR_PTR(-ENOMEM);
+	}
+	sprintf(name, "PCI Bus: %04x:%02x", domain, ZPCI_BUS_NR);
+	r->name = name;
+
+	rc = request_resource(&iomem_resource, r);
+	if (rc)
+		pr_debug("request resource %pR failed\n", r);
+	return r;
+}
+
+static int zpci_alloc_iomap(struct zpci_dev *zdev)
+{
+	int entry;
+
+	spin_lock(&zpci_iomap_lock);
+	entry = find_first_zero_bit(zpci_iomap, ZPCI_IOMAP_MAX_ENTRIES);
+	if (entry == ZPCI_IOMAP_MAX_ENTRIES) {
+		spin_unlock(&zpci_iomap_lock);
+		return -ENOSPC;
+	}
+	set_bit(entry, zpci_iomap);
+	spin_unlock(&zpci_iomap_lock);
+	return entry;
+}
+
+static void zpci_free_iomap(struct zpci_dev *zdev, int entry)
+{
+	spin_lock(&zpci_iomap_lock);
+	memset(&zpci_iomap_start[entry], 0, sizeof(struct zpci_iomap_entry));
+	clear_bit(entry, zpci_iomap);
+	spin_unlock(&zpci_iomap_lock);
+}
+
+static int zpci_create_device_bus(struct zpci_dev *zdev)
+{
+	struct resource *res;
+	LIST_HEAD(resources);
+	int i;
+
+	/* allocate mapping entry for each used bar */
+	for (i = 0; i < PCI_BAR_COUNT; i++) {
+		unsigned long addr, size, flags;
+		int entry;
+
+		if (!zdev->bars[i].size)
+			continue;
+		entry = zpci_alloc_iomap(zdev);
+		if (entry < 0)
+			return entry;
+		zdev->bars[i].map_idx = entry;
+
+		/* only MMIO is supported */
+		flags = IORESOURCE_MEM;
+		if (zdev->bars[i].val & 8)
+			flags |= IORESOURCE_PREFETCH;
+		if (zdev->bars[i].val & 4)
+			flags |= IORESOURCE_MEM_64;
+
+		addr = ZPCI_IOMAP_ADDR_BASE + ((u64) entry << 48);
+
+		size = 1UL << zdev->bars[i].size;
+
+		res = zpci_alloc_bus_resource(addr, size, flags, zdev->domain);
+		if (IS_ERR(res)) {
+			zpci_free_iomap(zdev, entry);
+			return PTR_ERR(res);
+		}
+		pci_add_resource(&resources, res);
+	}
+
+	zdev->bus = pci_create_root_bus(NULL, ZPCI_BUS_NR, &pci_root_ops,
+					zdev, &resources);
+	if (!zdev->bus)
+		return -EIO;
+
+	zdev->bus->max_bus_speed = zdev->max_bus_speed;
+	return 0;
+}
+
+static int zpci_alloc_domain(struct zpci_dev *zdev)
+{
+	spin_lock(&zpci_domain_lock);
+	zdev->domain = find_first_zero_bit(zpci_domain, ZPCI_NR_DEVICES);
+	if (zdev->domain == ZPCI_NR_DEVICES) {
+		spin_unlock(&zpci_domain_lock);
+		return -ENOSPC;
+	}
+	set_bit(zdev->domain, zpci_domain);
+	spin_unlock(&zpci_domain_lock);
+	return 0;
+}
+
+static void zpci_free_domain(struct zpci_dev *zdev)
+{
+	spin_lock(&zpci_domain_lock);
+	clear_bit(zdev->domain, zpci_domain);
+	spin_unlock(&zpci_domain_lock);
+}
+
+int zpci_create_device(struct zpci_dev *zdev)
+{
+	int rc;
+
+	rc = zpci_alloc_domain(zdev);
+	if (rc)
+		goto out;
+
+	rc = zpci_create_device_bus(zdev);
+	if (rc)
+		goto out_bus;
+
+	mutex_lock(&zpci_list_lock);
+	list_add_tail(&zdev->entry, &zpci_list);
+	mutex_unlock(&zpci_list_lock);
+
+	if (zdev->state == ZPCI_FN_STATE_STANDBY)
+		return 0;
+
+	return 0;
+
+out_bus:
+	zpci_free_domain(zdev);
+out:
+	return rc;
+}
+
+void zpci_stop_device(struct zpci_dev *zdev)
+{
+	/*
+	 * Note: SCLP disables fh via set-pci-fn so don't
+	 * do that here.
+	 */
+}
+EXPORT_SYMBOL_GPL(zpci_stop_device);
+
+int zpci_scan_device(struct zpci_dev *zdev)
+{
+	zdev->pdev = pci_scan_single_device(zdev->bus, ZPCI_DEVFN);
+	if (!zdev->pdev) {
+		pr_err("pci_scan_single_device failed for fid: 0x%x\n",
+			zdev->fid);
+		goto out;
+	}
+
+	zpci_map_resources(zdev);
+	pci_bus_add_devices(zdev->bus);
+
+	/* now that pdev was added to the bus mark it as used */
+	zdev->state = ZPCI_FN_STATE_ONLINE;
+	return 0;
+
+out:
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(zpci_scan_device);
+
+static inline int barsize(u8 size)
+{
+	return (size) ? (1 << size) >> 10 : 0;
+}
+
+static int zpci_mem_init(void)
+{
+	/* TODO: use realloc */
+	zpci_iomap_start = kzalloc(ZPCI_IOMAP_MAX_ENTRIES * sizeof(*zpci_iomap_start),
+				   GFP_KERNEL);
+	if (!zpci_iomap_start)
+		goto error_zdev;
+	return 0;
+
+error_zdev:
+	return -ENOMEM;
+}
+
+static void zpci_mem_exit(void)
+{
+	kfree(zpci_iomap_start);
+}
+
+unsigned int pci_probe = 1;
+EXPORT_SYMBOL_GPL(pci_probe);
+
+char * __init pcibios_setup(char *str)
+{
+	if (!strcmp(str, "off")) {
+		pci_probe = 0;
+		return NULL;
+	}
+	return str;
+}
+
+static int __init pci_base_init(void)
+{
+	int rc;
+
+	if (!pci_probe)
+		return 0;
+
+	if (!test_facility(2) || !test_facility(69)
+	    || !test_facility(71) || !test_facility(72))
+		return 0;
+
+	pr_info("Probing PCI hardware: PCI:%d  SID:%d  AEN:%d\n",
+		test_facility(69), test_facility(70),
+		test_facility(71));
+
+	rc = zpci_mem_init();
+	if (rc)
+		goto out_mem;
+
+	zpci_scan_devices();
+	return 0;
+
+	zpci_mem_exit();
+out_mem:
+	return rc;
+}
+subsys_initcall(pci_base_init);
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 448303b..9e0ebe0 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -83,19 +83,25 @@ static inline void __raw_writel(u32 b, volatile void __iomem *addr)
 #define writel(b,addr) __raw_writel(__cpu_to_le32(b),addr)
 
 #ifdef CONFIG_64BIT
+#ifndef __raw_readq
 static inline u64 __raw_readq(const volatile void __iomem *addr)
 {
 	return *(const volatile u64 __force *) addr;
 }
+#endif
+
 #define readq(addr) __le64_to_cpu(__raw_readq(addr))
 
+#ifndef __raw_writeq
 static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
 {
 	*(volatile u64 __force *) addr = b;
 }
-#define writeq(b,addr) __raw_writeq(__cpu_to_le64(b),addr)
 #endif
 
+#define writeq(b, addr) __raw_writeq(__cpu_to_le64(b), addr)
+#endif /* CONFIG_64BIT */
+
 #ifndef PCI_IOBASE
 #define PCI_IOBASE ((void __iomem *) 0)
 #endif
@@ -286,15 +292,20 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 
 #ifndef CONFIG_GENERIC_IOMAP
 struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+
+#ifndef pci_iounmap
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
+#endif
 #endif /* CONFIG_GENERIC_IOMAP */
 
 /*
  * Change virtual addresses to physical addresses and vv.
  * These are pretty trivial
  */
+#ifndef virt_to_phys
 static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return __pa((unsigned long)address);
@@ -304,6 +315,7 @@ static inline void *phys_to_virt(unsigned long address)
 {
 	return __va(address);
 }
+#endif
 
 /*
  * Change "struct page" to physical address.
@@ -363,9 +375,16 @@ static inline void *bus_to_virt(unsigned long address)
 }
 #endif
 
+#ifndef memset_io
 #define memset_io(a, b, c)	memset(__io_virt(a), (b), (c))
+#endif
+
+#ifndef memcpy_fromio
 #define memcpy_fromio(a, b, c)	memcpy((a), __io_virt(b), (c))
+#endif
+#ifndef memcpy_toio
 #define memcpy_toio(a, b, c)	memcpy(__io_virt(a), (b), (c))
+#endif
 
 #endif /* __KERNEL__ */
 
-- 
1.7.12.4

