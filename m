Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0IXQ33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:29:29 -0400
Received: from kroah.org ([198.145.64.141]:38630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab0IXQ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:29:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.802877431@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:25:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [79/80] drm/i915: Ensure that the crtcinfo is populated during mode_fixup()
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 897493504addc5609f04a2c4f73c37ab972c29b2 upstream.

This should fix the mysterious mode setting failures reported during
boot up and after resume, generally for i8xx class machines.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=16478
Reported-and-tested-by: Xavier Chantry <chantry.xavier@gmail.com>
Buzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29413
Tested-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2376,11 +2376,19 @@ static bool intel_crtc_mode_fixup(struct
 				  struct drm_display_mode *adjusted_mode)
 {
 	struct drm_device *dev = crtc->dev;
+
 	if (HAS_PCH_SPLIT(dev)) {
 		/* FDI link clock is fixed at 2.7G */
 		if (mode->clock * 3 > 27000 * 4)
 			return MODE_CLOCK_HIGH;
 	}
+
+	/* XXX some encoders set the crtcinfo, others don't.
+	 * Obviously we need some form of conflict resolution here...
+	 */
+	if (adjusted_mode->crtc_htotal == 0)
+		drm_mode_set_crtcinfo(adjusted_mode, 0);
+
 	return true;
 }
 


