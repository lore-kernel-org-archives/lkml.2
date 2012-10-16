Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2JPQ1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:27:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36464 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2JPQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:27:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,593,1344211200"; 
   d="scan'208";a="15208854"
Message-ID: <1350404821.2460.3.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH V2 3/7]: PVH:  mmu related changes.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Date: Tue, 16 Oct 2012 17:27:01 +0100
In-Reply-To: <1350032276.14806.53.camel@zakaz.uk.xensource.com>
References: <20121011145817.0d744c99@mantra.us.oracle.com>
	 <1350032276.14806.53.camel@zakaz.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 09:57 +0100, Ian Campbell wrote:
> > +int xen_unmap_domain_mfn_range(struct vm_area_struct *vma)
> > +{
> > +       int numpgs = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > +       struct page **pages = vma ? vma->vm_private_data : NULL;
> 
> I thought we agreed to keep uses of vm_private_data in the privcmd
> driver?
> 
> I think you should just add pages and nr as direct parameters to this
> function, which is symmetric with the map call.

I had to look at this while rebasing my arm patches, turned out to be
fairly simple. Feel free to either fold in or badger me for a proper
commit message.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

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
index db3b3b7..dc63e80 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -29,6 +29,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       xen_pfn_t mfn, int nr,
 			       pgprot_t prot, unsigned domid,
 			       struct page **pages);
-int xen_unmap_domain_mfn_range(struct vm_area_struct *vma);
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       struct page **pages, int nr);
 
 #endif /* INCLUDE_XEN_OPS_H */


