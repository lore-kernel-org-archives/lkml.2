Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab0HFSht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:37:49 -0400
Received: from kroah.org ([198.145.64.141]:48738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964956Ab0HFSgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:36:10 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:03 2010
Message-Id: <20100806183203.063961113@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [34/38] drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michel Dänzer <daenzer@vmware.com>

commit e376573f7267390f4e1bdc552564b6fb913bce76 upstream.

This fixes a problem where on low VRAM cards we'd run out of space for validation.

[airlied: Tested on my M7, Thinkpad T42, compiz works with no problems.]

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_object.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -110,6 +110,7 @@ int radeon_bo_create(struct radeon_devic
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
 
+retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);
@@ -118,10 +119,15 @@ int radeon_bo_create(struct radeon_devic
 			&radeon_ttm_bo_destroy);
 	mutex_unlock(&rdev->vram_mutex);
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
@@ -321,6 +327,7 @@ int radeon_bo_list_validate(struct list_
 {
 	struct radeon_bo_list *lobj;
 	struct radeon_bo *bo;
+	u32 domain;
 	int r;
 
 	list_for_each_entry(lobj, head, list) {
@@ -333,17 +340,19 @@ int radeon_bo_list_validate(struct list_
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
 						true, false, false);
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


