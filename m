Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab2JQLdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:33:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52386 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab2JQLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344211200"; 
   d="scan'208";a="41487903"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 3/6] xen: avoid use of vma->vm_private in xen_unmap_domain_mfn_range interface
Date: Wed, 17 Oct 2012 12:32:09 +0100
Message-ID: <1350473532-15863-3-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
I beleive Mukesh has something similar in his tree. Should be trivial
to resolve I think. I'm happy to do so ontop of PVH v3 when it arrives.
---
 arch/x86/xen/mmu.c    |    6 ++----
 drivers/xen/privcmd.c |    2 +-
 include/xen/xen-ops.h |    3 ++-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 018cbf0..1c5812b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2655,11 +2655,9 @@ out:
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
 
 /* Returns: 0 success */
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       struct page **pages, int numpgs)
 {
-	int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	struct page **pages = vma ? vma->vm_private_data : NULL;
-
 	if (!pages || !xen_feature(XENFEAT_auto_translated_physmap))
 		return 0;
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 641a420..a1ca5ab 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -498,7 +498,7 @@ static void privcmd_close(struct vm_area_struct *vma)
 	if (!pages || !numpgs || !xen_feature(XENFEAT_auto_translated_physmap))
 		return;
 
-	xen_unmap_domain_mfn_range(vma);
+	xen_unmap_domain_mfn_range(vma, pages, numpgs);
 	while (numpgs--)
 		free_xenballooned_pages(1, &pages[numpgs]);
 	kfree(pages);
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 8b24315..6a40253 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -29,6 +29,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long mfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages);
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma);
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       struct page **pages, int nr);
 
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.7.2.5

