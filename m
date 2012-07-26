Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2GZPe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:34:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33772 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab2GZPe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:34:57 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32688377"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 07/24] xen/arm: Xen detection and shared_info page mapping
Date: Thu, 26 Jul 2012 16:33:49 +0100
Message-ID: <1343316846-25860-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for a "/xen" node in the device tree, if it is present set
xen_domain_type to XEN_HVM_DOMAIN and continue initialization.

Map the real shared info page using XENMEM_add_to_physmap with
XENMAPSPACE_shared_info.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index d27c2a6..8c923af 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -5,6 +5,9 @@
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 struct start_info _xen_start_info;
 struct start_info *xen_start_info = &_xen_start_info;
@@ -33,3 +36,56 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
+
+/*
+ * == Xen Device Tree format ==
+ * - /xen node;
+ * - compatible "arm,xen";
+ * - one interrupt for Xen event notifications;
+ * - one memory region to map the grant_table.
+ */
+static int __init xen_guest_init(void)
+{
+	int cpu;
+	struct xen_add_to_physmap xatp;
+	static struct shared_info *shared_info_page = 0;
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "arm,xen");
+	if (!node) {
+		pr_info("No Xen support\n");
+		return 0;
+	}
+	xen_domain_type = XEN_HVM_DOMAIN;
+
+	if (!shared_info_page)
+		shared_info_page = (struct shared_info *)
+			get_zeroed_page(GFP_KERNEL);
+	if (!shared_info_page) {
+		pr_err("not enough memory");
+		return -ENOMEM;
+	}
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		BUG();
+
+	HYPERVISOR_shared_info = (struct shared_info *)shared_info_page;
+
+	/* xen_vcpu is a pointer to the vcpu_info struct in the shared_info
+	 * page, we use it in the event channel upcall and in some pvclock
+	 * related functions. We don't need the vcpu_info placement
+	 * optimizations because we don't use any pv_mmu or pv_irq op on
+	 * HVM.
+	 * When xen_hvm_init_shared_info is run at boot time only vcpu 0 is
+	 * online but xen_hvm_init_shared_info is run at resume time too and
+	 * in that case multiple vcpus might be online. */
+	for_each_online_cpu(cpu) {
+		per_cpu(xen_vcpu, cpu) =
+			&HYPERVISOR_shared_info->vcpu_info[cpu];
+	}
+	return 0;
+}
+core_initcall(xen_guest_init);
-- 
1.7.2.5

