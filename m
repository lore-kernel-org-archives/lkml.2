Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2ILXcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:32:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2ILXcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 046/108] Revert "drm/radeon: fix bo creation retry path"
Date: Wed, 12 Sep 2012 16:28:44 -0700
Message-Id: <20120912232455.357472620@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 676bc2e1e4f9072f7a640d5b7c99ffdf9709a6e7 upstream.

This reverts commit d1c7871ddb1f588b8eb35affd9ee1a3d5e11cd0c.

ttm_bo_init() destroys the BO on failure. So this patch makes
the retry path work with freed memory.  This ends up causing
kernel panics when this path is hit.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_object.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -138,6 +138,7 @@ int radeon_bo_create(struct radeon_devic
 	acc_size = ttm_bo_dma_acc_size(&rdev->mman.bdev, size,
 				       sizeof(struct radeon_bo));
 
+retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -151,8 +152,6 @@ int radeon_bo_create(struct radeon_devic
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
 	INIT_LIST_HEAD(&bo->va);
-
-retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);


