Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab1BLDaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 22:30:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51201 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab1BLD37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 22:29:59 -0500
Date: Fri, 11 Feb 2011 19:29:44 -0800
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Eugene Teo <eugeneteo@kernel.org>
Subject: [PATCH] drm: do not leak kernel addresses via /proc/dri/*/vma
Message-ID: <20110212032944.GA24080@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the continuing effort to avoid kernel addresses leaking to unprivileged
users, this patch switches to %pK for /proc/dri/*/vma.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/gpu/drm/drm_info.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
index 3cdbaf3..be9a9c0 100644
--- a/drivers/gpu/drm/drm_info.c
+++ b/drivers/gpu/drm/drm_info.c
@@ -283,17 +283,18 @@ int drm_vma_info(struct seq_file *m, void *data)
 #endif
 
 	mutex_lock(&dev->struct_mutex);
-	seq_printf(m, "vma use count: %d, high_memory = %p, 0x%08llx\n",
+	seq_printf(m, "vma use count: %d, high_memory = %pK, 0x%pK\n",
 		   atomic_read(&dev->vma_count),
-		   high_memory, (u64)virt_to_phys(high_memory));
+		   high_memory, (void *)virt_to_phys(high_memory));
 
 	list_for_each_entry(pt, &dev->vmalist, head) {
 		vma = pt->vma;
 		if (!vma)
 			continue;
 		seq_printf(m,
-			   "\n%5d 0x%08lx-0x%08lx %c%c%c%c%c%c 0x%08lx000",
-			   pt->pid, vma->vm_start, vma->vm_end,
+			   "\n%5d 0x%pK-0x%pK %c%c%c%c%c%c 0x%08lx000",
+			   pt->pid,
+			   (void *)vma->vm_start, (void *)vma->vm_end,
 			   vma->vm_flags & VM_READ ? 'r' : '-',
 			   vma->vm_flags & VM_WRITE ? 'w' : '-',
 			   vma->vm_flags & VM_EXEC ? 'x' : '-',
-- 
1.7.2.3

-- 
Kees Cook
Ubuntu Security Team
