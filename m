Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab2GZP5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:57:10 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7827 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab2GZP5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:57:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32691226"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 14/24] xen/arm: initialize grant_table on ARM
Date: Thu, 26 Jul 2012 16:33:56 +0100
Message-ID: <1343316846-25860-14-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the grant table mapping at the address specified at index 0
in the DT under the /xen node.
After the grant table is initialized, call xenbus_probe (if not dom0).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c  |   13 +++++++++++++
 drivers/xen/grant-table.c |    2 +-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 2e013cf..854af1e 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -1,8 +1,12 @@
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
+#include <xen/interface/hvm/params.h>
 #include <xen/platform_pci.h>
 #include <xen/features.h>
+#include <xen/grant_table.h>
+#include <xen/hvm.h>
+#include <xen/xenbus.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/module.h>
@@ -51,12 +55,16 @@ int __init xen_guest_init(void)
 	struct xen_add_to_physmap xatp;
 	static struct shared_info *shared_info_page = 0;
 	struct device_node *node;
+	struct resource res;
 
 	node = of_find_compatible_node(NULL, NULL, "arm,xen");
 	if (!node) {
 		pr_info("No Xen support\n");
 		return 0;
 	}
+	if (of_address_to_resource(node, 0, &res))
+		return -EINVAL;
+	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
@@ -97,6 +105,11 @@ int __init xen_guest_init(void)
 		per_cpu(xen_vcpu, cpu) =
 			&HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
+
+	gnttab_init();
+	if (!xen_initial_domain())
+		xenbus_probe(NULL);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_guest_init);
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 1d0d95e..fd2137a 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -62,7 +62,7 @@
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
-static unsigned int boot_max_nr_grant_frames;
+static unsigned int boot_max_nr_grant_frames = 1;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
-- 
1.7.2.5

