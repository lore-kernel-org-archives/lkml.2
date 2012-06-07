Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab2FGEhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:37:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006Ab2FGEUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:20:50 -0400
Message-Id: <20120607040346.527632060@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:45 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 69/82] drm/radeon: fix vm deadlocks on cayman
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <deathsimple@vodafone.de>

commit bb4091558228ff4a3e02328c931e683fc7f08722 upstream.

Locking mutex in different orders just screams for
deadlocks, and some testing showed that it is actually
quite easy to trigger them.

Signed-off-by: Christian König <deathsimple@vodafone.de>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_gart.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -478,12 +478,18 @@ int radeon_vm_bo_add(struct radeon_devic
 
 	mutex_lock(&vm->mutex);
 	if (last_pfn > vm->last_pfn) {
-		/* grow va space 32M by 32M */
-		unsigned align = ((32 << 20) >> 12) - 1;
+		/* release mutex and lock in right order */
+		mutex_unlock(&vm->mutex);
 		radeon_mutex_lock(&rdev->cs_mutex);
-		radeon_vm_unbind_locked(rdev, vm);
+		mutex_lock(&vm->mutex);
+		/* and check again */
+		if (last_pfn > vm->last_pfn) {
+			/* grow va space 32M by 32M */
+			unsigned align = ((32 << 20) >> 12) - 1;
+			radeon_vm_unbind_locked(rdev, vm);
+			vm->last_pfn = (last_pfn + align) & ~align;
+		}
 		radeon_mutex_unlock(&rdev->cs_mutex);
-		vm->last_pfn = (last_pfn + align) & ~align;
 	}
 	head = &vm->va;
 	last_offset = 0;
@@ -597,8 +603,8 @@ int radeon_vm_bo_rmv(struct radeon_devic
 	if (bo_va == NULL)
 		return 0;
 
-	mutex_lock(&vm->mutex);
 	radeon_mutex_lock(&rdev->cs_mutex);
+	mutex_lock(&vm->mutex);
 	radeon_vm_bo_update_pte(rdev, vm, bo, NULL);
 	radeon_mutex_unlock(&rdev->cs_mutex);
 	list_del(&bo_va->vm_list);
@@ -643,9 +649,8 @@ void radeon_vm_fini(struct radeon_device
 	struct radeon_bo_va *bo_va, *tmp;
 	int r;
 
-	mutex_lock(&vm->mutex);
-
 	radeon_mutex_lock(&rdev->cs_mutex);
+	mutex_lock(&vm->mutex);
 	radeon_vm_unbind_locked(rdev, vm);
 	radeon_mutex_unlock(&rdev->cs_mutex);
 


