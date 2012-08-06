Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2HFO4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:56:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13586 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab2HFO43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:56:29 -0400
X-IronPort-AV: E=Sophos;i="4.77,720,1336363200"; 
   d="scan'208";a="33702119"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 13/23] xen/arm: get privilege status
Date: Mon, 6 Aug 2012 15:27:16 +0100
Message-ID: <1344263246-28036-13-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Xen features to figure out if we are privileged.

XENFEAT_dom0 was introduced by 23735 in xen-unstable.hg.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c         |    7 +++++++
 include/xen/interface/features.h |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 102d823..ac3a2d6 100644
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
@@ -57,6 +58,12 @@ static int __init xen_guest_init(void)
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

