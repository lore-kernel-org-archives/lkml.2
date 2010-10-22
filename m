Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0JVTUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:20:47 -0400
Received: from kroah.org ([198.145.64.141]:33981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759238Ab0JVS4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.119456088@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [020/103] drm/radeon/kms: avivo cursor workaround applies to evergreen as well
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 6a2a11dbea5db417d200d38dda53c30a2e5603e0 upstream.

Fixes cursor corruption in certain cases.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_cursor.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cursor.c
+++ b/drivers/gpu/drm/radeon/radeon_cursor.c
@@ -203,6 +203,7 @@ int radeon_crtc_cursor_move(struct drm_c
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 	struct radeon_device *rdev = crtc->dev->dev_private;
 	int xorigin = 0, yorigin = 0;
+	int w = radeon_crtc->cursor_width;
 
 	if (x < 0)
 		xorigin = -x + 1;
@@ -213,22 +214,7 @@ int radeon_crtc_cursor_move(struct drm_c
 	if (yorigin >= CURSOR_HEIGHT)
 		yorigin = CURSOR_HEIGHT - 1;
 
-	radeon_lock_cursor(crtc, true);
-	if (ASIC_IS_DCE4(rdev)) {
-		/* cursors are offset into the total surface */
-		x += crtc->x;
-		y += crtc->y;
-		DRM_DEBUG("x %d y %d c->x %d c->y %d\n", x, y, crtc->x, crtc->y);
-
-		/* XXX: check if evergreen has the same issues as avivo chips */
-		WREG32(EVERGREEN_CUR_POSITION + radeon_crtc->crtc_offset,
-		       ((xorigin ? 0 : x) << 16) |
-		       (yorigin ? 0 : y));
-		WREG32(EVERGREEN_CUR_HOT_SPOT + radeon_crtc->crtc_offset, (xorigin << 16) | yorigin);
-		WREG32(EVERGREEN_CUR_SIZE + radeon_crtc->crtc_offset,
-		       ((radeon_crtc->cursor_width - 1) << 16) | (radeon_crtc->cursor_height - 1));
-	} else if (ASIC_IS_AVIVO(rdev)) {
-		int w = radeon_crtc->cursor_width;
+	if (ASIC_IS_AVIVO(rdev)) {
 		int i = 0;
 		struct drm_crtc *crtc_p;
 
@@ -260,7 +246,17 @@ int radeon_crtc_cursor_move(struct drm_c
 			if (w <= 0)
 				w = 1;
 		}
+	}
 
+	radeon_lock_cursor(crtc, true);
+	if (ASIC_IS_DCE4(rdev)) {
+		WREG32(EVERGREEN_CUR_POSITION + radeon_crtc->crtc_offset,
+		       ((xorigin ? 0 : x) << 16) |
+		       (yorigin ? 0 : y));
+		WREG32(EVERGREEN_CUR_HOT_SPOT + radeon_crtc->crtc_offset, (xorigin << 16) | yorigin);
+		WREG32(EVERGREEN_CUR_SIZE + radeon_crtc->crtc_offset,
+		       ((w - 1) << 16) | (radeon_crtc->cursor_height - 1));
+	} else if (ASIC_IS_AVIVO(rdev)) {
 		WREG32(AVIVO_D1CUR_POSITION + radeon_crtc->crtc_offset,
 			     ((xorigin ? 0 : x) << 16) |
 			     (yorigin ? 0 : y));


