Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762Ab2JXNTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:19:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57900 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934743Ab2JXNTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:19:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="42269820"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 5/5] xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn mappings
Date: Wed, 24 Oct 2012 14:19:37 +0100
Message-ID: <1351084777-28898-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
References: <1351084756.18035.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squeezing the necessary fields into the existing XENMEM_add_to_physmap
interface was proving to be a bit tricky so we have decided to go with
a new interface upstream (the XENMAPSPACE_gmfn_foreign interface using
XENMEM_add_to_physmap was never committed anywhere). This interface
also allows for batching which was impossible to support at the same
time as foreign mfns in the old interface.

This reverts the relevant parts of "PVH: basic and header changes,
elfnote changes, ..." and followups and trivially converts
pvh_add_to_xen_p2m over.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/enlighten.c       |    1 -
 arch/x86/xen/mmu.c             |   18 ++++++++++++------
 drivers/xen/grant-table.c      |    1 -
 include/xen/interface/memory.h |   18 +++++++++---------
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index bf6313b..eb9a567 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1546,7 +1546,6 @@ void __ref xen_hvm_init_shared_info(void)
 	xatp.domid = DOMID_SELF;
 	xatp.idx = 0;
 	xatp.space = XENMAPSPACE_shared_info;
-	xatp.foreign_domid = 0;
 	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
 	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
 		BUG();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 58f2084..fee34fe 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2500,13 +2500,19 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 			      unsigned int domid)
 {
 	int rc;
-	struct xen_add_to_physmap xatp = { .foreign_domid = domid };
+	struct xen_add_to_physmap_range xatp = {
+		.domid = DOMID_SELF,
+		.foreign_domid = domid,
+		.size = 1,
+		.space = XENMAPSPACE_gmfn_foreign,
+	};
+	xen_ulong_t idx = fgmfn;
+	xen_pfn_t gpfn = lpfn;
+
+	set_xen_guest_handle(xatp.idxs, &idx);
+	set_xen_guest_handle(xatp.gpfns, &gpfn);
 
-	xatp.gpfn = lpfn;
-	xatp.idx = fgmfn;
-	xatp.domid = DOMID_SELF;
-	xatp.space = XENMAPSPACE_gmfn_foreign;
-	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
+	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
 	if (rc)
 		pr_warn("d0: Failed to map pfn (0x%lx) to mfn (0x%lx) rc:%d\n",
 			lpfn, fgmfn, rc);
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index adaa4c2..1ab8630 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1049,7 +1049,6 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 		do {
 			xatp.domid = DOMID_SELF;
 			xatp.idx = i;
-			xatp.foreign_domid = 0;
 			xatp.space = XENMAPSPACE_grant_table;
 			xatp.gpfn = start_gpfn + i;
 			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 5de2b36..9dad393 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -153,6 +153,14 @@ struct xen_machphys_mapping {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mapping_t);
 
+#define XENMAPSPACE_shared_info  0 /* shared info page */
+#define XENMAPSPACE_grant_table  1 /* grant table page */
+#define XENMAPSPACE_gmfn         2 /* GMFN */
+#define XENMAPSPACE_gmfn_range   3 /* GMFN range, XENMEM_add_to_physmap only. */
+#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another dom,
+				    * XENMEM_add_to_physmap_range only.
+				    */
+
 /*
  * Sets the GPFN at which a particular page appears in the specified guest's
  * pseudophysical address space.
@@ -167,15 +175,7 @@ struct xen_add_to_physmap {
     uint16_t    size;
 
     /* Source mapping space. */
-#define XENMAPSPACE_shared_info 0 /* shared info page */
-#define XENMAPSPACE_grant_table 1 /* grant table page */
-#define XENMAPSPACE_gmfn        2 /* GMFN */
-#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
-#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
-    uint16_t space;
-    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
-
-#define XENMAPIDX_grant_table_status 0x80000000
+    unsigned int space;
 
     /* Index into source mapping space. */
     xen_ulong_t idx;
-- 
1.7.2.5

