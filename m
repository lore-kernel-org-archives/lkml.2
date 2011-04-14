Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab1DNRp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:37190 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab1DNRpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 004/209] drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.
Date: Thu, 14 Apr 2011 13:40:34 -0400
Message-Id: <1302803039-9400-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Dänzer <daenzer@vmware.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e376573f7267390f4e1bdc552564b6fb913bce76 upstream.

This fixes a problem where on low VRAM cards we'd run out of space for validation.

[airlied: Tested on my M7, Thinkpad T42, compiz works with no problems.]

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/radeon/radeon_object.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 1227747..bae33b7 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -110,16 +110,22 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
 
+retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	r = ttm_bo_init(&rdev->mman.bdev, &bo->tbo, size, type,
 			&bo->placement, 0, 0, !kernel, NULL, size,
 			&radeon_ttm_bo_destroy);
 	if (unlikely(r != 0)) {
-		if (r != -ERESTARTSYS)
+		if (r != -ERESTARTSYS) {
+			if (domain == RADEON_GEM_DOMAIN_VRAM) {
+				domain |= RADEON_GEM_DOMAIN_GTT;
+				goto retry;
+			}
 			dev_err(rdev->dev,
 				"object_init failed for (%lu, 0x%08X)\n",
 				size, domain);
+		}
 		return r;
 	}
 	*bo_ptr = bo;
@@ -314,6 +320,7 @@ int radeon_bo_list_validate(struct list_head *head)
 {
 	struct radeon_bo_list *lobj;
 	struct radeon_bo *bo;
+	u32 domain;
 	int r;
 
 	r = radeon_bo_list_reserve(head);
@@ -323,17 +330,19 @@ int radeon_bo_list_validate(struct list_head *head)
 	list_for_each_entry(lobj, head, list) {
 		bo = lobj->bo;
 		if (!bo->pin_count) {
-			if (lobj->wdomain) {
-				radeon_ttm_placement_from_domain(bo,
-								lobj->wdomain);
-			} else {
-				radeon_ttm_placement_from_domain(bo,
-								lobj->rdomain);
-			}
+			domain = lobj->wdomain ? lobj->wdomain : lobj->rdomain;
+
+		retry:
+			radeon_ttm_placement_from_domain(bo, domain);
 			r = ttm_bo_validate(&bo->tbo, &bo->placement,
 						true, false);
-			if (unlikely(r))
+			if (unlikely(r)) {
+				if (r != -ERESTARTSYS && domain == RADEON_GEM_DOMAIN_VRAM) {
+					domain |= RADEON_GEM_DOMAIN_GTT;
+					goto retry;
+				}
 				return r;
+			}
 		}
 		lobj->gpu_offset = radeon_bo_gpu_offset(bo);
 		lobj->tiling_flags = bo->tiling_flags;
-- 
1.7.4.4

