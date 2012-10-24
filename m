Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783Ab2JXNUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:20:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:49022 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934681Ab2JXNTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:19:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="42269817"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 1/5] xen: balloon: allow PVMMU interfaces to be compiled out
Date: Wed, 24 Oct 2012 14:19:33 +0100
Message-ID: <1351084777-28898-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM platform has no concept of PVMMU and therefor no
HYPERVISOR_update_va_mapping et al. Allow this code to be compiled out
when not required.

In some similar situations (e.g. P2M) we have defined dummy functions
to avoid this, however I think we can/should draw the line at dummying
out actual hypercalls.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/xen/Kconfig  |    1 +
 drivers/xen/Kconfig   |    3 +++
 drivers/xen/balloon.c |    4 ++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index c9660bf..7e938ba 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -6,6 +6,7 @@ config XEN
 	bool "Xen guest support"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
+	select XEN_HAVE_PVMMU
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
 	depends on X86_CMPXCHG && X86_TSC
 	help
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d4dffcd..9c00652 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -204,4 +204,7 @@ config XEN_MCE_LOG
 	  Allow kernel fetching MCE error from Xen platform and
 	  converting it into Linux mcelog format for mcelog tools
 
+config XEN_HAVE_PVMMU
+       bool
+
 endmenu
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 66fad33..d42da3b 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -359,6 +359,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 
 		set_phys_to_machine(pfn, frame_list[i]);
 
+#ifdef CONFIG_XEN_HAVE_PVMMU
 		/* Link back into the page tables if not highmem. */
 		if (xen_pv_domain() && !PageHighMem(page) &&
 		    !xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -370,6 +371,7 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
 				0);
 			BUG_ON(ret);
 		}
+#endif
 
 		/* Relinquish the page back to the allocator. */
 		ClearPageReserved(page);
@@ -418,6 +420,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 
 		scrub_page(page);
 
+#ifdef CONFIG_XEN_HAVE_PVMMU
 		if (xen_pv_domain() && !PageHighMem(page)) {
 			if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 				ret = HYPERVISOR_update_va_mapping(
@@ -426,6 +429,7 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 				BUG_ON(ret);
 			}
 		}
+#endif
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */
-- 
1.7.2.5

