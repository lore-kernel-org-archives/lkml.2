Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0LLXrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab0LLXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:15 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: daenzer@vmware.com, daenzer@vmware.com, daenzer@vmware.com,
        markus@trippelsdorf.de, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [132/223] drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
Message-Id: <20101212234714.4FA9FB27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>

commit 2b66b50b12cabc05f05543e792d4c9c2465d5702 upstream.

If ttm_bo_init() returns failure, it already destroyed the BO, so we need to
retry from scratch.

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_object.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/gpu/drm/radeon/radeon_object.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_object.c
+++ linux/drivers/gpu/drm/radeon/radeon_object.c
@@ -102,6 +102,8 @@ int radeon_bo_create(struct radeon_devic
 		type = ttm_bo_type_device;
 	}
 	*bo_ptr = NULL;
+
+retry:
 	bo = kzalloc(sizeof(struct radeon_bo), GFP_KERNEL);
 	if (bo == NULL)
 		return -ENOMEM;
@@ -109,8 +111,6 @@ int radeon_bo_create(struct radeon_devic
 	bo->gobj = gobj;
 	bo->surface_reg = -1;
 	INIT_LIST_HEAD(&bo->list);
-
-retry:
 	radeon_ttm_placement_from_domain(bo, domain);
 	/* Kernel allocation are uninterruptible */
 	mutex_lock(&rdev->vram_mutex);
