Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1AJKfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1AJKft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:49 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293779"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "Derek G. Murray" <Derek.Murray@cl.cam.ac.uk>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/12] xen: gntdev: move use of GNTMAP_contains_pte next to the map_op
Date: Mon, 10 Jan 2011 10:36:35 +0000
Message-Id: <1294655801-16230-6-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:48.0627 (UTC) FILETIME=[25470630:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

This flag controls the meaning of gnttab_map_grant_ref.host_addr and
specifies that the field contains a reference to the pte entry to be
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
index fa6355a..888d763 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -211,10 +211,12 @@ static int find_grant_ptes(pte_t *pte, pgtable_t token,
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
@@ -569,7 +571,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	vma->vm_private_data = map;
 	map->vma = vma;
 
-	map->flags = GNTMAP_host_map | GNTMAP_application_map | GNTMAP_contains_pte;
+	map->flags = GNTMAP_host_map | GNTMAP_application_map;
 	if (!(vma->vm_flags & VM_WRITE))
 		map->flags |= GNTMAP_readonly;
 
-- 
1.5.6.5

