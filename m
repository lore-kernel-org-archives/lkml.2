Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762619Ab2FVQPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:15:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57722 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762508Ab2FVQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336363200"; 
   d="scan'208";a="199722609"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <tim@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH WIP 3/6] xen/arm: get privilege status
Date: Fri, 22 Jun 2012 17:14:42 +0100
Message-ID: <1340381685-22529-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
 <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Xen features to figure out if we are privileged.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c         |    9 ++++++++-
 include/xen/interface/features.h |    3 +++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index e1c2e4d..ddacecf 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -3,6 +3,7 @@
 #include <xen/interface/memory.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <xen/features.h>
 
 #include <linux/module.h>
 
@@ -11,7 +12,7 @@
 
 #include <asm/pgtable.h>
 
-struct start_info _xen_start_info = { .flags = (SIF_INITDOMAIN|SIF_PRIVILEGED) };
+struct start_info _xen_start_info;
 struct start_info *xen_start_info = &_xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
@@ -133,6 +134,12 @@ static void __init xen_hvm_init_shared_info(void)
 	struct xen_add_to_physmap xatp;
 	static struct shared_info *shared_info_page = 0;
 
+	xen_setup_features();
+	if (xen_feature(XENFEAT_dom0))
+		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
+	else
+		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
+
 	/* already setup */
 	if (shared_info_page != 0 && HYPERVISOR_shared_info == shared_info_page)
 		return;
diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
index b6ca39a..131a6cc 100644
--- a/include/xen/interface/features.h
+++ b/include/xen/interface/features.h
@@ -50,6 +50,9 @@
 /* x86: pirq can be used by HVM guests */
 #define XENFEAT_hvm_pirqs           10
 
+/* operation as Dom0 is supported */
+#define XENFEAT_dom0                      11
+
 #define XENFEAT_NR_SUBMAPS 1
 
 #endif /* __XEN_PUBLIC_FEATURES_H__ */
-- 
1.7.2.5

