Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab1LGQXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab1LGQXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.450451332@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:59 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [057/104] drm/radeon/kms: add some loop timeouts in pageflip code
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f64964796dedca340608fb1075ab6baad5625851 upstream.

Avoid infinite loops waiting for surface updates if a GPU
reset happens while waiting for a page flip.

See:
https://bugs.freedesktop.org/show_bug.cgi?id=43191

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Tested-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    7 ++++++-
 drivers/gpu/drm/radeon/r100.c      |    7 ++++++-
 drivers/gpu/drm/radeon/rs600.c     |    7 ++++++-
 drivers/gpu/drm/radeon/rv770.c     |    7 ++++++-
 4 files changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -82,6 +82,7 @@ u32 evergreen_page_flip(struct radeon_de
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc_id];
 	u32 tmp = RREG32(EVERGREEN_GRPH_UPDATE + radeon_crtc->crtc_offset);
+	int i;
 
 	/* Lock the graphics update lock */
 	tmp |= EVERGREEN_GRPH_UPDATE_LOCK;
@@ -99,7 +100,11 @@ u32 evergreen_page_flip(struct radeon_de
 	       (u32)crtc_base);
 
 	/* Wait for update_pending to go high. */
-	while (!(RREG32(EVERGREEN_GRPH_UPDATE + radeon_crtc->crtc_offset) & EVERGREEN_GRPH_SURFACE_UPDATE_PENDING));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(EVERGREEN_GRPH_UPDATE + radeon_crtc->crtc_offset) & EVERGREEN_GRPH_SURFACE_UPDATE_PENDING)
+			break;
+		udelay(1);
+	}
 	DRM_DEBUG("Update pending now high. Unlocking vupdate_lock.\n");
 
 	/* Unlock the lock, so double-buffering can take place inside vblank */
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -84,13 +84,18 @@ u32 r100_page_flip(struct radeon_device
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc_id];
 	u32 tmp = ((u32)crtc_base) | RADEON_CRTC_OFFSET__OFFSET_LOCK;
+	int i;
 
 	/* Lock the graphics update lock */
 	/* update the scanout addresses */
 	WREG32(RADEON_CRTC_OFFSET + radeon_crtc->crtc_offset, tmp);
 
 	/* Wait for update_pending to go high. */
-	while (!(RREG32(RADEON_CRTC_OFFSET + radeon_crtc->crtc_offset) & RADEON_CRTC_OFFSET__GUI_TRIG_OFFSET));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(RADEON_CRTC_OFFSET + radeon_crtc->crtc_offset) & RADEON_CRTC_OFFSET__GUI_TRIG_OFFSET)
+			break;
+		udelay(1);
+	}
 	DRM_DEBUG("Update pending now high. Unlocking vupdate_lock.\n");
 
 	/* Unlock the lock, so double-buffering can take place inside vblank */
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -62,6 +62,7 @@ u32 rs600_page_flip(struct radeon_device
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc_id];
 	u32 tmp = RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset);
+	int i;
 
 	/* Lock the graphics update lock */
 	tmp |= AVIVO_D1GRPH_UPDATE_LOCK;
@@ -74,7 +75,11 @@ u32 rs600_page_flip(struct radeon_device
 	       (u32)crtc_base);
 
 	/* Wait for update_pending to go high. */
-	while (!(RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset) & AVIVO_D1GRPH_SURFACE_UPDATE_PENDING));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset) & AVIVO_D1GRPH_SURFACE_UPDATE_PENDING)
+			break;
+		udelay(1);
+	}
 	DRM_DEBUG("Update pending now high. Unlocking vupdate_lock.\n");
 
 	/* Unlock the lock, so double-buffering can take place inside vblank */
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -47,6 +47,7 @@ u32 rv770_page_flip(struct radeon_device
 {
 	struct radeon_crtc *radeon_crtc = rdev->mode_info.crtcs[crtc_id];
 	u32 tmp = RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset);
+	int i;
 
 	/* Lock the graphics update lock */
 	tmp |= AVIVO_D1GRPH_UPDATE_LOCK;
@@ -66,7 +67,11 @@ u32 rv770_page_flip(struct radeon_device
 	       (u32)crtc_base);
 
 	/* Wait for update_pending to go high. */
-	while (!(RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset) & AVIVO_D1GRPH_SURFACE_UPDATE_PENDING));
+	for (i = 0; i < rdev->usec_timeout; i++) {
+		if (RREG32(AVIVO_D1GRPH_UPDATE + radeon_crtc->crtc_offset) & AVIVO_D1GRPH_SURFACE_UPDATE_PENDING)
+			break;
+		udelay(1);
+	}
 	DRM_DEBUG("Update pending now high. Unlocking vupdate_lock.\n");
 
 	/* Unlock the lock, so double-buffering can take place inside vblank */


