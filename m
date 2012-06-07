Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032Ab2FGEld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:41:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab2FGES7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:59 -0400
Message-Id: <20120607040343.165833992@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:23 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Burian <michael.burian@sbg.at>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 47/82] drm/radeon: fix regression in UMS CS ioctl
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9b00147d9f2ba137ce74b66b768a8312be0b6781 upstream.

radeon_cs_parser_init is called by both the legacy UMS
CS ioctl and the KMS CS ioctl.  Protect KMS specific
pieces of the code by checking that rdev is not NULL.

Reported-by: Michael Burian <michael.burian@sbg.at>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -158,6 +158,7 @@ static int radeon_cs_sync_rings(struct r
 	return 0;
 }
 
+/* XXX: note that this is called from the legacy UMS CS ioctl as well */
 int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 {
 	struct drm_radeon_cs *cs = data;
@@ -252,23 +253,25 @@ int radeon_cs_parser_init(struct radeon_
 		}
 	}
 
-	if ((p->cs_flags & RADEON_CS_USE_VM) &&
-	    !p->rdev->vm_manager.enabled) {
-		DRM_ERROR("VM not active on asic!\n");
-		return -EINVAL;
-	}
+	/* these are KMS only */
+	if (p->rdev) {
+		if ((p->cs_flags & RADEON_CS_USE_VM) &&
+		    !p->rdev->vm_manager.enabled) {
+			DRM_ERROR("VM not active on asic!\n");
+			return -EINVAL;
+		}
+
+		/* we only support VM on SI+ */
+		if ((p->rdev->family >= CHIP_TAHITI) &&
+		    ((p->cs_flags & RADEON_CS_USE_VM) == 0)) {
+			DRM_ERROR("VM required on SI+!\n");
+			return -EINVAL;
+		}
 
-	/* we only support VM on SI+ */
-	if ((p->rdev->family >= CHIP_TAHITI) &&
-	    ((p->cs_flags & RADEON_CS_USE_VM) == 0)) {
-		DRM_ERROR("VM required on SI+!\n");
-		return -EINVAL;
+		if (radeon_cs_get_ring(p, ring, priority))
+			return -EINVAL;
 	}
 
-	if (radeon_cs_get_ring(p, ring, priority))
-		return -EINVAL;
-
-
 	/* deal with non-vm */
 	if ((p->chunk_ib_idx != -1) &&
 	    ((p->cs_flags & RADEON_CS_USE_VM) == 0) &&


