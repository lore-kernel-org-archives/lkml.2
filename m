Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab2INLlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:41:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46891 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400Ab2INLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:41:05 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="208102944"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 14/24] xen/arm: initialize grant_table on ARM
Date: Fri, 14 Sep 2012 12:13:16 +0100
Message-ID: <1347621207-11294-14-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the grant table mapping at the address specified at index 0
in the DT under the /xen node.
After the grant table is initialized, call xenbus_probe (if not dom0).

Changes in v2:

- introduce GRANT_TABLE_PHYSADDR;
- remove unneeded initialization of boot_max_nr_grant_frames.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index c2a47a7..036a4d8 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -1,8 +1,12 @@
 #include <xen/xen.h>
+#include <xen/grant_table.h>
+#include <xen/hvm.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
+#include <xen/interface/hvm/params.h>
 #include <xen/features.h>
 #include <xen/platform_pci.h>
+#include <xen/xenbus.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/module.h>
@@ -42,6 +46,7 @@ EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
  */
+#define GRANT_TABLE_PHYSADDR 0
 static int __init xen_guest_init(void)
 {
 	struct xen_add_to_physmap xatp;
@@ -51,6 +56,7 @@ static int __init xen_guest_init(void)
 	const char *s = NULL;
 	const char *version = NULL;
 	const char *xen_prefix = "xen,xen-";
+	struct resource res;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
@@ -65,6 +71,9 @@ static int __init xen_guest_init(void)
 		pr_debug("Xen version not found\n");
 		return 0;
 	}
+	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
+		return 0;
+	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
@@ -98,6 +107,11 @@ static int __init xen_guest_init(void)
 	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
 	 * for secondary CPUs as they are brought up. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
+
+	gnttab_init();
+	if (!xen_initial_domain())
+		xenbus_probe(NULL);
+
 	return 0;
 }
 core_initcall(xen_guest_init);
-- 
1.7.2.5

