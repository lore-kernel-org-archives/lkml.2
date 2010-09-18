Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0IRTF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:05:26 -0400
Received: from kroah.org ([198.145.64.141]:51941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806Ab0IRTCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:32 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:03 2010
Message-Id: <20100918190003.281128941@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [122/123] drm/i915: Prevent double dpms on
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=drm-i915-prevent-double-dpms-on.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 032d2a0d068b0368296a56469761394ef03207c3 upstream.

Arguably this is a bug in drm-core in that we should not be called twice
in succession with DPMS_ON, however this is still occuring and we see
FDI link training failures on the second call leading to the occassional
blank display. For the time being ignore the repeated call.

Original patch by Dave Airlie <airlied@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1954,6 +1954,9 @@ static void intel_crtc_dpms(struct drm_c
 	int pipe = intel_crtc->pipe;
 	bool enabled;
 
+	if (intel_crtc->dpms_mode == mode)
+		return;
+
 	dev_priv->display.dpms(crtc, mode);
 
 	intel_crtc->dpms_mode = mode;
@@ -4000,7 +4003,7 @@ static void intel_crtc_init(struct drm_d
 	}
 
 	intel_crtc->cursor_addr = 0;
-	intel_crtc->dpms_mode = DRM_MODE_DPMS_OFF;
+	intel_crtc->dpms_mode = -1;
 	drm_crtc_helper_add(&intel_crtc->base, &intel_helper_funcs);
 
 	intel_crtc->busy = false;


