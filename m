Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2BGCrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:47:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43081 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2BGCrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:47:05 -0500
From: Hitoshi Mitake <h.mitake@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Kashyap Desai <Kashyap.Desai@lsi.com>, Len Brown <lenb@kernel.org>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Matthew Garrett <mjg@redhat.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] asm-generic: architecture independent readq/writeq for 32bit environment
Date: Tue,  7 Feb 2012 11:45:33 +0900
Message-Id: <1328582733-31804-1-git-send-email-h.mitake@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

This patch removes some readq()s in drivers (added in  dbee8a0affd5e6eaa5d7c816)
and provides unified readq()/writeq() for the drivers.

For some people, readq/writeq without atomicity is harmful, and order of io
access has to be specified explicitly. So in this patch, new two header files
which contain non-atomic readq/writeq are added. io-64-nonatomic-lo-hi.h
provides non-atomic readq/writeq with the order of lower address -> higher
address. io-64-nonatomic-hi-lo.h provides non-atomic readq/writeq with reversed
order. All of them are endian awared.

If this patch is applied, the drivers which need readq/writeq must add the line:
#include <asm-generic/io-64-nonatomic-lo-hi.h> /* or hi-lo.h */

But this will be nop in 64-bit environments, and no other #ifdefs are required.
So I believe that this patch can solve the problem of
1. driver-specific readq/writeq
2. atomicity and order of io access

This patch is tested with building allyesconfig and allmodconfig as ARCH=x86 and
ARCH=i386 on top of tip/master.

Cc: Kashyap Desai <Kashyap.Desai@lsi.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Cc: James Bottomley <James.Bottomley@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

---
 drivers/edac/i3200_edac.c                   |   15 +------
 drivers/platform/x86/ibm_rtl.c              |   15 +------
 drivers/platform/x86/intel_ips.c            |   15 +------
 drivers/scsi/qla4xxx/ql4_nx.c               |   23 +---------
 include/asm-generic/io-64-nonatomic-hi-lo.h |   63 +++++++++++++++++++++++++++
 include/asm-generic/io-64-nonatomic-lo-hi.h |   63 +++++++++++++++++++++++++++
 6 files changed, 134 insertions(+), 60 deletions(-)
 create mode 100644 include/asm-generic/io-64-nonatomic-hi-lo.h
 create mode 100644 include/asm-generic/io-64-nonatomic-lo-hi.h

diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index aa08497..73f55e200 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -15,6 +15,8 @@
 #include <linux/io.h>
 #include "edac_core.h"
 
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
 #define I3200_REVISION        "1.1"
 
 #define EDAC_MOD_STR        "i3200_edac"
@@ -101,19 +103,6 @@ struct i3200_priv {
 
 static int nr_channels;
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-#endif
-
 static int how_many_channels(struct pci_dev *pdev)
 {
 	unsigned char capid0_8b; /* 8th byte of CAPID0 */
diff --git a/drivers/platform/x86/ibm_rtl.c b/drivers/platform/x86/ibm_rtl.c
index 42a7d60..7481146 100644
--- a/drivers/platform/x86/ibm_rtl.c
+++ b/drivers/platform/x86/ibm_rtl.c
@@ -33,6 +33,8 @@
 #include <linux/mutex.h>
 #include <asm/bios_ebda.h>
 
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
 static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -83,19 +85,6 @@ static void __iomem *rtl_cmd_addr;
 static u8 rtl_cmd_type;
 static u8 rtl_cmd_width;
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-#endif
-
 static void __iomem *rtl_port_map(phys_addr_t addr, unsigned long len)
 {
 	if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 809a3ae..88a98cf 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -77,6 +77,8 @@
 #include <asm/processor.h>
 #include "intel_ips.h"
 
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
 #define PCI_DEVICE_ID_INTEL_THERMAL_SENSOR 0x3b32
 
 /*
@@ -344,19 +346,6 @@ struct ips_driver {
 static bool
 ips_gpu_turbo_enabled(struct ips_driver *ips);
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-#endif
-
 /**
  * ips_cpu_busy - is CPU busy?
  * @ips: IPS driver struct
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 78f1111..65253df 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -10,6 +10,8 @@
 #include "ql4_def.h"
 #include "ql4_glbl.h"
 
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
 #define MASK(n)		DMA_BIT_MASK(n)
 #define MN_WIN(addr)	(((addr & 0x1fc0000) >> 1) | ((addr >> 25) & 0x3ff))
 #define OCM_WIN(addr)	(((addr & 0x1ff0000) >> 1) | ((addr >> 25) & 0x3ff))
@@ -655,27 +657,6 @@ static int qla4_8xxx_pci_is_same_window(struct scsi_qla_host *ha,
 	return 0;
 }
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-#endif
-
-#ifndef writeq
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-#endif
-
 static int qla4_8xxx_pci_mem_read_direct(struct scsi_qla_host *ha,
 		u64 off, void *data, int size)
 {
diff --git a/include/asm-generic/io-64-nonatomic-hi-lo.h b/include/asm-generic/io-64-nonatomic-hi-lo.h
new file mode 100644
index 0000000..34e61cc
--- /dev/null
+++ b/include/asm-generic/io-64-nonatomic-hi-lo.h
@@ -0,0 +1,63 @@
+#ifndef _ASM_IO_64_NONATOMIC_HI_LO_H_
+#define _ASM_IO_64_NONATOMIC_HI_LO_H_
+
+#include <linux/io.h>
+#include <asm-generic/int-ll64.h>
+
+#ifdef CPU_LITTLE_ENDIAN
+
+#ifndef readq
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	high = readl(p + 1);
+	low = readl(p);
+
+	return low + ((u64)high << 32);
+}
+
+#endif
+
+#ifndef writeq
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val >> 32, addr + 4);
+	writel(val, addr);
+}
+
+#endif
+
+#else  /* big endian */
+
+#ifndef readq
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p + 1);
+	high = readl(p);
+
+	return low + ((u64)high << 32);
+}
+
+#endif
+
+#ifndef writeq
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val >> 32, addr);
+	writel(val, addr + 4);
+}
+
+#endif
+
+#endif
+
+#endif	/* _ASM_IO_64_NONATOMIC_HI_LO_H_ */
diff --git a/include/asm-generic/io-64-nonatomic-lo-hi.h b/include/asm-generic/io-64-nonatomic-lo-hi.h
new file mode 100644
index 0000000..bf2fe0f
--- /dev/null
+++ b/include/asm-generic/io-64-nonatomic-lo-hi.h
@@ -0,0 +1,63 @@
+#ifndef _ASM_IO_64_NONATOMIC_LO_HI_H_
+#define _ASM_IO_64_NONATOMIC_LO_HI_H_
+
+#include <linux/io.h>
+#include <asm-generic/int-ll64.h>
+
+#ifdef CPU_LITTLE_ENDIAN
+
+#ifndef readq
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	low = readl(p);
+	high = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+
+#endif
+
+#ifndef writeq
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr + 4);
+}
+
+#endif
+
+#else  /* big endian */
+
+#ifndef readq
+
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 low, high;
+
+	high = readl(p);
+	low = readl(p + 1);
+
+	return low + ((u64)high << 32);
+}
+
+#endif
+
+#ifndef writeq
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr + 4);
+	writel(val >> 32, addr);
+}
+
+#endif
+
+#endif
+
+#endif	/* _ASM_IO_64_NONATOMIC_LO_HI_H_ */
-- 
1.7.5.1

