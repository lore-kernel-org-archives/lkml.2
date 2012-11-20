Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2KTPSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:18:41 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2KTPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:17 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 05/11] x86/xen: Register resources required by kexec-tools
Date: Tue, 20 Nov 2012 16:04:47 +0100
Message-Id: <1353423893-23125-6-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-5-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-4-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-5-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.006529
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register resources required by kexec-tools.

v2 - suggestions/fixes:
   - change logging level
     (suggested by Konrad Rzeszutek Wilk).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/kexec.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 150 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/xen/kexec.c

diff --git a/arch/x86/xen/kexec.c b/arch/x86/xen/kexec.c
new file mode 100644
index 0000000..7ec4c45
--- /dev/null
+++ b/arch/x86/xen/kexec.c
@@ -0,0 +1,150 @@
+/*
+ * Copyright (c) 2011 Daniel Kiper
+ * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
+ *
+ * kexec/kdump implementation for Xen was written by Daniel Kiper.
+ * Initial work on it was sponsored by Google under Google Summer
+ * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
+ * was the mentor for this project.
+ *
+ * Some ideas are taken from:
+ *   - native kexec/kdump implementation,
+ *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
+ *   - PV-GRUB.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include <xen/interface/platform.h>
+#include <xen/interface/xen.h>
+#include <xen/xen.h>
+
+#include <asm/xen/hypercall.h>
+
+unsigned long xen_vmcoreinfo_maddr = 0;
+unsigned long xen_vmcoreinfo_max_size = 0;
+
+static int __init xen_init_kexec_resources(void)
+{
+	int rc;
+	static struct resource xen_hypervisor_res = {
+		.name = "Hypervisor code and data",
+		.flags = IORESOURCE_BUSY | IORESOURCE_MEM
+	};
+	struct resource *cpu_res;
+	struct xen_kexec_range xkr;
+	struct xen_platform_op cpuinfo_op;
+	uint32_t cpus, i;
+
+	if (!xen_initial_domain())
+		return 0;
+
+	if (strstr(boot_command_line, "crashkernel="))
+		pr_warn("kexec: Ignoring crashkernel option. "
+			"It should be passed to Xen hypervisor.\n");
+
+	/* Register Crash kernel resource. */
+	xkr.range = KEXEC_RANGE_MA_CRASH;
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
+
+	if (rc) {
+		pr_warn("kexec: %s: HYPERVISOR_kexec_op(KEXEC_RANGE_MA_CRASH)"
+			": %i\n", __func__, rc);
+		return rc;
+	}
+
+	if (!xkr.size)
+		return 0;
+
+	crashk_res.start = xkr.start;
+	crashk_res.end = xkr.start + xkr.size - 1;
+	insert_resource(&iomem_resource, &crashk_res);
+
+	/* Register Hypervisor code and data resource. */
+	xkr.range = KEXEC_RANGE_MA_XEN;
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
+
+	if (rc) {
+		pr_warn("kexec: %s: HYPERVISOR_kexec_op(KEXEC_RANGE_MA_XEN)"
+			": %i\n", __func__, rc);
+		return rc;
+	}
+
+	xen_hypervisor_res.start = xkr.start;
+	xen_hypervisor_res.end = xkr.start + xkr.size - 1;
+	insert_resource(&iomem_resource, &xen_hypervisor_res);
+
+	/* Determine maximum number of physical CPUs. */
+	cpuinfo_op.cmd = XENPF_get_cpuinfo;
+	cpuinfo_op.u.pcpu_info.xen_cpuid = 0;
+	rc = HYPERVISOR_dom0_op(&cpuinfo_op);
+
+	if (rc) {
+		pr_warn("kexec: %s: HYPERVISOR_dom0_op(): %i\n", __func__, rc);
+		return rc;
+	}
+
+	cpus = cpuinfo_op.u.pcpu_info.max_present + 1;
+
+	/* Register CPUs Crash note resources. */
+	cpu_res = kcalloc(cpus, sizeof(struct resource), GFP_KERNEL);
+
+	if (!cpu_res) {
+		pr_warn("kexec: %s: kcalloc(): %i\n", __func__, -ENOMEM);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < cpus; ++i) {
+		xkr.range = KEXEC_RANGE_MA_CPU;
+		xkr.nr = i;
+		rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
+
+		if (rc) {
+			pr_warn("kexec: %s: cpu: %u: HYPERVISOR_kexec_op"
+				"(KEXEC_RANGE_MA_XEN): %i\n", __func__, i, rc);
+			continue;
+		}
+
+		cpu_res->name = "Crash note";
+		cpu_res->start = xkr.start;
+		cpu_res->end = xkr.start + xkr.size - 1;
+		cpu_res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+		insert_resource(&iomem_resource, cpu_res++);
+	}
+
+	/* Get vmcoreinfo address and maximum allowed size. */
+	xkr.range = KEXEC_RANGE_MA_VMCOREINFO;
+	rc = HYPERVISOR_kexec_op(KEXEC_CMD_kexec_get_range, &xkr);
+
+	if (rc) {
+		pr_warn("kexec: %s: HYPERVISOR_kexec_op(KEXEC_RANGE_MA_VMCOREINFO)"
+			": %i\n", __func__, rc);
+		return rc;
+	}
+
+	xen_vmcoreinfo_maddr = xkr.start;
+	xen_vmcoreinfo_max_size = xkr.size;
+
+	return 0;
+}
+
+core_initcall(xen_init_kexec_resources);
-- 
1.5.6.5

