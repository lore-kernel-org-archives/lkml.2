Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab2HPP5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:57:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3372 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab2HPP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:57:10 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336363200"; 
   d="scan'208";a="205388723"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <tim@xen.org>, <Ian.Campbell@citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 13/25] xen/arm: get privilege status
Date: Thu, 16 Aug 2012 16:36:05 +0100
Message-ID: <1345131377-14713-13-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Xen features to figure out if we are privileged.

XENFEAT_dom0 was introduced by 23735 in xen-unstable.hg.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/arm/xen/enlighten.c         |    7 +++++++
 include/xen/interface/features.h |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 78ea1f7..e529662 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -1,6 +1,7 @@
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/memory.h>
+#include <xen/features.h>
 #include <xen/platform_pci.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -66,6 +67,12 @@ static int __init xen_guest_init(void)
 	}
 	xen_domain_type = XEN_HVM_DOMAIN;
 
+	xen_setup_features();
+	if (xen_feature(XENFEAT_dom0))
+		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
+	else
+		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
+
 	if (!shared_info_page)
 		shared_info_page = (struct shared_info *)
 			get_zeroed_page(GFP_KERNEL);
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

