Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0LHBC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:28 -0500
Received: from kroah.org ([198.145.64.141]:33456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab0LHBCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:25 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:39 2010
Message-Id: <20101208005739.175789688@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [177/289] drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>

commit 2b66b50b12cabc05f05543e792d4c9c2465d5702 upstream.

If ttm_bo_init() returns failure, it already destroyed the BO, so we need to
retry from scratch.

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_object.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
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


