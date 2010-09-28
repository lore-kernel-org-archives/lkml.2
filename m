Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0I1MRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:17:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:16725 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0I1MRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:38 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729393"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stephen Tweedie <sct@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 12/12] xen/mtrr: Add mtrr_if support for Xen mtrr
Date: Tue, 28 Sep 2010 13:16:58 +0100
Message-Id: <1285676218-26218-12-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:22.0463 (UTC) FILETIME=[1A869AF0:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Tweedie <sct@redhat.com>

Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
querying the hypervisor itself.)

[ Impact: add basic MTRR support ]

Signed-off-by: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/cpu/mtrr/Makefile |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c   |    3 +
 arch/x86/kernel/cpu/mtrr/mtrr.h   |    7 ++
 arch/x86/kernel/cpu/mtrr/xen.c    |  110 +++++++++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c

diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index ad9e5ed..e955771 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,3 @@
 obj-y		:= main.o if.o generic.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
-
+obj-$(CONFIG_XEN) += xen.o
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 91f8f62..fcfa520 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -727,6 +727,9 @@ void __init mtrr_bp_init(void)
 		}
 	}
 
+	/* Let Xen code override the above if it wants */
+	xen_init_mtrr();
+
 	if (mtrr_if) {
 		num_var_ranges = mtrr_if->num_var_ranges();
 		init_table();
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index add8abe..8f0693e 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -74,6 +74,13 @@ void mtrr_wrmsr(unsigned, unsigned, unsigned);
 int amd_init_mtrr(void);
 int cyrix_init_mtrr(void);
 int centaur_init_mtrr(void);
+#ifdef CONFIG_XEN
+void xen_init_mtrr(void);
+#else
+static inline void xen_init_mtrr(void)
+{
+}
+#endif
 
 extern int changed_by_mtrr_cleanup;
 extern int mtrr_cleanup(unsigned address_bits);
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
new file mode 100644
index 0000000..fec3b0a
--- /dev/null
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -0,0 +1,110 @@
+#include <linux/init.h>
+#include <linux/mm.h>
+
+#include <asm/pat.h>
+#include <asm/mtrr.h>
+
+#include "mtrr.h"
+
+#include <xen/xen.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+static void xen_set_mtrr(unsigned int reg, unsigned long base,
+			 unsigned long size, mtrr_type type)
+{
+	struct xen_platform_op op;
+	int error;
+
+	/* mtrr_ops->set() is called once per CPU,
+	 * but Xen's ops apply to all CPUs.
+	 */
+	if (smp_processor_id())
+		return;
+
+	if (size == 0) {
+		op.cmd = XENPF_del_memtype;
+		op.u.del_memtype.handle = 0;
+		op.u.del_memtype.reg    = reg;
+	} else {
+		op.cmd = XENPF_add_memtype;
+		op.u.add_memtype.mfn     = base;
+		op.u.add_memtype.nr_mfns = size;
+		op.u.add_memtype.type    = type;
+	}
+
+	error = HYPERVISOR_dom0_op(&op);
+	BUG_ON(error != 0);
+}
+
+static void xen_get_mtrr(unsigned int reg, unsigned long *base,
+			 unsigned long *size, mtrr_type *type)
+{
+	struct xen_platform_op op;
+
+	op.cmd = XENPF_read_memtype;
+	op.u.read_memtype.reg = reg;
+	if (HYPERVISOR_dom0_op(&op) != 0) {
+		*base = 0;
+		*size = 0;
+		*type = 0;
+		return;
+	}
+
+	*size = op.u.read_memtype.nr_mfns;
+	*base = op.u.read_memtype.mfn;
+	*type = op.u.read_memtype.type;
+}
+
+static int __init xen_num_var_ranges(void)
+{
+	int ranges;
+	struct xen_platform_op op;
+
+	op.cmd = XENPF_read_memtype;
+
+	for (ranges = 0; ; ranges++) {
+		op.u.read_memtype.reg = ranges;
+		if (HYPERVISOR_dom0_op(&op) != 0)
+			break;
+	}
+	return ranges;
+}
+
+/*
+ * DOM0 TODO: Need to fill in the remaining mtrr methods to have full
+ * working userland mtrr support.
+ */
+static struct mtrr_ops xen_mtrr_ops = {
+	.vendor            = X86_VENDOR_UNKNOWN,
+	.get_free_region   = generic_get_free_region,
+	.set               = xen_set_mtrr,
+	.get               = xen_get_mtrr,
+	.have_wrcomb       = positive_have_wrcomb,
+	.validate_add_page = generic_validate_add_page,
+	.use_intel_if	   = 0,
+	.num_var_ranges	   = xen_num_var_ranges,
+};
+
+void __init xen_init_mtrr(void)
+{
+	/* 
+	 * Check that we're running under Xen, and privileged enough
+	 * to play with MTRRs.
+	 */
+	if (!xen_initial_domain())
+		return;
+
+	/* 
+	 * Check that the CPU has an MTRR implementation we can
+	 * support.
+	 */
+	if (cpu_has_mtrr ||
+	    cpu_has_k6_mtrr ||
+	    cpu_has_cyrix_arr ||
+	    cpu_has_centaur_mcr) {
+		mtrr_if = &xen_mtrr_ops;
+		pat_init();
+	}
+}
-- 
1.5.6.5

