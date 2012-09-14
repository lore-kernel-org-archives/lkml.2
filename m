Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2INLOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:14:31 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17801 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab2INLOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:14:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37873000"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 01/24] arm: initial Xen support
Date: Fri, 14 Sep 2012 12:13:03 +0100
Message-ID: <1347621207-11294-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Basic hypervisor.h and interface.h definitions.
- Skeleton enlighten.c, set xen_start_info to an empty struct.
- Make xen_initial_domain dependent on the SIF_PRIVILIGED_BIT.

The new code only compiles when CONFIG_XEN is set, that is going to be
added to arch/arm/Kconfig in patch #11 "xen/arm: introduce CONFIG_XEN on
ARM".

Changes in v3:

- improve comments.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/Makefile                     |    1 +
 arch/arm/include/asm/hypervisor.h     |    6 +++
 arch/arm/include/asm/xen/hypervisor.h |   19 ++++++++++
 arch/arm/include/asm/xen/interface.h  |   65 +++++++++++++++++++++++++++++++++
 arch/arm/xen/Makefile                 |    1 +
 arch/arm/xen/enlighten.c              |   35 ++++++++++++++++++
 include/xen/xen.h                     |    2 +-
 7 files changed, 128 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/include/asm/hypervisor.h
 create mode 100644 arch/arm/include/asm/xen/hypervisor.h
 create mode 100644 arch/arm/include/asm/xen/interface.h
 create mode 100644 arch/arm/xen/Makefile
 create mode 100644 arch/arm/xen/enlighten.c

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 30eae87..f42968a 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -251,6 +251,7 @@ endif
 core-$(CONFIG_FPE_NWFPE)	+= arch/arm/nwfpe/
 core-$(CONFIG_FPE_FASTFPE)	+= $(FASTFPE_OBJ)
 core-$(CONFIG_VFP)		+= arch/arm/vfp/
+core-$(CONFIG_XEN)		+= arch/arm/xen/
 
 # If we have a machine-specific directory, then include it in the build.
 core-y				+= arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
