Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1AJKf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:35:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36877 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1AJKfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:35:52 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291611600"; 
   d="scan'208";a="130293795"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [PATCH 08/12] xen/gntdev: Fix circular locking dependency
Date: Mon, 10 Jan 2011 10:36:37 +0000
Message-Id: <1294655801-16230-8-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
X-OriginalArrivalTime: 10 Jan 2011 10:35:52.0080 (UTC) FILETIME=[2755E900:01CBB0B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel De Graaf <dgdegra@tycho.nsa.gov>

apply_to_page_range will acquire PTE lock while priv->lock is held,
and mn_invl_range_start tries to acquire priv->lock with PTE already
held.  Fix by not holding priv->lock during the entire map operation.
This is safe because map->vma is set nonzero while the lock is held,
which will cause subsequent maps to fail and will cause the unmap
ioctl (and other users of gntdev_del_map) to return -EBUSY until the
area is unmapped. It is similarly impossible for gntdev_vma_close to
be called while the vma is still being created.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
---
 drivers/xen/gntdev.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index a2ea533..aba76d4 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -575,21 +575,26 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 	if (!(vma->vm_flags & VM_WRITE))
 		map->flags |= GNTMAP_readonly;
 
+	spin_unlock(&priv->lock);
+
 	err = apply_to_page_range(vma->vm_mm, vma->vm_start,
 				  vma->vm_end - vma->vm_start,
 				  find_grant_ptes, map);
 	if (err) {
 		printk(KERN_WARNING "find_grant_ptes() failure.\n");
-		goto unlock_out;
+		return err;
 	}
 
 	err = map_grant_pages(map);
 	if (err) {
 		printk(KERN_WARNING "map_grant_pages() failure.\n");
-		goto unlock_out;
+		return err;
 	}
+
 	map->is_mapped = 1;
 
+	return 0;
+
 unlock_out:
 	spin_unlock(&priv->lock);
 	return err;
-- 
1.5.6.5

