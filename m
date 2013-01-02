Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3ABW6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:58:25 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:58474 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752769Ab3ABW6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:58:21 -0500
X-TM-IMSS-Message-ID: <5cefc39500096f1c@nsa.gov>
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
To: viro@ZenIV.linux.org.uk, konrad.wilk@oracle.com
Cc: david.vrabel@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [PATCH 1/3] xen/gntdev: fix unsafe vma access
Date: Wed,  2 Jan 2013 17:57:11 -0500
Message-Id: <1357167433-16874-2-git-send-email-dgdegra@tycho.nsa.gov>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
References: <20121221201824.GA31554@phenom.dumpdata.com>
 <1357167433-16874-1-git-send-email-dgdegra@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gntdev_ioctl_get_offset_for_vaddr, we need to hold mmap_sem while
calling find_vma() to avoid potentially having the result freed out from
under us.  Similarly, the MMU notifier functions need to synchronize with
gntdev_vma_close to avoid map->vma being freed during their iteration.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
---
 drivers/xen/gntdev.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2e22df2..cca62cc 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -378,7 +378,20 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 	struct grant_map *map = vma->vm_private_data;
 
 	pr_debug("gntdev_vma_close %p\n", vma);
-	map->vma = NULL;
+	if (use_ptemod) {
+		struct file *file = vma->vm_file;
+		struct gntdev_priv *priv = file->private_data;
+		/* It is possible that an mmu notifier could be running
+		 * concurrently, so take priv->lock to ensure that the vma won't
+		 * vanishing during the unmap_grant_pages call, since we will
+		 * spin here until that completes. Such a concurrent call will
+		 * not do any unmapping, since that has been done prior to
+		 * closing the vma, but it may still iterate the unmap_ops list.
+		 */
+		spin_lock(&priv->lock);
+		map->vma = NULL;
+		spin_unlock(&priv->lock);
+	}
 	vma->vm_private_data = NULL;
 	gntdev_put_map(map);
 }
@@ -579,25 +592,31 @@ static long gntdev_ioctl_get_offset_for_vaddr(struct gntdev_priv *priv,
 	struct ioctl_gntdev_get_offset_for_vaddr op;
 	struct vm_area_struct *vma;
 	struct grant_map *map;
+	int rv = -EINVAL;
 
 	if (copy_from_user(&op, u, sizeof(op)) != 0)
 		return -EFAULT;
 	pr_debug("priv %p, offset for vaddr %lx\n", priv, (unsigned long)op.vaddr);
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, op.vaddr);
 	if (!vma || vma->vm_ops != &gntdev_vmops)
-		return -EINVAL;
+		goto out_unlock;
 
 	map = vma->vm_private_data;
 	if (!map)
-		return -EINVAL;
+		goto out_unlock;
 
 	op.offset = map->index << PAGE_SHIFT;
 	op.count = map->count;
+	rv = 0;
 
-	if (copy_to_user(u, &op, sizeof(op)) != 0)
+ out_unlock:
+	up_read(&current->mm->mmap_sem);
+
+	if (rv == 0 && copy_to_user(u, &op, sizeof(op)) != 0)
 		return -EFAULT;
-	return 0;
+	return rv;
 }
 
 static long gntdev_ioctl_notify(struct gntdev_priv *priv, void __user *u)
-- 
1.7.11.7

