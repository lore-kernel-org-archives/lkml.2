Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab2BJWmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2BJWmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:16 -0500
MIME-Version: 1.0
Message-Id: <20120210222947.819521593@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [patch 31/86] drm/radeon: Set DESKTOP_HEIGHT register to the framebuffer (not mode) height.
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit 1b61925061660009f5b8047f93c5297e04541273 upstream.

The value of this register is transferred to the V_COUNTER register at the
beginning of vertical blank. V_COUNTER is the reference for VLINE waits and
goes from VIEWPORT_Y_START to VIEWPORT_Y_START+VIEWPORT_HEIGHT during scanout,
so if VIEWPORT_Y_START is not 0, V_COUNTER actually went backwards at the
beginning of vertical blank, and VLINE waits excluding the whole scanout area
could never finish (possibly only if VIEWPORT_Y_START is larger than the length
of vertical blank in scanlines). Setting DESKTOP_HEIGHT to the framebuffer
height should prevent this for any kind of VLINE wait.

Fixes https://bugs.freedesktop.org/show_bug.cgi?id=45329 .

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -1189,7 +1189,7 @@ static int dce4_crtc_do_set_base(struct
 	WREG32(EVERGREEN_GRPH_ENABLE + radeon_crtc->crtc_offset, 1);
 
 	WREG32(EVERGREEN_DESKTOP_HEIGHT + radeon_crtc->crtc_offset,
-	       crtc->mode.vdisplay);
+	       target_fb->height);
 	x &= ~3;
 	y &= ~1;
 	WREG32(EVERGREEN_VIEWPORT_START + radeon_crtc->crtc_offset,
@@ -1358,7 +1358,7 @@ static int avivo_crtc_do_set_base(struct
 	WREG32(AVIVO_D1GRPH_ENABLE + radeon_crtc->crtc_offset, 1);
 
 	WREG32(AVIVO_D1MODE_DESKTOP_HEIGHT + radeon_crtc->crtc_offset,
-	       crtc->mode.vdisplay);
+	       target_fb->height);
 	x &= ~3;
 	y &= ~1;
 	WREG32(AVIVO_D1MODE_VIEWPORT_START + radeon_crtc->crtc_offset,


