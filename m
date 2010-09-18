Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0IRTQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:51 -0400
Received: from kroah.org ([198.145.64.141]:43998 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab0IRTQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:41 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:08 2010
Message-Id: <20100918191308.334221972@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [129/129] drm: Only decouple the old_fb from the crtc is we call mode_set*
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 356ad3cd616185631235ffb48b3efbf39f9923b3 upstream.

Otherwise when disabling the output we switch to the new fb (which is
likely NULL) and skip the call to mode_set -- leaking driver private
state on the old_fb.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29857
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_crtc_helper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -610,13 +610,13 @@ int drm_crtc_helper_set_config(struct dr
 		mode_changed = true;
 
 	if (mode_changed) {
-		old_fb = set->crtc->fb;
-		set->crtc->fb = set->fb;
 		set->crtc->enabled = (set->mode != NULL);
 		if (set->mode != NULL) {
 			DRM_DEBUG_KMS("attempting to set mode from"
 					" userspace\n");
 			drm_mode_debug_printmodeline(set->mode);
+			old_fb = set->crtc->fb;
+			set->crtc->fb = set->fb;
 			if (!drm_crtc_helper_set_mode(set->crtc, set->mode,
 						      set->x, set->y,
 						      old_fb)) {


