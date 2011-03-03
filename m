Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab1CCJpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:45:45 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39489 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab1CCJpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:45:44 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>, Andy Whitcroft <apw@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 1/2] drm/radeon: fall back to GTT if bo creation/validation in VRAM fails." has been added to staging queue
Date: Thu,  3 Mar 2011 10:43:39 +0100
Message-Id: <1299145419-4164-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 1/2] drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 23eaa12abcd9afdb374b0176fa8cff5b74180946 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Date: Wed, 2 Mar 2011 17:55:06 +0000
Subject: [PATCH 1/2] drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes a problem where on low VRAM cards we'd run out of space for validation.

[airlied: Tested on my M7, Thinkpad T42, compiz works with no problems.]

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Cc: stable@kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/652934

(cherry-picked from e376573f7267390f4e1bdc552564b6fb913bce76)
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_object.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index f1da370..f23a199 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -109,16 +109,22 @@ int radeon_bo_create(struct radeon_device *rdev, struct drm_gem_object *gobj,
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
@@ -310,6 +316,7 @@ int radeon_bo_list_validate(struct list_head *head)
 {
 	struct radeon_bo_list *lobj;
 	struct radeon_bo *bo;
+	u32 domain;
 	int r;

 	r = radeon_bo_list_reserve(head);
@@ -319,17 +326,19 @@ int radeon_bo_list_validate(struct list_head *head)
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
1.7.0.4

