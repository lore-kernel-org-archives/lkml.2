Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2JQLcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:32:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56272 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756224Ab2JQLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344211200"; 
   d="scan'208";a="41487904"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 6/6] xen: x86 pvh: use XENMEM_add_to_physmap_range for foreign gmfn mappings
Date: Wed, 17 Oct 2012 12:32:12 +0100
Message-ID: <1350473532-15863-6-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
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
---
 arch/x86/xen/mmu.c             |   18 ++++++++++++------
 include/xen/interface/memory.h |   24 +++++++++++-------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d779e96..e7edcdd 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2506,13 +2506,19 @@ static int pvh_add_to_xen_p2m(unsigned long lpfn, unsigned long fgmfn,
 			      unsigned int domid)
 {
 	int rc;
-	struct xen_add_to_physmap xatp = { .u.foreign_domid = domid };
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
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index eb2d3e5..b40a431 100644
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
@@ -163,22 +171,12 @@ struct xen_add_to_physmap {
     /* Which domain to change the mapping for. */
     domid_t domid;
 
-    union {
-	/* Number of pages to go through for gmfn_range */
-	uint16_t    size;
-	/* IFF XENMAPSPACE_gmfn_foreign */
-	domid_t foreign_domid;
-    } u;
+    /* Number of pages to go through for gmfn_range */
+    uint16_t    size;
+
     /* Source mapping space. */
-#define XENMAPSPACE_shared_info 0 /* shared info page */
-#define XENMAPSPACE_grant_table 1 /* grant table page */
-#define XENMAPSPACE_gmfn        2 /* GMFN */
-#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
-#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
     unsigned int space;
 
-#define XENMAPIDX_grant_table_status 0x80000000
-
     /* Index into source mapping space. */
     xen_ulong_t idx;
 
-- 
1.7.2.5

