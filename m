Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031091Ab2I1TU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:20:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab2I1TE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 208/262] drm/i915: Reduce a pin-leak BUG into a WARN
Date: Fri, 28 Sep 2012 11:52:17 -0700
Message-Id: <20120928183022.681377051@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7e81a42e341a4f15d76624b7c02ffb21b085b56f upstream.

Pin-leaks persist and we get the perennial bug reports of machine
lockups to the BUG_ON(pin_count==MAX). If we instead loudly report that
the object cannot be pinned at that time it should prevent the driver from
locking up, and hopefully restore a semblance of working whilst still
leaving us a OOPS to debug.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3044,7 +3044,8 @@ i915_gem_object_pin(struct drm_i915_gem_
 {
 	int ret;
 
-	BUG_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT);
+	if (WARN_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT))
+		return -EBUSY;
 
 	if (obj->gtt_space != NULL) {
 		if ((alignment && obj->gtt_offset & (alignment - 1)) ||


