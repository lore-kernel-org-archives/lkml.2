Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0LONkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:40:55 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47842 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0LONkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:40:51 -0500
X-IronPort-AV: E=Sophos;i="4.59,349,1288584000"; 
   d="scan'208";a="126991590"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Derek G. Murray" <Derek.Murray@cl.cam.ac.uk>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/11] xen: gntdev: move use of GNTMAP_contains_pte next to the map_op
Date: Wed, 15 Dec 2010 13:40:41 +0000
Message-Id: <1292420446-3348-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
X-OriginalArrivalTime: 15 Dec 2010 13:40:51.0124 (UTC) FILETIME=[B0241F40:01CB9C5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This flag controls the meaning of gnttab_map_grant_ref.host_addr and
specifies that the field contains a refernce to the pte entry to be
used to perform the mapping. Therefore move the use of this flag to
the point at which we actually use a reference to the pte instead of
something else, splitting up the usage of the flag in this way is
confusing and potentially error prone.

The other flags are all properties of the mapping itself as opposed to
properties of the hypercall arguments and therefore it make sense to
continue to pass them round in map->flags.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: Derek G. Murray <Derek.Murray@cl.cam.ac.uk>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/gntdev.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index cf61c7d..b916d6b 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -205,10 +205,12 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token, unsigned long addr, void
 	BUG_ON(pgnr >= map->count);
 	pte_maddr  = (u64)pfn_to_mfn(page_to_pfn(token)) << PAGE_SHIFT;
 	pte_maddr += (unsigned long)pte & ~PAGE_MASK;
-	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, map->flags,
+	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr,
+			  GNTMAP_contains_pte | map->flags,
 			  map->grants[pgnr].ref,
 			  map->grants[pgnr].domid);
-	gnttab_set_unmap_op(&map->unmap_ops[pgnr], pte_maddr, map->flags,
+	gnttab_set_unmap_op(&map->unmap_ops[pgnr], pte_maddr,
+			    GNTMAP_contains_pte | map->flags,
 			    0 /* handle */);
 	return 0;
 }
@@ -579,7 +581,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	vma->vm_private_data = map;
 	map->vma = vma;
 
-	map->flags = GNTMAP_host_map | GNTMAP_application_map | GNTMAP_contains_pte;
+	map->flags = GNTMAP_host_map | GNTMAP_application_map;
 	if (!(vma->vm_flags & VM_WRITE))
 		map->flags |= GNTMAP_readonly;
 
-- 
1.5.6.5

