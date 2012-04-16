Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2DPSqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:46:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36950 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2DPSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:46:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: xen-devel@lists.xensource.com, suresh.b.siddha@intel.com, hpa@zytor.com,
        hpa@zytor.co, tglx@linutronix.de,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen/x86: Implement x86_apic_ops
Date: Mon, 16 Apr 2012 14:40:15 -0400
Message-Id: <1334601616-25309-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
References: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F8C68E8.0046,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or rather just implement one different function as opposed
to the native one : the read function.

We synthesize the values.

Acked-by:  Suresh Siddha <suresh.b.siddha@intel.com>
[v1: Rebased on top of tip/x86/urgent]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/Makefile    |    2 +-
 arch/x86/xen/apic.c      |   17 +++++++++++++++++
 arch/x86/xen/enlighten.c |    2 ++
 arch/x86/xen/xen-ops.h   |    4 ++++
 4 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/xen/apic.c

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
index 0000000..aee16ab
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,17 @@
+#include <linux/init.h>
+#include <asm/x86_init.h>
+
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+{
+	if (reg == 0x1)
+		return 0x00170020;
+	else if (reg == 0x0)
+		return apic << 24;
+
+	return 0xff;
+}
+
+void __init xen_init_apic(void)
+{
+	x86_io_apic_ops.read = xen_io_apic_read;
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 4f51beb..2e9cde8 100644
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
-- 
1.7.7.5

