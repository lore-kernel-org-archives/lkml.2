Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0LONlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:41:32 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47842 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0LONkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:40:55 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288584000"; 
   d="scan'208";a="126991596"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/11] xen: introduce gnttab_map_refs and gnttab_unmap_refs
Date: Wed, 15 Dec 2010 13:40:44 +0000
Message-Id: <1292420446-3348-9-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
X-OriginalArrivalTime: 15 Dec 2010 13:40:54.0718 (UTC) FILETIME=[B24885E0:01CB9C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

gnttab_map_refs maps some grant refs and uses the new m2p override to
set a proper m2p mapping for the granted pages.

gnttab_unmap_refs unmaps the granted refs and removes th mappings from
the m2p override.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/grant-table.c |   36 ++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |    5 +++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 6c45318..a5cf820 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -447,6 +447,42 @@ unsigned int gnttab_max_grant_frames(void)
 }
 EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
 
+int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+		    struct page **pages, unsigned int count)
+{
+	int i, ret;
+	pte_t val;
+	pte_t *pte;
+	unsigned long pfn, mfn;
+
+	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
+
+	for (i = 0; i < count; i++) {
+		pfn = mfn_to_pfn(map_ops[i].host_addr >> PAGE_SHIFT);
+		pte = (pte_t *) __va((pfn << PAGE_SHIFT) +
+				(map_ops[i].host_addr & ~PAGE_MASK));
+		val = *pte;
+		mfn = (native_pte_val(val) & PTE_PFN_MASK) >> PAGE_SHIFT;
+		m2p_add_override(mfn, pages[i]);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_map_refs);
+
+int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
+		struct page **pages, unsigned int count)
+{
+	int i, ret;
+
+	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
+	for (i = 0; i < count; i++)
+		m2p_remove_override(pages[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
+
 static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
 {
 	struct gnttab_setup_table setup;
diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
index 1821aa1..b1fab6b 100644
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -155,4 +155,9 @@ unsigned int gnttab_max_grant_frames(void);
 
 #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
 
+int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
+		    struct page **pages, unsigned int count);
+int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
+		      struct page **pages, unsigned int count);
+
 #endif /* __ASM_GNTTAB_H__ */
-- 
1.5.6.5

