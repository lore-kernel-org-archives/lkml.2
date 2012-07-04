Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030276Ab2GDLPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:15:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56771 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587Ab2GDLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="30393583"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, david.vrabel@citrix.com
Subject: [PATCH WIP 1/5] xen/arm: initialize grant_table on ARM
Date: Wed, 4 Jul 2012 12:15:16 +0100
Message-ID: <1341400520-31770-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the grant table mapping it at HVM_PARAM_GRANT_START_PFN.
After the grant table is initialized, call xenbus_probe (if not dom0).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c           |   18 ++++++++++++++++++
 drivers/xen/grant-table.c          |    2 +-
 include/xen/interface/hvm/params.h |    4 +++-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index ddacecf..6901e37 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -1,9 +1,13 @@
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
+#include <xen/interface/hvm/params.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <xen/features.h>
+#include <xen/grant_table.h>
+#include <xen/hvm.h>
+#include <xen/xenbus.h>
 
 #include <linux/module.h>
 
@@ -133,6 +137,7 @@ static void __init xen_hvm_init_shared_info(void)
 	int cpu;
 	struct xen_add_to_physmap xatp;
 	static struct shared_info *shared_info_page = 0;
+	uint64_t val;
 
 	xen_setup_features();
 	if (xen_feature(XENFEAT_dom0))
@@ -171,6 +176,19 @@ static void __init xen_hvm_init_shared_info(void)
 	for_each_online_cpu(cpu) {
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
+
+	if (!xen_hvm_resume_frames) {
+		if (hvm_get_parameter(HVM_PARAM_GRANT_START_PFN, &val) >= 0)
+			xen_hvm_resume_frames = val << PAGE_SHIFT;
+		else {
+			printk(KERN_ERR "error getting "
+					"HVM_PARAM_GRANT_START_PFN");
+			return;
+		}
+	}
+	gnttab_init();
+	if (!xen_initial_domain())
+		xenbus_probe(NULL);
 }
 core_initcall(xen_hvm_init_shared_info);
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index db3964b..766fc35 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -58,7 +58,7 @@
 
 static grant_ref_t **gnttab_list;
 static unsigned int nr_grant_frames;
-static unsigned int boot_max_nr_grant_frames;
+static unsigned int boot_max_nr_grant_frames = 1;
 static int gnttab_free_count;
 static grant_ref_t gnttab_free_head;
 static DEFINE_SPINLOCK(gnttab_list_lock);
diff --git a/include/xen/interface/hvm/params.h b/include/xen/interface/hvm/params.h
index 1b4f923..e51269b 100644
--- a/include/xen/interface/hvm/params.h
+++ b/include/xen/interface/hvm/params.h
@@ -94,6 +94,8 @@
 #define HVM_PARAM_CONSOLE_PFN    17
 #define HVM_PARAM_CONSOLE_EVTCHN 18
 
-#define HVM_NR_PARAMS          19
+#define HVM_PARAM_GRANT_START_PFN 30
+
+#define HVM_NR_PARAMS          31
 
 #endif /* __XEN_PUBLIC_HVM_PARAMS_H__ */
-- 
1.7.2.5