diff --git a/arch/arm/include/asm/hypervisor.h b/arch/arm/include/asm/hypervisor.h
new file mode 100644
index 0000000..b90d9e5
--- /dev/null
+++ b/arch/arm/include/asm/hypervisor.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ARM_HYPERVISOR_H
+#define _ASM_ARM_HYPERVISOR_H
+
+#include <asm/xen/hypervisor.h>
+
+#endif
diff --git a/arch/arm/include/asm/xen/hypervisor.h b/arch/arm/include/asm/xen/hypervisor.h
new file mode 100644
index 0000000..d7ab99a
--- /dev/null
+++ b/arch/arm/include/asm/xen/hypervisor.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_ARM_XEN_HYPERVISOR_H
+#define _ASM_ARM_XEN_HYPERVISOR_H
+
+extern struct shared_info *HYPERVISOR_shared_info;
+extern struct start_info *xen_start_info;
+
+/* Lazy mode for batching updates / context switch */
+enum paravirt_lazy_mode {
+	PARAVIRT_LAZY_NONE,
+	PARAVIRT_LAZY_MMU,
+	PARAVIRT_LAZY_CPU,
+};
+
+static inline enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
+{
+	return PARAVIRT_LAZY_NONE;
+}
+
+#endif /* _ASM_ARM_XEN_HYPERVISOR_H */
diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
new file mode 100644
index 0000000..9e0ec5a
--- /dev/null
+++ b/arch/arm/include/asm/xen/interface.h
@@ -0,0 +1,65 @@
+/******************************************************************************
+ * Guest OS interface to ARM Xen.
+ *
+ * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
+ */
+
+#ifndef _ASM_ARM_XEN_INTERFACE_H
+#define _ASM_ARM_XEN_INTERFACE_H
+
+#include <linux/types.h>
+
+#define __DEFINE_GUEST_HANDLE(name, type) \
+	typedef type * __guest_handle_ ## name
+
+#define DEFINE_GUEST_HANDLE_STRUCT(name) \
+	__DEFINE_GUEST_HANDLE(name, struct name)
+#define DEFINE_GUEST_HANDLE(name) __DEFINE_GUEST_HANDLE(name, name)
+#define GUEST_HANDLE(name)        __guest_handle_ ## name
+
+#define set_xen_guest_handle(hnd, val)			\
+	do {						\
+		if (sizeof(hnd) == 8)			\
+			*(uint64_t *)&(hnd) = 0;	\
+		(hnd) = val;				\
+	} while (0)
+
+#ifndef __ASSEMBLY__
+/* Guest handles for primitive C types. */
+__DEFINE_GUEST_HANDLE(uchar, unsigned char);
+__DEFINE_GUEST_HANDLE(uint,  unsigned int);
+__DEFINE_GUEST_HANDLE(ulong, unsigned long);
+DEFINE_GUEST_HANDLE(char);
+DEFINE_GUEST_HANDLE(int);
+DEFINE_GUEST_HANDLE(long);
+DEFINE_GUEST_HANDLE(void);
+DEFINE_GUEST_HANDLE(uint64_t);
+DEFINE_GUEST_HANDLE(uint32_t);
+
+/* Maximum number of virtual CPUs in multi-processor guests. */
+#define MAX_VIRT_CPUS 1
+
+struct arch_vcpu_info { };
+struct arch_shared_info { };
+
+/* TODO: Move pvclock definitions some place arch independent */
+struct pvclock_vcpu_time_info {
+	u32   version;
+	u32   pad0;
+	u64   tsc_timestamp;
+	u64   system_time;
+	u32   tsc_to_system_mul;
+	s8    tsc_shift;
+	u8    flags;
+	u8    pad[2];
+} __attribute__((__packed__)); /* 32 bytes */
+
+/* It is OK to have a 12 bytes struct with no padding because it is packed */
+struct pvclock_wall_clock {
+	u32   version;
+	u32   sec;
+	u32   nsec;
+} __attribute__((__packed__));
+#endif
+
+#endif /* _ASM_ARM_XEN_INTERFACE_H */
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
new file mode 100644
index 0000000..0bad594
--- /dev/null
+++ b/arch/arm/xen/Makefile
@@ -0,0 +1 @@
+obj-y		:= enlighten.o
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
new file mode 100644
index 0000000..c535540
--- /dev/null
+++ b/arch/arm/xen/enlighten.c
@@ -0,0 +1,35 @@
+#include <xen/xen.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/platform_pci.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <linux/module.h>
+
+struct start_info _xen_start_info;
+struct start_info *xen_start_info = &_xen_start_info;
+EXPORT_SYMBOL_GPL(xen_start_info);
+
+enum xen_domain_type xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
+
+struct shared_info xen_dummy_shared_info;
+struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
+
+DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
+
+/* TODO: to be removed */
+__read_mostly int xen_have_vector_callback;
+EXPORT_SYMBOL_GPL(xen_have_vector_callback);
+
+int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
+EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
+
+int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
+			       unsigned long addr,
+			       unsigned long mfn, int nr,
+			       pgprot_t prot, unsigned domid)
+{
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
diff --git a/include/xen/xen.h b/include/xen/xen.h
index a164024..2c0d3a5 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -23,7 +23,7 @@ extern enum xen_domain_type xen_domain_type;
 #include <xen/interface/xen.h>
 #include <asm/xen/hypervisor.h>
 
-#define xen_initial_domain()	(xen_pv_domain() && \
+#define xen_initial_domain()	(xen_domain() && \
 				 xen_start_info->flags & SIF_INITDOMAIN)
 #else  /* !CONFIG_XEN_DOM0 */
 #define xen_initial_domain()	(0)
-- 
1.7.2.5

