Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749Ab2JXNTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:19:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49022 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab2JXNTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:19:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="42269816"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 2/5] xen: arm: enable balloon driver
Date: Wed, 24 Oct 2012 14:19:34 +0100
Message-ID: <1351084777-28898-2-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is no in a state where can just enable it.

Drop the *_xenballloned_pages duplicates since these are now supplied
by the balloon code.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |   23 +++++------------------
 drivers/xen/Makefile     |    4 ++--
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 59bcb96..ba5cc13 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -8,6 +8,7 @@
 #include <xen/features.h>
 #include <xen/platform_pci.h>
 #include <xen/xenbus.h>
+#include <xen/page.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/interrupt.h>
@@ -29,6 +30,10 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 
+/* These are unused until we support booting "pre-ballooned" */
+unsigned long xen_released_pages;
+struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
+
 /* TODO: to be removed */
 __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
@@ -148,21 +153,3 @@ static int __init xen_init_events(void)
 	return 0;
 }
 postcore_initcall(xen_init_events);
-
-/* XXX: only until balloon is properly working */
-int alloc_xenballooned_pages(int nr_pages, struct page **pages, bool highmem)
-{
-	*pages = alloc_pages(highmem ? GFP_HIGHUSER : GFP_KERNEL,
-			get_order(nr_pages));
-	if (*pages == NULL)
-		return -ENOMEM;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(alloc_xenballooned_pages);
-
-void free_xenballooned_pages(int nr_pages, struct page **pages)
-{
-	kfree(*pages);
-	*pages = NULL;
-}
-EXPORT_SYMBOL_GPL(free_xenballooned_pages);
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 0e863703..909bb56 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,8 +1,8 @@
 ifneq ($(CONFIG_ARM),y)
-obj-y	+= manage.o balloon.o
+obj-y	+= manage.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 endif
-obj-y	+= grant-table.o features.o events.o
+obj-y	+= grant-table.o features.o events.o balloon.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
-- 
1.7.2.5

